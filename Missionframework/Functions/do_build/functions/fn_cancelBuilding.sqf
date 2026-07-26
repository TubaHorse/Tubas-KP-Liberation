#include "..\defines.hpp"
/*
    File: fn_cancelBuilding.sqf
    Author: PiG13BR (https://github.com/PiG13BR)
    Date: 11/11/2025
    Last update: 24/07/2026
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Cancel building

    Parameter(s)
        _object - preplaced object to delete [OBJECT, defaults to objNull]
        _player - player object that cancelled building [OBJECT, defaults to player]

    Returns:
        -
*/
params[["_object", objNull, [objnull]], ["_player", player, [objNull]]];

if (isNull _object) exitWith {};

// Resources management
private _buildType = localNamespace getVariable ["KPLIB_BUILD_buildType", 1];
private _buildPos = ([] call KPLIB_fnc_getNearestBuildPos) # 0;
if (_buildType != BUILDTYPE_FACTORY_STORAGE) then {
    private _buildSelected = localNamespace getVariable ["KPLIB_BUILD_itemToBuild", []];
    ["KPLIB_restoreResources", [_buildSelected, _buildPos, _player]] call CBA_fnc_serverEvent;
};

// Remove spheres
private _spheres = (localNamespace getVariable ["KPLIB_BUILD_areaSpheres", []]);
{deleteVehicle _x}forEach _spheres;

// Delete the object
deleteVehicle _object;

// Remove EachFrame MEH
if !(isNil "KPLIB_doBuild_pfhID") then {
    [KPLIB_doBuild_pfhID] call CBA_fnc_removePerFrameHandler;
};

// Restore isBuilding variable
_player setVariable ["KPLIB_BUILD_isBuilding", false, true];

// Cancel build camera assist
[_player, false] call KPLIB_fnc_buildCameraAssist;

// Remove actions
{_player removeAction _x}forEach (_player getVariable ["KPLIB_BUILD_playerActions", []]);

// "Delete" variables
[_player] call KPLIB_fnc_deleteBuildVariables;

[localize "STR_CANCEL_HINT", false, 3] call KPLIB_fnc_hint;
