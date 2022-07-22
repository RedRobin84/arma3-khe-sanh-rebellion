params["_unit", "_faction"]; //enum located at init.sqf

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
    };
    default { throw "invalid BLUEFOR faction type" };
};
