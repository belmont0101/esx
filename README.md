# ESX Server - ox_lib Migration Edition

A complete FiveM ESX server framework with UI components migrated to use ox_lib for better performance and modern user experience.

## Overview

This ESX server has been enhanced with ox_lib integration, replacing legacy ESX UI components with modern, optimized alternatives. The migration maintains 100% backward compatibility while providing better visuals, performance, and user experience.

## What's Been Migrated

### Core UI Resources

#### esx_progressbar
- Converted from custom NUI to lib.progressBar()
- Maintains all animation support (anim and Scenario types)
- Supports FreezePlayer, onFinish, and onCancel callbacks
- Backward compatible with existing exports

#### esx_textui  
- Converted from custom NUI to lib.showTextUI() and lib.hideTextUI()
- Maps ESX types (error, success, info) to ox_lib icons
- Right-center positioning for better visibility
- Backward compatible with ESX.TextUI() calls

#### esx_notify
- Converted from custom NUI to lib.notify()
- Position mapping from ESX format to ox_lib format
- Supports all notification features (type, duration, title)
- Backward compatible with ESX.ShowNotification() calls

### Addon Resources

#### esx_drugs
- TextUI system converted to lib.showTextUI() with icons
- Notifications converted to lib.notify()
- Context menus converted to lib.registerContext() and lib.showContext()
- Input dialogs using lib.inputDialog()
- License purchase using lib.alertDialog()
- All drug mechanics work exactly as before

## Server Structure

```
esx/
├── artifacts/                    # FiveM server files
├── resources/
│   ├── [cfx-default]/           # Default FiveM resources
│   ├── [core]/                  # ESX core resources
│   │   ├── es_extended/         # Main ESX framework
│   │   ├── esx_notify/          # Notification system (ox_lib)
│   │   ├── esx_progressbar/     # Progress bars (ox_lib)
│   │   ├── esx_textui/          # Text UI system (ox_lib)
│   │   ├── esx_context/         # Context menus
│   │   ├── esx_identity/        # Character identity
│   │   ├── esx_multicharacter/  # Character selection
│   │   └── ...                  # Other core resources
│   ├── [esx_addons]/           # ESX addon resources
│   │   ├── esx_drugs/          # Drug system (ox_lib)
│   │   ├── esx_ambulancejob/   # EMS job
│   │   ├── esx_policejob/      # Police job
│   │   └── ...                 # Other addons
│   └── [standalone]/           # Standalone resources
│       ├── ox_lib/             # ox_lib framework (required)
│       ├── ox_inventory/       # Inventory system
│       ├── ox_target/          # Targeting system
│       ├── oxmysql/            # MySQL connector
│       └── pma-voice/          # Voice chat
├── es_extended.sql             # Database structure
├── server.cfg                  # Server configuration
└── start.bat                   # Server startup script
```

## Installation

### Prerequisites

- Windows operating system
- MySQL/MariaDB database server
- FiveM server artifacts (included in artifacts folder)

### Database Setup

1. Create a new MySQL database
2. Import the database structure:
   ```sql
   SOURCE es_extended.sql
   ```
3. Import additional SQL files from resources that need them:
   - resources/[core]/esx_identity/esx_identity.sql
   - resources/[core]/esx_multicharacter/esx_multicharacter.sql
   - resources/[esx_addons]/esx_drugs/esx_drugs.sql
   - And any other .sql files in addon resources

### Server Configuration

1. Edit server.cfg to configure your server:
   - Set your server name
   - Configure MySQL connection
   - Set sv_licenseKey (from keymaster.fivem.net)
   - Adjust other settings as needed

2. Ensure resources are loaded in the correct order:
   ```cfg
   # Core Libraries (must be first)
   ensure ox_lib
   ensure oxmysql
   
   # ESX Core
   ensure es_extended
   ensure cron
   
   # ESX UI (ox_lib versions)
   ensure esx_notify
   ensure esx_textui
   ensure esx_progressbar
   
   # ESX Core Resources
   ensure esx_context
   ensure esx_identity
   ensure esx_multicharacter
   # ... other core resources
   
   # ESX Addons
   ensure esx_drugs
   # ... other addons
   ```

### Starting the Server

Run start.bat to launch the server. The batch file will execute the FiveM server with the configured settings.

## ox_lib Migration Benefits

### Performance Improvements
- Reduced NUI file loading (no custom HTML/CSS/JS for each UI component)
- Optimized rendering through ox_lib's unified system
- Better memory management
- Faster UI response times

### User Experience Enhancements
- Consistent design language across all UI components
- Modern, clean interface styling
- Better icon support and visual feedback
- Improved positioning and visibility
- Smoother animations and transitions

### Developer Benefits
- Easier maintenance (no custom NUI code to maintain)
- Actively maintained by communityox
- Better documentation and community support
- More features available out of the box
- Simpler debugging

### Backward Compatibility
- All existing scripts continue to work without modification
- Export functions maintain their original signatures
- Server-side code unchanged
- No database changes required
- Players experience no disruption

## Usage for Players

### Character System
- Select or create characters at server join
- Multiple character slots available
- Identity system for character information

### Drug System (esx_drugs)
- Harvest cannabis plants at the weed field
- Process cannabis at the processing location
- Sell drugs at the drug dealer location
- Purchase processing licenses if required (configurable)

### Jobs and Activities
Multiple jobs available including:
- Police (esx_policejob)
- EMS/Ambulance (esx_ambulancejob)
- Mechanic (esx_mechanicjob)
- Taxi (esx_taxijob)
- And many more

## Configuration

### Core Settings

