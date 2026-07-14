#include "..\defines.hpp"
/*
    File: fn_build_getEntryText.sqf
    Author: KP Liberation Dev Team - https://github.com/KillahPotatoes, PiG13BR - https://github.com/PiG13BR, FernandimModelador https://github.com/FernandimModelador
    Date: 10/11/2025
    Last Update: 14/07/2026
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Get item's entry text to display on the listNbox

    Parameter(s):
        _class - item classname [STRING, defaults to ""]
        _cfg - config path to find [CONFIG, defauls to configFile >> "cfgVehicles"]

    Returns:
        Entry Text [STRING]
*/

params[["_class", "", [""]],  ["_buildType", 7], ["_cfg", configFile >> "cfgVehicles"]];

if (_class isEqualTo "") exitWith {};

private _entryText = getText (_cfg >> _class >> "displayName");

if (!isNil {_customName}) then {
    if (_customName != "") then {
        _entryText = _customName;
    };
};

if (_class in KPLIB_b_mobileRespawns) then {
    if (KPLIB_param_mobileRespawn) then {
        if (KPLIB_b_mobileRespawn isEqualType "") then {
            if (_class == KPLIB_b_mobileRespawn) then {
                _entryText = localize "STR_RESPAWN_TRUCK";
            };
        } else {
            {
                if (_class == _x) exitWith {
                    _entryText = "MSP " + getText (configFile >> "CfgVehicles" >> _x >> "displayName");
                };
            } forEach KPLIB_b_mobileRespawns;
        };
    };
};

if (_buildType == BUILDTYPE_SUPPORT) then {
    if (_class in KPLIB_b_slotHeli) then {
        _entryText = localize "STR_HELI_SLOT";
    };

    if (_class in KPLIB_b_slotPlane) then {
        _entryText = localize "STR_PLANE_SLOT";
    };

    // Support names
    switch (_class) do {
        case KPLIB_b_fobBox: {_entryText = localize "STR_FOB_BOX";};
        case KPLIB_b_arsenal: {if (KPLIB_param_mobileArsenal) then {_entryText = localize "STR_ARSENAL_BOX";};};
        case KPLIB_b_fobTruck: {_entryText = localize "STR_FOB_TRUCK";};
        case KPLIB_b_outpostBox: {_entryText = localize "STR_OUTPOST_BOX";};
        case KPLIB_b_smallStorage: {_entryText = localize "STR_SMALL_STORAGE";};
        case KPLIB_b_largeStorage: {_entryText = localize "STR_LARGE_STORAGE";};
        case KPLIB_b_transStorage: {_entryText = localize "STR_TRANS_STORAGE";};
        case KPLIB_b_logiStation: {_entryText = localize "STR_RECYCLE_BUILDING";};
        case KPLIB_b_airControl: {_entryText = localize "STR_AIRCONTROL_BUILDING";};             
        case KPLIB_b_supplyDump : {_entryText = localize "STR_SUPPLY_DUMP_ENTRY";};
        case KPLIB_b_barrack : {_entryText = localize "STR_BARRACK_ENTRY";};
        case KPLIB_b_medicalFacility : {_entryText = localize "STR_MEDICAL_ENTRY";};
        default {};
    };
} else {
    switch (_class) do {
        case "Flag_White_F": {_entryText = localize "STR_INDIV_FLAG";};
        default {};
    }
};

_entryText