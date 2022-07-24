_allSectors = [allMissionObjects "EmptyDetector", {
        (triggerText _x) == "sector"
    }
] call BIS_fnc_conditionalselect;
diag_log(format["DEBUG::getAllSectors: Total count of %1", count(_allSectors)]);
//RETURN
_allSectors;
