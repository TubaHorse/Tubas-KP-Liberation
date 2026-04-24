/*
* Author: Ampersand
* For all AI helicopters that are decelerating, force it level
*
* Arguments:
* 0: Time <NUMBER>
* 1: Handler ID <NUMBER>
*
* Return Value:
* None
*
* ahdnc_main_fnc_perFrame
*
*/

#define MIN_SPEED 60;
#define MIN_ALT 20;

params ["_time", "_pfhId"];

if (isGamePaused) exitWith {};

{
    if (isNil KPLIB_AHDNC_PfID || {count KPLIB_AHDNC_helisDecel == 0}) exitWith {
        [KPLIB_AHDNC_PfID] call CBA_fnc_removePerFrameHandler;
        KPLIB_AHDNC_PfID = nil;
    };
    
    _x params ["_heli", "_initSpeed", "_initAltitude", "_initTime"];
    
    private _speed = speed _heli;
    private _altitude = getPosASL _heli # 2;
    private _pitch = vectorDir _heli # 2;
    
    if (
        _altitude < _initAltitude // Descending
        || {_speed < MIN_SPEED} // Deceleration complete
        || {_pitch <= 0} // Nose down
    ) then {
        KPLIB_AHDNC_helisDecel deleteAt _forEachIndex;
        continue;
    };

    private _altClimbed = _altitude - _initAltitude;
    private _velocityZ = (velocity _heli # 2) max 1;
    private _force = _altClimbed^2 * _velocityZ^2 * _pitch * getMass _heli * -0.01;

    _heli addForce [
        [0, 0, _force],
        getCenterOfMass _heli
    ]; // Force it level
} forEachReversed KPLIB_AHDNC_helisDecel;
  