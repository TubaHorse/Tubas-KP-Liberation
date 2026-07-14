
private _start = diag_ticktime;
if (isServer) then {
    ["----- Server starts preset initialization -----", "PRESETS"] call KPLIB_fnc_log;
    ["Not found vehicles listed below are not an issue in general. It just sorts out vehicles from not loaded mods.", "PRESETS"] call KPLIB_fnc_log;
    ["Only if you e.g. use a CUP preset and you get messages about missing CUP classes, then check your loaded mods.", "PRESETS"] call KPLIB_fnc_log;
};

// Load default presets
[] call compile preprocessFileLineNumbers "Presets\Players\default.sqf";
[] call compile preprocessFileLineNumbers "Presets\Enemies\default.sqf";
[] call compile preprocessFileLineNumbers "Presets\Resistance\default.sqf";
[] call compile preprocessFileLineNumbers "Presets\Civilians\default.sqf";

// Load selected presets on mission params
[] call compile preprocessFileLineNumbers "Presets\get_presets.sqf";

/*
    Compatibility checks
*/
if ((KPLIB_b_vehSupport findIf {(_x#0 == KPLIB_b_supplyDump)}) < 0) then {
    // No supply dump found in support label, add it.
    KPLIB_b_vehSupport pushBack [KPLIB_b_supplyDump, 250,1000,0]
};

if ((KPLIB_b_vehSupport findIf {(_x#0 == KPLIB_b_barrack)}) < 0) then {
    // No barrack found in support label, add it
    KPLIB_b_vehSupport pushBack [KPLIB_b_barrack, 200,0,0]
};

if ((KPLIB_b_vehSupport findIf {(_x#0 == KPLIB_b_medicalFacility)}) < 0) then {
    // No barrack found in support label, add it
    KPLIB_b_vehSupport pushBack [KPLIB_b_medicalFacility, 300,0,0]
};

// Add crates to the support label
{
    private _class = _x # 0;
    if ((KPLIB_b_vehSupport findIf {(_x#0 == _class)}) < 0) then {KPLIB_b_vehSupport pushBack _x};
}forEach KPLIB_supply_crates;

KPLIB_supply_cratesClasses = KPLIB_supply_crates apply {toLowerANSI (_x#0)};

if (KPLIB_b_mobileRespawn isEqualType "") then {
    KPLIB_b_mobileRespawns = [KPLIB_b_mobileRespawn];
} else {
    KPLIB_b_mobileRespawns = KPLIB_b_mobileRespawn;
};

// Add transportable storage to support list if not available
if ((KPLIB_b_vehSupport findIf {(_x#0 == KPLIB_b_transStorage)}) < 0) then {
    // No barrack found in support label, add it
    KPLIB_b_vehSupport pushBack [KPLIB_b_transStorage,100,0,0]
};

// Outpost compat
if ((KPLIB_b_vehSupport findIf {(_x#0 == KPLIB_b_outpostBox)}) < 0) then {
    // No outpost found in support label, add it
    KPLIB_b_vehSupport pushBack [KPLIB_b_outpostBox,300,300,0]
};

// Compatibility check and fix for vehicles to unlock
KPLIB_b_vehToUnlock = KPLIB_b_vehToUnlock apply {if (_x isEqualType "") then {[_x, ""]} else {_x}};

// Force storages to be containers
KPLIB_b_smallStorage    = "Land_Cargo20_brick_red_F";
KPLIB_b_largeStorage    = "Land_Cargo40_brick_red_F"; 

// Compatibility data for slots and hangas
if (KPLIB_b_slotHeli isEqualType "") then {
    private _value = KPLIB_b_slotHeli;
    KPLIB_b_slotHeli = []; // Change data type
    KPLIB_b_slotHeli pushBack _value;
};

if (KPLIB_b_slotPlane isEqualType "") then {
    private _value = KPLIB_b_slotPlane;
    KPLIB_b_slotPlane = []; // Change data type
    KPLIB_b_slotPlane pushBack _value;
};

// Remove any heli slots and planes from aesthetic buildings if they are in KPLIB_type_heliPads variable already
{
    if (_x in KPLIB_type_heliPads) then {
        KPLIB_b_objectsDeco deleteAt _forEachIndex;
    };
}forEach (KPLIB_b_objectsDeco apply {_x#0});

// Squad names for build menu
KPLIB_b_squadNames = [
    localize "STR_LIGHT_RIFLE_SQUAD",
    localize "STR_RIFLE_SQUAD",
    localize "STR_AT_SQUAD",
    localize "STR_AA_SQUAD",
    localize "STR_RECON_SQUAD",
    localize "STR_PARA_SQUAD"
];

/*
    Checking all preset arrays for missing mods and sort out not available classnames
*/
// Blufor
KPLIB_b_infantry                = KPLIB_b_infantry                  select {[( _x select 0)] call KPLIB_fnc_checkClass};
KPLIB_b_vehLight                = KPLIB_b_vehLight                  select {[( _x select 0)] call KPLIB_fnc_checkClass};
KPLIB_b_vehHeavy                = KPLIB_b_vehHeavy                  select {[( _x select 0)] call KPLIB_fnc_checkClass};
KPLIB_b_vehAir                  = KPLIB_b_vehAir                    select {[( _x select 0)] call KPLIB_fnc_checkClass};
KPLIB_b_vehStatic               = KPLIB_b_vehStatic                 select {[( _x select 0)] call KPLIB_fnc_checkClass};
KPLIB_b_objectsDeco             = KPLIB_b_objectsDeco               select {[( _x select 0)] call KPLIB_fnc_checkClass};
KPLIB_b_vehSupport              = KPLIB_b_vehSupport                select {[( _x select 0)] call KPLIB_fnc_checkClass};
KPLIB_b_squadLight              = KPLIB_b_squadLight                select {[_x] call KPLIB_fnc_checkClass};
KPLIB_b_squadInf                = KPLIB_b_squadInf                  select {[_x] call KPLIB_fnc_checkClass};
KPLIB_b_squadAT                 = KPLIB_b_squadAT                   select {[_x] call KPLIB_fnc_checkClass};
KPLIB_b_squadAA                 = KPLIB_b_squadAA                   select {[_x] call KPLIB_fnc_checkClass};
KPLIB_b_squadRecon              = KPLIB_b_squadRecon                select {[_x] call KPLIB_fnc_checkClass};
KPLIB_b_squadPara               = KPLIB_b_squadPara                 select {[_x] call KPLIB_fnc_checkClass};
KPLIB_b_vehToUnlock             = KPLIB_b_vehToUnlock               select {[( (_x select 0))] call KPLIB_fnc_checkClass};
private _elite_crosscheck = (KPLIB_b_vehLight + KPLIB_b_vehHeavy + KPLIB_b_vehAir + KPLIB_b_vehStatic + KPLIB_b_vehSupport) apply {(_x#0);};
KPLIB_b_vehToUnlockClasses      = KPLIB_b_vehToUnlock               apply {if (_x isEqualType "") then {_x} else {_x#0};};
KPLIB_b_vehToUnlockClasses      = KPLIB_b_vehToUnlockClasses        arrayIntersect _elite_crosscheck;


// Opfor
KPLIB_o_militiaInfantry         = KPLIB_o_militiaInfantry           select {[_x] call KPLIB_fnc_checkClass};
KPLIB_o_militiaVehicles         = KPLIB_o_militiaVehicles           select {[_x] call KPLIB_fnc_checkClass};
KPLIB_o_armyVehicles            = KPLIB_o_armyVehicles              select {[_x] call KPLIB_fnc_checkClass};
KPLIB_o_armyVehiclesLight       = KPLIB_o_armyVehiclesLight         select {[_x] call KPLIB_fnc_checkClass};
KPLIB_o_antiAirVehicles         = KPLIB_o_antiAirVehicles           select {[_x] call KPLIB_fnc_checkClass};
KPLIB_o_tankVehicles            = KPLIB_o_tankVehicles              select {[_x] call KPLIB_fnc_checkClass};
KPLIB_o_battleGrpVehicles       = KPLIB_o_battleGrpVehicles         select {[_x] call KPLIB_fnc_checkClass};
KPLIB_o_battleGrpVehiclesLight  = KPLIB_o_battleGrpVehiclesLight    select {[_x] call KPLIB_fnc_checkClass};
KPLIB_o_troopTransports         = KPLIB_o_troopTransports           select {[_x] call KPLIB_fnc_checkClass};
KPLIB_o_helicopters             = KPLIB_o_helicopters               select {[_x] call KPLIB_fnc_checkClass};
KPLIB_o_slingHelicopters        = KPLIB_o_slingHelicopters               select {[_x] call KPLIB_fnc_checkClass};
KPLIB_o_attackHelicopters       = KPLIB_o_attackHelicopters         select {[_x] call KPLIB_fnc_checkClass};
KPLIB_o_paradropPlanes          = KPLIB_o_paradropPlanes            select {[_x] call KPLIB_fnc_checkClass};
KPLIB_o_planes                  = KPLIB_o_planes                    select {[_x] call KPLIB_fnc_checkClass};
KPLIB_o_statics_H_HMG           = KPLIB_o_statics_H_HMG             select {[_x] call KPLIB_fnc_checkClass};
KPLIB_o_statics_L_HMG           = KPLIB_o_statics_L_HMG             select {[_x] call KPLIB_fnc_checkClass};             
KPLIB_o_statics_H_GMG           = KPLIB_o_statics_H_GMG             select {[_x] call KPLIB_fnc_checkClass};
KPLIB_o_statics_L_GMG           = KPLIB_o_statics_L_GMG             select {[_x] call KPLIB_fnc_checkClass};
KPLIB_o_statics_AT              = KPLIB_o_statics_AT                select {[_x] call KPLIB_fnc_checkClass};
KPLIB_o_statics_AA              = KPLIB_o_statics_AA                select {[_x] call KPLIB_fnc_checkClass};   
KPLIB_o_SAM_radars              = KPLIB_o_SAM_radars                select {[_x] call KPLIB_fnc_checkClass}; 
KPLIB_o_SAM_launchers           = KPLIB_o_SAM_launchers             select {[_x] call KPLIB_fnc_checkClass};
KPLIB_o_SAM_SHORAD              = KPLIB_o_SAM_SHORAD                select {[_x] call KPLIB_fnc_checkClass};
KPLIB_o_boats                   = KPLIB_o_boats                     select {[_x] call KPLIB_fnc_checkClass};
KPLIB_o_artilleryLight          = KPLIB_o_artilleryLight            select {_x params ["_class"]; [_class] call KPLIB_fnc_checkClass};
KPLIB_o_artilleryHeavy          = KPLIB_o_artilleryHeavy            select {_x params ["_class"]; [_class] call KPLIB_fnc_checkClass};
KPLIB_o_artilleryPieces         = (KPLIB_o_artilleryLight + KPLIB_o_artilleryHeavy) apply {_x params ["_class"]; _class};

// Resistance
KPLIB_r_units                   = KPLIB_r_units                     select {[_x] call KPLIB_fnc_checkClass};
KPLIB_r_vehicles                = KPLIB_r_vehicles                  select {[_x] call KPLIB_fnc_checkClass};

// Civilians
KPLIB_c_units                   = KPLIB_c_units                     select {[_x] call KPLIB_fnc_checkClass};
KPLIB_c_vehicles                = KPLIB_c_vehicles                  select {[_x] call KPLIB_fnc_checkClass};

// Misc
KPLIB_transportConfigs          = KPLIB_transportConfigs            select {[_x select 0] call KPLIB_fnc_checkClass};
KPLIB_aiResupplySources         = KPLIB_aiResupplySources           select {[_x] call KPLIB_fnc_checkClass};

/*
    Fetch arrays with only classnames from the blufor preset build arrays
    Beware that all classnames are converted to lowercase. Important for e.g. `in` checks, as it's case-sensitive.
*/
KPLIB_b_inf_classes             = KPLIB_b_infantry                  apply {toLowerANSI (_x select 0)};
KPLIB_b_light_classes           = KPLIB_b_vehLight                  apply {toLowerANSI (_x select 0)};
KPLIB_b_heavy_classes           = KPLIB_b_vehHeavy                  apply {toLowerANSI (_x select 0)};
KPLIB_b_air_classes             = KPLIB_b_vehAir                    apply {toLowerANSI (_x select 0)};
KPLIB_b_static_classes          = KPLIB_b_vehStatic                 apply {toLowerANSI (_x select 0)};
KPLIB_b_deco_classes            = KPLIB_b_objectsDeco               apply {toLowerANSI (_x select 0)};
KPLIB_b_support_classes         = KPLIB_b_vehSupport                apply {toLowerANSI (_x select 0)};
KPLIB_transport_classes         = KPLIB_transportConfigs            apply {toLowerANSI (_x select 0)};

KPLIB_b_inf_classes append (KPLIB_b_squadLight + KPLIB_b_squadInf + KPLIB_b_squadAT + KPLIB_b_squadAA + KPLIB_b_squadRecon + KPLIB_b_squadPara);
KPLIB_b_inf_classes             = KPLIB_b_inf_classes               apply {toLowerANSI _x};
KPLIB_b_inf_classes             = KPLIB_b_inf_classes               arrayIntersect KPLIB_b_inf_classes;

/*
    Opfor squad compositions
*/
KPLIB_o_squadStd        = [KPLIB_o_squadLeader, KPLIB_o_medic, KPLIB_o_machinegunner, KPLIB_o_heavyGunner, KPLIB_o_medic, KPLIB_o_marksman, KPLIB_o_grenadier, KPLIB_o_riflemanLAT];
KPLIB_o_squadInf        = [KPLIB_o_squadLeader, KPLIB_o_medic, KPLIB_o_machinegunner, KPLIB_o_heavyGunner, KPLIB_o_heavyGunner, KPLIB_o_marksman, KPLIB_o_sharpshooter, KPLIB_o_sniper];
KPLIB_o_squadTank       = [KPLIB_o_squadLeader, KPLIB_o_medic, KPLIB_o_machinegunner, KPLIB_o_atSpecialist, KPLIB_o_atSpecialist, KPLIB_o_atSpecialist, KPLIB_o_riflemanLAT, KPLIB_o_riflemanLAT];
KPLIB_o_squadAir        = [KPLIB_o_squadLeader, KPLIB_o_medic, KPLIB_o_machinegunner, KPLIB_o_aaSpecialist, KPLIB_o_aaSpecialist, KPLIB_o_aaSpecialist, KPLIB_o_riflemanLAT, KPLIB_o_riflemanLAT];
KPLIB_o_paratroopers    = [KPLIB_o_squadLeader, KPLIB_o_medic, KPLIB_o_medic, KPLIB_o_machinegunner, KPLIB_o_heavyGunner, KPLIB_o_medic, KPLIB_o_marksman, KPLIB_o_grenadier, KPLIB_o_riflemanLAT, KPLIB_o_riflemanLAT, KPLIB_o_atSpecialist, KPLIB_o_aaSpecialist, KPLIB_o_atSpecialist, KPLIB_o_aaSpecialist];
/*
    Liberation specific collections
*/
KPLIB_buildList         = [[], KPLIB_b_infantry, KPLIB_b_vehLight, KPLIB_b_vehHeavy, KPLIB_b_vehAir, KPLIB_b_vehStatic, KPLIB_b_objectsDeco, KPLIB_b_vehSupport, KPLIB_b_allSquads];
KPLIB_crates            = [KPLIB_b_crateSupply, KPLIB_b_crateAmmo, KPLIB_b_crateFuel];

KPLIB_airSlots          = [];
KPLIB_airSlots append (KPLIB_b_slotHeli + KPLIB_b_slotPlane);
KPLIB_storageBuildings  = [KPLIB_b_smallStorage, KPLIB_b_largeStorage, KPLIB_b_transStorage];
KPLIB_upgradeBuildings  = [KPLIB_b_logiStation, KPLIB_b_airControl];
KPLIB_upgradeBuildings append (KPLIB_b_slotHeli + KPLIB_b_slotPlane);
KPLIB_aiResupplySources append KPLIB_b_mobileRespawns;
KPLIB_aiResupplySources append [KPLIB_b_potato01, KPLIB_b_arsenal];

KPLIB_airSlots          = KPLIB_airSlots            apply {toLowerANSI _x};
KPLIB_crates            = KPLIB_crates              apply {toLowerANSI _x};
KPLIB_storageBuildings  = KPLIB_storageBuildings    apply {toLowerANSI _x};
KPLIB_upgradeBuildings  = KPLIB_upgradeBuildings    apply {toLowerANSI _x};
KPLIB_aiResupplySources = KPLIB_aiResupplySources   apply {toLowerANSI _x};

/*
    Classname collections
*/
// All land vehicle classnames
KPLIB_allLandVeh_classes = [[], [KPLIB_b_potato01]] select (KPLIB_b_potato01 isKindOf "Air");;
{
    KPLIB_allLandVeh_classes append _x;
} forEach [
    KPLIB_o_militiaVehicles apply {toLowerANSI _x},
    KPLIB_o_armyVehicles apply {toLowerANSI _x},
    KPLIB_o_armyVehiclesLight apply {toLowerANSI _x},
    KPLIB_o_antiAirVehicles apply {toLowerANSI _x},
    KPLIB_o_tankVehicles apply {toLowerANSI _x},
    KPLIB_o_battleGrpVehicles apply {toLowerANSI _x},
    KPLIB_o_battleGrpVehiclesLight apply {toLowerANSI _x},
    KPLIB_o_troopTransports apply {toLowerANSI _x},
    KPLIB_b_light_classes,
    KPLIB_b_heavy_classes,
    KPLIB_b_support_classes select {_x isKindOf "Car" || _x isKindOf "Tank"}
];
KPLIB_allLandVeh_classes = KPLIB_allLandVeh_classes arrayIntersect KPLIB_allLandVeh_classes;

// All air vehicle classnames
KPLIB_allAirVeh_classes = [[], [KPLIB_b_potato01]] select (KPLIB_b_potato01 isKindOf "Air");
{
    KPLIB_allAirVeh_classes append _x;
} forEach [KPLIB_o_helicopters apply {toLowerANSI _x}, KPLIB_o_slingHelicopters apply {toLowerANSI _x}, KPLIB_o_attackHelicopters apply {toLowerANSI _x}, KPLIB_o_paradropPlanes apply {toLowerANSI _x},KPLIB_o_planes apply {toLowerANSI _x}, KPLIB_b_air_classes, KPLIB_b_support_classes select {_x isKindOf "Air"}];

// All blufor vehicle (land and air) classnames
KPLIB_b_allVeh_classes = [];
{
    KPLIB_b_allVeh_classes append _x;
} forEach [KPLIB_b_light_classes, KPLIB_b_heavy_classes, KPLIB_b_air_classes, KPLIB_b_static_classes, KPLIB_b_support_classes];

// All opfor vehicle (land and air) classnames
KPLIB_o_allVeh_classes  = [];
{
    KPLIB_o_allVeh_classes append _x;
} forEach [
    KPLIB_o_militiaVehicles,
    KPLIB_o_armyVehicles,
    KPLIB_o_armyVehiclesLight,
    KPLIB_o_antiAirVehicles,
    KPLIB_o_tankVehicles,
    KPLIB_o_battleGrpVehicles,
    KPLIB_o_battleGrpVehiclesLight,
    KPLIB_o_troopTransports,
    KPLIB_o_helicopters,
    KPLIB_o_slingHelicopters,
    KPLIB_o_paradropPlanes,
    KPLIB_o_planes,
    KPLIB_o_SAM_radars,
    KPLIB_o_SAM_launchers,
    KPLIB_o_SAM_SHORAD,
    KPLIB_o_boats,
    KPLIB_o_artilleryPieces
];
KPLIB_o_allVeh_classes = KPLIB_o_allVeh_classes apply {toLowerANSI _x};
KPLIB_o_allVeh_classes = KPLIB_o_allVeh_classes arrayIntersect KPLIB_o_allVeh_classes;

// All opfor statics
KPLIB_o_allStatics_classes = [];
{
    KPLIB_o_allStatics_classes append _x
}forEach [KPLIB_o_statics_H_HMG, KPLIB_o_statics_L_HMG, KPLIB_o_statics_H_GMG, KPLIB_o_statics_L_GMG, KPLIB_o_statics_AT, KPLIB_o_statics_AA];
KPLIB_o_allStatics_classes = KPLIB_o_allStatics_classes apply {toLowerANSI _x};
KPLIB_o_allStatics_classes = KPLIB_o_allStatics_classes arrayIntersect KPLIB_o_allStatics_classes;

// All opfor SAM assets
KPLIB_o_allSAM_classes = [];
{
    KPLIB_o_allSAM_classes append _x
}forEach [KPLIB_o_SAM_radars, KPLIB_o_SAM_launchers, KPLIB_o_SAM_SHORAD];
KPLIB_o_allSAM_classes = KPLIB_o_allSAM_classes apply {toLowerANSI _x};
KPLIB_o_allSAM_classes = KPLIB_o_allSAM_classes arrayIntersect KPLIB_o_allSAM_classes;

// All regular opfor soldier classnames
KPLIB_o_inf_classes = [KPLIB_o_sentry, KPLIB_o_rifleman, KPLIB_o_grenadier, KPLIB_o_squadLeader, KPLIB_o_teamLeader, KPLIB_o_marksman, KPLIB_o_machinegunner, KPLIB_o_heavyGunner, KPLIB_o_medic, KPLIB_o_riflemanLAT, KPLIB_o_atSpecialist, KPLIB_o_aaSpecialist, KPLIB_o_officer, KPLIB_o_sharpshooter, KPLIB_o_sniper,KPLIB_o_engineer];
KPLIB_o_inf_classes = KPLIB_o_inf_classes apply {toLowerANSI _x};

/*
    Vehicle type permission arrays
*/
KPLIB_typeLightClasses = +KPLIB_b_light_classes;
KPLIB_typeHeavyClasses = +KPLIB_b_heavy_classes;
KPLIB_typeAirClasses   = +KPLIB_b_air_classes;
{
    switch (true) do {
        case (_x isKindOf "Tank"):  {KPLIB_typeHeavyClasses    pushBack _x};
        case (_x isKindOf "Air"):   {KPLIB_typeAirClasses      pushBack _x};
        default                     {KPLIB_typeLightClasses    pushBack _x};
    };
} forEach (KPLIB_b_support_classes + [toLowerANSI KPLIB_b_potato01]);

// Classnames of objects which should be ignored when building
KPLIB_collisionIgnoreObjects = [];
{
    KPLIB_collisionIgnoreObjects pushBack _x;
}forEach (KPLIB_b_deco_classes + KPLIB_b_static_classes + (KPLIB_b_support_classes select {!(_x isKindOf "allVehicles")}));

// Military alphabet used for FOBs/outposts and convoys
KPLIB_militaryAlphabet = ["Alpha", "Bravo", "Charlie", "Delta", "Echo", "Foxtrot", "Golf", "Hotel", "India", "Juliet", "Kilo", "Lima", "Mike", "November", "Oscar", "Papa", "Quebec", "Romeo", "Sierra", "Tango", "Uniform", "Victor", "Whiskey", "X-Ray", "Yankee", "Zulu"];

// Misc variables
markers_reset = [99999,99999,0];
zeropos = [0,0,0];
KPLIB_sarWreck = "Land_Wreck_Heli_Attack_01_F";
KPLIB_sarFire = "test_EmptyObjectForFireBig";

if (isServer) then {[format ["----- Preset initialization finished. Time needed: %1 seconds -----", diag_ticktime - _start], "PRESETS"] call KPLIB_fnc_log;};
