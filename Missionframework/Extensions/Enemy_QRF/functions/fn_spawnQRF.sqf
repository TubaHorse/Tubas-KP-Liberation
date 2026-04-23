params["_qrfPos", "_sector", "_bluforUnits"];

if (_qrfPos isEqualTo []) exitWith {false};
if (_sector isEqualTo "") exitWith {false};
if (_bluforUnits isEqualTo []) then {
    // Find blufor units in the qrfPos

};

// Count type of units
private _bluforInf = _bluforUnits select {_x isKindOf "CAManBase"};
private _vehicles = _bluforUnits select {_x isKindOf "LandVehicle"};

if (count _vehicles > 0) exitWith {

    // Get vehicle pool
    private _vehiclePool = [KPLIB_o_battleGrpVehicles, KPLIB_o_battleGrpVehiclesLight] select (KPLIB_enemyReadiness < 50);

    if (("Tank" countType _bluforUnits) > 0) then {
        // Tanks receive a special treatment
        if ((markerPos _sector) distance2D _qrfPos >= 1200) then {
            // Attack heli
            ["", _qrfPos, _sector, false] call KPLIB_fnc_battlegroupAttackHeli;
        } else {
            // Tank
            [selectRandom KPLIB_o_tankVehicles, _qrfPos, _sector, false] call KPLIB_fnc_battlegroupLandVehicle;
        };
    } else {
        // Count types
        private _apcCount = ("TrackedAPC" countType _vehicles);
        _apcCount = _apcCount + ("Wheeled_APC_F" countType _vehicles);
        private _carCount = ("Car" countType _vehicles);
        private _typeSelection = [{((_x isKindOf "TrackedAPC") || (_x isKindOf "Wheeled_APC_F"))}, {(_x isKindOf "Car")}] selectRandomWeighted [_apcCount, _carCount];
        [selectRandom (_vehiclePool select _typeSelection), _qrfPos, _sector, false] call KPLIB_fnc_battlegroupLandVehicle;
    };
};

if (count _bluforInf > 0) exitWith {
    // Send infantry
    if ((markerPos _sector) distance2D _qrfPos >= 1000) then {
        ["", _qrfPos, _sector, false] call KPLIB_fnc_battlegroupTransportHeli
    } else {
        [selectRandom (KPLIB_o_troopTransports select {_x isKindOf "LandVehicle"}), _qrfPos, _sector, false] call KPLIB_fnc_battlegroupLandVehicle
    };
};