_currentDefCon = _this; //enum located at init.sqf
_faction = "";
switch (_currentDefCon) do
{
    case DEFCON_SIX:    { _faction = BLUEFOR_CIDG }; //enum located at init.sqf
    case DEFCON_FIVE:   { _faction = BLUEFOR_CIDG };
    case DEFCON_FOUR:   { _faction = BLUEFOR_ARVN };
    case DEFCON_THREE:  { _faction = BLUEFOR_ARVN };
    case DEFCON_TWO:    { _faction = BLUEFOR_SOG };
    case DEFCON_ONE:    { _faction = BLUEFOR_SOG };
    default { throw "invalid DEFCON level" };
};
diag_log(format["DEBUG::fn_getBLUEFORdefenseFactionBasedOnDefConLevel: %1", _faction]);
//RETURN
_faction;
