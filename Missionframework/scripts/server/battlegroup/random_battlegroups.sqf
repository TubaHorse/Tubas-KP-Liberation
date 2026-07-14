scriptName "random_battlegroups";

sleep (900 / KPLIB_param_aggressivity);
private _sleeptime = 0;
while {KPLIB_param_aggressivity > 0.9 && KPLIB_endgame == 0} do {
    _sleeptime =  (1800 + (random 1800)) / (([] call KPLIB_fnc_getOpforFactor) * KPLIB_param_aggressivity);

    if (KPLIB_enemyReadiness >= 80) then {_sleeptime = _sleeptime * 0.75;};
    if (KPLIB_enemyReadiness >= 90) then {_sleeptime = _sleeptime * 0.75;};
    if (KPLIB_enemyReadiness >= 95) then {_sleeptime = _sleeptime * 0.75;};

    sleep _sleeptime;

    if (!isNil "KPLIB_last_battlegroup_time") then {
        waitUntil {
            sleep 5;
            diag_tickTime > (KPLIB_last_battlegroup_time + (2100 / KPLIB_param_aggressivity))
        };
    };

    if (
        (count (allPlayers - entities "HeadlessClient_F") >= 4) // ToDo: mission parameter to select min. amount of players to start an attack
        && {KPLIB_enemyReadiness >= (60 - (5 * KPLIB_param_aggressivity))}
        && {[] call KPLIB_fnc_getOpforCap < KPLIB_cap_battlegroup}
        && {diag_fps > 15.0}
    ) then {
        private _playerAirports = KPLIB_sectors_player select {_x in KPLIB_sectors_airport};
        if ((random 100 <= KPLIB_enemyReadiness) && ((count _playerAirports) > 0)) then {
            // Raid Random Airport
            private _sector = selectRandom _playerAirports;
            private _targetPos = markerPos _sector;

            // Paradrop or heli transport + slingload vehicles
            if (random 100 <= 50) then {
                ["", _targetPos, ""] call KPLIB_fnc_battlegroupParatroopers;
                sleep 3;
                if (KPLIB_param_unitCap >= 1) then {
                    ["", _targetPos, ""] call KPLIB_fnc_battlegroupParatroopers;
                };
                sleep 3;
                if (KPLIB_enemyReadiness >= 75) then {
                    ["", _targetPos, ""] call KPLIB_fnc_battlegroupParatroopers;
                };
            } else {
                ["", _targetPos, "", false] call KPLIB_fnc_battlegroupTransportHeli;
                sleep 3;
                if (KPLIB_param_unitCap >= 1) then {
                    ["", _targetPos, "", false] call KPLIB_fnc_battlegroupTransportHeli;
                };
                sleep 3;
                if (KPLIB_enemyReadiness >= 75) then {
                    ["", _targetPos, ""] call KPLIB_fnc_battlegroupAttackHeli;
                };
                ["", _targetPos, "", false] call KPLIB_fnc_battlegroupSlingLoadVeh;
                sleep 3;
                if (KPLIB_param_unitCap >= 1) then {
                    ["", _targetPos, "", false] call KPLIB_fnc_battlegroupSlingLoadVeh;
                };
            };
            ["KPLIB_reinfIncoming", ["", _targetPos]] call CBA_fnc_globalEvent;
        } else {
            // Random battlegroup for random sector closer to the front
            [] call KPLIB_fnc_spawnBattlegroup;
        }
    };
};
