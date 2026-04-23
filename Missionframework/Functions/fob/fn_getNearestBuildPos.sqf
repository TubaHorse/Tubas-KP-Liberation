/*
    File: fn_getNearestBuildPos.sqf
    Author: PiG13BR - https://github.com/PiG13BR
    Date: 15/03/2026
    Last Update: 15/03/2026
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Gets the nearest build position.

    Parameter(s):
        _pos - Position to find the nearest build position from [POSITION, defaults to getPos player]

    Returns:
        [ARRAY]
        - Nearest FOB position [POSITION] 
        - Build Range [NUMBER]
*/

params [
    ["_pos", getPos player, [[]], [2, 3]]
];

private _buildPos = [0,0,0];
private _buildRange = KPLIB_range_fob;

if ((KPLIB_player_fobs isNotEqualTo []) || (KPLIB_player_outposts isNotEqualTo [])) then {
    _buildPos = (KPLIB_player_outposts + KPLIB_player_fobs) apply {[_pos distance2d _x, _x]};
    _buildPos sort true;
    _buildPos = (_buildPos select 0) select 1;
    if (_buildPos in KPLIB_player_outposts) then {
        _buildRange = KPLIB_range_outpost
    };
};

[_buildPos, _buildRange];