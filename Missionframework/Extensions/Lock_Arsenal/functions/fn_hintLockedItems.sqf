/*
    File: fn_hintLockedItems.sqf
    Author: PiG13BR (https://github.com/PiG13BR)
    Date: 06/07/2026
    Last update: 06/07/2026
    License: MIT License - http://www.opensource.org/licenses/MIT
    
    Description:
        Shows the unlockable arsenal items for the player for an especific sector

    Parameter(s):
        _sector - sector to get arsenal unlockable items [STRING, defaults to ""]
    
    Returns:
        -
*/
params[["_sector", "", [""]]];

if (_sector isEqualTo "") exitWith {false};

private _items = KPLIB_sector_arsenalLink get _sector;
_items = _items apply {
    private _name = "";
    if (isClass(configFile >> "cfgWeapons" >> _x)) then {
        _name = getText(configFile >> "cfgWeapons" >> _x >> "displayName");
    };

    if (isClass(configFile >> "cfgMagazines" >> _x)) then {
        _name = getText(configFile >> "cfgMagazines" >> _x >> "displayName");
    };

    if (isClass(configFile >> "cfgVehicles" >> _x)) then {
        _name = getText(configFile >> "cfgVehicles" >> _x >> "displayName");
    };
    _name
}; 
[parseText (format[["<t size='1.3'>", localize "STR_ARSENAL_UNLOCK_LIST", "</t><br/>", "%1", "<br/>"] joinString "", _items joinString "<br/>"]), true, 7] call KPLIB_fnc_hint;