_LAST_TIMESTAMP_VAR_NAME = "lastTimestamp";

/** RANDOM LOOT CHANCES
PISTOLS =           30 %
SHOTGUN =           15 %
CARABINES =         15 %
SUB-MACHINE GUNS =  15 %
ASSAULT RIFLES =    10 %
MACHINE GUNS =      5 %
AT / AA LAUNCHER =  5 %
**/
_RANDOM_LOOT_ARRAY = [
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
        ["vn_m1carbine". "vn_carbine_15_mag"],
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

addBasicLootGeneratorEvent = {
    _container = _this;
    _container addEventHandler
    [
        "ContainerOpened", {
            params ["_container", "_unit"];
            if (_container call _moreThanOneHourPassedSinceLastOpened) {
                _container call _generateRandomLoot;
                _container call _generateRandomLoot;
                _container setVariable[_LAST_TIMESTAMP_VAR_NAME, _currentTimestamp];
    }
        }
    ];
};

_moreThanOneHourPassedSinceLastOpened = {
    _container = _this;
    _lastTimestamp = _container getVariable[_LAST_TIMESTAMP_VAR_NAME, 0];
    _currentTimestamp = round(diag_TickTime);
    //RETURN
    ((_currentTimestamp - _lastTimestamp) >= 3600)
};

_generateRandomLoot = {
    _container = _this;
    _randomType = _RANDOM_LOOT_ARRAY call BIS_fnc_selectRandomWeighted;
    _randomItem = selectRandom _randomType;
    _container addItemCargo [(_randomItem select 0), ceil(random(3))];
    _container addItemCargo [(_randomItem select 1), ceil(random(6))];
};