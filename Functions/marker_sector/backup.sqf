
_unitsArray = allUnits inAreaArray _trigger;
_westCount = { side _x == west } count _unitsArray;
_eastCount = { side _x == east } count _unitsArray;
_owner = _trigger getVariable["owner", west];
systemChat("owner: " + str _owner);
_sectorState = _trigger getVariable["sectorState", 10];
systemChat("state: " + str _sectorState);
systemChat("west: " + str _westCount + " east: " + str _eastCount);
if (_westCount > _eastCount) then {
    if (_sectorState >= 10) then {
        _trigger setVariable["owner", "west"];
        hint(format["Sector %s captured by enemy.", _sectorID]);
    } else {
        _trigger setVariable["sectorState", _sectorState + 1];
    };
};

if (_westCount == 0) then {
    if (_sectorState <= 0) then {
        _trigger setVariable["owner", "east"];
        hint(format["Sector %1 captured.", _sectorID]);
    } else {
        _trigger setVariable["sectorState", _sectorState - 1];
        systemChat("Capturing...");
    };
};

false