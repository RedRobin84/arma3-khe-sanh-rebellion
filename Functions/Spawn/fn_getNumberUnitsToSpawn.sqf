params["_enemySector", "_numberOfEnemyunitsinSector"];
_sectorValue = _enemySector call REB_fnc_getSectorValue;
_minEnemySectorunits = _enemySector getVariable["min", _sectorValue];
_difference = (_minEnemySectorunits - _numberOfEnemyunitsinSector);
_result = if (_difference > 0) then [{_difference}, {SECTOR_ENEMY_UNITS_DEFAULT_INCREASE}];
diag_log(format["DEBUG::getNumberUnitsToSpawn: sector: %1 -> Units to spawn: %2 = (_minEnemySectorunits: %3 - _numberOfEnemyunitsinSector: %4), _difference = %5", _enemySector, _result, _minEnemySectorunits, _numberOfEnemyunitsinSector, _difference]);
//RETURN
_result;