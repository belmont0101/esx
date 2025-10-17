# ESX Drugs - NPC Drug Dealer with ox_target

## Overview

Added an NPC drug dealer to the esx_drugs resource with ox_target integration for seamless marijuana selling experience.

## What's Added

### NPC Drug Dealer
- **Model**: Mexican gang member (g_m_y_mexgoon_03)
- **Location**: Sandy Shores area coordinates from config
- **Animation**: Drug dealer hard scenario animation
- **Interaction**: ox_target based interaction (no distance checking)
- **Blip**: Optional blip marker on map

### Features
- **Persistent NPC**: Spawns when resource starts
- **Invincible**: Cannot be killed or moved
- **ox_target Integration**: Modern targeting system
- **Animated**: Performs drug dealer animations
- **Blip Support**: Optional map marker
- **Auto Cleanup**: NPC and targets removed when resource stops

## Configuration

Edit the `Config.DrugDealerNPC` section in config.lua:

```lua
Config.DrugDealerNPC = {
    model = 'g_m_y_mexgoon_03',                                    -- NPC model
    coords = vector4(-1173.112061, -1572.883545, 4.662231, 35.0), -- x, y, z, heading
    scenario = 'WORLD_HUMAN_DRUG_DEALER_HARD',                    -- Animation
    enableBlip = true,                                            -- Show blip on map
    blip = {
        sprite = 378,      -- Blip icon
        color = 6,         -- Blip color (red)
        scale = 0.8,       -- Blip size
        name = 'Drug Dealer' -- Blip name
    }
}
```

### Customization Options

#### NPC Models
You can change the model to any of these drug dealer types:
- `g_m_y_mexgoon_03` - Mexican gang member (default)
- `g_m_y_mexgoon_01` - Alternative Mexican gang member
- `g_m_y_mexgoon_02` - Another Mexican gang member
- `g_m_m_mexcntry_01` - Mexican country type
- `g_m_y_ballaeast_01` - Ballas gang member
- `g_m_y_ballaorig_01` - Original Ballas member

#### Animation Scenarios
Available animation scenarios:
- `WORLD_HUMAN_DRUG_DEALER_HARD` - Active drug dealing (default)
- `WORLD_HUMAN_DRUG_DEALER` - Casual drug dealing
- `WORLD_HUMAN_SMOKING` - Smoking animation
- `WORLD_HUMAN_HANG_OUT_STREET` - Hanging out
- `WORLD_HUMAN_GUARD_STAND` - Standing guard

#### Blip Customization
- **Sprites**: 378 (dollar sign), 51 (person), 480 (weed leaf)
- **Colors**: 1 (red), 6 (pink), 25 (green), 46 (yellow)
- **Scale**: 0.6 (small) to 1.2 (large)

## Installation

The NPC system is automatically included with the ox_lib migration. No additional installation required.

### Prerequisites
- ox_lib (for notifications and context menus)
- ox_target (for NPC interaction)
- ESX framework
- Updated esx_drugs with ox_lib support

## Usage

### For Players
1. **Locate the Dealer**: Use the map blip or go to the coordinates
2. **Target**: Look at the NPC to see ox_target options
3. **Interact**: Click "Access Drug Dealer" option or press default key
4. **Sell**: Select marijuana from the context menu
5. **Complete**: Choose amount to sell in the input dialog

### For Admins
The NPC will automatically spawn when the resource starts. If needed:
- `/restart esx_drugs` - Respawns the NPC
- Check console for any NPC spawning errors

## Technical Details

### NPC Properties
- **Health**: 200 (higher than default)
- **Invincible**: Yes (cannot be killed)
- **Frozen**: Yes (cannot be moved)
- **Collision**: Yes (players cannot walk through)
- **Ragdoll**: Disabled

### Interaction System
- **Target System**: ox_target based (no distance loops)
- **Interface**: Modern targeting interface
- **Menu System**: Uses ox_lib context menus
- **Performance**: Better performance than distance checking
- **Cleanup**: Automatic target and NPC cleanup when resource stops

### Performance
- **Spawning**: Single thread, spawns once on resource start
- **Monitoring**: ox_target handles all interaction detection
- **Memory**: Minimal impact (single NPC entity, no distance loops)
- **CPU**: Better performance than traditional distance checking

## Troubleshooting

### NPC not spawning
1. Check console for model loading errors
2. Verify coordinates are valid
3. Restart resource: `/restart esx_drugs`
4. Check if model name is correct

### NPC disappeared
1. Resource may have been restarted
2. Check if NPC was accidentally deleted
3. Restart resource to respawn

### Interaction not working
1. Check if ox_target is running and loaded
2. Look directly at the NPC to see target options
3. Verify ox_lib is running for menus
4. Try restarting esx_drugs

### Blip issues
1. Set `enableBlip = false` if causing problems
2. Check blip sprite and color values
3. Restart resource after config changes

## Notes

- The old marker system has been removed in favor of the NPC
- NPC uses the same coordinates as the original drug dealer zone
- All existing functionality remains the same
- Server-side code unchanged (selling mechanics identical)
- Works with all existing esx_drugs features (licensing, validation, etc.)

## Compatibility

- Compatible with all ESX versions
- Works with ox_lib UI system
- Requires ox_target for interaction
- Compatible with other drug-related resources
- No conflicts with existing esx_drugs addons