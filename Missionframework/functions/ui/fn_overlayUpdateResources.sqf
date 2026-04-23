#include "script_components.hpp"
/*
    File: fn_overlayUpdateResources.sqf
    Author: KP Liberation Dev Team - https://github.com/KillahPotatoes
    Date: 2020-05-01
    Last Update: 2026-04-12
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Update resources overlay.

    Parameter(s):
        _overlay        - Overlay display                               [DISPLAY, defaults to displayNull]
        _show           - Should the resources controls be shown        [BOOL, defaults to true]
        _updateValues   - Should values controls be updated with data   [BOOL, defaults to true]
        _resourceArea   - Name of resource area to be shown             [STRING, defaults ""]

    Returns:
        Resources overlay visible [BOOL]
*/

params [
    ["_overlay", displayNull, [displayNull]],
    ["_show", true, [true]],
    ["_updateValues", true, [true]],
    ["_resourceArea", "", [""]]
];

if (isNull _overlay) exitWith {
    ["Null overlay given"] call BIS_fnc_error;
    false
};
if (!_show) exitWith {
    {
        (_overlay displayCtrl _x) ctrlShow false;
    } forEach OVERLAY_RSC_IDCS;
    false
};

if (_updateValues) then {
    if (_resourceArea find "Out" >= 0) then {
        // Outpost
        (_overlay displayCtrl IDC_OVERLAY_RSC_LABEL_FOB) ctrlSetText toUpperANSI _resourceArea;
        (_overlay displayCtrl IDC_OVERLAY_RSC_LABEL_SUPPLIES) ctrlSetText str floor KPLIB_supplies;
        (_overlay displayCtrl IDC_OVERLAY_RSC_LABEL_AMMO) ctrlSetText str floor KPLIB_ammo;
        (_overlay displayCtrl IDC_OVERLAY_RSC_LABEL_FUEL) ctrlSetText str floor KPLIB_fuel;
        (_overlay displayCtrl IDC_OVERLAY_RSC_LABEL_UNITCAP) ctrlSetText ([unitcap, "/", [] call KPLIB_fnc_getLocalCap] joinString "");
        (_overlay displayCtrl IDC_OVERLAY_RSC_LABEL_ALERT) ctrlSetText ([round KPLIB_enemyReadiness, "%"] joinString "");
        (_overlay displayCtrl IDC_OVERLAY_RSC_LABEL_CIVREP) ctrlSetText ([KPLIB_civ_rep,"%"] joinString "");
        
        /*
            (_overlay displayCtrl IDC_OVERLAY_RSC_LABEL_UNITCAP) ctrlShow false;
            (_overlay displayCtrl IDC_OVERLAY_RSC_LABEL_PLANE) ctrlShow false;
            (_overlay displayCtrl IDC_OVERLAY_RSC_LABEL_HELIPAD) ctrlShow false;
            (_overlay displayCtrl IDC_OVERLAY_RSC_LABEL_INTEL) ctrlShow false;
            (_overlay displayCtrl IDC_OVERLAY_RSC_PIC_UNITCAP) ctrlShow false;
            (_overlay displayCtrl IDC_OVERLAY_RSC_PIC_UNITCAP_SHADOW) ctrlShow false;
            (_overlay displayCtrl IDC_OVERLAY_RSC_PIC_PLANE) ctrlShow false;
            (_overlay displayCtrl IDC_OVERLAY_RSC_PIC_PLANE_SHADOW) ctrlShow false;
            (_overlay displayCtrl IDC_OVERLAY_RSC_PIC_HELIPAD) ctrlShow false;
            (_overlay displayCtrl IDC_OVERLAY_RSC_PIC_HELIPAD_SHADOW) ctrlShow false;
            (_overlay displayCtrl IDC_OVERLAY_RSC_PIC_INTEL) ctrlShow false;
            (_overlay displayCtrl IDC_OVERLAY_RSC_PIC_INTEL_SHADOW) ctrlShow false;

            // Replace ctrls pos
            private _unitCapLabelPos = ctrlPosition (_overlay displayCtrl IDC_OVERLAY_RSC_LABEL_UNITCAP);
            private _heliLabelPos = ctrlPosition (_overlay displayCtrl IDC_OVERLAY_RSC_LABEL_HELIPAD);
            private _unitCapPicPos = ctrlPosition (_overlay displayCtrl IDC_OVERLAY_RSC_PIC_UNITCAP);
            private _heliPicPos = ctrlPosition (_overlay displayCtrl IDC_OVERLAY_RSC_PIC_HELIPAD);
            (_overlay displayCtrl IDC_OVERLAY_RSC_LABEL_ALERT) ctrlSetPosition _unitCapLabelPos;
            (_overlay displayCtrl IDC_OVERLAY_RSC_LABEL_ALERT) ctrlCommit 0;
            (_overlay displayCtrl IDC_OVERLAY_RSC_LABEL_CIVREP) ctrlSetPosition _heliLabelPos;
            (_overlay displayCtrl IDC_OVERLAY_RSC_LABEL_CIVREP) ctrlCommit 0;
            (_overlay displayCtrl IDC_OVERLAY_RSC_PIC_ALERT) ctrlSetPosition _unitCapPicPos;
            (_overlay displayCtrl IDC_OVERLAY_RSC_PIC_ALERT) ctrlCommit 0;
            (_overlay displayCtrl IDC_OVERLAY_RSC_PIC_ALERT_SHADOW)  ctrlSetPosition _unitCapPicPos;
            (_overlay displayCtrl IDC_OVERLAY_RSC_PIC_ALERT_SHADOW) ctrlCommit 0;
            (_overlay displayCtrl IDC_OVERLAY_RSC_PIC_CIVREP) ctrlSetPosition _heliPicPos;
            (_overlay displayCtrl IDC_OVERLAY_RSC_PIC_CIVREP) ctrlCommit 0;
            (_overlay displayCtrl IDC_OVERLAY_RSC_PIC_CIVREP_SHADOW) ctrlSetPosition _heliPicPos;
            (_overlay displayCtrl IDC_OVERLAY_RSC_PIC_CIVREP_SHADOW) ctrlCommit 0;
        */

        (_overlay displayCtrl IDC_OVERLAY_RSC_LABEL_PLANE) ctrlSetTextColor [0.4, 0.4, 0.4, 1];
        (_overlay displayCtrl IDC_OVERLAY_RSC_LABEL_PLANE) ctrlSetText "N/A";
        (_overlay displayCtrl IDC_OVERLAY_RSC_LABEL_HELIPAD) ctrlSetTextColor [0.4, 0.4, 0.4, 1];
        (_overlay displayCtrl IDC_OVERLAY_RSC_LABEL_HELIPAD) ctrlSetText "N/A";
        (_overlay displayCtrl IDC_OVERLAY_RSC_LABEL_INTEL) ctrlSetTextColor [0.4, 0.4, 0.4, 1];
        (_overlay displayCtrl IDC_OVERLAY_RSC_LABEL_INTEL) ctrlSetText "N/A";
        (_overlay displayCtrl IDC_OVERLAY_RSC_PIC_PLANE) ctrlSetTextColor [0.4, 0.4, 0.4, 1];
        (_overlay displayCtrl IDC_OVERLAY_RSC_PIC_HELIPAD) ctrlSetTextColor [0.4, 0.4, 0.4, 1];
        (_overlay displayCtrl IDC_OVERLAY_RSC_PIC_INTEL) ctrlSetTextColor [0.4, 0.4, 0.4, 1];
        
    } else {

        // Global or Fob
        (_overlay displayCtrl IDC_OVERLAY_RSC_LABEL_FOB) ctrlSetText toUpperANSI _resourceArea;
        (_overlay displayCtrl IDC_OVERLAY_RSC_LABEL_SUPPLIES) ctrlSetText str floor KPLIB_supplies;
        (_overlay displayCtrl IDC_OVERLAY_RSC_LABEL_AMMO) ctrlSetText str floor KPLIB_ammo;
        (_overlay displayCtrl IDC_OVERLAY_RSC_LABEL_FUEL) ctrlSetText str floor KPLIB_fuel;
        (_overlay displayCtrl IDC_OVERLAY_RSC_LABEL_UNITCAP) ctrlSetText ([unitcap, "/", [] call KPLIB_fnc_getLocalCap] joinString "");
        (_overlay displayCtrl IDC_OVERLAY_RSC_LABEL_HELIPAD) ctrlSetText ([KPLIB_heli_count, "/", KPLIB_heli_slots] joinString "");
        (_overlay displayCtrl IDC_OVERLAY_RSC_LABEL_PLANE) ctrlSetText ([KPLIB_plane_count, "/", KPLIB_plane_slots] joinString "");
        (_overlay displayCtrl IDC_OVERLAY_RSC_LABEL_ALERT) ctrlSetText ([round KPLIB_enemyReadiness, "%"] joinString "");
        (_overlay displayCtrl IDC_OVERLAY_RSC_LABEL_CIVREP) ctrlSetText ([KPLIB_civ_rep,"%"] joinString "");
        (_overlay displayCtrl IDC_OVERLAY_RSC_LABEL_INTEL) ctrlSetText str round resources_intel;

        (_overlay displayCtrl IDC_OVERLAY_RSC_LABEL_PLANE) ctrlSetTextColor [0.8, 0.8, 0.8, 1];
        (_overlay displayCtrl IDC_OVERLAY_RSC_LABEL_HELIPAD) ctrlSetTextColor [0.8, 0.8, 0.8, 1];
        (_overlay displayCtrl IDC_OVERLAY_RSC_LABEL_INTEL) ctrlSetTextColor [0, 0.45, 0.95, 1];
        (_overlay displayCtrl IDC_OVERLAY_RSC_PIC_UNITCAP) ctrlSetTextColor [0.8, 0.8, 0.8, 1];
        (_overlay displayCtrl IDC_OVERLAY_RSC_PIC_PLANE) ctrlSetTextColor [0.8, 0.8, 0.8, 1];
        (_overlay displayCtrl IDC_OVERLAY_RSC_PIC_HELIPAD) ctrlSetTextColor [0.8, 0.8, 0.8, 1];
        (_overlay displayCtrl IDC_OVERLAY_RSC_PIC_INTEL) ctrlSetTextColor [0, 0.45, 0.95, 1];
    };

    // Show all controls
    {
        (_overlay displayCtrl _x) ctrlShow true;
    } forEach OVERLAY_RSC_IDCS;


    private _color_readiness = [0.8,0.8,0.8,1];
    if ( KPLIB_enemyReadiness >= 25 ) then { _color_readiness = [0.8,0.8,0,1] };
    if ( KPLIB_enemyReadiness >= 50 ) then { _color_readiness = [0.8,0.6,0,1] };
    if ( KPLIB_enemyReadiness >= 75 ) then { _color_readiness = [0.8,0.3,0,1] };
    if ( KPLIB_enemyReadiness >= 100 ) then { _color_readiness = [0.8,0,0,1] };

    (_overlay displayCtrl IDC_OVERLAY_RSC_PIC_ALERT) ctrlSetTextColor _color_readiness;
    (_overlay displayCtrl IDC_OVERLAY_RSC_LABEL_ALERT) ctrlSetTextColor _color_readiness;

    private _color_reputation = [0.8,0.8,0.8,1];
    if (KPLIB_civ_rep >= 25) then {_color_reputation = [0,0.7,0,1]};
    if (KPLIB_civ_rep <= -25) then {_color_reputation = [0.7,0,0,1]};

    (_overlay displayCtrl IDC_OVERLAY_RSC_PIC_CIVREP) ctrlSetTextColor _color_reputation;
    (_overlay displayCtrl IDC_OVERLAY_RSC_LABEL_CIVREP) ctrlSetTextColor _color_reputation;

};

true
