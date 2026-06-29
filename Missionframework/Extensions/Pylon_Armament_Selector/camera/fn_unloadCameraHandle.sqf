/*
    File: fn_unloadCameraHandle.sqf
    Author: Alganthe
    Adaptation made by PiG13BR for Air Spawner Menu
    Date: 14/10/2025
    Update Date: 14/10/2025
    
    Description:
        Unloads EH and deletes variables from the camera handle

    Parameter(s):
        -
    
    Returns:
        -
*/

removeMissionEventHandler ["Draw3D", PIG_PAS_camPosUpdateHandle];

if (!isNull curatorCamera && {ACE_player == player}) then {
    curatorCamera cameraEffect ["Internal", "BACK"];
} else {
    PIG_PAS_camera cameraEffect ["Terminate", "BACK"];
};

deleteVehicle PIG_PAS_cameraHelper;
camDestroy PIG_PAS_camera;

ACE_player switchCamera PIG_PAS_cameraView;

PIG_PAS_camera = nil;
PIG_PAS_cameraHelper = nil;
PIG_PAS_mouseButtonState = nil;
PIG_PAS_center = nil;
PIG_PAS_cameraPos = nil;

["hideHud", []] call ace_common_fnc_showHud;
