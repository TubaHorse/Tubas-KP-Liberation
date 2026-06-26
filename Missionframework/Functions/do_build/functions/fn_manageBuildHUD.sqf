#include "..\defines.hpp"
#include "\a3\ui_f\hpp\definedikcodes.inc"

/*
    File: fn_manageBuildHUD.sqf
    Author: PiG13BR (https://github.com/PiG13BR)
    Date: 21/02/2026
    Last update: 26/06/2026
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Manages build HUD

    Parameter(s)
        _player - player that is building [OBJECT, defaults to player] 

    Returns:
        -
*/
params[["_player", player, [objNull]]];

if (isNull _player) exitWith {false};

localNamespace setVariable ["KPLIB_BUILD_player", _player];

// Create build hud
"KPLIB_BUILD_hudLayer" cutRsc ["KPLIB_BUILD_RscBuildControls", "PLAIN", -1, false];

// Disable action menu
inGameUISetEventHandler ["PrevAction", "true"];
inGameUISetEventHandler ["NextAction", "true"];
inGameUISetEventHandler ["Action", "true"];

// Controls
private _hudDisplay = localNameSpace getVariable ['KPLIB_BUILD_hudDisplay', displayNull];

private _buildTextCtrl = _hudDisplay displayCtrl BUILD_TEXT;
private _repeatTextCtrl = _hudDisplay displayCtrl REPEAT_BUILD_TEXT;
private _cancelTextCtrl = _hudDisplay displayCtrl CANCEL_BUILD_TEXT;
private _scrollTextCtrl = _hudDisplay displayCtrl MODE_ACTIONS_TEXT;

_scrollTextCtrl ctrlSetStructuredText (parseText format["<img size='1.5' image='Functions\do_build\icons\mmb.paa'/> %1", localize "STR_BUILD_MODE_ACTIONS"]);
_buildTextCtrl ctrlSetStructuredText (parseText format["<img size='1.5' image='Functions\do_build\icons\lmb.paa'/> - %1", localize "STR_BUILD_ACTION_BUILD"]);
_repeatTextCtrl ctrlSetStructuredText (parseText format["<img size='1.5' image='Functions\do_build\icons\lmb.paa'/> + CTRL - %1", localize "STR_BUILD_ACTION_BUILDREPEAT"]);
_cancelTextCtrl ctrlSetStructuredText (parseText format["<img size='1.5' image='Functions\do_build\icons\rmb.paa'/> - %1", localize "STR_BUILD_ACTION_CANCEL"]);

private _rotationTextCtrl = _hudDisplay displayCtrl ROTATE_MODE_TEXT;
private _heightTextCtrl = _hudDisplay displayCtrl HEIGHT_MODE_TEXT;
private _yTextCtrl = _hudDisplay displayCtrl MODEY_MODE_TEXT;
private _snapTextCtrl = _hudDisplay displayCtrl SNAP_MODE_TEXT;
private _vectorTextCtrl = _hudDisplay displayCtrl VERTICAL_MODE_TEXT;
private _boostTextCtrl = _hudDisplay displayCtrl BOOST_MODE_TEXT;
private _cameraTextCtrl = _hudDisplay displayCtrl CAMERA_MODE_TEXT;

// Set init text and color
_rotationTextCtrl ctrlSetStructuredText (parseText format["%1 <img image='a3\3den\data\cfgwrapperui\cursors\3denrotate_ca.paa'/>", localize "STR_BUILD_ACTION_ROTATE"]);
_rotationTextCtrl ctrlSetTextColor [0,1,0,1]; // Init green

_heightTextCtrl ctrlSetStructuredText (parseText format["%1 <img image='a3\3den\data\cfgwrapperui\cursors\3dentransformscale0_ca.paa'/>", localize "STR_BUILD_ACTION_HEIGHT"]);
_heightTextCtrl ctrlSetTextColor [1,0,0,1];

_yTextCtrl ctrlSetStructuredText (parseText format["%1 <img image='a3\3den\data\displays\display3den\statusbar\y_ca.paa'/>", localize "STR_BUILD_ACTION_YMODE"]);
_yTextCtrl ctrlSetTextColor [1,0,0,1];

