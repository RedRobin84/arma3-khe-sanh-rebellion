_CONTAINER_GENERATOR_FLAG_DEFAULT_VALUE = false;

    _container = _this;
    _container addEventHandler
    [
        "ContainerOpened", {
            params ["_container", "_unit"];
            _generated = _container getVariable[CONTAINER_GENERATOR_FLAG, _CONTAINER_GENERATOR_FLAG_DEFAULT_VALUE];
            if (_generated == false) then {
                _container call REB_fnc_spawnGeneralLoot;
                _container setVariable[CONTAINER_GENERATOR_FLAG, true];
                }
        }
    ];