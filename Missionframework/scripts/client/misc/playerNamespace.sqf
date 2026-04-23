/*
    File: playerNamespace.sqf
    Author: KP Liberation Dev Team - https://github.com/KillahPotatoes
    Date: 2020-04-12
    Last Update: 2023-03-02
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Tracks player state values to provide this information for other scripts.
*/

// ToDo: get rid of this.

scriptName "KPLIB_playerNamespace";

//waitUntil {!isNil "one_synchro_done"};
//waitUntil {!isNil "one_eco_done"};
//waitUntil {one_synchro_done};
//waitUntil {one_eco_done};

private _basePos = [0, 0, 0];
private _baseDist = 99999;
private _baseName = "";

while {true} do {
    // FOB distance, name and position
    if ((KPLIB_player_fobs isNotEqualTo []) || (KPLIB_player_outposts isNotEqualTo [])) then {
        _basePos = [] call KPLIB_fnc_getNearestPlayerBase;
        _baseDist = player distance2d _basePos;
        switch (true) do {
            case (_basePos in KPLIB_player_fobs) : {
                _baseName = ["", ["FOB", [_basePos] call KPLIB_fnc_getBaseName] joinString " "] select (_baseDist < KPLIB_range_fob);
                player setVariable ["KPLIB_isNearFob", true];
                player setVariable ["KPLIB_isNearOutpost", false];
            };
            case (_basePos in KPLIB_player_outposts) : {
                _baseName = ["", ["Out", [_basePos] call KPLIB_fnc_getBaseName] joinString " "] select (_baseDist < KPLIB_range_outpost);
                player setVariable ["KPLIB_isNearFob", false];
                player setVariable ["KPLIB_isNearOutpost", true];
            };
        }    
    } else {
        _basePos = [0, 0, 0];
        _baseDist = 99999;
        _baseName = "";
    };
    player setVariable ["KPLIB_nearestBaseDist", _baseDist];
    player setVariable ["KPLIB_currentBaseName", _baseName];
    player setVariable ["KPLIB_nearestBasePos", _basePos];

    // Direct acces due to config, commander or quartermaster or admin
    player setVariable ["KPLIB_hasDirectAccess", (getPlayerUID player) in KPLIB_whitelist_cmdrActions || {player == ([] call KPLIB_fnc_getCommander)} || {player isEqualto (missionnamespace getVariable ['quartermaster',objNull])} || {serverCommandAvailable "#kick"}];

    // Outside of startbase "safezone"
    player setVariable ["KPLIB_isAwayFromStart", (player distance2d startbase) > 1000];

    // Is near an arsenal object
    if (KPLIB_param_mobileArsenal) then {
        player setVariable ["KPLIB_isNearArsenal", !(((player nearObjects [KPLIB_b_arsenal, 5]) select {getObjectType _x >= 8}) isEqualTo [])];
    };

    // Is near a mobile respawn
    if (KPLIB_param_mobileRespawn) then {
        player setVariable ["KPLIB_isNearMobRespawn", !((player nearEntities [(KPLIB_b_mobileRespawns)+ [KPLIB_b_potato01], 10]) isEqualTo [])];
    };
    
    // Is near supply dump
    player setVariable ["KPLIB_isNearDump", !((player nearEntities [KPLIB_b_supplyDump, 10]) isEqualTo [])];

    // Is near startbase
    player setVariable ["KPLIB_isNearStart", (player distance2d startbase) < 200];

    // Nearest activated sector and possible production data
    player setVariable ["KPLIB_nearProd", KPLIB_production getOrDefault [[100] call KPLIB_fnc_getNearestSector, []]];
    player setVariable ["KPLIB_nearSector", [KPLIB_range_sectorActivation] call KPLIB_fnc_getNearestSector];

    // Zeus module synced to player
    player setVariable ["KPLIB_ownedZeusModule", getAssignedCuratorLogic player];

    // Update state in Discord rich presence
    [] call KPLIB_fnc_setDiscordState;

    sleep 1;
};
