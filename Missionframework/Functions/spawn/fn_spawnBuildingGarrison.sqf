/*
    File: fn_spawnBuildingGarrison.sqf
    Author: PiG13BR - https://github.com/PiG13BBR
    Date: 12/12/2025
    Last Update: 29/05/2026
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Spawns entire squads in the provided building.

    Parameter(s):
        _garrison - building to garrison [OBJECT]
        _infType - infantry type to spawn [STRING, defaults to "army"]
        
    Returns:
        Spawned group
*/

params["_garrison", ["_infType", "army"]];

// Get all building positions
private _buildingPositions = [_garrison] call CBA_fnc_buildingPositions;

if (_buildingPositions isEqualTo []) exitWith {grpNull};

private _grp = createGroup [KPLIB_side_enemy, true];

// Sort indoor positions
if (!(typeOf _garrison in KPLIB_guardTowers_marksman) && !(typeOf _garrison in KPLIB_guardTowers)) then {
    // Squad size garrison
    _buildingPositions = _buildingPositions select {
        private _pos = AGLToASL _x;
        lineIntersects [_pos, _pos vectorAdd [0, 0, 6]]
    };

    // Get squad comp to garrison building
    private _garrisonSquad = [_infType] call KPLIB_fnc_getSquadComp;

    {
        private _pos = _buildingPositions deleteAt (_buildingPositions find (selectRandom _buildingPositions));
        if (isNil "_pos") exitWith {}; // Exit
        
        private _posATL = (ASLToATL (AGLToASL _pos));

        private _unit = [_x, _posATL, _grp] call KPLIB_fnc_createManagedUnit;
        _unit setPosATL _posATL;
        _unit setDir (_garrison getDir _posATL);
        _unit doWatch (_garrison getPos [200, (_garrison getDir _posATL)]);
        _unit disableAI "PATH";
        _unit setVariable ["KPLIB_garrisoned", true]; // Set garrison status

        // Avoid prone (only if garrisoned)
        _unit addEventHandler ["AnimChanged", {
            params ["_unit", "_anim"];
            if !(_unit getVariable ["KPLIB_garrisoned", false]) exitWith {_unit removeEventHandler [_thisEvent, _thisEventHandler]};

            if (unitPos _unit == "Down") then {_unit setUnitPos "UP"};
        }];

        _unit addEventHandler ["Hit", {
            params ["_unit"];
            _unit enableAI "PATH";
            _unit setVariable ["KPLIB_garrisoned", false];
            _unit setCombatBehaviour "COMBAT";
        }];
        _unit addEventHandler ["Fired", {
            params ["_unit"];
            _unit setCombatBehaviour "COMBAT";
        }];
        _unit addEventHandler ["FiredNear", {
            params ["_unit"];
            _unit setCombatBehaviour "COMBAT";
        }];
        _unit addEventHandler ["Suppressed", {
            params ["_unit"];
            _unit setCombatBehaviour "COMBAT";
        }];

    }forEach _garrisonSquad;

} else {
    // Sentry/Marksman
    _buildingPositions resize 1;

    private _posATL = (ASLToATL (AGLToASL (_buildingPositions # 0)));

     private "_unit";
    switch (true) do {
        case (typeOf _garrison in KPLIB_guardTowers_marksman) : {
            // Force spawn marksman
            _unit = [KPLIB_o_marksman, _posATL, _grp] call KPLIB_fnc_createManagedUnit;
            _unit setSkill ["aimingAccuracy", 0.65];
            _unit setSkill ["spotTime", 1];
            _unit setSkill ["spotDistance", 1];
        };
        case (typeOf _garrison in KPLIB_guardTowers) : {
            // Force spawn rifleman
            _unit = [KPLIB_o_sentry, _posATL, _grp] call KPLIB_fnc_createManagedUnit;
        };
        default {
            // Spawn squad unit
            _unit = [_x, _posATL, _grp] call KPLIB_fnc_createManagedUnit;
        };
    };

    _unit setPosATL _posATL;
    _unit setDir (_garrison getDir _posATL);
    _unit doWatch (_garrison getPos [200, (_garrison getDir _posATL)]);
    _unit disableAI "PATH";
    _unit setVariable ["KPLIB_garrisoned", true]; // Set garrison status

    // Avoid prone (only if garrisoned)
    _unit addEventHandler ["AnimChanged", {
        params ["_unit", "_anim"];
        if !(_unit getVariable ["KPLIB_garrisoned", false]) exitWith {_unit removeEventHandler [_thisEvent, _thisEventHandler]};

        if (unitPos _unit == "Down") then {_unit setUnitPos "UP"};
    }];

    _unit addEventHandler ["Hit", {
        params ["_unit"];
        _unit enableAI "PATH";
        _unit setVariable ["KPLIB_garrisoned", false];
        _unit setCombatBehaviour "COMBAT";
    }];
    _unit addEventHandler ["Fired", {
        params ["_unit"];
        _unit setCombatBehaviour "COMBAT";
    }];
    _unit addEventHandler ["FiredNear", {
        params ["_unit"];
        _unit setCombatBehaviour "COMBAT";
    }];
    _unit addEventHandler ["Suppressed", {
        params ["_unit"];
        _unit setCombatBehaviour "COMBAT";
    }];
};

_grp