/*
    File: fn_applyDefaultPermissions.sqf
    Author: PiG13BR - https://github.com/PiG13BR
    Date: 18/07/2026
    Last Update: 29/07/2026
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Apply defaults permissions on loaded client

    Parameter(s):
        _player - player to add defaults permissions [OBJECT, defaults to player]

    Returns:
        -
*/
params[["_player", player, [objNull]]];

private _uid = (getPlayerUID _player);

// Get default permissions
private _defaultGeneral = KPLIB_general_permissions getOrDefault ["Default", [], true];
_defaultGeneral = _defaultGeneral param [1, [false,false,false,false,false,false]];
private _defaultBuild = KPLIB_build_permissions getOrDefault ["Default", [], true];
_defaultBuild = _defaultBuild param [1, [false,false,false,false,false,false,false,false]];

// Get player's permissions
private _generalPerm = KPLIB_general_permissions getOrDefault [(getPlayerUID player), [], true];
_generalPerm = _generalPerm param [1, [false,false,false,false,false,false]];
private _buildPerm = KPLIB_build_permissions getOrDefault [(getPlayerUID player), [], true];
_buildPerm = _buildPerm param [1, [false,false,false,false,false,false,false,false]];

{
    if (_generalPerm # _forEachIndex) then {continue}; // Ignore if it's true
    _generalPerm set [_forEachIndex, _x];
}forEach _defaultGeneral;
KPLIB_general_permissions set [_uid, [name _player, _generalPerm]];
publicVariable "KPLIB_general_permissions";

{
    if (_buildPerm # _forEachIndex) then {continue}; // Ignore if it's true
    _buildPerm set [_forEachIndex, _x];
}forEach _defaultBuild;
KPLIB_build_permissions set [_uid, [name _player, _buildPerm]];
publicVariable "KPLIB_build_permissions";