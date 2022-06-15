_sector = _this;
diag_log(format["DEBUG::decrementSectorManpower: Civilian killed. Sector %1 manpower decremented.", _sector]);
[_sector, SECTOR_MANPOWER_DEFAULT_DECREMENT] call REB_fnc_decreaseSectorManpower;
//VOID
