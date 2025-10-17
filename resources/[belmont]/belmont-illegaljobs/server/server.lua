-- ====================================
-- SERVER-SIDE LOGIC
-- ====================================

-- Get ESX object
ESX = exports['es_extended']:getSharedObject()

-- Active missions tracking
local activeMissions = {}
local missionCooldowns = {}

-- Processing tracking (anti-spam)
local processingPlayers = {}

-- ====================================
-- UTILITY FUNCTIONS
-- ====================================

-- Get player count for specific job
local function GetPoliceCount()
    local count = 0
    local xPlayers = ESX.GetExtendedPlayers('job', Config.PoliceJob)
    return #xPlayers
end

-- Send police alert
local function SendPoliceAlert(coords, alertType)
    local policeCount = GetPoliceCount()
    
    if policeCount > 0 then
        local xPlayers = ESX.GetExtendedPlayers('job', Config.PoliceJob)
        
        local alertMessage = ''
        if alertType == 'processing' then
            alertMessage = _U('police_alert_processing')
        elseif alertType == 'selling' then
            alertMessage = _U('police_alert_selling')
        elseif alertType == 'mission' then
            alertMessage = _U('police_alert_mission')
        end
        
        for _, xPlayer in pairs(xPlayers) do
            TriggerClientEvent('illegal_jobs:PoliceAlert', xPlayer.source, {
                title = _U('police_alert_title'),
                message = alertMessage,
                coords = coords
            })
        end
        
        DebugPrint('Police alert sent to ' .. policeCount .. ' officers')
    end
end

-- Check if alert should be sent (random chance)
local function ShouldSendAlert(alertType)
    local chance = 0
    
    if alertType == 'processing' then
        chance = Config.PoliceAlertChance.Processing
    elseif alertType == 'selling' then
        chance = Config.PoliceAlertChance.Selling
    elseif alertType == 'mission' then
        chance = Config.PoliceAlertChance.Mission
    end
    
    return math.random(100) <= chance
end

-- ====================================
-- DRUG PROCESSING
-- ====================================

RegisterNetEvent('illegal_jobs:ProcessDrug', function(drugType, progressCompleted)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if not xPlayer then return end
    
    -- Anti-spam check
    if processingPlayers[source] then
        return
    end
    
    -- Validate drug type
    local drugConfig = Config.Drugs[drugType]
    if not drugConfig then
        DebugPrint('Invalid drug type: ' .. tostring(drugType))
        return
    end
    
    -- Check if player has required items
    local hasItem = exports.ox_inventory:GetItem(source, drugConfig.rawItem, nil, true)
    
    if not hasItem or hasItem < drugConfig.processAmount then
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Illegal Jobs',
            description = _U('not_enough_items', drugConfig.rawLabel, drugConfig.processAmount),
            type = 'error'
        })
        return
    end
    
    -- Check if inventory has space
    local canCarry = exports.ox_inventory:CanCarryItem(source, drugConfig.processedItem, drugConfig.processOutput)
    
    if not canCarry then
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Illegal Jobs',
            description = _U('inventory_full'),
            type = 'error'
        })
        return
    end
    
    -- Mark player as processing
    processingPlayers[source] = true
    
    -- If progress bar was completed on client, process immediately
    if progressCompleted then
        -- Remove raw materials
        exports.ox_inventory:RemoveItem(source, drugConfig.rawItem, drugConfig.processAmount)
        
        -- Add processed drugs
        exports.ox_inventory:AddItem(source, drugConfig.processedItem, drugConfig.processOutput)
        
        -- Notify player
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Illegal Jobs',
            description = _U('processing_success', drugConfig.processOutput, drugConfig.processedLabel),
            type = 'success'
        })
        
        -- Police alert chance
        if ShouldSendAlert('processing') then
            local playerCoords = GetEntityCoords(GetPlayerPed(source))
            SendPoliceAlert(playerCoords, 'processing')
        end
        
        DebugPrint('Player ' .. source .. ' processed ' .. drugType)
        
        -- Remove processing flag
        processingPlayers[source] = nil
    end
end)

