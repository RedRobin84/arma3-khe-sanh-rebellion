diag_log("DEBUG::fn_updateDefConGUI: executing...");
_defcon = _this;
(uiNameSpace getVariable "myUI_DefCon") ctrlSetText format["DEFCON: %1", _defcon];
