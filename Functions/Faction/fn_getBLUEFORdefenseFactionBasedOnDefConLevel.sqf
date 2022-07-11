_currentDefCon = _this; //enum located at initServer.sqf

switch (_currentDefCon) do
{
    case DEFCON_SIX: { BLUEFOR_CIDG }; //enum located at initServer.sqf
    case DEFCON_FIVE: { BLUEFOR_CIDG };
    case DEFCON_FOUR: { BLUEFOR_ARVN };
    case DEFCON_THREE: { BLUEFOR_ARVN };
    case DEFCON_TWO: { BLUEFOR_ARVN };
    case DEFCON_ONE:  { BLUEFOR_SOG };
    default { throw "invalid DEFCON level" };
};
