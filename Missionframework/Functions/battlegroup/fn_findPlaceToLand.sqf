/*
    File: fn_findPlaceToLand.sqf
    Author: PiG13BR - https://github.com/PiG13BBR
    Date: 08/06/2026
    Last Update: 08/06/2026
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Find a situable place to land a helicopter

    Parameter(s):
        _targetPos - position to land [POSITION, defaults to [0,0,0]]
        _radius - notify players [NUMBER, defaults to 700]

    Returns:
        Position to land [POSITION]
*/
params[["_targetPos",[0,0,0],[[]],[2,3]], ["_radius", 700, [0]]];

if (_targetPos isEqualTo [0,0,0]) exitWith {["No position provided"] call BIS_fnc_error; [0,0]};

// Find land area
private _landArea = [0,0];
private _tries = 0;
while {_tries < 4} do {
    _tries = _tries + 1;
    _landArea = [[[_targetPos, _radius]], [], 
    {
        (_this distance2D _targetPos > (_radius/3)) && 
        (_this distance2D _targetPos < (_radius*0.8)) && 
        {_this isFlatEmpty [15, -1, -1, -1, 0, false] isNotEqualTo []} &&
        {([_this, 150, KPLIB_side_player] call KPLIB_fnc_getNearbyEntities) isEqualTo []} &&
        {_this inArea KPLIB_centerArea}
    }] call BIS_fnc_randomPos;
    if (_landArea isNotEqualTo [0,0]) exitWith {}; // Exit on pos found
};

if (_landArea isEqualTo [0,0]) exitWith {[format["No land area found in %1", _targetPos], "HELICOPTER TRANSPORT"] call KPLIB_fnc_log; _landArea};

_landArea