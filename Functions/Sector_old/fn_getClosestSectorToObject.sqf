_object = _this;
_closestSector = ([call REB_fnc_getAllSectors, _object] call BIS_fnc_nearestPosition);
diag_log(format["DEBUG::getClosestSectorToObject: Closest sector to %1 is %2", _object, _closestSector]);
//RETURN
_closestSector
