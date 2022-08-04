//CONSTANTS
executeTime = 40; // 600 seconds, aka 10 minutes. Used in fn_gameTickLoop
MAX_SOLDIERS_MULTIPLIER = 4; //Default multiplier for max soldiers per sector value
NUMBER_OF_ATTACK_SPAWN_POINTS = 3; //Number of spawn markers for AI per gametick attacking
DEFAULT_DEFCON = 6;
SECTOR_ENEMY_UNITS_DEFAULT_INCREASE = 1;

//PRIVATE GLOBALS
currentTimestamp = round(time);
totalTicks = 3; //Storing gameticks. Resets after AI attack.
nextAttackedSectorName = "";
SECTOR_MANPOWER_DEFAULT_DECREMENT = 1;
MAX_NUMBER_OF_BOAT_CREW = 5;

//STRING CONSTANTS
INTRO_INFO_MSG = "Capture all settlements to win. The main objective is Nabo Camp military outpost.";
INTRO_INFO_MSG2 = "Begin with capturing ruins to the north-east.";
INTRO_HINT = "You may find some equipment in your shack.";

MANPOWER_VAR_NAME = "manpower";
CONTAINER_GENERATOR_FLAG = "generated";
SECTOR_INVENTORY_VAR_SUFFIX = "_inventory";

//BLUEFOR FACTIONS PREFIXES
BLUEFOR_SEAL = "vn_b_men_seal_";
BLUEFOR_ARVN = "vn_b_men_army_";
BLUEFOR_LRRP = "vn_b_men_lrrp_";
BLUEFOR_CIDG = "vn_b_men_cidg_";
BLUEFOR_SFOR = "vn_b_men_sf_";
BLUEFOR_SOG  = "vn_b_men_sog_";

//CIVILIAN
CIVILIAN_TYPE = "vn_c_men_";
CIVILIAN_TYPES_COUNT = 32;

//War level enum
DEFCON_SIX = 6;
DEFCON_FIVE = 5;
DEFCON_FOUR = 4;
DEFCON_THREE = 3;
DEFCON_TWO = 2;
DEFCON_ONE = 1;

//Message types (displayMessage fnc)
MSG_TYPE_SCORE_ADDED = "ScoreAdded";
MSG_TYPE_WARNING = "Warning";

0 spawn {
    call REB_fnc_makeAllSystemMarkersInvisible;
    call REB_fnc_registerOnGameLoadScripts;
};