#include "..\defines.hpp"
/*
	File: fn_reloadPresetControls.sqf
	Author: PiG13BR - https://github.com/PiG13BR
	Date: 14/10/2025
	Last Update: 22/06/2026
	License: MIT License - http://www.opensource.org/licenses/MIT

	Description:
        Resets presets buttons and creates a profile variable if not existent

	Parameter(s):
		_display - pylon manager display [DISPLAY, defaults to (findDisplay IDD_PAS_MENU)]
	
	Returns:
		-
*/
params[["_display", (findDisplay IDD_PAS_MENU)]];

// Create variable in profilenamespace
if (isNil {(profileNamespace getVariable "PIG_PAS_profilePresets")}) then {[] call KPLIB_fnc_resetAirProfileLoadout};

// Disable all preset buttons (default)
(_display displayCtrl IDC_SAVE_BUTTON) ctrlEnable false;	// Save
(_display displayCtrl IDC_LOAD_BUTTON) ctrlEnable false;	// Load
(_display displayCtrl IDC_DELETE_BUTTON) ctrlEnable false;	// Delete
(_display displayCtrl IDC_RENAME_BUTTON) ctrlEnable false;	// Rename
(_display displayCtrl IDC_SAVENEW_BUTTON) ctrlEnable false;	// Save new preset

private _ctlrPresetsListBox = _display displayCtrl IDC_PRESETS_LISTBOX;
_ctlrPresetsListBox lbSetCurSel 0;