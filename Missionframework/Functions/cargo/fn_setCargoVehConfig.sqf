/*
	File: fn_setCargoVehConfig.sqf
	Author: PiG13BR (https://github.com/PiG13BR)
	Date: 21/10/2025
	Last update: 09/07/2026
	License: MIT License - http://www.opensource.org/licenses/MIT

	Description:
		Add transport configuration to the vehicle to receive cargo

	Parameters:
		_vehicle - vehicle to set transport configuration [OBJECT, defaults to objNull]

	Return:
		[BOOL]
*/

params [["_vehicle", objNull, [objNull]]];

if (isNull _vehicle) exitWith {["[CARGO LOAD] Object is Null"] call BIS_fnc_error; false};
if !(toLowerANSI(typeOf _vehicle) in KPLIB_transport_classes) exitWith {false};

// To load crates
private _index = KPLIB_transport_classes find toLowerANSI(typeOf _vehicle);
private _offsets = (KPLIB_transportConfigs # _index) select {_x isEqualType []};

_vehicle setVariable ["KPLIB_CARGO_isTransportVeh", true, true];
_vehicle setVariable ["KPLIB_CARGO_offSets", _offsets, true];
_vehicle setVariable ["KPLIB_CARGO_unloadOffset", (KPLIB_transportConfigs # _index) # 1, true];

_vehicle addMPEventHandler ["MPKilled", {
    params ["_vehicle"];
	["KPLIB_deleteCargo", _vehicle] call CBA_fnc_localEvent;
}];

// Add unload action
["KPLIB_addActionUnloadCrate", _vehicle] call CBA_fnc_globalEventJIP;

if (_vehicle isKindOf "Air") then {
    // Add paradrop action
    ["KPLIB_addActionParadropCrates", _vehicle] call CBA_fnc_globalEventJIP;
};

_vehicle addEventHandler ["RopeAttach", {
	params ["_heli", "_rope", "_cargo"];

	if (typeOf _cargo == KPLIB_b_transStorage) then {
		_cargo setVariable ["KPLIB_ropeAttached", true, true];
	};
}];

_vehicle addEventHandler ["RopeBreak", {
	params ["_heli", "_rope", "_cargo"];

	if (typeOf _cargo == KPLIB_b_transStorage) then {
		_cargo setVariable ["KPLIB_ropeAttached", false, true];
	};
}];

true