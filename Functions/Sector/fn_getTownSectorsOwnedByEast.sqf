_sectorsOwnedByEast = east call REB_fnc_getSectorsOwnedBySide;
_townSectorsOwnedByEast = [_sectorsOwnedByEast, {
            !isNull((missionNamespace getVariable [((_x call BIS_fnc_objectVar) + "_recruitArea"), objNull]))
        }] call BIS_fnc_conditionalselect;
//RETURN
_townSectorsOwnedByEast;