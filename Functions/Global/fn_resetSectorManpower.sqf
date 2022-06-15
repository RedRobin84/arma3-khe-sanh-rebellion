_sector = _this;
diag_log(format["DEBUG::resetSectorManpower: Manpower for sector %1 manpower has been reset.", _sector]);
[_sector, 0] call REB_fnc_decreaseSectorManpower;
//VOID
