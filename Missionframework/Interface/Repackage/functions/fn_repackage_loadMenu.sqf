#include "..\defines.hpp"
/*
    File: fn_repackage_loadMenu.sqf
    Author: PiG13BR - https://github.com/PiG13BR
    Date: 22/04/2026
    Last Update: 22/04/2026
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Load repackage menu

    Parameter(s):
        _display - repackage menu display [DISPLAY, defaults to findDisplay IDD_BASENAME_MENU]

    Returns:
        -
*/
params[["_display", findDisplay IDD_REPACKAGE_MENU]];

private _building = localNamespace getVariable ["KPLIB_baseToRepackage", objNull];

if (isNull _building) exitWith {_display closeDisplay 1};

// Outpost
if (typeOf _building == KPLIB_b_outpostBuilding) then {
    private _truckButton = _display displayCtrl IDC_TRUCK_BUTTON;
    _truckButton ctrlEnable false;
};