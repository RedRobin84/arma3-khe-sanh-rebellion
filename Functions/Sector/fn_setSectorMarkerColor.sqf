params["_sector", "_color"];
_markerName = "AdvSector_" + (_sector call REB_fnc_getSectorVarName);
_markerName setMarkerColor _color;
diag_log(format["DEBUG:: Setting sector marker %1 to color %2", _markerName, _color]);