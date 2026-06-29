#include "..\defines.hpp"
/*
	File: fn_handlePresetEdit.sqf
	Author: PiG13BR - https://github.com/PiG13BR
	Date: 14/10/2025
	Last Update: 22/06/2026
	License: MIT License - http://www.opensource.org/licenses/MIT

	Description:
        Handles preset edit box

	Parameter(s):
		Edit box passed arguments
	
	Returns:
		-
*/
params ["_control", "_newText"];

private _display = ctrlParent _control;

private _ctrlRenameButton = _display displayCtrl IDC_RENAME_BUTTON;
private _ctrlSaveNewButton = _display displayCtrl IDC_SAVENEW_BUTTON;

private _profilePresets = profileNamespace getVariable ["PIG_PAS_profilePresets", createHashMap];
if ((_newText in _profilePresets) || {(toLowerANSI _newText) in PIG_PAS_cfgPresets} || {(toUpperANSI _newText) in PIG_PAS_cfgPresets}) then {
    // Disable save new preset
    _ctrlSaveNewButton ctrlEnable false;
    _ctrlSaveNewButton ctrlSetTooltip (localize "STR_PAS_NAME_WARN");
    // Disable rename preset
    _ctrlRenameButton ctrlEnable false;
    _ctrlRenameButton ctrlSetTooltip (localize "STR_PAS_NAME_WARN");
} else {
    _ctrlSaveNewButton ctrlEnable true;
    _ctrlSaveNewButton ctrlSetTooltip (localize "STR_PAS_SAVENEWPRESET_TOOLTIP");
    _ctrlRenameButton ctrlEnable true;
    _ctrlRenameButton ctrlSetTooltip (localize "STR_PAS_RENAME_PRESET_TOOLTIP");
};