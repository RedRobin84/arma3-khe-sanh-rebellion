//(uiNameSpace getVariable "myUI_manpower") ctrlSetText format["Manpower: %1", manpower];
params["_enemySectorName", "_currentManpower", "_sectorValue"];
_manpowerMarker = _enemySectorName + "_manpowerMarker";
_manpowerMarkerText = format["%1/%2", _currentManpower, _sectorValue];
_manpowerMarker setMarkerText _manpowerMarkerText;
diag_log(format["DEBUG::fn_updateManpowerGUI: Setting text %1 for marker %2", _manpowerMarkerText, _manpowerMarker]);
//VOID
