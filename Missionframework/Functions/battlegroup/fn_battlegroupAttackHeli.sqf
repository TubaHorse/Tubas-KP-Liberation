/*
    File: fn_battlegroupAttackHeli.sqf
    Author: PiG13BR - https://github.com/PiG13BBR
    Date: 30/10/2025 
    Last Update: 26/06/2026
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Spawns an attack helicopter

    Parameter(s):
        _heliClass - vehicle classname [STRING, defaults to ""]
		_targetPos - position to attack [POSITION, defaults to [0 ,0 ,0]
        _spawnPoint - spawn point or sector reference [STRING, defaults to ""]
        _notify - notify players [BOOL, defaults to true]

    Returns:
        Group spawned [GROUP]
*/

params [
    ["_heliClass", "", [""]],
    ["_targetPos", [0 ,0 ,0], [[]]],
    ["_spawnPoint", "", [""]],
    ["_notify", true, [false]]
];

if (!isServer) exitWith {grpNull};

if (_heliClass isEqualTo "") then {
    _heliClass = selectRandom KPLIB_o_attackHelicopters;
};

if (_heliClass isEqualTo "") exitWith {grpNull};

// Get target position if not provided
if (_targetPos isEqualTo [0 ,0 ,0]) then {
    _targetPos = [_targetPos] call KPLIB_fnc_getBluforObjective;
};
if (_targetPos isEqualTo []) exitWith {[]};

// Get spawn point if not provided
if (_spawnPoint isEqualTo "") then {
    _spawnPoint = [1200, 2500, false, _targetPos] call KPLIB_fnc_getOpforSpawnPoint;
};
if (_spawnPoint isEqualTo "") exitWith {grpNull};

private _attackHeli = createVehicle [_heliClass, markerpos _spawnPoint, [], 0, "FLY"];
private _pilot_group = [_attackHeli, KPLIB_side_enemy] call KPLIB_fnc_createCrew;

_attackHeli addMPEventHandler ["MPKilled", {
    params ["_unit", "_killer"];
    ["KPLIB_manageKills", [_unit,_killer]] call CBA_fnc_localEvent;
}];
{
    _x addMPEventHandler ["MPKilled", {
        params ["_unit", "_killer"];
        ["KPLIB_manageKills", [_unit, _killer]] call CBA_fnc_localEvent;
    }];
} forEach (crew _attackHeli);

{ deleteWaypoint _x } forEachReversed waypoints _pilot_group;

_wp1 = _pilot_group addWaypoint [_targetPos, 25];
_wp1 setWaypointType "SAD";
_wp1 setWaypointSpeed "NORMAL";
_wp1 setWaypointBehaviour "COMBAT";
_wp1 setWaypointCompletionRadius 100;

_pilot_group setCombatMode "RED";

// Get countermeasures
private "_counterMeasures";
{
    private _currentWeapons = _attackHeli weaponsTurret _x;
    _counterMeasures = _currentWeapons select {tolower ((_x call bis_fnc_itemType) select 1) in ["countermeasureslauncher"]};
    if (_counterMeasures isNotEqualTo []) exitWith {}; // Found
}forEach ([[-1]] + allTurrets _attackHeli);
_attackHeli setVariable ["KPLIB_heli_counterMeasures", _counterMeasures];

_attackHeli addEventHandler ["IncomingMissile", {
	params ["_target", "_ammo", "_vehicle", "_instigator", "_missile"];

    [_target] spawn {
        params["_target"];
        private _counterMeasures = _target getVariable ["KPLIB_heli_counterMeasures", []];
        private _flareType = selectRandom _counterMeasures;
		if (isNil "_flareType") exitWith {}; // Flare type not found
        for "_i" from 1 to (random 4) do {
            (driver _target) forceWeaponFire [_flareType, "Burst"];
            sleep 0.2;
        };
    };
}];

KPLIB_fnc_findTargetsInSector = {
    params["_targets", "_heliGrp"];
    // Reveal targets inside the sector
    {
        if ((_heliGrp knowsAbout _x) >= 2.5) then {continue};
        _heliGrp reveal [_x, 2.5];
    }forEach _targets;
};

[{
    params["_args", "_handle"];
    _args params ["_targetPos", "_helicopter"];

    if (!alive _helicopter || {!alive (driver _helicopter)}) exitWith {[_handle] call CBA_fnc_removePerFrameHandler;};

    //private _bluforEntities = ([_targetPos, 250, 250, 0, false] nearEntities [["CAManBase", "Landvehicle", "Helicopter"], false, true, true]) select {(side _x) == KPLIB_side_player};
    private _bluforEntities = [_targetPos, 250, KPLIB_side_player] call KPLIB_fnc_getNearbyEntities;
    
    private _heliGroup = (group (driver _helicopter));

    [_bluforEntities, _heliGroup] remoteExecCall ["KPLIB_fnc_findTargetsInSector", groupOwner _heliGroup];

}, 15, [_targetPos, _attackHeli]] call CBA_fnc_addPerFrameHandler;

if (_notify) then {
    ["KPLIB_reinfIncoming", [_spawnPoint, _targetPos]] call CBA_fnc_globalEvent;
};

["KPLIB_battlegroupSpawn", [_pilot_group]] call CBA_fnc_serverEvent;

_pilot_group