Edit resources/[core]/es_extended/config.lua for core ESX settings:
- Economy settings
- Accounts configuration
- Server locale
- Debug options

### UI Settings

#### esx_notify
Edit resources/[core]/esx_notify/Config.lua:
- Notification sound enable/disable
- Default position (top-right, center-right, etc.)

#### esx_drugs  
Edit resources/[esx_addons]/esx_drugs/config.lua:
- Zone coordinates for weed field, processing, dealer
- Processing delays
- Drug prices
- License requirements
- Sell menu limits

## Development

### Adding New Resources

When creating new resources that use UI components:

1. Add ox_lib to dependencies in fxmanifest.lua:
   ```lua
   shared_scripts {
       '@es_extended/imports.lua',
       '@ox_lib/init.lua'
   }
   ```

2. Use ox_lib functions instead of ESX UI:
   ```lua
   -- Progress bar
   lib.progressBar({
       duration = 5000,
       label = 'Processing...',
       useWhileDead = false,
       canCancel = true
   })
   
   -- Text UI
   lib.showTextUI('Press [E] to interact', {
       position = 'right-center',
       icon = 'hand'
   })
   lib.hideTextUI()
   
   -- Notification
   lib.notify({
       title = 'Success',
       description = 'Action completed',
       type = 'success'
   })
   
   -- Context Menu
   lib.registerContext({
       id = 'my_menu',
       title = 'Menu Title',
       options = {
           {
               title = 'Option 1',
               description = 'Description here',
               onSelect = function()
                   print('Selected option 1')
               end
           }
       }
   })
   lib.showContext('my_menu')
   
   -- Input Dialog
   local input = lib.inputDialog('Dialog Title', {
       {type = 'input', label = 'Name', required = true},
       {type = 'number', label = 'Amount', min = 1, max = 100}
   })
   ```

### Backward Compatibility

Existing ESX functions still work:
```lua
-- These continue to work (wrapped to use ox_lib internally)
ESX.ShowNotification('Message', 'success', 5000)
ESX.TextUI('Press [E] to interact', 'info')
ESX.HideUI()
exports['esx_progressbar']:Progressbar('Label', 5000, {})
```

## Troubleshooting

### ox_lib not found
- Ensure ox_lib is in resources/[standalone]/ox_lib/
- Check that ox_lib is started before ESX resources in server.cfg
- Restart server after adding ox_lib

### UI not showing
- Clear FiveM cache (FiveM > Settings > Clear cache)
- Check F8 console for JavaScript errors
- Verify ox_lib version is up to date
- Ensure no conflicting resources

### Database connection issues
- Verify MySQL credentials in server.cfg
- Check MySQL server is running
- Confirm oxmysql resource is started
- Check database user has proper permissions

### Resource won't start
- Check console for error messages
- Verify all dependencies are installed
- Ensure files are not corrupted
- Check fxmanifest.lua syntax

## Resource List

### Core ESX Resources
- es_extended - Core ESX framework
- cron - Scheduled tasks
- esx_notify - Notifications (ox_lib)
- esx_textui - Text UI (ox_lib)
- esx_progressbar - Progress bars (ox_lib)
- esx_context - Context menus
- esx_identity - Character identity
- esx_multicharacter - Character selection
- esx_skin - Character appearance
- skinchanger - Skin modification system
- esx_loadingscreen - Server loading screen
- esx_menu_default - Default menu system
- esx_menu_dialog - Dialog menus
- esx_menu_list - List menus

### Job Resources
- esx_ambulancejob - EMS/Medical services
- esx_policejob - Law enforcement
- esx_mechanicjob - Vehicle repair
- esx_taxijob - Taxi service

### Gameplay Resources
- esx_drugs - Drug farming and selling (ox_lib)
- esx_shops - General stores
- esx_clotheshop - Clothing stores
- esx_barbershop - Hair salons
- esx_vehicleshop - Vehicle dealerships
- esx_garage - Vehicle garages
- esx_property - Property system
- esx_dmvschool - Driving school
- esx_license - License system
- esx_banking - Banking system
- esx_billing - Billing system
- esx_society - Society/company management
- esx_status - Player status (hunger, thirst)
- esx_basicneeds - Basic needs system

### Standalone Resources
- ox_lib - UI library (required)
- ox_inventory - Advanced inventory system
- ox_target - Targeting system
- oxmysql - MySQL connector (required)
- pma-voice - Voice communication
- bob74_ipl - Interior loading

## Credits

### Frameworks
- ESX Framework - https://github.com/esx-framework
- ox_lib - https://github.com/communityox/ox_lib
- Communityox Resources - https://github.com/communityox

### Migration
This server has been enhanced with ox_lib integration for improved performance and user experience while maintaining full ESX compatibility.

## Support

For issues related to:
- ESX Core Framework - https://github.com/esx-framework/esx-legacy
- ox_lib - https://github.com/communityox/ox_lib
- FiveM - https://forum.cfx.re

## License

This server uses various resources with different licenses. Check individual resource folders for their respective LICENSE files.

## Version Information

- ESX Version: 1.13.4+
- ox_lib: Latest
- FiveM: Latest server artifacts
- Migration Version: 2.0.0

## Migration Documentation

Detailed migration guides are available in:
- resources/[core]/OX_LIB_MIGRATION.md - Core UI resources migration
- resources/[core]/MIGRATION_SUMMARY.md - Quick migration summary  
- resources/[esx_addons]/esx_drugs/OX_LIB_MIGRATION.md - Drug system migration

These documents contain technical details about what was changed, how to use the new systems, and troubleshooting information.
