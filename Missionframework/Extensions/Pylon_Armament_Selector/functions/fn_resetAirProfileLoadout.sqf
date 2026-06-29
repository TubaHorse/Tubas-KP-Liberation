#include "..\defines.hpp"
/*
	File: fn_resetAirProfileLoadout.sqf
	Author: PiG13BR - https://github.com/PiG13BR
	Date: 14/10/2025
	Last Update: 22/06/2025
	License: MIT License - http://www.opensource.org/licenses/MIT

	Description:
        Resets profile loadout (this action can't be undone)

	Parameter(s):
		-
	
	Returns:
		-
*/

// Create/overwrite variable in profilenamespace
profileNamespace setVariable ["PIG_PAS_profilePresets", createHashMap];