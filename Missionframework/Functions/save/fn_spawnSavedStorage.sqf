/*
    File: fn_spawnSavedStorage.sqf
    Author: KP Liberation Dev Team - https://github.com/KillahPotatoes, PiG13BR (https://github.com/PiG13BR)
    Date: 29/07/2026
    Last Update: 29/07/2026
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Spawn saved storages from the loadgame and fill their content

    Parameter(s):
        _class - object's class [STRING]
        _pos - object's position [POSITION]
        _vecDir - object's vectorDir [ARRAY]
        _vecUp - object's vectorUp [ARRAY]
        _supply - amount of supply [NUMBER, defaults to 0]
        _ammo - amount of ammo [NUMBER, defaults to 0]
        _fuel - amount of fuel [NUMBER, defaults to 0]

    Returns:
        Storage spawned [OBJECT]
*/

params [
    "_class", 
    "_pos", 
    "_vecDir", 
    "_vecUp", 
    ["_supply", 0], 
    ["_ammo", 0], 
    ["_fuel", 0]
];

// Compatibility check for the new resource model.
switch (toLowerANSI _class) do {
    case (toLowerANSI "ContainmentArea_02_sand_F") : {
        _class = "Land_Cargo20_brick_red_F";
    };
    case (toLowerANSI "ContainmentArea_01_sand_F") : {
        _class = "Land_Cargo40_brick_red_F"
    } 
};

private _object = objNull;

// Only spawn, if the classname is still in the presets
if ((toLowerANSI _class) in KPLIB_classnamesToSave) then {

    // Create object without damage handling and simulation
    private _posATL = +_pos;
    _posATL set [2, 1];
    _object = createVehicle [_class, _posATL, [], 0, "CAN_COLLIDE"];
    _object allowdamage false;
    _object enableSimulation false;

    // Reposition spawned object
    _object setPosATL _posATL;
    _object setVectorDirAndUp [_vecDir, _vecUp];

    // Re-enable physics on spawned object
    _object setdamage 0;
    _object enableSimulation true;
    _object allowdamage true;

    // Mark it as FOB storage
    _object setVariable ["KPLIB_fobStorage", true, true];

    // Add actions to storage
    [_object] call KPLIB_fnc_addObjectInit;

    // Fill storage with saved resources
    [floor _supply, floor _ammo, floor _fuel, _object] call KPLIB_fnc_fillStorage;
};

_object