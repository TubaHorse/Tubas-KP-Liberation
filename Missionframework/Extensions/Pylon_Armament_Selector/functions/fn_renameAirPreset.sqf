#include "..\defines.hpp"
/*
	File: fn_renameAirPreset.sqf
	Author: PiG13BR - https://github.com/PiG13BR
	Date: 14/10/2025
	Last Update: 22/06/2025
	License: MIT License - http://www.opensource.org/licenses/MIT

	Description:
        Rename preset. Only possible for profile presets.

	Parameter(s):
		_control - preset name edit box [CONTROL]
	
	Returns:
		-
*/
params["_control"];

private _display = ctrlParent _control;

private _ctlrPresetsListBox = _display displayCtrl IDC_PRESETS_LISTBOX;
private _ctrlRenameEdit = _display displayCtrl IDC_RENAME_EDIT;

private _aircraft = localNameSpace getVariable ["PIG_PAS_aircraft", objNull];

if ((lbCurSel _ctlrPresetsListBox ) isEqualTo -1) exitWith {[localize "STR_PAS_NO_PRESET_RENAME_WARN", true, 5, 2] call ace_common_fnc_displayText};
private _key = _ctlrPresetsListBox  lbText (lbCurSel _ctlrPresetsListBox ); // The text that shows in the lb is the key name in the hashmaps
if (toLowerANSI(_key) in PIG_PAS_cfgPresets) exitWith {[localize "STR_PAS_CFG_WARN", true, 5, 2] call ace_common_fnc_displayText};

private _profilePresets = profileNamespace getVariable ["PIG_PAS_profilePresets", createHashMap];

if ((ctrlText _ctrlRenameEdit) isEqualTo "") exitWith {[localize "STR_PAS_ENTER_NAME_WARN", true, 5, 2] call ace_common_fnc_displayText};

// The renamed key
private _renamedText = (ctrlText _ctrlRenameEdit);
if (_renamedText in _profilePresets) exitWith {[[localize "STR_PAS_ENTER_NAME_ERROR", str _renamedText], 1.5, ACE_player] call ace_common_fnc_displayTextStructured};

// Save original value
private _value = _profilePresets get _key; 
// Delete key
_profilePresets deleteAt _key;
// Save new key and get original value from the deleted key
_profilePresets set [_renamedText, _value];
// Update lb text
_ctlrPresetsListBox lbSetText [(lbCurSel _ctlrPresetsListBox), _renamedText];
[_aircraft, _ctlrPresetsListBox] call KPLIB_fnc_reloadPresetsLb; 