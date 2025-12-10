/*
    File: fn_createSuppModules.sqf
    Author: KP Liberation Dev Team - https://github.com/KillahPotatoes
    Date: 2020-04-21
    Last Update: 2020-05-23
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Creates the A3 support framework modules.

    Parameter(s):
        NONE

    Returns:
        Function reached the end [BOOL]
*/

if (!isServer || KPLIB_param_supportModule isEqualTo 0) exitWith {false};

["Creating modules", "SUPPORTMODULES"] call KPLIB_fnc_log;

// Create modules
private _grp = createGroup sideLogic;
KPLIB_param_supportModule_req = _grp createUnit ["SupportRequester", [0, 0, 0], [], 0, "NONE"];
KPLIB_param_supportModule_arty = _grp createUnit ["SupportProvider_Artillery", [0, 0, 0], [], 0, "NONE"];

// Only create missile module if EF is loaded
private _hasEF = isClass (configFile >> "CfgPatches" >> "EF_Data");
if (_hasEF) then {
    diag_log "Expeditionary Forces is loaded, enabling cruise missile support...";
    KPLIB_param_supportModule_missile = _grp createUnit ["Logic", [0, 0, 0], [], 0, "NONE"];
    KPLIB_param_supportModule_req synchronizeObjectsAdd [KPLIB_param_supportModule_missile];
} else {
    diag_log "Expeditionary Forces not loaded, skipping...";
    KPLIB_param_supportModule_missile = objNull;
};

// Set variables which are normally set via eden object attributes
{
    [KPLIB_param_supportModule_req, _x, -1] call BIS_fnc_limitSupport;
} forEach ["Artillery", "CAS_Heli", "CAS_Bombing", "UAV", "Drop", "Transport"];

// Publish global variables to clients
publicVariable "KPLIB_param_supportModule_req";
publicVariable "KPLIB_param_supportModule_arty";
publicVariable "KPLIB_param_supportModule_missile";

// Delay provider init until save is loaded, to catch synchronized units from loaded save
[] spawn {
    waitUntil {!isNil "KPLIB_saveLoaded" && {KPLIB_saveLoaded}};
    ["Init provider on server", "SUPPORTMODULES"] call KPLIB_fnc_log;
    [KPLIB_param_supportModule_req] call BIS_fnc_moduleSupportsInitRequester;
    [KPLIB_param_supportModule_arty] call BIS_fnc_moduleSupportsInitProvider;
    
    // Only init EF module if it exists
    if (!isNull KPLIB_param_supportModule_missile) then {
        [KPLIB_param_supportModule_missile] call EF_fnc_moduleNLOS;
    };

    // There remain issues with this feature. It seems that EF_fnc_moduleNLOS does not automatically handle dynamic updates to the support module like BIS_fnc_moduleSupportsInitProvider. I will be checking w/ Tiny Gecko to see if this is correct.
    //As it stands, a player has to respawn for the vehicles to show up, and if a vehicle is destroyed it is not removed from the list.
    // Also, I think empty vehicles are also included in the menu despite not being able to perform the fire mission.

    // Hide the three HQ entities created at zero pos. BIS scripts only hides them local for the creator
    waitUntil {!isNil "BIS_SUPP_HQ_WEST" && !isNil "BIS_SUPP_HQ_EAST" && !isNil "BIS_SUPP_HQ_GUER"};
    {
        hideObjectGlobal _x;
    } forEach [BIS_SUPP_HQ_WEST, BIS_SUPP_HQ_EAST, BIS_SUPP_HQ_GUER]
};

true