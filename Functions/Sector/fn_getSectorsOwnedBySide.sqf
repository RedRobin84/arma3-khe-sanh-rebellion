_sideName = _this;
    _allSectors = call REB_fnc_getAllSectors;
    _sideSectors = [_allSectors, { (_x call REB_fnc_getSectorController) == _sideName }] call BIS_fnc_conditionalSelect;
    _sideSectorsCount = count(_sideSectors);
    if (_sideSectorsCount == 0) exitwith {
        diag_log(format["DEBUG::getSectorsOwnedBySide: No sector owned by %1 found. Exiting.", _sideName]);
        //RETURN
        []
        };
     diag_log(format["DEBUG::getSectorsOwnedBySide: Found %1 sector(s) owned by %2", _sideSectorsCount, _sideName]);
    //RETURN
    _sideSectors
    