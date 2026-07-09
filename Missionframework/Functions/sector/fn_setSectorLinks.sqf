/*
	File: fn_setSectorLinks.sqf
	Author: PiG13BR (https://github.com/PiG13BR)
	Date: 08/07/2026
	Last update: 08/07/2026
	License: MIT License - http://www.opensource.org/licenses/MIT

	Description:
		Set vehicle and arsenal links to sectors

	Parameters:
		-

	Return:
		-
*/

KPLIB_vehicle_unlock_markers = [];
KPLIB_arsenal_unlock_markers = [];
private _cfg = configFile >> "cfgVehicles";

{
    _x params ["_vehicle", "_base"];
    private _marker = createMarker [format ["vehicleunlockmarker_%1", _base], [(markerpos _base) select 0, ((markerpos _base) select 1) + 125]];
    _marker setMarkerText (getText (_cfg >> _vehicle >> "displayName"));
    _marker setMarkerColor KPLIB_color_enemy;
    _marker setMarkerType "mil_pickup";
    KPLIB_vehicle_unlock_markers pushback [_marker, _base];
} forEach KPLIB_sector_vehicleLinks;

{    
    private _sector = _x;
    private _marker = createMarker [format ["arsenalunlockmarker_%1", _sector], [(markerpos _sector) select 0, ((markerpos _sector) select 1) - 125]];
    _marker setMarkerText "Arsenal+";
    _marker setMarkerColor KPLIB_color_enemy;
    _marker setMarkerType "mil_pickup";
    _marker setMarkerSize [0.8, 0.8];
    KPLIB_arsenal_unlock_markers pushback [_marker, _sector];
}forEach KPLIB_sector_arsenalLink;