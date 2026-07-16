/*
    File: fn_hintTowerInfo.sqf
    Author: PiG13BR (https://github.com/PiG13BR)
    Date: 15/07/2026
    Last update: 15/07/2026
    License: MIT License - http://www.opensource.org/licenses/MIT
    
    Description:
        Hint tower's information for the player

    Parameter(s):
        _sector - tower sector to get info [STRING, defaults to ""]
    
    Returns:
        -
*/
params["_sector"];

localNamespace setVariable ["KPLIB_towerInfoCooldown", true];
localNamespace setVariable ["KPLIB_clickedTower", _sector];

private _mk = createMarkerLocal [format["towerradius_%1", _sector], markerPos _sector];
_mk setMarkerShapeLocal "ELLIPSE";
_mk setMarkerBrushLocal "Border";
_mk setMarkerSizeLocal [KPLIB_range_radioTowerScan, KPLIB_range_radioTowerScan];
_mk setMarkerColorLocal KPLIB_color_enemy;
[{
    deleteMarkerLocal _this;
    localNamespace setVariable ["KPLIB_towerInfoCooldown", false];
}, _mk, 5] call CBA_fnc_waitAndExecute;

// Hint tower's info (QRF and sectors reinforcements)
private _militaryBases = (KPLIB_sectors_military - KPLIB_sectors_player) select {((markerPos _x) distance2D (markerPos _sector)) <= KPLIB_range_radioTowerScan};

if (count _militaryBases > 0) then {
    _militaryBases = _militaryBases apply {markerText _x};

    [parseText (format[
        [
            "<t size='1.5'>", "QRF INFO", "</t><br/>", 
            "<t size='1.2' color='#FF0000'>", "%1", "</t><br/>"
        ] joinString "", _militaryBases joinString "<br/>"
    ]), true, 5] call KPLIB_fnc_hint;

    KPLIB_drawEH = ((findDisplay 12) displayCtrl 51) ctrlAddEventHandler ["Draw", {
        private _tower = localNamespace getVariable ["KPLIB_clickedTower", ""];
        private _militaryBases = (KPLIB_sectors_military - KPLIB_sectors_player) select {((markerPos _x) distance2D (markerPos _tower)) <= KPLIB_range_radioTowerScan};
            
        // Draw lines between tower > bases
        {
            private _milPos = markerPos _x;
            (_this # 0) drawLine [markerPos _tower, _milPos, KPLIB_enemy_sector_color];
        }forEach _militaryBases;
    }];
    [{((findDisplay 12) displayCtrl 51) ctrlRemoveEventHandler ["Draw", KPLIB_drawEH]}, [], 5] call CBA_fnc_waitAndExecute;
} else {
    [parseText (format[
        [
            "<t size='1.3'>", "QRF INFO", "</t><br/>", "<t size='1.2' color='#00ff62'>", "%1", "<br/>"
        ] joinString "", localize "STR_TOWER_NO_MILITARY_BASES"
    ]), true, 5] call KPLIB_fnc_hint;
};