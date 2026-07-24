/*
    File: fn_callEnemyFighter.sqf
    Author: PiG13BR - (https://github.com/PiG13BR)
    Date: 17/08/2025
    Last update: 21/07/2026
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Handles enemy air fighter
    
    Parameter(s)
        _target - target player reference [OBJECT, defaults to objNull]

    Returns:
        -
*/

params[["_target", objNull, [objNull]]];

if (isNull _target) exitWith {["No target provided to spawn enemy fighter"] call BIS_fnc_error};

private _targetPos = getPos _target;

if (count KPLIB_bluforAircrafts < 1) exitWith {};

if (isNil "KPLIB_enemy_jetInAir") then {
    KPLIB_enemy_jetInAir = [];
    publicVariable "KPLIB_enemy_jetInAir";
};

if (count KPLIB_enemy_jetInAir >= ((floor KPLIB_param_difficulty) min 3)) exitWith {};

// Spawning enemy jet
private _fighter = [_targetPos] call KPLIB_fnc_spawnEnemyFighter;

if (isNull _fighter) exitWith {["Enemy fighter is null", "ENEMY FIGHTER"] call KPLIB_fnc_log};

KPLIB_enemy_jetInAir pushBack _fighter;
publicVariable "KPLIB_enemy_jetInAir";

// Enemy Jet PFH
[{
    params ["_args", "_handle"];
    _args params ["_plane", "_despawnPos"];

    if ((alive _plane) && (canFire _plane) && (canMove _plane) && (damage _plane <= 0.5) && ({alive _x} count (crew _plane) > 0) && {((getPosATL _plane) # 2) >= 10} && {fuel _plane > 0.2} && {KPLIB_bluforAircrafts isNotEqualTo []}) then {
        private _bluforAir = KPLIB_bluforAircrafts select {(count(crew _x) > 0) && (side(group(effectiveCommander _x)) == KPLIB_side_player) && ((getPos _x) # 2 > 200)};

        private _target = _plane getVariable ["KPLIB_fighterTarget", objNull];
        if (isNull _target) then {
            // Set target
            private _bluforTarget = selectRandom _bluforAir;
            _plane setVariable ["KPLIB_fighterTarget", _bluforTarget];
        } else {
            // Check target status
            if (!(alive _target) || ({alive _x} count (crew _target) < 1)) then {
                // Change target
                private _bluforTarget = selectRandom _bluforAir;
                _plane setVariable ["KPLIB_fighterTarget", _bluforTarget];
            }
        };

        if (local _plane) then {
            _plane reveal [_target, 1.5];
        } else {
            [_plane, [_target, 1.5]] remoteExec ["reveal", _plane];
        };

        {deleteWaypoint _x}forEachReversed (waypoints (group _plane));

        private _wp = (group _plane) addWaypoint [getPosATL _target, 0];
        _wp setWaypointType "MOVE";
        //_wp setWaypointBehaviour "COMBAT";
        _wp setWaypointCombatMode "RED";
    } else {
        if (alive _plane && ({alive _x} count crew _plane > 0)) then {
            // Return to the spawn position 
            (group _plane) setBehaviourStrong "CARELESS";
            {
                [_plane, _x] remoteExec ["ignoreTarget", _plane]
            }forEach _bluforAir; 
            _plane doMove _despawnPos;
            [{
                params ["_plane", "_despawnPos"];

                _plane distance2D _despawnPos <= 500
            }, {
                deleteVehicleCrew (_this # 0);
                deleteVehicle (_this # 0);
                KPLIB_enemy_jetInAir deleteAt (KPLIB_enemy_jetInAir find (_this # 0));
            }, [_plane, _despawnPos], 180, {deleteVehicleCrew (_this # 0); deleteVehicle (_this # 0)}] call CBA_fnc_waitUntilAndExecute;
        };
        [_handle] call CBA_fnc_removePerFrameHandler;
    }
}, 30, [_fighter, getPosATL _fighter]] call CBA_fnc_addPerFrameHandler;