_vectorTextCtrl ctrlSetStructuredText (parseText format["%1 <img image='a3\3den\data\displays\display3den\toolbar\vert_atl_ca.paa'/>", localize "STR_BUILD_ACTION_ALIGNMENT"]);
_vectorTextCtrl ctrlSetTextColor [1,0,0,1];

_snapTextCtrl ctrlSetStructuredText (parseText format["%1 <img image='a3\3den\data\displays\display3den\toolbar\snap_on_ca.paa'/>", localize "STR_BUILD_ACTION_SNAP"]);
_snapTextCtrl ctrlSetTextColor [0,1,0,1]; // Init green

_boostTextCtrl ctrlSetStructuredText (parseText format["%1 <img image='Functions\do_build\icons\chevron-double-up.paa'/>", localize "STR_BUILD_ACTION_BOOST"]);
_boostTextCtrl ctrlSetTextColor [1,0,0,1];

_cameraTextCtrl ctrlSetStructuredText (parseText localize "STR_BUILD_ACTION_CAMERA_ASSIST");
_cameraTextCtrl ctrlSetTextColor [0,1,0,1];

// Camera on (default)
[_player] call KPLIB_fnc_buildCameraAssist;

// Unshow cancel control if it's a FOB or Outpost
private _buildType = localNamespace getVariable ["KPLIB_BUILD_buildType", 1];
if (_buildType == BUILDTYPE_FOB || _buildType == BUILDTYPE_OUTPOST) then {
    //_cancelTextCtrl ctrlshow false;
    _cancelTextCtrl ctrlSetTextColor [0.4,0.4,0.4,1];
    _repeatTextCtrl ctrlSetTextColor [0.4,0.4,0.4,1];
};

