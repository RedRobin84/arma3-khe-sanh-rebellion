       diag_log(format["INFO::gameTickLoop: Executing regular computations. currentTimeStamp: %1, running every %2 seconds, iteration: %3", currentTimeStamp, executeTime, floor(currentTimeStamp / executeTime)]);
        totalTicks = totalTicks + 1;
        _totalPOVL = call REB_fnc_calculateTotalPOVL;
        _totalPOVL call REB_fnc_calculateDefCon;
        call REB_fnc_generateManpower;
        sleep 10;
        if (nextAttackedSectorVar != "") then {
            diag_log(format["DEBUG::gameTickLoop: Commencing attack on sector %1", nextAttackedSectorVar]);
            _nextAttackedSector = missionNamespace getVariable [nextAttackedSectorVar, objNull];
            _nextAttackedSectorName = _nextAttackedSector call REB_fnc_getSectorName;
            if ((_nextAttackedSector call REB_fnc_getSectorController) == EAST) then {
                [_totalPOVL, _nextAttackedSector] call attackRandomSettlement;
                _warningMsg = "Enemy is attacking " + _nextAttackedSectorName;
                [_warningMsg, MSG_TYPE_WARNING] call REB_fnc_displayMessage;
                playMusic "KheSanhAttackBegins";
            } else {
                _msg = format["Sector %1 is not in our hands anymore. Enemy cancelled his attack.", nextAttackedSectorVar];
                [_msg, MSG_TYPE_SCORE_ADDED] call REB_fnc_displayMessage;
            };
            nextAttackedSectorVar = "";
        };
        if (totalTicks >= defconThreshold) then {
            _randomSectorOwnedByEast = call REB_fnc_getRandomEastSector;
            nextAttackedSectorVar = _randomSectorOwnedByEast call REB_fnc_getSectorVarName;
            _nextAttackedSectorName = _randomSectorOwnedByEast call REB_fnc_getSectorName;
            diag_log(format["DEBUG::gameTickLoop: Generating sector for attack in next game tick: %1", nextAttackedSectorVar]);
            if (nextAttackedSectorVar != "") then {

                _msg = format["We have a report of incoming attack on sector %1.", _nextAttackedSectorName];
                [_msg, MSG_TYPE_WARNING] call REB_fnc_displayMessage;
                playMusic "KheSanhAttackSoon";
                totalTicks = 0;
            };
        };
        _totalPOVL call REB_fnc_populateEnemySectors;

       realTickTime = 0; // reset the timer back to 0 to allow counting to 300 again.
       diag_log(format["INFO::gameTickLoop: Finished. TotalTicks: %1, DEFCON: %2, _totalPOVL: %3", totalTicks, defconThreshold, _totalPOVL]);