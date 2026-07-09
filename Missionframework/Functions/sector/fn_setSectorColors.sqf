/*
	File: fn_setSectorColors.sqf
	Author: PiG13BR (https://github.com/PiG13BR)
	Date: 08/07/2026
	Last update: 08/07/2026
	License: MIT License - http://www.opensource.org/licenses/MIT

	Description:
		Set sector colors

	Parameters:
		-

	Return:
		-
*/

// Set enemy sector color
{
    if (_x in KPLIB_sectors_airport) then {
        private _airportData = (KPLIB_airportSectorHash getOrDefault [_x, []]);
        if (_airportData isEqualTo []) then {continue};
        _centerMk = _airportData # 0;
        _centerMk setMarkerColor KPLIB_color_enemy;
    };
    _x setMarkerColor KPLIB_color_enemy;
} forEach (KPLIB_sectors_all - KPLIB_sectors_player);

// Set friendly sector color
{
    private _sector = _x;
    if (_x in KPLIB_sectors_airport) then {
        private _airportData = (KPLIB_airportSectorHash getOrDefault [_x, []]);
        if (_airportData isEqualTo []) then {continue};
        _centerMk = _airportData # 0;
        _centerMk setMarkerColor KPLIB_color_player;
    };
    _x setMarkerColor KPLIB_color_player;
} forEach KPLIB_sectors_player;

// Select color for unlockable vehicle marker
{
    _x params ["_marker", "_base"];
    _marker setMarkerColor ([KPLIB_color_enemy, KPLIB_color_player] select (_base in KPLIB_sectors_player));
} forEach KPLIB_vehicle_unlock_markers;

// Select color for unlockable arsenal marker
{
    _x params ["_marker", "_sector"];
    _marker setMarkerColor ([KPLIB_color_enemy, KPLIB_color_player] select (_sector in KPLIB_sectors_player));
} forEach KPLIB_arsenal_unlock_markers;