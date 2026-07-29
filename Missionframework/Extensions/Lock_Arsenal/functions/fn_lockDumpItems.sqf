/*
    File: fn_lockDumpItems.sqf
    Author: PiG13BR (https://github.com/PiG13BR)
    Date: 05/07/2026
    Last Update: 05/07/2026
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
        Get lock arsenal preset and apply it if the linked sector wasn't captured.
        The locked items will be removed from the supply dump.

    Parameter(s):
        _items - items to add [ARRAY]

    Returns:
        -
*/

// Case sensitive failsafe
private _sectorsPlayer = KPLIB_sectors_player apply {toLowerANSI _x};

{
    private _sector = _x;
    private _items = _y;

    if !(toLowerANSI(_sector) in _sectorsPlayer) then {
        {
            private _item = toLowerANSI _x;
            KPLIB_supply_VirtualItems deleteAt ((KPLIB_supply_VirtualItems apply {toLowerANSI (_x # 0)}) findIf {_x == _item});
        }forEach _items;
    };
}forEach KPLIB_sector_arsenalLink;