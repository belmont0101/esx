local menuOpen = false
local drugDealerNPC = nil
local drugDealerBlip = nil

-- Spawn Drug Dealer NPC
CreateThread(function()
    -- Load NPC model
    local model = GetHashKey(Config.DrugDealerNPC.model)
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(1)
    end
    
    -- Create NPC
    drugDealerNPC = CreatePed(4, model, Config.DrugDealerNPC.coords.x, Config.DrugDealerNPC.coords.y, Config.DrugDealerNPC.coords.z - 1.0, Config.DrugDealerNPC.coords.w, false, true)
    
    -- Set NPC properties
    SetEntityHealth(drugDealerNPC, 200)
    SetPedCanRagdoll(drugDealerNPC, false)
    SetEntityInvincible(drugDealerNPC, true)
    FreezeEntityPosition(drugDealerNPC, true)
    SetBlockingOfNonTemporaryEvents(drugDealerNPC, true)
    
    -- Start scenario
    TaskStartScenarioInPlace(drugDealerNPC, Config.DrugDealerNPC.scenario, 0, true)
    
    -- Add ox_target interaction
    exports.ox_target:addLocalEntity(drugDealerNPC, {
        {
            name = 'drug_dealer',
            icon = 'fas fa-cannabis',
            label = 'Access Drug Dealer',
            onSelect = function()
                if not menuOpen then
                    OpenDrugShop()
                end
            end,
            canInteract = function()
                return not menuOpen
            end
        }
    })
    
    -- Create blip if enabled
    if Config.DrugDealerNPC.enableBlip then
        drugDealerBlip = AddBlipForEntity(drugDealerNPC)
        SetBlipSprite(drugDealerBlip, Config.DrugDealerNPC.blip.sprite)
        SetBlipColour(drugDealerBlip, Config.DrugDealerNPC.blip.color)
        SetBlipScale(drugDealerBlip, Config.DrugDealerNPC.blip.scale)
        SetBlipAsShortRange(drugDealerBlip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName(Config.DrugDealerNPC.blip.name)
        EndTextCommandSetBlipName(drugDealerBlip)
    end
    
    SetModelAsNoLongerNeeded(model)
end)

function OpenDrugShop()
	local options = {}
	menuOpen = true

	for k, v in pairs(ESX.GetPlayerData().inventory) do
		local price = Config.DrugDealerItems[v.name]

		if price and v.count > 0 then
			options[#options + 1] = {
				title = v.label,
				description = TranslateCap('dealer_item', ESX.Math.GroupDigits(price)),
				icon = 'cannabis',
				onSelect = function()
					OpenSellMenu(v.name, v.label, price, v.count)
				end
			}
		end
	end

	if #options == 0 then
		lib.notify({
			title = 'Drug Dealer',
			description = 'You have no drugs to sell',
			type = 'error'
		})
		menuOpen = false
		return
	end

	lib.registerContext({
		id = 'drug_shop_menu',
		title = TranslateCap('dealer_title'),
		options = options
	})

	lib.showContext('drug_shop_menu')
end

function OpenSellMenu(itemName, itemLabel, price, maxAmount)
	local input = lib.inputDialog('Sell ' .. itemLabel, {
		{
			type = 'number',
			label = 'Amount',
			placeholder = 'Amount you want to sell',
			min = Config.SellMenu.Min,
			max = math.min(Config.SellMenu.Max, maxAmount),
			required = true
		}
	})

	if input and input[1] and input[1] > 0 then
		TriggerServerEvent('esx_drugs:sellDrug', itemName, input[1])
	end
	
	menuOpen = false
end

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		lib.hideContext()
		lib.hideTextUI()
	end
end)

function OpenBuyLicenseMenu(licenseName)
	menuOpen = true
	local license = Config.LicensePrices[licenseName]

	local alert = lib.alertDialog({
		header = TranslateCap('purchase_license'),
		content = ('%s - %s'):format(license.label, TranslateCap('dealer_item', ESX.Math.GroupDigits(license.price))),
		centered = true,
		cancel = true
	})

	if alert == 'confirm' then
		ESX.TriggerServerCallback('esx_drugs:buyLicense', function(boughtLicense)
			if boughtLicense then
				lib.notify({
					title = 'License',
					description = TranslateCap('license_bought', license.label, ESX.Math.GroupDigits(license.price)),
					type = 'success'
				})
			else
				lib.notify({
					title = 'License',
					description = TranslateCap('license_bought_fail', license.label),
					type = 'error'
				})
			end
		end, licenseName)
	end
	
	menuOpen = false
end

-- Blip creation removed - no blips will be displayed on map

-- Cleanup when resource stops
AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		if drugDealerNPC then
			exports.ox_target:removeLocalEntity(drugDealerNPC, 'drug_dealer')
			DeleteEntity(drugDealerNPC)
		end
		if drugDealerBlip then
			RemoveBlip(drugDealerBlip)
		end
		lib.hideContext()
		lib.hideTextUI()
	end
end)
