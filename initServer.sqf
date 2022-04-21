_executeTime = 60; // 300 seconds, aka 5 minutes.
manpower = 1;
totalPOVL = 0;


0 spawn {
	sleep 2;
	call displayInitialTask;
	sleep 3;
	call attackRandomSettlement;
};

displayInitialTask = {
	["ScoreAdded", ["Capture the ruins to the north"]] call BIS_fnc_showNotification;
};

calculateTotalPOVL = {
	newPOVL = 0;
	{if (str(_x getVariable "owner") == "EAST") then {newPOVL = newPOVL + parseNumber(_x getVariable "scoreReward")}} count allSectors;
	totalPOVL = newPOVL;
};

recruitUnit = {
	if (manpower < 1) exitWith { hint "Not enough manpower."; };
	myUnit = nil;
	"vn_o_men_vc_local_16" createUnit [position player, group player, "removeAllWeapons this;"];
	manpower = manpower - 1;
};

attackRandomSettlement = {
_units = [
	"vn_b_men_sog_09",0.5, "vn_b_men_sog_10",0.4,"vn_b_men_sog_04",0.1
];
_allSectors = true call BIS_fnc_moduleSector;
if (count _allSectors == 0) exitwith {systemChat "No sector found. Exiting.";};
systemChat str(count(_allSectors));
_ownedSectors = [_allSectors, { str(_x getVariable "owner") == "EAST" }] call BIS_fnc_conditionalSelect;
if (count _ownedSectors == 0) exitwith {systemChat "No owned sector found. Exiting.";};
systemChat str(count(_ownedSectors));
_randomOwnedSector = selectRandom _ownedSectors;
systemChat "random sector selected";
_randomOwnedSectorName = _randomOwnedSector getVariable "name";
systemChat _randomOwnedSectorName;
_randomSpawnPointName = _randomOwnedSectorName + str(floor(random 3));
systemChat str(_randomSpawnPointName);
_randomSpawnPointNamePos = getMarkerPos(_randomSpawnPointName);
_grp = createGroup [west,true];
	for "_i" from 0 to 3 do {
		selectRandomWeighted _units createUnit [_randomSpawnPointNamePos, _grp];
	};
_randomOwnedSectorPos = getPos _randomOwnedSector;
systemChat str(_randomOwnedSectorPos);
new_wp = _grp addWaypoint [_randomOwnedSectorPos, 0];
new_wp setWaypointType "GUARD";
warningMsg = "Enemy is attacking " + _randomOwnedSectorName;
[warningMsg, 1] call BIS_fnc_3DENNotification;
["Warning", [warningMsg]] call BIS_fnc_showNotification;
};



updateManpower = {
 allSectors = true call BIS_fnc_moduleSector;
 call calculateTotalPOVL;
 manpower = manpower + totalPOVL;
};

showReport = {
	strToDisplay = "Manpower: " + str (manpower) + "TotalPOVL: " + str (totalPOVL);
	["ScoreAdded", [strToDisplay]] call BIS_fnc_showNotification;
};

_globalScriptsRun = {
	call updateManpower;
	call showReport;
};

realTickTime = 0; // declare the local variable for the loop compare.
 
while {true} do // loops for entire duration that mission/server is running.
{
	ticksBegin = round(diag_TickTime); // tick time begin.
	if (realTickTime >= _executeTime) then // check _realTickTime against executeTime.
	{
		call _globalScriptsRun; // call the function.
		realTickTime = 0; // reset the timer back to 0 to allow counting to 300 again.
	};
	uiSleep 1; // sleep for one second.
	ticksEnd = round(diag_TickTime); // tick time end.
	ticksEndLoop = round(ticksEnd - ticksBegin); // get 'real' (rounded) tick time due to loop latency/calls.
	realTickTime = realTickTime + ticksEndLoop; // increase the tick counter.
};