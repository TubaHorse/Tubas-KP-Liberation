/*
    File: fn_destroyOutpost.sqf
    Author: PiG13BR - https://github.com/PiG13BR
    Date: 13/04/2026
    Last Update: 13/04/2026
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Removes all player built buildings (from build list) inside the Outpost radius of given position.
        Also removes possible clearances from given position.

    Parameter(s):
        _outpostPos - Center position [ARRAY, defaults to []]

    Returns:
        Function reached the end [BOOL]
*/

params [
    ["_outpostPos", [], [[]]]
];

private _buildings = [toLowerANSI KPLIB_b_outpostBuilding];
_buildings append KPLIB_b_deco_classes;

{
    if ((toLowerANSI (typeOf _x)) in _buildings) then {
        _x spawn {
            sleep ((random 4) + (random 4));
            _this setDamage 1;
        };
    };
} forEach ((_outpostPos nearObjects (KPLIB_range_outpost * 1.2)) select {getObjectType _x >= 8});

// Leave as an empty pos
private _index = KPLIB_player_outposts find _outpostPos;
KPLIB_player_outposts set [_index, [0,0,0]]; 
publicVariable "KPLIB_player_outposts";

// Restore default name
private _defaultName = KPLIB_militaryAlphabet select _index;
KPLIB_outpostNames set [_index, _defaultName];
publicVariable "KPLIB_outpostNames";

KPLIB_clearances deleteAt (KPLIB_clearances findIf {(_x select 0) isEqualTo _outpostPos});
publicVariable "KPLIB_clearances";

["KPLIB_updateBaseMarkers", []] call CBA_fnc_serverEvent;

true
