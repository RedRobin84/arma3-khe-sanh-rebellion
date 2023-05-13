diag_log("DEBUG::calculateDefCon: executing...");
_totalPOVL = _this;
_calculatedDefcon = 0; // located in init.sqf

switch (true) do {
    case (_totalPOVL < 2): { 
        _calculatedDefcon = DEFCON_SIX;
    };
    case (_totalPOVL < 4): {
         _calculatedDefcon = DEFCON_FIVE;
    };
    case (_totalPOVL <= 6): {
        _calculatedDefcon = DEFCON_FOUR;
    };
    case (_totalPOVL <= 8): {
        _calculatedDefcon = DEFCON_THREE;
    };
    case (_totalPOVL <= 10): {
        _calculatedDefcon = DEFCON_TWO;
    };
    default { 
        _calculatedDefcon = DEFCON_ONE;
    };
};
diag_log(format["DEBUG::calculateDefCon: _calculatedDefcon = %1", _calculatedDefcon]);

if (defconThreshold > _calculatedDefcon) then {
    diag_log(format["DEBUG::calculateDefCon: new defcon threshold = %1, advanced from %2", _calculatedDefcon, defconThreshold]);
    defconThreshold = _calculatedDefcon;
    defconThreshold call REB_fnc_updateDefConGUI;
    defconThreshold call REB_fnc_displayCurrentDefCon;
};
//VOID
