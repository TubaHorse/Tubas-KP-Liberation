#include "..\defines.hpp"
/*
    File: fn_general_perms_createActiveText.sqf
    Author: KP Liberation Dev Team - https://github.com/KillahPotatoes, PiG13BR - https://github.com/PiG13BR
    Date: 16/07/2026
    Last Update: 17/07/2026
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Crate active text on general permission display

    Parameter(s):
        _display - general permissions display [DISPLAY]
        _controlGrp - group control to add the active text [CONTROL]
        _playerInfo - player's info [ARRAY]
        _column - column to add active text [NUMBER]
        _permission - permission ID [NUMBER]
        _text - permission text [STRING]
        _tooltip - permission tooltip [STRING]

    Returns:
        -
*/

params ["_display", "_controlGrp", "_playerInfo", "_column", "_permission", "_text", "_tooltip"];
private _uid = _playerInfo # 0;
private _idx = _playerInfo # 2;

private _control = _display ctrlCreate ["RscActiveText", ((10 * _idx) + 111) + _column, _controlGrp];
_control ctrlSetPosition [0.072 * _column * safeZoneW, (_idx * 0.025) * safezoneH, 0.072 * safeZoneW, 0.025  * safezoneH];
_control ctrlSetText _text;
_control ctrlSetFontHeight FONT_SIZE;
_control ctrlSetTooltip _tooltip;

_control setVariable ["KPLIB_playerInfo", _playerInfo];
_control setVariable ["KPLIB_permissionId", _permission];

// Collect control
if (_uid in KPLIB_temp_controls) then {
    private _tempControls = KPLIB_temp_controls getOrDefault [_uid, []];
    _tempControls pushBack _control;
    KPLIB_temp_controls set [_uid, _tempControls]
} else {
    KPLIB_temp_controls set [_uid, [_control]]
};

// Set color based on permission
private _data = KPLIB_general_permissions getOrDefault [_uid, []];
private _permsData = _data param [1, [false,false,false,false,false,false]];
private _perm = _permsData # _permission;
if (_perm) then {
    _control ctrlSetTextColor COLOR_AUTHORIZED;
    _control ctrlSetActiveColor COLOR_AUTHORIZED;
} else {
    _control ctrlSetTextColor COLOR_DENIED;
    _control ctrlSetActiveColor COLOR_DENIED;
};

_control ctrlCommit 0;

// Active text click
_control ctrlAddEventHandler ["ButtonClick", {
    params ["_control"];

    private _playerInfo = _control getVariable ["KPLIB_playerInfo", []];
    if (_playerInfo isEqualTo []) exitWith {};

    _playerInfo params ["_uid", "_name", "_idx"];

    private _data = KPLIB_temp_permissions getOrDefault [_uid, []];

    private _permissions = _data param [1, [false,false,false,false,false,false]];
    private _permID = _control getVariable ["KPLIB_permissionId", -1];

    private _perm = _permissions # _permID;
    private _color = COLOR_DENIED;
    private _permitted = if !(_perm) then {
        _color = COLOR_AUTHORIZED;
        true
    } else {
        false
    };

    // Check for default setting
    if (_uid != "Default") then {
        private _defaultData = KPLIB_temp_permissions getOrDefault ["Default", []];
        private _defaultPerms = _defaultData param [1, [false,false,false,false,false,false]];
        private _selDefaultPerm = _defaultPerms # _permID;
        if (_selDefaultPerm && !_permitted) then {
            _permitted = _selDefaultPerm; // Force it back if it's true
            _color = COLOR_AUTHORIZED;
        };
    };

    _control ctrlSetTextColor _color;
    _control ctrlSetActiveColor _color;

    // Set permission
    _permissions set [_permID, _permitted];
    KPLIB_temp_permissions set [_uid, [_name, _permissions]];

    // Apply changes on players flying air vehicles
    private _playerObj = _uid call BIS_fnc_getUnitByUID;
    if (_playerObj isNotEqualTo objNull) then {
        if ((_permID == HELICOPTER_PERM) || (_permID == PLANE_PERM)) then {
            private _vehicle = (vehicle _playerObj);
            if (typeOf(vehicle _playerObj) isKindOf "Air") then {
                if ((currentPilot _vehicle == _playerObj) && ((_vehicle unitTurret (_playerObj)) isNotEqualTo [-1])) then {
                    _playerObj action ["SuspendVehicleControl", _vehicle];
                };
            };
        };
    };

    // Default 
    if (_uid == "Default") then {
        {
            private _key = _x;
            private _permissions = (_y # 1);
            
            _permissions set [_permID, _permitted];
            KPLIB_temp_permissions set [_key, [_y # 0, _permissions]];

            // Change active text color
            private _tempControls = KPLIB_temp_controls getOrDefault [_key, []];
            if (_tempControls isEqualTo []) exitWith {};

            private _controlTemp = _tempControls # _permID;
        
            _controlTemp ctrlSetTextColor _color;
            _controlTemp ctrlSetActiveColor _color;
        }forEach KPLIB_temp_permissions;
    };

    // Save directly
    KPLIB_general_permissions = +KPLIB_temp_permissions;
    publicVariable "KPLIB_general_permissions";
}];