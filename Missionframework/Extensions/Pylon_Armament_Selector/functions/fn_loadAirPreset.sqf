#include "..\defines.hpp"
/*
	File: fn_loadAirPreset.sqf
	Author: PiG13BR - https://github.com/PiG13BR
	Date: 14/10/2025
	Last Update: 27/06/2026
	License: MIT License - http://www.opensource.org/licenses/MIT

	Description:
        Visualy loads the selected preset on the aircraft

	Parameter(s):
		_aircraft - aircraft to load the preset [OBJECT]
		_preset - name of the preset to load in [STRING]
	
	Returns:
		-
*/

params["_aircraft", "_preset", ["_display", (findDisplay IDD_PAS_MENU)]];

private _ctrlPylonsListBox = _display displayCtrl IDC_PYLONS_LISTBOX;
private _ctrlMagazinesListBox = _display displayCtrl IDC_MAGAZINES_LISTBOX;
private _ctlrPresetsListBox = _display displayCtrl IDC_PRESETS_LISTBOX;
private _ctrlTurretButton = _display displayCtrl IDC_TURRET_BUTTON;

// Cfg Preset
if (toLowerANSI(_preset) in PIG_PAS_cfgPresets) then {
	private _pylonsCfg = PIG_PAS_cfgPresets get (tolowerANSI _preset);
	if (_pylonsCfg isEqualTo []) then {
		// Reset to default
		lbClear _ctrlPylonsListBox;
		_pylonPaths = configProperties [configFile >> "CfgVehicles" >> (typeOf _aircraft) >> "Components" >> "TransportPylonsComponent" >> "Pylons", "isClass _x"];

		{
			_pylonName = configName _x;
			_ctrlPylonsListBox lbAdd (_pylonName + " " + "-" + " " + "empty");
			_ctrlPylonsListBox lbSetData [_forEachIndex, _pylonName]; // Save the default names
			_ctrlPylonsListBox lbSetColor [_forEachIndex, [1, 0, 0, 1]]; // RED COLOR
			private _turret = [_aircraft, _forEachIndex] call KPLIB_fnc_getPylonTurret;
			//[_aircraft, _forEachIndex + 1, "", _turret] call KPLIB_fnc_setPylonConfiguration;
			["PAS_setPylonArmament", [_aircraft, _forEachIndex + 1, "", _turret]] call CBA_fnc_globalEvent;
		} forEach _pylonPaths;
	};

	{
		private _magazine = _x # 0;
		private _turret = _x # 1;
		if (_magazine isEqualTo "") then {
			_defaultName = _ctrlPylonsListBox lbData _forEachIndex;
			_ctrlPylonsListBox lbSetText [_forEachIndex, _defaultName + " " + "-" + " " + "empty"];
			_ctrlPylonsListBox lbSetColor [_forEachIndex, [1, 0, 0, 1]]; // RED COLOR
		} else {
			private _magName = getText(configFile >> "cfgMagazines" >> _magazine >> "displayName");
			_ctrlPylonsListBox lbSetText [_forEachIndex, _magName];
			_ctrlPylonsListBox lbSetColor [_forEachIndex, [0, 0.7, 0, 1]]; // GREEN COLOR
		};

		//[_aircraft, _forEachIndex + 1, _magazine, _turret] call KPLIB_fnc_setPylonConfiguration;
		["PAS_setPylonArmament", [_aircraft, _forEachIndex + 1, _magazine, _turret]] call CBA_fnc_globalEvent;
	}forEach _pylonsCfg;
};

// Profile presets
private _profilePresets = profileNamespace getVariable ["PIG_PAS_profilePresets", createHashMap];
if (_preset in _profilePresets) then {
	private _pylonsProfile = ((_profilePresets get _preset) # 1); // # 1 = array that cointains the magazines and pylons in order
	{
		if (_x isEqualType "") exitWith {hint "Wrong preset format detected. Delete or redo it."}; // Stringtable this
		private _magazine = _x # 0;
		private _turret = _x # 1;
		if (_magazine isEqualTo "") then {
			_defaultName = _ctrlPylonsListBox lbData _forEachIndex;
			_ctrlPylonsListBox lbSetText [_forEachIndex, _defaultName + " " + "-" + " " + "empty"];
			_ctrlPylonsListBox lbSetColor [_forEachIndex, [1, 0, 0, 1]]; // RED COLOR
		} else {
			private _magName = getText(configFile >> "cfgMagazines" >> _magazine >> "displayName");
			_ctrlPylonsListBox lbSetText [_forEachIndex, _magName];
			_ctrlPylonsListBox lbSetColor [_forEachIndex, [0, 0.7, 0, 1]]; // GREEN COLOR
		};

		//[_aircraft, _forEachIndex + 1, _magazine, _turret] call KPLIB_fnc_setPylonConfiguration;
		["PAS_setPylonArmament", [_aircraft, _forEachIndex + 1, _magazine, _turret]] call CBA_fnc_globalEvent;
	}forEach _pylonsProfile;

	// Change turret icon if necessary
	if !(isNull _ctrlTurretButton) then {
		private _pylonSelected = (localNameSpace getVariable ["PIG_PAS_pylonIndex", 0]);
		private _turret = [_aircraft, _pylonSelected] call KPLIB_fnc_getPylonTurret;
		[_ctrlTurretButton, false, _pylonSelected, _turret] call KPLIB_fnc_handleTurretButton;
	};
};