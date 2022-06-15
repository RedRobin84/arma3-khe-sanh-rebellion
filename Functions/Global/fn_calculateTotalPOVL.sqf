totalPOVL = 0;
    {
        if (str(_x getVariable "owner") == "east") then {
            totalPOVL = totalPOVL + (_x call REB_fnc_getSectorValue)
        }
    } forEach (call REB_fnc_getAllSectors);
    diag_log(format["DEBUG::calculateTotalPOVL: New totalPOVL: %1", totalPOVL]);
    totalPOVL call REB_fnc_updateTotalPOVLGUI;
    //RETURN
    totalPOVL
    