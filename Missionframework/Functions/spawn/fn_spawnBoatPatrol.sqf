/*
	File: fn_spawnBoatPatrol.sqf
	Author: PiG13BR (https://github.com/PiG13BR)
	Date: 19/12/2025
	Last update: 08/07/2026
	License: MIT License - http://www.opensource.org/licenses/MIT

	Description:
		Spawns boat patrol on sector near a body of water

	Parameters:
		_sector - sector to spawn boat in water [STRING]

	Return:
		Array containing the boat and its crew
*/

params["_sector"];

private _boatCrewGrp = createGroup KPLIB_side_enemy;
private _sectorPos = markerPos _sector;
private _boatVeh = objNull;

private _waterPos = [[[_sectorPos, KPLIB_range_sectorCapture * 2]], [], {
    (_this isFlatEmpty [-1, -1, -1, -1, 2, false]) isNotEqualTo [] && 
    {(getTerrainHeightASL (AGLToASL (ASLToATL _this))) < -25}}
] call BIS_fnc_randomPos;

if (_waterPos isNotEqualTo [0,0]) then {
    _boatVeh = (selectRandom KPLIB_o_boats) createVehicle _waterPos;
    [_boatVeh, KPLIB_side_enemy, _boatCrewGrp] call KPLIB_fnc_createCrew;
    
    private _lastPos = _waterPos;
    for "_i" from 0 to 2 do {
        private _waterPos = [[[_sectorPos, KPLIB_range_sectorCapture * 3]], [], {(_this isFlatEmpty [-1, -1, -1, -1, 2, false]) isNotEqualTo [] && (_lastPos distance2D _this >= 200) && {(abs (getTerrainHeightASL (AGLToASL (ASLToATL _this)))) > 25}}] call BIS_fnc_randomPos;
        if (_waterPos isEqualTo [0,0]) exitWith {};
        _lastPos = _waterPos;
        private _wp = _boatCrewGrp addWaypoint [_waterPos, 0];
        if (_i < 2) then {
            _wp setWaypointType "MOVE";
            //_wp setWaypointType "LIMITED";
            _wp setWaypointCompletionRadius 50;
            _wp setWaypointTimeout [10, 15, 20];
        } else {
            // Cycle
            _wp setWaypointType "CYCLE";
            _wp setWaypointCompletionRadius 50;
            _wp setWaypointTimeout [10, 15, 20];
        }
    };
};

(units _boatCrewGrp) + [_boatVeh]