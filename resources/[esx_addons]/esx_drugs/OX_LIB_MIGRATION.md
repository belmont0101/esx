# ESX Drugs - ox_lib Migration

## Overview

The `esx_drugs` resource has been successfully converted to use **ox_lib** instead of ESX's native UI systems. This provides a better, more modern user experience while maintaining full functionality.

## What Changed

### 1. User Interface Components

**Before (ESX Native):**
- `ESX.ShowHelpNotification()` - Help text prompts
- `ESX.ShowNotification()` - Success/error notifications  
- `ESX.OpenContext()` - Context menus for drug dealer

**After (ox_lib):**
- `lib.showTextUI()` / `lib.hideTextUI()` - Interactive text UI with icons
- `lib.notify()` - Modern notification system
- `lib.registerContext()` / `lib.showContext()` - Context menus
- `lib.inputDialog()` - Input dialogs for amount selection
- `lib.alertDialog()` - License purchase confirmations

### 2. Visual Improvements

#### Text UI Enhancements
- **Cannabis Plant Harvesting**: Shows cannabis seedling icon
- **Weed Processing**: Shows cannabis leaf icon  
- **Drug Dealer**: Shows money/dollar icon
- **Better Positioning**: Right-center positioning for better visibility

#### Notification Improvements
- **Processing Started**: Success notification with title
- **Processing Failed**: Error notification when too far away
- **Inventory Full**: Error notification with clear messaging
- **License Purchase**: Success/error notifications with proper formatting

#### Menu System Improvements
- **Drug Selling Menu**: Clean context menu with item icons
- **Amount Selection**: Modern input dialog with min/max validation
- **License Purchase**: Alert dialog with clear pricing information

## Key Features

### ✅ Maintained Functionality
- All original drug mechanics work exactly the same
- Weed field spawning and harvesting
- Processing system with timers
- Drug dealer selling system
- License system (if enabled)
- Blip and marker systems

### ✅ Enhanced UX
- **Visual Icons**: Cannabis, seedling, and dollar icons for context
- **Better Notifications**: Clearer success/error messaging
- **Improved Menus**: Modern context menus with better navigation
- **Input Validation**: Proper min/max validation for selling amounts
- **Responsive UI**: Automatic hiding when leaving zones

### ✅ Performance Benefits
- Uses ox_lib's optimized UI system
- Better memory management
- Faster rendering and responsiveness

## Configuration

No configuration changes are needed! All existing Config.lua settings work as before:

- `Config.CircleZones` - All zone coordinates remain the same
- `Config.DrugDealerItems` - Pricing unchanged
- `Config.LicenseEnable` - License system works as before
- `Config.SellMenu.Min/Max` - Amount limits still enforced

## Usage Examples

### For Players
The interaction remains exactly the same:
1. **Harvesting**: Walk up to cannabis plants and press [E]
2. **Processing**: Go to processing area and press [E] 
3. **Selling**: Visit drug dealer and press [E] to open selling menu
4. **License**: Purchase processing licenses when required

### For Developers
All server-side events and callbacks remain unchanged:
```lua
-- These still work exactly the same
TriggerServerEvent('esx_drugs:processCannabis')
TriggerServerEvent('esx_drugs:sellDrug', itemName, amount)
ESX.TriggerServerCallback('esx_drugs:canPickUp', callback, 'cannabis')
```

## Installation Notes

### Prerequisites
Ensure these resources are started in order:
```cfg
# Essential
ensure ox_lib
ensure es_extended

# Drugs system
ensure esx_drugs
```

### File Structure
```
esx_drugs/
├── fxmanifest.lua (updated - added ox_lib dependency)
├── config.lua (unchanged)
├── client/
│   ├── main.lua (converted to ox_lib)
│   └── weed.lua (converted to ox_lib)
├── server/
│   └── main.lua (unchanged)
└── locales/ (unchanged)
```

## Testing Checklist

After installation, test these features:

### Weed Field (Config.CircleZones.WeedField)
- ✅ Plants spawn automatically near the field
- ✅ TextUI appears when near plants: "Press [E] to harvest Cannabis plant"
- ✅ Harvesting animation plays correctly
- ✅ Success notification when picked up
- ✅ Error notification when inventory is full

### Processing Area (Config.CircleZones.WeedProcessing)  
- ✅ TextUI appears: "Press [E] to process Cannabis"
- ✅ Processing notification appears
- ✅ Timer works correctly
- ✅ Error notification if you move too far away
- ✅ License check works (if enabled)

### Drug Dealer (Config.CircleZones.DrugDealer)
- ✅ TextUI appears: "Press [E] to access Drug Dealer"
- ✅ Context menu opens with available drugs
- ✅ Input dialog for amount selection works
- ✅ Min/max amount validation works
- ✅ Selling completes successfully

### License System (if Config.LicenseEnable = true)
- ✅ Alert dialog appears for license purchase
- ✅ Purchase confirmation works
- ✅ Success/error notifications show correctly

## Troubleshooting

### "ox_lib not found"
Ensure ox_lib is installed and started before esx_drugs:
```cfg
ensure ox_lib
ensure esx_drugs
```

### UI not showing
1. Check console (F8) for errors
2. Restart the resource: `/restart esx_drugs`
3. Ensure you're in the correct zones (check Config.CircleZones)

### Menus not working
1. Make sure you have the latest version of ox_lib
2. Check that no other resources are conflicting
3. Verify ESX framework is running correctly

## Compatibility

### ✅ Compatible With
- All ESX versions (1.13.4+)
- ox_lib (latest version)
- All existing esx_drugs addons/modifications
- All server frameworks using ESX

### ⚠️ Requirements  
- **ox_lib**: Must be installed and running
- **ESX**: Core framework required
- **oxmysql**: For database operations (already required)

## Support

This conversion maintains 100% backward compatibility. All existing:
- Server events work the same
- Database structure unchanged  
- Configuration options preserved
- Admin commands still function

The only changes are visual improvements and better user experience through ox_lib's modern UI system.