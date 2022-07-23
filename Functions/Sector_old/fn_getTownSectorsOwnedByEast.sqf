_sectorsOwnedByEast = east call REB_fnc_getSectorsOwnedBySide;
_townSectorsOwnedByEast = [_sectorsOwnedByEast, {
            (missionNamespace getVariable [((_x call BIS_fnc_objectVar) + "_recruitArea"), objNull]) != objNull
        }] call BIS_fnc_conditionalselect;
//RETURN
_townSectorsOwnedByEast;