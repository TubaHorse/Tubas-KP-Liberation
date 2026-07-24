/*
	File: fn_getCfgWeapons.sqf
	Author: PiG13BR - https://github.com/PiG13BR
	Date: 24/07/2026
	Last Update: 24/07/2026
	License: MIT License - http://www.opensource.org/licenses/MIT

	Description:
		Get aircraft weapons from configuration

	Parameter(s):
		_aircraft - aircraft to get config weapons [OBJECT]
	
	Returns:
		Array of weapons classnames
*/
params["_aircraft"];

// Get config weapons
private _cfg = (configOf _aircraft);
private _configWeapons = [];

// Main weapons, generally available in the driver seat.
_configWeapons append (getArray(_cfg >> "weapons"));

// Get turret weapons
private _cfgTurrets = [(_cfg >> "Turrets")] call BIS_fnc_returnChildren;
{
	private _weapons = getArray(_x >> "weapons");
	if (_weapons isNotEqualTo []) then {
		_configWeapons append _weapons
	};
}forEach _cfgTurrets;

_configWeapons