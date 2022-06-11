totalPOVL = 0;
    {
        if (str(_x getVariable "owner") == "east") then {
            totalPOVL = totalPOVL + parseNumber(_x call getSectorValue)
        }
    } forEach (true call BIS_fnc_moduleSector);
    diag_log(format["DEBUG::calculateTotalPOVL: New totalPOVL: %1", totalPOVL]);
    totalPOVL call REB_fnc_updateTotalPOVLGUI;
    //RETURN
    totalPOVL