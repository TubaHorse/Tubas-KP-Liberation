/*
    File: fn_applyTurretPylon.sqf
    Author: PiG13BR - https://github.com/PiG13BR
    Date: 13/06/2026
    Update Date: 27/06/2026
    
    Description:
        Apply designated turret to the pylon

    Parameter(s):
        _aircraft - aircraft to apply the turret configuration [OBJECT]
        _pylonIndex - pylon index [NUMBER]
        _turret - turret to apply [ARRAY, defaults to [-1]]
    
    Returns:
        -
*/
params["_aircraft", "_pylonIndex", ["_turret", [-1]]];

private _magazine = (getAllPylonsInfo (_aircraft) param [_pylonIndex - 1, []]) param [3, ""];
if (_magazine isEqualTo "") exitWith {};

["PAS_setPylonArmament", [_aircraft, _pylonIndex, _magazine, _turret]] call CBA_fnc_globalEvent;
//[_aircraft, _pylonIndex, _magazine, _turret] call KPLIB_fnc_setPylonConfiguration;