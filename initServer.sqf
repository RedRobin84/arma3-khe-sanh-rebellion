_executeTime = 600; // 600 seconds, aka 10 minutes.
defcon = 0;
manpower = 0;

//AKA Influence
totalPOVL = 0;

//War level enum
defConSix = 6;
defConFive = 5;
defConFour = 4;
defConThree = 3;
defConTwo = 2;

0 spawn {
	call makeAllSpawnPointMarkersInvisible;
	call initWinConditionForSectorsEventHandlers;
	call populateEnemySectors;
	sleep 1;
	call initGUI;
	sleep 1;
	call displayInitialTask;
	sleep 5;
	call updateDefCon;
};

initWinConditionForSectorsEventHandlers = {
{
	[ _x, "ownerChanged", {
		params[ "_sector", "_owner", "_ownerOld" ];

		if ( _owner isEqualTo EAST ) then {
			call checkIfAllSectorsOwnedByEast;
			call calculateTotalPOVL;
			call updateGui;
		};
	}] call BIS_fnc_addScriptedEventHandler; 
}forEach ( true call BIS_fnc_moduleSector );
};

checkIfAllSectorsOwnedByEast = {
	_enemySectorNumber = west call BIS_fnc_moduleSector;
	systemChat("Number of owned WEST sectors " + str(_enemySectorNumber));
	if (_enemySectorNumber == 0) then {
		["end1", true, 20, true, false] call BIS_fnc_endMission;
	};
};

updateDefCon = {
	defcon = call calculateWarLevel;
	_msg = "DEFCON at level " + str(defcon);
	["Warning", [_msg]] call BIS_fnc_showNotification;
};

calculateWarLevel = {
	if (totalPOVL < 2) exitWith {
		defConSix
	};
	if (totalPOVL < 4) exitWith {
		defConFive
	};
	if (totalPOVL < 6) exitWith {
		defConFour
	};
	if (totalPOVL < 8) exitWith {
		defConThree
	};
	defConTwo
};

makeAllSpawnPointMarkersInvisible =  {
	{
	if (getMarkerType _x  == "mil_start" || getMarkerType _x  == "respawn_inf") 
	then { _x setMarkerAlpha 0;} 	
	} forEach allMapMarkers
};

displayInitialTask = {
	["ScoreAdded", ["Capture the ruins to the north"]] call BIS_fnc_showNotification;
};

