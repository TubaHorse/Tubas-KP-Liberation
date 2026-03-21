/*
    File: fn_getOpforCap.sqf
    Author: KP Liberation Dev Team - https://github.com/KillahPotatoes
    Date: 2019-12-03
    Last Update: 2026-03-21
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Gets current amount of total opfor units in sectors.

    Parameter(s):
        NONE

    Returns:
        Total opfor units in actual sectors [NUMBER]
*/

private _unitsCap = [];

{
    // Get closest sector
    private _sector = [KPLIB_range_sectorCapture * 1.4, getPosATL _x, false, true] call KPLIB_fnc_getNearestSector;
    if (isNil "_sector") then {continue};

    _unitsCap pushBackUnique _x;
}forEach (units KPLIB_side_enemy);

count _unitsCap