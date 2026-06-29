#include "..\defines.hpp"
/*
	File: fn_handleMagazineCombo.sqf
	Author: PiG13BR - https://github.com/PiG13BR
	Date: 15/06/2026
	Last Update: 28/06/2026
	License: MIT License - http://www.opensource.org/licenses/MIT

	Description:
        Handles magazines combobox selector

	Parameter(s):
		_control - combo box [CONTROL]
	
	Returns:
		-
*/
params ["_control", "_lbCurSel", "_lbSelection"];

private _display = ctrlParent _control;

_control setVariable ["PIG_PAS_comboBoxCurSel", _lbCurSel];

[_display, _lbCurSel] call KPLIB_fnc_fillMagazinesListBox;