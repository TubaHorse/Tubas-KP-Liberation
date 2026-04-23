#include "..\defines.hpp"
/*
    File: fn_baseName_loadMenu.sqf
    Author: PiG13BR - https://github.com/PiG13BR
    Date: 13/04/2026
    Last Update: 13/04/2026
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Load the base name menu

    Parameter(s):
        _display - base name menu display [DISPLAY, defaults to findDisplay IDD_BASENAME_MENU]

    Returns:
        -
*/

params[["_display", findDisplay IDD_BASENAME_MENU]];

// Controls
private _editCtrl = _display displayCtrl IDC_EDIT;

private _base = localNamespace getVariable ["KPLIB_basePosition", [0,0,0]];

// Set the actual name
private _actualName = [_base] call KPLIB_fnc_getBaseName;
_editCtrl ctrlSetText _actualName;