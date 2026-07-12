/*
    File: fn_getNearestBluforObjective.sqf
    Author: KP Liberation Dev Team - https://github.com/KillahPotatoes
    Date: 2019-12-03
    Last Update: 2026-07-12
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Gets the position of the nearest blufor sector/fob from given position.

    Parameter(s):
        _pos - Position to check for nearest blufor sector/fob [POSITION, defaults to [0, 0, 0]]

    Returns:
        Nearest blufor sector/fob position [POSITION]
*/

params [
    ["_pos", [0, 0, 0], [[]], [2, 3]]
];

if (KPLIB_player_fobs isEqualTo [] && (KPLIB_player_outposts isEqualTo []) && (KPLIB_sectors_player isEqualTo [])) exitWith {[]};

private _objectives = ((KPLIB_player_fobs select {_x isNotEqualTo [0,0,0]}) + (KPLIB_player_outposts select {_x isNotEqualTo [0,0,0]})) + ((KPLIB_sectors_player - KPLIB_fillers_patrol) apply {markerPos _x});
_objectives = _objectives apply {[_x distance2d _pos, _x]};
_objectives sort true;

(_objectives select 0) select 1
