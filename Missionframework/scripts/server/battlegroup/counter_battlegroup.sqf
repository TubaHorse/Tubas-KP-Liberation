scriptName "counter_battle_group";

if (isNil "KPLIB_infantryWeight") then {KPLIB_infantryWeight = 33;};
if (isNil "KPLIB_armorWeight") then {KPLIB_armorWeight = 33;};
if (isNil "KPLIB_airWeight") then {KPLIB_airWeight = 33;};

sleep 1800;
private _sleeptime = 0;
private _target_player = objNull;
private _target_pos = "";
while {KPLIB_param_aggressivity >= 0.9 && KPLIB_endgame == 0} do {
    _sleeptime = (1800 + (random 1800)) / (([] call KPLIB_fnc_getOpforFactor) * KPLIB_param_aggressivity);

    if (KPLIB_enemyReadiness >= 80) then {_sleeptime = _sleeptime * 0.75;};
    if (KPLIB_enemyReadiness >= 90) then {_sleeptime = _sleeptime * 0.75;};
    if (KPLIB_enemyReadiness >= 95) then {_sleeptime = _sleeptime * 0.75;};

    sleep _sleeptime;

    waitUntil {sleep 5;
        KPLIB_enemyReadiness >= 70 && {KPLIB_armorWeight >= 50 || KPLIB_airWeight >= 50}
    };

    _target_player = objNull;
    {
        if (
            (KPLIB_armorWeight >= 50 && {(objectParent _x) isKindOf "Tank"})
            || (KPLIB_airWeight >= 50 && {(objectParent _x) isKindOf "Air"})
        ) exitWith {
            _target_player = _x;
        };
    } forEach (allPlayers - entities "HeadlessClient_F");

    if (!isNull _target_player) then {
        _target_pos = [99999, getPos _target_player] call KPLIB_fnc_getNearestSector;
        if !(_target_pos isEqualTo "") then {
            ["", _target_pos] call KPLIB_fnc_battlegroupAttackHeli;
        };
    };
};
