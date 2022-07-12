_currentDefCon = _this; //enum located at init.sqf

switch (_currentDefCon) do
{
    case DEFCON_SIX: { BLUEFOR_CIDG }; //enum located at init.sqf
    case DEFCON_FIVE: { BLUEFOR_CIDG };
    case DEFCON_FOUR: { BLUEFOR_LRRP };
    case DEFCON_THREE: { BLUEFOR_LRRP };
    case DEFCON_TWO: { BLUEFOR_LRRP };
    case DEFCON_ONE:  { BLUEFOR_SFOR };
    default { throw "invalid DEFCON level" };
};
