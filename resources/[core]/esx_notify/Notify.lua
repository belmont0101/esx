local Debug = ESX.GetConfig().EnableDebug

local possiblePosition = {
    ["top-right"] = "top-right",
    ["top-left"] = "top-left",
    ["top-middle"] = "top",
    ["bottom-right"] = "bottom-right",
    ["bottom-left"] = "bottom-left",
    ["bottom-middle"] = "bottom",
    ["middle-left"] = "center-left",
    ["middle-right"] = "center-right"
}

---@param notificatonType string the notification type
---@param length number the length of the notification
---@param message any the message :D
---@param title string optional title for the notification
---@param position string optional position for the notification
local function Notify(notificatonType, length, message, title, position)
    if Debug then
        print("1 ".. tostring(notificatonType))
        print("2 "..tostring(length))
        print("3 "..message)
        print("4 "..tostring(title))
        print("5 "..tostring(position))
    end

    if type(notificatonType) ~= "string" then
        notificatonType = "info"
    end

    if type(length) ~= "number" then
        length = 3000
    end

    -- Convert ESX position to ox_lib position
    local oxPosition = "top-right"
    if position and possiblePosition[position] then
        oxPosition = possiblePosition[position]
    elseif Config.position and possiblePosition[Config.position] then
        oxPosition = possiblePosition[Config.position]
    end

    if Debug then
        print("6 ".. tostring(notificatonType))
        print("7 "..tostring(length))
        print("8 "..message)
        print("9 "..tostring(title))
        print("10 "..tostring(oxPosition))
    end

    if type(message) == "string" then
        message = message:gsub("~br~", "\n")
    end

    lib.notify({
        title = title or "New Notification",
        description = message or "ESX-Notify",
        type = notificatonType or "info",
        duration = length or 5000,
        position = oxPosition
    })
end

exports('Notify', Notify)
RegisterNetEvent("ESX:Notify", Notify)

if Debug then
    RegisterCommand("oldnotify", function()
        ESX.ShowNotification('No Waypoint Set.', true, false, 140)
    end)

    RegisterCommand("notify", function()
        ESX.ShowNotification("You Received \n1x ball!", "success", 3000)
    end)

    RegisterCommand("notify1", function()
        ESX.ShowNotification("Well ~g~Done~s~!", "success", 3000, "Achievement")
    end)

    RegisterCommand("notify2", function()
        ESX.ShowNotification("Information Received", "info", 3000, "System Info")
    end)

    RegisterCommand("notify3", function()
        ESX.ShowNotification("You Did something ~r~WRONG~s~!", "error", 3000, "Error")
    end)

    RegisterCommand("notify4", function()
        ESX.ShowNotification("You Did something ~r~WRONG~s~!", "warning", 3000, "~y~Warning~s~")
    end)   
end