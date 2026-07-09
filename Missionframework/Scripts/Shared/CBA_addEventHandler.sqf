// Log
["KPLIB_generateLog", {
    params["_text", "_title"];
    [_text, _title] call KPLIB_fnc_log;
}] call CBA_fnc_addEventHandler;

// Battlegroup notifications
["KPLIB_reinfIncoming", {
    params[["_spawn_marker", ""], "_objPos"];

    [_spawn_marker, _objPos] call KPLIB_fnc_battlegroupIncoming;

}] call CBA_fnc_addEventHandler;

// Add FOB Build Actions
["KPLIB_fobActions", {
    params["_fobObject"];

    if ((typeOf _fobObject) isEqualTo KPLIB_b_fobBox) then {
        [_fobObject] call KPLIB_fnc_setFobMass;
        [_fobObject] call KPLIB_fnc_setLoadableViV;
    };

    [_fobObject] call KPLIB_fnc_addActionsFob;
}] call CBA_fnc_addEventHandler;

// Add Outpost Build Actions
["KPLIB_outpostActions", {
    params["_outpostObject"];

    if ((typeOf _outpostObject) isEqualTo KPLIB_b_outpostBox) then {
        [_outpostObject] call KPLIB_fnc_setFobMass;
        [_outpostObject] call KPLIB_fnc_setLoadableViV;
    };

    [_outpostObject] call KPLIB_fnc_addActionsOutpost;
}] call CBA_fnc_addEventHandler;

// Add Unflip action
["KPLIB_addUnflipAction", {
    _this spawn {
        waitUntil {sleep 1; alive player};

        _this addAction [
            "<t color='#FFFF00'>" + localize "STR_UNFLIP" + "</t> <img size='2' image='Images\ui_flipveh.paa'/>", 
            {
                params ["_veh"];

                if (!isNull _veh) then {
                    _veh setPosATL ((getPosATL _veh) vectorAdd [0, 0, 0.5]);
                    _veh setVectorUp surfaceNormal position _veh;
                };
            }, 
            "",
            -950,
            true,
            true,
            "",
            toString {
                !(_this getVariable ['KPLIB_BUILD_isBuilding', false]) &&
                {[5] call KPLIB_fnc_hasPermission} &&
                {isNull objectParent _this} &&
                {(count crew _target) == 0} &&
                {(locked _target == 0 || locked _target == 1)} &&
                {speed _target < 2} &&
                {(vectorUp _target) vectorCos (surfaceNormal getPos _target) < 0.5}
            }
        ];
    }
}] call CBA_fnc_addEventHandler;

