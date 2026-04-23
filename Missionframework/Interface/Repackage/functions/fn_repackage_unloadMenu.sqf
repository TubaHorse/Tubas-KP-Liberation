#include "..\defines.hpp"
/*
    File: fn_repackage_unloadMenu.sqf
    Author: PiG13BR - https://github.com/PiG13BR
    Date: 14/04/2026
    Last Update: 14/04/2026
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Unload repackage menu

    Parameter(s):
        _display - repackage menu display [DISPLAY, defaults to findDisplay IDD_BASENAME_MENU]

    Returns:
        -
*/
params[["_display", findDisplay IDD_REPACKAGE_MENU]];

localNamespace setVariable ["KPLIB_baseToRepackage", nil];