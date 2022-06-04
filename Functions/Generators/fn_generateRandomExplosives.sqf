/** RANDOM LOOT CHANCES
SMOKE GRENADES =    30 %
GRENADES =          25 %
TRAPS =             25 %
MINES =             20 %
**/
EXPLOSIVES_LOOT_ARRAY = [
    [
        ["vn_rdg2_mag"]
    ], .3, //Smoke grenades
    [
        ["vn_v40_grenade_mag"],
        ["vn_molotov_grenade_mag"],
        ["vn_t67_grenade_mag"],
        ["vn_f1_grenade_mag"]
    ], .25, //Grenades
    [
        ["vn_mine_punji_01"],
        ["vn_mine_punji_02"],
        ["vn_mine_punji_03"]
    ], .25, //Traps
    [
        ["vn_mine_satchel_remote_02_mag"],
        ["vn_mine_m14_mag"],
        ["vn_mine_m15_mag"],
        ["vn_mine_m16_mag"]
    ], .20
];

_container = _this;

_randomExplosiveType = EXPLOSIVES_LOOT_ARRAY call BIS_fnc_selectRandomWeighted;
_randomExplosiveItem = selectRandom _randomExplosiveType;
_container addItemCargo [_randomExplosiveItem, ceil(random(3))];