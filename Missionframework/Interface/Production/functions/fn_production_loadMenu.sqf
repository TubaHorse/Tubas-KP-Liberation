#include "..\defines.hpp"
/*
    File: fn_production_loadMenu.sqf
    Author: KP Liberation Dev Team - https://github.com/KillahPotatoes, PiG13BR - https://github.com/PiG13BR
    Date: 10/11/2025
    Last Update: 01/08/2026
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Load the production menu

    Parameter(s):
        _display - production menu display [DISPLAY, defaults to findDisplay IDD_PRODUCTION_MENU]

    Returns:
        -
*/

params[["_display", findDisplay IDD_PRODUCTION_MENU]];

// Controls
private _mapControl = _display displayCtrl IDC_MAP;
private _prodLbControl = _display displayCtrl IDC_PRODUCTION_LISTBOX;
private _productionBoostCtrl = _display displayCtrl IDC_PRODUCTION_BOOST_TEXT;

lbClear _prodLbControl;
private _keysSorted = (keys KPLIB_production);
_keysSorted sort true;
{
    private _data = KPLIB_production getOrDefault [_x, ""];
    private _markerText = _data # 0;
    _prodLbControl lbAdd _markerText; // Add marker text
    _prodLbControl lbSetData [_forEachIndex, _x]; // Save key as data
} forEach _keysSorted;

ctrlMapAnimClear _mapControl;

if (lbCurSel _prodLbControl == -1) then {
    _prodLbControl lbSetCurSel 0;
};

private _listcolor = COLOR_NOT_DEFINED;
{
    private _storageArray = _y # 2;
    private _typeOfResource = _y # 6;
    if ((count _storageArray) > 0) then {
        switch _typeOfResource do {
            case PRODUCING_AMMO: {_listcolor = COLOR_AMMO;}; // Ammo
            case PRODUCING_FUEL: {_listcolor = COLOR_FUEL;}; // Fuel
            case PRODUCING_NOTHING: {_listcolor = COLOR_NEUTRAL;};  // None
            default {_listcolor = COLOR_SUPPLY;};   // Supply
        };
    };

    _prodLbControl lbSetColor [_forEachIndex, _listcolor];
} forEach KPLIB_production;

_productionBoostCtrl ctrlSetText (format [localize "STR_PRODUCTION_BOOST", round (30 + (10 * KPLIB_param_difficulty))]);