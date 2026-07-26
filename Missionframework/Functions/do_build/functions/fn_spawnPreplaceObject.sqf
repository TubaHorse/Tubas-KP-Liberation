#include "..\defines.hpp"
/*
    File: fn_spawnPreplaceObject.sqf
    Author: PiG13BR (https://github.com/PiG13BR)
    Date: 28/08/2025
    Last update: 11/04/2026
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Spawn a local object to be used as a placeholder

    Parameter(s)
        _objectClass - object classname [STRING, defaults to ""]
        _player - player that the object is going to attach to [OBJECT, defaults to player] 

    Returns:
        -
*/

params[["_objectClass", "", [""]], ["_player", player, [objNull]]];

if (_objectClass isEqualTo "") exitWith {["No classname provided"] call BIS_fnc_error};

// Create preplaced object (locally)
private _object = createVehicleLocal [_objectClass, markerPos "ghost_spot"]; // Placeholder object and in a placeholder spawn pos
_object allowdamage false;
_object setVehicleLock "LOCKED";

// Crate simple object of it
private _simpleObject = [
    _objectClass, 
    (getPosWorld _object), 
    (getDir _object), 
    false, 
    false, 
    true // LOCAL!
] call BIS_fnc_createSimpleObject;
if (!isNull _simpleObject) then {deleteVehicle _object; _object = _simpleObject;}; // If creation not fails, delete the preplaced object and replace _object variable 

private _pos = getPosATL _object;
_pos set [2,0];
_object setPosATL _pos;

// Clear cargo
[_object] call KPLIB_fnc_clearCargo;

// Set up variables
private _rotation = 0;
private _yCoord = if (_object isKindOf "StaticWeapon") then {
    ceil(boundingBoxReal _object # 2) * 0.8; // Draw static weapons closer
} else {
    if (_object distance2D _player > 10) then {
        ceil(boundingBoxReal _object # 2);
    } else {
        ceil(boundingBoxReal _object # 2) * 1.3;
    }
};
private _height = ((getPosATL _object) # 2);

localNamespace setVariable ["KPLIB_BUILD_preplacedObject", _object];
localNamespace setVariable ["KPLIB_BUILD_objectRotation", _rotation];
localNamespace setVariable ["KPLIB_BUILD_objectElevation", _height];
localNamespace setVariable ["KPLIB_BUILD_objectYCoord", _yCoord];
localNamespace setVariable ["KPLIB_BUILD_snapToGround", true]; // Snap true (default)

// Simulation and collision flag
_object enableSimulationGlobal false;
_object setPhysicsCollisionFlag false;

private _startPos = positionCameraToWorld [0, 0, _yCoord];
_object setVectorUp (surfaceNormal _startPos);

// Create spheres
private _buildType = localNamespace getVariable ["KPLIB_BUILD_buildType", 1];
//private _buildCenterPos = [getPosATL _player] call KPLIB_fnc_getNearestFob; // Get FOB Pos
private _nearestBuildPos = [getPosATL _player] call KPLIB_fnc_getNearestBuildPos;

_nearestBuildPos params ["_buildCenterPos", "_buildRange"];

if (_buildType == BUILDTYPE_FACTORY_STORAGE) then {
    // For storage building, get the nearest sector
    _buildCenterPos = markerPos ([100] call KPLIB_fnc_getNearestSector);
};

if ((_buildType != BUILDTYPE_FOB) && (_buildType != BUILDTYPE_OUTPOST)) then {
    // If it's an airport area, replace the build range for the airport marker
    private _inAirport = KPLIB_sectors_airport findIf {_buildCenterPos inArea _x};
    _buildRange = if ((_inAirport >= 0) && ((_buildCenterPos distance2D _player) > _buildRange)) then {
        KPLIB_sectors_airport # _inAirport;
    };

    // Buildings
    [_buildCenterPos, _buildRange, _player] call KPLIB_fnc_spawnSpheresArea;

} else {
    // Fob or outpost
    _buildCenterPos = getPosATL _player;
};

// Commit
[_object, _player, _buildCenterPos, _buildRange] call KPLIB_fnc_buildEachFrame;

private _hiddenSelection = getArray(configFile >> "CfgVehicles" >> _objectClass >> "hiddenSelections");
{
    _object setObjectMaterial [_x, "\a3\data_f\default.rvmat"];
    _object setObjectTexture [_x, "#(rgb,8,8,3)color(0,1,0,1)"];
}forEach _hiddenSelection;