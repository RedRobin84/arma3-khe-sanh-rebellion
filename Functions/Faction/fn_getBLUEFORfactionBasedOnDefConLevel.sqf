//BLUEFOR FACTIONS PREFIXES
BLUEFOR_SEAL = "vn_b_men_seal_";
BLUEFOR_ARVN = "vn_b_men_army_";
BLUEFOR_LRRP = "vn_b_men_lrrp_";
BLUEFOR_CIDG = "vn_b_men_cidg_";
BLUEFOR_SFOR = "vn_b_men_sf_";
BLUEFOR_SOG  = "vn_b_men_sog_";

_currentDefCon = _this;

switch (_currentDefCon) do
{
	case DEFCON_SIX: { _BLUEFOR_SEAL_SOLDIER_TYPES_NR };
	case BLUEFOR_ARVN: { _BLUEFOR_ARVN_SOLDIER_TYPES_NR };
	case BLUEFOR_LRRP: { _BLUEFOR_LRRP_SOLDIER_TYPES_NR };
	case BLUEFOR_CIDG: { _BLUEFOR_CIDG_SOLDIER_TYPES_NR };
	case BLUEFOR_SFOR: { _BLUEFOR_SFOR_SOLDIER_TYPES_NR };
	case BLUEFOR_SOG:  { _BLUEFOR_SOG_SOLDIER_TYPES_NR };
	default { throw "invalid DEFCON level" };
};