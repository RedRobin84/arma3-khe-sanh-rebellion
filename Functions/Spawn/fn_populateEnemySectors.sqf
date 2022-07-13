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
    //VOID