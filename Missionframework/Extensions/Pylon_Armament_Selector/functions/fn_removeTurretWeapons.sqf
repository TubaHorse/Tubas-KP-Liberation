/*
	File: fn_removeTurretWeapons.sqf
	Author: 654wak654 (ACE) PiG13BR - https://github.com/PiG13BR
	Date: 14/06/2026
	Last Update: 14/06/2026
	License: MIT License - http://www.opensource.org/licenses/MIT

	Description:
		Remove remnant weapons from the setPylonLoadout command

	Parameter(s):
		_aircraft - aircraft to remove remnant weapons [OBJECT]
	
	Returns:
		-
*/
params["_aircraft"];

{ 
	private _turret = _x;
	private _weapons = _aircraft weaponsTurret _turret; 
	{
		// "configFile" >> "CfgMagazines" >> _x >> "pylonWeapon" 
		private _weaponState = weaponState [_aircraft, _turret, _x]; 
		if ((_weaponState # 3 == "") && (_x find "mastersafe" < 0)) then { 
			if (_aircraft turretLocal _turret) then { 
				_aircraft removeWeaponTurret [_x, _turret]; 
			} 
		}; 
	}forEach _weapons; 
}forEach ([[-1]] + allTurrets _aircraft);