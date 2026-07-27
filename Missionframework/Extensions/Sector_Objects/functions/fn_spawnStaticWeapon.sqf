/*
    File: fn_spawnStaticWeapon.sqf
    Author: PiG13BR - https://github.com/PiG13BR
    Date: 22/11/2024 
    Last Update: 26/07/2026
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
       Handles the spawning of a static weapon

    Parameter(s):
        _relPos - relative position to a object [POSITION, PositionRelative]
		_class - classname of the static weapon to spawn [STRING]
		_relDir - relative direction to a object [NUMBER]

    Returns:
        All static weapons [ARRAY]
*/

params ["_relPos", "_class", ["_relDir", random 360, [0]], ["_crewGrp", grpNull ,[grpNull]]];

private _weapon = createVehicle [_class, _relPos, [], 0, "CAN_COLLIDE"];
private _crewArray = [];

if (isNull _crewGrp) then {
    _crewGrp = [_weapon] call KPLIB_fnc_createCrew;
} else {
    [_weapon, KPLIB_side_enemy, _crewGrp] call KPLIB_fnc_createCrew;
};

_crewArray append (units _crewGrp);

_weapon allowdamage false;
_weapon enableSimulation false;
_weapon setDir _relDir;
_weapon setVectorUp surfaceNormal getPosASL _weapon;

if (_crewArray isEqualTo []) exitWith {["No crew spawned in static weapon, deleting it", "WARNING"] call KPLIB_fnc_log; deleteVehicle _weapon; objNull};

[_weapon] call KPLIB_fnc_clearCargo;
[_weapon] call KPLIB_fnc_addObjectInit;

_weapon allowdamage true;
_weapon enableSimulation true;
_weapon enableWeaponDisassembly false;

{
    // Make sure it watches the right direction once spawned, to avoid trying to look at the leader
    [{_this doWatch (_this getPos [300, (getDir _this)]);}, _x, 10] call CBA_fnc_waitAndExecute;
    
	_x addMPEventHandler ["MPKilled", {
		params ["_unit", "_killer"];
		["KPLIB_manageKills", [_unit, _killer]] call CBA_fnc_localEvent;
        if (_unit == gunner (vehicle _unit)) then {
            if (count (crew (vehicle _unit)) > 0) then {
                _nextGunner = selectRandom ((crew (vehicle _unit)) select {alive _x});
                moveOut _unit;
                moveOut _nextGunner;
                _nextGunner moveInGunner (vehicle _unit);
            }
        };
	}];
} forEach _crewArray;

_weapon addMPEventHandler ["MPKilled", {
    params ["_unit", "_killer"];
    ["KPLIB_manageKills", [_unit, _killer]] call CBA_fnc_localEvent;

}];

// Infinite ammo.
_weapon addEventHandler ["Reloaded", {
	params ["_unit", "_weapon", "_muzzle", "_newMagazine", "_oldMagazine"];
    if !(isPlayer (gunner _unit)) then {
        _unit setVehicleAmmo 1;
    };
}];

_weapon
