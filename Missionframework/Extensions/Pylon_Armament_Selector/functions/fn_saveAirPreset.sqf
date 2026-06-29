#include "..\defines.hpp"
/*
	File: fn_saveAirPreset.sqf
	Author: PiG13BR - https://github.com/PiG13BR
	Date: 14/10/2025
	Last Update: 22/06/2026
	License: MIT License - http://www.opensource.org/licenses/MIT

	Description:
        Overwrite preset. Only possible for profile presets.

	Parameter(s):
		_control - save air preset button [CONTROL]
	
	Returns:
		-
*/
params["_control"];

private _display = ctrlParent _control;

private _ctlrPresetsListBox = _display displayCtrl IDC_PRESETS_LISTBOX;

if (lbCurSel _ctlrPresetsListBox == -1) exitWith {[localize "STR_PAS_NO_PRESET_WARN", true, 5, 2] call ace_common_fnc_displayText};

private _profilePresets = profileNamespace getVariable ["PIG_PAS_profilePresets", createHashMap];
private _key = _ctlrPresetsListBox lbText (lbCurSel _ctlrPresetsListBox);
private _aircraft = localNameSpace getVariable ["PIG_PAS_aircraft", objNull];

private _loadout = PIG_PAS_airLoadout;
_profilePresets set [(_key), [typeOf _aircraft, _loadout]];

[_aircraft, _ctlrPresetsListBox] call KPLIB_fnc_reloadPresetsLb; 