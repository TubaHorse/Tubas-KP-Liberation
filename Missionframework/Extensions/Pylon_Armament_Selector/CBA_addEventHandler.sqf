["KPLIB_addActionPAS", {
    _this call KPLIB_fnc_addPASAction;
}] call CBA_fnc_addEventHandler;

["PAS_setPylonArmament", {  
    _this call KPLIB_fnc_setPylonConfiguration
}] call CBA_fnc_addEventHandler;

["PAS_removeTurretWeapons", {  
    _this call KPLIB_fnc_removeTurretWeapons
}] call CBA_fnc_addEventHandler;