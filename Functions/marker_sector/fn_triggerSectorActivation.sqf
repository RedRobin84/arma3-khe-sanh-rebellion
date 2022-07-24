_trigger = _this;
_triggerName = _trigger call BIS_fnc_objectVar;
_sectorMarker = "AdvSector_" + _triggerName;
[_trigger, "ColorBlack"] call REB_fnc_setSectorMarkerColor;