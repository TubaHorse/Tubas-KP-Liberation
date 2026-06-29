#include "..\defines.hpp"
/*
    File: fn_buildEachFrame.sqf
    Author: PiG13BR (https://github.com/PiG13BR)
    Date: 11/11/2025
    Last update: 29/06/2026
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Create EachFrame MEH to check distance/collision for the preplaced object

    Parameter(s)
        _object - preplaced object [OBJECT, defaults to objNull]
        _player - player who object is attached too [OBJECT, defaults to player]
        _centerPos - Center building position [POSITION, defaults to [0,0,0]]

    Returns:
        -
*/

params[["_object", objNull, [objnull]], ["_player", player, [objNull]], ["_centerPos", [0,0,0], []], ["_buildRange", KPLIB_range_fob, [0]]];

if (isNull _object) exitWith {["Object is null"] call BIS_fnc_error};
if (_centerPos isEqualTo [0,0,0]) exitWith {["Center position is [0,0,0]"] call BIS_fnc_error};

if !(isNil "KPLIB_doBuild_eachFrame") then {
    removeMissionEventHandler ["EachFrame", KPLIB_doBuild_eachFrame]
};

// Show and manage Build HUD
[{_this call KPLIB_fnc_manageBuildHUD}, _player] call CBA_fnc_execNextFrame;

private _buildType = localNamespace getVariable ["KPLIB_BUILD_buildType", 1]; // Get build type (look for FOB build type)

// Select no weapon
private _previousWeapon = _player getVariable "KPLIB_BUILD_previousWeapon";

if (isNil "_previousWeapon") then {
    _player setVariable ["KPLIB_BUILD_previousWeapon", (weaponState _player) select [0, 3], true];
    _player action ["SwitchWeapon", _player, _player, 299];
};

KPLIB_doBuild_eachFrame = addMissionEventHandler ["EachFrame", { 
    
    _thisArgs params ["_object", "_player", "_posCenter", "_maxDist", "_typeNumber"];

    // Failsafe
    if (!alive _player || !([_player] call KPLIB_fnc_ace_isAwake)) exitWith {
        [_object] call KPLIB_fnc_cancelBuilding;
    };

    private _areaSpheres = localNamespace getVariable ["KPLIB_BUILD_areaSpheres", []];
    private _objectSize = (boundingBoxReal _object # 2) * 1.05;
    private _nearObjects = nearestObjects [_object, ["AllVehicles", "Things", "ThingX", "Building", "Ruins"], _objectSize, false] - [_object, _player] - _areaSpheres; 
    private _distanceFromFob = _object distance2D _posCenter;

    // Object positioning
    private _basePos = positionCameraToWorld [0, 0, 5];
    //private _x = _basePos # 0;
    //private _y = _basePos # 1;

    private _height = localNamespace getVariable ["KPLIB_BUILD_objectElevation", 0];
    private _yCoord = localNamespace getVariable ["KPLIB_BUILD_objectYCoord", 0];
    private _rotation = localNamespace getVariable ["KPLIB_BUILD_objectRotation", 0];

    private _worldPos = _basePos vectorAdd [0, _yCoord, _height]; // Camera based
    private _snap = (localNamespace getVariable ["KPLIB_BUILD_snapToGround", false]);
    private _zcoord = (_worldPos # 2);
    _worldPos = _player modelToWorld [0, _yCoord, _zcoord]; // Relative pos

    private _camera = _player getVariable ["KPLIB_BUILD_camera", objNull];
    private _cameraHelper = _player getVariable ["KPLIB_BUILD_cameraLogic", objNull]; // ToCheck

    if (_snap) then {
        // Snap into surface
        if (((getPosATL _object) # 2) < 0) then {_height = 0;};

        // Snap position
        private _posATL = _player modelToWorld [0, _yCoord, 0];
        _posATL set [2,0];

        _object setPosATL _posATL;
        private _vector = localNamespace getVariable ["KPLIB_BUILD_vectorSurface", false];
        private _vectorUp = if (_vector) then {[0,0,1]} else {(surfaceNormal _posATL)};
        _object setVectorUp _vectorUp;
    } else {
        _object setPosATL _worldPos;

        private _vector = localNamespace getVariable ["KPLIB_BUILD_vectorSurface", false];
        private _vectorUp = if (_vector) then {[0,0,1]} else {(surfaceNormal _worldPos)};
        _object setVectorUp _vectorUp;
    };

    _object setVectorDir [sin _rotation * cos _zcoord, cos _rotation * cos _zcoord, sin _zcoord];

    // Update camera
    if !(isNull _camera) then {
        //_cameraHelper attachTo [player, player worldToModel (ASLToAGL (getPosWorld _obj))];
        private _bounding = ((boundingBoxReal _object # 2) * 3);
        if ((_bounding > 20) && (_bounding < 40)) then {_bounding = _bounding/2};
        _cameraHelper setPosATL (getPosATL _object);
        _cameraHelper setDir ((getDir _player) - 180); // Relative direction
        _camera attachTo [_cameraHelper, [0, 0.1, _bounding]];
        _camera camPrepareTarget _cameraHelper;
        _camera camSetTarget _cameraHelper;
    };

    // Check if the building can be placed and set a variable to it
    if (((_distanceFromFob > _maxDist) && {_typeNumber != BUILDTYPE_FOB}) || {((surfaceIsWater (getPosASL _object))) && !((typeOf _object) in boats_names)} || {(_nearObjects isNotEqualTo []) && !(toLowerANSI(typeOf _object) in KPLIB_collisionIgnoreObjects)}) then {
        _object setVariable ["KPLIB_BUILD_canBuild", false]; // Change value
        if ((_distanceFromFob > _maxDist) && {_typeNumber != BUILDTYPE_FOB}) then {_object setVariable ["KPLIB_BUILD_isObjectInArea", false]} else {_object setVariable ["KPLIB_BUILD_isObjectInArea", true]}; // Change value

        //_object hideObject true; // Hide object
        drawIcon3D
        [
            "a3\3den\data\displays\display3den\panelright\modemarkers_ca.paa",
            [1, 0, 0, 1], 
            ASLToAGL getPosASLVisual _object, 
            1, 
            1, 
            0, 
            "Cannot Build", 
            1, 
            0.05, 
            "PuristaMedium"
        ];
        private _hiddenSelection = getArray(configOf _object >> "hiddenSelections");
        {
            _object setObjectMaterial [_x, "\a3\data_f\default.rvmat"];
            _object setObjectTexture [_x, "#(rgb,8,8,3)color(1,0,0,1)"];
        }forEach _hiddenSelection;
    } else {
        _object setVariable ["KPLIB_BUILD_canBuild", true]; // Change value
        _object setVariable ["KPLIB_BUILD_isObjectInArea", true]; // Change value
        private _hiddenSelection = getArray(configOf _object >> "hiddenSelections");
        {
            _object setObjectMaterial [_x, "\a3\data_f\default.rvmat"];
            _object setObjectTexture [_x, "#(rgb,8,8,3)color(0,1,0,1)"];
        }forEach _hiddenSelection;
        //if (isObjectHidden _object) then {_object hideObject false}; // Show object
    };
}, [_object, _player, _centerPos, _buildRange, _buildType]];