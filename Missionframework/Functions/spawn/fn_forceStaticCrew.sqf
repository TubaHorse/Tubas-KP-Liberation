/*
	File: fn_forceStaticCrew.sqf
	Author: PiG13BR - https://github.com/PiG13BR/
	Date: 26/08/2024 
	Last Update: 23/07/2026
	License: MIT License - http://www.opensource.org/licenses/MIT

	Description:
		Forces crew to stay on static weapon, no matter what
	
	Parameter(s):
		_vehicle - Static weapn [OBJECT, defaults to objNull]
		_grp - crew's group [GROUP, defaults to grpNull]

	Returns:
		Function reached the end [BOOL]
*/

params[["_staticWeapon", objNull,[objNull]], ["_crewGrp", grpNull, [grpNull]]];

if (isNull _staticWeapon) exitWith {false};
if (isNull _crewGrp) exitWith {false};

{
	_x addEventHandler ["Killed", {
		params ["_unit", "_killer"];
        if (_unit == gunner (vehicle _unit)) then {
            if (count (crew (vehicle _unit)) > 0) then {
                _nextGunner = selectRandom ((crew (vehicle _unit)) select {alive _x});
                moveOut _unit;
                moveOut _nextGunner;
                _nextGunner moveInGunner (vehicle _unit);
            }
        };
	}];
} forEach (units _crewGrp);

_staticWeapon addEventHandler ["GetOut", {
    params ["_vehicle", "_role", "_unit", "_turret", "_isEject"];
    if (alive _unit) then {
        switch (_role) do {
            case "gunner" : {
                _unit assignAsGunner _vehicle;
                _unit moveInGunner _vehicle;
            };
            case "commander" : {
                _unit assignAsCommander _vehicle;
                _unit moveInCommander _vehicle
            };
            case "cargo" : {
                _unit assignAsCargo _vehicle;
                _unit moveInCargo _vehicle;
            };
            case "driver" : {
                _unit assignAsDriver _vehicle;
                _unit moveInDriver _vehicle;
            };
        };
    }
}];

true