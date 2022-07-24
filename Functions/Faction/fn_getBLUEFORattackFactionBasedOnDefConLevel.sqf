_currentDefCon = _this; //enum located at init.sqf
_faction = "";
switch (_currentDefCon) do
{
    case DEFCON_SIX:    { _faction = BLUEFOR_CIDG }; //enum located at init.sqf
    case DEFCON_FIVE:   { _faction = BLUEFOR_CIDG };
    case DEFCON_FOUR:   { _faction = BLUEFOR_LRRP };
    case DEFCON_THREE:  { _faction = BLUEFOR_LRRP };
    case DEFCON_TWO:    { _faction = BLUEFOR_LRRP };
    case DEFCON_ONE:    { _faction = BLUEFOR_SFOR };
    default { throw "invalid DEFCON level" };
};
diag_log(format["DEBUG::fn_getBLUEFORattackFactionBasedOnDefConLevel: %1", _faction]);
//RETURN
_faction;
