/*
    File: fn_updateCruiseMissiles.sqf
    Author: TubaHorse, based off of the work of KP Liberation Dev Team - https://github.com/KillahPotatoes
    Date: 2025-12-14
    Last Update: 2025-12-14
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Reusable code to be called whenever a cruise missile vehicle is built 

    Parameter(s):
        NONE
*/

if (!isServer || isNull KPLIB_param_supportModule_missile) exitWith {};

diag_log "MISSILE UPDATE: Calling EF_fnc_moduleNLOS";
diag_log format ["MISSILE UPDATE: Objects synced to missile module: %1", synchronizedObjects KPLIB_param_supportModule_missile];
diag_log format ["MISSILE UPDATE: Objects synced to requester: %1", synchronizedObjects KPLIB_param_supportModule_req];

[KPLIB_param_supportModule_missile] call EF_fnc_moduleNLOS;

diag_log "MISSILE UPDATE: Complete";