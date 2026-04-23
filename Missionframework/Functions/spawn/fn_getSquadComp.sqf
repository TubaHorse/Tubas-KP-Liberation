/*
    File: fn_getSquadComp.sqf
    Author: KP Liberation Dev Team - https://github.com/KillahPotatoes
    Date: 2019-11-25
    Last Update: 2025-11-18
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Provides an infantry squad composition of classnames in accordance to the current weights to adapt to the players playstyle.

    Parameter(s):
        _type - Type of infantry. Army or militia [STRING, defaults to "army"]

    Returns:
        Array of infantry classnames [ARRAY]
*/

params [
    ["_type", "army", [""]]
];

private _squadcomp = [];

switch _type do {
    case "army" : {
        private _selected = false;
        private _randomchance = 0;
        _squadcomp = KPLIB_o_squadStd;

        if (KPLIB_armorWeight > 40 && !_selected) then {
            _randomchance = (KPLIB_armorWeight - 35) * 1.4;
            if ((random 100) < _randomchance) then {
                _selected = true;
                _squadcomp = KPLIB_o_squadTank;
            };
        };

        if (KPLIB_airWeight > 40 && !_selected) then {
            _randomchance = (KPLIB_airWeight - 35) * 1.4;
            if ((random 100) < _randomchance) then {
                _selected = true;
                _squadcomp = KPLIB_o_squadAir;
            };
        };

        if (KPLIB_infantryWeight > 40 && !_selected) then {
            _randomchance = (KPLIB_infantryWeight - 35) * 1.4;
            if ((random 100) < _randomchance) then {
                _selected = true;
                _squadcomp = KPLIB_o_squadInf;
            };
        };
    };
    case "paratroopers" : {
        _squadcomp = KPLIB_o_paratroopers;
    };
    default {
        private _multiplier = 1;
        if (KPLIB_param_unitcap < 1) then {_multiplier = KPLIB_param_unitcap;};
        while {count _squadcomp < (10 * _multiplier)} do {_squadcomp pushback (selectRandom KPLIB_o_militiaInfantry)};
    };
};

_squadcomp
