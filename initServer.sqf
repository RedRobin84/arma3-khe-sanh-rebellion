//CONSTANTS
_executeTime = 600; // 600 seconds, aka 10 minutes.
MANPOWER_VAR_NAME = "manpower";
maxSoldiersMultiplier = 4;
NUMBER_OF_ATTACK_SPAWN_POINTS = 3;
SECTOR_MANPOWER_DEFAULT_DECREMENT = 1;
INTRO_INFO_MSG = "Capture all settlements to win. The main objective is Nabo Camp military outpost.";
INTRO_INFO_MSG2 = "Capture ruins to the north";
MAX_NUMBER_OF_BOAT_CREW = 5;

totalTicks = 3;
nextAttackedSectorName = "";
realTickTime = 0; // declare the local variable for the loop compare.

//BLUEFOR FACTIONS PREFIXES
BLUEFOR_SEAL = "vn_b_men_seal_";
BLUEFOR_ARVN = "vn_b_men_army_";
BLUEFOR_LRRP = "vn_b_men_lrrp_";
BLUEFOR_CIDG = "vn_b_men_cidg_";
BLUEFOR_SFOR = "vn_b_men_sf_";
BLUEFOR_SOG  = "vn_b_men_sog_";

//War level enum
DEFCON_SIX = 6;
DEFCON_FIVE = 5;
DEFCON_FOUR = 4;
DEFCON_THREE = 3;
DEFCON_TWO = 2;
DEFCON_ONE = 1;

//Message types (displayMessage fnc)
MSG_TYPE_SCORE_ADDED = "ScoreAdded";
MSG_TYPE_WARNING = "Warning";

0 spawn {
    call makeAllSpawnPointMarkersInvisible;
    call initWinConditionForSectorsEventHandlers;
    call REB_fnc_gameTickLoop;
    call addResumeGameLoopOnGameLoadHandler;
    sleep 1;
    call REB_fnc_initGUI;
    sleep 5;
    [INTRO_INFO_MSG, MSG_TYPE_SCORE_ADDED] call REB_fnc_displayMessage;
    _totalPOVL = call REB_fnc_calculateTotalPOVL;
    _totalPOVL call populateEnemySectors;
    sleep 5;
    [INTRO_INFO_MSG2, MSG_TYPE_SCORE_ADDED] call REB_fnc_displayMessage;
    sleep 5;
    _currentDefcon = _totalPOVL call REB_fnc_calculateDefCon;
    _currentDefcon call REB_fnc_displayCurrentDefCon;
};

initWinConditionForSectorsEventHandlers = {
{
    [ _x, "ownerChanged", {
        params[ "_sector", "_owner", "_ownerOld" ];
         _enemySectorName = _sector call BIS_fnc_objectVar;
        _manpowerMarker = _enemySectorName + "_manpowerMarker";
        if ( _owner isEqualTo EAST ) then {
            call checkIfAllSectorsOwnedByEast;
            _manpowerMarker setMarkerAlpha 100;
        };
        if ( _owner isEqualTo WEST ) then {
            _manpowerMarker setMarkerAlpha 0;
            _sector call REB_fnc_resetSectorManpower;
        };
    }] call BIS_fnc_addScriptedEventHandler; 
}forEach (call REB_fnc_getAllSectors);
};

addResumeGameLoopOnGameLoadHandler = {
addMissionEventHandler ["Loaded", {
    params ["_saveType"];
    
    call REB_fnc_gameTickLoop;
}];
};

checkIfAllSectorsOwnedByEast = {
    _enemySectorNumber = west call BIS_fnc_moduleSector;
    diag_log(format["DEBUG::checkIfAllSectorsOwnedByEast: Number of owned WEST sectors: %1", _enemySectorNumber]);
    if (_enemySectorNumber == 0) then {
        ["end1", true, 20, true, false] call BIS_fnc_endMission;
    };
};

makeAllSpawnPointMarkersInvisible =  {
    {
    if (getMarkerType _x  == "mil_start" || getMarkerType _x  == "respawn_inf") 
    then { _x setMarkerAlpha 0;}    
    } forEach allMapMarkers
};

