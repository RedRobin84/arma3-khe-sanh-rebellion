params["_unit", "_faction"]; //enum located at init.sqf

_skillType = "";
switch (_faction) do
{
    case BLUEFOR_SEAL: { // SpecOps good skill
    _unit setSkill ["aimingspeed", 0.3];
    _unit setSkill ["spotdistance", 0.3];
    _unit setSkill ["aimingaccuracy", 0.3];
    _unit setSkill ["aimingshake", 0.3];
    _unit setSkill ["spottime", 0.5];
    _unit setSkill ["spotdistance", 0.8];
    _unit setSkill ["commanding", 0.8];
    _unit setSkill ["general", 0.9];
    _skillType = "SpecOps";
    };
    case BLUEFOR_ARVN: { // Trained soldiers medium skill
    _unit setSkill ["aimingspeed", 0.2];
    _unit setSkill ["spotdistance", 0.2];
    _unit setSkill ["aimingaccuracy", 0.2];
    _unit setSkill ["aimingshake", 0.2];
    _unit setSkill ["spottime", 0.4];
    _unit setSkill ["spotdistance", 0.6];
    _unit setSkill ["commanding", 0.6];
    _unit setSkill ["general", 0.7];
    _skillType = "Medium skill";
    };
    case BLUEFOR_LRRP: { // Trained soldiers medium skill
    _unit setSkill ["aimingspeed", 0.2];
    _unit setSkill ["spotdistance", 0.2];
    _unit setSkill ["aimingaccuracy", 0.2];
    _unit setSkill ["aimingshake", 0.2];
    _unit setSkill ["spottime", 0.4];
    _unit setSkill ["spotdistance", 0.6];
    _unit setSkill ["commanding", 0.6];
    _unit setSkill ["general", 0.7];
    _skillType = "Medium skill";
    };
    case BLUEFOR_CIDG: { // Regular fair skill
    _unit setSkill ["aimingspeed", 0.15];
    _unit setSkill ["spotdistance", 0.15];
    _unit setSkill ["aimingaccuracy", 0.1];
    _unit setSkill ["aimingshake", 0.1];
    _unit setSkill ["spottime", 0.3];
    _unit setSkill ["spotdistance", 0.5];
    _unit setSkill ["commanding", 0.5];
    _unit setSkill ["general", 0.6];
    _skillType = "Regular skill";
    };
    case BLUEFOR_SFOR: { // SpecOps good skill
    _unit setSkill ["aimingspeed", 0.3];
    _unit setSkill ["spotdistance", 0.3];
    _unit setSkill ["aimingaccuracy", 0.3];
    _unit setSkill ["aimingshake", 0.3];
    _unit setSkill ["spottime", 0.5];
    _unit setSkill ["spotdistance", 0.8];
    _unit setSkill ["commanding", 0.8];
    _unit setSkill ["general", 0.9]; 
    _skillType = "SpecOps";
    };
    case BLUEFOR_SOG:  { // SpecOps good skill
    _unit setSkill ["aimingspeed", 0.3];
    _unit setSkill ["spotdistance", 0.3];
    _unit setSkill ["aimingaccuracy", 0.3];
    _unit setSkill ["aimingshake", 0.3];
    _unit setSkill ["spottime", 0.5];
    _unit setSkill ["spotdistance", 0.8];
    _unit setSkill ["commanding", 0.8];
    _unit setSkill ["general", 0.9];
    _skillType = "SpecOps";
    };
    case CIVILIAN_TYPE:  { // Rebels low skill
    _unit setSkill ["aimingspeed", 0.1];
    _unit setSkill ["spotdistance", 0.1];
    _unit setSkill ["aimingaccuracy", 0.05];
    _unit setSkill ["aimingshake", 0.05];
    _unit setSkill ["spottime", 0.2];
    _unit setSkill ["spotdistance", 0.4];
    _unit setSkill ["commanding", 0.4];
    _unit setSkill ["general", 0.3];
    _skillType = "Rebel low skill";
    };
    default { throw "invalid BLUEFOR faction type" };
};
diag_log(format["DEBUG::fn_setBLUEFORunitSkillBasedOnFaction: unit: %1, skill: %2, faction: %3", _unit, _skillType, _faction]);
//VOID
