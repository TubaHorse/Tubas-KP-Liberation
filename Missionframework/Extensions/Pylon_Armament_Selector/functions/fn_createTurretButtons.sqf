
#include "..\defines.hpp"
/*
    File: fn_createTurretButtons.sqf
    Author: PiG13BR - https://github.com/PiG13BR
    Date: 13/06/2026
    Update Date: 22/06/2026
    
    Description:
        Create the turret button

    Parameter(s):
        _display - pylon manager display [DISPLAY]
        _aircraft - aircraft to display the turret button [OBJECT, defaults to objNull]
    
    Returns:
        -
*/
params["_display", "_aircraft"];

if (isNull _aircraft) exitWith {};

// Get pylon relative pos
private _selectedPylon = localNameSpace getVariable ["PIG_PAS_pylonName", ""];
private _pylonRelPos = PIG_PAS_pylonsPosHash get _selectedPylon;
if (isNil "_pylonRelPos") exitWith {}; // Avoid error on changing aircraft

if ((allTurrets [_aircraft, false]) isNotEqualTo []) then {
    disableSerialization;
    private _pylonRelPos = PIG_PAS_pylonsPosHash get _selectedPylon;
    private _center = PIG_PAS_cameraHelper;
    private _mouseAreaCtrl = _display displayCtrl IDC_MOUSEAREA;
    private _ctrl = _display displayCtrl IDC_TURRET_BUTTON;

    // Create control for the first time
    if (isNull _ctrl) then {
        _ctrl = _display ctrlCreate ["ctrlButtonPictureKeepAspect", IDC_TURRET_BUTTON];
        _ctrl ctrlSetBackgroundColor [0, 0, 0, 0.5];
        _ctrl ctrlSetActiveColor [0.23,0.34,0.82,0.6];

        if (isNil "PIG_PAS_pylonsTurret") then {
            PIG_PAS_pylonsTurret = createHashMap;
        };

        _ctrl ctrlAddEventHandler ["ButtonClick", {
            private _pylon = localNameSpace getVariable ["PIG_PAS_pylonIndex", -1];
            [_this # 0, true, _pylon, []] call KPLIB_fnc_handleTurretButton;
        }];

        PIG_PAS_turretUpdateHandle = addMissionEventHandler ["Draw3D", {
            private _pylon = localNameSpace getVariable ["PIG_PAS_pylonName", ""];
            [_thisArgs, _pylon] call KPLIB_fnc_updateTurretButton
        }, [_ctrl, _aircraft]
        ];
    };
    private _pylonIndex = localNameSpace getVariable ["PIG_PAS_pylonIndex", -1];
    private _turret = [_aircraft, _pylonIndex] call KPLIB_fnc_getPylonTurret;
    [_ctrl, false, _pylonIndex, _turret] call KPLIB_fnc_handleTurretButton;
};