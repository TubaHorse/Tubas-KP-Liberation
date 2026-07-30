#include "..\defines.hpp"
/*
    File: fn_general_perms_loadMenu.sqf
    Author: KP Liberation Dev Team - https://github.com/KillahPotatoes, PiG13BR - https://github.com/PiG13BR
    Date: 16/07/2026
    Last Update: 29/07/2026
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Load the general permissions menu

    Parameter(s):
        _display - general permissions menu display [DISPLAY, defaults to findDisplay IDD_GENERAL_PERMS_MENU]

    Returns:
        -
*/

params[["_display", findDisplay IDD_GENERAL_PERMS_MENU]];

disableSerialization;

// Controls
private _controlGrp = _display displayCtrl IDC_PERM_CONTROL_GRP;

KPLIB_temp_permissions = +KPLIB_general_permissions;
KPLIB_temp_controls = createHashMap;

private _playersInfo = [];
private _uidsData = ["Default"];

_playersInfo pushback ["Default", localize "STR_DEFAULT", 0]; // First row
private _idx = 2;

// Get clients present on the mission
{
    private _nextPlayer = _x;
    private _uid = getPlayerUID _nextPlayer;

    private _displayName = "";
    if(count (squadParams _nextPlayer) != 0) then {
        _displayName = "[" + ((squadParams _nextPlayer # 0) # 0) + "] ";
    };
    _displayName = _displayName + name _nextPlayer;

    _playersInfo pushback [_uid, _displayName, _idx];
    _uidsData pushBack _uid;

    // Set temporary key on non-existent
    if !(_uid in KPLIB_temp_permissions) then {
        KPLIB_temp_permissions set [_uid, [_displayName, [false,false,false,false,false,false]]]
    };

    _idx = _idx + 1;
} foreach (allPlayers - entities "HeadlessClient_F");

// Jump one index
_idx = _idx + 1;

// Players in the list but not present in the mission
{
    private _uid = _x;
    private _name = _y # 0;

    if !(_uid in _uidsData) then {
        _playersInfo pushBack [_uid, _name, _idx];
        _idx = _idx + 1;
    };
} forEach KPLIB_temp_permissions;

// Create row and columns for permissions for each player (and default)
{
    private _name = _x # 1;
    private _idx = _x # 2;

    if (_idx % 2 == 0) then {

        private _control = _display ctrlCreate ["RscBackground", -1, _controlGrp];
        _control ctrlSetPosition [0, (_idx * 0.025) * safezoneH, 0.595 * safeZoneW, 0.025  * safezoneH];
        _control ctrlSetBackgroundColor COLOR_BACKGROUND;
        _control ctrlCommit 0;
    };

    // Name
    private _control = _display ctrlCreate ["RscText", (10 * _idx), _controlGrp];
    _control ctrlSetPosition [0, (_idx * 0.025) * safezoneH, 0.072 * safeZoneW, 0.025  * safezoneH];
    _control ctrlSetText _name;
    _control ctrlSetFontHeight FONT_SIZE;
    _control ctrlCommit 0;

    // Permissions
    [_display, _controlGrp, _x, 1, LIGHT_VEH_PERM, localize "STR_PERMISSIONS_LIGHT", localize "STR_PERMISSIONS_TOOLTIP_LIGHT"] call KPLIB_fnc_general_perms_createActiveText;
    [_display, _controlGrp, _x, 2, ARMORED_VEH_PERM, localize "STR_PERMISSIONS_ARMORED", localize "STR_PERMISSIONS_TOOLTIP_ARMORED"] call KPLIB_fnc_general_perms_createActiveText;
    [_display, _controlGrp, _x, 3, HELICOPTER_PERM, localize "STR_PERMISSIONS_HELICOPTER", localize "STR_PERMISSIONS_TOOLTIP_HELICOPTER"] call KPLIB_fnc_general_perms_createActiveText;
    [_display, _controlGrp, _x, 4, PLANE_PERM, localize "STR_PERMISSIONS_PLANES", localize "STR_PERMISSIONS_TOOLTIP_PLANES"] call KPLIB_fnc_general_perms_createActiveText;
    [_display, _controlGrp, _x, 5, LOGISTIC_PERM, localize "STR_PERMISSIONS_LOGISTICS", localize "STR_PERMISSIONS_TOOLTIP_LOGISTICS"] call KPLIB_fnc_general_perms_createActiveText;
    [_display, _controlGrp, _x, 6, MISC_PERM, localize "STR_PERMISSIONS_MISC", localize "STR_PERMISSIONS_TOOLTIP_MISC"] call KPLIB_fnc_general_perms_createActiveText;

    // All button
    [_display, _controlGrp, _x] call KPLIB_fnc_general_perms_createAllButton;

    // None button
    [_display, _controlGrp, _x] call KPLIB_fnc_general_perms_createNoneButton;
} foreach _playersInfo;