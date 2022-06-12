_sideName = _this;
    _allSectors = true call BIS_fnc_moduleSector;
    _sideSectors = [_allSectors, { (_x getVariable "owner") == _sideName }] call BIS_fnc_conditionalSelect;
    _sideSectorsCount = count(_sideSectors);
    if (_sideSectorsCount == 0) exitwith {
        diag_log(format["DEBUG::getSectorsOwnedBySide: No sector owned by %1 found. Exiting.", _sideName]);
        //RETURN
        []
        };
     diag_log(format["DEBUG::getSectorsOwnedBySide: Found %1 sector(s) owned by %2", _sideSectorsCount, _sideName]);
    //RETURN
    _sideSectors