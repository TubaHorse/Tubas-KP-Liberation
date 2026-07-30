/*
    File: fn_hasPermission.sqf
    Author: KP Liberation Dev Team - https://github.com/KillahPotatoes
    Date: 2019-11-25
    Last Update: 2026-07-30
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

private _uid = getPlayerUID player;

if (_type == "GENERAL") then {
    private _data = KPLIB_general_permissions getOrDefault [_uid, []];

    private _perms = _data param [1, [false,false,false,false,false,false]];
    KPLIB_permissions_cache = _perms;
} else {
    private _data = KPLIB_build_permissions getOrDefault [_uid, []];
    private _perms = _data param [1, [false,false,false,false,false,false,false,false]];
    KPLIB_permissions_cache = _perms;
};

if (isNil "KPLIB_permissions_cache") exitWith {false};

if (count KPLIB_permissions_cache > _permission) then {
    KPLIB_permissions_cache # _permission
} else {
    false
};
