/*
    File: fn_getNearestPlayerBase.sqf
    Author: PiG13BR - https://github.com/PiG13BR
    Date: 11/04/2026
    Last Update: 14/04/2026
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Gets the nearest base position to given position.

    Parameter(s):
        _pos - Position to find the nearest base from [POSITION, defaults to getPosATL player]

    Returns:
        Nearest base position [POSITION]
*/

params [
    ["_pos", getPosATL player, [[]], [2, 3]]
];

if (KPLIB_player_fobs isNotEqualTo []) then {
    // Check for nearby fobs and outposts
    private _fobs = ((KPLIB_player_fobs + KPLIB_player_outposts) select {_x isNotEqualTo [0,0,0]}) apply {[_pos distance2d _x, _x]};
    _fobs sort true;
    (_fobs select 0) select 1
} else {
    []
};
