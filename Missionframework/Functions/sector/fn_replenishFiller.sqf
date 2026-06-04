/*
	File: fn_replenishFiller.sqf
	Author: PiG13BR - https://github.com/PiG13BR
	Date: 20/12/2025
	Last Update: 13/02/2026
	License: MIT License - http://www.opensource.org/licenses/MIT

	Description:
        Replenish filler if there is an enemy military sector within range.
        Basically by removing it from the players captured sectors list so it can be activated again.

	Parameter(s):
		_filler - filler sector [STRING]
	
	Returns:
		-
*/

params["_filler"];

if (KPLIB_player_fobs findIf {((markerPos _filler) distance2D _x) < 500} >= 0) exitWith {}; // Exit if there is a FOB nearby
if (KPLIB_player_outposts findIf {((markerPos _filler) distance2D _x) < 500} >= 0) exitWith {}; // Exit if there is a Outpost nearby

private _base = [markerPos _filler, KPLIB_side_enemy, KPLIB_range_replenishRadius] call KPLIB_fnc_getNearestMilitaryBase;

if !(isNil "_base") then {
    // Now this outpost can spawn assets again
    KPLIB_sectors_player deleteAt (KPLIB_sectors_player find _filler);
};
