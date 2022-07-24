params["_villager", "_sectorVar"];
_villager setVariable["homeSector", _sectorVar];
_unitType = (CIVILIAN_TYPE + (CIVILIAN_TYPES_COUNT call REB_fnc_getRandomNumberWithLessThanTenZeroPrefix));
_unitLoadout = getUnitLoadout(_unitType);
_villager setUnitLoadout (_unitLoadout);
diag_log(format["DEBUG::fn_villagerInit: Created villager %1 with homeSector %2 and loadout %3", _villager, _unitType, _unitLoadout]);
_villager addEventHandler ["Killed", { 
    _killed = _this select 0; 
    _killer = _this select 1;
    if (side _killer == east) then {
        _eventSectorVar = _killed getVariable["homeSector", "no_sector"];
        if (_eventSectorVar == "no_sector") exitWith {
            diag_log(format["ERROR::villagerInit: No sector specified for villager at pos %1", (position _killed)]);
        };
        _sector = missionNamespace getVariable [_eventSectorVar , objNull];
        _sector call REB_fnc_decrementSectorManpower;  
        systemChat "Civilian was killed by your soldiers and the number of volunteers has decreased.";
        } 
    }
    diag_log(format["DEBUG::fn_villagerInit: Villager %1 killed by %2 at sector %3", _killed, _killer, _sectorVar]);
];
//VOID
