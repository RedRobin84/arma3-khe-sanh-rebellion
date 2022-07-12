{
    [ _x, "ownerChanged", {
        params[ "_sector", "_owner", "_ownerOld" ];
         _enemySectorName = _sector call BIS_fnc_objectVar;
        _manpowerMarker = _enemySectorName + "_manpowerMarker";
        if ( _owner isEqualTo EAST ) then {
            call checkIfAllSectorsOwnedByEast;
            _manpowerMarker setMarkerAlpha 100;
        };
        if ( _owner isEqualTo WEST ) then {
            _manpowerMarker setMarkerAlpha 0;
            _sector call REB_fnc_resetSectorManpower;
        };
    }] call BIS_fnc_addScriptedEventHandler; 
} forEach (call REB_fnc_getAllSectors);