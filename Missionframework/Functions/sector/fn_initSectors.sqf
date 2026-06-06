/*
    File: fn_initSectors.sqf
    Author: KP Liberation Dev Team - https://github.com/KillahPotatoes
    Date: 2020-04-29
    Last Update: 2026-06-01
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Sorts the placed sector markers to their category array.

    Parameter(s):
        NONE

    Returns:
        Function reached the end [BOOL]
*/

KPLIB_sectors_airSpawn = [];
KPLIB_sectors_all = [];
KPLIB_sectors_capital = [];
KPLIB_sectors_city = [];
KPLIB_sectors_factory = [];
KPLIB_sectors_military = [];
KPLIB_sectors_airport = [];
KPLIB_sectors_spawn = [];
KPLIB_road_spawn = [];
KPLIB_sectors_tower = [];
KPLIB_fillers_patrol = [];
KPLIB_fillers_aa = [];
KPLIB_fillers_all = [];

{
    switch (true) do {
        case (_x find "bigtown" == 0): {KPLIB_sectors_capital pushBack _x; KPLIB_sectors_all pushBack _x;};
        case (_x find "capture" == 0): {KPLIB_sectors_city pushBack _x; KPLIB_sectors_all pushBack _x;};
        case (_x find "factory" == 0): {KPLIB_sectors_factory pushBack _x; KPLIB_sectors_all pushBack _x;};
        case (_x find "military" == 0): {KPLIB_sectors_military pushBack _x; KPLIB_sectors_all pushBack _x;};
        case (_x find "airport_area" == 0): {KPLIB_sectors_airport pushBack _x; KPLIB_sectors_all pushBack _x; [_x] call KPLIB_fnc_initAirportSector};
        case (_x find "opfor_airspawn" == 0): {KPLIB_sectors_airSpawn pushBack _x;};
        case (_x find "opfor_point" == 0): {KPLIB_sectors_spawn pushBack _x;};
        case (_x find "opfor_spawn_road" == 0): {KPLIB_road_spawn pushBack _x;};
        case (_x find "tower" == 0): {KPLIB_sectors_tower pushBack _x; if (isServer) then {_x setMarkerText format ["%1 %2",markerText _x, mapGridPosition (markerPos _x)];}; KPLIB_sectors_all pushBack _x;};
        case (_x find "filler_inf" == 0): {KPLIB_fillers_patrol pushBack _x; _x setMarkerAlpha 0; KPLIB_fillers_all pushBack _x;};
        case (_x find "filler_aa" == 0): {KPLIB_fillers_aa pushBack _x; _x setMarkerAlpha 0; KPLIB_fillers_all pushBack _x;};
    };
} forEach allMapMarkers;

true
