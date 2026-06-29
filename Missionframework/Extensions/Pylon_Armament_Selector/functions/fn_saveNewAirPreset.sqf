#include "..\defines.hpp"
/*
	File: fn_saveNewAirPreset.sqf
	Author: PiG13BR - https://github.com/PiG13BR
	Date: 14/10/2025
	Last Update: 22/06/2026
	License: MIT License - http://www.opensource.org/licenses/MIT

	Description:
        Save new preset

	Parameter(s):
		_control - save new preset button [CONTROL]
	
	Returns:
		-
*/
params["_control"];

private _display = ctrlParent _control;

private _ctrlRenameEdit = _display displayCtrl IDC_RENAME_EDIT;
private _ctlrPresetsListBox = _display displayCtrl IDC_PRESETS_LISTBOX;

if ((ctrlText _ctrlRenameEdit) isEqualTo "") exitWith {[localize "STR_PAS_ENTER_NAME_WARN", true, 5, 2] call ace_common_fnc_displayText};

// Get new key name
private _key = (ctrlText _ctrlRenameEdit);
// Get profile hashmap
private _profilePresets = profileNamespace getVariable ["PIG_PAS_profilePresets", createHashMap];
// Check for similar names/key in presets
if ((_key in _profilePresets) || {toLowerANSI(_key) in PIG_PAS_cfgPresets}) exitWith {systemChat format [localize "STR_PAS_ENTER_NAME_ERROR", str _key]};

private _aircraft = localNameSpace getVariable ["PIG_PAS_aircraft", objNull];
private _loadout = PIG_PAS_airLoadout;

_profilePresets set [(_key), [typeOf _aircraft, _loadout], true]; // Set a new key

[_aircraft, _ctlrPresetsListBox] call KPLIB_fnc_reloadPresetsLb;