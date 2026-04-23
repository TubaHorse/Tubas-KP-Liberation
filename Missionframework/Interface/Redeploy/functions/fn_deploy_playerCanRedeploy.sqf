/*
    File: fn_deploy_playerCanRedeploy.sqf
    Author: KP Liberation Dev Team - https://github.com/KillahPotatoes, PiG13BR - https://github.com/PiG13BR
    Date: 17/11/2025
    Last Update: 12/04/2026
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Check if the base has enough resources to able the player to respawn

    Parameter(s):
        _respawnPos - respawn position used as reference to get the nearest base [POSITION, defaults to [0,0,0]] 

    Returns:
        Bool and Base name [ARRAY]
*/
params[["_respawnPos", [0,0,0], [[]]]];

private _canRespawn = [true, ""];

if (_respawnPos isEqualTo [0,0,0]) exitWith {_canRespawn};
if ((KPLIB_player_fobs isEqualTo []) && (KPLIB_player_outposts isEqualTo [])) exitWith {_canRespawn};
if (KPLIB_param_respawnCost < 1) exitWith {_canRespawn};

private _player = localNamespace getVariable ["KPLIB_playerDeploying", player];

// Check range from the nearest base
private _closestBasePos = [_respawnPos] call KPLIB_fnc_getNearestPlayerBase;

// Players and respawn pos is inside a base, ignore cost
if ((_respawnPos distance2D _closestBasePos < KPLIB_range_fob) && {_player distance2D _closestBasePos < KPLIB_range_fob}) exitWith {_canRespawn};

// Respawn pos is outside of base minimal cost range, ignore cost
if ((_respawnPos distance2D _closestBasePos) > (KPLIB_range_fob * 2)) exitWith {_canRespawn};

// Respawn pos is inside of fob minimal cost range, return fob name to warn players
private _prefix = switch (true) do {
    case (_closestBasePos in KPLIB_player_outposts) : {"Outpost"};
    default {"FOB"}
};
if (_respawnPos distance2D _closestBasePos < (KPLIB_range_fob * 2)) then {_canRespawn set [1, [_prefix, [_closestBasePos] call KPLIB_fnc_getBaseName] joinString " "];};

// Respawn cost
private _supplies = KPLIB_param_respawnCost;
private _ammo = KPLIB_param_respawnCost;
private _fuel = KPLIB_param_respawnCost;

// Check fob available supplies
private _baseData = KPLIB_base_resources select {((_x select 0) distance _closestBasePos) < KPLIB_range_fob};

(_baseData # 0) params ["", "_fobSupplies", "_fobAmmo", "_fobFuel"];

if (
    ((_supplies > 0) && (_supplies > _fobSupplies)) ||
    ((_ammo > 0) && (_ammo > _fobAmmo)) ||
    ((_fuel > 0) && (_fuel > _fobFuel))
) then {
    _canRespawn set [0, false];
};

_canRespawn