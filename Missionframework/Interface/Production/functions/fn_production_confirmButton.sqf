#include "..\defines.hpp"
/*
    File: fn_production_confirmButton.sqf
    Author: PiG13BR - https://github.com/PiG13BR
    Date: 15/11/2025
    Last Update: 01/08/2026
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Handles the confirm button. Changes the production.

    Parameter(s):
        -

    Returns:
        -
*/
params["_control"];

private _display = ctrlParent _control;

// Changes production
private _newProduction = localNameSpace getVariable ["KPLIB_production_new", 0];
private _sector = localNamespace getVariable ["KPLIB_production_SectorSelected", ""];

if (_sector isNotEqualTo "") then {
    ["KPLIB_changeFactoryProduction", [_sector, _newProduction, clientOwner]] call CBA_fnc_serverEvent;
};

// Update colors
private _prodLbControl = _display displayCtrl IDC_PRODUCTION_LISTBOX;
private _listcolor = COLOR_NOT_DEFINED;
switch _newProduction do {
    case PRODUCING_AMMO: {_listcolor = COLOR_AMMO;}; // Ammo
    case PRODUCING_FUEL: {_listcolor = COLOR_FUEL;}; // Fuel
    case PRODUCING_NOTHING: {_listcolor = COLOR_NEUTRAL;};  // None
    default {_listcolor = COLOR_SUPPLY;};   // Supply
};

private _index = lbCurSel _prodLbControl;
_prodLbControl lbSetColor [_index, _listcolor];