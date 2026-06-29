#include "..\defines.hpp"
/*
	File: fn_handleAirPresetsLb.sqf
	Author: PiG13BR - https://github.com/PiG13BR
	Date: 14/10/2025
	Last Update: 22/06/2026
	License: MIT License - http://www.opensource.org/licenses/MIT

	Description:
        Handles presets in listbox

	Parameter(s):
		Listbox passed arguments
	
	Returns:
		-
*/
params ["_control", "_lbCurSel", "_lbSelection"];

if (_lbCurSel == -1) exitWith {};

private _display = ctrlParent _control;

private _ctlrPresetsListBox = _display displayCtrl IDC_PRESETS_LISTBOX;
private _ctrlSaveButton = _display displayCtrl IDC_SAVE_BUTTON;
private _ctrlLoadButton = _display displayCtrl IDC_LOAD_BUTTON;
private _ctrlDeleteButton = _display displayCtrl IDC_DELETE_BUTTON;
private _ctrlRenameButton = _display displayCtrl IDC_RENAME_BUTTON;
private _ctrlRenameEdit = _display displayCtrl IDC_RENAME_EDIT;
private _ctrlSaveNewButton = _display displayCtrl IDC_SAVENEW_BUTTON;

_ctrlLoadButton ctrlEnable true; // Enable Load button

// Get the actual text in the listbox
private _getText = _ctlrPresetsListBox lbText _lbCurSel;

// Get aircraft classname selected
private _aircraft = localNameSpace getVariable ["PIG_PAS_aircraft", objNull];

// Check if it's a cfg preset
/*
private _presets = configProperties [configFile >> "CfgVehicles" >> typeOf _aircraft >> "Components" >> "TransportPylonsComponent" >> "Presets", "isClass _x"];
private _is_preset = false;

{
    if (getText(_x >> "displayName") == _getText) exitWith {_is_preset = true};
}forEach _presets;
*/

private _config = (configFile >> "CfgVehicles" >> typeOf _aircraft >> "Components" >> "TransportPylonsComponent" >> "Presets" >> _getText);
// If it's a cfg preset, disable save/delete/rename button
if (isClass _config) then {
    {
        _x ctrlEnable false;
        _x ctrlSetTooltip (localize "STR_PAS_CFG_WARN");
    }forEach [_ctrlSaveButton, _ctrlDeleteButton, _ctrlRenameButton]
} else { 
    _ctrlSaveButton ctrlEnable true;
    _ctrlSaveButton ctrlSetTooltip (localize "STR_PAS_OVERWRITE_PRESET_TOOLTIP");
    _ctrlDeleteButton ctrlEnable true;
    _ctrlDeleteButton ctrlSetTooltip (localize "STR_PAS_DELETE_PRESET_TOOLTIP");
    _ctrlRenameButton ctrlEnable true;
    _ctrlRenameButton ctrlSetTooltip (localize "STR_PAS_RENAME_PRESET_TOOLTIP");
};

_ctrlRenameEdit ctrlSetText _getText;