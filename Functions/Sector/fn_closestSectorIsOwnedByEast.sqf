_trigger = _this;
_closestSector =_trigger call REB_fnc_getClosestSectorToObject;
_result = (_closestSector call REB_fnc_getSectorController) == EAST;
diag_log(format["DEBUG::fn_closestSectorIsOwnedByEast: Found sector: %1, related object: %2", _closestSector, _trigger]);
//RETURN
_result;