// Update scroll information
private _mouseZchanged = (findDisplay MISSION_IDD) displayAddEventHandler ["MouseZChanged", {
    params ["_displayOrControl", "_scroll"];

    private _boost = if (localNamespace getVariable ["KPLIB_BUILD_boost", false]) then {5} else {0};

    // Get variables
    private _obj = localNamespace getVariable ["KPLIB_BUILD_preplacedObject", objNull];
    private _height = localNamespace getVariable ["KPLIB_BUILD_objectElevation", 0];
    private _yCoord = localNamespace getVariable ["KPLIB_BUILD_objectYCoord", 0];
    private _rotation = localNamespace getVariable ["KPLIB_BUILD_objectRotation", 0];

    switch (true) do {
        case (localNamespace getVariable ["KPLIB_BUILD_heightMode", false]) : {
            // Height
            // Only if snap is off
            if !(localNamespace getVariable ["KPLIB_BUILD_snapToGround", false]) then {
                if (_scroll > 0) then {
                    _height = (_height + 0.1) + (_boost * 0.2);
                } else {
                    _height = (_height - 0.1) - (_boost * 0.2);
                };
            }
        };
        case (localNamespace getVariable ["KPLIB_BUILD_yMode", false]) : {
            if (_scroll > 0) then {
                _yCoord = ((_yCoord + 0.2) + (_boost * 0.5)) min 10;
            } else {
                private _maxY = if (_obj isKindOf "StaticWeapon") then {
                    ceil(boundingBoxReal _obj # 2) * 0.8; // Draw static weapons closer
                } else {
                    ceil(boundingBoxReal _obj # 2) * 1.3;
                };
                _yCoord = ((_yCoord - 0.2) - (_boost * 0.5)) max (_maxY);
            };
        };
        default {
            // Rotation
            if (_scroll > 0) then {
                _rotation = ((_rotation + 5) + _boost) % 360;
            } else {
                _rotation = ((_rotation - 5) - _boost) % 360;
            };
        }
    };

    // Update variables
    localNamespace setVariable ["KPLIB_BUILD_objectElevation", _height];
    localNamespace setVariable ["KPLIB_BUILD_objectYCoord", _yCoord];
    localNamespace setVariable ["KPLIB_BUILD_objectRotation", _rotation]
}];

// Key down detection to change between height/rotation modes
private _keyDownEH = (findDisplay MISSION_IDD) displayAddEventHandler ["KeyDown", {
    params ["_displayOrControl", "_key", "_shift", "_ctrl", "_alt"];

    private _player = localNamespace getVariable ["KPLIB_BUILD_player", objNull];

    private _hudDisplay = localNameSpace getVariable ['KPLIB_BUILD_hudDisplay', displayNull];

    private _rotationTextCtrl = _hudDisplay displayCtrl ROTATE_MODE_TEXT;
    private _heightTextCtrl = _hudDisplay displayCtrl HEIGHT_MODE_TEXT;
    private _yTextCtrl = _hudDisplay displayCtrl MODEY_MODE_TEXT;
    private _snapTextCtrl = _hudDisplay displayCtrl SNAP_MODE_TEXT;
    private _vectorTextCtrl = _hudDisplay displayCtrl VERTICAL_MODE_TEXT;
    private _boostTextCtrl = _hudDisplay displayCtrl BOOST_MODE_TEXT;
    private _cameraTextCtrl = _hudDisplay displayCtrl CAMERA_MODE_TEXT;
    
    switch _key do {
        // Active/deactive height mode
        case DIK_LMENU : {
            private _heightMode = !(localNamespace getVariable ["KPLIB_BUILD_heightMode", false]);
            localNamespace setVariable ["KPLIB_BUILD_heightMode", _heightMode];
            localNamespace setVariable ["KPLIB_BUILD_yMode", false]; // Turn off Ymode

            if (_heightMode) then {
                _heightTextCtrl ctrlSetTextColor [0,1,0,1]; // Green
                _rotationTextCtrl ctrlSetTextColor [1,0,0,1];
                _yTextCtrl ctrlSetTextColor [1,0,0,1];
            } else {
                _heightTextCtrl ctrlSetTextColor [1,0,0,1]; // Red
                _rotationTextCtrl ctrlSetTextColor [0,1,0,1]; // Green
                _yTextCtrl ctrlSetTextColor [1,0,0,1];
            };
        };
        // Active/deactive yMode
        case DIK_LCONTROL : {
            private _yMode = !(localNamespace getVariable ["KPLIB_BUILD_yMode", false]);
            localNamespace setVariable ["KPLIB_BUILD_yMode", _yMode];
            localNamespace setVariable ["KPLIB_BUILD_heightMode", false]; // Turn off height

            if (_yMode) then {
                _yTextCtrl ctrlSetTextColor [0,1,0,1];  // Green
                _rotationTextCtrl ctrlSetTextColor [1,0,0,1];
                _heightTextCtrl ctrlSetTextColor [1,0,0,1];
            } else {
                _yTextCtrl ctrlSetTextColor [1,0,0,1]; // Red
                _rotationTextCtrl ctrlSetTextColor [0,1,0,1]; // Green
                _heightTextCtrl ctrlSetTextColor [1,0,0,1];
            };
        };
        // TAB for camera assist mode
        case DIK_TAB : {
            if (isNull (_player getVariable ["KPLIB_BUILD_camera", objNull])) then {
                [_player] call KPLIB_fnc_buildCameraAssist;
                _cameraTextCtrl ctrlSetTextColor [0,1,0,1];
            } else {
                [_player, false] call KPLIB_fnc_buildCameraAssist;
                _cameraTextCtrl ctrlSetTextColor [1,0,0,1];
            };
        };
        // CAPS-LOCK for snap to the ground
        case DIK_CAPITAL : {
            private _snap = !(localNamespace getVariable ["KPLIB_BUILD_snapToGround", false]);
            localNamespace setVariable ["KPLIB_BUILD_snapToGround", _snap];

            if (_snap) then {
                _snapTextCtrl ctrlSetTextColor [0,1,0,1];
                _snapTextCtrl ctrlSetStructuredText (parseText format["%1 <img image='a3\3den\data\displays\display3den\toolbar\snap_on_ca.paa'/>", localize "STR_BUILD_ACTION_SNAP"]);
                
            } else {
                _snapTextCtrl ctrlSetTextColor [1,0,0,1];
                _snapTextCtrl ctrlSetStructuredText (parseText format["%1 <img image='a3\3den\data\displays\display3den\toolbar\snap_off_ca.paa'/>", localize "STR_BUILD_ACTION_SNAP"]);
            }
        };
        // SPACE: Vector
        case DIK_SPACE : {
            private _vector = !(localNamespace getVariable ["KPLIB_BUILD_vectorSurface", false]);
            localNamespace setVariable ["KPLIB_BUILD_vectorSurface", _vector];

            if (_vector) then {
                _vectorTextCtrl ctrlSetStructuredText (parseText format["%1 <img image='a3\3den\data\displays\display3den\toolbar\vert_asl_ca.paa'/>", localize "STR_BUILD_ACTION_ALIGNMENT"]);
                _vectorTextCtrl ctrlSetTextColor [0,1,0,1];
            } else {
                _vectorTextCtrl ctrlSetStructuredText (parseText format["%1 <img image='a3\3den\data\displays\display3den\toolbar\vert_atl_ca.paa'/>", localize "STR_BUILD_ACTION_ALIGNMENT"]);
                _vectorTextCtrl ctrlSetTextColor [1,0,0,1]; 
            }
        };
        default {};
    };
    
    // Boost
    if (_key ==	DIK_LSHIFT) then {
        localNamespace setVariable ["KPLIB_BUILD_boost", true];
        _boostTextCtrl ctrlSetTextColor [0,1,0,1];
    };
}];

private _keyUpEH = (findDisplay MISSION_IDD) displayAddEventHandler ["KeyUp", {
    params ["_displayOrControl", "_key", "_shift", "_ctrl", "_alt"];

    private _hudDisplay = localNameSpace getVariable ['KPLIB_BUILD_hudDisplay', displayNull];

    private _boostTextCtrl = _hudDisplay displayCtrl BOOST_MODE_TEXT;
    
    // Deactive boost
    if (_key ==	DIK_LSHIFT) then {
        localNamespace setVariable ["KPLIB_BUILD_boost", false];
        _boostTextCtrl ctrlSetTextColor [1,0,0,1];
    };
}];

// Build-Repeat
private _mouseButtonDownEH = (findDisplay MISSION_IDD) displayAddEventHandler ["MouseButtonDown", {
    params ["_displayOrControl", "_button", "_xPos", "_yPos", "_shift", "_ctrl", "_alt"];

    private _object = localNamespace getVariable ["KPLIB_BUILD_preplacedObject", objNull];
    private _player = localNamespace getVariable ["KPLIB_BUILD_player", objNull];
    private _buildType = localNamespace getVariable ["KPLIB_BUILD_buildType", 1];

    if (_button > 0) then {
        // Cancel
        if (_buildType != BUILDTYPE_FOB && _buildType != BUILDTYPE_OUTPOST) then {
            [_object] call KPLIB_fnc_cancelBuilding;
            "KPLIB_BUILD_hudLayer" cutRsc ["RemoveRsc","PLAIN",5, false];
        };
    } else {
        private _canBuild = _object getVariable ["KPLIB_BUILD_canBuild", true]; // Change value
        private _objectInArea = _object getVariable ["KPLIB_BUILD_isObjectInArea", true]; // Change value

        if (!_canBuild || !_objectInArea) exitWith {
            if !((typeOf _object) in KPLIB_collisionIgnoreObjects) then {
                if (_object getVariable ["KPLIB_BUILD_isObjectInArea", false]) then {
                    //private _spheres = (_object getVariable ["KPLIB_BUILD_objectSpheres", []]);
                    private _areaSpheres = localNamespace getVariable ["KPLIB_BUILD_areaSpheres", []];
                    private _nearestObjects = (nearestObjects [_object, ["AllVehicles", "Things", "ThingX", "Building", "Ruins"], (boundingBoxReal _object # 2) * 1.05, false] - ([_object, _player] - _areaSpheres));
                    if (_nearestObjects isNotEqualTo []) then {
                        [format [localize "STR_PLACEMENT_IMPOSSIBLE", count _nearestObjects, ((boundingBoxReal _object # 2) * 1.05) toFixed 0], true, 3] call KPLIB_fnc_hint;
                    };
                }
            };
            if !(_object getVariable ["KPLIB_BUILD_isObjectInArea", false]) then {
                [format [localize "STR_BUILD_ERROR_DISTANCE", KPLIB_range_fob], true, 3] call KPLIB_fnc_hint;
            };
        };

        // Build
        if (_ctrl && ((_buildType != BUILDTYPE_FOB) && (_buildType != BUILDTYPE_OUTPOST))) then {
            private _repeat = true;

            // Remove spheres
            private _spheres =  (localNamespace getVariable ["KPLIB_BUILD_areaSpheres", []]);
            {deleteVehicle _x}forEach _spheres;

            // Reset variables
            localNamespace setVariable ["KPLIB_BUILD_preplacedObject", nil];

            // Spawn builded object

            // Get local object attributes
            private _objectClass = (typeOf _object);
            private _objPos = getPosATL _object;
            private _objDir = getDir _object;
            private _vector = localNamespace getVariable ["KPLIB_BUILD_vectorSurface", false];
            private _buildType = localNamespace getVariable ["KPLIB_BUILD_buildType", 1];
            private _withCrew = localNamespace getVariable ["KPLIB_BUILD_requireCrew", false];

            deleteVehicle _object;

            "KPLIB_BUILD_hudLayer" cutRsc ["RemoveRsc","PLAIN",5, false];
            _player removeAction (localNamespace getVariable ["KPLIB_BUILD_blockFire", -1]);

            // Build and repeat
            ["KPLIB_buildObject", [_objectClass, _objPos, _objDir, _vector, _buildType, _withCrew, _player, _repeat]] call CBA_fnc_serverEvent;

        } else {
            // Remove spheres
            private _spheres = (localNamespace getVariable ["KPLIB_BUILD_areaSpheres", []]);
            {deleteVehicle _x}forEach _spheres;

            // Get local object attributes
            private _objectClass = (typeOf _object);
            private _objPos = getPosATL _object;
            private _objDir = getDir _object;
            private _vector = localNamespace getVariable ["KPLIB_BUILD_vectorSurface", false];
            private _buildType = localNamespace getVariable ["KPLIB_BUILD_buildType", 1];
            private _withCrew = localNamespace getVariable ["KPLIB_BUILD_requireCrew", false];

            deleteVehicle _object;

            // Build object (server sided)
		    ["KPLIB_buildObject", [_objectClass, _objPos, _objDir, _vector, _buildType, _withCrew, _player]] call CBA_fnc_serverEvent;

            [_player, false] call KPLIB_fnc_buildCameraAssist;
            [_player] call KPLIB_fnc_deleteBuildVariables;

            if !(isNil "KPLIB_doBuild_eachFrame") then {
                removeMissionEventHandler ["EachFrame", KPLIB_doBuild_eachFrame]
            };

            _player setVariable ["KPLIB_BUILD_isBuilding", false];

            // Select previous weapon
            private _previousWeapon = _player getVariable "KPLIB_BUILD_previousWeapon";

            if (!isNil "_previousWeapon") then {
                _player selectWeapon _previousWeapon;
                _player setVariable ["KPLIB_BUILD_previousWeapon", nil, true];
            };
        };

        "KPLIB_BUILD_hudLayer" cutRsc ["RemoveRsc","PLAIN",5, false];
    };
}];

localNamespace setVariable ["KPLIB_BUILD_hudEH", [["MouseZChanged", _mouseZchanged],  ["KeyDown", _keyDownEH], ["KeyUp", _keyUpEH], ["MouseButtonDown", _mouseButtonDownEH]]];

_hudDisplay displayAddEventHandler ["Unload", {
    {(findDisplay MISSION_IDD) displayRemoveEventHandler _x}forEach (localNamespace getVariable ["KPLIB_BUILD_hudEH", []]);
    inGameUISetEventHandler ["PrevAction", "false"];
    inGameUISetEventHandler ["NextAction", "false"];
    inGameUISetEventHandler ["Action", "false"];
}];

true