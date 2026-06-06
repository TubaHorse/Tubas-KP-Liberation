/*
    File: fn_getUnitsCount.sqf
    Author: KP Liberation Dev Team - https://github.com/KillahPotatoes
    Date: 2019-12-03
    Last Update: 2026-06-05
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Gets the amount of units of given side inside given radius of given sector.

    Parameter(s):
        _sector - Description [STRING, defaults to ""]
        _radius - Description [NUMBER or ARRAY, defaults to 100]
        _side - Description [SIDE, defaults to KPLIB_side_player]

    Returns:
        Amount of units [NUMBER]
*/

params [
    ["_pos", [0, 0, 0], [[]], [2, 3]],
    ["_radius", 100, [0, []]],
    ["_side", KPLIB_side_player, [sideEmpty]]
];

private _sector = [100, _pos] call KPLIB_fnc_getNearestSector;

private _amount = 0;

if (_radius isEqualType []) then {
   _amount = _side countSide ((allUnits select {!(captive _x) && ((getpos _x) select 2 < 500) && lifeState _x != "INCAPACITATED"}) inAreaArray [_pos, _radius # 0, _radius # 1, 0, (markerShape _sector == "RECTANGLE"), 10]);
} else {
    _amount = _side countSide ((_pos nearEntities ["CAManBase", _radius]) select {!(captive _x) && ((getpos _x) select 2 < 500) && lifeState _x != "INCAPACITATED"});
    {
        _amount = _amount + (_side countSide (crew _x));
    } forEach ((_pos nearEntities [["Car", "Tank", "Air", "Ship"], _radius]) select {((getpos _x) select 2 < 500) && (count (crew _x) > 0) && side group(effectiveCommander _x) == KPLIB_side_player});
};

_amount
