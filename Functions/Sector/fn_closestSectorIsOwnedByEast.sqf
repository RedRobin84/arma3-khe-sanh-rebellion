_trigger = _this;
_closestSector =_trigger call REB_fnc_getClosestSectorToObject;
//RETURN
(_closestSector getVariable ("sector_" + str(_closestSector) + "_controller")) == EAST

