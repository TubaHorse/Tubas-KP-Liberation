/*
    File: fn_counterArtillery.sqf
    Author: PiG13BR - https://github.com/PiG13BR
    Date: 01/09/2024
    Last Update: 20/07/2026
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Handles the counter artillery fire.
		It's executed when a artillery shell explodes via EH

    Parameter(s):
    	_unit - The artillery piece that fired [OBJECT]
		_unitPos - original position where the artillery fired [POSITION]
		_shellPos - Position where the shell exploded [POSITION]

    Returns:
        -
*/

params["_unit", "_unitPos", "_shellPos"];

if (!canSuspend) exitWith {_this spawn KPLIB_fnc_counterArtillery};

if (isNil "KPLIB_o_artilleryUnits") exitWith {};
if (KPLIB_o_artilleryUnits isEqualTo []) exitWith {};
if (count (((ASLToAGL _shellPos) nearEntities [["CAManBase", "landVehicle"], 200]) select {(alive _x) && (side _x == KPLIB_side_enemy)}) < 1) exitWith {};

// Each time that blufor fires an artillery and targets enemy units by shell exploding near them, it will raise the chance of the counter artillery
if (isNil "KPLIB_counterArtyChance") then {
	// Resets value if nil
	KPLIB_counterArtyChance = 25;
};

KPLIB_counterArtyChance = KPLIB_counterArtyChance + 5;

if (KPLIB_counterArtyChance >= 100) then {KPLIB_counterArtyChance = 100;};

publicVariableServer "KPLIB_counterArtyChance";

if (side _unit == KPLIB_side_player) then {

	private _chanceOfFiring = 0;

	// Find if the shell landed near the enemy artillery position by getting the nearest artillery piece
	private _nearestArtillery = [_shellPos, 200] call KPLIB_fnc_getNearestArtillery;

	if (!isNil "_nearestArtillery") then {
		_chanceOfFiring = 100; // Always react
	} else {
		_chanceOfFiring = KPLIB_counterArtyChance // Has a chance to react
	};
	if ((random 100) <= _chanceOfFiring) then {

		if (_unit getVariable ["KPLIB_CounterArtyReaction", false]) exitWith {}; // Exit loop
		_unit setVariable ["KPLIB_CounterArtyReaction", true];

		// Enemy artillery reaction time
		sleep ((10 + (random 20)) / (([] call KPLIB_fnc_getOpforFactor) * KPLIB_param_aggressivity));

		if ((_unit isKindOf "StaticMortar") || {_unit isKindOf "StaticWeapon"}) then {
			// Static target artillery
			private _ammoType = [["HE", (3 + (random 7))], ["CLUSTER", (1 + (random 1))]] selectRandomWeighted [0.8, 0.2];
			[_unitPos, 20, (_ammoType select 0), (_ammoType select 1)] call KPLIB_fnc_fireArtillery;
		} else {
			// Heavy/Mobile target artillery
			private _ammoType = [["HE", (3 + (random 7))], ["LG", 1]] selectRandomWeighted [0.2, 0.8]; // Heavy punishment for the use of heavy artillery
			if (_ammoType select 0 == "LG") then {
				[_unitPos, 20, (_ammoType select 0), (_ammoType select 1), objNull, _unit] call KPLIB_fnc_fireArtillery;
			} else {
				[_unitPos, 20, (_ammoType select 0), (_ammoType select 1)] call KPLIB_fnc_fireArtillery;
			};
		};

		// Delay
		sleep ((60 + (random 60)) / (([] call KPLIB_fnc_getOpforFactor) * KPLIB_param_aggressivity));
		_unit setVariable ["KPLIB_CounterArtyReaction", nil];
	}
};
