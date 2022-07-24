params["_sector", "_amountToDecrease"];
_sectorManpower = _sector getVariable[MANPOWER_VAR_NAME, 0];
_enemySectorName = _sector call BIS_fnc_objectVar;
_sectorValue = _sector call REB_fnc_getSectorValue;
_sectorManpower = _sectorManpower - _amountToDecrease;
_sector setVariable[MANPOWER_VAR_NAME, _sectorManpower];
diag_log(format["DEBUG::fn_decreaseSectorManpower: by %1 to %2 on sector %3", _amountToDecrease, _sectorManpower, _sector]);

[_enemySectorName, _sectorManpower, _sectorValue] call REB_fnc_updateManpowerGUI;
//VOID
