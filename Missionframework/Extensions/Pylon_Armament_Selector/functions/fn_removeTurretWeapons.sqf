/*
	File: fn_removeTurretWeapons.sqf
	Author: 654wak654 (ACE), PiG13BR - https://github.com/PiG13BR
	Date: 14/06/2026
	Last Update: 18/07/2026
	License: MIT License - http://www.opensource.org/licenses/MIT

	Description:
		Remove remnant weapons from the setPylonLoadout command

	Parameter(s):
		_aircraft - aircraft to remove remnant weapons [OBJECT]
	
	Returns:
		-
*/
params["_aircraft"];

// Get pylon weapon from the selected loadout
private _weaponsPylons = [];
{
	_weaponsPylons pushBackUnique (getText(configFile >> "CfgMagazines" >> _x >> "pylonWeapon"));
}forEach (getPylonMagazines _aircraft); 

{ 
	private _turret = _x;
	private _weapons = _aircraft weaponsTurret _turret; 
	{
		private _weapon = _x;

		private _weaponState = weaponState [_aircraft, _turret, _weapon]; 
		if (!(_weapon in _weaponsPylons) && ((_weaponState # 3 == "") || (_weapon find "mastersafe" < 0))) then { 
			if (_aircraft turretLocal _turret) then { 
				_aircraft removeWeaponTurret [_weapon, _turret]; 
			} 
		}; 
	}forEach _weapons; 
}forEach ([[-1]] + allTurrets _aircraft);