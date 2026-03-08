// Set up attributes
_center enableRopeAttach false;
_center setMass 10000;
_center allowDamage false;

KPLIB_player_outposts pushBack _center;
publicVariable "KPLIB_player_outposts";

// Remove addAction

[] call KPLIB_fnc_getNearestOutpost