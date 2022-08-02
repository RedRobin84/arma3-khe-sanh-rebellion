diag_log("DEBUG::calculateDefCon: executing...");
_totalPOVL = _this;
_calculatedDefcon = 0; // located in init.sqf

if (_totalPOVL < 2) then {
    //RETURN
    _calculatedDefcon = DEFCON_SIX; //enum located in init.sqf
};
if (_totalPOVL < 4) then {
    //RETURN
    _calculatedDefcon = DEFCON_FIVE;
};
if (_totalPOVL <= 6) then {
    //RETURN
    _calculatedDefcon = DEFCON_FOUR;
};
if (_totalPOVL <= 8) then {
    //RETURN
    _calculatedDefcon = DEFCON_THREE;
};
if (_totalPOVL <= 10) then {
    //RETURN
    _calculatedDefcon = DEFCON_TWO;
} else {
    _calculatedDefcon = DEFCON_ONE;
};

if (defconThreshold < _calculatedDefcon) then {
    diag_log(format["DEBUG::calculateDefCon: new defcon threshold = %1, advanced from %2", _calculatedDefcon, defconThreshold]);
    defconThreshold = _calculatedDefcon;
    defconThreshold call REB_fnc_updateDefConGUI;
    defconThreshold call REB_fnc_displayCurrentDefCon;
};
//VOID
