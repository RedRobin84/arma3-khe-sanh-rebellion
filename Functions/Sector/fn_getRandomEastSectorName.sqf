_ownedSectors = east call REB_fnc_getSectorsOwnedBySide;
if (count _ownedSectors == 0) exitwith {
    diag_log("INFO::getRandomEastSectorName: No sectors owned by EAST. Exiting.");
    //RETURN
    ""
    };
_randomOwnedSector = selectRandom _ownedSectors;
_randomOwnedSectorName = _randomOwnedSector call BIS_fnc_objectVar;
diag_log(format["DEBUG::fn_getRandomEastSectorName: _randomOwnedSectorName"]);
//RETURN
_randomOwnedSectorName