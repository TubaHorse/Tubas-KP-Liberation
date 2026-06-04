// Create sector mines
["KPLIB_createSectorMines", {

	if (isNil "KPLIB_sectorMinesHash") then {
		KPLIB_sectorMinesHash = createHashMap;
	};

	if (isNil "KPLIB_savedMinesPosHash") then {
		KPLIB_savedMinesPosHash = createHashMap;
	};

	// Check for spawned mines positions in this sector
	if !(_this in KPLIB_savedMinesPosHash) then {
		// Create new minefield
		_this call KPLIB_fnc_createMines;
	} else {
		// Respawn the minefields
		_this call KPLIB_fnc_createSavedMines;
	};
}] call CBA_fnc_addEventHandler;

// Delete sector mines
["KPLIB_deleteSectorMines", {

    private _sectorMines = KPLIB_sectorMinesHash getOrDefault [_this, []];
	if (_sectorMines isEqualTo []) exitWith {};

	// Save active mines only
	private _sectorAPMines = (_sectorMines # 0) select {mineActive _x};
	private _sectorATMines = (_sectorMines # 1) select {mineActive _x};
	KPLIB_savedMinesPosHash set [_this, [_sectorAPMines apply {ASLToAGL (ATLtoASL getPosATL _x)}, _sectorATMines apply {ASLToAGL (ATLtoASL getPosATL _x)}]]; 
	{
		[_x] call KPLIB_fnc_despawnObject;
    }forEach (_sectorAPMines + _sectorATMines);

    KPLIB_sectorMinesHash deleteAt _sector // Clear sector key
}] call CBA_fnc_addEventHandler;