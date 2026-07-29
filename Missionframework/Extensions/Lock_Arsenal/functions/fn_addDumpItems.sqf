/*
    File: fn_addDumpItems.sqf
    Author: PiG13BR (https://github.com/PiG13BR)
    Date: 05/07/2026
    Last Update: 05/07/2026
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Add items to supply dump

    Parameter(s):
        _items - items to add [ARRAY]

    Returns:
        -
*/
params["_items"];

{KPLIB_supply_VirtualItems pushBack [_x, -1]}forEach _items;
publicVariable "KPLIB_supply_VirtualItems";