_sectorsOwnedByEast = east call REB_fnc_getSectorsOwnedBySide;
_townSectorsOwnedByEast = [_sectorsOwnedByEast, {
            !isNull((missionNamespace getVariable [((_x call BIS_fnc_objectVar) + "_recruitArea"), objNull]))
        }] call BIS_fnc_conditionalselect;
diag_log(format["DEBUG::fn_getTownSectorsOwnedByEast: Total count of %1", count(_townSectorsOwnedByEast)]);
//RETURN
_townSectorsOwnedByEast;