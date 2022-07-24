/** RANDOM LOOT CHANCES
PISTOLS =           30 %
SHOTGUN =           12 %
CARABINES =         12 %
SUB-MACHINE GUNS =  12 %
ASSAULT RIFLES =    12 %
GRENADE LAUNCHERS ´ 12 %
MACHINE GUNS =      5 %
AT / AA LAUNCHER =  5 %
**/
WEAPONS_LOOT_ARRAY = [
    [
        ["vn_m1895", "vn_m1895_mag", "vn_s_m1895"],
        ["vn_m1911", "vn_m1911_mag", "vn_s_m1911"]
    ], .3, //Pistols
    [
        ["vn_izh54", "vn_izh54_mag", "vn_izh54_mag"],
        ["vn_izh54_p", "vn_izh54_mag", "vn_izh54_mag"],
        ["vn_izh54_shorty", "vn_izh54_mag", "vn_izh54_mag"]
    ], .12, //Shotguns
    [
        ["vn_m1carbine", "vn_carbine_15_mag", "vn_o_3x_m84"],
        ["vn_sks", "vn_sks_mag", "vn_o_3x_m9130"]
    ], .12, //Carabines
    [
        ["vn_sten", "vn_sten_mag", "vn_s_sten"],
        ["vn_mc10", "vn_mc10_mag", "vn_s_mc10"]
    ], .12, //Submachine guns
    [
        ["vn_type56", "vn_type56_mag", "vn_b_type1956"],
        ["vn_m38", "vn_m38_mag", "vn_b_m38"],
        ["vn_m4956", "vn_m4956_10_mag", "vn_o_4x_m4956"]
    ], .12, //Assault Rifles
    [
        ["vn_m60", "vn_m60_100_mag", "vn_m60_200_mag"],
        ["vn_m60_shorty", "vn_m60_200_mag", "vn_m60_100_mag"]
    ], .12, //Machine Guns
    [
        ["vn_m79", "vn_40mm_m433_hedp_mag", "vn_f1_grenade_mag"],
        ["vn_m79_p", "vn_40mm_m433_hedp_mag", "vn_f1_grenade_mag"]
    ], .12, //Grenade Launchers
    [
        ["vn_rpg2", "vn_rpg2_mag", "vn_mine_satchel_remote_02_mag"],
        ["vn_rpg7", "vn_rpg7_mag", "vn_mine_satchel_remote_02_mag"]
    ], .05 //AT/AA
];

_container = _this;

_randomWeaponType = WEAPONS_LOOT_ARRAY call BIS_fnc_selectRandomWeighted;
_randomWeaponItem = selectRandom _randomWeaponType;
_container addItemCargo [(_randomWeaponItem select 0), ceil(random(3))];
_container addItemCargo [(_randomWeaponItem select 1), ceil(random(6))];
if (25 call REB_fnc_percentageChanceOf) then {
    _container addItemCargo [(_randomWeaponItem select 2), 1];
};
hint("You have found some hidden weapons.");
diag_log(format["DEBUG::fn_generateRandomWeapons: Adding random item %1 to container %1", _randomWeaponItem, _container]);
//VOID
