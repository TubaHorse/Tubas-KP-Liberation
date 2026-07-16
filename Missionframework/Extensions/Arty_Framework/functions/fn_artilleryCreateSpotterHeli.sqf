/*
    File: fn_artilleryCrateSpotterHeli.sqf
    Author: PiG13BR - https://github.com/PiG13BR
	Date: 14/07/2026
	Last Update: 16/07/2026
	License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Spawns an enemy helicopter and make it loiter the target position to call artillery strike.
    
    Parameter(s):
        _targetPos - artillery strike position [POSITION, defaults to [0,0,0]]
        _spawnPoint - helicopter spawn point [STRING, defaults to ""]
    
    Returns:
        Function reached the end [BOOL]

*/
params[["_targetPos", [0,0,0], [[]], [2,3]], ["_spawnPoint", "", [""]]];

if (KPLIB_o_artilleryUnits isEqualTo []) exitWith {false};
if (missionNamespace getVariable ["KPLIB_artilleryFob", false]) exitWith {false};

// Get target position if not provided
if (_targetPos isEqualTo [0,0,0]) then {
    _targetPos = [_targetPos] call KPLIB_fnc_getNearestFob;
};
if (_targetPos isEqualTo []) exitWith {false};

private _heliClass = "";
if (_heliClass isEqualTo "") then {
    _heliClass = selectRandom (KPLIB_o_helicopters select {_x in KPLIB_o_troopTransports});
};
if (_heliClass isEqualTo "") exitWith {false};

// Get spawn point if not provided
if (_spawnPoint isEqualTo "") then {
    _spawnPoint = [1500, 5000, false, _targetPos] call KPLIB_fnc_getOpforSpawnPoint;
};
if (_spawnPoint isEqualTo "") exitWith {false};

private _newHeli = [markerpos _spawnPoint, _heliClass] call KPLIB_fnc_spawnVehicle;
if (isNull _newHeli) exitWith {[format["No helicopter spawned to scout for target pos (%1)", _targetPos], "HELICOPTER TRANSPORT"] call KPLIB_fnc_log; false};

private _pilot_group = (group (driver _newHeli));

_newHeli addMPEventHandler ["MPKilled", {
    params ["_unit", "_killer"];
    ["KPLIB_manageKills", [_unit,_killer]] call CBA_fnc_localEvent;
}];
{
    _x addMPEventHandler ["MPKilled", {
        params ["_unit", "_killer"];
        ["KPLIB_manageKills", [_unit, _killer]] call CBA_fnc_localEvent;
    }];
} forEach (crew _newHeli);

{ deleteWaypoint _x } forEachReversed waypoints _pilot_group;

_newHeli flyInHeight 50;

_pilot_group setBehaviour "CARELESS";

// Split pilot-turret groups and reveal ground targets for heli gunners
private _turretGrp = createGroup [KPLIB_side_enemy, true];
private _fullCrew = fullCrew [_newHeli, "", true];
{
    private _unit = _x # 0;
    private _role = _x # 1;
    if (_role == "gunner" || _role == "turret" || _role == "cargo") then {
        [_unit] join _turretGrp
    };
}forEach _fullCrew;

_turretGrp setBehaviour "COMBAT";
_turretGrp setCombatMode "RED";

// Loiter
(leader _pilot_group) doMove _targetPos;
private _wp1 = _pilot_group addWaypoint [_targetPos, -1];
_wp1 setWaypointType "LOITER";
_wp1 setWaypointLoiterType (selectRandom ["CIRCLE", "CIRCLE_L"]);
_wp1 setWaypointLoiterAltitude 50;
_wp1 setWaypointLoiterRadius KPLIB_range_fob;

missionNamespace setVariable ["KPLIB_artilleryFob", true, true];

[_newHeli, _turretGrp, _targetPos, _spawnPoint, _pilot_group] spawn {
    params["_heli", "_turretGrp", "_targetPos", "_spawnPoint", "_pilot_group"];

    _fnc_heliRTB = {
        params["_heli", "_returnMarker"];

        _waypoint = (group (driver _heli)) addWaypoint [getMarkerPos _returnMarker, 0];
        _waypoint setWaypointType "MOVE";
        _waypoint setWaypointSpeed "FULL";
        _waypoint setWaypointBehaviour "CARELESS";
        _waypoint setWaypointCombatMode "BLUE";
        _waypoint setWaypointCompletionRadius 100;

        waitUntil {sleep 1; (_heli distance2D (getMarkerPos _returnMarker)) < 200 || {!alive _heli} || {alive _x || [_x] call KPLIB_fnc_ace_isAwake} count crew _heli < 1};

		if (!alive _heli) exitWith {};
        deleteVehicleCrew _heli;
		deleteVehicle _heli;
    };
    
    waitUntil {sleep 1; !alive _heli || {_heli distance2D _targetPos < KPLIB_range_fob * 2}};
    
        // Get countermeasures
	private "_counterMeasures";
	{
		private _currentWeapons = _heli weaponsTurret _x;
		_counterMeasures = _currentWeapons select {tolower ((_x call bis_fnc_itemType) select 1) in ["countermeasureslauncher"]};
		if (_counterMeasures isNotEqualTo []) exitWith {}; // Found
	}forEach ([[-1]] + allTurrets _heli);

	[_heli, _counterMeasures, _targetPos] spawn {
		params["_heli", "_counterMeasures", "_targetPos"];

		private _flareType = selectRandom _counterMeasures;
		if (isNil "_flareType") exitWith {}; // Flare type not found
		private _counterModes = (getArray (configFile >> "CfgWeapons" >> _flareType >> "modes"));

		// Fire flares until exit the area
		while {((_heli distance2d _targetPos) < 500) && (alive _heli) && (({alive _x || [_x] call KPLIB_fnc_ace_isAwake} count (crew _heli)) > 0)} do {
			if (((getPosATL _heli) # 2) < 10) then {continue};
            (driver _heli) forceWeaponFire [_flareType, (selectRandom _counterModes)];
			sleep (3 + (random 1));
		};
	};

    private _time = serverTime;
    while {alive _heli && (serverTime < (_time + (30 + (random [20,30,40]))))} do {
        private _bluforEntities = [_targetPos, KPLIB_range_fob, KPLIB_side_player] call KPLIB_fnc_getNearbyEntities;

        {
            _turretGrp reveal [_x, 4];
        }forEach _bluforEntities;

        sleep 5;
    };

    if (!alive _heli) exitWith {missionNamespace setVariable ["KPLIB_artilleryFob", false, true];};

    // Arty fire
    if (_targetPos in KPLIB_player_fobs) then {
        [_targetPos] call KPLIB_fnc_artilleryFobFiring;
    } else {
        [_targetPos, 150, "HE", (6 + (random 6))] call KPLIB_fnc_fireArtillery;
    };
    

    if (alive _heli) then {
        // Despawn heli
        { deleteWaypoint _x } forEachReversed waypoints _pilot_group;
        [_heli, _spawnPoint] spawn _fnc_heliRTB;
    };

    missionNamespace setVariable ["KPLIB_artilleryFob", false, true];
};

true