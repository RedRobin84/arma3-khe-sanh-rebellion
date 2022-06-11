_executeTime = 600; // 600 seconds, aka 10 minutes.
defcon = 0;
manpower = 0;
maxSoldiersMultiplier = 4;
NUMBER_OF_ATTACK_SPAWN_POINTS = 3;

totalTicks = 3;

//War level enum
defConSix = 6;
defConFive = 5;
defConFour = 4;
defConThree = 3;
defConTwo = 2;

0 spawn {
    call makeAllSpawnPointMarkersInvisible;
    call initWinConditionForSectorsEventHandlers;
    sleep 1;
    call REB_fnc_initGUI;
    sleep 5;
    "Capture all settlements to win. The main objective is Nabo Camp military outpost." call displayTask;
    _totalPOVL = call REB_fnc_calculateTotalPOVL;
    _totalPOVL call populateEnemySectors;
    sleep 5;
    "Capture ruins to the north" call displayTask;
    sleep 5;
    _totalPOVL call updateDefCon;
};

initWinConditionForSectorsEventHandlers = {
{
    [ _x, "ownerChanged", {
        params[ "_sector", "_owner", "_ownerOld" ];

        if ( _owner isEqualTo EAST ) then {
            call checkIfAllSectorsOwnedByEast;
        };
    }] call BIS_fnc_addScriptedEventHandler; 
}forEach ( true call BIS_fnc_moduleSector );
};

checkIfAllSectorsOwnedByEast = {
    _enemySectorNumber = west call BIS_fnc_moduleSector;
    diag_log(format["DEBUG::checkIfAllSectorsOwnedByEast: Number of owned WEST sectors: %1", _enemySectorNumber]);
    if (_enemySectorNumber == 0) then {
        ["end1", true, 20, true, false] call BIS_fnc_endMission;
    };
};

updateDefCon = {
    _totalPOVL = _this;
    defcon = _totalPOVL call calculateWarLevel;
    _msg = "DEFCON at level " + str(defcon);
    ["Warning", [_msg]] call BIS_fnc_showNotification;
};

calculateWarLevel = {
     _totalPOVL = _this;
    if (_totalPOVL < 2) exitWith {
        defConSix
    };
    if (_totalPOVL < 4) exitWith {
        defConFive
    };
    if (_totalPOVL < 6) exitWith {
        defConFour
    };
    if (_totalPOVL < 8) exitWith {
        defConThree
    };
    defConTwo
};

makeAllSpawnPointMarkersInvisible =  {
    {
    if (getMarkerType _x  == "mil_start" || getMarkerType _x  == "respawn_inf") 
    then { _x setMarkerAlpha 0;}    
    } forEach allMapMarkers
};

displayTask = {
    _message = _this;
    ["ScoreAdded", [_message]] call BIS_fnc_showNotification;
};

