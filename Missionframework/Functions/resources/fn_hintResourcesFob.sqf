/*
    File: fn_hintResurcesFob.sqf
    Author: PiG13BR (https://github.com/PiG13BR)
    Date: 06/07/2026
    Last update: 06/07/2026
    License: MIT License - http://www.opensource.org/licenses/MIT
    
    Description:
        Display the resources list for the player of selected fob position

    Parameter(s):
        _fob - fob position to get resources info [STRING, defaults to ""]
    
    Returns:
        -
*/

params[["_fob", [0,0,0], []]];

if (_fob isEqualTo [0,0,0]) exitWith {false};

private _resources = [_fob] call KPLIB_fnc_getBaseResources;
_resources params ["", "_supply", "_ammo", "_fuel"];

[parseText (format[[
    "<t size='1.3'>", localize "STR_FOB_RESOURCES_LIST", "</t><br/>",
    "<img image='Images\ui_manpo.paa'/>", " ", "%1", 
    "<br/>", // Spaces
    "<img image='Images\ui_ammo.paa'/>", " ", "%2", 
    "<br/>", // Spaces
    "<img image='Images\ui_fuel.paa'/>", " ", "%3"
] joinString "", _supply, _ammo, _fuel]), true, 7] call KPLIB_fnc_hint;