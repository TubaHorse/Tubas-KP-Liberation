waitUntil {!isNil "KPLIB_initServerDone"};

params ["_newUnit", "_oldUnit"];

if (isNil "KPLIB_respawn_loadout") then {
    removeAllWeapons player;
    removeAllItems player;
    removeAllAssignedItems player;
    removeVest player;
    removeBackpack player;
    removeHeadgear player;
    removeGoggles player;
    player linkItem "ItemMap";
    player linkItem "ItemCompass";
    player linkItem "ItemWatch";
    player linkItem "ItemRadio";
} else {
    sleep 4;
    [player, KPLIB_respawn_loadout] call KPLIB_fnc_setLoadout;
};

[] call KPLIB_fnc_addActionsPlayer;

// Support Module handling
if ([
    false,
    player isEqualTo ([] call KPLIB_fnc_getCommander) || (getPlayerUID player) in KPLIB_whitelist_supportModule,
    true
] select KPLIB_param_supportModule) then {
    waitUntil {!isNil "KPLIB_param_supportModule_req" && !isNil "KPLIB_param_supportModule_arty" && time > 5};

    // Wait for missile module only if EF is loaded
    if (!isNull KPLIB_param_supportModule_missile) then {
        waitUntil {!isNil "KPLIB_param_supportModule_missile"};
    };

    // Remove link to corpse, if respawned
    if (!isNull _oldUnit) then {
        KPLIB_param_supportModule_req synchronizeObjectsRemove [_oldUnit];
        _oldUnit synchronizeObjectsRemove [KPLIB_param_supportModule_req];
    };

    // Link player to support modules
    [player, KPLIB_param_supportModule_req, KPLIB_param_supportModule_arty] call BIS_fnc_addSupportLink;
    
    // Only link and init missile module if EF is loaded
    if (!isNull KPLIB_param_supportModule_missile) then {
        [player, KPLIB_param_supportModule_req, KPLIB_param_supportModule_missile] call BIS_fnc_addSupportLink;
    };

    // Init modules, if newly joined and not client host
    if (isNull _oldUnit && !isServer) then {
        [KPLIB_param_supportModule_req] call BIS_fnc_moduleSupportsInitRequester;
        [KPLIB_param_supportModule_arty] call BIS_fnc_moduleSupportsInitProvider;
        
        // Only call EF if there are missile vehicles synchronized
        if (!isNull KPLIB_param_supportModule_missile) then {
            [KPLIB_param_supportModule_missile] call EF_fnc_moduleNLOS;
        };

        // There remain issues with this feature. It seems that EF_fnc_moduleNLOS does not automatically handle dynamic updates to the support module like BIS_fnc_moduleSupportsInitProvider. I will be checking w/ Tiny Gecko to see if this is correct.
        //As it stands, a player has to respawn for the vehicles to show up, and if a vehicle is destroyed it is not removed from the list.
        // Also, I think empty vehicles are also included in the menu despite not being able to perform the fire mission.
    };
};