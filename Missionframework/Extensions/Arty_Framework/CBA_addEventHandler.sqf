// Artillery firing
["KPLIB_artilleryFiring", {
    params["_gunner", "_targetPos", ["_eta", 60], ["_area", 100]];
    [_gunner, _targetPos, _eta, _area] call remote_call_artillery_firing;
}] call CBA_fnc_addEventHandler;

if (isServer && KPLIB_LAMBS) then {
    ["lambs_danger_OnArtilleryCalled", {
        params["_caller", "_groupCaller", "_artilleryGun", "_targetPos"];

        private _playersInArea = allPlayers select {_x distance2d _targetPos < 200};
        ["KPLIB_artilleryFiring", [gunner _artilleryGun, _targetPos], _playersInArea] call CBA_fnc_targetEvent;
        ["KPLIB_generateLog", [format ["Unit (%1) called artillery fire at pos %2",_caller, _targetPos], "LAMBS ARTILLERY"]] call CBA_fnc_serverEvent;
    }] call CBA_fnc_addEventHandler;
};

// Artillery position destroyed
["KPLIB_artilleryPosDestroyed", {
    ["lib_artillery_destroyed", ["", ""]] call BIS_fnc_showNotification;
}] call CBA_fnc_addEventHandler;

// Counter artillery
["KPLIB_counterArtillery", {
    params ["_unit", "_unitPos", "_typePos"];
    [_unit, _unitPos, _typePos] spawn KPLIB_fnc_counterArtillery;
}] call CBA_fnc_addEventHandler;

// Fire artillery
["KPLIB_fireArtillery", {
    _this call KPLIB_fnc_fireArtillery;
}] call CBA_fnc_addEventHandler;

// Fire Flare and then strike
["KPLIB_ArtilleryFireFlare", {
    params["_targetPos", "_spread", "_type", "_rounds"];

    // Find flare magazine
    private _ammoClass = KPLIB_artyHashMap_ammo get "KPLIB_arty_FLARE_round";
    if (_ammoClass != "") then {
        private _artyReturns = [_targetPos, 10, _ammoClass, 1] call KPLIB_fnc_fireArtillery;
        _artyReturns params ["", "_artyElements"];
            private _eta = _artyElements select 1; // Gets the shell's ETA
            [
                {
                    _this params ["_targetPos", "_type", "_rounds"];
                    [_targetPos, _spread, _type, _rounds] call KPLIB_fnc_fireArtillery;
                }, 
                [_targetPos, _spread, _type, _rounds], 
                _eta + 5
            ] call CBA_fnc_waitAndExecute;
    } else {
        // No flare, fire directly
        [_targetPos, _spread, _type, _rounds] call KPLIB_fnc_fireArtillery;
    };
}] call CBA_fnc_addEventHandler;

// Detect group unit kills
["KPLIB_onUnitKilled", {
    params ["_group", "_unit", "_killer"];
    [_group, _unit, _killer] call KPLIB_fnc_onUnitKilled;
}] call CBA_fnc_addEventHandler;