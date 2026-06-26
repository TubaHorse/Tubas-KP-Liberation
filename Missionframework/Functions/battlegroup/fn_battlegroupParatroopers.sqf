/*
    File: fn_battlegroupParatroopers.sqf
    Author: PiG13BR - https://github.com/PiG13BBR
    Date: 29/10/2025
    Last Update: 26/06/2026
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Spawns an airplane and paradrop units to designated location
        Once the infantry is on the ground, they will regroup first and then attack the target position

    Parameter(s):
        _planeClass - vehicle classname [STRING, defaults to ""]
		_targetPos - position to attack [POSITION, defaults to [0 ,0 ,0]
        _spawnPoint - spawn point or sector reference [STRING, defaults to ""]
        _notify - notify players [BOOL, defaults to true]

    Returns:
        Group spawned [GROUP]
*/

params [
    ["_planeClass", "", [""]],
    ["_targetPos", [0 ,0 ,0], [[]]],
    ["_spawnPoint", "", [""]],
    ["_notify", true, [false]]
];

if (!isServer) exitWith {[]};

// Get heli class if not provided
if (_planeClass isEqualTo "") then {
    _planeClass = selectRandom KPLIB_o_paradropPlanes;
    while {!(_planeClass in KPLIB_o_troopTransports)} do {
        _planeClass = selectRandom KPLIB_o_paradropPlanes;
    };
};
if (_planeClass isEqualTo "") exitWith {[]};

// Get target position if not provided
if (_targetPos isEqualTo [0 ,0 ,0]) then {
    _targetPos = [_targetPos] call KPLIB_fnc_getBluforObjective;
};
if (_targetPos isEqualTo []) exitWith {[]};

// Get spawn point if not provided
if (_spawnPoint isEqualTo "") then {
    // Avoid getting air spawns close by
    _airSpawns = KPLIB_sectors_airSpawn select {(markerPos _x) distance _targetPos > 3000};
    _spawnPoint = ([_airSpawns, [_targetPos], {(markerPos _x) distance _input0}, "ASCEND"] call BIS_fnc_sortBy) select 0;
};
if (_spawnPoint isEqualTo "") exitWith {grpNull};

private _paradropArea = [_targetPos, 800] call KPLIB_fnc_findPlaceToParadrop;

if (_paradropArea isEqualTo [0,0]) exitWith {[]};
private _newPlane = createVehicle [_planeClass, markerpos _spawnPoint, [], 100, "FLY"];
_newPlane setVariable ["KPLIB_planeSpawnMarker", _spawnPoint];
//_newPlane setPosASL [markerpos _spawnPoint # 0, markerpos _spawnPoint # 1, (getTerrainHeightASL (markerpos _spawnPoint)) + 300];
private _pilot_group = [_newPlane, KPLIB_side_enemy] call KPLIB_fnc_createCrew;
_newPlane setDir (getDir _newPlane + (_newPlane getRelDir _targetPos));
_newPlane setVelocityModelSpace [0,100,0];

_newPlane addMPEventHandler ["MPKilled", {
    params ["_unit", "_killer"];
    ["KPLIB_manageKills", [_unit,_killer]] call CBA_fnc_localEvent;
}];
{
    _x addMPEventHandler ["MPKilled", {
        params ["_unit", "_killer"];
        ["KPLIB_manageKills", [_unit, _killer]] call CBA_fnc_localEvent;
    }];
} forEach (crew _newPlane);

{ deleteWaypoint _x } forEachReversed waypoints _pilot_group;

private _infGrp = [_newPlane] call KPLIB_fnc_spawnInfCargo;
if (isNull _infGrp) exitWith {deleteVehicle _newPlane; []};
_newPlane setVariable ["KPLIB_groupCargoPlane", _infGrp];

_newPlane flyInHeightASL [300, 300, 300];

_pilot_group setBehaviour "CARELESS";

