_executeTime = 600; // 600 seconds, aka 10 minutes.
manpower = 0;

//AKA Influence
totalPOVL = 0;


0 spawn {
	call initGUI;
	call makeAllSpawnPointMarkersInvisible;
	sleep 2;
	call displayInitialTask;
};

makeAllSpawnPointMarkersInvisible =  {
	{
	if (getMarkerType _x  == "mil_start") then { _x setMarkerAlpha 0;} 	
	} forEach allMapMarkers
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
	_randomUnitId = str(floor(random 32) + 1);
	if (parseNumber _randomUnitId < 10) then {
		_randomUnitId = "0" + _randomUnitId;
	};
	systemChat ("Random recruit ID: " + _randomUnitId);
	_myUnitName = "vn_c_men_" + _randomUnitId;
	_myUnitName createUnit [position player, group player, "removeAllAssignedItems this; this call addActionStayHere; this call addRemoveAllActionsFromCorpseHandler"];

	call decreaseManpower;
};

decreaseManpower = {
	if (manpower > 0) then {
		manpower = manpower - 1;
	};
};

addRemoveAllActionsFromCorpseHandler = {
	params["_unit"];
	_unit addEventHandler ["Killed", {
		params ["_unit"];
		removeAllActions _unit;
	}];
};

addActionStayHere = {
	params["_unit"];
	_unit addAction["Stay here.", removeUnit, [_unit]];
};

removeUnit = {
	params["_unit"];
	[_unit] joinSilent grpNull;
	removeAllActions _unit;
	_unit addAction["Join me.", joinPlayer, [_unit]];
};

joinPlayer = {
	params["_unit"];
	removeAllActions _unit;
	_unit call addActionStayHere;
	[_unit] join (group player);
};

attackRandomSettlement = {
_units = [
	"vn_b_men_sog_09",0.5, "vn_b_men_sog_10",0.4,"vn_b_men_sog_04",0.1 //random like in recruitUnit instead of an array
];
_allSectors = true call BIS_fnc_moduleSector;
_ownedSectors = [_allSectors, { str(_x getVariable "owner") == "EAST" }] call BIS_fnc_conditionalSelect;
if (count _ownedSectors == 0) exitwith {systemChat "No owned sector found. Exiting.";}; //TODO: replace with getSectorsOwnedBySide
systemChat str(count(_ownedSectors));
_randomOwnedSector = selectRandom _ownedSectors;
systemChat "random sector selected";
_randomOwnedSectorName = _randomOwnedSector getVariable "name";
_randomSpawnPointName = _randomOwnedSectorName + str(floor(random 3));
systemChat str(_randomSpawnPointName);
_randomSpawnPointNamePos = getMarkerPos(_randomSpawnPointName);
_grp = createGroup [west,true];
	for "_i" from 0 to 2 do {
		selectRandomWeighted _units createUnit [_randomSpawnPointNamePos, _grp];
	};
_randomOwnedSectorPos = getPos _randomOwnedSector;
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
	strToDisplay = "Manpower: " + str (manpower) + " Influence: " + str (totalPOVL);
	["ScoreAdded", [strToDisplay]] call BIS_fnc_showNotification;
};

_globalScriptsRun = {
	call updateManpower;
	call showReport;
	call updateGui;
};

initGUI = {
	("ManpowerTitle_layer" call BIS_fnc_rscLayer) cutRsc ["ManpowerTitle","PLAIN"];
	("TotalPOVL_layer" call BIS_fnc_rscLayer) cutRsc ["TotalPOVLTitle","PLAIN"];
};

updateGUI = {
	(uiNameSpace getVariable "myUI_manpower") ctrlSetText format["Manpower: %1",manpower];
	(uiNameSpace getVariable "myUI_totalPOVL") ctrlSetText format["Influence: %1",totalPOVL];
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