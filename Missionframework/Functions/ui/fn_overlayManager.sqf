#include "script_components.hpp"
/*
    File: fn_overlayManager.sqf
    Author: -
    Modified by PiG13BR - https://github.com/PiG13BR
    Date: 12/06/2026
    Last Update: 23/07/2026
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Update player overlay.

    Parameter(s):
        _player - player to update the overlay [OBJECT, defaults to player]

    Returns:
        -
*/
params[["_player", player]];

disableSerialization;

KPLIB_ui_notif = "";
KPLIB_supplies = 0;
KPLIB_ammo = 0;
KPLIB_fuel = 0;
//KPLIB_b_airControl_near = false;
//KPLIB_b_logiStation_near = false;
KPLIB_medical_facilities_near = false;

waitUntil { !isNil "synchro_done" };
waitUntil { synchro_done };

if (isNil "cinematic_camera_started") then {cinematic_camera_started = false;};
if (isNil "halojumping") then {halojumping = false;};

private _uiticks = 0;
private _sectorsActiveHint = false;
private _attacked_string = "";
private _nearestSector = "";
private _zone_size = 0;
private _colorzone = "ColorGrey";
private _bar = controlNull;
private _barwidth = 0;

private _overlay = displayNull;
private _overlayVisible = false;
private _showHud = false;
private _showResources = false;
private _currentFob = "";

