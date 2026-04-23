#include "..\defines.hpp"
/*
    File: fn_baseName_setDefaultName.sqf
    Author: PiG13BR - https://github.com/PiG13BR
    Date: 13/04/2026
    Last Update: 14/04/2026
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Sets the default name for the base

    Parameter(s):
        _button - default button [CONTROL]

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

private _index = KPLIB_player_fobs findIf {(_x distance2d _base) < 100};
if (_index >= 0) exitWith {
    private _defaultName = KPLIB_militaryAlphabet select _index;
    KPLIB_fobNames set [_index, _defaultName];
    _editCtrl ctrlSetText _defaultName;
    ["KPLIB_updateBaseMarkers", []] call CBA_fnc_serverEvent;
    true
};

private _index = KPLIB_player_outposts findIf {(_x distance2d _base) < 100};
if (_index >= 0) exitWith {
    private _defaultName = KPLIB_militaryAlphabet select _index;
    KPLIB_outpostNames set [_index, _defaultName];
    _editCtrl ctrlSetText _defaultName;
    ["KPLIB_updateBaseMarkers", []] call CBA_fnc_serverEvent;
    true;
};

false