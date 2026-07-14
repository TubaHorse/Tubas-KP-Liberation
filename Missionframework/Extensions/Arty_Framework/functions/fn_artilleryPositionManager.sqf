/*
    File: fn_artilleryPositionManager.sqf
    Author: PiG13BR - https://github.com/PiG13BR
	Date: 06/10/2024
	Last Update: 13/07/2026
	License: MIT License - http://www.opensource.org/licenses/MIT

	Description:
		Manages the artillery position. Checks if the artillery units are still operational.

	Parameter(s):
		-

	Return(s):
		-
*/

if ((_despawnObjects isEqualTo []) || {count _despawnObjects < 2}) exitWith {};

// Replenish function
KPLIB_fnc_replenishArty = {
	[{
		if (!alive _this) exitWith {};
		if (count ([getPosASL _this, 300, KPLIB_side_player] call KPLIB_fnc_getNearbyEntities) > 0) exitWith {
			_this call KPLIB_fnc_replenishArty;
		};

		// Fix arty
		_this setDamage 0;
		_this setVehicleAmmo 1;
		_this setVehicleAmmoDef 1;
		[_this, 1] remoteExec ["setFuel"];

		// Create new crew
		if ((gunner _this) isEqualTo objNull) then {
			if (!alive (gunner _this) || !([_this] call KPLIB_fnc_ace_isAwake)) then {
				deleteVehicleCrew _this;
			};
			private _crewGrp = [_this] call KPLIB_fnc_createCrew;

			{
				// Eject crew if hit
				_x addEventHandler ["Hit", {
					params ["_unit", "_source", "_damage", "_instigator"];
					_unit setVariable ["KPLIB_artyUnitGotHit", true];

					private _grp = group _unit;
					private _veh = vehicle _unit;
					{
						_unit action ["eject", _veh];
					}forEach units _grp;
				}];

				// Force eject crew if dead 
				_x addMPEventHandler ["MPKilled", {
					params ["_unit", "_killer"];
					moveOut _unit;
				}];
			}forEach units _crewGrp;
		};
		_this setVariable ["KPLIB_artyReplenishing", false, true];
	}, _x, round (random [1200, 1800, 2400])] call CBA_fnc_waitAndExecute;
};
// Add PFH to update the artillery units variable
[{
	params["_args", "_handler"];

	// Check arty status
	KPLIB_o_artilleryUnits = KPLIB_o_artilleryUnits select {(alive _x)};

	// Find empty arty pieces to replenish
	private _emptyPieces = KPLIB_o_artilleryUnits select {
		!(_x getVariable ["KPLIB_artyReplenishing", false])
		&& ((gunner _x isEqualTo objNull) || {!alive (gunner _x)} || {!canFire _x})
	};

	if (count _emptyPieces > 0) then {
		// Start replenishment
		{
			_this call KPLIB_fnc_replenishArty;
		}forEach _emptyPieces;
	};

	if (KPLIB_o_artilleryUnits isEqualTo []) then {
		// Despawner
		{[_x] call KPLIB_fnc_despawnGroup}forEach KPLIB_artilleryPosition_groups;
		{[_x] call KPLIB_fnc_despawnObject}forEach KPLIB_artilleryPosition_objects;

		["KPLIB_artilleryPosDestroyed", []] call CBA_fnc_globalEvent;
		
		["Arty position destroyed. Despawner initiated", "ARTILLERY POSITION"] call KPLIB_fnc_log;
		
		KPLIB_artilleryPosition_Down = KPLIB_artilleryPosition_Down + 1;
		// Remove PFH
		[_handler] call CBA_fnc_removePerFrameHandler;
		// Call the artillery spawn script
		[] call KPLIB_fnc_artilleryTimerSpawn;
		// Reset counter artillery chance
		KPLIB_counterArtyChance = nil;
		KPLIB_artyHashMap_ammo = nil;
		KPLIB_artilleryPosition_groups = nil;
		KPLIB_artilleryPosition_objects = nil;
	};
}, 60, []] call CBA_fnc_addPerFrameHandler; 
