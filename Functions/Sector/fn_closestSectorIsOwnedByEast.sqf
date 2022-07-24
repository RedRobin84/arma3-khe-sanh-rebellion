_trigger = _this;
_closestSector =_trigger call REB_fnc_getClosestSectorToObject;
//RETURN
(_closestSector call REB_fnc_getSectorController) == EAST;

