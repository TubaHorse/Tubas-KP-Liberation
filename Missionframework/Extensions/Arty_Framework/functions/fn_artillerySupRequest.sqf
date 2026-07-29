/*
	File: fn_artillerySupRequest.sqf
	Author: PiG13BR - https://github.com/PiG13BR
	Date: 10/09/2024
	Last Update: 20/04/2026
	License: MIT License - http://www.opensource.org/licenses/MIT

	Description:
		Request artillery strike at a target object

	Parameter(s):
		_grp - Group of requester [GROUP]
		_grpLeader - Requester [OBJECT - Infantry unit]
		_target - Target object [OBJECT - Infantry unit/vehicle]
		_targetPos - Target Position [POSITION]
	
	Returns:
		-
*/

params["_grp", "_grpLeader", "_target", "_targetPos"];

// Check if the leader can see the target
private _visibility = [objNull, "VIEW"] checkVisibility [eyePos _grpLeader, eyePos _target];
private _knowsAbout = _grpLeader knowsAbout _target;

if ((_visibility <= 0.1) && {_knowsAbout < 1}) exitWith {};

// Arty support is per group.
if ((_grp getVariable ["KPLIB_artySupportCalled", false])) exitWith {};
_grp setVariable ["KPLIB_artySupportCalled", true];

// AI Disable features
_grpLeader forceSpeed 0;
_grpLeader setUnitPos "MIDDLE";
if (local _grpLeader) then {
	_grpLeader doWatch _targetPos;
} else {
	[_grpLeader, _targetPos] remoteExec ["doWatch", _grpLeader];
};

_grpLeader disableAI "FireWeapon";

sleep 2;

// Force AI to use binocular by removing it's weapons
// Save weapons and magazines for later
_grpLWeapons = weapons _grpLeader;
_grpLMagazines = (magazines _grpLeader) + [currentMagazine _grpLeader];
removeAllWeapons _grpLeader;

if ((binocular _grpLeader) isEqualTo "") then {
	_grpLeader addWeapon "binocular";
};

_grpLeader selectWeapon (binocular _grpLeader);

sleep (7 + (random 3)); // The players has a chance to kill the leader before it calls the arty strike
if (!(alive _grpLeader) || {!([_grpLeader] call KPLIB_fnc_ace_isAwake)}) exitWith {};

// From this point, enemy artillery strike is unavoidable

// AI enable features back
_grpLeader forceSpeed -1;
_grpLeader enableAI "FireWeapon";
_grpLeader setUnitPos "AUTO";

// Add magazines back
{
	_grpLeader addMagazine _x;
}forEach _grpLMagazines;

// Add weapons back
{
	_grpLeader addWeapon _x;
}forEach _grpLWeapons;

// If provided position is too far from the real killer position, fire a check round instead
if ((_targetPos distance2d _target > 100) && (_targetPos distance2d _target < 300)) exitWith {
	["KPLIB_fireArtillery", [_targetPos, 0, "HE", 1 + (random 1)]] call CBA_fnc_serverEvent;

	// Artillery strike cooldown
	[{
		_thisArgs setVariable ["KPLIB_artySupportCalled", nil];
	},_grp ,(20 + (random 20)) / (([] call KPLIB_fnc_getOpforFactor) * KPLIB_param_aggressivity)] call CBA_fnc_waitAndExecute;
};

// Infantry Section
if ((_target isKindOf "CAManBase") && (isNull objectParent _target)) then {
	// Machine-gunner/Sniper killer (if doesn't work, blame shitty mod config)
	if (((primaryweapon _target call BIS_fnc_itemtype) select 1 == "MachineGun") || {(primaryweapon _target call BIS_fnc_itemtype) select 1 == "SniperRifle"}) then {
		
		private _ammoType = [[100, "HE", (3 + (random 7))], [0, "SMOKE", (3 + (random 2))]] selectRandomWeighted [0.5, 0.5];
		_ammoType params ["_spread", "_ammo", "_rounds"];
		["KPLIB_fireArtillery", [_targetPos, _spread, _ammo, _rounds]] call CBA_fnc_serverEvent;
	} else {
		private _ammoType = "HE";
		private _spread = 100;
		private _rounds = (5 + (random 7));

		// Ordinary infantry
		if (sunOrMoon < 1) then {
			["KPLIB_ArtilleryFireFlare", [_targetPos, _spread, _ammoType, _rounds]] call CBA_fnc_serverEvent;
		} else {
			["KPLIB_fireArtillery", [_targetPos, _spread, _ammoType, _rounds]] call CBA_fnc_serverEvent;
		};
	};
};

// Vehicles Section
if ((getNumber(configFile >> "CfgVehicles" >> (typeOf (vehicle _target)) >> "ArtilleryScanner")) == 1) exitWith {}; // Let the counter battery handle artillery fire

if ((toLower (typeOf (vehicle _target))) in KPLIB_allLandVeh_classes) then {
	if ((((typeOf (vehicle _target)) isKindOf "Tank") || {(typeOf (vehicle _target)) isKindOf "Wheeled_APC_F"} || {(typeOf (vehicle _target)) isKindOf "TrackedAPC"} || {(typeOf (vehicle _target)) isKindOf "Wheeled_APC_F"}) && !((typeOf (vehicle _target)) isKindOf "Air")) then {
		// Heavy vehicle
		private _ammoType = [["CLUSTER", 1 + (random 2)], ["LG", 1 + (random 1)], objNull, _target] selectRandomWeighted [0.5, 0.9];
		_ammoType params 
		[
			"_ammo", 
			"_rounds", 
			["_artillery", objNull], 
			["_laserTarget", objNull]
		];
		
		["KPLIB_fireArtillery", [_targetPos, 10, _ammo, _rounds, _artillery, _laserTarget]] call CBA_fnc_serverEvent;
	} else {
		// Light vehicle
		["KPLIB_fireArtillery", [_targetPos, 10, "HE", (3 + (random 7))]] call CBA_fnc_serverEvent;
	}
};

// Artillery strike cooldown
[{
	_thisArgs setVariable ["KPLIB_artySupportCalled", nil];
},_grp ,(90 + (random 30)) / (([] call KPLIB_fnc_getOpforFactor) * KPLIB_param_aggressivity)] call CBA_fnc_waitAndExecute;
