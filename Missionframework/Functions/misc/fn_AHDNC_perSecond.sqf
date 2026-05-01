/*
* Author: Ampersand
* Check for AI helicopters that are decelerating
*
* Arguments:
* 0: Args <nil>
* 1: Handler ID <NUMBER>
*
* Return Value:
* None
*
* ahdnc_main_fnc_perSecond
*
*/

#define MIN_SPEED 60;
#define MIN_ALT 20;

if (isClass (configFile >> "CfgPatches" >> "AHDNC_main")) exitWith {["AHDNC mod from Ampersand found. Exiting framework.", "AHDNC"] call KPLIB_fnc_log};

params ["", "_pfhId"];

private _time = cba_missionTime;

{
    private _heli = _x;
    private _speed = speed _heli;
    private _altitude = getPosASL _heli # 2;
    private _radAlt = getPos _heli # 2;
    
    if (
        isNull _heli
        || {_heli getVariable ["KPLIB_AHDNC_disable", false]}
        || {isPlayer currentPilot _heli}
        || {_speed < MIN_SPEED}
        || {_radAlt < MIN_ALT}
        || {(getTerrainHeightASL (_heli modelToWorld [0, 500, 0]) + 20) > _altitude}
        || {(getTerrainHeightASL (_heli modelToWorld [0, 300, 0]) + 20) > _altitude}
        || {(getTerrainHeightASL (_heli modelToWorld [0, 100, 0]) + 20) > _altitude}
    ) then {
        KPLIB_AHDNC_helisDecel deleteAt (KPLIB_AHDNC_helisDecel find _heli);
        continue;
    };
    if !(
        local _heli
        && {alive _heli}
        && {isEngineOn _heli}
        && {isNull remoteControlled driver _heli}
    ) then {
        KPLIB_AHDNC_helisDecel deleteAt (KPLIB_AHDNC_helisDecel find _heli);
        continue;
    };
    
    if (KPLIB_AHDNC_helisDecel findIf {_heli == _x # 0} > -1) then {
        continue;
    };

    private _altitude = getPosASL _heli # 2;
    
    private _speedAlt = _heli getVariable ["KPLIB_AHDNC_speedAlt", [-1, -1, -1]];
    _speedAlt params ["_lastSpeed", "_lastAltitude", "_lastTime"];
    if (_lastTime + 2 < _time) then {
        // First check ever
        _heli setVariable ["KPLIB_AHDNC_speedAlt", [_speed, _altitude, _time]];
        continue;
    };
    
    if (
        _lastSpeed > _speed && // Decelerating
        {_lastAltitude < _altitude} && // Ascending
        {vectorDir _heli # 2 > 0} // Nose up
    ) then {
        KPLIB_AHDNC_helisDecel pushBack [_heli, _speed, _altitude, _time];
    };
    
    // Start pfh
    if (count KPLIB_AHDNC_helisDecel > 0 && {isNil "KPLIB_AHDNC_PfID"}) then {
        KPLIB_AHDNC_PfID = [{[] call KPLIB_fnc_AHDNC_perFrame}, 0, cba_missionTime] call CBA_fnc_addPerFrameHandler;
    };

    // Update speed altitude and time
    _heli setVariable ["KPLIB_AHDNC_speedAlt", [_speed, _altitude, _time]];

} forEachReversed KPLIB_AHDNC_helicopters; 
