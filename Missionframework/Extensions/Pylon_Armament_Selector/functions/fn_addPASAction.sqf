/*
	File: fn_addPASAction.sqf
	Author: PiG13BR - https://github.com/PiG13BR
	Date: 20/10/2025
	Last Update: 23/06/2026
	License: MIT License - http://www.opensource.org/licenses/MIT

	Description:
        Add plyon manager action to all air vehicle classes

	Parameter(s):
		_aircraft - aircraft object to add pylon armament selector
	
	Returns:
		-
*/

params ["_aircraft"];

if !(isClass ((configOf _aircraft) >> "Components" >> "TransportPylonsComponent")) exitWith {};

// Select Icon
private _actionIcon = ['Extensions\Pylon_Armament_Selector\icons\helicopter.paa', 'Extensions\Pylon_Armament_Selector\icons\jet.paa'] select (_aircraft isKindOf "Plane");

//if (hasPilotCamera _aircraft) then {
	if (!alive _aircraft) exitWith {};
	private _action = [
		"PIG_PAS_Action", 
		localize "STR_PAS_TITLE", 
		_actionIcon, 
		{
			[_target] call KPLIB_fnc_createPASRsc
		}, 
		{
			(_player == driver _target) 
			&& {speed _target < 1} 
			&& {!isEngineOn _target} 
			&& {_target nearEntities [parseSimpleArray PIG_PAS_RequireNearby, 50] isNotEqualTo []}
		}
	] call ace_interact_menu_fnc_createAction;

	[_aircraft, 1, ["ACE_SelfActions"], _action] call ace_interact_menu_fnc_addActionToObject;
//};
