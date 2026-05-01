#include "..\defines.hpp"
/*
    File: fn_droneJamEffects.sqf
    Author: Benchmark, PiG13BR - https://github.com/PiG13BR
    Date: 25/04/2026
    Last update: 01/05/2026

    Description:
        Apply UAV jam effects in UAV optics. Called on client.

    Parameter(s):
        -
    
    Returns:
        -
*/
params["_uav", "_handle"];

private _player = missionNamespace getVariable ["bis_fnc_moduleRemoteControl_unit", player];

// Update nearest tower
private _tower = [getPosASL _uav, KPLIB_side_enemy, JAMMER_RADIUS] call KPLIB_fnc_getNearestTower;

private _time = CBA_missionTime;

// Set effects
private _grain = ppEffectCreate ["FilmGrain", 2000];
private _chrom = ppEffectCreate ["ChromAberration", 2001];
private _color = ppEffectCreate ["ColorCorrections", 1500];
private _dynblur = ppEffectCreate ["DynamicBlur", 500];
{ _x ppEffectEnable true; } forEach [_grain, _chrom, _color];

// Exit conditions
if (!(alive _uav) || (cameraOn != _uav) || (isNil "_tower")) exitWith {
    // Call PFH off
    _uav setVariable ["KPLIB_droneGettingJammed", false, true];
    [_handle] call CBA_fnc_removePerFrameHandler;

    // Remove effects
    _grain ppEffectEnable false;
    _chrom ppEffectEnable false;
    _color ppEffectEnable false;
    _dynblur ppEffectEnable false;

    // Remove layer
    private _layer = localNamespace getVariable ["KPLIB_losingSignal_Layer", -1];
    _layer cutRsc ["RemoveRsc", "PLAIN"];
    localNamespace setVariable ["KPLIB_losingSignal_layerTime", -1]
};

// Get jammer position
private _jammerPos = markerPos _tower;
private _dist = _uav distance _jammerPos;

// Jammer effects modifications
if (_dist < JAMMER_RADIUS) then {
    private _rawIntensity = 1 - (_dist / JAMMER_RADIUS);
    if (_dist < CRITICAL_DIST) then {
        _rawIntensity = 1.1 - (_dist / JAMMER_RADIUS);
    };
    private _intensity = _rawIntensity ^ 2;
    private _flicker = 0.8 + (random 0.4);
    private _finalEffect = (_intensity * _flicker) min 1;

    // Visual Noise
    _grain ppEffectAdjust [_finalEffect * 5, 2, 3, 0.5, 0.5, true];
    _grain ppEffectEnable true;
    _grain ppEffectCommit 0.05;

    // Color Splitting
    _chrom ppEffectAdjust [_finalEffect * 0.15, _finalEffect * 0.15, true];
    _chrom ppEffectEnable true;
    _chrom ppEffectCommit 0.05;

    // Desaturation
    _color ppEffectAdjust [1, 1 + (_finalEffect * 0.7), 0, [0, 0, 0, 0], [1, 1, 1, 1 - _finalEffect], [0.299, 0.587, 0.114, 0]];
    _color ppEffectEnable true;
    _color ppEffectCommit 0.05;

    // Blur
    _dynblur ppEffectAdjust [_finalEffect * 8];
    _dynblur ppEffectEnable true;
    _dynblur ppEffectCommit 0.05;

    // Disable TI equipament
    _uav disableTIEquipment true;
    _uav disableNVGEquipment true;

    if (_dist < CRITICAL_DIST) then {

        // Display/remove losing connection rsc layer
        private _lastTime = localNamespace getVariable ["KPLIB_losingSignal_layerTime", -1];
        if (_lastTime + 1 < _time && (cameraOn == _uav) and (cameraView == "GUNNER")) then {
            private _layer = ("KPLIB_rsc_losingSignal" call BIS_fnc_rscLayer);
            _layer cutRsc ["DroneLosingSignal", "PLAIN"];
            localNamespace setVariable ["KPLIB_losingSignal_Layer", _layer];
            localNamespace setVariable ["KPLIB_losingSignal_layerTime", _time];
        };
    } else {
        private _layer = missionNamespace getVariable ["KPLIB_losingSignal_Layer", -1];
        _layer cutRsc ["RemoveRsc", "PLAIN"];
    };

    // Control Jitter (Physically shakes the drone)
    private _jitterPower = (CRITICAL_DIST - _dist) / CRITICAL_DIST;
    private _vel = velocity _uav;
    _uav setVelocity [
        (_vel select 0) + (random _jitterPower - (_jitterPower/2)),
        (_vel select 1) + (random _jitterPower - (_jitterPower/2)),
        (_vel select 2) + (random _jitterPower - (_jitterPower/2))
    ];

    // Disable distance
    if (_dist < DISABLE_DIST) then {
        //_player disableUAVConnectability [_uav, true]; // Is this command working?
        //_uav engineOn false; // Engine off (cool, but not the idea)
        deleteVehicleCrew _uav; // Remove AI crew (more dramatic, makes the drone fall from the sky)
        //_uav disableAI "MOVE";
    } else {
        //_uav enableAI "MOVE";
    };
} else {
    // Range reset
    _grain ppEffectAdjust [0, 0, 0, 0, 0, true];
    _chrom ppEffectAdjust [0, 0, true];
    _color ppEffectAdjust [1, 1, 0, [0,0,0,0], [1,1,1,1], [0,0,0,0]];
    _dynblur ppEffectAdjust [0.00];
    { _x ppEffectCommit 0.5; } forEach [_grain, _chrom, _color, _dynblur];

    // Enable TI equipament
    _uav disableTIEquipment false;
    _uav disableNVGEquipment false;
};