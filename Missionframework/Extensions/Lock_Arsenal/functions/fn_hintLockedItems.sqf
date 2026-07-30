/*
    File: fn_hintLockedItems.sqf
    Author: PiG13BR (https://github.com/PiG13BR)
    Date: 06/07/2026
    Last update: 30/07/2026
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
_items = _items select {_x != ""};

if (count _items < 1) then {
    // Warn
    [parseText (format[["<t size='1.3'>", localize "STR_ARSENAL_UNLOCK_LIST", "</t><br/>", "%1", "<br/>"] joinString "", localize "STR_ARSENAL_UNLOCK_WARN"]), true, 7] call KPLIB_fnc_hint;
} else {
    // Hint locked preset
    [parseText (format[["<t size='1.3'>", localize "STR_ARSENAL_UNLOCK_LIST", "</t><br/>", "%1", "<br/>"] joinString "", _items joinString "<br/>"]), true, 7] call KPLIB_fnc_hint;
}