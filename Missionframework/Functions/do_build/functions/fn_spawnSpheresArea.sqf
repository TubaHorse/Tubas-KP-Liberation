/*
    File: fn_spawnShepresArea.sqf
    Author: PiG13BR (https://github.com/PiG13BR)
    Date: 28/08/2025
    Last update: 24/07/2026
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Creates spheres around the building area, locally

    Parameter(s)
        _buildPos - build position [POSITION, defaults to [0,0,0]] 
        _range - build range to place the spheres around it. Can be an marker area. [NUMBER or STRING, defaults to KPLIB_range_fob]
        _player - player that is using the build menu [OBJECT, defaults to player]

    Returns:
        -
*/
params[["_buildPos", [0,0,0], [[]]], ["_range", KPLIB_range_fob, [0, ""]], ["_player", player, [ObjNull]]];

if (_buildPos isEqualTo [0,0,0]) exitWith {["Position is [0,0,0]"] call BIS_fnc_error};

private _build_spheres = [];

if (_range isEqualType "") then {
    // Airport build area
    private _airportArea = _range;
    (getMarkerSize _airportArea) params ["_areaX"];
    private _angle = (markerDir _airportArea);

    private _isRectangle = (markerShape _airportArea) == "RECTANGLE";

    // Check shape
    if !(_isRectangle) then {
        // Circle
        for "_i" from 1 to 36 do {
            _build_spheres pushBack ("Sign_Sphere100cm_F" createVehicleLocal [0, 0, 0]);
        };
        {
            _x setObjectTexture [0, "#(rgb,8,8,3)color(0.9,0.6,0,1)"]; 
            _x setPosATL ((markerPos _airportArea) getPos [_areaX, 10 * _forEachIndex]);
        } foreach _build_spheres;
    } else {
        // Rectangle
        private _airportCenter = (markerPos _airportArea);

        private _directions = [_angle, _angle + 90, _angle + 180, _angle + 270]; 

        {
            private _sphere = "Sign_Sphere100cm_F" createVehicleLocal _airportCenter;

            _sphere setPos (_sphere getPos [_areaX, _x]);
            _sphere setDir (getDir _sphere + (_sphere getRelDir (_airportCenter)));

            _build_spheres pushBack _sphere;

            for "_i" from 1 to 10 do {
                private _add = (_i*0.1);
                private _cornerPosRight = _sphere getPos [_areaX*_add, (getDir _sphere) + 90];
                private _sphereRight = createVehicleLocal ["Sign_Sphere100cm_F", _cornerPosRight, [], 0, "CAN_COLLIDE"]; 
                private _cornerPosLeft = _sphere getPos [_areaX*_add, (getDir _sphere) - 90];
                private _sphereLeft = createVehicleLocal ["Sign_Sphere100cm_F", _cornerPosLeft, [], 0, "CAN_COLLIDE"];
                _build_spheres pushBack _sphereRight;
                _build_spheres pushBack _sphereLeft;
            };
        }forEach _directions;
    };
} else {
    // Fob/outpost build area
    for "_i" from 1 to 36 do {
        _build_spheres pushBack ("Sign_Sphere100cm_F" createVehicleLocal [0, 0, 0]);
    };

    {
        _x setObjectTexture [0, "#(rgb,8,8,3)color(0.9,0.6,0,1)"]; 
        _x setPosATL (_buildPos getPos [_range, 10 * _forEachIndex]);
    } foreach _build_spheres;
};

localNamespace setVariable ["KPLIB_BUILD_areaSpheres", _build_spheres];