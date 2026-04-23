// Call enemy fighter
["KPLIB_callEnemyFighter", {
    [_this] call KPLIB_fnc_callEnemyFighter;

    // Set a cooldown for the same target. Used to ignore the collection of valid targets.
    _this setVariable ["KPLIB_fighterCalledUpon", true, true];

    [{
        _this setVariable ["KPLIB_fighterCalledUpon", false, true];
    }, _this, round(random [1200, 1500, 1800])] call CBA_fnc_waitAndExecute;
}] call CBA_fnc_addEventHandler;