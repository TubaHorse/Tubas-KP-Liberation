/*
    File: fn_getBaseResources.sqf
    Author: KP Liberation Dev Team - https://github.com/KillahPotatoes
    Date: 2019-05-08
    Last Update: 2026-04-13
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Gets the base resource data in format [<POSITION>, <SUPPLIES>, <AMMO>, <FUEL>, <HAS_AIR_BUILD>, <HAS_REC_WORKSHOP>].

    Parameter(s):
        _base - Position of Base to get resources of [POSITION, defaults to [0, 0, 0]]

    Returns:
        BASE resource data [ARRAY]
*/

#define NO_RESULT [[0, 0, 0], 0, 0, 0, false, false, false]

params [
    ["_base", [0, 0, 0], [[]], [2, 3]]
];

KPLIB_base_resources param [KPLIB_base_resources findIf {(_x select 0) isEqualTo _base}, NO_RESULT] // return
