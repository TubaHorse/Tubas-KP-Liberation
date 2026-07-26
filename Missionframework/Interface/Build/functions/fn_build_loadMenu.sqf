#include "..\defines.hpp"
/*
    File: fn_build_loadMenu.sqf
    Author: KP Liberation Dev Team - https://github.com/KillahPotatoes, PiG13BR - https://github.com/PiG13BR
    Date: 10/11/2025
    Last Update: 23/07/2026
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

private _infButtonCtrl = _display displayCtrl IDC_INFANTRY_BUTTON;
private _transButtonCtrl = _display displayCtrl IDC_TRANSPORT_BUTTON;
private _combatvehButtonCtrl = _display displayCtrl IDC_COMBATVEH_BUTTON;
private _aerialButtonCtrl = _display displayCtrl IDC_AERIAL_BUTTON;
private _defencesButtonCtrl = _display displayCtrl IDC_DEFENCE_BUTTON;
private _decorativeButtonCtrl = _display displayCtrl IDC_BUILDING_BUTTON;
private _supportButtonCtrl = _display displayCtrl IDC_SUPPORT_BUTTON;

private _iscommandant = false;
if (player == [] call KPLIB_fnc_getCommander) then {
    _iscommandant = true;
};

// Show or hide squad composition tab
_squadButtonCtrl ctrlEnable _iscommandant;
_mannedButtonCtrl ctrlEnable _iscommandant;

private _crewButtonCtrl = _display displayCtrl IDC_CREW_BUTTON;
_crewButtonCtrl ctrlEnable false;

// Fob or outpost
private _buildPos = ([getPosATL player] call KPLIB_fnc_getNearestBuildPos);
_buildPos params ["_posBuild", "_radius"];

private _inAirport = (KPLIB_sectors_airport findIf {(_posBuild) inArea _x}) >= 0;

// Airport area
if (_inAirport && (_posBuild distance2D player > _radius)) then {
    // Disable these commands as default
    _infButtonCtrl ctrlEnable false;
    _squadButtonCtrl ctrlEnable false;
    _transButtonCtrl ctrlEnable false;
    _combatvehButtonCtrl ctrlEnable false;
};

// Outposts
if ((_posBuild in KPLIB_player_outposts) && ((player distance2D _posBuild) < _radius)) then {
    // Disable controls for outpost
    {_x ctrlEnable false}forEach [_infButtonCtrl, _transButtonCtrl, _combatvehButtonCtrl, _aerialButtonCtrl, _supportButtonCtrl, _squadButtonCtrl];
};

// Check for permissions
if !(player getVariable ['KPLIB_hasDirectAccess', false]) then {
    if !([0, "BUILD"] call KPLIB_fnc_hasPermission) then {_infButtonCtrl ctrlEnable false; _squadButtonCtrl ctrlEnable _iscommandant;};
    if !([1, "BUILD"] call KPLIB_fnc_hasPermission) then {_transButtonCtrl ctrlEnable false;};
    if !([2, "BUILD"] call KPLIB_fnc_hasPermission) then {_combatvehButtonCtrl ctrlEnable false;};
    if !([3, "BUILD"] call KPLIB_fnc_hasPermission) then {_aerialButtonCtrl ctrlEnable false;};
    if !([4, "BUILD"] call KPLIB_fnc_hasPermission) then {_defencesButtonCtrl ctrlEnable false;};
    if !([5, "BUILD"] call KPLIB_fnc_hasPermission) then {_decorativeButtonCtrl ctrlEnable false;};
    if !([6, "BUILD"] call KPLIB_fnc_hasPermission) then {_supportButtonCtrl ctrlEnable false;};
};

[_display] call KPLIB_fnc_build_updateTypesButtons;

// Show the first enabled build list
switch (true) do {
    case (ctrlEnabled _infButtonCtrl) : {[BUILDTYPE_INFANTRY, _display] call KPLIB_fnc_build_fillLnb;};
    case (ctrlEnabled _transButtonCtrl) : {[BUILDTYPE_TRANSPORT, _display] call KPLIB_fnc_build_fillLnb;};
    case (ctrlEnabled _combatvehButtonCtrl) : {[BUILDTYPE_COMBATVEH, _display] call KPLIB_fnc_build_fillLnb;};
    case (ctrlEnabled _aerialButtonCtrl) : {[BUILDTYPE_AERIAL, _display] call KPLIB_fnc_build_fillLnb;};
    case (ctrlEnabled _defencesButtonCtrl) : {[BUILDTYPE_DEFENCE, _display] call KPLIB_fnc_build_fillLnb;};
    case (ctrlEnabled _decorativeButtonCtrl) : {[BUILDTYPE_BUILDING, _display] call KPLIB_fnc_build_fillLnb;};
    case (ctrlEnabled _supportButtonCtrl) : {[BUILDTYPE_SUPPORT, _display] call KPLIB_fnc_build_fillLnb;};
};

// Disable user actions
inGameUISetEventHandler ["PrevAction", "true"];
inGameUISetEventHandler ["NextAction", "true"];
inGameUISetEventHandler ["Action", "true"];