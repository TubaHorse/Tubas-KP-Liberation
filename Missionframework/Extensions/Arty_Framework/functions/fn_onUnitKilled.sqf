/*
	File: fn_onUnitKilled.sqf
	Author: PiG13BR - https://github.com/PiG13BR
	Date: 11/10/2024
    Last Update: 19/07/2026
    License: MIT License - http://www.opensource.org/licenses/MIT

	Description:
		Handles the calling of enemy artillery support if group of enemy units is attacked

	Parameter(s):
		_grp - group of the unit that got killed [GROUP]
		_unit - unit that got killed [OBJECT - Infantry unit]
		_killer - killer [OBJECT - Infantry unit]
	
	Returns:
		-
*/

params ["_grp", "_unit", "_killer"];

// Return the nearest sector of the killed unit
private _sector = [300, getPosATL _unit] call KPLIB_fnc_getNearestSector;
// Is this an active sector?
if (!(_sector in KPLIB_sectors_active) || {_sector in KPLIB_sectors_player}) exitWith {};

if ((!(isNull objectParent _unit)) && {vehicle (leader _grp) != (leader _grp)}) exitWith {};

// ---------------------------------------------------------- ENEMY ARTILLERY SUPPORT HANDLING
if (!isNil "KPLIB_o_artilleryUnits") then {

	private _minDist = 100; // This is the minumun distance from the killer that the leader can call the artillery

	// Check distance from killer and artillery availability
	if ((_unit distance2d _killer >= _minDist) && {KPLIB_o_artilleryUnits isNotEqualTo []}) then {
		if ((side _killer) == KPLIB_side_player) then {
			private _grpLeader = leader _grp;

			// "Returns the Position where object believes the enemy to be".
			private _posKiller = _grpLeader getHideFrom _killer;
			if (_posKiller isEqualTo [0,0,0]) exitWith {}; // "A returned position of [0,0,0] implies that object does not knowAbout enemy

			// Check if the provided position is not inside a town/capital
			if (((_sector in KPLIB_sectors_capital) || {_sector in KPLIB_sectors_city}) && {_posKiller distance (markerpos _sector) < 250}) exitWith {};

			// Check if possible position is too far from the original position or too near to friendlies
			if ((_posKiller distance2d _killer >= 200) || {count((_posKiller nearEntities [["CAManBase"], 75]) select {side _x == KPLIB_side_enemy}) > 0}) exitWith {};

			if (KPLIB_enemyReadiness >= (20 - (5 * KPLIB_param_difficulty))) then {
				[_grp, _grpLeader, _killer, _posKiller] spawn KPLIB_fnc_artillerySupRequest;
			};
		};
	};
};