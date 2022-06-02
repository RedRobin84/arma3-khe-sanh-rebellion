_container = _this;

_randomType = RANDOM_LOOT_ARRAY call BIS_fnc_selectRandomWeighted;
_randomItem = selectRandom _randomType;
_container addItemCargo [(_randomItem select 0), ceil(random(3))];
_container addItemCargo [(_randomItem select 1), ceil(random(6))];
hint("You have found some hidden weapons.");