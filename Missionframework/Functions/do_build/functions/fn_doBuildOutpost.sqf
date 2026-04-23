#include "..\defines.hpp"
/*
    File: fn_doBuildOutpost.sqf
    Author: PiG13BR - https://github.com/PiG13BR
    Date: 11/04/2026
    Last Update: 11/04/2026
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Start outpost building process

    Parameter(s):
        Action passed arguments 
            _outpostPlacer - fob object that was deployed [OBJECT]

    Returns:
        [BOOL]
*/
params ["_outpostPlacer"];

// Build Fob!
[BUILDTYPE_OUTPOST] call KPLIB_fnc_buildItem;
deleteVehicle _outpostPlacer; // Delete fob placer