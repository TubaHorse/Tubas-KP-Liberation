#include "..\defines.hpp"
/*
    File: fn_build_loadMenu.sqf
    Author: KP Liberation Dev Team - https://github.com/KillahPotatoes, PiG13BR - https://github.com/PiG13BR
    Date: 10/11/2025
    Last Update: 15/03/2026
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Load the build menu

    Parameter(s):
        _display - build menu display [DISPLAY, defaults to findDisplay IDD_BUILD_MENU]

    Returns:
        -
*/

params[["_display", findDisplay IDD_BUILD_MENU]];

// Controls
private _squadButtonCtrl = _display displayCtrl IDC_SQUAD_BUTTON;
private _squadImageCtrl = _display displayCtrl IDC_SQUAD_IMAGE;
private _mannedButtonCtrl = _display displayCtrl IDC_MANNED_WEAPON;

private _iscommandant = false;
if (player == [] call KPLIB_fnc_getCommander) then {
    _iscommandant = true;
};

// Show or hide squad composition tab
_squadButtonCtrl ctrlEnable _iscommandant;
_mannedButtonCtrl ctrlEnable _iscommandant;
//_squadButtonCtrl ctrlShow _iscommandant;
//_squadImageCtrl ctrlShow _iscommandant;
//_mannedButtonCtrl ctrlShow _iscommandant;

// Fob or outpost
private _buildPos = ([getPos _originalTarget] call KPLIB_fnc_getNearestBuildPos) # 0;

if (_buildPos in KPLIB_player_outposts) then {
    [BUILDTYPE_DEFENCE, _display] call KPLIB_fnc_build_fillLnb; // Always opens the menu showing the static weapons tab
    
    // Disable controls for outpost
    private _infButtonCtrl = _display displayCtrl IDC_INFANTRY_BUTTON;
    private _transButtonCtrl = _display displayCtrl IDC_TRANSPORT_BUTTON;
    private _combatvehButtonCtrl = _display displayCtrl IDC_COMBATVEH_BUTTON;
    private _aerialButtonCtrl = _display displayCtrl IDC_AERIAL_BUTTON;
    private _supportButtonCtrl = _display displayCtrl IDC_SUPPORT_BUTTON;

    {_x ctrlEnable false}forEach [_infButtonCtrl, _transButtonCtrl, _combatvehButtonCtrl, _aerialButtonCtrl, _supportButtonCtrl, _squadButtonCtrl];
} else {
    // Fob
    [BUILDTYPE_INFANTRY, _display] call KPLIB_fnc_build_fillLnb; // Always opens the menu showing the infantry tab
};

// Disable user actions
inGameUISetEventHandler ["PrevAction", "true"];
inGameUISetEventHandler ["NextAction", "true"];
inGameUISetEventHandler ["Action", "true"];