populateEnemySectors = {
    _totalPOVL = _this;
    _enemySectors = west call REB_fnc_getSectorsOwnedBySide;
    if (count(_enemySectors) == 0) exitwith {
        diag_log("ERROR::populateEnemySectors: No enemy sectors found. The game should be finished already.");
    };
    {
        _enemySector = _x;
        _enemySectorname = _enemySector call BIS_fnc_objectVar;
        _maxEnemySectorunits = _enemySector getVariable["max", (_enemySector call getDefaultMaxSoldiers)];
        if (_maxEnemySectorunits == 0) then {
            diag_log(format ["WARN::populateEnemySectors: max units not set for sector %1", _enemySectorname]);
        };
        _enemySectorspawnAreaMarkername = _enemySectorname + "_spawn";
        _enemySectorspawnAreamarkerPos = getmarkerPos(_enemySectorspawnAreaMarkername);
        if (_enemySectorspawnAreamarkerPos call markerNotExist) exitwith {
            diag_log(format ["ERROR::populateEnemySectors: spawn marker not found for sector %1", _enemySectorname]);
        };
        _allunitsinEnemySector = allunits inAreaArray _enemySectorspawnAreaMarkername;
        _allEnemyunitsinSector = [_allunitsinEnemySector, {
            side _x == west
        }] call BIS_fnc_conditionalselect;
        _numberOfEnemyunitsinSector = count(_allEnemyunitsinSector);
        if ((_numberOfEnemyunitsinSector < _maxEnemySectorunits) && !(player inArea _enemySectorspawnAreaMarkername)) then {
            _allStaticspawnPointsinEnemySector = allMapMarkers select {
                ((getmarkerPos _x) inArea _enemySectorspawnAreaMarkername) && ((getmarkertype _x) == "respawn_inf")
            };
            if (count(_allStaticspawnPointsinEnemySector) == 0) exitwith {
                diag_log(format ["ERROR::populateEnemySectors: No spawn points set for sector %1", _enemySectorname]);
            };
            _numberOfUnitsToSpawn = [_enemySector, _numberOfEnemyunitsinSector] call getNumberUnitsToSpawn;
            _maxEnemySectorStaticUnits = _enemySector getVariable["maxStatic", 0];
            _currentDefConLevel = _totalPOVL call REB_fnc_calculateDefCon;
            _routeGroupName = _enemySectorName + "_route_group";
            _routeGroup = allGroups select { groupId _x == _routeGroupName };
            _routeGroupNumber = count(_routeGroup);
            if (_routeGroupNumber > 1) then {
                diag_log(format ["ERROR::populateEnemySectors: More than one route groups found for sector %1", _enemySectorName]);
            };
            if (_routeGroupNumber == 0) then {
                _routeGroup = createGroup[west, false];
                _routeGroup setGroupId[_routeGroupName];
                _routeGroup setBehaviour "SAFE";
                _routeWaypointNumber = _enemySector getVariable["waypoints", 0];
                for [{_i = 0},{ _i < _routeWaypointNumber},{ _i = _i + 1}] do {
                    _routeWPMarkerName = _enemySectorName + "_route" + str(_i);
                    _routeWPPos = getMarkerPos(_routeWPMarkerName);
                    _wp = _routeGroup addWaypoint[_routeWPPos, 0];
                    _wp setWaypointType (markerText _routeWPMarkerName);
                    _wp setWaypointBehaviour "SAFE";
                    _wp setWaypointSpeed "LIMITED";
                };
            } else {
                _routeGroup = _routeGroup select 0;
            };
            _unitFaction = _currentDefConLevel call REB_fnc_getBLUEFORdefenseFactionBasedOnDefConLevel;
            _i = 0;
            while {_i  < _numberOfUnitsToSpawn} do {
                _allUnoccupiedStaticspawnPointsinEnemySector = [_allStaticspawnPointsinEnemySector, {
                    count(_allEnemyunitsinSector inAreaArray _x) == 0
                }] call BIS_fnc_conditionalselect;
                _unoccupiedStaticUnitNumber = count(_allUnoccupiedStaticspawnPointsinEnemySector);
                _occupiedStaticUnitNumber = _numberOfEnemyunitsinSector - _unoccupiedStaticUnitNumber;
                _unitType = (_unitFaction + ((_unitFaction call REB_fnc_getBLUEFORfactionSoldierTypesCount) call REB_fnc_getRandomNumberWithLessThanTenZeroPrefix));
                if (_maxEnemySectorStaticUnits > _occupiedStaticUnitNumber && _unoccupiedStaticUnitNumber != 0) then {
                    _chosenspawnPoint = selectRandom _allUnoccupiedStaticspawnPointsinEnemySector;
                    _chosenspawnPointPos = getmarkerPos(_chosenspawnPoint);
                    _chosenspawnPointPos set [2, parseNumber(markertext _chosenspawnPoint)];
                    diag_log(format ["DEBUG::populateEnemySectors: Creating unit %1 on spawn point %2 at sector %3", _unitType, _chosenspawnPoint, _enemySectorname]);
                    _group = createGroup west;
                    _group setBehaviour "SAFE";
                    _unit = _group createUnit [_unitType, _chosenspawnPointPos, [], 0, "NONE"];
                    _unit setPosATL [_chosenspawnPointPos select 0, _chosenspawnPointPos select 1, _chosenspawnPointPos select 2];
                    _chosenspawnPointdirection = markerDir _chosenspawnPoint;
                    _unit setDir _chosenspawnPointdirection;
                    _unit setFormDir _chosenspawnPointdirection;
                    _unit setCombatBehaviour "SAFE";
                    [_unit, _unitFaction] call REB_fnc_setBLUEFORunitSkillBasedOnFaction;
                    _allEnemyunitsinSector pushBack _unit;
                    _i = _i + 1;
                };
                if (_i < _numberOfUnitsToSpawn && _currentDefConLevel <= DEFCON_FIVE) then {
                    _sectorRouteSpawnPointName = _enemySectorname + "_route0";
                    _sectorRouteSpawnPointPos = getmarkerPos(_sectorRouteSpawnPointName);
                    _sectorRouteSpawnPointPos set [2, parseNumber(markertext _sectorRouteSpawnPointName)];
                    diag_log(format["DEBUG::populateEnemySectors: Creating route unit %1 at sector %2", _unitType, _enemySectorname]);
                    _routeUnit = _routeGroup createUnit [_unitType, _sectorRouteSpawnPointPos, [], 0, "NONE"];
                    [_routeUnit, _unitFaction] call REB_fnc_setBLUEFORunitSkillBasedOnFaction;
                    _i = _i + 1;
                };
        };
    };
    } forEach _enemySectors;
};

