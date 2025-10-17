Config = {}

-- General Settings
Config.Locale = 'da' -- Danish locale
Config.Debug = false -- Enable debug prints

-- Police Job Name (for alerts)
Config.PoliceJob = 'police'
Config.MinimumPolice = 0 -- Minimum police online for certain activities

-- Alert Chances (0-100)
Config.PoliceAlertChance = {
    Processing = 15, -- Chance of alert when processing drugs
    Selling = 30,    -- Chance of alert when selling drugs
    Mission = 20     -- Chance of alert during missions
}

-- ====================================
-- DRUG SYSTEM CONFIGURATION
-- ====================================

Config.Drugs = {
    ['coke'] = {
        label = 'Kokain',
        rawItem = 'raw_coke',
        rawLabel = 'Rå Kokain',
        processedItem = 'coke_bag',
        processedLabel = 'Kokain Pose',
        processTime = 8000, -- Time in ms
        processAmount = 10, -- Amount of raw needed
        processOutput = 25, -- Amount of processed output
        sellPrice = {min = 150, max = 250}, -- Random price range
        processingZones = {
            {
                coords = vector3(1391.74, 3605.94, 38.94), -- Sandy Shores - Abandoned motel
                heading = 200.0,
                label = 'Forarbejd Kokain',
                blipEnabled = false
            }
        }
    },
    ['heroin'] = {
        label = 'Heroin',
        rawItem = 'raw_heroin',
        rawLabel = 'Rå Heroin',
        processedItem = 'heroin_bag',
        processedLabel = 'Heroin Pose',
        processTime = 9000,
        processAmount = 5,
        processOutput = 10,
        sellPrice = {min = 180, max = 280},
        processingZones = {
            {
                coords = vector3(1905.48, 4922.95, 48.87), -- Grapeseed area - Farm
                heading = 150.0,
                label = 'Forarbejd Heroin',
                blipEnabled = false
            }
        }
    },
    ['meth'] = {
        label = 'Metamfetamin',
        rawItem = 'raw_meth',
        rawLabel = 'Rå Metamfetamin',
        processedItem = 'meth_bag',
        processedLabel = 'Metamfetamin Pose',
        processTime = 10000,
        processAmount = 10,
        processOutput = 30,
        sellPrice = {min = 200, max = 300},
        processingZones = {
            {
                coords = vector3(-1153.29, 4937.63, 222.29), -- Paleto Bay - Abandoned house
                heading = 120.0,
                label = 'Forarbejd Metamfetamin',
                blipEnabled = false
            }
        }
    },
    ['joint'] = {
        label = 'Joint',
        rawItem = 'cannabis',
        rawLabel = 'Cannabis',
        processedItem = 'joint',
        processedLabel = 'Joint',
        processTime = 5000,
        processAmount = 2,
        processOutput = 3,
        sellPrice = {min = 50, max = 100},
        processingZones = {
            {
                coords = vector3(2434.27, 4969.09, 46.81), -- Grapeseed - Warehouse
                heading = 45.0,
                label = 'Rul Joints',
                blipEnabled = false
            }
        }
    }
}

-- ====================================
-- DRUG DEALER CONFIGURATION
-- ====================================

Config.Dealers = {
    {
        name = 'Drug Dealer',
        coords = vector3(1961.95, 3743.61, 32.34), -- Sandy Shores - Behind Liquor Store
        heading = 210.0,
        model = 'g_m_y_lost_01',
        scenario = 'WORLD_HUMAN_DRUG_DEALER',
        acceptedDrugs = {'coke_bag', 'heroin_bag', 'meth_bag', 'joint'},
        blipEnabled = false,
        blip = {
            sprite = 514,
            color = 1,
            scale = 0.8,
            label = 'Drug Dealer'
        }
    },
    {
        name = 'Drug Dealer',
        coords = vector3(1701.24, 4917.88, 42.08), -- Grapeseed - Near Cluckin Bell
        heading = 90.0,
        model = 'g_m_y_lost_02',
        scenario = 'WORLD_HUMAN_SMOKING',
        acceptedDrugs = {'coke_bag', 'heroin_bag', 'meth_bag', 'joint'},
        blipEnabled = false
    },
    {
        name = 'Drug Dealer',
        coords = vector3(-428.56, 6171.02, 31.48), -- Paleto Bay - Behind motel
        heading = 225.0,
        model = 'g_m_y_mexgang_01',
        scenario = 'WORLD_HUMAN_DRUG_DEALER_HARD',
        acceptedDrugs = {'coke_bag', 'heroin_bag', 'meth_bag', 'joint'},
        blipEnabled = false
    },
    {
        name = 'Drug Dealer',
        coords = vector3(1527.29, 6330.54, 24.61), -- Paleto Bay - Industrial area
        heading = 180.0,
        model = 'g_m_y_ballaeast_01',
        scenario = 'WORLD_HUMAN_SMOKING',
        acceptedDrugs = {'coke_bag', 'heroin_bag', 'meth_bag', 'joint'},
        blipEnabled = false
    }
}

-- ====================================
-- MISSION CONFIGURATION
-- ====================================

