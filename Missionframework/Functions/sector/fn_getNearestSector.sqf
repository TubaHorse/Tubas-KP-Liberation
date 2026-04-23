/*
    File: fn_getNearestSector.sqf
    Author: KP Liberation Dev Team - https://github.com/KillahPotatoes
    Date: 2019-12-03
    Last Update: 2026-14-04
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Gets the marker of the nearest sector from given position inside given radius.
        As default, only get visible sectors, not fillers

    Parameter(s):
        _radius - Radius in which to look for the nearest sector    [NUMBER, defaults to 1000]
        _pos    - Position to look from for the nearest sector      [POSITION, defaults to getPos player]
        _sectors - sectors to find the nearest sector               [ARRAY, defaults to []]
        _enemySector - Get enemy sectors only                       [BOOL, defaults to false]
        

    Returns:
        Marker of nearest sector [STRING]
*/

params [
    ["_radius", 1000, [0]],
    ["_pos", getPos player, [[]], [2, 3]],
    ["_sectors", [], [[]]],
    ["_enemySector", false, [false]]
];

if (_sectors isNotEqualTo []) then {
    if (_enemySector) then {
        // Only enemy sectors
        _sectors = _sectors - KPLIB_sectors_player select {((markerPos _x) distance2d _pos) < _radius};
    } else {
        _sectors = KPLIB_sectors_all select {((markerPos _x) distance2d _pos) < _radius};
    };

} else {
    if (_enemySector) then {
        // Only enemy sectors
        _sectors = (KPLIB_sectors_all - (KPLIB_sectors_player - KPLIB_fillers_patrol)) select {((markerPos _x) distance2d _pos) < _radius};
    } else {
        _sectors = KPLIB_sectors_all select {((markerPos _x) distance2d _pos) < _radius};
    };
};

if (_sectors isEqualTo []) exitWith {""};

_sectors = _sectors apply {[(markerPos _x) distance2d _pos, _x]};
_sectors sort true;

(_sectors select 0) select 1