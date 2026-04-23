/*
    This file reads the preset selected on mission parameters.
    Any preset file addition requires adding the path of it in this files that must match the preset number from missions params.
    The default.sqf presets are read before this file in init_presets.sqf.
*/

switch (KPLIB_presetPlayer) do {
    case  1: {[] call compile preprocessFileLineNumbers "Presets\Players\custom.sqf";};
    case  2: {[] call compile preprocessFileLineNumbers "Presets\Players\apex.sqf";};
    case  3: {[] call compile preprocessFileLineNumbers "Presets\Players\baf_mtp.sqf";};
    case  4: {[] call compile preprocessFileLineNumbers "Presets\Players\baf_des.sqf";};
    case  5: {[] call compile preprocessFileLineNumbers "Presets\Players\bwmod.sqf";};
    case  6: {[] call compile preprocessFileLineNumbers "Presets\Players\bwmod_des.sqf";};
    case  7: {[] call compile preprocessFileLineNumbers "Presets\Players\rhs_usaf_wdl.sqf";};
    case  8: {[] call compile preprocessFileLineNumbers "Presets\Players\rhs_usaf_des.sqf";};
    case  9: {[] call compile preprocessFileLineNumbers "Presets\Players\rhs_afrf.sqf";};
    case 10: {[] call compile preprocessFileLineNumbers "Presets\Players\gm_west.sqf";};
    case 11: {[] call compile preprocessFileLineNumbers "Presets\Players\gm_west_win.sqf";};
    case 12: {[] call compile preprocessFileLineNumbers "Presets\Players\gm_east.sqf";};
    case 13: {[] call compile preprocessFileLineNumbers "Presets\Players\gm_east_win.sqf";};
    case 14: {[] call compile preprocessFileLineNumbers "Presets\Players\csat.sqf";};
    case 15: {[] call compile preprocessFileLineNumbers "Presets\Players\csat_apex.sqf";};
    case 16: {[] call compile preprocessFileLineNumbers "Presets\Players\unsung.sqf";};
    case 17: {[] call compile preprocessFileLineNumbers "Presets\Players\cup_baf_desert.sqf";};
    case 18: {[] call compile preprocessFileLineNumbers "Presets\Players\cup_baf_woodland.sqf";};
    case 19: {[] call compile preprocessFileLineNumbers "Presets\Players\cup_usmc_desert.sqf";};
    case 20: {[] call compile preprocessFileLineNumbers "Presets\Players\cup_usmc_woodland.sqf";};
    case 21: {[] call compile preprocessFileLineNumbers "Presets\Players\cup_usa_desert.sqf";};
    case 22: {[] call compile preprocessFileLineNumbers "Presets\Players\cup_usa_woodland.sqf";};
    case 23: {[] call compile preprocessFileLineNumbers "Presets\Players\cup_cdf.sqf";};
    case 24: {[] call compile preprocessFileLineNumbers "Presets\Players\cup_acr_desert.sqf";};
    case 25: {[] call compile preprocessFileLineNumbers "Presets\Players\cup_acr_woodland.sqf";};
    case 26: {[] call compile preprocessFileLineNumbers "Presets\Players\cup_chdkz.sqf";};
    case 27: {[] call compile preprocessFileLineNumbers "Presets\Players\cup_sla.sqf";};
    case 28: {[] call compile preprocessFileLineNumbers "Presets\Players\cup_takistan.sqf";};
    case 29: {[] call compile preprocessFileLineNumbers "Presets\Players\sfp_wdl.sqf";};
    case 30: {[] call compile preprocessFileLineNumbers "Presets\Players\sfp_des.sqf";};
    case 31: {[] call compile preprocessFileLineNumbers "Presets\Players\enoch.sqf";};
    case 32: {[] call compile preprocessFileLineNumbers "Presets\Players\cup_aaf_deserters.sqf";};
    default  {};
};

