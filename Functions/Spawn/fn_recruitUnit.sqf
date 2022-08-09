_CIVILIAN_TYPES_COUNT = 32;

_sector = player call REB_fnc_getClosestSectorToObject;
_sectorManpower = _sector call REB_fnc_getSectorManpower;
if (_sectorManpower < 1) exitWith { hint "Not enough manpower."; };

_randomUnitId = _CIVILIAN_TYPES_COUNT call REB_fnc_getRandomNumberWithLessThanTenZeroPrefix;
_myUnitName = CIVILIAN_TYPE + _randomUnitId;
_myUnitName createUnit [position player, group player, "removeAllAssignedItems this; this call addActionStayHere; this call addRemoveAllActionsFromCorpseHandler; [this, CIVILIAN_TYPE] call REB_fnc_setBLUEFORunitSkillBasedOnFaction;"];

_sector call REB_fnc_decrementSectorManpower;
diag_log(format["DEBUG::recruitUnit: Creating recruit at sector %1 with name %2", _randomUnitId, _myUnitName]);
//VOID
