_ownedSectors = east call REB_fnc_getSectorsOwnedBySide;
if (count _ownedSectors == 0) exitwith {
    diag_log("INFO::getRandomEastSector: No sectors owned by EAST. Exiting.");
    //RETURN
    ""
    };
_randomOwnedSector = selectRandom _ownedSectors;
diag_log(format["DEBUG::fn_getRandomEastSector: %1", _randomOwnedSector]);
//RETURN
_randomOwnedSector