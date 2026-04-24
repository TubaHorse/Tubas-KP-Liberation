    /*
    File: fn_addActionsOutpost.sqf
    Author: PiG13BR - https://github.com/PiG13BR
    Date: 2026-04-22
    Last Update: 2026-04-22
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Adds build action to Outpost box and repackage action to Outpost building.

    Parameter(s):
        _obj - Outpost box/building to add the deploy/repack action to [OBJECT, defaults to objNull]

    Returns:
        Function reached the end [BOOL]
*/
params [
    ["_obj", objNull, [objNull]]
];

if (isNull _obj) exitWith {["Null object given"] call BIS_fnc_error; false};

if ((typeOf _obj) isEqualTo KPLIB_b_outpostBuilding) exitWith {
    _obj addAction [
        ["<t color='#FFFF00'>", localize "STR_BASE_REPACKAGE", "</t> <img size='2' image='Images\ui_deployfob.paa'/>"] joinString "",
        {[_this # 0] call KPLIB_fnc_repackage_createMenuRsc},
        nil,
        -754,
        false,
        true,
        "",
        toString {
            alive _target &&
            isNull (objectParent _this) && 
            {player getVariable ['KPLIB_hasDirectAccess', false]}
        },
        20
    ];
    true
};

// Outpost
if ((typeOf _obj) isEqualTo KPLIB_b_outpostBox) exitWith {
    [
    _obj,
        ["<t color='#FFFF00'>", localize "STR_OUTPOST_ACTION", "</t> <img size='2' image='Images\ui_deployfob.paa'/>"] joinString "",
        "", "",
        toString {
            !(_this getVariable ['KPLIB_BUILD_isBuilding', false])
            && {KPLIB_player_fobs isNotEqualTo []} // Make available only if there are at least one fob builded
            && {
                _this getVariable ['KPLIB_hasDirectAccess', false]
                || {[3] call KPLIB_fnc_hasPermission}
            }
            && {isNull objectParent _this} 
            && {isNull (_this getVariable ["KPLIB_carriedObject", objNull])}
            && {!(_target getVariable ["KPLIB_isOutpost", false])}
            && {!(surfaceIsWater getPos player)}
            
        }, 
        toString {
            _caller distance _target < 10
            && {(KPLIB_player_fobs findIf {(_x distance2D _target) < (KPLIB_distance_base)} < 0)}
            && {(KPLIB_player_outposts findIf {(_x distance2D _target) < (KPLIB_distance_base)} < 0)}
        },
        {},
        {},
        {
            params["_object"];
            [_object] call KPLIB_fnc_doBuildOutpost
        },
        {
            if ( count (KPLIB_player_outposts select {_x isNotEqualTo [0,0,0]}) >= count KPLIB_militaryAlphabet) exitWith {
                [format [ localize "STR_HINT_OUTPOSTS_EXCEEDED", count KPLIB_militaryAlphabet], true, 3] call KPLIB_fnc_hint;
            };

            // Check for nearest fobs and outposts
            private _index = (KPLIB_player_fobs + KPLIB_player_outposts) findIf {(_x distance2D _target) < KPLIB_distance_base};
            if (_index >= 0) exitWith {
                private _distFob = _target distance ([getPosATL _target] call KPLIB_fnc_getNearestPlayerBase);
                [format [localize "STR_OUTPOST_BUILDING_IMPOSSIBLE", floor KPLIB_distance_base, floor _distFob], true, 3] call KPLIB_fnc_hint;
            };

            // Check for nearest sector
            private _index = KPLIB_sectors_all findIf {((markerPos _x) distance2D _target) < KPLIB_distance_sector};
            if (_index >= 0) exitWith {
                private _distSector = _target distance (markerPos ([KPLIB_distance_sector, getPosATL _target] call KPLIB_fnc_getNearestSector));
                [format [localize "STR_OUTPOST_BUILDING_IMPOSSIBLE_SECTOR", floor KPLIB_distance_sector, floor _distSector], true, 3] call KPLIB_fnc_hint;
            };

            // Check if terrain is relatively flat
            if (((ASLToAGL (getPosASL _target)) isFlatEmpty [-1, -1, KPLIB_terrainGradient_fob, 10, 0]) isEqualTo []) exitWith {
                [localize "STR_OUTPOST_BUILDING_IMPOSSIBLE_GRADIENT", true, 3] call KPLIB_fnc_hint;
            };
        },
        [], 2, -753, false, false
    ] call BIS_fnc_holdActionAdd;

    true
};

false