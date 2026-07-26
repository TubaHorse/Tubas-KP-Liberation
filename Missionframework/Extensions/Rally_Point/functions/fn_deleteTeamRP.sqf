/*
    File: fn_deleteTeamRP.sqf
    Author: PiG13BR (https://github.com/PiG13BR)
    Date: 09/11/2025
    Last update: 25/07/2026
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Deletes team/commander rally point

    Parameter(s)
        -

    Returns:
        -
*/
private _rallyPoint = [] call KPLIB_fnc_getTeamRP;

// Delete rally point
if (!isNull _rallyPoint) then {deleteVehicle _rallyPoint;};