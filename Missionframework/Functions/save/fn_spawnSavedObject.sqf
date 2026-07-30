/*
    File: fn_spawnSavedObject.sqf
    Author: KP Liberation Dev Team - https://github.com/KillahPotatoes, PiG13BR (https://github.com/PiG13BR)
    Date: 29/07/2026
    Last Update: 29/07/2026
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Spawn objects from the loadgame

    Parameter(s):
        _class - object's class [STRING]
        _pos - object's position [POSITION]
        _vecDir - object's vectorDir [ARRAY]
        _vecUp - object's vectorUp [ARRAY]
        _hasCrew - if object had crew [BOOL, defaults to false]
        _weaponsCargo - weapons on cargo [ARRAY, defaults to [[], []]]
        _magsCargo - magazines on cargo [ARRAY, defaults to [[], []]]
        _itemsCargo - items on cargo [ARRAY, defaults to [[], []]]
        _backpacksCargo - backpacks on cargo [ARRAY, defaults to [[], []]]
        _hitPoints - object's hitpoints damages [ARRAY, defaults to []]
        _fuel - object's fuel [ARRAY, defaults to 1]
        _ammo - object's ammo from magazineAllTurrets [ARRAY, defaults to []]
        _pylonsInfo - object's pylons [ARRAY, defaults to []]

    Returns:
        Object spawned [OBJECT]
*/

params [
    "_class", 
    "_pos", 
    "_vecDir", 
    "_vecUp", 
    ["_hasCrew", false], 
    ["_weaponsCargo", []], 
    ["_magsCargo", [[], []]], 
    ["_itemsCargo", [[], []]], 
    ["_backpacksCargo", [[],[]]], 
    ["_hitPoints", []], 
    ["_fuel", 1], 
    ["_ammo", []], 
    ["_pylonsInfo", []]
];

private _object = objNull;

// Only spawn, if the classname is still in the presets
if ((toLowerANSI _class) in KPLIB_classnamesToSave) then {
    // Create object without damage handling and simulation
    _object = createVehicle [_class, _pos, [], 0, "CAN_COLLIDE"];
    _object enableSimulation false;

    // Reposition spawned object
    _object setPosWorld _pos;
    _object setVectorDirAndUp [_vecDir, _vecUp];

    // Apply kill manager handling, if not excluded
    if !((toLower _class) in _noKillHandler) then {
        _object addMPEventHandler ["MPKilled", {
            params ["_unit", "_killer"];
            ["KPLIB_manageKills", [_unit, _killer]] call CBA_fnc_localEvent;
        }];
    };

    // Set enemy vehicle as captured
    if ((toLowerANSI _class) in KPLIB_o_allVeh_classes) then {
        _object setVariable ["KPLIB_captured", true, true];
    };

    // Set civilian vehicle as seized
    if (_class in KPLIB_c_vehicles) then {
        _object setVariable ["KPLIB_seized", true, true];
    };

    // Determine if cargo should be cleared
    [_object] call KPLIB_fnc_clearCargo;

    // Add blufor crew, if it had crew or is a UAV
    if ((unitIsUAV _object) || _hascrew) then {
        [
            {simulationEnabled _this}, 
            {
                private _crewGrp = [_this, KPLIB_side_player] call KPLIB_fnc_createCrew; 
                [_this, _crewGrp] call KPLIB_fnc_forceStaticCrew;
            }, 
            _object, 
            60, 
            {["Couldn't add crew. Simulation not enabled on the object","WARNING"] call KPLIB_fnc_log}
        ] call CBA_fnc_waitUntilAndExecute;
    };

    // Cargo
    if (_weaponsCargo isNotEqualTo []) then {
        {_object addWeaponWithAttachmentsCargoGlobal [_x, 1]}forEach _weaponsCargo;
    };
    if (_magsCargo isNotEqualTo [[],[]]) then {
        private _names = _magsCargo # 0;
        private _count = _magsCargo # 1;
        {_object addMagazineCargoGlobal [_x, _count # _forEachIndex]}forEach _names;
    };
    if (_itemsCargo isNotEqualTo [[],[]]) then {
        private _names = _itemsCargo # 0;
        private _count = _itemsCargo # 1;
        {_object addItemCargoGlobal [_x, _count # _forEachIndex]}forEach _names;
    };
    if (_backpacksCargo isNotEqualTo [[],[]]) then {
        private _names = _backpacksCargo # 0;
        private _count = _backpacksCargo # 1;
        {_object addBackpackCargoGlobal [_x, _count # _forEachIndex]}forEach _names;
    };
    
    // Hitpoints
    if (_hitPoints isNotEqualTo []) then {
        private _hitNames = (_hitPoints # 0);
        private _damages = (_hitPoints # 2);
        {
            _object setHitPointDamage [_x, _damages # _forEachIndex];
        }forEach _hitNames;
    };

    // Fuel
    [_object, _fuel] remoteExec ["setFuel"];

    // Ammo
    if (_ammo isNotEqualTo []) then {
        {
            _x params["_class", "_turret", "_count"];

            // Handle pylon magazines below
            if (getText(configFile >> "cfgMagazines" >> _class >> "pylonWeapon") != "") then {continue};

            _object removeMagazineTurret [_class, _turret];
            _object addMagazineTurret [_class, _turret, _count];
        }forEach _ammo;
    };

    if (_pylonsInfo isNotEqualTo []) then {
        {
            private _pylonIndex = _x # 0;
            private _turret = _x # 2;
            private _magazine = _x # 3;
            private _ammoCount = _x # 4;
            
            ["PAS_setPylonArmament", [_object, _pylonIndex, _magazine, _turret]] call CBA_fnc_globalEvent;
            [_object, [_pylonIndex, _ammoCount]] remoteExec ["setAmmoOnPylon"];
        }forEach _pylonsInfo;
    };

    // Process KP object init
    [_object] call KPLIB_fnc_addObjectInit;
};

_object