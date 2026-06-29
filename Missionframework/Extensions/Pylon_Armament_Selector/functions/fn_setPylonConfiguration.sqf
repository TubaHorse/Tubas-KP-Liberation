/*
	File: fn_setPylonConfiguration.sqf
	Author: PiG13BR - https://github.com/PiG13BR
	Date: 15/06/2026
	Last Update: 15/06/2026
	License: MIT License - http://www.opensource.org/licenses/MIT

	Description:
		Apply the selected ammo on the pylon of the aircraft

	Parameter(s):
        _ctrl - pylon listbox control [CONTROL]
		_aircraft - aircraft to remove remnant weapons [OBJECT]
        _pylonIndex - pylon index [NUMBER]
        _magazine - magazine to add to pylon [STRING]
        _turret - target turret to add the magazine [ARRAY, defaults to gunner turret [0]]
	
	Returns:
		-
*/
params["_aircraft", "_pylonIndex", "_magazine", ["_turret", [0]]];

PIG_PAS_airLoadout set [(_pylonIndex - 1), [_magazine, _turret]];
_aircraft setPylonLoadout [_pylonIndex, _magazine, false, _turret];

[_aircraft] call KPLIB_fnc_removeTurretWeapons;