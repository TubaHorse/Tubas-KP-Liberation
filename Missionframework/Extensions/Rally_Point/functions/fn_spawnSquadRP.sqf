/* 
    File: fn_spawnSquadRP.sqf 
    Author: PiG13BR (https://github.com/PiG13BR) 
    Date: 27/10/2025 
    Last update: 25/07/2026 
    License: MIT License - http://www.opensource.org/licenses/MIT 
 
    Description: 
        Spawns a squad/group rally point 
 
    Parameter(s) 
        _leader - leader who is going to spawn rally point object [OBJECT, defaults to player] 
        _model - rally point object classname to spawn [STRING, defaults to "Land_TentSolar_01_folded_bluewhite_F"] 
 
    Returns: 
        - 
*/ 
params[["_leader", player, [objNull]], ["_model", "Land_TentSolar_01_folded_olive_F", [""]]]; 
 
if (isNull _leader) exitWith {}; 
private _group = (group _leader);
 
private _rallyPoint = [_group] call KPLIB_fnc_getSquadRP; 
if (!isNull _rallyPoint) then { 
    // Delete previous rally point 
    [_group, _rallyPoint] call KPLIB_fnc_deleteSquadRP; 
}; 
 
_rallyPoint = createVehicle [_model , getPosATL _leader, [], 0, "CAN_COLLIDE"]; 

_group setVariable ["KPLIB_RP_squadRallyPoint", _rallyPoint, true]; // Save rally point object
_rallyPoint setVariable ["KPLIB_RP_rallyPointSquad", _group, true]; // Save original group 
 
// If rally point is hit, delete RP 
_rallyPoint addEventHandler ["Hit", { 
    params ["_object"]; 

    private _grp = _object getVariable ["KPLIB_RP_rallyPointSquad", grpNull];
    [_grp] call KPLIB_fnc_deleteSquadRP;
}];

// Leader event handler
if ((_leader getVariable ["KPLIB_RP_leaderEH", []]) isNotEqualTo []) then {
    _leader removeMPEventHandler (_leader getVariable ["KPLIB_RP_leaderEH", ["", -1]]); 
};

// If leader gets killed, delete RP 
private _killedEH = _leader addEventHandler ["Killed", { 
    params ["_unit"];
    
    [group _unit] call KPLIB_fnc_deleteSquadRP;
    _unit removeEventHandler [_thisEvent, _thisEventHandler]; 
}];

// Group event handlers
if ((_group getVariable ["KPLIB_RP_grpEH", []]) isNotEqualTo []) then {
    {
        _group removeEventHandler _x; 
    }forEach (_group getVariable ["KPLIB_RP_grpEH", []]); 
};

// if the leader changes, delete RP 
private _leaderChangedEH = _group addEventHandler ["LeaderChanged", { 
    params ["_group"]; 
    [_group] call KPLIB_fnc_deleteSquadRP;
}]; 

private _emptyEH = _group addEventHandler ["Empty", {
	params ["_group"];

    [_group] call KPLIB_fnc_deleteSquadRP; 
}];

private _deletedEH = _group addEventHandler ["Deleted", {
	params ["_group"];

    [_group] call KPLIB_fnc_deleteSquadRP;
}];

private _groupIDChangedEH = _group addEventHandler ["GroupIdChanged", {
	params ["_group", "_newGroupId"];

    [_group] call KPLIB_fnc_deleteSquadRP;
}];
 
// Save EHs
_leader setVariable ["KPLIB_RP_leaderEH", ["Killed", _killedEH], true]; 
_group setVariable ["KPLIB_RP_grpEH", [
    ["LeaderChanged", _leaderChangedEH], 
    ["Empty", _emptyEH],
    ["Deleted", _deletedEH],
    ["GroupIdChanged", _groupIDChangedEH]
], true]; 
 
[localize "STR_RALLYPOINT_DEPLOYED", false, 5, 2] call ace_common_fnc_displayText; 
 
// Rally Point deploy cooldown 
if (PIG_RallyPoint_Setting_Cooldown > 0) then { 
    _group setVariable ["KPLIB_RP_squadCooldown", true, true]; 
    [{ 
        [_this] call KPLIB_fnc_deleteSquadRP; 
        _this setVariable ["KPLIB_RP_squadCooldown", false, true] 
    }, _group, (60 * PIG_RallyPoint_Setting_Cooldown)] call CBA_fnc_waitAndExecute; 
};