params["_airport"];

// Prepare artillery fire if available or send CAS
["", markerPos _airport, "", false] call KPLIB_fnc_battlegroupAttackHeli;
["", markerPos _airport, "", false] call KPLIB_fnc_battlegroupTransportHeli;
["", markerPos _airport, "", false] call KPLIB_fnc_battlegroupTransportHeli;

if ((random KPLIB_enemyReadiness) > (20 + (30 / KPLIB_param_aggressivity))) then {
    ["", markerPos _airport, "", false] call KPLIB_fnc_battlegroupAttackHeli;
} else {
    ["", markerPos _airport, "", false] call KPLIB_fnc_battlegroupTransportHeli;
};