Config.Missions = {
    enabled = true,
    cooldown = 300000, -- 5 minutes cooldown between missions (in ms)
    duration = 600000, -- 10 minutes to complete mission (in ms)
    rewardRange = {min = 2000, max = 5000},
    
    pickupLocations = {
        vector3(1905.21, 3729.16, 32.77), -- Sandy Shores - Gas station area
        vector3(2562.05, 4686.33, 34.08), -- Grapeseed - Farm area
        vector3(1686.90, 4689.29, 43.07), -- Grapeseed - North side
        vector3(-93.51, 6360.47, 31.49), -- Paleto Bay - Near pier
        vector3(-379.86, 6062.05, 31.50), -- Paleto Bay - Main street
        vector3(1697.16, 6425.87, 32.77), -- Paleto Bay - East industrial
        vector3(264.05, 3583.92, 36.72), -- Sandy Shores - Airfield area
        vector3(1588.06, 3587.23, 38.77) -- Sandy Shores - Mine area
    },
    
    dropoffLocations = {
        vector3(1961.95, 3743.61, 32.34), -- Sandy Shores - Dealer location
        vector3(1701.24, 4917.88, 42.08), -- Grapeseed - Dealer location
        vector3(-428.56, 6171.02, 31.48), -- Paleto Bay - Dealer location
        vector3(1527.29, 6330.54, 24.61), -- Paleto Bay - Industrial dealer
        vector3(1841.93, 3913.99, 33.26), -- Sandy Shores - Behind buildings
        vector3(2134.17, 4780.93, 40.97), -- Grapeseed - Secluded area
        vector3(-158.33, 6152.47, 31.21), -- Paleto Bay - Back alley
        vector3(1712.39, 3289.95, 41.14) -- Sandy Shores - Desert area
    },
    
    blipSettings = {
        pickup = {sprite = 501, color = 5, scale = 1.0},
        dropoff = {sprite = 280, color = 2, scale = 1.0}
    }
}

-- ====================================
-- INTERACTION SETTINGS
-- ====================================

Config.InteractionDistance = 2.0 -- Distance for ox_target interactions

-- ====================================
-- LOCALIZATION
-- ====================================

Config.Locales = {
    ['da'] = {
        -- Processing
        ['processing_started'] = 'Du begynder at forarbejde %s...',
        ['processing_success'] = 'Du har forarbejdet %dx %s',
        ['processing_cancelled'] = 'Forarbejdning annulleret',
        ['not_enough_items'] = 'Du har ikke nok %s (behøver %d)',
        ['inventory_full'] = 'Dit inventar er fuldt',
        ['processing_in_progress'] = 'Du forarbejder allerede noget',
        
        -- Selling
        ['selling_started'] = 'Du sælger til dealeren...',
        ['selling_success'] = 'Du solgte %dx %s for $%d',
        ['no_drugs_to_sell'] = 'Du har ingen stoffer at sælge',
        ['dealer_not_interested'] = 'Dealeren er ikke interesseret i det du har',
        ['already_selling'] = 'Du sælger allerede noget',
        
        -- Missions
        ['mission_started'] = 'Mission påbegyndt! Gå til afhentningsstedet',
        ['mission_cooldown'] = 'Du skal vente %d sekunder før næste mission',
        ['mission_pickup'] = 'Tryk ~g~E~s~ for at afhente pakken',
        ['mission_dropoff'] = 'Tryk ~g~E~s~ for at aflevere pakken',
        ['mission_pickup_success'] = 'Pakke afhentet! Lever den til det markerede sted',
        ['mission_dropoff_success'] = 'Mission fuldført! Du modtog $%d',
        ['mission_expired'] = 'Missionen udløb',
        ['mission_failed'] = 'Mission fejlet',
        ['mission_in_progress'] = 'Du har allerede en aktiv mission',
        
        -- Police Alerts
        ['police_alert_title'] = 'Mistænkelig Aktivitet',
        ['police_alert_processing'] = 'Mistænkelig aktivitet rapporteret: Mulig narkotikaforarbejdning',
        ['police_alert_selling'] = 'Mistænkelig aktivitet rapporteret: Muligt narkotikasalg',
        ['police_alert_mission'] = 'Mistænkelig aktivitet rapporteret: Mulig illegal handel',
        
        -- Interactions
        ['process_drug'] = 'Forarbejd %s',
        ['sell_drugs'] = 'Sælg Stoffer',
        ['start_mission'] = 'Start Narko Mission',
        ['drug_dealer'] = 'Narkotika Dealer',
        
        -- Menu
        ['sell_menu_title'] = 'Sælg Stoffer',
        ['sell_menu_description'] = 'Hvad vil du sælge?',
        ['sell_item'] = '%s ($%d - $%d pr. stk)',
        ['amount_to_sell'] = 'Hvor mange vil du sælge?',
        ['invalid_amount'] = 'Ugyldigt antal',
        ['confirm_sell'] = 'Bekræft salg af %dx %s'
    }
}

-- Helper function to get locale string
function _U(str, ...)
    if Config.Locales[Config.Locale] and Config.Locales[Config.Locale][str] then
        return string.format(Config.Locales[Config.Locale][str], ...)
    else
        return 'Translation [' .. str .. '] does not exist'
    end
end

-- Helper function for debugging
function DebugPrint(...)
    if Config.Debug then
        print('[ILLEGAL_JOBS]', ...)
    end
end
