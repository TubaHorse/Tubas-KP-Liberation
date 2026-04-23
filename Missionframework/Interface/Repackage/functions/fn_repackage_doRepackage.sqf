#include "..\defines.hpp"
/*
    File: fn_repackage_doRepackage.sqf
    Author: PiG13BR - https://github.com/PiG13BR
    Date: 14/04/2026
    Last Update: 14/04/2026
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Repackage confirmed. Deletes building and spawns box/truck.

    Parameter(s):
        _control - button control [CONTROL]
        _type - base name menu display [DISPLAY, defaults to findDisplay IDD_BASENAME_MENU]

    Returns:
        -
*/
params[["_type", "BOX", [""]]];

private _building = localNamespace getVariable ["KPLIB_baseToRepackage", player];

// Get actual position
private _nearestBase = [getPosATL _building] call KPLIB_fnc_getNearestPlayerBase;

switch (true) do {
    case (_nearestBase in KPLIB_player_outposts) : {
        // Delete Outpost object
        {deleteVehicle _x} forEach (((_nearestBase) nearobjects [KPLIB_b_outpostBuilding, 250]) select {getObjectType _x >= 8});

        private _index = KPLIB_player_outposts find _nearestBase;
        KPLIB_player_outposts set [_index, [0,0,0]]; 
        publicVariable "KPLIB_player_outposts";

        // Restore default name
        private _defaultName = KPLIB_militaryAlphabet select _index;
        KPLIB_outpostNames set [_index, _defaultName];
        publicVariable "KPLIB_outpostNames";

        if (_type == "BOX") exitWith {
            // Create box
            private _baseBox = KPLIB_b_fobBox createVehicle _nearestBase;
            [_baseBox] call KPLIB_fnc_addObjectInit;
        };
        if (_type == "TRUCK") exitWith {
            // Truck
            private _baseTruck = KPLIB_b_fobTruck createVehicle _nearestBase;
            [_baseTruck] call KPLIB_fnc_addObjectInit;
        };
    };
    default {
        // Delete FOB object
        {deleteVehicle _x} forEach (((_nearestBase) nearobjects [KPLIB_b_fobBuilding, 250]) select {getObjectType _x >= 8});

        private _index = KPLIB_player_fobs find _nearestBase;
        KPLIB_player_fobs set [_index, [0,0,0]]; 
        publicVariable "KPLIB_player_fobs";

        // Restore default name
        private _defaultName = KPLIB_militaryAlphabet select _index;
        KPLIB_fobNames set [_index, _defaultName];
        publicVariable "KPLIB_fobNames";

        if (_type == "BOX") exitWith {
            // Create box
            private _baseBox = KPLIB_b_fobBox createVehicle _nearestBase;
            [_baseBox] call KPLIB_fnc_addObjectInit;
        };
        if (_type == "TRUCK") exitWith {
            // Truck
            private _baseTruck = KPLIB_b_fobTruck createVehicle _nearestBase;
            [_baseTruck] call KPLIB_fnc_addObjectInit;
        };
    };
};

KPLIB_clearances deleteAt (KPLIB_clearances findIf {(_x select 0) isEqualTo _nearestBase});
publicVariable "KPLIB_clearances";

[localize "STR_BASE_REPACKAGE_HINT", false, 3] call KPLIB_fnc_hint;

// Log
["KPLIB_generateLog", 
    [
        format ["Base at position %1 repackaged by %2", _nearestBase, name player],
        "BASE REPACKAGE"
    ]
] call CBA_fnc_serverEvent;

["KPLIB_updateBaseMarkers", []] call CBA_fnc_serverEvent;