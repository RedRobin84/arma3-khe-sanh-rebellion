//BLUEFOR FACTIONS PREFIXES
BLUEFOR_SEAL = "vn_b_men_seal_";
BLUEFOR_ARVN = "vn_b_men_army_";
BLUEFOR_LRRP = "vn_b_men_lrrp_";
BLUEFOR_CIDG = "vn_b_men_cidg_";
BLUEFOR_SFOR = "vn_b_men_sf_";
BLUEFOR_SOG  = "vn_b_men_sog_";

_currentDefCon = _this; //enum located at fn_calcualteDefCon

switch (_currentDefCon) do
{
    case DEFCON_SIX: { BLUEFOR_CIDG };
    case DEFCON_FIVE: { BLUEFOR_CIDG };
    case DEFCON_FOUR: { BLUEFOR_LRRP };
    case DEFCON_THREE: { BLUEFOR_LRRP };
    case DEFCON_TWO: { BLUEFOR_LRRP };
    case DEFCON_ONE:  { BLUEFOR_SFOR };
    default { throw "invalid DEFCON level" };
};