populateEnemySectors = {
    _totalPOVL = _this;
    _enemySectors = "west" call getSectorsOwnedByside;
    if (count(_enemySectors) == 0) exitwith {};
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
            _numberOfUnitsToSpawn = [_totalPOVL, _enemySector] call getNumberUnitsToSpawn;
            _maxEnemySectorStaticUnits = _enemySector getVariable["maxStatic", 0];
            _currentWarLevel = _totalPOVL call calculateWarLevel;
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
                _routeGroup = routeGroup select 0;
            };
            _i = 0;
            while {_i  < _numberOfUnitsToSpawn} do {
                _allUnoccupiedStaticspawnPointsinEnemySector = [_allStaticspawnPointsinEnemySector, {
                    count(_allEnemyunitsinSector inAreaArray _x) == 0
                }] call BIS_fnc_conditionalselect;
                _unoccupiedStaticUnitNumber = count(_allUnoccupiedStaticspawnPointsinEnemySector);
                _occupiedStaticUnitNumber = _numberOfEnemyunitsinSector - _unoccupiedStaticUnitNumber;
                if (_maxEnemySectorStaticUnits > _occupiedStaticUnitNumber && _unoccupiedStaticUnitNumber != 0) then {
                    _chosenspawnPoint = selectRandom _allUnoccupiedStaticspawnPointsinEnemySector;
                    _chosenspawnPointPos = getmarkerPos(_chosenspawnPoint);

                    _chosenspawnPointPos set [2, parseNumber(markertext _chosenspawnPoint)];
                    _unittype = "vn_b_men_sog_09";
                    diag_log(format ["DEBUG::populateEnemySectors: Creating unit %1 on spawn point %2 at sector %3", _unittype, _chosenspawnPoint, _enemySectorname]);
                    _group = createGroup west;
                    _group setBehaviour "SAFE";
                    _unit = _group createUnit [_Unittype, _chosenspawnPointPos, [], 0, "NONE"];
                    _unit setPosATL [_chosenspawnPointPos select 0, _chosenspawnPointPos select 1, _chosenspawnPointPos select 2];
                    _chosenspawnPointdirection = markerDir _chosenspawnPoint;
                    _unit setDir _chosenspawnPointdirection;
                    _unit setFormDir _chosenspawnPointdirection;
                    _unit setCombatBehaviour "SAFE";
                    _allEnemyunitsinSector pushBack _unit;
                    _i = _i + 1;
                };
                if (_i < _numberOfUnitsToSpawn && _currentWarLevel <= defConFive) then {
                    _sectorRouteSpawnPointName = _enemySectorname + "_route0";
                    _sectorRouteSpawnPointPos = getmarkerPos(_sectorRouteSpawnPointName);
                    _sectorRouteSpawnPointPos set [2, parseNumber(markertext _sectorRouteSpawnPointName)];
                    _routeUnitType = "vn_b_men_sog_09";
                    diag_log(format["DEBUG::populateEnemySectors: Creating route unit %1 at sector %2", _routeUnitType, _enemySectorname]);
                    _routeUnit = _routeGroup createUnit [_routeUnitType, _sectorRouteSpawnPointPos, [], 0, "NONE"];
                    _i = _i + 1;
                };
        };
    };
    } forEach _enemySectors;
};

getNumberUnitsToSpawn = {
params["_totalPOVL", "_enemySector"];
_sectorValue = _enemySector call getSectorValue;
_minEnemySectorunits = _enemySector getVariable["min", _sectorValue];
if (_minEnemySectorunits > _totalPOVL) then {
    _minEnemySectorunits = _totalPOVL;
};
_difference = _minEnemySectorunits - _numberOfEnemyunitsinSector;
//RETURN
if (_difference > 0) then [{_difference}, {0}];
};

getDefaultMaxSoldiers = {
    _sector = _this;
    _sectorValue = _sector call getSectorValue;
    //RETURN
    (parseNumber(_sectorValue) * maxSoldiersMultiplier)
};

getSectorValue = {
    _sector = _this;
    //RETURN
    (_sector getVariable ["scoreReward", 0])
};

markerNotExist = {
    _position = _this;
    (_position select 0) == 0 && (_position select 1) == 0 && (_position select 2) == 0
};

getSectorsOwnedBySide = {
    _sideName = _this;
    _allSectors = true call BIS_fnc_moduleSector;
    _sideSectors = [_allSectors, { str(_x getVariable "owner") == _sideName }] call BIS_fnc_conditionalSelect;
    _sideSectorsCount = count(_sideSectors);
    if (_sideSectorsCount == 0) exitwith {
        diag_log(format["DEBUG::getSectorsOwnedBySide: No sector owned by %1 found. Exiting.", _sideName]);
        //RETURN
        []
        };
     diag_log(format["DEBUG::getSectorsOwnedBySide: Found %1 sector(s) owned by %2", _sideSectorsCount, _sideName]);
    //RETURN
    _sideSectors
};

recruitUnit = {
    if (manpower < 1) exitWith { hint "Not enough manpower."; };
    _randomUnitId = str(floor(random 32) + 1);
    if (parseNumber _randomUnitId < 10) then {
        _randomUnitId = "0" + _randomUnitId;
    };
    diag_log(format["DEBUG::recruitUnit: Random recruit ID: %1", _randomUnitId]);
    _myUnitName = "vn_c_men_" + _randomUnitId;
    _myUnitName createUnit [position player, group player, "removeAllAssignedItems this; this call addActionStayHere; this call addRemoveAllActionsFromCorpseHandler"];

    call decreaseManpower;
};

