## LIBERATION PRESETS

### DESCRIPTION
This is main hub of the Liberation presets, where you can edit or add files yourself.

DON'T CHANGE THE PRESETS MIDGAME, IT CAN BREAK YOUR MISSION, particullary for the player side (missing building FOBs and assets); You can still edit the selected file.

### FILES
The `init_presets.sqf`: 
- Handles the reading of the defaults.sqf presets before the selected ones from the mission parameters.
- Compatibility checks default.sqf vs. other presets.
- Check presets for missing mods.
- Classnames collection.
- Squads build list is located in this file.

The `get_presets.sqf`:
- Reads the presets selected on mission parameters.

The `mission_params.hpp`:
- Mission parameters presets selection.

Preset's `default.sqf`:
- This file reads before the actual selected preset.
- Any important variable additions should be added in this file.
- If it requires build menu additions (i.e: new variable in the support label/array), the compatibility should be done on the init_presets.sqf. You can follow the examples there.

### EDITING PRESET
To costumize your own preset, use the `custom.sqf` files and select it on the mission parameters. If you want to create a new preset, read **PRESET CREATION** below.

### PRESET CREATION
It's highly recommended that you create your own preset by copying the `default.sqf`.
To add a new preset, it requires:
- Adding it in the correct order in `Presets\mission_params.hpp` with its value (number);
- Adding it the correct path of the file and its associated `switch` number from `Presets\mission_params.hpp` in `Presets\get_presets.sqf`.
- (Optional) Adding it in the `Scripts\Shared\fetch_params.sqf` file to generate a log entry.

If you think your preset is really helpful, you can make a pull request to be added as an official preset of this fork.