getNumberUnitsToSpawn = {
params["_enemySector", "_numberOfEnemyunitsinSector"];
_sectorValue = _enemySector call REB_fnc_getSectorValue;
_minEnemySectorunits = _enemySector getVariable["min", _sectorValue];
_difference = _minEnemySectorunits - _numberOfEnemyunitsinSector;
//RETURN
if (_difference > 0) then [{_difference}, {0}];
};

getDefaultMaxSoldiers = {
    _sector = _this;
    _sectorValue = _sector call REB_fnc_getSectorValue;
    //RETURN
    (_sectorValue * maxSoldiersMultiplier)
};

markerNotExist = {
    _position = _this;
    (_position select 0) == 0 && (_position select 1) == 0 && (_position select 2) == 0
};

addRemoveAllActionsFromCorpseHandler = {
    params["_unit"];
    _unit addEventHandler ["Killed", {
        params ["_unit"];
        removeAllActions _unit;
    }];
};

addActionStayHere = {
    params["_unit"];
    _unit addAction["Stay here.", removeUnit, [_unit]];
};

removeUnit = {
    params["_unit"];
    [_unit] joinSilent grpNull;
    removeAllActions _unit;
    _unit addAction["Join me.", joinPlayer, [_unit]];
};

joinPlayer = {
    params["_unit"];
    removeAllActions _unit;
    _unit call addActionStayHere;
    [_unit] join (group player);
};

attackRandomSettlement = {
params["_totalPOVL", "_nextAttackedSector"];

_randomOwnedSectorName = _nextAttackedSector call BIS_fnc_objectVar;
_nextAttackedSectorPos = getPos _nextAttackedSector;
diag_log(format["INFO::attackRandomSettlement: Creating attack on POI %1 at position %2", _randomOwnedSectorName, _nextAttackedSectorPos]);
[_totalPOVL, _randomOwnedSectorName, _nextAttackedSectorPos] call distributeAttackInGroups;
};

getRandomEastSectorName = {
_ownedSectors = east call REB_fnc_getSectorsOwnedBySide;
if (count _ownedSectors == 0) exitwith {
    diag_log("INFO::getRandomEastSectorName: No sectors owned by EAST. Exiting.");
    //RETURN
    ""
    };
_randomOwnedSector = selectRandom _ownedSectors;
_randomOwnedSectorName = _randomOwnedSector call BIS_fnc_objectVar;
//RETURN
_randomOwnedSectorName
};

distributeAttackInGroups = {
params["_totalPOVL", "_randomOwnedSectorName", "_randomOwnedSectorPos"];
_nrOfAttackGroups = _totalPOVL call getNumberOfAttackGroups;
_sectorSpawnPointsArray = _randomOwnedSectorName call createSectorSpawnPointsArray;
for "_i" from 1 to _nrOfAttackGroups do {
    _randomlySelectedSpawnPoint = selectRandom _sectorSpawnPointsArray;
    _randomSpawnPointNamePos = getMarkerPos(_randomlySelectedSpawnPoint);
    diag_log(format["DEBUG::distributeAttackInGroups: Random spawn point selected: %1 at position %2", _randomlySelectedSpawnPoint, _randomSpawnPointNamePos]);
    _soldiersPerGroup = ceil(_totalPOVL / _nrOfAttackGroups);
    _currentDefConLevel = _totalPOVL call REB_fnc_calculateDefCon;
    _groupFaction = _currentDefConLevel call REB_fnc_getBLUEFORattackFactionBasedOnDefConLevel;
    if (surfaceIsWater _randomSpawnPointNamePos) then {
       _grp = [_randomSpawnPointNamePos, _soldiersPerGroup, _groupFaction] call createEnemyInfantryBoatGroup;
      [_grp, _randomOwnedSectorName, _randomOwnedSectorPos] call doNavalAttack;
    } else {
       _grp = [_randomSpawnPointNamePos, _soldiersPerGroup, _groupFaction] call createEnemyInfantryGroup;
      [_grp, _randomOwnedSectorPos] call doLandAttack;
    };
    _sectorSpawnPointsArray deleteAt (_sectorSpawnPointsArray find _randomlySelectedSpawnPoint);
};
};

