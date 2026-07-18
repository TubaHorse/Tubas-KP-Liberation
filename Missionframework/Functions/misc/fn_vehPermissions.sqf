/*
	File: fn_vehPermissions.sqf
	Author: KP Liberation Dev Team - https://github.com/KillahPotatoes, PiG13BR (https://github.com/PiG13BR)
	Date: -
	Last update: 17/07/2026
	License: MIT License - http://www.opensource.org/licenses/MIT

	Description:
		Check for vehicle permissions

	Parameters:
		_unit - player to check permissions [OBJECT]
        _vehicle - vehicle to check permissions [OBJECT]

	Return:
		-
*/

params ["_unit", "_vehicle"];
private _vehicleClass = toLowerANSI (typeOf _vehicle);

// Cargo and helicopters seats (except pilot) are always allowed
private _isCargo = (_vehicle getCargoIndex _unit) != -1;
if (_isCargo || _vehicle isKindOf "ParachuteBase") exitWith {};
if ((_vehicleClass in KPLIB_typeHeliClasses) && (driver _vehicle != _unit)) exitWith {};

private _permissibleVehicles = [
    [KPLIB_typeLightClasses, "STR_PERMISSION_NO_LIGHT"],
    [KPLIB_typeHeavyClasses, "STR_PERMISSION_NO_ARMOR"],
    [KPLIB_typeHeliClasses, "STR_PERMISSION_NO_AIR"],
    [KPLIB_typePlaneClasses, "STR_PERMISSION_NO_AIR"]
];

private _permissionIdx = _permissibleVehicles findIf {_vehicleClass in (_x select 0)};
if (_permissionIdx isEqualTo -1) exitWith {};

if !([_permissionIdx] call KPLIB_fnc_hasPermission) exitWith {
    moveOut player;
    [localize (_permissibleVehicles select _permissionIdx select 1), true, 5] call KPLIB_fnc_hint;
};
