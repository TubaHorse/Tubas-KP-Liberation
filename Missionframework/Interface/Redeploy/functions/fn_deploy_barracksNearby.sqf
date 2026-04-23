/*
    File: fn_deploy_barracksNearby.sqf
    Author: PiG13BR - https://github.com/PiG13BR
    Date: 08/01/2026
    Last Update: 12/04/2026
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Check if the base has barracks. Valid check for FOBs. Ignore outposts in this case.

    Parameter(s):
        _respawnPos - respawn position used as reference to get the nearest base [POSITION, defaults to [0,0,0]] 

    Returns:
        [BOOL]
*/
params[["_respawnPos", [0,0,0], [[]]]];

private _canRespawn = true;

if (_respawnPos isEqualTo [0,0,0]) exitWith {_canRespawn};
if (KPLIB_player_fobs isEqualTo [] && (KPLIB_player_outposts isEqualTo [])) exitWith {_canRespawn};

// Check range from the nearest base
private _closestBasePos = [_respawnPos] call KPLIB_fnc_getNearestPlayerBase;

if (_respawnPos distance2D _closestBasePos > KPLIB_range_fob) exitWith {_canRespawn};

// Outpost always cost redeploy
if (_closestBasePos in KPLIB_player_outposts) then {
    _canRespawn = false;
};

// Check for neaby barracks in fobs
if (((count (_closestBasePos nearObjects [KPLIB_b_barrack, KPLIB_range_fob])) < 2) && (_closestBasePos in KPLIB_player_fobs)) then {
    _canRespawn = false
};

_canRespawn

