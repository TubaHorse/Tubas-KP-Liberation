params["_sector"];

// ToDo: Notification.

switch (true) do {
    case (_sector in KPLIB_sectors_airport) : {
        _sector call KPLIB_fnc_airportCounterAttack;
    };
    case (_sector in KPLIB_sectors_capital) : {
        [markerPos _sector] call KPLIB_fnc_spawnBattlegroup;
    };
    default {};
};