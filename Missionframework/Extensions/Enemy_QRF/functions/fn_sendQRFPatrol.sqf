/*
    Make a sector patrol go to a position 
*/

params["_sector", "_qrfPos", "_bluforUnits"];

if (_sector isEqualTo "") exitWith {false};
if (_qrfPos isEqualTo []) exitWith {false};
if (_bluforUnits isEqualTo []) then {
    // Find blufor units in the qrfPos

};

// Count type of units
private _bluforInf = _bluforUnits select {_x isKindOf "CAManBase"};
private _vehicles = _bluforUnits select {_x isKindOf "LandVehicle"};

// Get all entities from the sector
private _allGroups = [];
private _entities = [(markerPos _sector), KPLIB_range_sectorCapture, KPLIB_side_enemy] call KPLIB_fnc_getNearbyEntities;

// Get all groups
private _grp = grpNull;
private _infantryGrps = [];
private _vehiclesGrps = [];
{
    if (_x isKindOf "CAManBase") then {
        _grp = group _x;
        _infantryGrps pushBackUnique _grp;
    } else {
        _grp = group(effectiveCommander _x);
        _vehiclesGrps pushBackUnique _grp;
    };
    
    _allGroups pushBackUnique _grp; 
}forEach _entities;

/*
    Send patrols according to what the blufor forces have in area
*/


private _vehPatrols = [];
private _infPatrols = [];

// Count type of units
private _bluforInf = _bluforUnits select {_x isKindOf "CAManBase"};
private _vehicles = _bluforUnits select {_x isKindOf "LandVehicle"};

if (count _vehicles > 0) then {

    // Get vehicle pool
    private _vehiclePool = [KPLIB_o_battleGrpVehicles, KPLIB_o_battleGrpVehiclesLight] select (KPLIB_enemyReadiness < 50);

    if (("Tank" countType _bluforUnits) > 0) then {
        _vehPatrols = _allGroups select {
            _x getVariable ["KPLIB_enemy_vehPatrol", false] 
            && {!((typeOf (vehicle (leader _x))) in KPLIB_o_tankVehicles)}
        };
    } else {
        // Count types
        private _apcCount = ("TrackedAPC" countType _vehicles);
        _apcCount = _apcCount + ("Wheeled_APC_F" countType _vehicles);
        private _carCount = ("Car" countType _vehicles);
        private _typeSelection = [{(((vehicle (leader _x)) isKindOf "TrackedAPC") || ((vehicle (leader _x)) isKindOf "Wheeled_APC_F"))}, {((vehicle (leader _x)) isKindOf "Car")}] selectRandomWeighted [_apcCount, _carCount];
        _vehPatrols = _allGroups select {
            _x getVariable ["KPLIB_enemy_vehPatrol", false] && _typeSelection; 
        };
    };

    if (count _vehPatrols > 0) then {
        private _qrfGrp = [_vehPatrols, _qrfPos] call BIS_fnc_nearestPosition;
        [_qrfGrp, _qrfPos] call KPLIB_fnc_battlegroupAttack;
        [format["QRF group (%3) of sector %1 is moving to position %2", markerText _sector, _qrfPos, _qrfGrp], "QRF"] call KPLIB_fnc_log;
    };
};

if (count _bluforInf > 0) then {
    // Send infantry
    _infPatrols = _allGroups select {
        _x getVariable ["KPLIB_enemy_grpPatrol", false]; 
    };

    if (count _infPatrols > 0) then {
        private _qrfGrp = [_infPatrols, _qrfPos] call BIS_fnc_nearestPosition;
        [_qrfGrp, _qrfPos] call KPLIB_fnc_battlegroupAttack;
        [format["QRF group (%3) of sector %1 is moving to position %2", markerText _sector, _qrfPos, _qrfGrp], "QRF"] call KPLIB_fnc_log;
    } else {
        // Spawn it
        if ((markerPos _sector) distance2D _qrfPos >= 1000) then {
            ["", _qrfPos, _sector, false] call KPLIB_fnc_battlegroupTransportHeli
        } else {
            [selectRandom (KPLIB_o_troopTransports select {_x isKindOf "LandVehicle"}), _qrfPos, _sector, false] call KPLIB_fnc_battlegroupLandVehicle
        };
    }
};

if ((count _vehPatrols < 1) && (count _infPatrols < 1)) then {
    [format["Failed to find QRF groups in sector %1. Spawning QRF instead.", markerText _sector], "QRF"] call KPLIB_fnc_log;
    [_qrfPos, _sector, _vehicles] call KPLIB_fnc_spawnQRF;
};

true