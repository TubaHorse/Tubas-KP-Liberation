/*
    File: fn_findPlaceToParadrop.sqf
    Author: PiG13BR - https://github.com/PiG13BBR
    Date: 08/06/2026
    Last Update: 08/06/2026
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Find a situable place to paradrop units

    Parameter(s):
        _targetPos - position to paradrop [POSITION, defaults to [0,0,0]]
        _radius - notify players [NUMBER, defaults to 1100]

    Returns:
        Position to paradrop [POSITION]
*/
params[["_targetPos",[0,0,0],[[]],[2,3]], ["_radius", 1100, [0]]];

if (_targetPos isEqualTo [0,0,0]) exitWith {["No position provided"] call BIS_fnc_error; [0,0]};

// Find paradrop area
private _paradropArea = [0,0];
private _tries = 0;
while {_tries < 8} do {
    _tries = _tries + 1; // Count tries to exit while loop

    // Find paradrop area
    _paradropArea = [[[_targetPos, _radius]], [], 
    {
        (_this distance2D _targetPos > (_radius/2)) && 
        (_this distance2D _targetPos < (_radius*0.9)) && 
        {_this isFlatEmpty [10, -1, 0.3, 5, 0, false] isNotEqualTo []} &&
        {([[[_this, 500]], [], {(surfaceIsWater _this)}] call BIS_fnc_randomPos) isEqualTo [0,0]} && // Find body of water nearby (to avoid dropping paratroopers close to the water)
        {([_this, 150, KPLIB_side_player] call KPLIB_fnc_getNearbyEntities) isEqualTo []} &&
        {_this inArea KPLIB_centerArea}
    }] call BIS_fnc_randomPos;

    //if (_checkSurface isNotEqualTo [0,0]) then {continue}; // Nearby water surface found, go to the next try
    if (_paradropArea isNotEqualTo [0,0]) exitWith {}; // Exit on pos found
};

if (_paradropArea isEqualTo [0,0]) exitWith {[format["No paradrop area found in %1", _targetPos], "PARADROP"] call KPLIB_fnc_log; _paradropArea};

_paradropArea