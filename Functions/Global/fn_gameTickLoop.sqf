while {true} do // loops for entire duration that mission/server is running.
{
    ticksBegin = round(diag_TickTime); // tick time begin.
    if (realTickTime >= executeTime) then // check _realTickTime against executeTime.
    {
        totalTicks = totalTicks + 1;
        _totalPOVL = call REB_fnc_calculateTotalPOVL;
        _currentDefcon = _totalPOVL call REB_fnc_calculateDefCon;
        _currentDefcon call REB_fnc_updateDefConGUI;
        call REB_fnc_generateManpower;
        if (nextAttackedSectorName != "") then {
            diag_log(format["DEBUG::gameTickLoop: Commencing attack on sector %1", nextAttackedSectorName]);
            _nextAttackedSector = missionNamespace getVariable [nextAttackedSectorName, objNull];
            if ((_nextAttackedSector call REB_fnc_getSectorController) == EAST) then {
                [_totalPOVL, _nextAttackedSector] call attackRandomSettlement;
                _warningMsg = "Enemy is attacking " + nextAttackedSectorName;
                [_warningMsg, MSG_TYPE_WARNING] call REB_fnc_displayMessage;
            } else {
                _msg = format["Sector %1 is not in our hands anymore. Enemy cancelled his attack.", nextAttackedSectorName];
                [_msg, MSG_TYPE_SCORE_ADDED] call REB_fnc_displayMessage;
            };
            nextAttackedSectorName = "";
        };
        if (totalTicks >= _currentDefcon) then {
            nextAttackedSectorName = call REB_fnc_getRandomEastSectorName;
            diag_log(format["DEBUG::gameTickLoop: Generating sector for attack in next game tick: %1", nextAttackedSectorName]);
            if (nextAttackedSectorName != "") then {
                 _msg = format["We have a report of incoming attack on sector %1.", nextAttackedSectorName];
                [_msg, MSG_TYPE_WARNING] call REB_fnc_displayMessage;
                totalTicks = 0;
            };
        };
        _totalPOVL call REB_fnc_populateEnemySectors;
        sleep 5;
       _currentDefcon call REB_fnc_displayCurrentDefCon;

       realTickTime = 0; // reset the timer back to 0 to allow counting to 300 again.
       diag_log(format["INFO::gameTickLoop: Executed regular computations. TotalTicks: %1, DEFCON: %2, _totalPOVL: %3", totalTicks, _currentDefcon, _totalPOVL]);
    };
    uiSleep 1; // sleep for one second.
    ticksEnd = round(diag_TickTime); // tick time end.
    ticksEndLoop = round(ticksEnd - ticksBegin); // get 'real' (rounded) tick time due to loop latency/calls.
    realTickTime = realTickTime + ticksEndLoop; // increase the tick counter.
};