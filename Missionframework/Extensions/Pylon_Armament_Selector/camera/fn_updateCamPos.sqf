/*
    File: fn_updateCamPos.sqf
    Author: Karel Moricky, modified by Alganthe.
    Adaptation made by PiG13BR for Air Spawner Menu
    Date: 14/10/2025
    Update Date: 14/10/2025
    
    Description:
        Updates the camera pos each frame (called from a draw3D MEH)
        Draw a pylon icon to show to the player what pylon is selected

    Parameter(s):
        -
    
    Returns:
        -
*/

params["_display"];

PIG_PAS_cameraPos params ["_distance", "_dirH", "_dirV"];

[PIG_PAS_cameraHelper, [_dirH + 180, - _dirV, 0]] call BIS_fnc_setObjectRotation;
PIG_PAS_cameraHelper attachTo [PIG_PAS_center, PIG_PAS_cameraPos select 3, ""]; // Reattach for smooth movement

PIG_PAS_camera setPos (PIG_PAS_cameraHelper modelToWorld [0, -_distance, 0]);
PIG_PAS_camera setVectorDirAndUp [vectorDir PIG_PAS_cameraHelper, vectorUp PIG_PAS_cameraHelper];

private _aircraft = localNamespace getVariable ["PIG_PAS_aircraft", objNull];

if (isNull _aircraft) exitWith {};

// Pylon draw3d
if (!(_aircraft isKindOf "Air") || {(localNameSpace getVariable ["PIG_PAS_pylonName", ""]) isEqualTo ""}) exitWith {};

// Get pylon relative pos
private _selectedPylon = localNameSpace getVariable ["PIG_PAS_pylonName", ""];
private _pylonRelPos = PIG_PAS_pylonsPosHash get _selectedPylon;
if (isNil "_pylonRelPos") exitWith {}; // Avoid error on changing aircraft

drawIcon3D
[
    "a3\ui_f\data\igui\rsccustominfo\sensors\targets\markedtarget_ca.paa",
    [1,1,1,1],
    _aircraft modelToWorld _pylonRelPos,
    1.5,
    1.5,
    0,
    _selectedPylon,
    0,
    0.04,
    "RobotoCondensed",
    "right",
    true,
    0,
    -0.045
];