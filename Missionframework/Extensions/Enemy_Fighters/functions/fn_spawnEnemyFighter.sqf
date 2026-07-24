/*
    File: fn_spawnEnemyFighter.sqf
    Author: PiG13BR - (https://github.com/PiG13BR)
    Date: 04/02/2026
    Last update: 20/07/2026
    License: MIT License - http://www.opensource.org/licenses/MIT 

    Description:
        Spawns enemy fighter and fill its pylon with air-to-air missiles
    
    Parameter(s)
        _targetPos - target pos reference [POSITION, defaults to [0,0,0]]

    Returns:
        Enemy Fighter [OBJECT]
*/

params[["_targetPos", [0,0,0], [[]], [2,3]]];

if (_targetPos isEqualTo [0,0,0]) exitWith {["No position provided to spawn enemy fighter"] call BIS_fnc_error; objNull};

// Spawning enemy jet
private _class = selectRandom KPLIB_o_fighters;
private _spawnPoint = [_targetPos] call KPLIB_fnc_getFighterSpawnPoint;

if (_spawnPoint isEqualTo "") exitWith {};

private _spawnPos = markerPos _spawnPoint;
private _targetAlt = _targetPos # 2;
_spawnPos = [(((_spawnPos select 0) + 500) - random 1000), (((_spawnPos select 1) + 500) - random 1000), (_targetAlt) max 200];

private _plane = createVehicle [_class, _spawnPos, [], 0, "FLY"];
[_plane] call KPLIB_fnc_createCrew;
//_plane flyInHeightASL [500 + (random 500), 500 + (random 500), 500 + (random 500)];
_plane setVelocityModelSpace [0, 300, 0];
(driver _plane) doMove _targetPos;

_plane addMPEventHandler ["MPKilled", {
    params ["_unit", "_killer"];
    ["KPLIB_manageKills", [_unit, _killer]] call CBA_fnc_localEvent;
    KPLIB_enemy_jetInAir deleteAt (KPLIB_enemy_jetInAir find _unit);
}];
{
    _x addMPEventHandler ["MPKilled", {
        params ["_unit", "_killer"];
        ["KPLIB_manageKills", [_unit,_killer]] call CBA_fnc_localEvent;
    }];
} forEach (crew _plane);

// Fill aircraft's pylons with air-to-air missiles
private _pylonsIndex = (getAllPylonsInfo _plane);
{
    private _index = _x # 0;
    _plane setPylonLoadout [_index, ""]; // Clear pylon
    private _compatibleMagazines = _plane getCompatiblePylonMagazines _index;
    {
        // Get Ammo
        private _ammo = getText(configFile >> "cfgMagazines" >> _x >> "Ammo");
        if ((getNumber(configFile >> "cfgAmmo" >> _ammo >>  "airLock")) == 2) exitWith {
            _plane setPylonLoadout [_index, _x]; // Add AA magazine to designated pylon
        }
    }forEach _compatibleMagazines;
}forEach _pylonsIndex;

_plane