populateEnemySectors = {
    _enemySectors = "west" call getSectorsOwnedByside;
    if (count _enemySectors == 0) exitwith {};
    {
	    _enemySector = _x;
	    _enemySectorname = _enemySector getVariable ["name", "undefined"];
	    if (_enemySectorname == "undefined") exitwith {
	        systemChat("Error: name not defined for sector" + _enemySectorname);
	    };
	    _maxEnemySectorunits = _enemySector getVariable["max", 0];
	    if (_maxEnemySectorunits == 0) then {
	        systemChat("WARN: max units not set for sector " + _enemySectorname);
	    };
	    _enemySectorspawnAreaMarkername = (_enemySector getVariable "name") + "_spawn";
	    _enemySectorspawnAreamarkerPos = getmarkerPos(_enemySectorspawnAreaMarkername);
	    if (_enemySectorspawnAreamarkerPos call markernotExist) exitwith {
	        systemChat("Error: spawn marker not found for sector" + _enemySectorname);
	    };
	    _allunitsinEnemySector = allunits inAreaArray _enemySectorspawnAreaMarkername;
	    _allEnemyunitsinSector = [_allunitsinEnemySector, {
	        side _x == west
	    }] call BIS_fnc_conditionalselect;
	    _numberOfEnemyunitsinSector = count(_allEnemyunitsinSector);
	    if ((_numberOfEnemyunitsinSector < _maxEnemySectorunits) && (east countside _allunitsinEnemySector) == 0) then {
	        _allStaticspawnPointsinEnemySector = allMapMarkers select {
	            ((getmarkerPos _x) inArea _enemySectorspawnAreaMarkername) && ((getmarkertype _x) == "respawn_inf")
	        };
	        if (count(_allStaticspawnPointsinEnemySector) == 0) exitwith {
	            systemChat("Error: No spawn points set for sector " + _enemySectorname);
	        };
	        _minEnemySectorunits = _enemySector getVariable["min", 0];
			_maxEnemySectorStaticUnits = _enemySector getVariable["maxStatic", 0];
	        _difference = _minEnemySectorunits - _numberOfEnemyunitsinSector;
	        _numberOfIterations = if (_difference > 0) then [{_difference}, { 0}];
			_i = 0;
			_currentWarLevel = call calculateWarLevel;
			_routeGroupName = _enemySectorName + "_route_group";
			_routeGroup = allGroups select { groupId _x == _routeGroupName };
			_routeGroupNumber = count(_routeGroup);
			if (_routeGroupNumber > 1) then {
				systemChat("ERROR: More than one route groups found for sector " + _enemySectorName);
			};
			if (_routeGroupNumber == 0) then {
				_routeGroup = createGroup[west, false];
				_routeGroup setGroupId[_routeGroupName];
				_routeGroup setBehaviour "SAFE";
				_routeWaypointNumber = _enemySector getVariable["waypointNumber", 0];
				for [_i = 0, _i < _routeWaypointNumber, _i = _i + 1] do {
					_routeWPMarkerName = _enemySectorName + "route" + str(_i);
					_routeWPPos = getMarkerPos(_routeWPMarkerName);
					_routeWPName = "wp_" + _routeWPMarkerName;
					_wp = _routeGroup addWaypoint[_routeWPName, 0];
					_wp setWaypointType "MOVE";
				};
			} else {
				_routeGroup = routeGroup select 0;
			};
	        while {_i  < _difference} do {
				_allUnoccupiedStaticspawnPointsinEnemySector = [_allStaticspawnPointsinEnemySector, {
					count(_allEnemyunitsinSector inAreaArray _x) == 0
				}] call BIS_fnc_conditionalselect;
				_unoccupiedStaticUnitNumber = count(_allUnoccupiedStaticspawnPointsinEnemySector);
				_occupiedStaticUnitNumber = _numberOfEnemyunitsinSector - _unoccupiedStaticUnitNumber;
				if (_maxEnemySectorStaticUnits > _occupiedStaticUnitNumber && _unoccupiedStaticUnitNumber != 0) then {
					_chosenspawnPoint = selectRandom _allUnoccupiedStaticspawnPointsinEnemySector;
					_chosenspawnPointPos = getmarkerPos(_chosenspawnPoint);
					_chosenspawnPointPos set [2, parseNumber(markertext _chosenspawnPoint)];
					_unittype = "vn_b_men_sog_09";
					systemChat("Creating unit " +_unittype + " on spawn point " + _chosenspawnPoint + " at sector " + _enemySectorname);
					_group = createGroup west;
					_group setBehaviour "SAFE";
					_unit = _group createUnit [_Unittype, _chosenspawnPointPos, [], 0, "NONE"];
					_unit setPosATL [_chosenspawnPointPos select 0, _chosenspawnPointPos select 1, _chosenspawnPointPos select 2];
					_chosenspawnPointdirection = markerDir _chosenspawnPoint;
					_unit setDir _chosenspawnPointdirection;
					_unit setFormDir _chosenspawnPointdirection;
					_allEnemyunitsinSector pushBack _unit;
					_i = _i + 1;
	        	};
				if (_i > _difference && _currentWarLevel >= defConFive) then {
					_sectorRouteSpawnPointName = _enemySectorname + "_route0";
					_sectorRouteSpawnPointPos = getmarkerPos(_sectorRouteSpawnPointName);
					_sectorRouteSpawnPointPos set [2, parseNumber(markertext _sectorRouteSpawnPointName)];
					_routeUnitType = "vn_b_men_sog_09";
					systemChat("Creating route unit " +_routeUnitType + " at sector " + _enemySectorname);
					_routeUnit = _routeGroup createUnit [_routeUnitType, _sectorRouteSpawnPointPos, [], 0, "NONE"];
					_i = _i + 1;
				};
	    };
	};
	} forEach _enemySectors;
};

markerNotExist = {
	_position = _this;
	(_position select 0) == 0 && (_position select 1) == 0 && (_position select 2) == 0
};

getSectorsOwnedBySide = {
	_sideName = _this;
	_allSectors = true call BIS_fnc_moduleSector;
	_sideSectors = [_allSectors, { str(_x getVariable "owner") == _sideName }] call BIS_fnc_conditionalSelect;
	_sideSectorsCount = count _sideSectors;
	if (_sideSectorsCount == 0) exitwith {
		systemChat ("No sector owned by " + _sideName + " found. Exiting.");
		[]
		};
	systemChat ("Found " + str(_sideSectorsCount) + " sector(s) owned by " + str(_sideName));
	_sideSectors
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
call _updateDefCon;
};



updateManpower = {
 call calculateTotalPOVL;
 if ((manpower + totalPOVL) > totalPOVL) then {
	 manpower = totalPOVL; //TODO: send info manpower cap reached to player
	 hint("Manpower limit reached. Capture more POI's to extend manpower capacity");
 } else {
	  manpower = manpower + totalPOVL;
 };
};

showReport = {
	strToDisplay = "Manpower: " + str (manpower) + " Influence: " + str (totalPOVL);
	["ScoreAdded", [strToDisplay]] call BIS_fnc_showNotification;
};

globalScriptsRun = {
	call updateManpower;
	call showReport;

	defcon = _defcon - 1;
	if (defcon == 0) then {
		call attackRandomSettlement;
	};

	call populateEnemySectors;
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
		call globalScriptsRun; // call the function.
		realTickTime = 0; // reset the timer back to 0 to allow counting to 300 again.
	};
	uiSleep 1; // sleep for one second.
	ticksEnd = round(diag_TickTime); // tick time end.
	ticksEndLoop = round(ticksEnd - ticksBegin); // get 'real' (rounded) tick time due to loop latency/calls.
	realTickTime = realTickTime + ticksEndLoop; // increase the tick counter.
};