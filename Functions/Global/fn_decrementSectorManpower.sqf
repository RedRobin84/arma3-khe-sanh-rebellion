_sector = _this;
diag_log(format["DEBUG::decrementSectorManpower: Decrementing sector %1 manpower.", _sector]);
[_sector, SECTOR_MANPOWER_DEFAULT_DECREMENT] call REB_fnc_decreaseSectorManpower;
//VOID
