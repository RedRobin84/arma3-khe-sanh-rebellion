_MANPOWER_SECTOR_DEFAULT_VALUE = 0;
_MANPOWER_SECTOR_DEFAULT_INCREMENT = 1;

_MANPOWER_VAR_NAME = "manpower";

_enemySectors = west call getSectorsOwnedByside;
{
    _currentManpower = _x getVariable[_MANPOWER_VAR_NAME, _MANPOWER_SECTOR_DEFAULT_VALUE];
    _sectorValue = _x call REB_fnc_getSectorValue;
    if (_currentManpower < _sectorValue) then {
        _currentManpower = _currentManpower + _MANPOWER_SECTOR_DEFAULT_INCREMENT;
        _x setVariable[_MANPOWER_VAR_NAME, _currentManpower];
        _enemySectorName = _enemySector call BIS_fnc_objectVar;
        _manpowerMarker = _enemySectorName + "_manpowerMarker";
        _manpowerMarkerText = format["%1/%2", _currentManpower, _sectorValue];
        _manpowerMarker setMarkerText _manpowerMarkerText;
    };
} forEach _enemySectors;
hint("New volunteers have arrived.");