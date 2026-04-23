/*
    File: fn_getNearestFob.sqf
    Author: KP Liberation Dev Team - https://github.com/KillahPotatoes
    Date: 2019-12-03
    Last Update: 2026-04-11
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Gets the nearest FOB position to given position.

    Parameter(s):
        _pos - Position to find the nearest FOB from [POSITION, defaults to getPos player]
        _onlyOutpost - Check for nearby outposts ONLY [BOOL, defaults to false]

    Returns:
        Nearest FOB position [POSITION]
*/

params [
    ["_pos", getPos player, [[]], [2, 3]],
    ["_onlyOutpost", false, [FALSE]]
];

if (KPLIB_player_fobs isNotEqualTo []) then {
    if (_onlyOutpost) then {
        // Check for nearby outposts
        private _outposts = KPLIB_player_outposts apply {[_pos distance2d _x, _x]};
        _outposts sort true;
        (_outposts select 0) select 1
    } else {
        // Check for nearby fobs
        private _fobs = KPLIB_player_fobs apply {[_pos distance2d _x, _x]};
        _fobs sort true;
        (_fobs select 0) select 1
    };
} else {
    []
};
