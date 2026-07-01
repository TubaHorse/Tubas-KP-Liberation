/*
    File: fn_vehicleAttack.sqf
    Author: PiG13BR (https://github.com/PiG13BR)
    Date: 01/07/2026
    Last Update: 01/07/2026
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Handle battlegroup attack movement

    Parameter(s):
        _vehicle - battlegroup vehicle [OBJECT, defaults to objNull]
        _attackPos - attack position [POSITION, defaults to [0,0,0]]

    Returns:
        [BOOL]
*/
params [
    ["_vehicle", objNull, [objNull]],
    ["_attackPos", [0,0,0], [[]], [2,3]]
];

private _vehicleGroup = (group(effectiveCommander _vehicle));
{deleteWaypoint _x}ForEachReversed (waypoints _vehicleGroup);

if (_vehicle isKindOf "LandVehicle") then {
    // Veh
    private _wp1 = _vehicleGroup addWaypoint [_attackPos, 100];
    _wp1 setWaypointType "SAD";
    _wp1 setWaypointBehaviour "SAFE"; // Vehicles in safe mode to follow road. Tracked vehicles tends to go off road.
    private _wp2 = _vehicleGroup addWaypoint [_attackPos, 100];
    _wp2 setWaypointType "CYCLE";
};

if (_vehicle isKindOf "Helicopter") then {
    _vehicleGroup setCombatMode "RED";

    private _wp1 = _vehicleGroup addWaypoint [_targetPos, 25];
    _wp1 setWaypointType "SAD";
    _wp1 setWaypointSpeed "NORMAL";
    _wp1 setWaypointBehaviour "COMBAT";
    _wp1 setWaypointCompletionRadius 100;

    private _pfhID = _vehicle getVariable ["KPLIB_attackHeli_idPFH", -1];
    [_pfhID] call CBA_fnc_removePerFrameHandler;

    private _idPFH = [{
        params["_args", "_handle"];
        _args params ["_targetPos", "_helicopter", "_heliGroup"];

        if (!alive _helicopter || {!alive (driver _helicopter)}) exitWith {[_handle] call CBA_fnc_removePerFrameHandler;};

        {deleteWaypoint _x}ForEachReversed (waypoints _heliGroup);
        private _wp1 = _heliGroup addWaypoint [_targetPos, 25];
        _wp1 setWaypointType "SAD";
        _wp1 setWaypointCompletionRadius 100;
        
        private _bluforEntities = [_targetPos, 250, KPLIB_side_player] call KPLIB_fnc_getNearbyEntities;
        
        {   
            private _lineIntersect = lineintersectsWith [getPosASLVisual _x, getPosASLVisual _helicopter];
            if (_lineIntersect isEqualTo []) then {
                _heliGroup reveal [_x, 4];
            } else {
                _heliGroup forgetTarget _x;
            }
        }forEach _bluforEntities;

    }, 15, [_targetPos, _vehicle, _vehicleGroup]] call CBA_fnc_addPerFrameHandler;

    _vehicle setVariable ["KPLIB_attackHeli_idPFH", _idPFH];
};