// Paradrop wp
private _pathPos1 = _paradropArea getPos [1500, (_newPlane getDir _paradropArea) - 180];
private _wp1 = _pilot_group addWaypoint [_pathPos1, 0];
_wp1 setWaypointType "MOVE";
_wp1 setWaypointSpeed "NORMAL";
_wp1 setWaypointBehaviour "CARELESS";
_wp1 setWaypointCombatMode "BLUE";
_wp1 setWaypointCompletionRadius 400;

private _wp2 = _pilot_group addWaypoint [_paradropArea, 25];
_wp2 setWaypointType "MOVE";
_wp2 setWaypointSpeed "LIMITED"; // Slow down
_wp2 setWaypointCompletionRadius 400;
_pilot_group setVariable ["KPLIB_paradropWp", _wp2];

private _wp1Inf = _infGrp addWaypoint [_paradropArea, 0];
_wp1Inf setWaypointType "MOVE";
_wp1Inf setWaypointSpeed "FULL";
_infGrp setVariable ["KPLIB_infparadropWp", _wp1Inf];

_infGrp setSpeedMode "FULL";

_infGrp addEventHandler ["WaypointComplete",{
    params ["_group", "_waypointIndex"];

    private _wpIndex = _group getVariable ["KPLIB_infparadropWp", []];
    
    if (_wpIndex # 1 == _waypointIndex) then {

        // Spawns an orange smoke in the paradrop assembling area
        private _moduleGroup = createGroup [sideLogic, true];
        "ModuleSmokeOrange_F" createUnit [
            (waypointPosition _wpIndex),
            _moduleGroup,
            "this setVariable ['BIS_fnc_initModules_disableAutoActivation', false, true];"
        ];
        _group removeEventHandler [_thisEvent, _thisEventHandler];
    };
}];


