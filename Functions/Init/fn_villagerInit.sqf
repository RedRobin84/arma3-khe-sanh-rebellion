params["_villager", "_sectorVar"];
_villager setVariable["homeSector", _sectorVar];
_villager setUnitLoadout (
    selectRandom [ 
        (getUnitLoadout "vn_c_men_01"), 
        (getUnitLoadout "vn_c_men_03"), 
        (getUnitLoadout "vn_c_men_02"), 
        (getUnitLoadout "vn_c_men_04"), 
        (getUnitLoadout "vn_c_men_05") 
    ]
);
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
];
//VOID
