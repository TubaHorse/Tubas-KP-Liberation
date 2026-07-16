/*
    File: fn_artilleryFobTargetingPFH.sqf
    Author: PiG13BR - https://github.com/PiG13BR
    Date: 23/11/2024 
    Last Update: 16/07/2026
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Artillery target fobs CBA PFH. Tries to target a FOB in each execution.

    Parameter(s):
        _delay - amount of time (in seconds) between executions [NUMBER, defaults to 600]

    Returns:
        -
*/

params[["_delay", 600, [0]]];

[{
    params["_args", "_handler"];

    // No enemy arty available in the pool
    if (KPLIB_o_artilleryUnits isEqualTo []) exitWith {
        [_handler] call CBA_fnc_removePerFrameHandler; // Remove PFH. Call it off.
    };

    // Enemy arty available but no fobs found, try again
    if (KPLIB_player_fobs isEqualTo []) exitWith {
        [_handler] call CBA_fnc_removePerFrameHandler;
        [] call KPLIB_fnc_artilleryFobTargeting; // Run it again to gain a random sleep time
    };

    // Check if there are FOBs with players on it
    private _possibleTargetFobs = [];
    
    private _playerCount = ceil(([] call KPLIB_fnc_getPlayerCount)/2);
    
    // Player count too low
    if (_playerCount < 3) exitWith {
        [_handler] call CBA_fnc_removePerFrameHandler;
        [] call KPLIB_fnc_artilleryFobTargeting; // Run it again to gain a random sleep time
    };
    _possibleTargetFobs = KPLIB_player_fobs select {
       
        count ([_x, KPLIB_range_fob] call KPLIB_fnc_getNearbyPlayers) > _playerCount
    };

    // No fobs with players on it
    if (count _possibleTargetFobs == 0) exitWith {
        [_handler] call CBA_fnc_removePerFrameHandler;
        [] call KPLIB_fnc_artilleryFobTargeting; // Run it again to gain a random sleep time
    };

    // ---------------------------------------------------------- GET A FOBS IN RANGE
    // Check all artillery available in the pool to see if it has range at least for one FOB. The players can move the FOB out of the artillery range.
    private _poolHasRange = false;
    private _artyPoolRangeCheck = [];

    private _fobsAtRange = [];
    {
        private _arty = _x;
        _fobsAtRange = _possibleTargetFobs select {(_x vectorAdd [200,200,0]) inRangeOfArtillery [[_arty], (KPLIB_artyHashMap_ammo get "KPLIB_arty_HE_round")]};
        if (count _fobsAtRange > 0) then {
            _artyPoolRangeCheck pushBack _x; // The artillery has range
        };
    }forEach KPLIB_o_artilleryUnits;

    if (count _artyPoolRangeCheck == count KPLIB_o_artilleryUnits) then {
        _poolHasRange = true;
    };

    // Artillery pool has range to at least one FOB
    if (_poolHasRange) then {

        // Recalculate the chance using combat readiness and agressivity from mission params
        _fireAtFOBChance = 15; // Reset to the base value
        if (KPLIB_enemyReadiness >= (50 - (5 * KPLIB_param_aggressivity))) then {_fireAtFOBChance = _fireAtFOBChance + 10};	// + 10
        if (KPLIB_enemyReadiness >= (65 - (5 * KPLIB_param_aggressivity))) then {_fireAtFOBChance = _fireAtFOBChance + 10}; // + 10 + 10
        if (KPLIB_enemyReadiness >= (85 - (5 * KPLIB_param_aggressivity))) then {_fireAtFOBChance = _fireAtFOBChance + 10};	// + 10 + 10 + 10
        if (KPLIB_enemyReadiness >= (95 - (5 * KPLIB_param_aggressivity))) then {_fireAtFOBChance = _fireAtFOBChance + 10}; // + 10 + 10 + 10 + 10

        if (_fireAtFOBChance > 100) then {_fireAtFOBChance = 100};

        if ((random 100) <= _fireAtFOBChance) then {

            // Returns a random fob position
            private _targetFob = selectRandom _fobsAtRange; 
            
            switch (KPLIB_param_spotterArtyType) do {
                case 1 : {
                    private _called = [_targetFob] call KPLIB_fnc_artilleryCreateDrone;
                    if (_called) then {[_handler] call CBA_fnc_removePerFrameHandler;};
                    [] call KPLIB_fnc_artilleryFobTargeting;
                };
                case 2 :{
                    private _called = [_targetFob] call KPLIB_fnc_artilleryCreateSpotterHeli;
                    if (_called) then {[_handler] call CBA_fnc_removePerFrameHandler;};
                    [] call KPLIB_fnc_artilleryFobTargeting;
                };
                default {
                    [_targetFob] call KPLIB_fnc_artilleryFobFiring;
                    [_handler] call CBA_fnc_removePerFrameHandler;
                    [] call KPLIB_fnc_artilleryFobTargeting;
                }
            } 
        }
    }
}, _delay, []] call CBA_fnc_addPerFrameHandler;