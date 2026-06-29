/*
	File: fn_reloadLoadout.sqf
	Author: PiG13BR - https://github.com/PiG13BR
	Date: 14/10/2025
	Last Update: 15/06/2026
	License: MIT License - http://www.opensource.org/licenses/MIT

	Description:
		Reloads aircraft's loadout variable

	Parameter(s):
		-
	
	Returns:
		-
*/

_originalCount = count PIG_PAS_airLoadout;
PIG_PAS_airLoadout = [];

for "_i" from 1 to _originalCount do {
    PIG_PAS_airLoadout pushBack ["", [0]]; // Restore default pylon slots
};