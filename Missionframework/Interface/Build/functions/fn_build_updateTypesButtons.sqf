#include "..\defines.hpp"
/*
    File: fn_build_updateTypesButtons.sqf
    Author: PiG13BR - https://github.com/PiG13BR
    Date: 12/06/2025
    Last Update: 13/06/2026
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Update building types button controls with tooltips

    Parameter(s):
        _display - build menu display [DISPLAY, defaults to findDisplay IDD_BUILD_MENU]

    Returns:
        -
*/

params[["_display", findDisplay IDD_BUILD_MENU]];

private _infImgCtrl = _display displayCtrl IDC_INFANTRY_IMG;
private _transportsImgCtrl = _display displayCtrl IDC_TRANSPORT_IMG;
private _combatvehImgCtrl = _display displayCtrl IDC_COMBATVEH_IMG;
private _aerialImgCtrl = _display displayCtrl IDC_AERIAL_IMG;
private _defenceImgCtrl = _display displayCtrl IDC_DEFENCE_IMG;
private _buildingsImgCtrl = _display displayCtrl IDC_BUILDING_IMG;
private _supportImgCtrl = _display displayCtrl IDC_SUPPORT_IMG;
private _squadImgCtrl = _display displayCtrl IDC_SQUAD_IMG;

// The images are in front of the buttons
_infImgCtrl ctrlSetTooltip (localize "STR_BUILD_TOOLTIP_INFANTRY");
_transportsImgCtrl ctrlSetTooltip (localize "STR_BUILD_TOOLTIP_TRANSPORT");
_combatvehImgCtrl ctrlSetTooltip (localize "STR_BUILD_TOOLTIP_COMBATVEH");
_aerialImgCtrl ctrlSetTooltip (localize "STR_BUILD_TOOLTIP_AERIAL");
_defenceImgCtrl ctrlSetTooltip (localize "STR_BUILD_TOOLTIP_DEFENCES");
_buildingsImgCtrl ctrlSetTooltip (localize "STR_BUILD_TOOLTIP_BUILDINGS");
_supportImgCtrl ctrlSetTooltip (localize "STR_BUILD_TOOLTIP_SUPPORT");
_squadImgCtrl ctrlSetTooltip (localize "STR_BUILD_TOOLTIP_SQUAD");