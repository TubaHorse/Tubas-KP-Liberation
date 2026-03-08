# KP LIBERATION PIG

## DESCRIPTION
Welcome to PiG's Liberation. This fork of APR is aimed to add several features but maintaining the original feeling of Liberation. This is **not** an overhaul of the gamemode.

The majority of the gameplay is the same, but there are more to it. Check the [CHANGELOG](https://github.com/PiG13BR/KP-Liberation-PIG/blob/v0.97.0-PIG-UNSTABLE/CHANGELOG.md) for further details.

There are new system in `Extensions` folder, some of them you can find details in README.md files.

Please, read the addition notes below.

## DEVKIT
The devkit had some small additions, but still uses the same logic that you can follow in [official tutorial page](https://github.com/KillahPotatoes/KP-Liberation/wiki/EN_Devkit).

Below are listed the additions so far, all optional:
- New sector: Outpost (marker name: `outpost`). This is an invisible sector aimed to be a filler. It spawns some patrol units and garrisons. Doesn't spawn vehicles.
- Factory sector: You can choose what the factory can produce at start by adding `supply`, `ammo` or `fuel` in the marker name (i.e: `factory_supply_1`).
- Enemy road spawn points (marker name: `spawn_opfor_road_point`). Enemy vehicles will use them, also for the convoy objective.

## DISCLAIMERS
- [LICENSE](https://github.com/KillahPotatoes/KP-Liberation/blob/master/LICENSE.md).
- This mission is only a continued project based on the original, but most likely abandoned, mission from [GreuhZbug](https://github.com/GreuhZbug).

## ADDITIONAL NOTES
- Presets are now mission parameters.
- The AI logistics in the current version is turned off because of the resources management changes for storages. There are a bunch of codes related to that in the logistic script and I don't want to touch it right now.
- It takes about 60 seconds from the server start to add actions to the objects.
- You can send information about factory and FOB resources to a discord channel. Information [here](https://github.com/PiG13BR/KP-Liberation-PIG/tree/v0.97.0-PIG-UNSTABLE/Missionframework/Extensions/Discord_Log).
- The arsenal was divided into two options: shared and whitelist by role/classnames. The first one is the default option (the same arsenal items for everyone), and the second one, the arsenal items are shared by roles. Access `Presets\Arsenal\roles_presets\...` to configure the whitelist option. Don't forget to change mission parameters to enable it.
- Player and enemy presets now have a `default.sqf` file, that it reads before the actual selected preset. It was created to make new additions for the presets without requiring to edit every file.
- Not only vehicles are unlockable per sector, but also arsenal items. Check the files in `Extensions\Lock_Arsenal`.
- You can choose what sector unlocks each elite vehicle in the presets (read the commentary before `KPLIB_b_vehToUnlock` in the `default.sqf` file).
- It should be compatible with saves from 0.96.8, but it's not guaranteed.
- There is a mission parameters that enables FOB redeploy cost, subtracting resources. For a particular FOB, you can build two barracks (in the build support label) to stop from taking resources for each redeploy. Also, the barracks are required to be able to buy AI units.
- It's possible to create unique sectors events (`Extensions\Sector_Events`).

Zeus Module:
- The zeus has no more restrictions, and as default it has to be accessed via admin logged. There is a whitelist for players for it in the `KPLIB_whitelist.sqf` file (KPLIB_whitelist_zeus), that creates a game master module for each logged player.
- It's highly recommended that you use the whitelist, because as tested, using it fixed some issues related to not having access to zeus in respawns.

## CREDITS
- [GREUH](https://github.com/GreuhZbug) and [KillahPotatoes](https://github.com/KillahPotatoes/);
- [Apricot](https://github.com/Apricot-ale/) for making a stable fork to work with;
- [FernandimModelador](https://github.com/FernandimModelador) for helping me debug scripts and solve issues.

## REQUIRED ADD-ONS
- [CBA_A3](https://steamcommunity.com/sharedfiles/filedetails/?id=450814997)

## RECOMMENDED ADD-ONS
- [ACE](https://steamcommunity.com/sharedfiles/filedetails/?id=463939057)
- [LAMBS_Danger.fsm (DEV)](https://steamcommunity.com/sharedfiles/filedetails/?id=2434257231)
- [Sling Load Rigging](https://steamcommunity.com/sharedfiles/filedetails/?id=2128676112)
- [cTab 1erGTD](https://steamcommunity.com/sharedfiles/filedetails/?id=2262006564)
- [Better CAS Environment (BCE)](https://steamcommunity.com/sharedfiles/filedetails/?id=2853828143)
- [IADS Coordinater (Beta)](https://steamcommunity.com/sharedfiles/filedetails/?id=3670705586)
