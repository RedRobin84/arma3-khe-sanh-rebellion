LAST_TIMESTAMP_VAR_NAME = "lastTimestamp";

    _container = _this;
    _container addEventHandler
    [
        "ContainerOpened", {
            params ["_container", "_unit"];
                _currentTimestamp = round(diag_TickTime);
            if ([_container, _currentTimestamp] call moreThanOneHourPassedSinceLastOpened) then {
                _container call REB_fnc_spawnGeneralLoot;
                _container setVariable[LAST_TIMESTAMP_VAR_NAME, _currentTimestamp];
    }
        }
    ];

moreThanOneHourPassedSinceLastOpened = {
    params ["_container", "_currentTimestamp"];
    _lastTimestamp = _container getVariable[LAST_TIMESTAMP_VAR_NAME, -3600];
    //RETURN
    ((_currentTimestamp - _lastTimestamp) >= 3600)
};
