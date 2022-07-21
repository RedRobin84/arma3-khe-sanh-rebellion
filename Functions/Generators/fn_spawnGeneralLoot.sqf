_container = _this;

_container call REB_fnc_generateRandomWeapons;

if (50 call REB_fnc_percentageChanceOf) then {
    _container call REB_fnc_generateRandomExplosives;
};

if (25 call REB_fnc_percentageChanceOf) then {
    _container call REB_fnc_generateRandomAccessiories;
};
