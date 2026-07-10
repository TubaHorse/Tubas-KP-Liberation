/*
    File: fn_getSectorRange.sqf
    Author: KP Liberation Dev Team - https://github.com/KillahPotatoes, PiG13BR - https://github.com/PiG13BR
    Date: 25/11/2019
    Last Update: 09/07/2026
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Gets the sector size with taking the given amount of units into account.

    Parameter(s):
        _unitCount - Number of units to take into account [NUMBER, defaults to 0]
        _sector    - Sector from KPLIB_sectors_all

    Returns:
        Calculated sector size [NUMBER]
*/

params [
    ["_unitCount", 0, [0]],
    "_sector"
];

private _activationRange = KPLIB_range_sectorActivation;

switch (true) do {
    case (_sector in KPLIB_sectors_spawn):    { _activationRange = KPLIB_range_pointActivation; };
    case (_sector in KPLIB_sectors_city):     { _activationRange = KPLIB_range_cityActivation; };
    case (_sector in KPLIB_sectors_tower):    { _activationRange = KPLIB_range_towerActivation; };
    case (_sector in KPLIB_sectors_factory):  { _activationRange = KPLIB_range_factoryActivation; };
    case (_sector in KPLIB_sectors_military): { _activationRange = KPLIB_range_militaryActivation; };
    case (_sector in KPLIB_sectors_airport):  { _activationRange = KPLIB_range_airportActivation; };
    case (_sector in KPLIB_sectors_capital):  { _activationRange = KPLIB_range_capitalActivation; };
    case (_sector in KPLIB_sectors_airSpawn): { _activationRange = KPLIB_range_airSpawnActivation; };
    case (_sector in KPLIB_fillers_patrol):   { _activationRange = KPLIB_range_filler_patrol; };
    case (_sector in KPLIB_fillers_aa):       { _activationRange = KPLIB_range_filler_aa; };
};

if (_unitCount < (KPLIB_cap_enemySide / 2)) exitWith {_activationRange};
if (_unitCount <= KPLIB_cap_enemySide) exitWith {_activationRange - (_activationRange * 0.5 * ((_unitCount / KPLIB_cap_enemySide) - 0.5))};
_activationRange * 0.75
