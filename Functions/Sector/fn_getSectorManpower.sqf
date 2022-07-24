_sectorManpower = _this getVariable[MANPOWER_VAR_NAME, 0];
if ( _sectorManpower == 0) then {
    diag_log(format["WARN::getSectorManpower: Manpower var not found on sector %1. Returning default of %2", _this, 0]);
};
//ELSE RETURN
_sectorManpower;