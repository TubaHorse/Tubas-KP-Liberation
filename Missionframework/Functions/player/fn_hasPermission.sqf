/*
    File: fn_hasPermission.sqf
    Author: KP Liberation Dev Team - https://github.com/KillahPotatoes
    Date: 2019-11-25
    Last Update: 2026-07-17
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Checks if local player has the given permission granted.

    Parameter(s):
        _type - Type of permissions [STRING, defaults to GENERAL]
        _permission - Permission to check [NUMBER, defaults to -1]

    Returns:
        Has permission granted [BOOL]
*/

params [
    ["_permission", -1, [0]],
    ["_type", "GENERAL", [""]]
];

if (_permission isEqualTo -1) exitWith {["No permission number given"] call BIS_fnc_error; false};
if (!KPLIB_param_permissions) exitWith {true};

if (_type == "GENERAL") then {
    KPLIB_permissions_cache = (KPLIB_general_permissions getOrDefault [getPlayerUID player, []]) # 1;
} else {
    KPLIB_permissions_cache = (KPLIB_build_permissions getOrDefault [getPlayerUID player, []]) # 1;
};

if (isNil "KPLIB_permissions_cache") exitWith {false};

if (count KPLIB_permissions_cache > _permission) then {
    KPLIB_permissions_cache # _permission
} else {
    false
};
