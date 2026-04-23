// FOB Builded
["KPLIB_fobBuilded", {
    params["_newFob", "_create"];
    
    [{
        params["_newFob", "_create"];

        _newFob allowDamage false; 
        private _newFobPos = getPosATL _newFob;
        [_newFobPos, _create] call KPLIB_fnc_createFob;
    }, [_newFob, _create]] call CBA_fnc_execNextFrame;

}] call CBA_fnc_addEventHandler;

["KPLIB_outpostBuilded", {
    params["_newOutpost", "_create"];
    
    [{
        params["_newOutpost", "_create"];

        _newOutpost allowDamage false;
        _newOutpost setVariable ["KPLIB_isOutpost", true, true];
        
        private _newOutpostPos = getPosATL _newOutpost;
        [_newOutpostPos, _create] call KPLIB_fnc_createOutpost;
    }, [_newOutpost, _create]] call CBA_fnc_execNextFrame;

}] call CBA_fnc_addEventHandler;

// Build object (server event)
["KPLIB_buildObject",{
    private _newObject = _this call KPLIB_fnc_spawnBuildedObject;
    

    private _repeat = _this # 7;
    if (_repeat) then {
        private _player = _this # 6;
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