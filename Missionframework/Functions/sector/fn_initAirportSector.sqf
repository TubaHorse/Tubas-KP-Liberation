/*
    File: fn_initAirportSector.sqf
    Author: PiG13BR - https://github.com/PiG13BR
    Date: 01/06/2026
    Last Update: 01/06/2026
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Adds a center marker for the airport and collect information about sam airport positions

    Parameter(s):
        _sector - airport sector [STRING]

    Returns:
        -
*/

params["_sector"];

if (!isServer) exitWith {};

if (isNil "KPLIB_airportSectorHash") then {
    KPLIB_airportSectorHash = createHashMap;
    publicVariable "KPLIB_airportSectorHash";
};

// Create airport center marker
private _centerMk = createMarker [format["%1_center", _sector], markerPos _sector]; 
_centerMk setMarkerType "o_installation";
private _sectorName = (markerText _sector);
if (_sectorName == "") then {_sectorName = "Airport"};
_centerMk setMarkerText (markerText _sector); 
_centerMk setMarkerSize [1.55, 1.55];

private _airportSams = [];
private _samsPos = ((allMapMarkers select {_x find "airport_sam"  == 0}) apply {markerPos _x}) inAreaArray _sector;

{
    _airportSams pushBack _x;
}forEach _samsPos;

KPLIB_airportSectorHash set [_sector, [_centerMk, _samsPos]];
publicVariable "KPLIB_airportSectorHash";