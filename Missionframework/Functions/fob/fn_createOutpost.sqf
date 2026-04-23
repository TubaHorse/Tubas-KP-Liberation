/*
    File: fn_createOutpost.sqf
    Author: PiG13BR - https://github.com/PiG13BR
    Date: 12/04/2026
    Last Update: 13/04/2026
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Creates/notify a new Outpost

    Parameter(s):
       _newOutposPos - new outpost position [POSITION, defaults to [0,0,0]]
       _create - create a new outpost [BOOL, defaults to false]

    Returns:
        Function reached the end [BOOL]
*/

if (!isServer) exitWith {false};

params [
    ["_newOutpostPos", [0,0,0], [[]]], 
    ["_create", false, [FALSE]]
];

if (_newOutpostPos isEqualTo [0,0,0]) exitWith {["No position provided"] call BIS_fnc_error; false};

if (_create) then {
    _newOutpostPos = [(_newOutpostPos select 0) + 15, (_newOutpostPos select 1) + 2, 0];
    [_newOutpostPos, 20, true] call KPLIB_fnc_createClearance;
    _newOutpost = KPLIB_b_outpostBuilding createVehicle _newOutpostPos;
    _newOutpost setpos _newOutpostPos;
    _newOutpost setVectorUp [0,0,1];
    [_newOutpost] call KPLIB_fnc_addObjectInit;
    _newOutpost setVariable ["KPLIB_isOutpost", true, true];
};

[] call KPLIB_fnc_doSave;

[{
    [_this, 0] remoteExec ["remote_call_fob"];

    // Find empty arrays in KPLIB_player_outposts
    private _index = KPLIB_player_outposts find [0,0,0];
    if (_index >= 0) then {
        // Empty array found, replace it
        KPLIB_player_outposts set [_index, _this];
    } else {
        // Pushback instead
        KPLIB_player_outposts pushback _this;
    };
    publicVariable "KPLIB_player_outposts";

    // Update markers
    ["KPLIB_updateBaseMarkers", []] call CBA_fnc_serverEvent;
}, _newOutpostPos, 3] call CBA_fnc_waitAndExecute;

stats_outpost_built = stats_outpost_built + 1;

true