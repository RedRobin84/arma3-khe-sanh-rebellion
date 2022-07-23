while {true} do // loops for entire duration that mission/server is running.
{
    ticksBegin = round(diag_TickTime); // tick time begin.
    if (realTickTime >= executeTime) then // check _realTickTime against executeTime.
    {
        diag_log("INFO::gameTickLoop: Executing regular computations");
        totalTicks = totalTicks + 1;
        _totalPOVL = call REB_fnc_calculateTotalPOVL;
        _currentDefcon = _totalPOVL call REB_fnc_calculateDefCon;
        call REB_fnc_generateManpower;
        sleep 5;
        if (nextAttackedSectorName != "") then {
            _nextAttackedSector = missionNamespace getVariable [nextAttackedSectorName, objNull];
            if ((_nextAttackedSector getVariable ("sector_" + str(_nextAttackedSector) + "_controller")) == EAST) then {
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
            nextAttackedSectorName = call getRandomEastSectorName;
            if (nextAttackedSectorName != "") then {
                 _msg = format["We have a report of incoming attack on sector %1.", nextAttackedSectorName];
                [_msg, MSG_TYPE_WARNING] call REB_fnc_displayMessage;
                totalTicks = 0;
            };
        };
        _totalPOVL call populateEnemySectors;
        sleep 5;
       _currentDefcon call REB_fnc_displayCurrentDefCon;

       realTickTime = 0; // reset the timer back to 0 to allow counting to 300 again.
    };
    uiSleep 1; // sleep for one second.
    ticksEnd = round(diag_TickTime); // tick time end.
    ticksEndLoop = round(ticksEnd - ticksBegin); // get 'real' (rounded) tick time due to loop latency/calls.
    realTickTime = realTickTime + ticksEndLoop; // increase the tick counter.
};