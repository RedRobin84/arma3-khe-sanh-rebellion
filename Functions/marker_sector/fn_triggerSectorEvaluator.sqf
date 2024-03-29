_trigger = _this;
_triggerName = _trigger call BIS_fnc_objectVar;
private _sectorController = _trigger call REB_fnc_getSectorController;

/*******************************************************************************************************************/
/*                                         Unit Counting of Sector Area                                            */
/*******************************************************************************************************************/
private _unitsArray = allUnits inAreaArray _trigger;

private _blufor = 0;
private _opfor = 0;
private _indfor = 0;
//counts and stores the units of each side in the trigger area
for [{_count1 = 0}, {_count1 < (count _unitsArray)}, {_count1 = _count1 + 1}] do
{
    private _unit = _unitsArray select _count1;
    private _side = side _unit;
    if (_side isEqualTo west) then {_blufor = _blufor + 1;};
    if (_side isEqualTo east) then {_opfor = _opfor + 1;};
    if (_side isEqualTo independent) then {_indfor = _indfor + 1;};
};

/*******************************************************************************************************************/
/*                                             Side Control Evaluation                                             */
/*******************************************************************************************************************/
//generates arrays for friendly and enemy sides
private _friendArray = [_sectorController];
private _enemyArray = [west,east,independent];
_enemyArray = _enemyArray - [_sectorController];
//handles a west - independent alliance or truce
if (!(_sectorController isEqualTo east) && ([west,independent] call BIS_fnc_sideIsFriendly)) then 
{
    _enemyArray = _enemyArray - [west,independent];
    if(_sectorController isEqualTo west) then {_friendArray = _friendArray + [independent];};
    if(_sectorController isEqualTo independent) then {_friendArray = _friendArray + [west];};
};
//handles a east - independent alliance or truce
if (!(_sectorController isEqualTo west) && ([east,independent] call BIS_fnc_sideIsFriendly)) then 
{
    _enemyArray = _enemyArray - [east,independent];
    if(_sectorController isEqualTo east) then {_friendArray = _friendArray + [independent];};
    if(_sectorController isEqualTo independent) then {_friendArray = _friendArray + [east];};
};
// handles a sideEmpty to start off the mission
if(_sectorController isEqualTo sideEmpty) then
{
    _friendArray = [sideEmpty];
    _enemyArray = [west,east,independent];
};
//preparations to tally friendly and enemy forces
private _friendCount = 0;
private _enemyCount = 0;
//totals up the friendly units
for [{_count2 = 0}, {_count2 < (count _friendArray)}, {_count2 = _count2 + 1}] do
{
    private _side = _friendArray select _count2;
    if (_side isEqualTo west) then {_friendCount = _friendCount + _blufor;};
    if (_side isEqualTo east) then {_friendCount = _friendCount + _opfor;};
    if (_side isEqualTo independent) then {_friendCount = _friendCount + _indfor;};
};
//totals up the enemy units
for [{_count3 = 0}, { _count3 < (count _enemyArray)}, { _count3 = _count3 + 1}] do
{
    private _side = _enemyArray select _count3;
    if (_side isEqualTo west) then {_enemyCount = _enemyCount + _blufor;};
    if (_side isEqualTo east) then {_enemyCount = _enemyCount + _opfor;};
    if (_side isEqualTo independent) then {_enemyCount = _enemyCount + _indfor;};
};
/*******************************************************************************************************************/
/*                                              Return Handling                                                    */
/*******************************************************************************************************************/
//handles no units
if((_enemyCount == 0) && (_friendCount == 0)) exitWith {false};

//handles situations where friendly forces are present:
//evaluates for a sizably larger enemy contingent (informs the trigger the battle is over)
if((_friendCount > 0) && ((_enemyCount/(_friendCount+_enemyCount)) > 0.9)) exitWith {false};
//evaluates for a sizably larger friendly contingent (informs the trigger the battle is over)
if((_friendCount > 0) && (_enemyCount/(_friendCount+_enemyCount)) < 0.1) exitWith {false};
//informs the trigger that a battle is occuring
if((_friendCount > 0) && (_enemyCount > 0)) exitWith {true};

//handles situations where the friendly forces are no longer present
_friendPresent = _trigger getVariable ["friend_present_" + _triggerName, true];
if((_friendPresent) && (_friendCount == 0)) exitWith
{
    //this little setup allows for the trigger to fire and then deactivate on next evaluation
    //which handles the edge case where you have killed the last unit before entering the sector
    _trigger setVariable ["friend_present_" + _triggerName, false];
    true
};


if(true) exitWith {false};
