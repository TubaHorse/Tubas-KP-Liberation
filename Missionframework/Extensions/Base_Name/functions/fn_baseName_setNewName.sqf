#include "..\defines.hpp"
/*
    File: fn_baseName_setNewName.sqf
    Author: PiG13BR - https://github.com/PiG13BR
    Date: 13/04/2026
    Last Update: 29/04/2026
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Sets a new name for the base

    Parameter(s):
        _button - confirm button [CONTROL]

    Returns:
        [BOOL]
*/
params["_button"];

// Get base position
private _base = localNamespace getVariable ["KPLIB_basePosition", [0,0,0]];

if (_base isEqualTo [0,0,0]) exitWith {["No position provided"] call BIS_fnc_error; false};

// Controls
private _display = (ctrlParent _button);
private _editCtrl = _display displayCtrl IDC_EDIT;

// Get name from edit box
private _newName = ctrlText _editCtrl;

if (_newName isEqualTo "") exitWith {["No name provided", true, 3] call KPLIB_fnc_hint; false};

private _index = KPLIB_player_fobs findIf {(_x distance2d _base) < 100};
if (_index >= 0) exitWith {
    KPLIB_fobNames set [_index, _newName];
    publicVariable "KPLIB_fobNames";
    ["KPLIB_updateBaseMarkers", []] call CBA_fnc_serverEvent;
    true
};

private _index = KPLIB_player_outposts findIf {(_x distance2d _base) < 100};
if (_index >= 0) exitWith {
    KPLIB_outpostNames set [_index, _newName];
    publicVariable "KPLIB_outpostNames";
    ["KPLIB_updateBaseMarkers", []] call CBA_fnc_serverEvent;
    true;
};

false