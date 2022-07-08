_totalPOVL = 0;
    {
        if (str(_x getVariable "owner") == "east") then {
            _totalPOVL = _totalPOVL + (_x call REB_fnc_getSectorValue)
        }
    } forEach (call REB_fnc_getAllSectors);
    diag_log(format["DEBUG::calculateTotalPOVL: New totalPOVL: %1", _totalPOVL]);
    _totalPOVL call REB_fnc_updateTotalPOVLGUI;
    //RETURN
    _totalPOVL
    