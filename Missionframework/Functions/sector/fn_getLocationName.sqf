/*
    File: fn_getLocationName.sqf
    Author: KP Liberation Dev Team - https://github.com/KillahPotatoes
    Date: 2019-11-25
    Last Update: 2026-04-12
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Gets the name of the nearest FOB/sector from given position.

    Parameter(s):
        _pos - Position to get the location name from [POSITION, defaults to [0, 0, 0]]

    Returns:
        Location name [STRING]
*/

params [
    ["_pos", [0, 0, 0], [[]], [2, 3]]
];

private _name = [_pos] call KPLIB_fnc_getBaseName;

if (_name isEqualTo "") then {
    markerText ([50, _pos] call KPLIB_fnc_getNearestSector)
} else {
    private _prefix = switch (true) do {
        case (_pos in KPLIB_player_outposts) : {"Outpost"};
        default {"FOB"}
    };
    [_prefix, _name] joinString " "
};
