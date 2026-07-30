/*
    File: fn_spawnSavedFactoryStorage.sqf
    Author: KP Liberation Dev Team - https://github.com/KillahPotatoes, PiG13BR (https://github.com/PiG13BR)
    Date: 29/07/2026
    Last Update: 29/07/2026
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Spawn saved factory storages from the loadgame and fill their content

    Parameter(s):
        _sector - sector in which the storage is going to spawn [SECTOR]
        _storage - storage attributes (position, direction and vectorUp) [ARRAY of ARRAYS]

    Returns:
        Storage spawned [OBJECT]
*/

params["_sector", "_storage"];

private _object = objNull;

// Spawn storage, if sector has valid storage
if ((count _storage) == 3) then {
    _storage params ["_pos", "_dir", "_vecUp"];

    // Create object without damage handling and simulation
    _object = createVehicle [KPLIB_b_smallStorage, _pos, [], 0, "CAN_COLLIDE"];
    _object enableSimulationGlobal false;
    _object allowdamage false;

    // Reposition spawned object
    _object setdir _dir;
    _object setVectorUp _vecUp;
    _object setPosATL _pos;

    // Re-enable physics on spawned object
    _object setdamage 0;
    _object enableSimulation true;
    _object allowdamage true;

    // Mark it as sector storage
    _object setVariable ["KPLIB_factoryStorage", true, true];

    // Save sector marker for this storage object
    _object setVariable ["KPLIB_storageSector", _sector];

    // Save storage object for this sector
    KPLIB_sector_storage set [_sector, _object];
    publicVariable "KPLIB_sector_storage";

    [_object] call KPLIB_fnc_addObjectInit;

    // Fill storage
    [floor (_y # 8), floor (_y # 9), floor (_y # 10), _object] call KPLIB_fnc_fillStorage;
};

_object