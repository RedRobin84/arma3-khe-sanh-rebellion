addMissionEventHandler ["Loaded", {
    params ["_saveType"];
    
    0 spawn {
        sleep 2;
        call REB_fnc_initGUI;
        };
}];
diag_log("DEBUG::registerOnGameLoadScripts: GUI refresh after game load registered.");
//VOID
