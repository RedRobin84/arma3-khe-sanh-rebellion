diag_log("DEBUG::fn_displayCurrentDefCon: executing...");
_defcon = _this;
_msgAddonBasedOnDefconLevel = switch (_defcon) do {
    case DEFCON_SIX:  { 
        _msgAddonBasedOnDefconLevel = "CIDG is guarding our villages. Death to traitors!" ;
        playMusic "KheSanhDefconSix";
        };
    case DEFCON_FIVE: { 
        _msgAddonBasedOnDefconLevel = "We've spotted enemy patrols around our towns!";
        playMusic "KheSanhDefconFive";
        };
    case DEFCON_FOUR: { 
        _msgAddonBasedOnDefconLevel = "South army started replacing weak defending CIDG forces.";
        playMusic "KheSanhDefconFour";
        };
    case DEFCON_THREE:{ 
        _msgAddonBasedOnDefconLevel = "American LRRP forces gets involved in.";
        playMusic "KheSanhDefconThree";
        };
    case DEFCON_TWO:  { 
        _msgAddonBasedOnDefconLevel = "SOG is taking over the defense.";
        playMusic "KheSanhDefconTwo";
        };
    case DEFCON_ONE:  { 
        _msgAddonBasedOnDefconLevel = "Special forces operation in the region!";
        playMusic "KheSanhDefconOne";
        };
    default { throw "Illegal defcon type." };
};
_msg = format["DEFCON at level %1. %2", defcon, _msgAddonBasedOnDefconLevel];
[_msg, MSG_TYPE_WARNING] call REB_fnc_displayMessage;
