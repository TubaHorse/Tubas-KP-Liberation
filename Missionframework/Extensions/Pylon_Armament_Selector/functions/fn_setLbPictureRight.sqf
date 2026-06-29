/*
	File: fn_setLbPictureRight.sqf
	Author: PiG13BR - https://github.com/PiG13BR
	Date: 15/06/2026
	Last Update: 17/06/2026
	License: MIT License - http://www.opensource.org/licenses/MIT

	Description:
        Add icon in the right of the listbox related to ammo main configuration.
        The configuration is decided on the config priority, because missiles can have multipurpose uses.

	Parameter(s):
		_display - pylon manager display [DISPLAY]
        _index - index from magazines combo selection [NUMBER, defaults to 0]
	
	Returns:
		-
*/
params["_control", "_magazine", "_index"];

if (_magazine isEqualTo "") exitWith {};

private _laserBasedAmmo = false;
private _IRBasedAmmo = false;
private _seadBasedAmmo = false;
private _createSubmunition = false;

private _ammo = getText(configFile >> "CfgMagazines" >> _magazine >> "ammo");
if (isClass (configFile >> "CfgAmmo" >> _ammo >> "Components" >> "SensorsManagerComponent" >> "Components")) then {
    _config = [configFile >> "CfgAmmo" >> _ammo >> "Components" >> "SensorsManagerComponent" >> "Components"] call BIS_fnc_returnChildren;
    {
        _value = getText(_config # _forEachIndex >> "componentType");
        switch _value do {
            case "LaserSensorComponent" : {
                // Can target laser
                _laserBasedAmmo = true;
            };
            case "IRSensorComponent" : {
                // Can target IR
                _IRBasedAmmo = true;
            };
            case "PassiveRadarSensorComponent" : {
                // Can target radar
                _seadBasedAmmo = true;
                
            };
            default {};
        };
    }forEach _config;
};

private _airLock = getNumber(configFile >> "CfgAmmo" >> _ammo >> "airLock");
private _laserLock = getNumber(configFile >> "CfgAmmo" >> _ammo >> "laserLock");
private _triggerOnImpact = getNumber(configFile >> "CfgAmmo" >> _ammo >> "triggerOnImpact");
private _topDown = isClass(configFile >> "CfgAmmo" >> _ammo >> "TopDown");
private _laserBomb = _ammo isKindOf "LaserBombCore";

// Try to find words in the magazine's description 
private _isRadar = (toLowerANSI(getText(configFile >> "cfgMagazines" >> _magazine >> "descriptionShort")) find "radar") >= 0;
private _isRocket = (toLowerANSI(getText(configFile >> "cfgMagazines" >> _magazine >> "descriptionShort"))) find "rocket" >= 0;
private _ExternalFuel = (toLowerANSI(getText(configFile >> "cfgMagazines" >> _magazine >> "displayName"))) find "fuel" >= 0; // External Fuel Tank

// Air-to-Air
if (((_airLock == 2) && _IRBasedAmmo) || {(_airLock == 2)}) exitWith {
    _control lbSetPictureRight [_index, "Extensions\Pylon_Armament_Selector\icons\antiair.paa"];
};

// Machine guns
if (_ammo isKindOf "BulletCore") exitWith {
    // i.e: Twin Cannon 20 mm
    _control lbSetPictureRight [_index, "Extensions\Pylon_Armament_Selector\icons\bullets.paa"];
};

// Bombs General Purpose
if (!_laserBasedAmmo && !_IRBasedAmmo && (_ammo isKindOf "BombCore") && (_laserLock == 0)) exitWith {
    _control lbSetPictureRight [_index, "Extensions\Pylon_Armament_Selector\icons\bomb.paa"];
};

// Laser guided
if ((_laserBasedAmmo && _laserLock == 1) || {_laserBomb && _laserLock == 1}) exitWith {
    _control lbSetPictureRight [_index, "a3\ui_f\data\igui\rscingameui\rscoptics\laser_designator_iconlaseron.paa"];
};

// Rockets
if (((getText(configFile >> "CfgAmmo" >> _ammo >> "warheadName") == "HE") && {_laserLock == 0} && (!_laserBasedAmmo) && (!_seadBasedAmmo) && (!_IRBasedAmmo) && (_airLock == 0)) || (_laserBasedAmmo && (_laserLock == 0) && (_triggerOnImpact == 0)) || _isRocket) exitWith {
    _control lbSetPictureRight [_index, "Extensions\Pylon_Armament_Selector\icons\rockets.paa"];
};

// Guided/IR Air-to-surface
if (((_IRBasedAmmo) && {_laserLock == 0}) || {(_IRBasedAmmo) && {_laserLock == 1}} || {(_airLock == 1)} || {_topDown}) exitWith {
    _control lbSetPictureRight [_index, "Extensions\Pylon_Armament_Selector\icons\guided.paa"];
};

// SEAD
if (_seadBasedAmmo || _isRadar) exitWith {
    _control lbSetPictureRight [_index, "Extensions\Pylon_Armament_Selector\icons\radar.paa"];
};

// External Fuel
if (_ExternalFuel) exitWith {
    _control lbSetPictureRight [_index, "Extensions\Pylon_Armament_Selector\icons\fuel.paa"];
};

// Uknown
_control lbSetPictureRight [_index, "a3\ui_f\data\igui\cfg\simpletasks\types\unknown_ca.paa"];