/*
    File: fn_recalculateResources.sqf
    Author: KP Liberation Dev Team - https://github.com/KillahPotatoes, PiG13BR (https://github.com/PiG13BR)
    Date: 10/09/2025
    Last update: 13/06/2026
    License: MIT License - http://www.opensource.org/licenses/MIT
    
    Description:
        Update resources (supplies, air slots, infantry cap)

    Parameter(s):
        -
    
    Returns:
        -
*/

private _local_base_resource = [];
private _local_supplies_global = 0;
private _local_ammo_global = 0;
private _local_fuel_global = 0;
private _local_heli_slots = 0;
private _local_plane_slots = 0;
private _local_infantry_cap = 50 * KPLIB_param_resourcesMulti;
private _range = KPLIB_range_fob;
private _airport_buildings = [];

{
    private _airportMk = _x;
    if !(_airportMk in KPLIB_sectors_player) then {continue};

    private _airportPos = markerPos _airportMk;
    private _airportArea = markerSize _airportMk;

    _airport_buildings = (_airportPos nearObjects ((_airportArea # 0) + (_airportArea # 1))) select {_x inArea _airportMk};

    private _heliSlots = {(KPLIB_type_heliPads find (typeOf _x) >= 0)} count _airport_buildings;
    private _planeSlots = {(KPLIB_type_hangars find (typeOf _x) >= 0)} count _airport_buildings;

    _local_heli_slots = _local_heli_slots + _heliSlots;
    _local_plane_slots = _local_plane_slots + _planeSlots;

} forEach KPLIB_sectors_airport;

{
    private _basePos = _x;
    if (_x in KPLIB_player_outposts) then {_range = KPLIB_range_outpost} else {_range = KPLIB_range_fob};
    private _fob_buildings = _basePos nearobjects _range;

    // Fob in airport area. Collect information about the airport area.
    private _inAirport = false;
    {
        private _airportArea = _x;
        if (_basePos inArea _x) exitWith {
            _range = ((markerSize _x)#0 + (markerSize _x)#1);
            _fob_buildings = _basePos nearobjects _range;
            _fob_buildings = _fob_buildings select {_x inArea _airportArea};
            _inAirport = true;
        };
    }forEach KPLIB_sectors_airport;
    
    private _storage_areas = _fob_buildings select {_x getVariable ["KPLIB_fobStorage", false] && {((getPosATL _x) # 2) < 1}};
    private _heliSlots = {KPLIB_type_heliPads find (typeOf _x) >= 0 && !(_x in _airport_buildings)} count _fob_buildings;
    private _planeSlots = {KPLIB_type_hangars find (typeOf _x) >= 0 && !(_x in _airport_buildings)} count _fob_buildings;
    private _hasAirBuilding = {(typeOf _x) == KPLIB_b_airControl;} count _fob_buildings;
    if (_hasAirBuilding > 0) then {_hasAirBuilding = true;} else {_hasAirBuilding = false;};
    private _hasRecBuilding = {(typeOf _x) == KPLIB_b_logiStation;} count _fob_buildings;
    if (_hasRecBuilding > 0) then {_hasRecBuilding = true;} else {_hasRecBuilding = false;};
    private _hasMedBuilding = {(typeOf _x) in KPLIB_medical_facilities;} count _fob_buildings;
    if (_hasMedBuilding > 0) then {_hasMedBuilding = true;} else {_hasMedBuilding = false;};
    private _hasBarracks = {(typeOf _x) in KPLIB_type_barracks;} count _fob_buildings;
    if (_hasBarracks > 0) then {_hasBarracks = true;} else {_hasBarracks = false;};

    private _supplyValue = 0;
    private _ammoValue = 0;
    private _fuelValue = 0;

    {
        private _resources = [_x] call KPLIB_fnc_getStorageValues;
        _resources params ["_supply", "_ammo", "_fuel"];
        _supplyValue = _supplyValue + _supply;
        _ammoValue = _ammoValue + _ammo;
        _fuelValue = _fuelValue + _fuel;
    } forEach _storage_areas;

    _local_base_resource pushBack [_x, _supplyValue, _ammoValue, _fuelValue, _hasAirBuilding, _hasRecBuilding, _hasMedBuilding, _hasBarracks, _inAirport];
    _local_supplies_global = _local_supplies_global + _supplyValue;
    _local_ammo_global = _local_ammo_global + _ammoValue;
    _local_fuel_global = _local_fuel_global + _fuelValue;
    _local_heli_slots = _local_heli_slots + _heliSlots;
    _local_plane_slots = _local_plane_slots + _planeSlots;
} forEach (KPLIB_player_fobs + KPLIB_player_outposts);

{
    if ( _x in KPLIB_sectors_city ) then {
        _local_infantry_cap = _local_infantry_cap + (10 * KPLIB_param_resourcesMulti);
    };
} foreach KPLIB_sectors_player;

KPLIB_base_resources = _local_base_resource;
KPLIB_supplies_global = _local_supplies_global;
KPLIB_ammo_global = _local_ammo_global;
KPLIB_fuel_global = _local_fuel_global;
KPLIB_heli_slots = _local_heli_slots;
KPLIB_plane_slots = _local_plane_slots;
infantry_cap = _local_infantry_cap;