decreaseManpower = {
    if (manpower > 0) then {
        manpower = manpower - 1;
    };
    call REB_fnc_updateManpowerGUI;
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
_totalPOVL = _this;
_allSectors = true call BIS_fnc_moduleSector;
_ownedSectors = [_allSectors, { str(_x getVariable "owner") == "EAST" }] call BIS_fnc_conditionalSelect;
if (count _ownedSectors == 0) exitwith {
    diag_log("INFO::attackRandomSettlement: No sectors owned by EAST. Exiting.");
    }; //TODO: replace with getSectorsOwnedBySide
_randomOwnedSector = selectRandom _ownedSectors;
_randomOwnedSectorName = _randomOwnedSector call BIS_fnc_objectVar;
_randomOwnedSectorPos = getPos _randomOwnedSector;
diag_log(format["INFO::attackRandomSettlement: Creating attack on POI %1 at position %2", _randomOwnedSectorName, _randomOwnedSectorPos]);
[_totalPOVL, _randomOwnedSectorName, _randomOwnedSectorPos] call distributeAttackInGroups;

warningMsg = "Enemy is attacking " + _randomOwnedSectorName;
[warningMsg, 1] call BIS_fnc_3DENNotification;
["Warning", [warningMsg]] call BIS_fnc_showNotification;
_totalPOVL call updateDefCon;
totalTicks = 0;
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
    if (surfaceIsWater _randomSpawnPointNamePos) then {
       _grp = [_randomSpawnPointNamePos, _soldiersPerGroup] call createEnemyInfantryBoatGroup;
      [_grp, _randomOwnedSectorName, _randomOwnedSectorPos] call doNavalAttack;
    } else {
       _grp = [_randomSpawnPointNamePos, _soldiersPerGroup] call createEnemyInfantryGroup;
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

INFANTRY_UNITS = [
    "vn_b_men_sog_09",0.5, "vn_b_men_sog_10",0.4,"vn_b_men_sog_04",0.1 //random like in recruitUnit instead of an array
];

createEnemyInfantryGroup = {
    params["_randomSpawnPointNamePos", "_soldiersPerGroup"];
    _grp = createGroup [west,true];
    for "_i" from 1 to _soldiersPerGroup do {
        selectRandomWeighted INFANTRY_UNITS createUnit [_randomSpawnPointNamePos, _grp];
    };
    _grp;
};

MAX_NUMBER_OF_BOAT_CREW = 5;

createEnemyInfantryBoatGroup = {
    params["_randomSpawnPointNamePos", "_soldiersPerGroup"];
    _grp = createGroup [west,true];
    _boatCrewNr = if (_soldiersPerGroup > MAX_NUMBER_OF_BOAT_CREW) then [{MAX_NUMBER_OF_BOAT_CREW},{_soldiersPerGroup}];
    for "_i" from 1 to _boatCrewNr do {
        selectRandomWeighted INFANTRY_UNITS createUnit [_randomSpawnPointNamePos, _grp];
    };
    _grp;
};

updateManpower = {
_totalPOVL = _this;
 if ((manpower + _totalPOVL) > _totalPOVL) then {
     manpower = _totalPOVL;
     hint("Manpower limit reached. Capture more POI's to extend manpower capacity.");
 } else {
      manpower = manpower + _totalPOVL;
      hint("New volunteers have arrived.")
 };
 call REB_fnc_updateManpowerGUI;
};

showReport = {
    _totalPOVL = _this;
    strToDisplay = "Manpower: " + str (manpower) + " Influence: " + str (_totalPOVL);
    ["ScoreAdded", [strToDisplay]] call BIS_fnc_showNotification;
};

runPerTickScripts = {
    totalTicks = totalTicks + 1;
    _totalPOVL = call REB_fnc_calculateTotalPOVL;
    _totalPOVL call updateManpower;
    _totalPOVL call showReport;
    sleep 5;
    if ((totalTicks mod defcon) == 0) then {
        _totalPOVL call attackRandomSettlement;
    };
    _totalPOVL call populateEnemySectors;
};

realTickTime = 0; // declare the local variable for the loop compare.
 
while {true} do // loops for entire duration that mission/server is running.
{
    ticksBegin = round(diag_TickTime); // tick time begin.
    if (realTickTime >= _executeTime) then // check _realTickTime against executeTime.
    {
        call runPerTickScripts; // call the function.
        realTickTime = 0; // reset the timer back to 0 to allow counting to 300 again.
    };
    uiSleep 1; // sleep for one second.
    ticksEnd = round(diag_TickTime); // tick time end.
    ticksEndLoop = round(ticksEnd - ticksBegin); // get 'real' (rounded) tick time due to loop latency/calls.
    realTickTime = realTickTime + ticksEndLoop; // increase the tick counter.
};