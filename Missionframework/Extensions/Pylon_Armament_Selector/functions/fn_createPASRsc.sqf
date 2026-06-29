#include "..\defines.hpp"
/*
	File: fn_createPASRsc.sqf
	Author: PiG13BR - https://github.com/PiG13BR
	Date: 14/10/2025
	Last Update: 22/06/2026
	License: MIT License - http://www.opensource.org/licenses/MIT

	Description:
		Create display for pylon armament selector
		
	Parameter(s):
		_aircraft - aircraft to change pylons [OBJECT, defaults to objNull]
	
	Returns:
		-
*/

params[["_aircraft", objNull, [objNull]]];

if (isNull _aircraft) exitWith {};

localNamespace setVariable ["PIG_PAS_aircraft", _aircraft];

private _displayToUse = findDisplay IDD_MISSION;

[{_this createDisplay "PIG_PAS_RscMainMenu"}, _displayToUse] call CBA_fnc_execNextFrame;