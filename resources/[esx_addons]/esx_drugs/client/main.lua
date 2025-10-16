local menuOpen = false
local inZoneDrugShop = false
local inRangeMarkerDrugShop = false
local cfgMarker = Config.Marker;

--slow loop
CreateThread(function()
	while true do
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)
		local distDrugShop = #(coords - Config.CircleZones.DrugDealer.coords)

		inRangeMarkerDrugShop = false
		if(distDrugShop <= Config.Marker.Distance) then
			inRangeMarkerDrugShop = true
		end

		if distDrugShop < 1 then
			inZoneDrugShop = true
		else
			inZoneDrugShop = false
			if menuOpen then
				menuOpen=false
			end
		end

		Wait(500)
	end
end)

--drawk marker
CreateThread(function()
	while true do 
		local Sleep = 1500
		if(inRangeMarkerDrugShop) then
			Sleep = 0
			local coordsMarker = Config.CircleZones.DrugDealer.coords
			local color = cfgMarker.Color
			DrawMarker(cfgMarker.Type, coordsMarker.x, coordsMarker.y,coordsMarker.z - 1.0,
			0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 
			cfgMarker.Size, color.r,color.g,color.b,color.a,
			false, true, 2, false, nil, nil, false)
		end
		Wait(Sleep)
	end
end)

--main loop
CreateThread(function ()
	while true do 
		local Sleep = 1500
		if inZoneDrugShop and not menuOpen then
			Sleep = 0
			lib.showTextUI(TranslateCap('dealer_prompt'), {
				position = "right-center",
				icon = 'hand-holding-dollar'
			})
			if IsControlJustPressed(0, 38) then
				lib.hideTextUI()
				OpenDrugShop()
			end
		else
			lib.hideTextUI()
		end
	Wait(Sleep)
	end
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

function CreateBlipCircle(coords, text, radius, color, sprite)
	local blip = AddBlipForRadius(coords, radius)

	SetBlipHighDetail(blip, true)
	SetBlipColour(blip, 1)
	SetBlipAlpha (blip, 128)

	-- create a blip in the middle
	blip = AddBlipForCoord(coords)

	SetBlipHighDetail(blip, true)
	SetBlipSprite (blip, sprite)
	SetBlipScale  (blip, 1.0)
	SetBlipColour (blip, color)
	SetBlipAsShortRange(blip, true)

	BeginTextCommandSetBlipName("STRING")
	AddTextComponentSubstringPlayerName(text)
	EndTextCommandSetBlipName(blip)
end

CreateThread(function()
	for k,zone in pairs(Config.CircleZones) do
		CreateBlipCircle(zone.coords, zone.name, zone.radius, zone.color, zone.sprite)
	end
end)
