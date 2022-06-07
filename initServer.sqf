_executeTime = 600; // 600 seconds, aka 10 minutes.
defcon = 0;
manpower = 0;
maxSoldiersMultiplier = 4;

//AKA Influence
totalPOVL = 0;
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
    call initGUI;
    sleep 1;
    "Capture ruins to the north" call displayTask;
    sleep 2;
    call populateEnemySectors;
    sleep 2;
    "The main objective is Nabo Camp military outpost" call displayTask;
    sleep 5;
    call updateDefCon;
};

initWinConditionForSectorsEventHandlers = {
{
    [ _x, "ownerChanged", {
        params[ "_sector", "_owner", "_ownerOld" ];

        if ( _owner isEqualTo EAST ) then {
            call checkIfAllSectorsOwnedByEast;
            call calculateTotalPOVL;
        };
    }] call BIS_fnc_addScriptedEventHandler; 
}forEach ( true call BIS_fnc_moduleSector );
};

checkIfAllSectorsOwnedByEast = {
    _enemySectorNumber = west call BIS_fnc_moduleSector;
    systemChat("Number of owned WEST sectors " + str(_enemySectorNumber));
    if (_enemySectorNumber == 0) then {
        ["end1", true, 20, true, false] call BIS_fnc_endMission;
    };
};

updateDefCon = {
    defcon = call calculateWarLevel;
    _msg = "DEFCON at level " + str(defcon);
    ["Warning", [_msg]] call BIS_fnc_showNotification;
};

calculateWarLevel = {
    if (totalPOVL < 2) exitWith {
        defConSix
    };
    if (totalPOVL < 4) exitWith {
        defConFive
    };
    if (totalPOVL < 6) exitWith {
        defConFour
    };
    if (totalPOVL < 8) exitWith {
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
    _enemySectors = "west" call getSectorsOwnedByside;
    if (count(_enemySectors) == 0) exitwith {};
    {
        _enemySector = _x;
        _enemySectorname = _enemySector call BIS_fnc_objectVar;
        _maxEnemySectorunits = _enemySector getVariable["max", (_enemySector call getDefaultMaxSoldiers)];
        if (_maxEnemySectorunits == 0) then {
            diag_log(format ["WARN: max units not set for sector %1", _enemySectorname]);
        };
        _enemySectorspawnAreaMarkername = _enemySectorname + "_spawn";
        _enemySectorspawnAreamarkerPos = getmarkerPos(_enemySectorspawnAreaMarkername);
        if (_enemySectorspawnAreamarkerPos call markernotExist) exitwith {
            diag_log(format ["ERROR: spawn marker not found for sector %1", _enemySectorname]);
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
                diag_log(format ["ERROR: No spawn points set for sector %1", _enemySectorname]);
            };
            _minEnemySectorunits = _enemySector getVariable["min", (_enemySector call getSectorValue)];
            _maxEnemySectorStaticUnits = _enemySector getVariable["maxStatic", 0];
            _difference = _minEnemySectorunits - _numberOfEnemyunitsinSector;
            _numberOfIterations = if (_difference > 0) then [{_difference}, { 0}];
            _currentWarLevel = call calculateWarLevel;
            _routeGroupName = _enemySectorName + "_route_group";
            _routeGroup = allGroups select { groupId _x == _routeGroupName };
            _routeGroupNumber = count(_routeGroup);
            if (_routeGroupNumber > 1) then {
                diag_log(format ["ERROR: More than one route groups found for sector %1", _enemySectorName]);
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
            while {_i  < _difference} do {
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
                    diag_log(format ["DEBUG: Creating unit %1 on spawn point %2 at sector %3", _unittype, _chosenspawnPoint, _enemySectorname]);
                    _group = createGroup west;
                    _group setBehaviour "SAFE";
                    _unit = _group createUnit [_Unittype, _chosenspawnPointPos, [], 0, "NONE"];
                    _unit setPosATL [_chosenspawnPointPos select 0, _chosenspawnPointPos select 1, _chosenspawnPointPos select 2];
                    _chosenspawnPointdirection = markerDir _chosenspawnPoint;
                    _unit setDir _chosenspawnPointdirection;
                    _unit setFormDir _chosenspawnPointdirection;
                    _unit SetCombatBehaviour "SAFE";
                    _allEnemyunitsinSector pushBack _unit;
                    _i = _i + 1;
                };
                if (_i < _difference && _currentWarLevel <= defConFive) then {
                    _sectorRouteSpawnPointName = _enemySectorname + "_route0";
                    _sectorRouteSpawnPointPos = getmarkerPos(_sectorRouteSpawnPointName);
                    _sectorRouteSpawnPointPos set [2, parseNumber(markertext _sectorRouteSpawnPointName)];
                    _routeUnitType = "vn_b_men_sog_09";
                    diag_log(format["DEBUG: Creating route unit %1 at sector %2", _routeUnitType, _enemySectorname]);
                    _routeUnit = _routeGroup createUnit [_routeUnitType, _sectorRouteSpawnPointPos, [], 0, "NONE"];
                    _i = _i + 1;
                };
        };
    };
    } forEach _enemySectors;
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
        systemChat ("No sector owned by " + _sideName + " found. Exiting.");
        []
        };
    systemChat ("Found " + str(_sideSectorsCount) + " sector(s) owned by " + str(_sideName));
    _sideSectors
};

calculateTotalPOVL = {
    newPOVL = 0;
    {
        if (str(_x getVariable "owner") == "east") then {
            newPOVL = newPOVL + parseNumber(_x call getSectorValue)
        }
    } forEach (true call BIS_fnc_moduleSector);
    totalPOVL = newPOVL;
    call updateGUI;
};

