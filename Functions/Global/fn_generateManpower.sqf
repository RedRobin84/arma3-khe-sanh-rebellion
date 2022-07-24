_MANPOWER_SECTOR_DEFAULT_VALUE = 0;
_MANPOWER_SECTOR_DEFAULT_INCREMENT = 1;

_capturedTownSectors = call REB_fnc_getTownSectorsOwnedByEast;
diag_log(format["DEBUG::generateManpower: capturedTownSectors: %1", _capturedTownSectors]);
if (count _capturedTownSectors != 0) then {
    {
        _currentManpower = _x getVariable[MANPOWER_VAR_NAME, _MANPOWER_SECTOR_DEFAULT_VALUE];
        _sectorValue = _x call REB_fnc_getSectorValue;
        if (_currentManpower < _sectorValue) then {
            _totalGeneratedManpower = _totalGeneratedManpower + _MANPOWER_SECTOR_DEFAULT_INCREMENT;
            _currentManpower = _currentManpower + _MANPOWER_SECTOR_DEFAULT_INCREMENT;
            _x setVariable[MANPOWER_VAR_NAME, _currentManpower];
            _capturedSectorName = _x call BIS_fnc_objectVar;
            [_capturedSectorName, _currentManpower, _sectorValue] call REB_fnc_updateManpowerGUI;
        };
    } forEach _capturedTownSectors;
    hint("New volunteers have arrived.");
};
//VOID
