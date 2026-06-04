/*
    File: fn_createSavedMines.sqf
    Author: KP Liberation Dev Team - https://github.com/KillahPotatoes, PiG13BR - https://github.com/PiG13BBR
    Date: 02/06/2026
    Last Update: 03/06/2026
    License: MIT License - http://www.opensource.org/licenses/MIT

    Description:
       Create saved mines of a sector

    Parameter(s):
        _sector - sector to spawn mines [STRING]

    Returns:
        Spawned mines [ARRAY]
*/
params["_sector"];

private _APMinesObj = [];
private _ATMinesObj = [];

// Spawn AP Mines
private _APMinesPos = (KPLIB_savedMinesPosHash get _sector) # 0;
if (count _APMinesPos > 0) then {
	// AP Mine
	{
		_x set [2,0]; // Reset Z pos
		private _mine = createMine [KPLIB_o_APMine, _x, [], 0];
		_APMinesObj pushBack _mine;
		
		KPLIB_side_enemy revealMine _mine;
		KPLIB_side_civilian revealMine _mine;
		if ((KPLIB_side_resistance getFriend KPLIB_side_enemy) > 0) then {KPLIB_side_resistance revealMine _mine};
	}forEach _APMinesPos;
};

// Spawn AT Mines
private _ATMinesPos = (KPLIB_savedMinesPosHash get _sector) # 1;
if (count _ATMinesPos > 0) then {
	{
		_x set [2,0]; // Reset Z pos
		private _mine = createMine [KPLIB_o_ATMine, _x, [], 0];
		_ATMinesObj pushBack _mine;
		
		KPLIB_side_enemy revealMine _mine;
		KPLIB_side_civilian revealMine _mine;
		if ((KPLIB_side_resistance getFriend KPLIB_side_enemy) > 0) then {KPLIB_side_resistance revealMine _mine};
	}forEach _ATMinesPos;
};

KPLIB_sectorMinesHash set [_sector, [_APMinesObj, _ATMinesObj]];
KPLIB_savedMinesPosHash set [_sector, [_APMinesObj apply {ASLToAGL (ATLtoASL getPosATL _x)}, _ATMinesObj apply {ASLToAGL (ATLtoASL getPosATL _x)}]];

[_APMinesObj, _ATMinesObj]