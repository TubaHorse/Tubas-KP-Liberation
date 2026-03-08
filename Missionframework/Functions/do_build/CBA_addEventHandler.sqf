// FOB Builded
["KPLIB_fobBuilded", {
    params["_newFob", "_create_fob_building"];
    
    [{
        params["_newFob", "_create_fob_building"];

        _newFob allowDamage false; 
        private _newFobPos = getPosATL _newFob;
        [_newFobPos, _create_fob_building] spawn build_fob_remote_call;
    }, [_newFob, _create_fob_building]] call CBA_fnc_execNextFrame;

}] call CBA_fnc_addEventHandler;

// Build object (server event)
["KPLIB_buildObject",{
    private _newObject = _this call KPLIB_fnc_spawnBuildedObject;

    private _repeat = _this # 7;
    if (_repeat) then {
        // Repeat building process
        ["KPLIB_repeatBuild", [_newObject, _player], _player] call CBA_fnc_targetEvent;
    }
}] call CBA_fnc_addEventHandler;

// Repeat build (target event)
["KPLIB_repeatBuild", {
    params["_repeatObject", "_player"];

    [_repeatObject, _player] call KPLIB_fnc_spawnRepeatedObject;
}] call CBA_fnc_addEventHandler;

// Factory storage builded
["KPLIB_factoryStorageBuilded", { 
    _this call KPLIB_fnc_registerStorageSector;
}] call CBA_fnc_addEventHandler;