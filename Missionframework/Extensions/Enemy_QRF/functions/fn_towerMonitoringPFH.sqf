/*
    Description:
        Enemy towers scans for blufor forces inside their radius of effect each 5 minutes.
        Calls for QRF if the conditions are met.
        The QRF has a cooldown per tower
*/

["TOWER MONITORING STARTED", "QRF"] call KPLIB_fnc_log;

// Create a list of towers that called QRF
if (isNil "KPLIB_towers_QRF") then {KPLIB_towers_QRF = []};
[{
    params["_args", "_handler"];

    {
        private _towerSector = _x;


        if ((KPLIB_param_difficulty < 1) && KPLIB_enemyReadiness < 25) then {continue}; // Skip on low enemy readiness and lower difficulty 
        if (_towerSector in KPLIB_towers_QRF) then {continue}; // Skip on cooldown

        // Check for blufor units inside tower range
        private _towerPos = getMarkerPos _towerSector;

        private _bluforInArea = [_towerPos, KPLIB_range_radioTowerScan, KPLIB_side_player] call KPLIB_fnc_getNearbyEntities;

        // Get valid units (NOT nearby to any sector and NOT in air vehicles)
        _bluforInArea = _bluforInArea select {
            (([300, getPosATL _x] call KPLIB_fnc_getNearestSector) == "") 
            && {!((vehicle _x) isKindOf "Air")} 
            && {((getPosATL _x) # 2) < 15}
            && {([(getPosATL _x), 200, KPLIB_side_player] call KPLIB_fnc_getUnitsCount) > 1}
        }; 

        // Low blufor count >> Skip
        if (count _bluforInArea < 3) then {continue};

        // Give units in area some heat if there are enemies inside the tower's radius
        {
            private _unit = _x;
            {
                [_x, [_unit, 1]] remoteExec ["reveal"];
            }forEach ([_towerPos, KPLIB_range_radioTowerScan, KPLIB_side_enemy] call KPLIB_fnc_getNearbyEntities);
        }forEach _bluforInArea;

        //private _qrfPos = getPosATL (selectRandom _bluforInArea);
        private _reference = [_bluforInArea, _towerPos] call BIS_fnc_nearestPosition;
        private _qrfPos = getPosATL _reference;
        if (surfaceIsWater _qrfPos) then {continue}; // Skip on position on water
        
        // Find all sectors in range
        private _sectorsInRange = ((KPLIB_sectors_all - [_towerSector]) - KPLIB_sectors_player) select {((markerPos _x) distance2D _towerPos) < KPLIB_range_radioTowerScan};

        if (count _sectorsInRange < 1) then {continue}; // No sectors in range >> Skip
        
        // Find all military bases within tower range
        private _militaryBases = (KPLIB_sectors_military arrayIntersect _sectorsInRange);

        if (count _militaryBases < 1) then {continue}; // No military bases in range >> Skip iteration

        // Find active bases
        private _nearbyActiveBases = _militaryBases arrayIntersect KPLIB_sectors_active;

        // Check for a valid INACTIVE military base
        private _nearbyBasesNotActivated = _militaryBases - KPLIB_sectors_active;

        /*
            Chance of QRF:
                - Blufor count in area (+ impact)
                - Enemy Readiness (+++ impact)
                - Military bases in area (++ impact)
        */

        private _chance = 10; // Start chance

        // Size of blufor forces
        private _vehicles = _bluforInArea select {_x isKindOf "LandVehicle"};
        private _bluforSize = (count _bluforInArea) + (5 * count _vehicles);

        if (_bluforSize >= 5) then {
            _chance = _chance + (_bluforSize * 2);
        };
        if (KPLIB_enemyReadiness >= (50 - (5 * KPLIB_param_difficulty))) then {
            _chance = _chance + (KPLIB_enemyReadiness/2);
        };
        if (count _militaryBases > 0) then {
            _chance = _chance + ((count _militaryBases) * 4);
        };

        // Call QRF
        if ((random 100 <= _chance)) then {

            private _responseSector = "";
            // Get nearest military base
            if (count _nearbyActiveBases > 0) then {
                // Military base active
                _responseSector = [KPLIB_range_radioTowerScan, _qrfPos, _nearbyActiveBases, true] call KPLIB_fnc_getNearestSector;
                [_responseSector, _qrfPos, _bluforInArea]  execVM "Extensions\Enemy_QRF\functions\fn_sendQRFPatrol.sqf";
            } else {
                // Military base not active
                _responseSector = [KPLIB_range_radioTowerScan, _qrfPos, _nearbyBasesNotActivated, true] call KPLIB_fnc_getNearestSector;
                [_qrfPos, _responseSector, _bluforInArea]  execVM "Extensions\Enemy_QRF\functions\fn_spawnQRF.sqf";
            };

            // Fail-safe
            if (_responseSector isEqualTo "") then {continue};

            // Cooldown
            KPLIB_towers_QRF pushBack _towerSector;
            [format["QRF called for %1 area from %2", markerText _towerSector, markerText _responseSector], "QRF"] call KPLIB_fnc_log;
            [{
                KPLIB_towers_QRF deleteAt (KPLIB_towers_QRF find _this)
            }, _towerSector, 1800] call CBA_fnc_waitAndExecute;
        };
    }forEach KPLIB_sectors_tower;
}, 120, []] call CBA_fnc_addPerFrameHandler;