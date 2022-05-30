_LAST_TIMESTAMP_VAR_NAME = "lastTimestamp";

/** RANDOM LOOT CHANCES
PISTOLS = 			30 %
SHOTGUN = 			15 %
CARABINES = 		15 %
SUB-MACHINE GUNS = 	15 %
ASSAULT RIFLES = 	10 %
MACHINE GUNS = 		5 %
AT / AA LAUNCHER = 	5 %
ACCESSORIES      =  5 %
**/
_RANDOM_LOOT_ARRAY = [
	[], //Pistols
	[], //Shotguns
	[], //Carabines
	[], //SubMGuns
	[], //Assault
	[], //MachineG
	[], //AT/AA
	[]  //Accessories
];

addBasicLootGeneratorEvent = {
	_container = _this;
	_container addEventHandler
	[
		"ContainerOpened", {
			params ["_container", "_unit"];
			if (_container call _moreThanOneHourPassedSinceLastOpened) {

				_container setVariable[_LAST_TIMESTAMP_VAR_NAME, _currentTimestamp];
	}
		}
	];
};

_moreThanOneHourPassedSinceLastOpened = {
	_container = _this;
	_lastTimestamp = _container getVariable[_LAST_TIMESTAMP_VAR_NAME, 0];
	_currentTimestamp = round(diag_TickTime);
	//RETURN
	((_currentTimestamp - _lastTimestamp) >= 3600)
};

_generateRandomLoot = {

};