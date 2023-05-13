_container = _this;
_container addEventHandler

    [
        "ContainerOpened", {
            params ["_container", "_unit"];
                           

            _generated = _container getVariable[CONTAINER_GENERATOR_FLAG, false];
 systemChat(str(CONTAINER_GENERATOR_FLAG_DEFAULT_VALUE));
            if (_generated == false) then {
                diag_log(format["DEBUG::fn_addLootSpawnEvent: Generating loot for container %1", _container]);
                _container call REB_fnc_spawnGeneralLoot;
                _container setVariable[CONTAINER_GENERATOR_FLAG, true];
                }
        }
    ];
    //VOID
    