/*
	File: fn_updateTurretButton.sqf
	Author: PiG13BR - https://github.com/PiG13BR
	Date: 14/06/2026
	Last Update: 22/06/2026
	License: MIT License - http://www.opensource.org/licenses/MIT

	Description:
		Update turret button position

	Parameter(s):
		_display - display to unload [DISPLAY, defauls to displayNull]
	
	Returns:
		-
*/
params["_args", "_pylon"];
_args params ["_ctrl", "_aircraft"];

private _pylonRelPos = PIG_PAS_pylonsPosHash get _pylon;
private _center = PIG_PAS_cameraHelper;
_pos = _aircraft modeltoworldvisual _pylonRelPos; 
_uiPos = worldtoscreen _pos;

_ctrl ctrlSetPosition [
    (_uiPos select 0) - (0.01055 * safeZoneW),//  + (0.235 * safeZoneW)
    (_uiPos select 1) - (0.024), //  + 0.2
    0.0205 * safeZoneW,
    0.032 * safeZoneH
];
_ctrl ctrlcommit 0;