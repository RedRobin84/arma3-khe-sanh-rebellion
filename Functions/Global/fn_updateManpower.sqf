_MANPOWER_SECTOR_DEFAULT_VALUE = 0;
_MANPOWER_SECTOR_DEFAULT_INCREMENT = 1;

_capturedSectors = east call REB_fnc_getSectorsOwnedBySide;
_totalGeneratedManpower = 0;
{
    _currentManpower = _x getVariable[MANPOWER_VAR_NAME, _MANPOWER_SECTOR_DEFAULT_VALUE];
    _sectorValue = _x call REB_fnc_getSectorValue;
    if (_currentManpower < _sectorValue) then {
        _totalGeneratedManpower = _totalGeneratedManpower + 1;
        _currentManpower = _currentManpower + _MANPOWER_SECTOR_DEFAULT_INCREMENT;
        _x setVariable[MANPOWER_VAR_NAME, _currentManpower];
        _capturedSectorName = _x call BIS_fnc_objectVar;
        [_capturedSectorName, _currentManpower, _sectorValue] call REB_fnc_updateManpowerGUI;
    };
} forEach _capturedSectors;

if (_totalGeneratedManpower > 0) then {
    hint("New volunteers have arrived.");
};
//VOID
