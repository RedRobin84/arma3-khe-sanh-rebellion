_sector = player call REB_fnc_getClosestSectorToObject;
_sectorManpower = _sector getVariable[MANPOWER_VAR_NAME, 0];
if (_sectorManpower < 1) exitWith { hint "Not enough manpower."; };
    _randomUnitId = str(floor(random 32) + 1);
    if ((parseNumber _randomUnitId) < 10) then {
        _randomUnitId = "0" + _randomUnitId;
    };
    diag_log(format["DEBUG::recruitUnit: Random recruit ID: %1", _randomUnitId]);
    _myUnitName = "vn_c_men_" + _randomUnitId;
    _myUnitName createUnit [position player, group player, "removeAllAssignedItems this; this call addActionStayHere; this call addRemoveAllActionsFromCorpseHandler"];

   _sector call REB_fnc_decrementSectorManpower;
//VOID
