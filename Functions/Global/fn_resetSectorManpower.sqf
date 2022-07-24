_sector = _this;
diag_log(format["DEBUG::resetSectorManpower: Manpower for sector %1 manpower will be reset.", _sector]);
_sectorManpower = _sector call REB_fnc_getSectorManpower;
[_sector, _sectorManpower] call REB_fnc_decreaseSectorManpower;
//VOID
