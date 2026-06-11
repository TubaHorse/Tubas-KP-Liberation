// Ampersand's AI Helicopter Decelerate No Climbing (https://github.com/ampersand38/ai-heli-decel-no-climb/tree/main)
if (!isServer) exitWith {};

if (isClass (configFile >> "CfgPatches" >> "AHDNC_main")) exitWith {["AHDNC mod from Ampersand found. Exiting framework.", "AHDNC"] call KPLIB_fnc_log;};

KPLIB_AHDNC_helicopters = [];
KPLIB_AHDNC_helisDecel = [];

[{call KPLIB_fnc_AHDNC_perSecond}, 1, nil] call CBA_fnc_addPerFrameHandler;

{
  [_x, "Init", {
      params ["_heli"];
      KPLIB_AHDNC_helicopters pushBack _heli;
  }, true, [], true] call CBA_fnc_addClassEventHandler;
} forEach [
  "VTOL_Base_F",
  "Helicopter"
];