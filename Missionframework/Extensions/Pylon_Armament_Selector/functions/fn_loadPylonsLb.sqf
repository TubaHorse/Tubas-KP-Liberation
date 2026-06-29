#include "..\defines.hpp"
/*
	File: fn_loadPylonsLb.sqf
	Author: PiG13BR - https://github.com/PiG13BR
	Date: 14/10/2025
	Last Update: 27/06/2026
	License: MIT License - http://www.opensource.org/licenses/MIT

	Description:
        Load aircraft pylons on the listbox

	Parameter(s):
		_aircraft - aircraft object to load its pylons on listbox [OBJECT]
	
	Returns:
		-
*/

params["_display", "_aircraft"];

private _ctrlPylonsListBox = _display displayCtrl IDC_PYLONS_LISTBOX;
private _ctrlMagazinesListBox = _display displayCtrl IDC_MAGAZINES_LISTBOX;
private _ctlrPresetsListBox = _display displayCtrl IDC_PRESETS_LISTBOX;

lbClear _ctrlPylonsListBox;
lbClear _ctrlMagazinesListBox;
lbClear _ctlrPresetsListBox;

private _allPylonsPos = [_aircraft] call KPLIB_fnc_getAllPylonsPos;
PIG_PAS_pylonsPosHash = createHashMapFromArray _allPylonsPos;

// Get pylons paths
private _pylonPaths = configProperties [configFile >> "CfgVehicles" >> typeOf _aircraft >> "Components" >> "TransportPylonsComponent" >> "Pylons", "isClass _x"];
private _pylonCount = 0; // For couting real pylons

// For pylon listbox
{
    if (getArray (_x >> "hardpoints") isEqualTo []) then { continue }; // Ignore dummy pylons
    
    _pylonName = configName _x;
    
    _ctrlPylonsListBox lbAdd (_pylonName + " " + "-" + " " + "empty");
    _ctrlPylonsListBox lbSetData [_pylonCount, _pylonName]; // Save the default names
    _ctrlPylonsListBox lbSetColor [_pylonCount, [1, 0, 0, 1]]; // RED COLOR

    _pylonCount = _pylonCount + 1; // Count real available pylons
} forEach _pylonPaths;

private _pylonsInfo = getAllPylonsInfo _aircraft;
{
    _x params ["_index", "_pylonName", "_turret", "_magazine"];
    
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
}forEach _pylonsInfo;

// For presets listbox
[_aircraft, _ctlrPresetsListBox] call KPLIB_fnc_reloadPresetsLb;