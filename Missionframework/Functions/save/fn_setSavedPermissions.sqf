/*
    File: fn_setSavedPermissions.sqf
    Author: PiG13BR (https://github.com/PiG13BR)
    Date: 29/07/2026
    Last Update: 29/07/2026
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Get and set saved general and build permissions

    Parameter(s):
        -

    Returns:
        -
*/

// General permissions
private _generalPermissionsHash = createHashMapFromArray [];
if (count KPLIB_general_permissions > 0) then {
    {
        _x params ["_uid", "_array"];
        _array params ["_name", ["_permissions", [false,false,false,false,false,false]]];

        _generalPermissionsHash set [_uid, [_name, _permissions]];
    }forEach KPLIB_general_permissions;
};

// It's now a hashmap
KPLIB_general_permissions = _generalPermissionsHash;
publicVariable "KPLIB_general_permissions";

// Build permissions
private _buildPermissionsHash = createHashMapFromArray [];
if (count KPLIB_build_permissions > 0) then {
    {
        _x params ["_uid", "_array"];
        _array params ["_name", ["_permissions", [false,false,false,false,false,false,false,false]]];

        _buildPermissionsHash set [_uid, [_name, _permissions]];
    }forEach KPLIB_build_permissions;
};

// It's now a hashmap
KPLIB_build_permissions = _buildPermissionsHash;
publicVariable "KPLIB_build_permissions";