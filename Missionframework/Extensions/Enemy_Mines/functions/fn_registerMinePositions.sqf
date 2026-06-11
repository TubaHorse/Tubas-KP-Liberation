/*
    File: fn_registerMinePositions.sqf
    Author: PiG13BR - https://github.com/PiG13BBR
    Date: 10/06/2026
    Last Update: 10/06/2026
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
       Register mine position at mission start

    Parameter(s):
        _sector - sector to find position for mines [STRING]

    Returns:
        -
*/
params["_sector"];

private _sector = _x;
if (_sector in KPLIB_sectorMinesPositionsHash) then {continue}; // Skip sectors with mines pos

[format["Trying to find mine positions for sector %1 (%2)", markerText _sector, _sector], "MINE POSITIONS"] call KPLIB_fnc_log;

// AP mines positions
private _minesApPos = [];
private _lastPos = markerPos _sector;
for "_i" from 1 to 6 do {
    private _pos = [[[markerPos _sector, 250]], [], {
        //((_this nearEntities [["LandVehicle"], 10]) isEqualTo []) 
        (_this isFlatEmpty [-1, -1, 1, 10, 0] isNotEqualTo [])
        && ((_lastPos distance2d _this) > 100)
        && {([200, _this] call KPLIB_fnc_getNearestSector) isEqualTo ""}
        && {!isOnRoad _this}
        && {(_minesApPos findIf {(_x distance2D _this) < 100}) < 0}
        && {nearestTerrainObjects [_this, ["building", "house"], 50] isEqualTo []}
        && {_this inArea KPLIB_centerArea}
    }] call BIS_fnc_randomPos;
    
    if (_pos isEqualTo [0,0]) then {continue};
    _lastPos = _pos;

    _minesApPos pushBack _pos;
};

// AT mines positions
private _minesATPos = [];
private _lastPos = markerPos _sector;
for "_i" from 1 to 3 do {
    private _pos = [[[markerPos _sector, 250]], [], {
        (isOnRoad _this) 
        //&& ((_this nearEntities [["LandVehicle"], 10]) isEqualTo []) 
        && (_this isFlatEmpty [-1, -1, 1, 10, 0] isNotEqualTo []) 
        && (_this distance2d (markerPos _sector) > 200)
        && ((_lastPos distance2d _this) > 100)
        && {(_minesATPos findIf {(_x distance2D _this) < 100}) < 0}	  
        && {([200, _this] call KPLIB_fnc_getNearestSector) isEqualTo ""}
        && {_this inArea KPLIB_centerArea}
        //&& {nearestTerrainObjects [_this, ["Tree", "Rock", "Rocks"], 1] isEqualTo []}
    }] call BIS_fnc_randomPos;
    
    if (_pos isEqualTo [0,0]) then {continue};
    _lastPos = _pos;

    _minesATPos pushBack _pos;
};

KPLIB_sectorMinesPositionsHash set [_sector, [_minesApPos, _minesATPos]];