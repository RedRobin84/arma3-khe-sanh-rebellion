/*populateEnemySectors = {
	_enemySectors = "WEST" call getSectorsOwnedBySide;
	if (isNil _enemySectors) exitwith {};
	{
		_enemySector = _x;
		_maxEnemySectorUnits = x getVariable["max", 0];
		if (_maxEnemySectorUnits == 0) then {systemChat("WARN: Max units not set for sector " + str(_enemySector));};
		_allUnitsInEnemySector = allUnits inAreaArray _enemySector;
		_enemySectorUnitCount = west countSide _allUnitsInEnemySector;
		if (((west countSide _allUnitsInEnemySector) < _maxEnemySectorUnits) && (east countSide _allUnitsInEnemySector) == 0) then {
			_allStaticSpawnPointsInEnemySector = allMapMarkers select { !isNil(_x getVariable["static"]) } inAreaArray _enemySector;
			if (count _allStaticSpawnPointsInEnemySector == 0) exitWith {
				systemChat("ERROR: No spawn points set for sector " + str(_enemySector));
			};
			_allUnopccupiedStaticSpawnPointsInEnemySector = [_allStaticSpawnPointsInEnemySector, { west countSide _x }] call BIS_fnc_conditionalSelect;
			if ((count _allUnopccupiedStaticSpawnPointsInEnemySector) != 0) then {
				_chosenSpawnPoint = selectRandom _allUnopccupiedStaticSpawnPointsInEnemySector;
				_unit = "vn_b_men_sog_09";
				systemChat("Creating unit " + str(_unit) + " on spawn point " + str(_chosenSpawnPoint));
				_unit createUnit [getMarkerPos(_randomSpawnPointNamePos), grpNull];
			};
		};		
	} forEach _enemySectors;
};

getSectorsOwnedBySide = {
	_sideName = _this;
	_allSectors = true call BIS_fnc_moduleSector;
	_sideSectors = [_allSectors, { str(_x getVariable "owner") == _sideName }] call BIS_fnc_conditionalSelect;
	_sideSectorsCount = count _sideSectors;
	if (_sideSectorsCount == 0) exitwith {
		systemChat ("No sector owned by " + _sideName + " found. Exiting.");
		nil
		};
	systemChat ("Found " + _sideSectorsCount + " sector(s) owned by " + _sideName);
	_sideSectors
};*/