/*
    File: fn_restoreResources.sqf
    Author: KP Liberation Dev Team - https://github.com/KillahPotatoes, PiG13BR (https://github.com/PiG13BR)
    Date: 10/09/2025
    Last update: 31/07/2026

    Description:
        Return resources to storage areas when building is cancelled

    Parameter(s):
        _supplyPrice - Supplies value to return [NUMBER, defaults 0]
        _ammoPrice - Ammo value to return [NUMBER, defaults 0]
        _fuelPrice - Fuel value to return [NUMBER, defaults 0]
        _storages - Base storages [ARRAY, defaults []]
    
    Returns:
        -
*/
params [
    ["_priceSupplies", 0, [0]], 
    ["_priceAmmo", 0, [0]], 
    ["_priceFuel", 0, [0]], 
    ["_storages", [], [[]]]
];

if (!isServer) exitWith {};
if (_storageAreas isEqualTo []) exitWith {};

#define SUPPLY_INDEX 0
#define AMMO_INDEX 1
#define FUEL_INDEX 2

if ((_supplyPrice > 0) || (_ammoPrice > 0) || (_fuelPrice > 0)) then {
    {
        private _resources = [_x] call KPLIB_fnc_getStorageValues;
        _resources params ["_supply", "_ammo", "_fuel"];
        private _sum = _supply + _ammo + _fuel;
        private _amountSum = _sum;

        private _storageLimit = [_x] call KPLIB_fnc_getStorageLimit;

        if (_supplyPrice > 0) then {
            private _amount = _supplyPrice;
            _amountSum = _amountSum + _amount;
            
            if (_amountSum > _storageLimit) then {
                private _adjust = (_sum + _amount) - _storageLimit;
                _amount = _amount - _adjust; // Only the necessary amount to fill storage
                if (_adjust < 0) then {_amount = 0;};
            };
            if (_amount < 0) exitWith {};
            
            _resources set [SUPPLY_INDEX, _supply + _amount];

            _supplyPrice = _supplyPrice - _amount
        };

        if (_ammoPrice > 0) then {
            private _amount = _ammoPrice;
            _amountSum = _amountSum + _amount;
            
            if (_amountSum > _storageLimit) then {
                private _adjust = (_sum + _amount) - _storageLimit;
                _amount = _amount - _adjust; // Only the necessary amount to fill storage
                if (_adjust < 0) then {_amount = 0;};
            };
            _resources set [AMMO_INDEX, _ammo + _amount];

            _ammoPrice = _ammoPrice - _amount
        };

        if (_fuelPrice > 0) then {
            private _amount = _fuelPrice;
            _amountSum = _amountSum + _amount;
            
            if (_amountSum > _storageLimit) then {
                private _adjust = (_sum + _amount) - _storageLimit;
                _amount = _amount - _adjust; // Only the necessary amount to fill storage
                if (_adjust < 0) then {_amount = 0;};
            };

            _resources set [FUEL_INDEX, _fuel + _amount];

            _fuelPrice = _fuelPrice - _amount
        };

        _x setVariable ["KPLIB_storageResources", _resources, true];
    } forEach _storages;

    ["KPLIB_recalculateResources", []] call CBA_fnc_serverEvent;

    // Spawn crates if there are resources left to restore
    private _storage = _storages # ((count _storages) - 1);
    while {(_supplyPrice > 0) || (_ammoPrice > 0) || (_fuelPrice > 0)} do {
        if (_supplyPrice > 0) then {
            private _price = _supplyPrice min 100;
            [KPLIB_b_crateSupply, _price, getPosATL _storage] call KPLIB_fnc_createCrate;
            _supplyPrice = _supplyPrice - _price;
        };

        if (_ammoPrice > 0) then {
            private _price = _ammoPrice min 100;
            [KPLIB_b_crateAmmo, _price, getPosATL _storage] call KPLIB_fnc_createCrate;
            _ammoPrice = _ammoPrice - _price;
        };

        if (_fuelPrice > 0) then {
            private _price = _fuelPrice min 100;
            [KPLIB_b_crateFuel, _price, getPosATL _storage] call KPLIB_fnc_createCrate;
            _fuelPrice = _fuelPrice - _price;
        };
    };
};