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

diag_log "MISSILE UPDATE: Starting...";

private _syncedObjects = synchronizedObjects KPLIB_param_supportModule_missile;
diag_log format ["MISSILE UPDATE: Found %1 synced objects", count _syncedObjects];

// Check EVERY synced object, not just vehicles
{
    private _obj = _x;
    diag_log format ["MISSILE UPDATE: Synced object %1 - Type: %2, isKindOf LandVehicle: %3, isKindOf AllVehicles: %4", 
        _obj, 
        typeOf _obj, 
        _obj isKindOf "LandVehicle",
        _obj isKindOf "AllVehicles"
    ];
    
    // If it's any kind of vehicle, check its weapons
    if (_obj isKindOf "AllVehicles") then {
        diag_log format ["MISSILE UPDATE: Vehicle %1 - Weapons: %2, Gunner: %3", 
            typeOf _obj, 
            weapons _obj, 
            gunner _obj
        ];
    };
} forEach _syncedObjects;

[KPLIB_param_supportModule_missile] call EF_fnc_moduleNLOS;

diag_log "MISSILE UPDATE: Complete";