recruitUnit = {
    if (manpower < 1) exitWith { hint "Not enough manpower."; };
    _randomUnitId = str(floor(random 32) + 1);
    if (parseNumber _randomUnitId < 10) then {
        _randomUnitId = "0" + _randomUnitId;
    };
    systemChat ("Random recruit ID: " + _randomUnitId);
    _myUnitName = "vn_c_men_" + _randomUnitId;
    _myUnitName createUnit [position player, group player, "removeAllAssignedItems this; this call addActionStayHere; this call addRemoveAllActionsFromCorpseHandler"];

    call decreaseManpower;
};

decreaseManpower = {
    if (manpower > 0) then {
        manpower = manpower - 1;
    };
    call updateGUI;
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

_allSectors = true call BIS_fnc_moduleSector;
_ownedSectors = [_allSectors, { str(_x getVariable "owner") == "EAST" }] call BIS_fnc_conditionalSelect;
if (count _ownedSectors == 0) exitwith {
    diag_log("INFO: No sectors owned by EAST. Exiting.");
    }; //TODO: replace with getSectorsOwnedBySide
_randomOwnedSector = selectRandom _ownedSectors;
_randomOwnedSectorName = _randomOwnedSector call BIS_fnc_objectVar;
_randomSpawnPointName = _randomOwnedSectorName + str(1);
_randomSpawnPointNamePos = getMarkerPos(_randomSpawnPointName);
_randomOwnedSectorPos = getPos _randomOwnedSector;
call calculateTotalPOVL;
if (surfaceIsWater _randomSpawnPointNamePos) then {
   _grp = _randomSpawnPointNamePos call createEnemyInfantryBoatGroup;
  [_grp, _randomOwnedSectorName, _randomOwnedSectorPos] call doNavalAttack;
} else {
   _grp = _randomSpawnPointNamePos call createEnemyInfantryGroup;
  [_grp, _randomOwnedSectorPos] call doLandAttack;
};

warningMsg = "Enemy is attacking " + _randomOwnedSectorName;
[warningMsg, 1] call BIS_fnc_3DENNotification;
["Warning", [warningMsg]] call BIS_fnc_showNotification;
call updateDefCon;
totalTicks = 0;
};

doLandAttack = { 
params["_grp", "_randomOwnedSectorPos"];
captureWP = _grp addWaypoint [_randomOwnedSectorPos, 0];
captureWP setWaypointType "GUARD";
};

doNavalAttack = { 
params["_grp", "_randomOwnedSectorName", "_randomOwnedSectorPos"];
_boat = "vn_o_boat_01_mg_03" createVehicle getPos(leader _grp);
{
    _x moveInAny _boat;
} forEach units _grp;
_coastWaypointPos = getMarkerPos (_randomOwnedSectorName + "_coastWP");
unloadWP = _grp addWaypoint [_coastWaypointPos, 0];
unloadWP setWaypointType "GETOUT";
captureWP = _grp addWaypoint [_randomOwnedSectorPos, 0];
captureWP setWaypointType "GUARD";
};

INFANTRY_UNITS = [
    "vn_b_men_sog_09",0.5, "vn_b_men_sog_10",0.4,"vn_b_men_sog_04",0.1 //random like in recruitUnit instead of an array
];

createEnemyInfantryGroup = {
    _grp = createGroup [west,true];
    for "_i" from 0 to totalPOVL do {
        selectRandomWeighted INFANTRY_UNITS createUnit [_randomSpawnPointNamePos, _grp];
    };
    _grp;
};

MAX_NUMBER_OF_BOAT_CREW = 5;

createEnemyInfantryBoatGroup = {
    _grp = createGroup [west,true];
    _boatCrewNr = if (totalPOVL > MAX_NUMBER_OF_BOAT_CREW) then [{MAX_NUMBER_OF_BOAT_CREW},{totalPOVL}];
    for "_i" from 1 to _boatCrewNr do {
        selectRandomWeighted INFANTRY_UNITS createUnit [_randomSpawnPointNamePos, _grp];
    };
    _grp;
};

updateManpower = {
 call calculateTotalPOVL;
 if ((manpower + totalPOVL) > totalPOVL) then {
     manpower = totalPOVL;
     hint("Manpower limit reached. Capture more POI's to extend manpower capacity.");
 } else {
      manpower = manpower + totalPOVL;
      hint("New volunteers have arrived.")
 };
 call updateGUI;
};

showReport = {
    strToDisplay = "Manpower: " + str (manpower) + " Influence: " + str (totalPOVL);
    ["ScoreAdded", [strToDisplay]] call BIS_fnc_showNotification;
};

runPerTickScripts = {
    totalTicks = totalTicks + 1;
    call updateManpower;;
    call showReport;
    sleep 5;
    if ((totalTicks mod defcon) == 0) then {
        call attackRandomSettlement;
    };

    call populateEnemySectors;
};

initGUI = {
    ("ManpowerTitle_layer" call BIS_fnc_rscLayer) cutRsc ["ManpowerTitle","PLAIN"];
    ("TotalPOVL_layer" call BIS_fnc_rscLayer) cutRsc ["TotalPOVLTitle","PLAIN"];
};

updateGUI = {
    (uiNameSpace getVariable "myUI_manpower") ctrlSetText format["Manpower: %1",manpower];
    (uiNameSpace getVariable "myUI_totalPOVL") ctrlSetText format["Influence: %1",totalPOVL];
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