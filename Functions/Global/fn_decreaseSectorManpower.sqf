params["_sector", "_amountToDecrease"];
_sectorManpower = _sector getVariable[MANPOWER_VAR_NAME, 0];
_enemySectorName = _sector call BIS_fnc_objectVar;
_sectorValue = _sector call REB_fnc_getSectorValue;

if (_sectorManpower > 0) then {
    _sectorManpower = _sectorManpower - _amountToDecrease;
    _sector setVariable[MANPOWER_VAR_NAME, _sectorManpower];
};
[_enemySectorName, _sectorManpower, _sectorValue] call REB_fnc_updateManpowerGUI;
//call REB_fnc_updateManpowerGUI;
//VOID