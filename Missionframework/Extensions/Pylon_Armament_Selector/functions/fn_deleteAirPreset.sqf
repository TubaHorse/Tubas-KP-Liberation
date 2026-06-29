#include "..\defines.hpp"
/*
	File: fn_deleteAirPreset.sqf
	Author: PiG13BR - https://github.com/PiG13BR
	Date: 14/10/2025
	Last Update: 22/06/2026
	License: MIT License - http://www.opensource.org/licenses/MIT

	Description:
		Delete loadout air preset

	Parameter(s):
		-
	
	Returns:
		-
*/
params["_control"];

private _display = ctrlParent _control;
private _ctlrPresetsListBox = _display displayCtrl IDC_PRESETS_LISTBOX;

if ((lbCurSel _ctlrPresetsListBox) isEqualTo -1) exitWith {[localize "STR_PAS_DELETE_WARN", true, 5, 2] call ace_common_fnc_displayText};
private _key = _ctlrPresetsListBox lbText (lbCurSel _ctlrPresetsListBox);
private _profilePresets = (profileNamespace getVariable ["PIG_PAS_profilePresets", ""]);
if (_key in _profilePresets) then {
    _profilePresets deleteAt _key;
    _ctlrPresetsListBox lbDelete (lbCurSel _ctlrPresetsListBox);
};

// Select last cursel
_ctlrPresetsListBox lbSetCurSel (lbCurSel _ctlrPresetsListBox);
private _aircraft = localNameSpace getVariable ["PIG_PAS_aircraft", objNull];
[_aircraft, _ctlrPresetsListBox] call KPLIB_fnc_reloadPresetsLb;