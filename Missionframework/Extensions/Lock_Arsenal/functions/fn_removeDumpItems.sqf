/*
    File: fn_removeDumpItems.sqf
    Author: PiG13BR (https://github.com/PiG13BR)
    Date: 05/07/2026
    Last Update: 05/07/2026
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Remove items from supply dump

    Parameter(s):
        _items - items to add [ARRAY]

    Returns:
        -
*/
params["_items"];

{
    private _item = _x;
    KPLIB_supply_VirtualItems deleteAt (KPLIB_supply_VirtualItems findIf {(_x # 0) == _item})
}forEach _items;
publicVariable "KPLIB_supply_VirtualItems";