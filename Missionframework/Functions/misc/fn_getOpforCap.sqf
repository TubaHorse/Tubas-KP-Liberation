/*
    File: fn_getOpforCap.sqf
    Author: KP Liberation Dev Team - https://github.com/KillahPotatoes, PiG13BR - https://github.com/PiG13BR
    Date: 03/12/2019
    Last Update: 10/06/2026
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Gets current amount of total opfor units in sectors.

    Parameter(s):
        NONE

    Returns:
        Total opfor units in actual sectors [NUMBER]
*/

private _unitsCap = 0;

private _range = KPLIB_range_sectorCapture * 1.4;
{
    if (_x in KPLIB_fillers_all) then {continue}; // Skip fillers
    if (markerShape _x == "ICON") then {_range = KPLIB_range_sectorCapture * 1.4} else {_range = markerSize _x};
    private _unitCount = [markerPos _x, _range, KPLIB_side_enemy] call KPLIB_fnc_getUnitsCount;
    _unitsCap = _unitsCap + _unitCount;
}forEach KPLIB_sectors_active;

_unitsCap