-- Cancel processing (if player moves away or interrupts)
RegisterNetEvent('illegal_jobs:CancelProcessing', function()
    local source = source
    processingPlayers[source] = nil
end)

-- ====================================
-- DRUG SELLING
-- ====================================

RegisterNetEvent('illegal_jobs:SellDrug', function(drugItem, amount)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if not xPlayer then return end
    
    -- Validate amount
    if not amount or amount < 1 then
        return
    end
    
    -- Find drug config
    local drugConfig = nil
    local drugType = nil
    
    for dtype, config in pairs(Config.Drugs) do
        if config.processedItem == drugItem then
            drugConfig = config
            drugType = dtype
            break
        end
    end
    
    if not drugConfig then
        DebugPrint('Invalid drug item: ' .. tostring(drugItem))
        return
    end
    
    -- Check if player has the items
    local hasItem = exports.ox_inventory:GetItem(source, drugItem, nil, true)
    
    if not hasItem or hasItem < amount then
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Illegal Jobs',
            description = _U('not_enough_items', drugConfig.processedLabel, amount),
            type = 'error'
        })
        return
    end
    
    -- Calculate payout
    local pricePerUnit = math.random(drugConfig.sellPrice.min, drugConfig.sellPrice.max)
    local totalPayout = pricePerUnit * amount
    
    -- Remove items
    exports.ox_inventory:RemoveItem(source, drugItem, amount)
    
    -- Add money (black money for illegal activities)
    local account = xPlayer.getAccount('black_money')
    if account then
        xPlayer.addAccountMoney('black_money', totalPayout)
    else
        xPlayer.addMoney(totalPayout, "Illegal Drug Sale")
    end
    
    -- Notify player
    TriggerClientEvent('ox_lib:notify', source, {
        title = 'Illegal Jobs',
        description = _U('selling_success', amount, drugConfig.processedLabel, totalPayout),
        type = 'success'
    })
    
    -- Police alert chance
    if ShouldSendAlert('selling') then
        local playerCoords = GetEntityCoords(GetPlayerPed(source))
        SendPoliceAlert(playerCoords, 'selling')
    end
    
    DebugPrint('Player ' .. source .. ' sold ' .. amount .. 'x ' .. drugItem .. ' for $' .. totalPayout)
end)

-- Get available drugs for selling (called from client)
ESX.RegisterServerCallback('illegal_jobs:GetAvailableDrugs', function(source, cb, dealerIndex)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then 
        cb({})
        return 
    end
    
    local availableDrugs = {}
    local dealer = Config.Dealers[dealerIndex]
    
    if not dealer then
        cb({})
        return
    end
    
    for _, drugItem in ipairs(dealer.acceptedDrugs) do
        local itemCount = exports.ox_inventory:GetItem(source, drugItem, nil, true)
        
        if itemCount and itemCount > 0 then
            -- Find drug config for price info
            for dtype, config in pairs(Config.Drugs) do
                if config.processedItem == drugItem then
                    table.insert(availableDrugs, {
                        item = drugItem,
                        label = config.processedLabel,
                        count = itemCount,
                        minPrice = config.sellPrice.min,
                        maxPrice = config.sellPrice.max
                    })
                    break
                end
            end
        end
    end
    
    cb(availableDrugs)
end)

-- ====================================
-- MISSIONS SYSTEM
-- ====================================

