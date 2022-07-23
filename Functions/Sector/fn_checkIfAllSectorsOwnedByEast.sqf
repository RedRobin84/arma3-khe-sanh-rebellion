_enemySectorNumber = count(west call REB_fnc_getSectorsOwnedBySide);
    diag_log(format["DEBUG::checkIfAllSectorsOwnedByEast: Number of owned WEST sectors: %1", _enemySectorNumber]);
    if (_enemySectorNumber == 0) then {
        ["end1", true, 20, true, false] call BIS_fnc_endMission;
    };