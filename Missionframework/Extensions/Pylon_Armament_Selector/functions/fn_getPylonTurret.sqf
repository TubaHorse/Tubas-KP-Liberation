/*
	File: fn_getPylonTurret.sqf
	Author: PabstMirror (ACE)
	Date: 14/10/2025
	Last Update: 16/10/2025
	License: MIT License - http://www.opensource.org/licenses/MIT

	Description:
        Get turret of the selected pylon

	Parameter(s):
		_vehicle - vehicle to check pylons pos [OBJECT]
		_pylon - pylon name [STRING]
	
	Returns:
		Pylon turret [ARRAY]
*/

params["_vehicle", "_pylon"];

((getAllPylonsInfo _vehicle) param [_pylon, []]) param [2, [-1]]