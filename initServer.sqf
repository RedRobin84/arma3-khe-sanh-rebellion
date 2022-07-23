0 spawn {
    0 spawn {call REB_fnc_gameTickLoop;};
    call REB_fnc_initSectorVars;
    sleep 5;
    //call REB_fnc_initWinConditionForSectorsEventHandlers;
    _totalPOVL = call REB_fnc_calculateTotalPOVL;
    _totalPOVL call REB_fnc_populateEnemySectors;
    sleep 1;
    call REB_fnc_initGUI;
    sleep 5;
    [INTRO_INFO_MSG, MSG_TYPE_SCORE_ADDED] call REB_fnc_displayMessage;
    sleep 11;
    [INTRO_INFO_MSG2, MSG_TYPE_SCORE_ADDED] call REB_fnc_displayMessage;
    sleep 6;
    hint(INTRO_HINT);
    sleep 6;
    _currentDefcon = _totalPOVL call REB_fnc_calculateDefCon;
    _currentDefcon call REB_fnc_displayCurrentDefCon;
};

//DEPRECATED
addResumeGameLoopOnGameLoadHandler = {
addMissionEventHandler ["Loaded", {
    params ["_saveType"];
    
    0 spawn {call REB_fnc_gameTickLoop;};
}];
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
    (_sectorValue * MAX_SOLDIERS_MULTIPLIER)
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
