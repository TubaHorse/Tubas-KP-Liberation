/*
    File: fn_linkVehToUnlock.sqf
    Author: KP Liberation Dev Team - https://github.com/KillahPotatoes, PiG13BR (https://github.com/PiG13BR)
    Date: 29/07/2026
    Last Update: 29/07/2026
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Link vehicles to designated sectors

    Parameter(s):
        -

    Returns:
        -
*/

KPLIB_sector_vehicleLinks = KPLIB_sector_vehicleLinks select {
    _x params ["_class", "_marker"];
    // EV which shall have already been validated, class checked, cross checked with build
    _class in KPLIB_b_vehToUnlockClasses && {_marker in KPLIB_sectors_all};
};

// Double crosscheck if sector changed
{
    _x params ["_class", "_base"];

    // Ignore empty strings
    if (_base isEqualTo "") then {continue};

    private _index = KPLIB_sector_vehicleLinks findIf {_class == (_x # 0)};
    if (_index >= 0) then {
        private _selection = KPLIB_sector_vehicleLinks # _index;
        if ((_selection # 1) != _base) then {
            // Different base
            //KPLIB_sector_vehicleLinks deleteAt _index;  // Delete to update below
            KPLIB_sector_vehicleLinks set [_index, [_class, _base]];
            [format["Different base detected for %1", _class], "SAVE"] call KPLIB_fnc_log;
        }
    };
}forEach KPLIB_b_vehToUnlock;

// Check for additions in the locked vehicles array
private _lockedVehCount = count KPLIB_sector_vehicleLinks;

if ((_lockedVehCount < (count KPLIB_sectors_all)) && (_lockedVehCount < (count KPLIB_b_vehToUnlock))) then {
    private _assignedBases = [];
    private _nextVehicle = "";
    private _nextBase = "";

    private _assignedVehicles = KPLIB_sector_vehicleLinks apply {
        _assignedBases pushBack (_x select 1);
        (_x select 0);
    };

    // Add new entries, when there are elite vehicles and military sectors are not yet assigned 
    {
        _x params ["_nextVehicle", "_nextBase"];

        if (KPLIB_sector_vehicleLinks findIf {_nextVehicle == (_x#0)} >= 0) then {continue};

        // Check if the sector exists
        if ((_nextBase isNotEqualTo "") && !(_nextBase in KPLIB_sectors_all)) then {
            [format["Couldn't find the sector %1 to link vehicle %2", _nextBase, _nextVehicle], "SAVE"] call KPLIB_fnc_log;
            _nextBase = "";
        };

        if (_nextBase isEqualTo "") then {
            // Select a random base
            _nextBase = selectRandom ((KPLIB_sectors_military + KPLIB_sectors_capital + KPLIB_sectors_airport) - _assignedBases);
        };

        if (isNil "_nextBase") exitWith {}; // Run out of military bases

        _assignedBases pushBack _nextBase;
        KPLIB_sector_vehicleLinks pushBack [_nextVehicle, _nextBase];

    }forEach KPLIB_b_vehToUnlock;
    ["Additional sectors or unlockable vehicles detected and assigned", "SAVE"] call KPLIB_fnc_log;
};