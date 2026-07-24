/*  
    File: fn_getFighterSpawnPoint.sqf  
    Author: PiG13BR - (https://github.com/PiG13BR)
    Date: 20/07/2026 
    Last Update: 20/07/2026  
    License: MIT License - http://www.opensource.org/licenses/MIT  
  
    Description:  
        Gets a random opfor air spawn point marker name   
  
    Parameter(s):  
        _pos - position used as reference to spawn fighter [POSITION, defaults to [0,0,0]]  
  
    Returns:  
        Opfor fighter spawn point [STRING]  
*/  

params [   
    ["_pos", [0,0,0], [[]], [2, 3]]   
];
   
// Only check for opfor spawn points which aren't used already in the current session   
private _spawnsToCheck = KPLIB_sectors_airSpawn;   
private _possibleSpawns = []; 
  
{  
    private _valid = true;  
    private _current = _x;  
      
    // Make sure that there is an opfor sector in sensible range to spawn  
    if (_valid) then {  
        if ((KPLIB_sectors_all - KPLIB_sectors_player) findIf {((markerPos _current) distance2D (markerPos _x)) < 4000} < 0) then {  
            _valid = false;  
        };  
    }; 
     
    // Make sure that there is no blufor sector in sensible range to spawn  
    if (_valid) then {  
        if ((KPLIB_sectors_player) findIf {((markerPos _current) distance2D (markerPos _x)) < 4000} >= 1) then {  
            _valid = false;  
        };  
    }; 
  
    // Make sure that there is no blufor unit inside min dist to spawn  
    if (_valid) then {  
        if (([markerpos _current, 1500, KPLIB_side_player] call KPLIB_fnc_getUnitsCount) > 0) then {  
            _valid = false;  
        };  
    }; 
 
    // Marker far from the target position
    if (_pos isNotEqualTo [0,0,0]) then {
        if (_valid) then { 
            if (((markerpos _current) distance2D _pos) < 3500) then {  
                _valid = false;  
            };  
        }; 
    };

    // Pushback marker if valid 
    if (_valid) then {  
        _possibleSpawns pushBack _current;  
    }; 
} forEach _spawnsToCheck;  
 
if (_possibleSpawns isEqualTo []) exitWith {["No opfor fighter spawn point found", "WARNING"] call KPLIB_fnc_log; ""}; 
 
// Return random spawn point  
(selectRandom _possibleSpawns);