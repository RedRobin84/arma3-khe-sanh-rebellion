diag_log("DEBUG::fn_displayCurrentDefCon: executing...");
_defcon = _this;
_msg = "DEFCON at level " + str(_defcon);
[_msg, MSG_TYPE_WARNING] call REB_fnc_displayMessage;
