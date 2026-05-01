// Jam Drone (target client)
["KPLIB_jamDrone", {
    _this setVariable ["KPLIB_droneGettingJammed", true, true];
    [{_this call KPLIB_fnc_droneJamEffects}, 0.1, _this] call CBA_fnc_addPerFrameHandler;
}] call CBA_fnc_addEventHandler;