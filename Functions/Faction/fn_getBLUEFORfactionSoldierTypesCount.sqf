//TOTAL UNIT TYPES FOR EACH BLUEFOR SOLDIER FACTION 
_BLUEFOR_SEAL_SOLDIER_TYPES_NR = 51;
_BLUEFOR_ARVN_SOLDIER_TYPES_NR = 31;
_BLUEFOR_LRRP_SOLDIER_TYPES_NR = 9;
_BLUEFOR_CIDG_SOLDIER_TYPES_NR = 22;
_BLUEFOR_SFOR_SOLDIER_TYPES_NR = 22;
_BLUEFOR_SOG_SOLDIER_TYPES_NR  = 27;

_faction = _this; //enum located at init.sqf
_nrOfTypes = 0;
switch (_faction) do
{
    case BLUEFOR_SEAL: { _nrOfTypes =  _BLUEFOR_SEAL_SOLDIER_TYPES_NR };
    case BLUEFOR_ARVN: { _nrOfTypes =  _BLUEFOR_ARVN_SOLDIER_TYPES_NR };
    case BLUEFOR_LRRP: { _nrOfTypes =  _BLUEFOR_LRRP_SOLDIER_TYPES_NR };
    case BLUEFOR_CIDG: { _nrOfTypes =  _BLUEFOR_CIDG_SOLDIER_TYPES_NR };
    case BLUEFOR_SFOR: { _nrOfTypes =  _BLUEFOR_SFOR_SOLDIER_TYPES_NR };
    case BLUEFOR_SOG:  { _nrOfTypes =  _BLUEFOR_SOG_SOLDIER_TYPES_NR };
    default { throw "invalid BLUEFOR faction type" };
};
diag_log(format["DEBUG::fn_getBLUEFORfactionSoldierTypesCount: %1", _nrOfTypes]);
//RETURN
_nrOfTypes;
