#include "..\defines.hpp"
/*
    File: fn_general_perms_unloadMenu.sqf
    Author: PiG13BR - https://github.com/PiG13BR
    Date: 16/07/2026
    Last Update: 16/07/2026
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Unload general permissions menu

    Parameter(s):
        _display - general permissions menu display [DISPLAY, defaults to findDisplay IDD_GENERAL_PERMS_MENU]

    Returns:
        -
*/
params[["_display", findDisplay IDD_GENERAL_PERMS_MENU]];

KPLIB_temp_permissions = nil;