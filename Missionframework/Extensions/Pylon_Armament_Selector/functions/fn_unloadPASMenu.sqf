#include "..\defines.hpp"
/*
	File: fn_unloadPASMenu.sqf
	Author: PiG13BR - https://github.com/PiG13BR
	Date: 14/10/2025
	Last Update: 26/06/2026
	License: MIT License - http://www.opensource.org/licenses/MIT

	Description:
		Unloads pylon armament selector

	Parameter(s):
		_display - display to unload [DISPLAY, defauls to displayNull]
	
	Returns:
		-
*/
params["_display"];

private _aircraft = localNameSpace getVariable ["PIG_PAS_aircraft", objNull];

// Apply configuration to all clients on unload
private _loadout = PIG_PAS_airLoadout;
{
	_x params["_magazine", "_turret"];
	private _pylonIndex = _forEachIndex;
	["PAS_setPylonArmament", [_aircraft, _pylonIndex + 1, _magazine, _turret]] call CBA_fnc_globalEvent;
}forEach _loadout;

// Clear variables
PIG_PAS_airLoadout = nil;
PIG_PAS_pylonsTurret = nil;

deleteVehicle (localNamespace getVariable 'PIG_PAS_LightSource');
localNamespace setvariable ["PIG_PAS_LightSource", nil];
PIG_PAS_pylonsPosHash = nil;

localNameSpace setVariable ["PIG_PAS_pylonName", nil];

// Unload camera
[] call KPLIB_fnc_unloadCameraHandle;

// Make sure to get rid of the remnant weapons
/*
{
	[_aircraft, _x] remoteExecCall ["KPLIB_fnc_removeTurretWeapons"];
}forEach [[0], [-1]];
*/

if !(isNil "PIG_PAS_turretUpdateHandle") then {
	removeMissionEventHandler ["Draw3D", PIG_PAS_turretUpdateHandle];
};

_aircraft setVariable ["PIG_PAS_isBusy", false];
localNamespace getVariable ["PIG_PAS_aircraft", nil];