#include "..\defines.hpp"
/*
    File: fn_baseName_createMenuRsc.sqf
    Author: PiG13BR - https://github.com/PiG13BR
    Date: 13/04/2026
    Last Update: 13/04/2026
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Create liberation base name Rsc

    Parameter(s):
        _base - base position to change the name [POSITION]

    Returns:
        -
*/
params["_base"];

private _displayToUse = findDisplay IDD_MISSION;

localNamespace setVariable ["KPLIB_basePosition", _base];

// Create dialog
[{_this createDisplay "LiberationBaseNameRsc"}, _displayToUse] call CBA_fnc_execNextFrame;