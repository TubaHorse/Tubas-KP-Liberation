/*
    File: fn_getBaseName.sqf
    Author: PiG13BR - https://github.com/PiG13BR
    Date: 11/04/2026
    Last Update: 12/04/2026
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Gets the Base name in accordance to the military alphabet set in init presets.

    Parameter(s):
        _base - Position of the base to get the name from [POSITION, defaults to [0, 0, 0]]

    Returns:
        Base name [STRING]
*/

params [
    ["_base", [0, 0, 0], [[]], [2, 3]]
];

private _index = KPLIB_player_fobs findIf {(_x distance2d _base) < 100};
if (_index >= 0) exitWith {
    KPLIB_fobNames param [_index, ""]
};

private _index = KPLIB_player_outposts findIf {(_x distance2d _base) < 100};
if (_index >= 0) exitWith {
    KPLIB_outpostNames param [_index, ""]
};

""