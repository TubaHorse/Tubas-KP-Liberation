/*
    File: fn_sectorCounterAttack.sqf
    Author: PiG13BR - https://github.com/PiG13BBR
    Date: 05/06/2026
    Last Update: 13/07/2026
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Handles airport counter attacks

    Parameter(s):
        _airport - airport to counter attack [STRING, defaults to ""]

    Returns:
        -
*/
params[["_airport", "", [""]]];

if (_airport isEqualTo "") exitWith {["No sector provided"] call BIS_fnc_error};

sleep (90 + (random 30));
[_airport] call KPLIB_fnc_fireAtCapturedSector;

sleep (20 + (random 30));

["", markerPos _airport, "", false] call KPLIB_fnc_battlegroupAttackHeli;
sleep 2;
if (KPLIB_param_unitCap >= 1) then {
    ["", markerPos _airport, "", false] call KPLIB_fnc_battlegroupTransportHeli;
};
sleep 2;
["", markerPos _airport, "", false] call KPLIB_fnc_battlegroupTransportHeli;
sleep 2;,
if (KPLIB_param_unitCap >= 1) then {
    ["", markerPos _airport, "", false] call KPLIB_fnc_battlegroupSlingLoadVeh;
};
sleep 2;
["", markerPos _airport, "", false] call KPLIB_fnc_battlegroupSlingLoadVeh;