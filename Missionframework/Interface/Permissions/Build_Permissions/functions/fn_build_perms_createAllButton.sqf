#include "..\defines.hpp"
/*
    File: fn_build_perms_createAllButton.sqf
    Author: KP Liberation Dev Team - https://github.com/KillahPotatoes, PiG13BR - https://github.com/PiG13BR
    Date: 17/07/2026
    Last Update: 17/07/2026
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Create "ALL" button to the row

    Parameter(s):
        _display - build permissions menu display [DISPLAY]
        _controlGrp - build permission control group [CONTROL]
        _playerInfo - player's data [ARRAY]

    Returns:
        -
*/
params["_display", "_controlGrp", "_playerInfo"];
private _idx = _playerInfo # 2;

_control = _display ctrlCreate ["RscButton", ((10 * _idx) + 111) + 7, _controlGrp];
_control ctrlSetPosition [((0.075 * 7) - 0.02) * safeZoneW, ((_idx * 0.025) * safezoneH) + 0.0025, (0.035 * safeZoneW), 0.022  * safezoneH];
_control ctrlSetText (localize "STR_PERMISSIONS_ALL");
_control ctrlSetFontHeight FONT_SIZE;
_control ctrlSetTooltip (localize "STR_PERMISSIONS_TOOLTIP_ALL");
_control ctrlCommit 0;

_control setVariable ["KPLIB_playerInfo", _playerInfo];

_control ctrlAddEventHandler ["ButtonClick", {
    params ["_control"];

    private _playerInfo = _control getVariable ["KPLIB_playerInfo", []];
    if (_playerInfo isEqualTo []) exitWith {};

    _playerInfo params ["_uid", "_name", "_idx"];

    private _data = KPLIB_temp_permissions getOrDefault [_uid, []];

    KPLIB_temp_permissions set [_uid, [_name, [true,true,true,true,true,true,true,true]]];

    private _tempControls = KPLIB_temp_controls getOrDefault [_uid, []];
    if (_tempControls isEqualTo []) exitWith {};

    // Update colors
    {
        _x ctrlSetTextColor COLOR_AUTHORIZED;
        _x ctrlSetActiveColor COLOR_AUTHORIZED;
    }forEach _tempControls;

    // Default
    if (_uid == "Default") then {
        {
            private _key = _x;
            private _name = _y # 0;
            
            KPLIB_temp_permissions set [_key, [_name, [true,true,true,true,true,true,true,true]]];

            // Change active text color
            private _tempControls = KPLIB_temp_controls getOrDefault [_key, []];
            if (_tempControls isEqualTo []) exitWith {};

            {
                _x ctrlSetTextColor COLOR_AUTHORIZED;
                _x ctrlSetActiveColor COLOR_AUTHORIZED;
            }forEach _tempControls;
        }forEach KPLIB_temp_permissions;
    };

    // Save directly
    KPLIB_build_permissions = +KPLIB_temp_permissions;
    publicVariable "KPLIB_build_permissions";
}];