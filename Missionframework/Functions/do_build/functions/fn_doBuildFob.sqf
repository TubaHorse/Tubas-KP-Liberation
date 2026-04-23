#include "..\defines.hpp"
/*
    File: fn_doBuildFob.sqf
    Author: KP Liberation Dev Team - https://github.com/KillahPotatoes, PiG13BR - https://github.com/PiG13BR
    Date: 12/11/2025
    Last Update: 12/04/2026
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Start fob building process

    Parameter(s):
        Action passed arguments 
            _fobPlacer - fob object that was deployed [OBJECT]

    Returns:
        [BOOL]
*/
params ["_fobPlacer"];

// Build Fob!
[BUILDTYPE_FOB] call KPLIB_fnc_buildItem;
deleteVehicle _fobPlacer; // Delete fob placer