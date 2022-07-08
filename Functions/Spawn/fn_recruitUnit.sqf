_CIVILIAN_TYPES_COUNT = 32;

_sector = player call REB_fnc_getClosestSectorToObject;
_sectorManpower = _sector getVariable[MANPOWER_VAR_NAME, 0];
if (_sectorManpower < 1) exitWith { hint "Not enough manpower."; };

_randomUnitId = _CIVILIAN_TYPES_COUNT call REB_fnc_getRandomNumberWihtLessThanTenZeroPrefix;
diag_log(format["DEBUG::recruitUnit: Random recruit ID: %1", _randomUnitId]);
_myUnitName = "vn_c_men_" + _randomUnitId;
_myUnitName createUnit [position player, group player, "removeAllAssignedItems this; this call addActionStayHere; this call addRemoveAllActionsFromCorpseHandler"];

   _sector call REB_fnc_decrementSectorManpower;
//VOID
