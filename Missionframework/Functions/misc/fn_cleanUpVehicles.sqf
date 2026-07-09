/*
    File: fn_cleanUpVehicles.sqf
    Author: -
    Date: -
    Last Update: 08/07/2026
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Clean up player's preset vehicles
    
    Parameter(s):
        -
    
    Returns:
        -
*/
private _vehClasses = [];
{
    _vehClasses append _x;
} forEach [KPLIB_b_light_classes, KPLIB_b_heavy_classes, KPLIB_b_air_classes];

[{
    ["_vehClasses", "_handle"];

    {
        private _vehicle = _x;
        private _nearestFob = [getposATL _vehicle] call KPLIB_fnc_getNearestFob;
        if ( count _nearestFob == 3 ) then {
            if ((_vehicle distance _nearestFob > (1.2 * KPLIB_range_fob)) && (_vehicle distance startbase > (1.2 * KPLIB_range_fob))) then {
                if ((toLowerANSI (typeof _vehicle)) in _vehClasses) then {
                    private _airports = KPLIB_sectors_airport select {_x in KPLIB_sectors_player};
                    if (_airports findIf {_vehicle inArea _x} >= 0) then {continue};
                    if (count (crew _vehicle) == 0) then {
                        deleteVehicle _vehicle;
                    };
                };
            };
        };
    } foreach vehicles;
}, (KPLIB_param_vehicleCleanup * 3600), _vehClasses] call CBA_fnc_addPerFrameHandler;