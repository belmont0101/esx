Debug = ESX.GetConfig().EnableDebug

---@param message string
---@param typ string
local function TextUI(message, typ)
    -- Map ESX types to ox_lib icon types
    local iconMap = {
        error = 'ban',
        success = 'check',
        info = 'circle-info'
    }
    
    local options = {
        position = 'right-center',
    }
    
    if typ and iconMap[typ] then
        options.icon = iconMap[typ]
    end
    
    lib.showTextUI(message or "ESX-TextUI", options)
end

local function HideUI()
    lib.hideTextUI()
end

exports("TextUI", TextUI)
exports("HideUI", HideUI)
ESX.SecureNetEvent("ESX:TextUI", TextUI)
ESX.SecureNetEvent("ESX:HideUI", HideUI)

if Debug then
    RegisterCommand("textui:error", function()
        ESX.TextUI("i ~r~love~s~ donuts", "error")
    end, false)

    RegisterCommand("textui:success", function()
        ESX.TextUI("i ~g~love~s~ donuts", "success")
    end, false)

    RegisterCommand("textui:info", function()
        ESX.TextUI("i ~b~love~s~ donuts", "info")
    end, false)

    RegisterCommand("textui:hide", function()
        ESX.HideUI()
    end, false)
end
