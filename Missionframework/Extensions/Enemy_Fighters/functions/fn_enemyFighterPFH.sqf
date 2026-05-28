/*
    File: fn_enemyFighterPFH.sqf
    Author: PiG13BR - (https://github.com/PiG13BR)
    Date: 04/02/2026
    Last update: 27/05/2026

    Description:
        Runs a CBA PFH to check some conditions to spawn enemy fighters
    
    Parameter(s)
        -

    Returns:
        -
*/

if (isNil "KPLIB_bluforAircrafts") then {KPLIB_bluforAircrafts = []; publicVariable "KPLIB_bluforAircrafts"};
if (isNil "KPLIB_enemy_jetInAir") then {KPLIB_enemy_jetInAir = []; publicVariable "KPLIB_enemy_jetInAir";};

[{
    params ["", "_handle"];

    // Find blufor air assets on air
    private _bluforAir = KPLIB_bluforAircrafts select {(count(crew _x) > 0) && !(_x getVariable ["KPLIB_fighterCalledUpon", false]) && {side(group(effectiveCommander _x)) == KPLIB_side_player} && {((getPos _x) # 2) > 200}};

    if (_bluforAir isEqualTo []) then {continue}; // Skip iteration

    // Count air assets (particullary airplanes)
    private _planeCount = "Plane" countType _bluforAir;
    if (((count KPLIB_enemy_jetInAir) > 0) && (_planeCount < 1)) then {continue}; // Skip iteration
    if (_planeCount >= count KPLIB_enemy_jetInAir) then {continue}; // Skip iteration

    if (KPLIB_enemyReadiness > (50 - (5 * KPLIB_param_difficulty))) then {
        {
            private _tower = [getPosATL _x, KPLIB_side_enemy, KPLIB_range_radioTowerScan * 1.4] call KPLIB_fnc_getNearestTower;
            if (!(isNil "_tower") && ({alive _x} count (crew _x) > 0) && {((getPosATL _x) # 2) >= 200}) then {    
                [
                    {
                        ["KPLIB_callEnemyFighter", _this] call CBA_fnc_serverEvent;
                    }, _x, (30 + random 30)
                ] call CBA_fnc_waitAndExecute;
                
                //[_handle] call CBA_fnc_removePerFrameHandler;
            }
        }forEach _bluforAir;
    }
}, 120, []] call CBA_fnc_addPerFrameHandler;