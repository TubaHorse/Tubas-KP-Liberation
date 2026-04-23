#include "..\defines.hpp"
/*
    File: fn_baseName_unloadMenu.sqf
    Author: PiG13BR - https://github.com/PiG13BR
    Date: 13/04/2026
    Last Update: 13/04/2026
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Unload base name menu

    Parameter(s):
        _display - base name menu display [DISPLAY, defaults to findDisplay IDD_BASENAME_MENU]

    Returns:
        -
*/
params[["_display", findDisplay IDD_BASENAME_MENU]];

localNamespace setVariable ["KPLIB_basePosition", nil];