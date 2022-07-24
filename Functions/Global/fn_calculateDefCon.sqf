diag_log("DEBUG::calculateDefCon: executing...");
_totalPOVL = _this;
if (_totalPOVL < 2) exitWith {
    //RETURN
    DEFCON_SIX //enum located in init.sqf
};
if (_totalPOVL < 4) exitWith {
    //RETURN
    DEFCON_FIVE
};
if (_totalPOVL < 6) exitWith {
    //RETURN
    DEFCON_FOUR
};
if (_totalPOVL < 8) exitWith {
    //RETURN
    DEFCON_THREE
};
if (_totalPOVL < 10) exitWith {
    //RETURN
    DEFCON_TWO
};
//ELSE RETURN
DEFCON_ONE
