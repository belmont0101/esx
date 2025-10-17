-- ====================================
-- CLIENT-SIDE LOGIC
-- ====================================

-- Get ESX object
ESX = exports['es_extended']:getSharedObject()

-- Local variables
local isProcessing = false
local currentMission = nil
local missionBlips = {}
local dealerPeds = {}

-- ====================================
-- UTILITY FUNCTIONS
-- ====================================

-- Create blip
local function CreateBlip(coords, sprite, color, scale, label, shortRange)
    local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(blip, sprite)
    SetBlipColour(blip, color)
    SetBlipScale(blip, scale)
    SetBlipAsShortRange(blip, shortRange or false)
    
    if label then
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentSubstringPlayerName(label)
        EndTextCommandSetBlipName(blip)
    end
    
    return blip
end

-- Remove blip
local function RemoveBlip(blip)
    if DoesBlipExist(blip) then
        RemoveBlip(blip)
    end
end

-- Create dealer ped
local function CreateDealerPed(dealerConfig)
    local hash = GetHashKey(dealerConfig.model)
    
    RequestModel(hash)
    while not HasModelLoaded(hash) do
        Wait(100)
    end
    
    local ped = CreatePed(4, hash, dealerConfig.coords.x, dealerConfig.coords.y, dealerConfig.coords.z, dealerConfig.heading, false, true)
    
    SetEntityInvincible(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    FreezeEntityPosition(ped, true)
    
    if dealerConfig.scenario then
        TaskStartScenarioInPlace(ped, dealerConfig.scenario, 0, true)
    end
    
    return ped
end

-- ====================================
-- DRUG PROCESSING
-- ====================================

-- Setup processing zones
local function SetupProcessingZones()
    for drugType, drugConfig in pairs(Config.Drugs) do
        for zoneIndex, zone in ipairs(drugConfig.processingZones) do
            -- Create ox_target zone
            exports.ox_target:addSphereZone({
                coords = zone.coords,
                radius = Config.InteractionDistance,
                debug = Config.Debug,
                options = {
                    {
                        name = 'process_' .. drugType .. '_' .. zoneIndex,
                        icon = 'fas fa-flask',
                        label = zone.label or _U('process_drug', drugConfig.label),
                        onSelect = function()
                            if isProcessing then
                                lib.notify({
                                    title = 'Illegal Jobs',
                                    description = _U('processing_in_progress'),
                                    type = 'error'
                                })
                                return
                            end
                            
                            ProcessDrug(drugType)
                        end
                    }
                }
            })
            
            -- Create blip if enabled
            if zone.blipEnabled then
                CreateBlip(zone.coords, 499, 1, 0.8, zone.label, true)
            end
        end
    end
end

-- Process drug
function ProcessDrug(drugType)
    local drugConfig = Config.Drugs[drugType]
    
    if not drugConfig then return end
    
    isProcessing = true
    
    -- Start progress bar
    if lib.progressCircle({
        duration = drugConfig.processTime,
        position = 'bottom',
        label = _U('processing_started', drugConfig.label),
        useWhileDead = false,
        canCancel = true,
        disable = {
            car = true,
            move = true,
            combat = true
        },
        anim = {
            dict = 'mini@repair',
            clip = 'fixing_a_ped'
        }
    }) then
        -- Progress completed - Tell server to process (server will verify and handle rewards immediately)
        TriggerServerEvent('illegal_jobs:ProcessDrug', drugType, true)
    else
        -- Cancelled
        lib.notify({
            title = 'Illegal Jobs',
            description = _U('processing_cancelled'),
            type = 'error'
        })
        TriggerServerEvent('illegal_jobs:CancelProcessing')
    end
    
    isProcessing = false
end

-- ====================================
-- DRUG SELLING
-- ====================================

-- Setup dealer zones and peds
local function SetupDealers()
    for dealerIndex, dealerConfig in ipairs(Config.Dealers) do
        -- Create ped
        local ped = CreateDealerPed(dealerConfig)
        dealerPeds[dealerIndex] = ped
        
        -- Create ox_target for ped
        exports.ox_target:addLocalEntity(ped, {
            {
                name = 'dealer_' .. dealerIndex,
                icon = 'fas fa-handshake',
                label = _U('sell_drugs'),
                onSelect = function()
                    OpenSellMenu(dealerIndex)
                end
            }
        })
        
        -- Create blip if enabled
        if dealerConfig.blipEnabled then
            CreateBlip(
                dealerConfig.coords,
                dealerConfig.blip.sprite,
                dealerConfig.blip.color,
                dealerConfig.blip.scale,
                dealerConfig.blip.label,
                true
            )
        end
    end
end

-- Open sell menu
function OpenSellMenu(dealerIndex)
    ESX.TriggerServerCallback('illegal_jobs:GetAvailableDrugs', function(availableDrugs)
        if #availableDrugs == 0 then
            lib.notify({
                title = 'Illegal Jobs',
                description = _U('no_drugs_to_sell'),
                type = 'error'
            })
            return
        end
        
        -- Build menu options
        local menuOptions = {}
        
        for _, drug in ipairs(availableDrugs) do
            table.insert(menuOptions, {
                title = drug.label,
                description = string.format('Du har %dx | Pris: $%d - $%d pr. stk', drug.count, drug.minPrice, drug.maxPrice),
                icon = 'cannabis',
                onSelect = function()
                    -- Ask for amount
                    local input = lib.inputDialog(_U('amount_to_sell'), {
                        {
                            type = 'number',
                            label = drug.label,
                            description = string.format('Maks: %d', drug.count),
                            required = true,
                            min = 1,
                            max = drug.count
                        }
                    })
                    
                    if input and input[1] then
                        local amount = tonumber(input[1])
                        
                        if amount and amount > 0 and amount <= drug.count then
                            -- Show progress bar
                            if lib.progressCircle({
                                duration = 3000,
                                position = 'bottom',
                                label = _U('selling_started'),
                                useWhileDead = false,
                                canCancel = true,
                                disable = {
                                    car = true,
                                    move = true,
                                    combat = true
                                },
                                anim = {
                                    dict = 'mp_common',
                                    clip = 'givetake1_a'
                                }
                            }) then
                                -- Tell server to process sale
                                TriggerServerEvent('illegal_jobs:SellDrug', drug.item, amount)
                            else
                                lib.notify({
                                    title = 'Illegal Jobs',
                                    description = _U('processing_cancelled'),
                                    type = 'error'
                                })
                            end
                        else
                            lib.notify({
                                title = 'Illegal Jobs',
                                description = _U('invalid_amount'),
                                type = 'error'
                            })
                        end
                    end
                end
            })
        end
        
        -- Show context menu
        lib.registerContext({
            id = 'drug_sell_menu',
            title = _U('sell_menu_title'),
            options = menuOptions
        })
        
        lib.showContext('drug_sell_menu')
    end, dealerIndex)
end

-- ====================================
-- MISSIONS SYSTEM
-- ====================================

-- Mission start point (example - you can add a ped or zone)
local function SetupMissionStarter()
    -- Example: Add a ped or zone where players can start missions
    local missionStartCoords = vector3(1961.95, 3743.61, 32.34) -- Sandy Shores - Near dealer
    
    exports.ox_target:addSphereZone({
        coords = missionStartCoords,
        radius = 2.0,
        debug = Config.Debug,
        options = {
            {
                name = 'start_drug_mission',
                icon = 'fas fa-briefcase',
                label = _U('start_mission'),
                onSelect = function()
                    if currentMission then
                        lib.notify({
                            title = 'Illegal Jobs',
                            description = _U('mission_in_progress'),
                            type = 'error'
                        })
                        return
                    end
                    
                    TriggerServerEvent('illegal_jobs:StartMission')
                end
            }
        }
    })
end

-- Mission started event
RegisterNetEvent('illegal_jobs:MissionStarted', function(missionData)
    currentMission = {
        pickup = missionData.pickup,
        dropoff = missionData.dropoff,
        pickedUp = false
    }
    
    -- Create pickup blip
    missionBlips.pickup = CreateBlip(
        missionData.pickup,
        Config.Missions.blipSettings.pickup.sprite,
        Config.Missions.blipSettings.pickup.color,
        Config.Missions.blipSettings.pickup.scale,
        'Mission Afhentning',
        false
    )
    
    SetBlipRoute(missionBlips.pickup, true)
    
    -- Create pickup zone
    exports.ox_target:addSphereZone({
        coords = missionData.pickup,
        radius = 2.0,
        debug = Config.Debug,
        options = {
            {
                name = 'mission_pickup',
                icon = 'fas fa-box',
                label = 'Hent Pakke',
                onSelect = function()
                    if not currentMission or currentMission.pickedUp then
                        return
                    end
                    
                    if lib.progressCircle({
                        duration = 5000,
                        position = 'bottom',
                        label = 'Henter pakke...',
                        useWhileDead = false,
                        canCancel = true,
                        disable = {
                            car = true,
                            move = true,
                            combat = true
                        },
                        anim = {
                            dict = 'pickup_object',
                            clip = 'pickup_low'
                        }
                    }) then
                        TriggerServerEvent('illegal_jobs:MissionPickup')
                        
                        -- Remove pickup blip and zone
                        RemoveBlip(missionBlips.pickup)
                        exports.ox_target:removeZone('mission_pickup')
                        
                        -- Create dropoff blip
                        missionBlips.dropoff = CreateBlip(
                            currentMission.dropoff,
                            Config.Missions.blipSettings.dropoff.sprite,
                            Config.Missions.blipSettings.dropoff.color,
                            Config.Missions.blipSettings.dropoff.scale,
                            'Mission Aflevering',
                            false
                        )
                        
                        SetBlipRoute(missionBlips.dropoff, true)
                        
                        -- Create dropoff zone
                        exports.ox_target:addSphereZone({
                            coords = currentMission.dropoff,
                            radius = 2.0,
                            debug = Config.Debug,
                            options = {
                                {
                                    name = 'mission_dropoff',
                                    icon = 'fas fa-box-open',
                                    label = 'Aflever Pakke',
                                    onSelect = function()
                                        if not currentMission or not currentMission.pickedUp then
                                            return
                                        end
                                        
                                        if lib.progressCircle({
                                            duration = 5000,
                                            position = 'bottom',
                                            label = 'Afleverer pakke...',
                                            useWhileDead = false,
                                            canCancel = true,
                                            disable = {
                                                car = true,
                                                move = true,
                                                combat = true
                                            },
                                            anim = {
                                                dict = 'pickup_object',
                                                clip = 'putdown_low'
                                            }
                                        }) then
                                            TriggerServerEvent('illegal_jobs:MissionDropoff')
                                        end
                                    end
                                }
                            }
                        })
                        
                        currentMission.pickedUp = true
                    end
                end
            }
        }
    })
end)

-- Mission completed event
RegisterNetEvent('illegal_jobs:MissionCompleted', function()
    -- Clean up blips and zones
    if missionBlips.dropoff then
        RemoveBlip(missionBlips.dropoff)
    end
    
    exports.ox_target:removeZone('mission_dropoff')
    
    currentMission = nil
    missionBlips = {}
end)

-- Mission expired event
RegisterNetEvent('illegal_jobs:MissionExpired', function()
    -- Clean up blips and zones
    if missionBlips.pickup then
        RemoveBlip(missionBlips.pickup)
    end
    
    if missionBlips.dropoff then
        RemoveBlip(missionBlips.dropoff)
    end
    
    exports.ox_target:removeZone('mission_pickup')
    exports.ox_target:removeZone('mission_dropoff')
    
    currentMission = nil
    missionBlips = {}
end)

-- ====================================
-- POLICE ALERTS
-- ====================================

-- Listen for police alerts (for police job players)
RegisterNetEvent('illegal_jobs:PoliceAlert', function(data)
    -- Create alert blip
    local blip = CreateBlip(data.coords, 161, 1, 1.0, data.title, false)
    SetBlipFlashes(blip, true)
    
    -- Notify officer
    lib.notify({
        title = data.title,
        description = data.message,
        type = 'error',
        duration = 10000
    })
    
    -- Remove blip after 60 seconds
    SetTimeout(60000, function()
        RemoveBlip(blip)
    end)
end)

-- ====================================
-- INITIALIZATION
-- ====================================

CreateThread(function()
    -- Wait for ESX to be ready
    while not ESX.IsPlayerLoaded() do
        Wait(100)
    end
    
    -- Setup all systems
    SetupProcessingZones()
    SetupDealers()
    SetupMissionStarter()
    
    print('^2[ILLEGAL_JOBS] ^7Client initialized successfully^0')
end)

-- Cleanup on resource stop
AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    
    -- Remove all dealer peds
    for _, ped in pairs(dealerPeds) do
        if DoesEntityExist(ped) then
            DeleteEntity(ped)
        end
    end
    
    -- Remove mission blips
    for _, blip in pairs(missionBlips) do
        RemoveBlip(blip)
    end
    
    -- Remove all ox_target zones (ox_target handles this automatically)
end)