// Plane RTB
KPLIB_fnc_planeRTB = {
    params["_plane", "_returnMarker"];

    _plane flyInHeightASL [500, 500, 500];

    _waypoint = (group (driver _plane)) addWaypoint [getMarkerPos _returnMarker, 1000];
    _waypoint setWaypointType "MOVE";
    _waypoint setWaypointSpeed "FULL";
    _waypoint setWaypointBehaviour "CARELESS";
    _waypoint setWaypointCombatMode "BLUE";
    _waypoint setWaypointCompletionRadius 400;
    (group (driver _plane)) setVariable ["KPLIB_planeDeleteWp", _waypoint];


    (group (driver _plane)) addEventHandler ["WaypointComplete",{
        params ["_group", "_waypointIndex"];

        private _driver = (units _group) select {(assignedVehicleRole _x) isEqualTo ["driver"]}; 
        private _plane = assignedVehicle (_driver # 0);
        private _wpIndex = _group getVariable ["KPLIB_planeDeleteWp", []];
        if (_wpIndex # 1 == _waypointIndex) then {
            if (!alive _plane) exitWith {};
            deleteVehicleCrew _plane;
            deleteVehicle _plane;
        }
    }];
};

// Drop off units 
_pilot_group addEventHandler ["WaypointComplete",{
    params ["_group", "_waypointIndex"];

    private _wpIndex = _group getVariable ["KPLIB_paradropWp", []];
    if (_wpIndex # 1 == _waypointIndex) then {

        private _driver = (units _group) select {(assignedVehicleRole _x) isEqualTo ["driver"]}; 
        private _plane = assignedVehicle (_driver # 0);
        private _infGrp = _plane getVariable ["KPLIB_groupCargoPlane", grpNull];

        if (!alive _plane || {({alive _x} count (units _infGrp) < 1) && {isNull _infGrp}}) exitWith {_group removeEventHandler ["WaypointComplete", _thisEventHandler]};

        // Add a waypoint to maintain path
        private _wp3 = _group addWaypoint [_plane getPos [1000, (getDir _plane)], 0];
        _wp3 setWaypointType "MOVE";
        _wp3 setWaypointCompletionRadius 400;

        [(units _infGrp)] allowGetIn false;
        [_infGrp, _plane] spawn {
            params ["_infGrp", "_plane"];
            {
                _x setVariable ["KPLIB_paratrooper_backpack", [backpack _x, backpackItems _x]];
                removeBackpack _x; 
                _x addBackPack KPLIB_o_parachuteType;
                sleep 0.5;
                unassignVehicle _x;
                moveout _x;
            } forEach (units _infGrp);
            private _spawnMarker = _plane getVariable ["KPLIB_planeSpawnMarker", []];

            [_plane, _spawnMarker] call KPLIB_fnc_planeRTB; // Plane RTB
        };
        
        _group removeEventHandler [_thisEvent, _thisEventHandler];
    };
}];


// Units arriving at regroup locations
KPLIB_fnc_assemblingArea = {
    params["_grpInf", "_paradropArea", "_targetPos"];

    {
        private _unit = _x;
        private _backpackContents = _unit getVariable ["KPLIB_paratrooper_backpack", []];
        _unit addBackpack (_backpackContents # 0);
        {_unit addItemToBackpack _x} foreach (_backpackContents # 1);
    }forEach (units _grpInf);

    [{
        params["_args", "_handle"];
        _args params ["_grpInf", "_paradropArea", "_targetPos"];
        
        if (({alive _x && [_x] call KPLIB_fnc_ace_isAwake} count (units _grpInf)) < 1) exitWith {[_handle] call CBA_fnc_removePerFrameHandler;}; // Delete PFH

        // Keep IA units moving to reach assembling area
        {
            if (_X distance _paradropArea > 100) then {_x doMove _paradropArea;};
        }forEach units (_grpInf);
        
        // Check if all units arrived at assembling area
        if ({(_x distance (leader _grpInf) < 125) && {alive _x} && {[_x] call KPLIB_fnc_ace_isAwake}} count (units _grpInf) >= (count units _grpInf)) then {
            [_grpInf, _targetPos] call KPLIB_fnc_battlegroupAttack; // Commit inf to attack
            [_handle] call CBA_fnc_removePerFrameHandler; // Delete PFH
        };

    }, 15, [_grpInf, _paradropArea, _targetPos]] call CBA_fnc_addPerFrameHandler;
};

// Check landing
[{
    params["_args", "_handle"];
    _args params ["_grpInf", "_paradropArea", "_targetPos"];

    if (({alive _x && [_x] call KPLIB_fnc_ace_isAwake} count (units _grpInf)) < 1) exitWith {[_handle] call CBA_fnc_removePerFrameHandler;}; // Delete PFH

    // Detect units that landed on water or uncounsionus, delete them
    private _unableUnits = (units _grpInf) select {(isTouchingGround _x || ((getPosATL _x # 2) < 2)) && {surfaceIsWater (getPosATL _x) || !([_x] call KPLIB_fnc_ace_isAwake)} };

    {
        if !([_x] call KPLIB_fnc_ace_isAwake) then {_x setDamage 1} else {deleteVehicle _x};
    }forEach _unableUnits;

    // Check if all units from the group landed and exit loop
    if ({isTouchingGround _x || ((getPosATL _x # 2) < 2)} count (units _grpInf) >= count (units _grpInf)) then {
        [_grpInf, _paradropArea, _targetPos] remoteExecCall ["KPLIB_fnc_assemblingArea", groupOwner _grpInf];

        [_handle] call CBA_fnc_removePerFrameHandler; // Delete PFH
    };
}, 10, [_infGrp, _paradropArea, _targetPos]] call CBA_fnc_addPerFrameHandler;

if (_notify) then {
    ["KPLIB_reinfIncoming", [_spawnPoint, _targetPos]] call CBA_fnc_globalEvent;
};

["KPLIB_battlegroupSpawn", [_infGrp]] call CBA_fnc_serverEvent; // Pass only inf group to HC

[_pilot_group, _infGrp]