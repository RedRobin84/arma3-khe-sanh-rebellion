_SECTOR_INVENTORY_VAR_SUFFIX = "_inventory";

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
            _sectorInventory = missionNamespace getVariable [_enemySectorName + _SECTOR_INVENTORY_VAR_SUFFIX, objNull];
            if (_sectorInventory != objNull) then {
                 _sectorInventory setVariable[CONTAINER_GENERATOR_FLAG, false];
            };          
        };
    }] call BIS_fnc_addScriptedEventHandler; 
} forEach (call REB_fnc_getAllSectors);
//VOID
