//War level enum
DEFCON_SIX = 6;
DEFCON_FIVE = 5;
DEFCON_FOUR = 4;
DEFCON_THREE = 3;
DEFCON_TWO = 2;
DEFCON_ONE = 1;

_totalPOVL = _this;
if (_totalPOVL < 2) exitWith {
    //RETURN
    DEFCON_SIX
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
