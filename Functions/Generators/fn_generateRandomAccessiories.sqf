ACCESSIORIES_LOOT_ARRAY = [
        "vn_o_item_map",
        "vn_o_item_firstaidkit",
        "vn_b_item_wiretap",
        "vn_b_item_toolkit",
        "vn_b_item_trapkit",
        "vn_b_item_cigs_01",
        "vn_m19_binocs_grn"
];

_container = _this;

_randomAccessoryItem = selectRandom ACCESSIORIES_LOOT_ARRAY;
_container addItemCargo [_randomAccessoryItem, 1];
diag_log(format["DEBUG::fn_generateRandomAccessiories: Adding random item %1 to container %1", _randomAccessoryItem, _container]);
//VOID

