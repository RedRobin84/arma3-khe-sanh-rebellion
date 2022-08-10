addMissionEventHandler ["Loaded", {
    params ["_saveType"];
    
    0 spawn {
        sleep 2;
        call REB_fnc_initGUI;
        defconThreshold call REB_fnc_updateDefConGUI;
        };
}];
diag_log("DEBUG::registerOnGameLoadScripts: GUI refresh after game load registered.");
//VOID
