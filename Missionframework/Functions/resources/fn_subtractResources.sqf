/*
    File: fn_subtractResources.sqf
    Author: KP Liberation Dev Team - https://github.com/KillahPotatoes, PiG13BR (https://github.com/PiG13BR)
    Date: 10/09/2025
    Last update: 31/07/2026

    Description:
        Remove resources to storage areas when building

    Parameter(s):
        _priceSupplies - Supplies value to return [NUMBER, defaults to 0]
        _priceAmmo - Ammo value to return [NUMBER, defaults to 0]
        _priceFuel - Fuel value to return [NUMBER, defaults to 0]
        _storageAreas - Base storages [ARRAY, defaults to []]
    
    Returns:
        -
*/
params [
    ["_priceSupplies", 0, [0]], 
    ["_priceAmmo", 0, [0]], 
    ["_priceFuel", 0, [0]], 
    ["_storageAreas", [], [[]]]
];

if (!isServer) exitWith {};
if (_storageAreas isEqualTo []) exitWith {};

#define SUPPLY_INDEX 0
#define AMMO_INDEX 1
#define FUEL_INDEX 2

if ((_priceSupplies > 0) || (_priceAmmo > 0) || (_priceFuel > 0)) then {

    stats_supplies_spent = stats_supplies_spent + _priceSupplies;
    stats_ammo_spent = stats_ammo_spent + _priceAmmo;
    stats_fuel_spent = stats_fuel_spent + _priceFuel;

    {
        private _resources = [_x] call KPLIB_fnc_getStorageValues;
        _resources params ["_supply", "_ammo", "_fuel"];

        if (_priceSupplies > 0 && (_supply > 0)) then {
            private _amount = _priceSupplies;
            private _dif = (_supply - _amount);
            _resources set [SUPPLY_INDEX, _dif max 0];
            if (_dif >= 0) then {
                _priceSupplies = _priceSupplies - _amount;
            } else {
                _priceSupplies = abs(_dif);
            };
        };

        if (_priceAmmo > 0 && (_ammo > 0)) then {
            private _amount = _priceAmmo;
            private _dif = (_ammo - _amount);
            _resources set [AMMO_INDEX, _dif max 0];
            if (_dif >= 0) then {
                _priceAmmo = _priceAmmo - _amount;
            } else {
                _priceAmmo = abs(_dif);
            };
        };

        if (_priceFuel > 0 && (_fuel > 0)) then {
            private _amount = _priceFuel;
            private _dif = (_fuel - _amount);
            _resources set [FUEL_INDEX, _dif max 0];
            if (_dif >= 0) then {
                _priceFuel = _priceFuel - _amount;
            } else {
                _priceFuel = abs(_dif);
            };
        };

        _x setVariable ["KPLIB_storageResources", _resources, true];

        if ((_priceSupplies == 0) && (_priceAmmo == 0) && (_priceFuel == 0)) exitWith {};
    } forEach _storageAreas;

    ["KPLIB_recalculateResources", []] call CBA_fnc_serverEvent;
};
