_MANPOWER_SECTOR_DEFAULT_VALUE = 0;
_MANPOWER_SECTOR_DEFAULT_INCREMENT = 1;

_enemySectors = east call REB_fnc_getSectorsOwnedBySide;
{
    _currentManpower = _x getVariable[MANPOWER_VAR_NAME, _MANPOWER_SECTOR_DEFAULT_VALUE];
    _sectorValue = _x call REB_fnc_getSectorValue;
    if (_currentManpower < _sectorValue) then {
        _currentManpower = _currentManpower + _MANPOWER_SECTOR_DEFAULT_INCREMENT;
        _x setVariable[MANPOWER_VAR_NAME, _currentManpower];
        _enemySectorName = _x call BIS_fnc_objectVar;
        [_enemySectorName, _currentManpower, _sectorValue] call REB_fnc_updateManpowerGUI;
    };
} forEach _enemySectors;
hint("New volunteers have arrived.");
//VOID