-- Start mission
RegisterNetEvent('illegal_jobs:StartMission', function()
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if not xPlayer then return end
    
    -- Check if missions are enabled
    if not Config.Missions.enabled then
        return
    end
    
    -- Check if player already has active mission
    if activeMissions[source] then
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Illegal Jobs',
            description = _U('mission_in_progress'),
            type = 'error'
        })
        return
    end
    
    -- Check cooldown
    local currentTime = os.time()
    if missionCooldowns[source] and currentTime < missionCooldowns[source] then
        local remaining = missionCooldowns[source] - currentTime
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Illegal Jobs',
            description = _U('mission_cooldown', remaining),
            type = 'error'
        })
        return
    end
    
    -- Select random pickup and dropoff locations
    local pickupIndex = math.random(#Config.Missions.pickupLocations)
    local dropoffIndex = math.random(#Config.Missions.dropoffLocations)
    
    -- Make sure pickup and dropoff are different
    while pickupIndex == dropoffIndex and #Config.Missions.dropoffLocations > 1 do
        dropoffIndex = math.random(#Config.Missions.dropoffLocations)
    end
    
    local pickup = Config.Missions.pickupLocations[pickupIndex]
    local dropoff = Config.Missions.dropoffLocations[dropoffIndex]
    
    -- Calculate reward
    local reward = math.random(Config.Missions.rewardRange.min, Config.Missions.rewardRange.max)
    
    -- Create mission
    activeMissions[source] = {
        pickup = pickup,
        dropoff = dropoff,
        reward = reward,
        startTime = currentTime,
        pickedUp = false
    }
    
    -- Send mission to client
    TriggerClientEvent('illegal_jobs:MissionStarted', source, {
        pickup = pickup,
        dropoff = dropoff
    })
    
    TriggerClientEvent('ox_lib:notify', source, {
        title = 'Illegal Jobs',
        description = _U('mission_started'),
        type = 'info'
    })
    
    -- Set mission timeout
    SetTimeout(Config.Missions.duration, function()
        if activeMissions[source] and not activeMissions[source].completed then
            activeMissions[source] = nil
            TriggerClientEvent('illegal_jobs:MissionExpired', source)
            TriggerClientEvent('ox_lib:notify', source, {
                title = 'Illegal Jobs',
                description = _U('mission_expired'),
                type = 'error'
            })
        end
    end)
    
    DebugPrint('Mission started for player ' .. source)
end)

-- Mission pickup
RegisterNetEvent('illegal_jobs:MissionPickup', function()
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if not xPlayer then return end
    
    local mission = activeMissions[source]
    if not mission or mission.pickedUp then
        return
    end
    
    -- Mark as picked up
    mission.pickedUp = true
    
    TriggerClientEvent('ox_lib:notify', source, {
        title = 'Illegal Jobs',
        description = _U('mission_pickup_success'),
        type = 'success'
    })
    
    -- Police alert chance
    if ShouldSendAlert('mission') then
        SendPoliceAlert(mission.pickup, 'mission')
    end
    
    DebugPrint('Player ' .. source .. ' picked up mission package')
end)

-- Mission dropoff
RegisterNetEvent('illegal_jobs:MissionDropoff', function()
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if not xPlayer then return end
    
    local mission = activeMissions[source]
    if not mission or not mission.pickedUp or mission.completed then
        return
    end
    
    -- Mark as completed
    mission.completed = true
    
    -- Give reward (black money)
    local account = xPlayer.getAccount('black_money')
    if account then
        xPlayer.addAccountMoney('black_money', mission.reward)
    else
        xPlayer.addMoney(mission.reward, "Illegal Mission Reward")
    end
    
    TriggerClientEvent('ox_lib:notify', source, {
        title = 'Illegal Jobs',
        description = _U('mission_dropoff_success', mission.reward),
        type = 'success'
    })
    
    -- Police alert chance
    if ShouldSendAlert('mission') then
        SendPoliceAlert(mission.dropoff, 'mission')
    end
    
    -- Set cooldown
    missionCooldowns[source] = os.time() + (Config.Missions.cooldown / 1000)
    
    -- Clean up mission
    activeMissions[source] = nil
    
    TriggerClientEvent('illegal_jobs:MissionCompleted', source)
    
    DebugPrint('Player ' .. source .. ' completed mission for $' .. mission.reward)
end)

-- Clean up on player disconnect
AddEventHandler('playerDropped', function()
    local source = source
    activeMissions[source] = nil
    missionCooldowns[source] = nil
    processingPlayers[source] = nil
end)

-- ====================================
-- STARTUP
-- ====================================

CreateThread(function()
    print('^2[ILLEGAL_JOBS] ^7Script loaded successfully^0')
    print('^2[ILLEGAL_JOBS] ^7Author: Belmont Development^0')
    print('^2[ILLEGAL_JOBS] ^7Version: 1.0.0^0')
end)
