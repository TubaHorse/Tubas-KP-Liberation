/*
    Spawning of start vehicles at placeholder objects

    This file spawns the so called "start vehicles" like boats
    and little birds at the starting base/carrier.

    The array at the end can be used to add start vehicles
    by using the variable name of the grasscutter placeholder
    and the variable defined in the preset or a direct classname.

    Format: [<variable name of placeholder without number>, <variable from preset or a classname>]

    E.g. the variables of the grasscutter placeholder objects for the
    little birds are named "littlebird_0", "littlebird_1", etc.
    while the variable from the preset is KPLIB_b_addHeli.
    This leads to the entry below.

    You can also remove unwanted start vehicles by deleting the corresponding line
    in the array below. Just keep the correct comma separation in mind.
    Refer to: https://github.com/KillahPotatoes/KP-Liberation/wiki/EN_ImportantHints#commas-inside-an-array
*/

waitUntil {!isNil "KPLIB_saveLoaded"};
waitUntil {KPLIB_saveLoaded};

private _placeholder = objNull;
private _spawnPos = [];
private _veh = objNull;
{
    _x params ["_id", "_classname"];

    for [{_i = 0}, {!isNil ([_id, _i] joinString "")}, {_i = _i + 1}] do {
        _placeholder = missionNamespace getVariable ([_id, _i] joinString "");
        _spawnPos = getPosATL _placeholder;
        _veh = _classname createVehicle [_spawnPos select 0, _spawnPos select 1, (_spawnPos select 2) + 0.2];
        _veh enableSimulationGlobal false;
        _veh allowDamage false;
        _veh setDir (getDir _placeholder);
        _veh setPosATL _spawnPos;
        [_veh] call KPLIB_fnc_clearCargo;
        sleep 0.5;
        _veh enableSimulationGlobal true;
        _veh setDamage 0;
        _veh allowDamage true;
        _veh setVariable ["KPLIB_preplaced", true, true];
        [_veh] call KPLIB_fnc_addObjectInit;
        _veh setDamage 0;

        // Apply custom configuration for extra heli (Cougar)
        if (_classname == KPLIB_b_extraHeli) then {
            [
                _veh,
                ["MARINE",1], 
                ["hide_ir_large",1,"hide_radar",0,"hide_searchlamp",1,"hide_winch",0,"hide_float_bags",0,"hide_antenna",0,"hide_refuelprobe",0,"hide_sensor",0,"hide_ir_small",0,"hide_fueltanks",1,"hide_engfilters_01",1,"hide_engfilters_02",0,"hide_rotordome",0,"hide_hook",0,"hide_chin_plate",0,"hide_ceiling_blanket",0,"hide_cm_dispenser",0,"door_copilot",0,"door_pilot",0,"door_cargo_left",0,"door_cargo_right",0]
            ] call BIS_fnc_initVehicle;
        };
    };
} forEach [
    ["littlebird_", KPLIB_b_addHeli],
    ["cougar_", KPLIB_b_extraHeli],
    //["boat_", KPLIB_b_addBoat], Handled below instead
    ["bigboat_", KPLIB_b_bigBoat],
    ["trucc_", KPLIB_b_addMRAP]
];




// Spawn boats at boat ramp holders and attach them to the boat ramps
for "_i" from 0 to 1 do {
    // Initialize spawned boat variable
    call compile format ["boatr_%1 = objNull", _i];
    
    // Get the boat ramp holder position marker
    _placeholder = call compile format ["boat_%1", _i];
    
    // Get position with slight Z offset for spawning
    _spawnPos = getposATL _placeholder;
    _spawnPos set [2, (_spawnPos select 2) + 0.2];
    
    // Create boat at placeholder position
    _spawnedBoat = KPLIB_b_addBoat createVehicle _spawnPos;
    _spawnedBoat setDir (getDir _placeholder);
    _spawnedBoat enableSimulationGlobal false;
    _spawnedBoat allowdamage false;
    _spawnedBoat setPosATL (getposATL _placeholder);
    _spawnedBoat setDamage 0;
    
    // Wait for boat to stabilize while invincible
    sleep 1;
    
    // Make boat vulnerable and active
    _spawnedBoat enableSimulationGlobal true;
    _spawnedBoat setDamage 0;
    _spawnedBoat allowdamage true;
    _spawnedBoat setVariable ["KPLIB_preplaced", true, true];
    
    [_spawnedBoat] call KPLIB_fnc_addObjectInit;
    [_spawnedBoat] call KPLIB_fnc_clearCargo;
    
    // Assign to global variable and publish
    call compile format ["boatr_%1 = _spawnedBoat", _i];
    publicVariable format ["boatr_%1", _i];
    
    sleep 1;
    
    // Attach boat to its ramp holder
    _boatRamp = call compile format ["br%1", _i];
    _boatRamp setVehicleCargo _spawnedBoat;
};

/* boatr_0 = objNull;
boatr_1 = objNull;
boatr_0 = KPLIB_b_addBoat createVehicle [(getposATL boat_0) select 0, (getposATL boat_0) select 1, ((getposATL boat_0) select 2) + 0.2];
boatr_0 setDir (getDir boat_0);
boatr_0 enableSimulationGlobal false;
boatr_0 allowdamage false;
boatr_0 setPosATL (getposATL boat_0);
boatr_0 setDamage 0;
sleep 1;
boatr_0 enableSimulationGlobal true;
boatr_0 setDamage 0;
boatr_0 allowdamage true;
boatr_0 setVariable ["KPLIB_preplaced", true, true];
[boatr_0] call KPLIB_fnc_addObjectInit;
[boatr_0] call KPLIB_fnc_clearCargo;
publicVariable "boatr_0";
boatr_1 = KPLIB_b_addBoat createVehicle [(getposATL boat_1) select 0, (getposATL boat_1) select 1, ((getposATL boat_1) select 2) + 0.2];
boatr_1 setDir (getDir boat_1);
boatr_1 enableSimulationGlobal false;
boatr_1 allowdamage false;
boatr_1 setPosATL (getposATL boat_1);
boatr_1 setDamage 0;
sleep 1;
boatr_1 enableSimulationGlobal true;
boatr_1 setDamage 0;
boatr_1 allowdamage true;
boatr_1 setVariable ["KPLIB_preplaced", true, true];
[boatr_1] call KPLIB_fnc_addObjectInit;
[boatr_1] call KPLIB_fnc_clearCargo;
publicVariable "boatr_1";
sleep 1; 
br0 setVehicleCargo boatr_0;
sleep 1;
br1 setVehicleCargo boatr_1; */