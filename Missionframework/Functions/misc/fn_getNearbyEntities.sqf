/*
    File: fn_getNearbyEntities.sqf
    Author: PiG13BR - https://github.com/PiG13BR
    Date: 17/04/2026
    Last Update: 17/04/2026
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Gets entities of given side inside given radius of given position.

    Parameter(s):
        _pos - Description [POSITION, defaults to [0, 0, 0]
        _radius - Description [NUMBER, defaults to 100]
        _side - Description [SIDE, defaults to KPLIB_side_player]

    Returns:
        Units [ARRAY]
*/

params [
    ["_pos", [0, 0, 0], [[]], [2, 3]],
    ["_radius", 100, [0]],
    ["_side", KPLIB_side_player, [sideEmpty]]
];

private _entities = (_pos nearEntities ["CAManBase", _radius]) select {(side (group _x) == _side) && !(captive _x) && ((getpos _x) select 2 < 500) && lifeState _x != "INCAPACITATED"};
{
    _entities pushBack _x;
} forEach ((_pos nearEntities [["Car", "Tank", "Air", "Ship"], _radius]) select {((getpos _x) select 2 < 500) && count (crew _x) > 0});

_entities