// Add Recycle Action
["KPLIB_addRecycleAction", {
    _this spawn {
        waitUntil {sleep 1; alive player};
        _this addAction [
            "<t color='#FFFF00'>" + localize "STR_RECYCLE" + "</t> <img size='2' image='Images\ui_recycle.paa'/>", 
            {
                if ((_this # 0) getVariable ["KPLIB_preplaced", false]) exitWith {[localize "STR_PREPLACED_ERROR", true, 2] call KPLIB_fnc_hint;};
                
                [_this # 0] call KPLIB_fnc_recycle_createMenuRsc
            }, 
            "", 
            -900, 
            true, 
            true, 
            "", 
            toString{
                alive _originalTarget &&
                {!(_originalTarget getVariable ['KPLIB_BUILD_isBuilding', false])} &&
                {isNull objectParent _originalTarget} &&
                {[4] call KPLIB_fnc_hasPermission} &&
                {KPLIB_player_fobs isNotEqualTo [] && {(_originalTarget distance2d ([] call KPLIB_fnc_getNearestFob)) < KPLIB_range_fob}} &&
                {(({alive _x} count (crew _originalTarget)) == 0) || {unitIsUAV _originalTarget}} &&
                //{locked _originalTarget == -1 || {locked _originalTarget == 0} || {locked _originalTarget == 1}} &&
                {(((toLowerANSI (typeOf _originalTarget)) in KPLIB_storageBuildings) && (_originalTarget getVariable ["KPLIB_fobStorage", false])) || {!((toLowerANSI (typeOf _originalTarget)) in KPLIB_storageBuildings)}} &&
                {(((attachedObjects _originalTarget) select {!isNull _originalTarget}) isEqualTo []) || {(typeOf _originalTarget) == "rhsusf_mkvsoc"}} // ignore null objects left by Advanced Towing (https://github.com/sethduda/AdvancedTowing/pull/46)
            },
            ((boundingBoxReal _this) # 2) * 1.2
        ];

        // Add Delete Action for dead structures 
        _this addAction [
            "<t color='#FFFF00'>" + localize "STR_BUILD_ACTION_DELETE" + "</t> <img size='2' image='Functions\do_build\icons\cross.paa'/>", 
            {
                deleteVehicle (_this # 0);
            }, 
            "", 
            -1000, 
            true, 
            true, 
            "", 
            toString{
                !alive _originalTarget &&
                {!(_originalTarget getVariable ['KPLIB_BUILD_isBuilding', false])} &&
                {isNull objectParent _originalTarget} &&
                {[4] call KPLIB_fnc_hasPermission} &&
                {KPLIB_player_fobs isNotEqualTo [] && {(_originalTarget distance2d ([] call KPLIB_fnc_getNearestFob)) < KPLIB_range_fob}} &&
                {(({alive _x} count (crew _originalTarget)) == 0) || {unitIsUAV _originalTarget}} &&
                //{locked _originalTarget == -1 || {locked _originalTarget == 0} || {locked _originalTarget == 1}} &&
                {(((toLowerANSI (typeOf _originalTarget)) in KPLIB_storageBuildings) && (_originalTarget getVariable ["KPLIB_fobStorage", false])) || {!((toLowerANSI (typeOf _originalTarget)) in KPLIB_storageBuildings)}} &&
                {(((attachedObjects _originalTarget) select {!isNull _originalTarget}) isEqualTo []) || {(typeOf _originalTarget) == "rhsusf_mkvsoc"}} // ignore null objects left by Advanced Towing (https://github.com/sethduda/AdvancedTowing/pull/46)
            },
            ((boundingBoxReal _this) # 2) * 1.2
        ];
    }
}] call CBA_fnc_addEventHandler;

// Add factory sector to the production list
["KPLIB_addFactoryProduction", {
    _this call KPLIB_fnc_addFactoryProduction;
}] call CBA_fnc_addEventHandler;

// Remove factory production
["KPLIB_removeFactoryProduction", {

    // Hashmap update
    KPLIB_production deleteAt _this;
    publicVariable "KPLIB_production";

    // Delete storage and its resources
    private _object = KPLIB_sector_storage getOrDefault [_this, objNull];
    if !(isNull _object) then {
        deleteVehicle _object;
    };
    KPLIB_sector_storage deleteAt _this;
    publicVariable "KPLIB_sector_storage";

}] call CBA_fnc_addEventHandler;

// Supply Dump
["KPLIB_registerSupplyDump", {
    _this call KPLIB_fnc_setSupplyDump;
}] call CBA_fnc_addEventHandler;

// Crate carriers/fillers
["KPLIB_addActionSupplyCrates", {
    _this call KPLIB_fnc_addSupplyActions;
}] call CBA_fnc_addEventHandler;

// Get intel action
["KPLIB_addActionIntel", {
    _this addAction [
        "<t color='#FFFF00'>" + localize "STR_INTEL" + "</t>",
        {
            ["KPLIB_intelYield", (_this # 0)] call CBA_fnc_serverEvent;
        },
        "",
        -849,
        true,
        true,
        "",
        toString{isNull objectParent _this}
    ];
}] call CBA_fnc_addEventHandler;

// Add capture action to surrendered enemy soldiers (NO ACE)
["KPLIB_addActionCapture", {
    _this call KPLIB_fnc_addActionCapture;
}] call CBA_fnc_addEventHandler;

// Add action to deliver pow to the FOB
["KPLIB_addActionDeliverPOW", {
    _this call KPLIB_fnc_addActionDeliver;
}] call CBA_fnc_addEventHandler;

["KPLIB_intelYieldPow", {
    [_this] call prisonner_remote_call;
}] call CBA_fnc_addEventHandler;

// Gain intel points
["KPLIB_intelYield", {
    [_this] call intel_remote_call;
}] call CBA_fnc_addEventHandler;

// Change factory production
["KPLIB_changeFactoryProduction", {
    _this call KPLIB_fnc_changeFactoryProduction;
}] call CBA_fnc_addEventHandler;

// Change factory production
["KPLIB_factoryBuildFacility", {
    _this call KPLIB_fnc_factoryBuildFacility;
}] call CBA_fnc_addEventHandler;

// Recalculate resources
["KPLIB_recalculateResources", {
    [] call KPLIB_fnc_recalculateResources;
}] call CBA_fnc_addEventHandler;

// Subtract Resources
["KPLIB_subtractResources", {
    params[["_buildSelected", [], [[]]], ["_buildType", 1, [0]], ["_buildPos", [0,0,0], [[]]]];

    if (_buildSelected isEqualTo []) exitWith {};

    // Get item cost
    private _classname = _buildSelected # 0;
    private _supplyPrice = _buildSelected # 1;
    private _ammoPrice = _buildSelected # 2;
    private _fuelPrice = _buildSelected # 3;

    // Update values based on civilian reputation
    private _priceAdd = -(KPLIB_civ_rep/1000);
    if (_priceAdd < 0) then {
        if (_supplyPrice > 0) then {_supplyPrice = (_supplyPrice - round(_supplyPrice * abs(_priceAdd))) max 0;};
        if (_ammoPrice > 0) then {_ammoPrice = (_ammoPrice - round(_ammoPrice * abs(_priceAdd))) max 0;};
        if (_fuelPrice > 0) then {_fuelPrice = (_fuelPrice - round(_fuelPrice * abs(_priceAdd))) max 0;};
    } else {
        if (_supplyPrice > 0) then {_supplyPrice = _supplyPrice + round(_supplyPrice * _priceAdd);};
        if (_ammoPrice > 0) then {_ammoPrice = _ammoPrice + round(_ammoPrice * _priceAdd);};
        if (_fuelPrice > 0) then {_fuelPrice = _fuelPrice + round(_fuelPrice * _priceAdd);};  
    };

    // Get storage areas
    private _storageAreas = (_buildPos nearobjects (KPLIB_range_fob * 2)) select {_x getVariable ["KPLIB_fobStorage", false] && {((getPosATL _x) # 2) < 1}};

    [_supplyPrice, _ammoPrice, _fuelPrice, _classname, _buildType, _storageAreas] call KPLIB_fnc_subtractResources;
}] call CBA_fnc_addEventHandler;

// Subtract Resources in FOB deployment
["KPLIB_subtractResources_Deploy", {
    params[["_prices", [], [[]]], ["_respawnPos", [0,0,0], []]];

    if (_prices isEqualTo []) exitWith {};
    if (_respawnPos isEqualTo [0,0,0]) exitWith {};

    // Get deploy cost
    private _supplyPrice = _prices # 0;
    private _ammoPrice = _prices # 1;
    private _fuelPrice = _prices # 2;

    // Get storage areas
    ([_respawnPos] call KPLIB_fnc_getNearestBuildPos) params ["_buildPos", "_range"];
    
    //private _nearBase = [_respawnPos] call KPLIB_fnc_getNearestPlayerBase;
    private _storageAreas = (_buildPos nearobjects (_range * 2)) select {_x getVariable ["KPLIB_fobStorage", false]};
    [_supplyPrice, _ammoPrice, _fuelPrice, "", -1, _storageAreas] call KPLIB_fnc_subtractResources;
}] call CBA_fnc_addEventHandler;

// Restore resources (cancel building)
["KPLIB_restoreResources", {
    params["_buildSelected", "_buildPos", "_player"];

    if (_buildSelected isEqualTo []) exitWith {};

    // Get item cost
    private _itemClass = toLowerANSI (_buildSelected # 0);
    private _supplyPrice = _buildSelected # 1;
    private _ammoPrice = _buildSelected # 2;
    private _fuelPrice = _buildSelected # 3;

    // Update cost to box and truck fob/outpost containers per fob builded
    if (_itemClass in ([KPLIB_b_fobBox, KPLIB_b_fobTruck] apply {toLowerANSI _x})) then {
        private _fobsBuilded = count (KPLIB_player_fobs select {_x isNotEqualTo [0,0,0]});
        _supplyPrice = _supplyPrice * _fobsBuilded;
        _ammoPrice = _ammoPrice * _fobsBuilded;
        _fuelPrice = _fuelPrice * _fobsBuilded;
    };

    // Update values based on civilian reputation
    private _priceAdd = -(KPLIB_civ_rep/1000);
    if (_priceAdd < 0) then {
        if (_supplyPrice > 0) then {_supplyPrice = (_supplyPrice - round(_supplyPrice * abs(_priceAdd))) max 0;};
        if (_ammoPrice > 0) then {_ammoPrice = (_ammoPrice - round(_ammoPrice * abs(_priceAdd))) max 0;};
        if (_fuelPrice > 0) then {_fuelPrice = (_fuelPrice - round(_fuelPrice * abs(_priceAdd))) max 0;};
    } else {
        if (_supplyPrice > 0) then {_supplyPrice = _supplyPrice + round(_supplyPrice * _priceAdd);};
        if (_ammoPrice > 0) then {_ammoPrice = _ammoPrice + round(_ammoPrice * _priceAdd);};
        if (_fuelPrice > 0) then {_fuelPrice = _fuelPrice + round(_fuelPrice * _priceAdd);};  
    };

    // Get storage areas
    private _storage_areas = (_buildPos nearobjects (KPLIB_range_fob * 2)) select {_x getVariable ["KPLIB_fobStorage", false] && {((getPosATL _x) # 2) < 1}};

    private _storages = [];
    {
        if ([_x] call KPLIB_fnc_isStorageFull) then {continue}; // Skip iteration

        private _storageLimit = [_x] call KPLIB_fnc_getStorageLimit;

        // Pushback storage with space
        _storages pushBack _x;
    } forEach _storage_areas;

    if (count _storages > 0) then {
        // Storages found and they are not full
        [_supplyPrice, _ammoPrice, _fuelPrice, _storages] call KPLIB_fnc_restoreResources;
    } else {
        // All storages full or no storages found. Spawn crates instead.
        while {(_supplyPrice > 0) || (_ammoPrice > 0) || (_fuelPrice > 0)} do {
            if (_supplyPrice > 0) then {
                private _price = _supplyPrice min 100;
                [KPLIB_b_crateSupply, _price, getPosATL _player] call KPLIB_fnc_createCrate;
                _supplyPrice = _supplyPrice - _price;
            };

            if (_ammoPrice > 0) then {
                private _price = _ammoPrice min 100;
                [KPLIB_b_crateAmmo, _price, getPosATL _player] call KPLIB_fnc_createCrate;
                _ammoPrice = _ammoPrice - _price;
            };

            if (_fuelPrice > 0) then {
                private _price = _fuelPrice min 100;
                [KPLIB_b_crateFuel, _price, getPosATL _player] call KPLIB_fnc_createCrate;
                _fuelPrice = _fuelPrice - _price;
            };
        };
    };
}] call CBA_fnc_addEventHandler;

// Restore recycle resources
["KPLIB_recycleResources", {
    _this call KPLIB_fnc_recycleResources;
}] call CBA_fnc_addEventHandler;

// Add actions to resources crates
["KPLIB_addActionsCrate", {
    _this spawn {
        waitUntil {sleep 1; alive player};
        _this call KPLIB_fnc_addActionsCrate;
    }
}] call CBA_fnc_addEventHandler;

// Add actions to storage
["KPLIB_addActionsStorage", {
    if (isDedicated) exitWith {};
    
    _this spawn {
        waitUntil {sleep 1; alive player};
        _this call KPLIB_fnc_addActionsStorage;
    }
}] call CBA_fnc_addEventHandler;

// Add actions to transport vehicles
["KPLIB_addActionUnloadCrate", {
    if (isDedicated) exitWith {};

    _this spawn {
        waitUntil {sleep 1; alive player};
        private _actionDist = 5;
        switch (true) do {
            case (_this isKindOf "Plane") : {_actionDist = 15};
            case (_this isKindOf "Helicopter") : {_actionDist = 10};
            default {}  
        };

        _this addAction [
            "<t color='#FFFF00'>" + localize "STR_ACTION_UNLOAD_BOX" + "</t>",
            {
                params["_vehicle", "_player"];
                [_vehicle, _player] call KPLIB_fnc_doUnloadCrate
            },
            "",
            -500,
            true,
            true,
            "",
            toString {
                alive _target && 
                {isNull objectParent _this} &&
                {!(_this getVariable ['KPLIB_BUILD_isBuilding', false])} &&
                {_target getVariable ["KPLIB_CARGO_loadedCargo", []] isNotEqualTo []} &&
                {_target getVariable ["KPLIB_CARGO_isTransportVeh", true]} &&
                {isNull (_this getVariable ["KPLIB_carriedObject", objNull])} &&
                {(speed _target < 2) ||
                {_target isKindOf "Air" && {!(isEngineOn _target)} && {isTouchingGround _target}}}
            },
            _actionDist
        ];
    }
}] call CBA_fnc_addEventHandler;

// Add action to air vehicles to paradrop crates
["KPLIB_addActionParadropCrates", {
    _this spawn {
        waitUntil {sleep 1; alive player};
        _this call KPLIB_fnc_addParadropAction;
    }
    
}] call CBA_fnc_addEventHandler;

// Remove all actions from crates
["KPLIB_removeAllActionsCrate", {
    private _actionIDs = _this getVariable ["KPLIB_crateActions", []];
    {_this removeAction _x}forEach _actionIDs;
}] call CBA_fnc_addEventHandler;

// Change collision crate status
["KPLIB_crateCollisionChange", {
    params["_crate", ["_bool", true]];
    _crate setPhysicsCollisionFlag _bool;
}] call CBA_fnc_addEventHandler;

// Flashbang event handler
["ace_grenades_flashbangedAI", {
	params["_unit", "_strength", "_grenadePosASL"];
    
    // Check for indoor
    if !(lineIntersects [_grenadePosASL, _grenadePosASL vectorAdd [0, 0, 6]]) exitWith {};

	if ((random 100 <= 35) && (_unit distance2D _grenadePosASL < 10) && (_strength >= 0.6) && (side (group _unit) == KPLIB_side_enemy)) then {

        [{
            if (captive _this) then {
                [_this, true] call KPLIB_fnc_setCapturable;
            } else {
                [_this] call KPLIB_fnc_setCapturable;
            };
        }, _unit, 2] call CBA_fnc_waitAndExecute;

	}
}] call CBA_fnc_addEventHandler;

// Delete cargo if vehicle is destroyed
["KPLIB_deleteCargo", {
    private _cargoLoaded = _this getVariable ["KPLIB_CARGO_loadedCargo", []];
    // If vehicle is destroyed, delete all cargo
    {
        deleteVehicle _x;
    }forEach _cargoLoaded;
    _this setVariable ["KPLIB_CARGO_loadedCargo", nil, true];
}] call CBA_fnc_addEventHandler;