# ESX to ox_lib Migration Guide

This document explains the migration of ESX UI resources to use ox_lib instead of custom NUI implementations.

## Overview

The following resources have been converted to use ox_lib:
- **esx_progressbar** → Uses `lib.progressBar()`
- **esx_textui** → Uses `lib.showTextUI()` and `lib.hideTextUI()`
- **esx_notify** → Uses `lib.notify()`

## Prerequisites

Make sure you have **ox_lib** installed in your server:
```
resources/[standalone]/ox_lib/
```

## Changes Made

### 1. esx_progressbar

**Before (Custom NUI):**
```lua
exports['esx_progressbar']:Progressbar("Drinking water...", 5000, {
    FreezePlayer = true,
    animation = {
        type = "anim",
        dict = "mp_player_intdrink",
        lib = "loop_bottle"
    },
    onFinish = function()
        print("Finished!")
    end
})
```

**After (ox_lib):**
The same export still works! The internal implementation now uses ox_lib's progress bar system.

**Key Changes:**
- Removed custom NUI files (no longer needed)
- Uses ox_lib's `lib.progressBar()` internally
- Maintains backward compatibility with existing exports
- Better performance and styling from ox_lib

### 2. esx_textui

**Before (Custom NUI):**
```lua
ESX.TextUI("Press [E] to interact", "info")
ESX.HideUI()
```

**After (ox_lib):**
The same API still works! Now uses ox_lib's text UI system.

**Key Changes:**
- Removed custom NUI files
- Uses ox_lib's `lib.showTextUI()` and `lib.hideTextUI()`
- Maintains backward compatibility
- Better positioning and styling from ox_lib

**Type Mapping:**
- `error` → Shows with ban icon
- `success` → Shows with check icon
- `info` → Shows with info icon

### 3. esx_notify

**Before (Custom NUI):**
```lua
ESX.ShowNotification("You received 1x ball!", "success", 3000, "Achievement")
```

**After (ox_lib):**
The same API still works! Now uses ox_lib's notification system.

**Key Changes:**
- Removed custom NUI files
- Uses ox_lib's `lib.notify()`
- Maintains backward compatibility
- Better notification styling and animations

**Position Mapping:**
- `top-right` → `top-right`
- `top-left` → `top-left`
- `top-middle` → `top`
- `bottom-right` → `bottom-right`
- `bottom-left` → `bottom-left`
- `bottom-middle` → `bottom`
- `middle-left` → `center-left`
- `middle-right` → `center-right`

## Benefits of Migration

1. **Reduced Resource Load**: No custom NUI files means less HTTP requests and faster loading
2. **Better Performance**: ox_lib is optimized and widely used
3. **Consistent UI**: All ox_lib components have a unified design language
4. **Better Maintenance**: ox_lib is actively maintained and updated
5. **Backward Compatibility**: All existing exports and events still work
6. **More Features**: Access to ox_lib's additional features and customization options

## Installation

1. Make sure `ox_lib` is installed and started before these resources
2. Restart the converted resources:
   ```
   restart esx_progressbar
   restart esx_textui
   restart esx_notify
   ```

## Troubleshooting

### "ox_lib not found" error
Make sure ox_lib is installed and add it to your server.cfg:
```
ensure ox_lib
```

### UI not showing
1. Check F8 console for errors
2. Make sure ox_lib is started BEFORE these resources
3. Clear your FiveM cache

### Old NUI files can be removed
The `nui/` folders in each resource are no longer used and can be safely deleted (but kept for reference).

## Testing

Test each resource with these commands (if Debug mode is enabled):

**esx_notify:**
```
/notify
/notify1
/notify2
/notify3
/notify4
```

**esx_textui:**
```
/textui:error
/textui:success
/textui:info
/textui:hide
```

## Notes

- The Config.lua for esx_notify is still used for default position settings
- All exports maintain their original signatures for backward compatibility
- ox_lib provides additional customization options that can be used by modifying the wrapper functions

## Support

For issues with:
- **ox_lib functionality**: Visit https://github.com/overextended/ox_lib
- **ESX compatibility**: Visit https://github.com/esx-framework/esx-legacy
