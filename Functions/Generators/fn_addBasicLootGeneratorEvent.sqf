LAST_TIMESTAMP_VAR_NAME = "lastTimestamp";

/** RANDOM LOOT CHANCES
PISTOLS =           30 %
SHOTGUN =           15 %
CARABINES =         15 %
SUB-MACHINE GUNS =  15 %
ASSAULT RIFLES =    15 %
MACHINE GUNS =      5 %
AT / AA LAUNCHER =  5 %
**/
RANDOM_LOOT_ARRAY = [
    [
        ["vn_m1895", "vn_m1895_mag"],
        ["vn_m1911", "vn_m1911_mag"]
    ], .3, //Pistols
    [
        ["vn_izh54", "vn_izh54_mag"],
        ["vn_izh54_p", "vn_izh54_mag"],
        ["vn_izh54_shorty", "vn_izh54_mag"]
    ], .15, //Shotguns
    [
        ["vn_m1carbine", "vn_carbine_15_mag"],
        ["vn_sks", "vn_sks_mag"]
    ], .15, //Carabines
    [
        ["vn_sten", "vn_sten_mag"],
        ["vn_mc10", "vn_mc10_mag"]
    ], .15, //SubMGuns
    [
        ["vn_type56", "vn_type56_mag"],
        ["vn_m38", "vn_m38_mag"],
        ["vn_m4956", "vn_m4956_10_mag"]
    ], .15, //Assault
    [
        ["vn_m60", "vn_m60_100_mag"],
        ["vn_m60_shorty", "vn_m60_200_mag"]
    ], .05, //MachineG
    [
        ["vn_rpg2", "vn_rpg2_mag"],
        ["vn_rpg7", "vn_rpg7_mag"]
    ], .05 //AT/AA
];
    _container = _this;
    _container addEventHandler
    [
        "ContainerOpened", {
            params ["_container", "_unit"];
                _currentTimestamp = round(diag_TickTime);
            if ([_container, _currentTimestamp] call moreThanOneHourPassedSinceLastOpened) then {
                _container call generateRandomLoot;
                _container setVariable[LAST_TIMESTAMP_VAR_NAME, _currentTimestamp];
    }
        }
    ];

moreThanOneHourPassedSinceLastOpened = {
    params ["_container", "_currentTimestamp"];
    _lastTimestamp = _container getVariable[LAST_TIMESTAMP_VAR_NAME, -3600];
    //RETURN
    ((_currentTimestamp - _lastTimestamp) >= 3600)
};

generateRandomLoot = {
    hint("You have found some hidden weapons.");
    _container = _this;
    _randomType = RANDOM_LOOT_ARRAY call BIS_fnc_selectRandomWeighted;
    _randomItem = selectRandom _randomType;
    _container addItemCargo [(_randomItem select 0), ceil(random(3))];
    _container addItemCargo [(_randomItem select 1), ceil(random(6))];
};