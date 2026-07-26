/*
    File: fn_deleteSquadRP.sqf
    Author: PiG13BR (https://github.com/PiG13BR)
    Date: 09/11/2025
    Last update: 23/07/2026
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Deletes squad's rally point

    Parameter(s)
        _grp - squad related to the rally point object [GROUP]
        _rallyPoint - rally point object [OBJECT, defaults to objNull]

    Returns:
        -
*/
params["_grp", ["_rallyPoint", objNull, [objNull]]];

if (isNull _rallyPoint) then {_rallyPoint = [_grp] call KPLIB_fnc_getSquadRP;};

// Delete rally point
deleteVehicle _rallyPoint;
