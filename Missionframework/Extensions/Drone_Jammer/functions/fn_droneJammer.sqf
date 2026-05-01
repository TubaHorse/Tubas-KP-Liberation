#include "..\defines.hpp"
/*
    File: fn_droneJammer.sqf
    Author: PiG13BR - https://github.com/PiG13BR
    Date: 25/04/2026
    Last update: 26/04/2026

    Description:
        Check for player's UAV inside an enemy tower's jammer radius

    Parameter(s):
        -
    
    Returns:
        -
*/

if (!isServer) exitWith {};
if (isClass (configFile >> "CfgPatches" >> "DRONE_SIGNALS")) exitWith {["Drone Signal mod found. Disabling KP Liberation Drone Jammer framework.","DRONE JAMMER"] call KPLIB_fnc_log}; // Exit on Drone Signal mod found

// Server
[{
    {
        private _uav = _x;

        // Get player controlling the UAV
        private _player = (UAVControl _uav) # 0;
        if (isNull _player) then {continue}; // Skip

        // Get UAV object
        private _uav = getConnectedUAV _player;
        if (!alive _uav) then {continue}; // Skip

        // Get nearest tower
        private _tower = [getPosASL _uav, KPLIB_side_enemy, JAMMER_RADIUS] call KPLIB_fnc_getNearestTower;
        if (isNil "_tower") then {continue}; // Skip
        if ((KPLIB_sectors_player findIf {_x == _tower}) >= 0) then {continue}; // Skip
        
        // Check if the uav is already beign jammed
        if !(_uav getVariable ["KPLIB_droneGettingJammed", false]) then {
            ["KPLIB_jamDrone", _uav, _player] call CBA_fnc_targetEvent;
        };
    }forEach allUnitsUAV;
}, 1, nil] call CBA_fnc_addPerFrameHandler;