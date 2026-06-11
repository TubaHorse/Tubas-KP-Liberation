/*
    File: fn_registerSectorObject.sqf
    Author: PiG13BR - https://github.com/PiG13BR
    Date: 20/12/2024
    Last Update: 10/06/2026
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Register object near a sector into a hashmap and deletes them from the map, to later spawn it again when the sector is activated
        Can be any object. Static weapons will spawn only in configurated objects.
        Put this code in the object's init to register as a sector object:
            [this] spawn KPLIB_fnc_registerSectorObject
		Only object close enough to sectors will be registered (KPLIB_sectorObject_radius). If the object isn't near any sectors, it will not be registered and it will be deleted from the map.
        Objects classnames under KPLIB_staticsConfigs.sqf have an option to disable static weapons from spawning it
            [this, false] spawn KPLIB_fnc_registerSectorObject
        The registered object can be deleted or not in the beginning of the mission. In this case a different variable will manage those objects.
            This is crucial to be able to spawn static weapon in those buildings once the sectors activates
        For default, map objects classnames that matches those in KPLIB_staticsConfigs.sqf will NOT spawn any static weapon.
        To enable MAP objects classnames that are under KPLIB_staticsConfigs.sqf to spawn static weapons, you can do it indirectly by placing a logic near of the object and in its init field:
            _objects = nearestObjects [getPos this, ["classname_of_object"], 75, false];
            {[_x] spawn KPLIB_fnc_registerSectorObject}forEach _objects;

    Parameter(s):
        _object - object that will be registered [OBJECT, defaults to objNull]
        _staticSpawn - Spawning of static weapons is enabled for this object? (provided if the object classname is refered in KPLIB_staticsConfigs.sqf) [BOOL, defaults to true]

    Returns:
        -
*/

if (!isServer) exitWith {};

params [
    ["_object", objNull, [ObjNull]],
    ["_staticSpawn", true, [false]], // Only works for buildings or structures under KPLIB_staticsConfigs
    ["_initDelete", true, [false]] // This will NOT work for map objects if it's TRUE
];

if (!canSuspend) exitWith {_this spawn KPLIB_fnc_registerSectorObject};

waitUntil {!isNil "KPLIB_sectors_all" && !isNil "KPLIB_sectorObject_radius"};

// Find the nearest sector
private _sector = [KPLIB_sectorObject_radius, getPosATL _object, (KPLIB_sectors_all + KPLIB_fillers_all)] call KPLIB_fnc_getNearestSector;

if (_sector isEqualTo "") exitWith {
    [format ["%1 in position %2 is too far away from any sectors. Deleting the object.", (typeOf _object), (getPosATL _object)], "REGISTERING OBJECT FAILED"] call KPLIB_fnc_log; 
    deleteVehicle _object;
};

if (isNil "KPLIB_sectorObjects_hashMap") then {
    // Creates the hashmap
    KPLIB_sectorObjects_hashMap = createHashMap;
};

if (isNil "KPLIB_sectorMapObject_hashMap") then {
    // Creates the hashmap
    KPLIB_sectorMapObject_hashMap = createHashMap;
};

if (!_staticSpawn) then {
    if !(typeOf _object in KPLIB_staticConfigs_classes) exitWith {};
    // Placeholder solution for disabling garrison. The objects will stay on the map. 
    _initDelete = false; // ToDo: Find something to get reference of the spawned object to disable garrison. Array position doesn't work good.
    // Because a deleted object will give a <NULL-OBJECT> in the garrison array, save the position of the object instead to find a match later.
    private _objectPos = [round parseNumber (((getPosATL _object) # 0) toFixed 2), round parseNumber (((getPosATL _object) # 1) toFixed 2), round parseNumber (((getPosATL _object) # 2) toFixed 2)];

    if !(_sector in KPLIB_GarrisonsBlacklist_HashMap) then {
    // Create a new key with a value
        KPLIB_GarrisonsBlacklist_HashMap set [_sector, [_objectPos]];
    } else {
        // Update key values if key already exists
        private _mapValue = KPLIB_GarrisonsBlacklist_HashMap get _sector;
        private _mapNewValues = _mapValue + [_objectPos];
        KPLIB_GarrisonsBlacklist_HashMap set [_sector, _mapNewValues];
    };
};

if !(_initDelete) then {
    // This object will not be deleted from start (or it's a map object itself)
    // Check if the key (sector) is already in the hashmap
    if !(_sector in KPLIB_sectorMapObject_hashMap) then {
        // Create a new key with a value
        KPLIB_sectorMapObject_hashMap set [_sector, [_object]];
    } else {
        // Update key values if key already exists
        private _mapValue = KPLIB_sectorMapObject_hashMap get _sector;
        private _mapNewValues = _mapValue + [_object];
        KPLIB_sectorMapObject_hashMap set [_sector, _mapNewValues];
    };
} else {
    // Spawn object
    // Check if the key (sector) is already in the hashmap
    if !(_sector in KPLIB_sectorObjects_hashMap) then {
        // Create a new key with a value
        KPLIB_sectorObjects_hashMap set [_sector, [[typeOf _object, [getPosATL _object, getDir _object, vectorUp _object]]]];
    } else {
        // Update key values if key already exists
        private _mapValue = KPLIB_sectorObjects_hashMap get _sector;
        private _mapNewValues = _mapValue + [[typeOf _object, [getPosATL _object, getDir _object, vectorUp _object]]];
        KPLIB_sectorObjects_hashMap set [_sector, _mapNewValues];
    };
};

if (isNil "KPLIB_GarrisonsBlacklist_HashMap") then {
    // Creates the hashmap
    KPLIB_GarrisonsBlacklist_HashMap = createHashMap;
};

// Delete the object to spawn it later when the sector is activated
if (_initDelete) then {
    deleteVehicle _object;
};