/*
    Specific object init codes depending on classnames.

    Format:
    [
        Array of classnames as strings <ARRAY>,
        Code to apply <CODE>,
        Allow inheritance <BOOL> (default false)
    ]
    _this is the reference to the object with the classname

    Example:
        KPLIB_objectInits = [
            [
                ["O_soldierU_F"],
                {systemChat "CSAT urban soldier was spawned!"}
            ],
            [
                ["CAManBase"],
                {systemChat format ["Some human named '%1' was spawned!", name _this]},
                true
            ]
        ];
*/

KPLIB_objectInits = [
    // Set KP logo on white flag
    [
        ["Flag_White_F"],
        {_this setFlagTexture "res\flag_kp_co.paa";}
    ],

    // Add helipads to zeus, as they can't be recycled after built
    [
        ["Helipad_base_F", "LAND_uns_Heli_pad", "Helipad", "LAND_uns_evac_pad", "LAND_uns_Heli_H"],
        {{[_x, [[_this], true]] remoteExecCall ["addCuratorEditableObjects", 2]} forEach allCurators;},
        true
    ],

    // Add ViV and build action to FOB box/truck
    [
        [KPLIB_b_fobBox, KPLIB_b_fobTruck],
        {
            [_this] spawn {
                params ["_fobBox"];
                waitUntil {sleep 0.1; time > 0};
                if ((typeOf _fobBox) isEqualTo KPLIB_b_fobBox) then {
                    [_fobBox] call KPLIB_fnc_setFobMass;
                    [_fobBox] remoteExecCall ["KPLIB_fnc_setLoadableViV", 0, _fobBox];
                };
                [_fobBox] remoteExecCall ["KPLIB_fnc_addActionsFob", 0, _fobBox];
            };
        }
    ],

    // Add FOB building damage handler override and repack action
    [
        [KPLIB_b_fobBuilding],
        {
            _this addEventHandler ["HandleDamage", {0}];
            [_this] spawn {
                params ["_fob"];
                waitUntil {sleep 0.1; time > 0};
                [_fob] remoteExecCall ["KPLIB_fnc_addActionsFob", 0, _fob];
            };
        }
    ],

    // Add ViV action to Arsenal crate
    [
        [KPLIB_b_arsenal],
        {
            [_this] spawn {
                params ["_arsenal"];
                waitUntil {sleep 0.1; time > 0};
                [_arsenal] remoteExecCall ["KPLIB_fnc_setLoadableViV", 0, _arsenal];
            };
        }
    ],

    // Add storage type variable to built storage areas (only for FOB built/loaded ones)
    [
        [KPLIB_b_smallStorage, KPLIB_b_largeStorage],
        {_this setVariable ["KPLIB_storage_type", 0, true];}
    ],

    // Add ACE variables to corresponding building types
    [
        [KPLIB_b_logiStation],
        {_this setVariable ["ace_isRepairFacility", 1, true];}
    ],
    [
        KPLIB_medical_facilities,
        {_this setVariable ["ace_medical_isMedicalFacility", true, true];}
    ],
    [
        KPLIB_medical_vehicles,
        {_this setVariable ["ace_medical_isMedicalVehicle", true, true];}
    ],

    // Hide Cover on big GM trucks
    [
        ["gm_ge_army_kat1_454_cargo", "gm_ge_army_kat1_454_cargo_win"],
        {_this animateSource ["cover_unhide", 0, true];}
    ],

    // Make sure a slingloaded object is local to the helicopter pilot (avoid desync and rope break)
    [
        ["Helicopter"],
        {if (isServer) then {[_this] call KPLIB_fnc_addRopeAttachEh;} else {[_this] remoteExecCall ["KPLIB_fnc_addRopeAttachEh", 2];};},
        true
    ],

    // Add valid vehicles to support module, if system is enabled
    [
        KPLIB_param_supportModule_artyVeh,
        {if (KPLIB_param_supportModule > 0) then {KPLIB_param_supportModule_arty synchronizeObjectsAdd [_this];};}
    ],

    // Add valid cruise missile vehicles to support module, if system is enabled & EF is loaded
    [
        KPLIB_param_supportModule_missileVeh,
        {
            if (KPLIB_param_supportModule > 0 && !isNull KPLIB_param_supportModule_missile) then {
                // Check if already has a gunner (vehicles spawned with crew via "manned" option)
                if (!isNull gunner _this) then {
                    KPLIB_param_supportModule_missile synchronizeObjectsAdd [_this];
                    diag_log format ["MISSILE: Synced %1 (has gunner)", _this];
                    [] execVM "scripts\server\support\fn_updateCruiseMissiles.sqf";
                } else {
                    diag_log format ["MISSILE: Vehicle %1 has no gunner yet, adding event handlers", _this];
                };
                
                // Add GetIn handler to catch when crew enters later
                _this addEventHandler ["GetIn", {
                    params ["_vehicle", "_role"];
                    if (_role == "gunner" && !(_vehicle in synchronizedObjects KPLIB_param_supportModule_missile)) then {
                        KPLIB_param_supportModule_missile synchronizeObjectsAdd [_vehicle];
                        diag_log format ["MISSILE: Synced %1 (gunner entered)", _vehicle];
                        [] execVM "scripts\server\support\fn_updateCruiseMissiles.sqf";
                    };
                }];
                
                // Add GetOut handler to desync when gunner leaves
                _this addEventHandler ["GetOut", {
                    params ["_vehicle", "_role"];
                    if (_role == "gunner") then {
                        KPLIB_param_supportModule_missile synchronizeObjectsRemove [_vehicle];
                        diag_log format ["MISSILE: Desynced %1 (gunner left)", _vehicle];
                        [] spawn {
                            sleep 0.5;
                            [] execVM "scripts\server\support\fn_updateCruiseMissiles.sqf";
                        };
                    };
                }];
            };
        }
    ],

    // Disable autocombat (if set in parameters) and fleeing
    [
        ["Man"],
        {
            if (!(KPLIB_param_autodanger) && {(side _this) isEqualTo KPLIB_side_player}) then {
                _this disableAI "AUTOCOMBAT";
            };
            _this allowFleeing 0;
        },
        true
    ]
];
