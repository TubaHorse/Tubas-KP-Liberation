/*
	File: fn_removeTurretWeapons.sqf
	Author: PiG13BR - https://github.com/PiG13BR
	Date: 14/06/2026
	Last Update: 20/07/2026
	License: MIT License - http://www.opensource.org/licenses/MIT

	Description:
		Remove remnant weapons from the setPylonLoadout command.
		This is a workaround for shitty mods

	Parameter(s):
		_aircraft - aircraft to remove remnant weapons [OBJECT]
		_pylonIndex - pylon index to remove the weapon [NUMBER]
		_turret - turret to remove the weapon [ARRAY]
	
	Returns:
		-
*/
params["_aircraft", "_pylonIndex", "_turret"];

private _allPylonWeapons = (getPylonMagazines _aircraft) apply {
	getText(configFile >> "CfgMagazines" >> _x >> "pylonWeapon")
};

private _pylonWeapon = _allPylonWeapons param [_pylonIndex - 1, ""];

if (_pylonWeapon != "") then {
		private _leftovers = (_aircraft weaponsTurret _turret) select {
		private _weaponState = weaponState [_aircraft, _turret, _x];
		private _mag = _weaponState # 3;
		private _reloadingPhase = _weaponState # 5;

		(_x find "mastersafe" < 0) && ((_mag == "") || (_reloadingPhase < 0))
	};

	{
		private _weapon = _x;
		if (_aircraft turretLocal _turret) then { 
			_aircraft removeWeaponTurret [_weapon, _turret]; 
		};
	}forEach (_leftovers + [_pylonWeapon]);
};