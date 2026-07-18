#include "..\defines.hpp"
/*
    File: fn_general_perms_createMenuRsc.sqf
    Author: PiG13BR - https://github.com/PiG13BR
    Date: 16/07/2026
    Last Update: 16/07/2026
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Create liberation general permissions Rsc

    Parameter(s):
        -

    Returns:
        -
*/

private _displayToUse = findDisplay IDD_MISSION;

[{_this createDisplay "LiberationGeneralPermsRsc"}, _displayToUse] call CBA_fnc_execNextFrame;