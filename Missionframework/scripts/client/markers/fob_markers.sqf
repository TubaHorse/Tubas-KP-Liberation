scriptName "fob_markers";

// ToDo: make a function, call this (on load saved game, fob/outpost builded, fob/outpost destroyed)

waitUntil {!isNil "KPLIB_saveLoaded"};
waitUntil {!isNil "KPLIB_player_fobs"};
waitUntil {KPLIB_saveLoaded};

uiSleep 3;

private _markers_fob = [];
private _markers_mobilespawns = [];
private _markers_outpost = [];

while {true} do {
    /*
    if (count _markers_fob != count KPLIB_player_fobs) then {
        {deleteMarkerLocal _x;} forEach _markers_fob;
        _markers_fob = [];

        for "_idx" from 0 to ((count KPLIB_player_fobs) - 1) do {
            private _marker = createMarkerLocal [format ["fobmarker%1", _idx], markers_reset];
            _marker setMarkerTypeLocal "b_hq";
            _marker setMarkerSizeLocal [1.5, 1.5];
            _marker setMarkerPosLocal (KPLIB_player_fobs select _idx);
            _marker setMarkerTextLocal format ["FOB %1", KPLIB_fobNames select _idx];
            _marker setMarkerColorLocal "ColorYellow";
            _markers_fob pushback _marker;
        };
    };

    if (count _markers_outpost != count KPLIB_player_outposts) then {
        {deleteMarkerLocal _x;} forEach _markers_outpost;
        _markers_outpost = [];

        for "_idx" from 0 to ((count KPLIB_player_outposts) - 1) do {
            private _marker = createMarkerLocal [format ["outpostmarker%1", _idx], markers_reset];
            _marker setMarkerTypeLocal "b_hq";
            _marker setMarkerSizeLocal [1.2, 1.2];
            _marker setMarkerPosLocal (KPLIB_player_outposts select _idx);
            _marker setMarkerTextLocal format ["Outpost %1", KPLIB_outpostNames select _idx];
            _marker setMarkerColorLocal "ColorYellow";
            _markers_outpost pushback _marker;
        };
    };
    */

    if (KPLIB_param_mobileRespawn) then {
        private _respawn_trucks = [] call KPLIB_fnc_getMobileRespawns;

        if (count _markers_mobilespawns != count _respawn_trucks) then {
            {deleteMarkerLocal _x;} forEach _markers_mobilespawns;
            _markers_mobilespawns = [];

            for "_idx" from 0 to ((count _respawn_trucks) - 1) do {
                _marker = createMarkerLocal [format ["mobilespawn%1", _idx], markers_reset];
                _marker setMarkerTypeLocal "mil_end";
                _marker setMarkerColorLocal "ColorYellow";
                _markers_mobilespawns pushback _marker;
            };
        };

        if (count _respawn_trucks == count _markers_mobilespawns) then {
            for "_idx" from 0 to ((count _markers_mobilespawns) - 1) do {
                (_markers_mobilespawns select _idx) setMarkerPosLocal getPos (_respawn_trucks select _idx);
                (_markers_mobilespawns select _idx) setMarkerTextLocal format ["%1 %2", localize "STR_RESPAWN_TRUCK", [_respawn_trucks select _idx] call KPLIB_fnc_getMobileRespawnName];
            };
        };
    };

    sleep 5;
};