while {alive _player} do {
    // Get nearest base pos
    private _basePos = [] call KPLIB_fnc_getNearestPlayerBase;
    private _baseDist = _player distance2d _basePos;
    private _currentFob = "";
    
    switch (true) do {
        case (_basePos in KPLIB_player_fobs) : {
            _currentFob = ["", ["FOB", [_basePos] call KPLIB_fnc_getBaseName] joinString " "] select (_baseDist < KPLIB_range_fob);
        };
        case (_basePos in KPLIB_player_outposts) : {
            _currentFob = ["", ["Out", [_basePos] call KPLIB_fnc_getBaseName] joinString " "] select (_baseDist < KPLIB_range_outpost);
        };
    };

    if (_currentFob == "") then {
        private _index = KPLIB_sectors_airport findIf {(_basePos inArea _x) && (_player inArea _x)};
        if (_index >= 0) then {
            private _airportMarker = KPLIB_sectors_airport # _index;
            _currentFob = markerText _airportMarker;
        }
    };

    private _showHud = (alive _player) && {!dialog && {isNull curatorCamera && {!cinematic_camera_started && !halojumping} && {!(_player getVariable ["KPLIB_playerOnRedeploy", false])}}};
    private _visibleMap = visibleMap;

    if (_showHud && {!_overlayVisible}) then {
        "KPLIB_ui" cutRsc ["KPLIB_overlay", "PLAIN", 0];
        _uiticks = 0;
    };
    if (!_showHud && {_overlayVisible}) then {
        "KPLIB_ui" cutText ["", "PLAIN"];
    };

    private _overlay = uiNamespace getVariable ["KPLIB_overlay", displayNull];
    _overlayVisible = !isNull _overlay;

    // Player is at FOB/Outpost
    if ((_currentFob != "") || {_visibleMap}) then {
        _showResources = true;;

        ([_basePos] call KPLIB_fnc_getBaseResources) params ["", "_supplies", "_ammo", "_fuel", "", "", "_hasMedical"];
        
        if (KPLIB_resources_global || {_visibleMap}) then {
            // Overwrite FOB name in global mode
            _currentFob = localize "STR_RESOURCE_GLOBAL";

            KPLIB_supplies = KPLIB_supplies_global;
            KPLIB_ammo = KPLIB_ammo_global;
            KPLIB_fuel = KPLIB_fuel_global;
        } else {
            KPLIB_supplies = _supplies;
            KPLIB_ammo = _ammo;
            KPLIB_fuel = _fuel;
        };
        KPLIB_medical_facilities_near = _hasMedical; // Used in full heal action
    } else {
        _showResources = false;
        KPLIB_supplies = 0;
        KPLIB_ammo = 0;
        KPLIB_fuel = 0;
        KPLIB_medical_facilities_near = false;
    };

    // Overlay is visible
    if (_overlayVisible) then {
        (_overlay displayCtrl CENTRAL_LABEL) ctrlSetText format ["%1", KPLIB_ui_notif];
        (_overlay displayCtrl CENTRAL_LABEL_SHADOW) ctrlSetText format ["%1", KPLIB_ui_notif];

        // Check if the enemy capture marker has moved from its reset pos
        if ((markerPos "opfor_capture_marker") distance2D markers_reset > 100) then {

            private _attackedSector = [markerpos "opfor_capture_marker"] call KPLIB_fnc_getLocationName;

            (_overlay displayCtrl ALERT_BG_PIC) ctrlShow true;
            (_overlay displayCtrl ALERT_LABEL) ctrlSetText _attackedSector;
            (_overlay displayCtrl ALERT_TIMER) ctrlSetText (markerText "opfor_capture_marker");
        } else {
            (_overlay displayCtrl ALERT_BG_PIC) ctrlShow false;
            (_overlay displayCtrl ALERT_LABEL) ctrlSetText "";
            (_overlay displayCtrl ALERT_TIMER) ctrlSetText "";
        };

        // Update resources overlay
        [
            _overlay,
            _showResources,
            _uiticks % 5 == 0,  // update values
            _currentFob         // area title
        ] call KPLIB_fnc_overlayUpdateResources;
        
        if (_uiticks % 25 == 0) then {

            // Check unit cap reached
            if (!isNil "KPLIB_sectors_active" && ([] call KPLIB_fnc_getOpforCap >= KPLIB_cap_enemySide)) then {
                (_overlay displayCtrl ACTIVE_SECTORS_BG_PIC) ctrlShow true;

                // Overload warning
                if (!_sectorsActiveHint) then {
                    [localize 'STR_OVERLOAD_HINT', true, 5] call KPLIB_fnc_hint;
                    _sectorsActiveHint = true;
                };

                private _activeSectors = "<t align='right' color='#e0e000'>" + (localize "STR_ACTIVE_SECTORS") + "<br/>";
                {
                    if (_x in KPLIB_fillers_all) then {continue};
                    _activeSectors = [_activeSectors, markerText _x, "<br/>"] joinString "";
                } forEach KPLIB_sectors_active;
                _activeSectors = [_activeSectors, "</t>"] joinString "";

                // Show active sectors overlay
                (_overlay displayCtrl ACTIVE_SECTORS) ctrlSetStructuredText (parseText _activeSectors);
            } else {
                // Hide active sectors overlay
                (_overlay displayCtrl ACTIVE_SECTORS) ctrlSetStructuredText parseText " ";
                (_overlay displayCtrl ACTIVE_SECTORS_BG_PIC) ctrlShow false;
            };

            // Get nearest active sector
            private _nearestSector = [KPLIB_range_sectorActivation] call KPLIB_fnc_getNearestSector;

            // Don't show up fillers
            if ((_nearestSector != "") && !(_nearestSector in KPLIB_fillers_all)) then {
                private _zone_size = KPLIB_range_sectorCapture;
                if (_nearestSector in KPLIB_sectors_airport) then {
                    // Airport sectors 
                    _zone_size = markerSize _nearestSector;
                    "zone_capture" setMarkerSizeLocal _zone_size;
                    "zone_capture" setMarkerShapeLocal (markerShape _nearestSector);
                    "zone_capture" setMarkerDirLocal (markerDir _nearestSector);
                } else {
                    // Default sectors
                    if (_nearestSector in KPLIB_sectors_capital) then {
                        _zone_size = KPLIB_range_sectorCapture * 1.4;
                        "zone_capture" setMarkerSizeLocal [_zone_size, _zone_size];
                    };
                    "zone_capture" setMarkerSizeLocal [_zone_size, _zone_size];
                    "zone_capture" setMarkerColorLocal "ColorUNKNOWN";
                    "zone_capture" setMarkerShapeLocal "Ellipse";
                    "zone_capture" setMarkerBrushLocal "SolidBorder";
                };

                "zone_capture" setMarkerPosLocal (markerPos _nearestSector);
                private _colorzone = "ColorGrey";
                private _sectorOwner = [markerPos _nearestSector, _zone_size] call KPLIB_fnc_getSectorOwnership;
                if (_sectorOwner == KPLIB_side_player) then {_colorzone = KPLIB_color_player};
                if (_sectorOwner == KPLIB_side_enemy) then {_colorzone = KPLIB_color_enemy};
                if (_sectorOwner == KPLIB_side_resistance) then {_colorzone = "ColorCivilian"};
                "zone_capture" setMarkerColorLocal _colorzone;

                // Capture bar
                private _ratio = [_nearestSector] call KPLIB_fnc_getBluforRatio;
                private _barwidth = 0.084 * safezoneW * _ratio;
                private _bar = _overlay displayCtrl CAPTURE_FRAME_BLUFOR;
                _bar ctrlSetPosition [(ctrlPosition _bar) select 0,(ctrlPosition _bar) select 1,_barwidth,(ctrlPosition _bar) select 3];
                _bar ctrlCommit ([0, 2] select ctrlShown _bar);

                // Show sector's name
                (_overlay displayCtrl LABEL_POINT) ctrlSetText (markerText _nearestSector);
                // Show all sector related controls
                {(_overlay displayCtrl (_x)) ctrlShow true;} forEach OVERLAY_SECTORS_CONTROLS;

                // Capture frame OPFOR color
                (_overlay displayCtrl CAPTURE_FRAME_OPFOR) ctrlSetTextColor KPLIB_captureFrame_opfor_color;
                (_overlay displayCtrl CAPTURE_FRAME_OPFOR) ctrlSetBackgroundColor KPLIB_captureFrame_opfor_color;
                // Capture frame BLUFOR color
                (_overlay displayCtrl CAPTURE_FRAME_BLUFOR) ctrlSetTextColor KPLIB_captureFrame_blufor_color;
                (_overlay displayCtrl CAPTURE_FRAME_BLUFOR) ctrlSetBackgroundColor KPLIB_captureFrame_blufor_color;
                
                // Change the sector's name color
                if (_nearestSector in KPLIB_sectors_player) then {
                    (_overlay displayCtrl LABEL_POINT) ctrlSetTextColor KPLIB_player_sector_color;
                } else {
                    (_overlay displayCtrl LABEL_POINT) ctrlSetTextColor KPLIB_enemy_sector_color;
                };
            } else {
                // Hide all sector related controls
                {(_overlay displayCtrl (_x)) ctrlShow false;} forEach OVERLAY_SECTORS_CONTROLS;
                "zone_capture" setMarkerPosLocal markers_reset; // Reset sector zone marker position
            };
        };
    };

    _uiticks = _uiticks + 1;
    if (_uiticks > 1000) then {_uiticks = 0;};
    uiSleep 0.25;
};