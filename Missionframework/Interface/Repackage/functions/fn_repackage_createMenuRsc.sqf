#include "..\defines.hpp"
/*
    File: fn_repackage_createMenuRsc.sqf
    Author: PiG13BR - https://github.com/PiG13BR
    Date: 14/04/2026
    Last Update: 14/04/2026
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Create liberation repackage Rsc

    Parameter(s):
        _building - building to repackage [OBJECT]

    Returns:
        -
*/
params["_building"];

private _displayToUse = findDisplay IDD_MISSION;

localNamespace setVariable ["KPLIB_baseToRepackage", _building];

// Create dialog
[{_this createDisplay "LiberationRepackageRsc"}, _displayToUse] call CBA_fnc_execNextFrame;