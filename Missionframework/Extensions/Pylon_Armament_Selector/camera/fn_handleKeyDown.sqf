/*
	File: fn_handleKeyDown.sqf
	Author: Alganthe, johnb43 (ACE). For PAS: PiG13BR - https://github.com/PiG13BR.
	Date: 06/07/2026
	Last Update: 06/07/2026
	License: MIT License - http://www.opensource.org/licenses/MIT

	Description:
        Handles key down

	Parameter(s):
		Display/control passed argument
	
	Returns:
		-
*/
params ["_displayOrControl", "_key", "_shift", "_ctrl", "_alt"];

if (_key in (actionKeys "nightvision")) then {
    if (isNil "PIG_PAS_visionMode") then {
        PIG_PAS_visionMode = 0;
    };

    PIG_PAS_visionMode = (PIG_PAS_visionMode + 1) % 3;

    switch (PIG_PAS_visionMode) do {
        // Normal
        case 0: {
            camUseNVG false;
            false setCamUseTI 0;
        };
        // NVG
        case 1: {
            camUseNVG true;
            false setCamUseTI 0;
        };
        // TI
        default {
            camUseNVG false;
            true setCamUseTI 0;
        };
    };

    playSound ["RscDisplayCurator_visionMode", true];
};