switch (KPLIB_presetEnemy) do {
    case  1: {[] call compile preprocessFileLineNumbers "Presets\Enemies\custom.sqf";};
    case  2: {[] call compile preprocessFileLineNumbers "Presets\Enemies\apex.sqf";};
    case  3: {[] call compile preprocessFileLineNumbers "Presets\Enemies\rhs_afrf.sqf";};
    case  4: {[] call compile preprocessFileLineNumbers "Presets\Enemies\takistan.sqf";};
    case  5: {[] call compile preprocessFileLineNumbers "Presets\Enemies\islamic_state.sqf";};
    case  6: {[] call compile preprocessFileLineNumbers "Presets\Enemies\sla.sqf";};
    case  7: {[] call compile preprocessFileLineNumbers "Presets\Enemies\aaf.sqf";};
    case  8: {[] call compile preprocessFileLineNumbers "Presets\Enemies\nato.sqf";};
    case  9: {[] call compile preprocessFileLineNumbers "Presets\Enemies\gm_west.sqf";};
    case 10: {[] call compile preprocessFileLineNumbers "Presets\Enemies\gm_west_win.sqf";};
    case 11: {[] call compile preprocessFileLineNumbers "Presets\Enemies\gm_east.sqf";};
    case 12: {[] call compile preprocessFileLineNumbers "Presets\Enemies\gm_east_win.sqf";};
    case 13: {[] call compile preprocessFileLineNumbers "Presets\Enemies\unsung.sqf";};
    case 14: {[] call compile preprocessFileLineNumbers "Presets\Enemies\cup_sla.sqf";};
    case 15: {[] call compile preprocessFileLineNumbers "Presets\Enemies\cup_takistan.sqf";};
    case 16: {[] call compile preprocessFileLineNumbers "Presets\Enemies\cup_chdkz.sqf";};
    case 17: {[] call compile preprocessFileLineNumbers "Presets\Enemies\cup_afrf_msv.sqf";};
    case 18: {[] call compile preprocessFileLineNumbers "Presets\Enemies\cup_afrf_msv_modern.sqf";};
    case 19: {[] call compile preprocessFileLineNumbers "Presets\Enemies\cup_cdf.sqf";};
    case 20: {[] call compile preprocessFileLineNumbers "Presets\Enemies\cup_baf_desert.sqf";};
    case 21: {[] call compile preprocessFileLineNumbers "Presets\Enemies\cup_baf_woodland.sqf";};
    case 22: {[] call compile preprocessFileLineNumbers "Presets\Enemies\cup_aaf.sqf";};
    default  {};
};

switch (KPLIB_presetResistance) do {
    case  1: {[] call compile preprocessFileLineNumbers "Presets\Resistance\custom.sqf";};
    case  2: {[] call compile preprocessFileLineNumbers "Presets\Resistance\apex.sqf";};
    case  3: {[] call compile preprocessFileLineNumbers "Presets\Resistance\rhs_gref.sqf";};
    case  4: {[] call compile preprocessFileLineNumbers "Presets\Resistance\middle_eastern.sqf";};
    case  5: {[] call compile preprocessFileLineNumbers "Presets\Resistance\racs.sqf";};
    case  6: {[] call compile preprocessFileLineNumbers "Presets\Resistance\germany.sqf";};
    case  7: {[] call compile preprocessFileLineNumbers "Presets\Resistance\unsung.sqf";};
    case  8: {[] call compile preprocessFileLineNumbers "Presets\Resistance\cup_takistan.sqf";};
    case  9: {[] call compile preprocessFileLineNumbers "Presets\Resistance\cup_napa.sqf";};
    case  10: {[] call compile preprocessFileLineNumbers "Presets\Resistance\cup_fia.sqf";};
    default  {};
};

switch (KPLIB_presetCivilians) do {
    case  1: {[] call compile preprocessFileLineNumbers "Presets\Civilians\custom.sqf";};
    case  2: {[] call compile preprocessFileLineNumbers "Presets\Civilians\apex.sqf";};
    case  3: {[] call compile preprocessFileLineNumbers "Presets\Civilians\middle_eastern.sqf";};
    case  4: {[] call compile preprocessFileLineNumbers "Presets\Civilians\rds_civ.sqf";};
    case  5: {[] call compile preprocessFileLineNumbers "Presets\Civilians\germany.sqf";};
    case  6: {[] call compile preprocessFileLineNumbers "Presets\Civilians\unsung.sqf";};
    case  7: {[] call compile preprocessFileLineNumbers "Presets\Civilians\cup_takistan.sqf";};
    case  8: {[] call compile preprocessFileLineNumbers "Presets\Civilians\cup_cherno.sqf";};
    case  9: {[] call compile preprocessFileLineNumbers "Presets\Civilians\cup_acw.sqf";};
    default  {};
};