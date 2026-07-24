/*
    File: fn_SAM_incomingMissile.sqf
    Author: PiG13BR (https://github.com/PiG13BR)
    Date: 05/12/2025
    Last Update: 21/07/2026
    License: MIT License - http://www.opensource.org/licenses/MIT
    
    Description:
        Set "incomingMissile" EH for radar and SHORADS to try to defeat incoming missiles
    
    Parameter(s):
        _radar - radar to add event handler [OBJECT]
		_shorads - SHORADS available [ARRAY, defaults to []]
    
    Returns:
        [BOOL]
*/

params["_radar", ["_shorads", []]];

if (_shorads isEqualTo []) exitWith {false};

[
	_radar, "IncomingMissile", 
	{
		params ["_target", "_ammo", "_vehicle", "_instigator", "_missile"];
		private _shorad = _thisArgs;

		// Check for available shorads
		_shorad = _shorad select {alive _x && {alive (gunner _x)} && {unitReady _x} && {!(_x getVariable ["KPLIB_isTargettingMissile", false])}};

		if (_shorad isEqualTo []) exitWith {};

		if (count _shorad > 1) then {_shorad = selectRandom _shorad} else {_shorad = _shorad # 0};

		//[format["Unit (%1) fired HARM missile (%7) at %2(%3). SHORAD: %4(%5). Local missile: %6", _instigator, _target, typeOf _target, _shorad, typeOf _shorad, local _missile, _missile], "SHORAD"] remoteExec ["KPLIB_fnc_log", 2];

		if (local _shorad) then {
			[_shorad, _target, _missile] call KPLIB_fnc_SAM_shoradTargetMissile;
		} else {
			[_shorad, _target, _missile] remoteExecCall ["KPLIB_fnc_SAM_shoradTargetMissile", _shorad];
		};
	}, 
	_shorads
] call CBA_fnc_addBISEventHandler;

// Add EH to the shoards themselves
{
	_x addEventHandler ["IncomingMissile", {
		params ["_target", "_ammo", "_vehicle", "_instigator", "_missile"];
	
		// Check for available shorads
		if (_target getVariable ["KPLIB_isTargettingMissile", false] || {!unitReady _target}) exitWith {};

		//[format["Unit (%1) fired HARM missile (%7) at %2(%3). SHORAD: %4(%5). Local missile: %6", _instigator, _target, typeOf _target, _shorad, typeOf _shorad, local _missile, _missile], "SHORAD"] remoteExec ["KPLIB_fnc_log", 2];

		if (local _target) then {
			[_target, _target, _missile] call KPLIB_fnc_SAM_shoradTargetMissile;
		} else {
			[_target, _target, _missile] remoteExecCall ["KPLIB_fnc_SAM_shoradTargetMissile", _target];
		};
	}];
}forEach _shorads;

true