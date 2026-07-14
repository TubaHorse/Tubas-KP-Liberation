/*
    File: fn_sectorCounterAttack.sqf
    Author: PiG13BR - https://github.com/PiG13BBR
    Date: 05/06/2026
    Last Update: 12/07/2026
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Handles enemy counter attacks

    Parameter(s):
        _sector - sector to counter attack [STRING, defaults to ""]

    Returns:
        -
*/
params[["_sector", "", [""]]];

if (_sector isEqualTo "") exitWith {["No sector provided"] call BIS_fnc_error};

// ToDo: Notification.

switch (true) do {
    case (_sector in KPLIB_sectors_airport) : {
        _sector spawn KPLIB_fnc_airportCounterAttack;
    };
    case (_sector in KPLIB_sectors_capital) : {
        [markerPos _sector] call KPLIB_fnc_spawnBattlegroup;
    };
    case (_sector in KPLIB_sectors_military) : {
        [markerPos _sector] call KPLIB_fnc_spawnBattlegroup;
    };
    case (_sector in KPLIB_sectors_city) : {
        if (KPLIB_enemyReadiness >= (50 - (5 * KPLIB_param_difficulty))) then {
            [markerPos _sector] call KPLIB_fnc_spawnBattlegroup;
        };
    };
    case (_sector in KPLIB_sectors_factory) : {
        if (KPLIB_enemyReadiness >= (50 - (5 * KPLIB_param_difficulty))) then {
            [markerPos _sector] call KPLIB_fnc_spawnBattlegroup;
        };
    };
    default {};
};