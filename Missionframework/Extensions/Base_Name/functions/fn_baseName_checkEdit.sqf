#include "..\defines.hpp"
/*
    File: fn_baseName_checkEdit.sqf
    Author: PiG13BR - https://github.com/PiG13BR
    Date: 13/04/2026
    Last Update: 14/04/2026
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Check name typed in the edit box

    Parameter(s):
        _editCtrl - edit control [CONTROL]
        _text - text typed [STRING]

    Returns:
    -
*/
params["_editCtrl", "_text"];

if (_text isEqualTo "") exitWith {};

// Controls
private _display = (ctrlParent _editCtrl);
private _confirmCtrl = _display displayCtrl IDC_CONFIRM_BUTTON;

private _base = localNamespace getVariable ["KPLIB_basePosition", [0,0,0]];

// Always the first letter upper case
private _firstLetter = toUpperANSI(_text select [0, 1]);
_text = _firstLetter + (_text select [1]);
_editCtrl ctrlSetText _text;
//if (count _text == 1) then {_text = toUpperANSI _text; _editCtrl ctrlSetText _text;};

private _blockConfirm = false;

switch (true) do {
    case (_base in KPLIB_player_outposts) : {
        private _match = (KPLIB_outpostNames apply {toLowerANSI _x}) find (toLowerANSI _text);
        if (_match >= 0) then {
            _blockConfirm = true;
        };
    };
    default {
        private _match = (KPLIB_fobNames apply {toLowerANSI _x}) find (toLowerANSI _text);
        if (_match >= 0) then {
            _blockConfirm = true;
        };
    }
};

if (_blockConfirm) then {
    _confirmCtrl ctrlEnable false;
    _confirmCtrl ctrlSetTooltip (localize "STR_BASE_NAME_UNIQUE_WARN");
} else {
    _confirmCtrl ctrlEnable true;
    _confirmCtrl ctrlSetTooltip "";
};
