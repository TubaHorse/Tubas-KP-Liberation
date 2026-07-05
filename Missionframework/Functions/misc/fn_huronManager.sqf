/*
    File: fn_spawnHuronStart.sqf
    Author: KP Liberation Dev Team - https://github.com/KillahPotatoes, PiG13BR - https://github.com/PiG13BR
    Date: 05/05/2026
    Last Update: 02/07/2026
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Spawns the huron (KPLIB_b_potato01) at start

    Parameter(s):
        -

    Returns:
        -
*/

waitUntil {!isNil "KPLIB_saveLoaded"};
waitUntil {KPLIB_saveLoaded};

KPLIB_potato01 = objNull;

// Detect possible Potato 01 from loaded save data
private _savedPotato = vehicles select {(toLowerANSI (typeOf _x)) isEqualTo (toLowerANSI KPLIB_b_potato01)};
if !(_savedPotato isEqualTo []) then {
    KPLIB_potato01 = _savedPotato select 0;
};

while {true} do {
    // Spawn new huron if not loaded or destroyed
    if !(alive KPLIB_potato01) then {
        KPLIB_potato01 = KPLIB_b_potato01 createVehicle [(getposATL huronspawn) select 0, (getposATL huronspawn) select 1, ((getposATL huronspawn) select 2) + 0.2];
        KPLIB_potato01 enableSimulationGlobal false;
        KPLIB_potato01 allowdamage false;
        KPLIB_potato01 setDir (getDir huronspawn);
        KPLIB_potato01 setPosATL (getposATL huronspawn);
        KPLIB_potato01 setDamage 0;
        sleep 0.5;
        KPLIB_potato01 enableSimulationGlobal true;
        KPLIB_potato01 setDamage 0;
        KPLIB_potato01 allowdamage true;
        [KPLIB_potato01] call KPLIB_fnc_addObjectInit;
    };
    [KPLIB_potato01] call KPLIB_fnc_clearCargo;
    publicVariable "KPLIB_potato01";

    // Wait until huron is destroyed to respawn it
    waitUntil {sleep 5; !alive KPLIB_potato01};
    stats_potato_respawns = stats_potato_respawns + 1;
    sleep KPLIB_potatoRespawnDelay;

    // Delete wreck, if near startbase
    if (KPLIB_potato01 distance startbase < 500) then {
        deletevehicle KPLIB_potato01;
    };
};