createSectorSpawnPointsArray = {
    _sectorName = _this;
    _arrayOfSectorSpawnPoints = [];
    for "_i" from 0 to (NUMBER_OF_ATTACK_SPAWN_POINTS - 1) do {
        _arrayOfSectorSpawnPoints pushBack (_sectorName + str(_i)); 
    };
    //RETURN
    _arrayOfSectorSpawnPoints;
};

getNumberOfAttackGroups = {
    _totalPOVL = _this;
    _nrOfSoldiers = _totalPOVL;
    _nrOfSpawnPoints = NUMBER_OF_ATTACK_SPAWN_POINTS;
    _nrOfAttackGroups = ceil(_nrOfSoldiers / _nrOfSpawnPoints);
    diag_log(format["DEBUG::getNumberOfAttackGroups: _nrOfSoldiers: %1, _nrOfSpawnPoints: %2, _nrOfAttackGroups: %3 ", _totalPOVL, _nrOfSpawnPoints, _nrOfAttackGroups]);
    if (_nrOfAttackGroups > _nrOfSpawnPoints) exitWith {
            //RETURN
        _nrOfSpawnPoints
    };
    //ELSE RETURN
    _nrOfAttackGroups
};

doLandAttack = { 
params["_grp", "_randomOwnedSectorPos"];
diag_log(format["DEBUG::doLandAttack: With group: %1", _grp]);
captureWP = _grp addWaypoint [_randomOwnedSectorPos, 0];
captureWP setWaypointType "GUARD";
};

doNavalAttack = { 
params["_grp", "_randomOwnedSectorName", "_randomOwnedSectorPos"];
diag_log(format["DEBUG::doNavalAttack: With group: %1", _grp]);
_boat = "vn_o_boat_01_mg_03" createVehicle getPos(leader _grp);
{
    _x moveInAny _boat;
} forEach units _grp;
_coastWaypointName = _randomOwnedSectorName + "_coastWP";
_coastWaypointPos = getMarkerPos (_coastWaypointName);
if (_coastWaypointPos call markerNotExist) then {
    diag_log(format["WARN::doNavalAttack: Boat spawn arker %1 does not exist.", _coastWaypointName]);
};
unloadWP = _grp addWaypoint [_coastWaypointPos, 0];
unloadWP setWaypointType "GETOUT";
captureWP = _grp addWaypoint [_randomOwnedSectorPos, 0];
captureWP setWaypointType "GUARD";
};

createEnemyInfantryGroup = {
    params["_randomSpawnPointNamePos", "_soldiersPerGroup", "_groupFaction"];
    _grp = createGroup [west,true];
    for "_i" from 1 to _soldiersPerGroup do {
        _unitType = (_groupFaction + ((_groupFaction call REB_fnc_getBLUEFORfactionSoldierTypesCount) call REB_fnc_getRandomNumberWithLessThanTenZeroPrefix));
        _unitType createUnit [_randomSpawnPointNamePos, _grp, "[this, _groupFaction] call REB_fnc_setBLUEFORunitSkillBasedOnFaction;"];
    };
    _grp;
};

createEnemyInfantryBoatGroup = {
    params["_randomSpawnPointNamePos", "_soldiersPerGroup", "_groupFaction"];
    _grp = createGroup [west,true];
    _boatCrewNr = if (_soldiersPerGroup > MAX_NUMBER_OF_BOAT_CREW) then [{MAX_NUMBER_OF_BOAT_CREW},{_soldiersPerGroup}];
    for "_i" from 1 to _boatCrewNr do {
        _unitType = (_groupFaction + ((_groupFaction call REB_fnc_getBLUEFORfactionSoldierTypesCount) call REB_fnc_getRandomNumberWithLessThanTenZeroPrefix));
        _unitType createUnit [_randomSpawnPointNamePos, _grp, "[this, _groupFaction] call REB_fnc_setBLUEFORunitSkillBasedOnFaction"];
    };
    _grp;
};
