Citizen.CreateThread(function() while not ESX do TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end) Citizen.Wait(500) end end)

local isNearPump = false
local isFueling = false
local currentFuel = 0.0
local currentCost = 0.0
local currentCash = 1000
local fuelSynced = false
local inBlacklisted = false

local function LoadAnimDict(dict)
	if not HasAnimDictLoaded(dict) then
		RequestAnimDict(dict)
		while not HasAnimDictLoaded(dict) do Citizen.Wait(1) end
	end
end

local function DrawText3Ds(x, y, z, text)
	local onScreen,_x,_y=World3dToScreen2d(x,y,z)
	if onScreen then
		SetTextScale(0.35, 0.35)
		SetTextFont(4)
		SetTextProportional(1)
		SetTextColour(255, 255, 255, 215)
		SetTextEntry("STRING")
		SetTextCentre(1)
		AddTextComponentString(text)
		DrawText(_x,_y)
	end
end

local function Round(num, numDecimalPlaces)
	local mult = 10^(numDecimalPlaces or 0)
	return math.floor(num * mult + 0.5) / mult
end

function CreateBlip(coords)
	local blip = AddBlipForCoord(coords)
	SetBlipSprite(blip, 361)
	SetBlipScale(blip, 0.9)
	SetBlipColour(blip, 4)
	SetBlipDisplay(blip, 4)
	SetBlipAsShortRange(blip, true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Gas Station")
	EndTextCommandSetBlipName(blip)
	return blip
end

function FindNearestFuelPump()
	local coords = GetEntityCoords(PlayerPedId())
	local fuelPumps = {}
	local handle, object = FindFirstObject()
	local success
	repeat
		if ConfigFuel.PumpModels[GetEntityModel(object)] then table.insert(fuelPumps, object) end
		success, object = FindNextObject(handle, object)
	until not success
	EndFindObject(handle)
	local pumpObject = 0
	local pumpDistance = 1000
	for _, fuelPumpObject in pairs(fuelPumps) do
		local dstcheck = GetDistanceBetweenCoords(coords, GetEntityCoords(fuelPumpObject))
		if dstcheck < pumpDistance then
			pumpDistance = dstcheck
			pumpObject = fuelPumpObject
		end
	end
	return pumpObject, pumpDistance
end

function GetFuel(vehicle) return DecorGetFloat(vehicle, ConfigFuel.FuelDecor) end

function SetFuel(vehicle, fuel)
	if type(fuel) == 'number' and fuel >= 0 and fuel <= 100 then
		SetVehicleFuelLevel(vehicle, fuel + 0.0)
		DecorSetFloat(vehicle, ConfigFuel.FuelDecor, GetVehicleFuelLevel(vehicle))
	end
end

function ManageFuelUsage(vehicle)
	if not DecorExistOn(vehicle, ConfigFuel.FuelDecor) then
		SetFuel(vehicle, math.random(200, 800) / 10)
	elseif not fuelSynced then
		SetFuel(vehicle, GetFuel(vehicle))
		fuelSynced = true
	end
	if IsVehicleEngineOn(vehicle) then
		SetFuel(vehicle, GetVehicleFuelLevel(vehicle) - ConfigFuel.FuelUsage[Round(GetVehicleCurrentRpm(vehicle), 1)] * (ConfigFuel.Classes[GetVehicleClass(vehicle)] or 1.0) / 10)
	end
end

Citizen.CreateThread(function()
	DecorRegister(ConfigFuel.FuelDecor, 1)
	for index = 1, #ConfigFuel.Blacklist do
		if type(ConfigFuel.Blacklist[index]) == 'string' then
			ConfigFuel.Blacklist[GetHashKey(ConfigFuel.Blacklist[index])] = true
		else
			ConfigFuel.Blacklist[ConfigFuel.Blacklist[index]] = true
		end
	end
	for index = #ConfigFuel.Blacklist, 1, -1 do table.remove(ConfigFuel.Blacklist, index) end
	while true do
		Citizen.Wait(1000)
		local ped = PlayerPedId()
		if IsPedInAnyVehicle(ped) then
			local vehicle = GetVehiclePedIsIn(ped)
			if ConfigFuel.Blacklist[GetEntityModel(vehicle)] then inBlacklisted = true else inBlacklisted = false end
			if not inBlacklisted and GetPedInVehicleSeat(vehicle, -1) == ped then ManageFuelUsage(vehicle) end
		else
			if fuelSynced then fuelSynced = false end
			if inBlacklisted then inBlacklisted = false end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(250)
		local pumpObject, pumpDistance = FindNearestFuelPump()
		if pumpDistance < 2.5 then
			isNearPump = pumpObject
			local playerData = ESX.GetPlayerData()
			for i=1, #playerData.accounts, 1 do
				if playerData.accounts[i].name == 'money' then
					currentCash = playerData.accounts[i].money
					break
				end
			end
		else
			isNearPump = false
			Citizen.Wait(math.ceil(pumpDistance * 20))
		end
	end
end)

AddEventHandler('fuel:startFuelUpTick', function(pumpObject, ped, vehicle)
	currentFuel = GetVehicleFuelLevel(vehicle)
	while isFueling do
		Citizen.Wait(500)
		local oldFuel = DecorGetFloat(vehicle, ConfigFuel.FuelDecor)
		local fuelToAdd = math.random(10, 20) / 10.0
		local extraCost = fuelToAdd / 1.5 * ConfigFuel.CostMultiplier
		if not pumpObject then
			if GetAmmoInPedWeapon(ped, 883325847) - fuelToAdd * 100 >= 0 then
				currentFuel = oldFuel + fuelToAdd
				SetPedAmmo(ped, 883325847, math.floor(GetAmmoInPedWeapon(ped, 883325847) - fuelToAdd * 100))
			else
				isFueling = false
			end
		else
			currentFuel = oldFuel + fuelToAdd
		end
		if currentFuel > 100.0 then
			currentFuel = 100.0
			isFueling = false
		end
		currentCost = currentCost + extraCost
		if currentCash >= currentCost then SetFuel(vehicle, currentFuel) else isFueling = false end
	end
	if pumpObject then TriggerServerEvent('fuel:pay', currentCost) end
	currentCost = 0.0
end)

AddEventHandler('fuel:refuelFromPump', function(pumpObject, ped, vehicle)
	TaskTurnPedToFaceEntity(ped, vehicle, 1000)
	Citizen.Wait(1000)
	SetCurrentPedWeapon(ped, -1569615261, true)
	LoadAnimDict("timetable@gardener@filling_can")
	TaskPlayAnim(ped, "timetable@gardener@filling_can", "gar_ig_5_filling_can", 2.0, 8.0, -1, 50, 0, 0, 0, 0)
	TriggerEvent('fuel:startFuelUpTick', pumpObject, ped, vehicle)
	while isFueling do
		for _, controlIndex in pairs(ConfigFuel.DisableKeys) do DisableControlAction(0, controlIndex) end
		local vehicleCoords = GetEntityCoords(vehicle)
		if pumpObject then
			local stringCoords = GetEntityCoords(pumpObject)
			local extraString = ""
			extraString = "\n" .. ConfigFuel.Strings.TotalCost .. ": ~g~$" .. Round(currentCost, 1)
			DrawText3Ds(stringCoords.x, stringCoords.y, stringCoords.z + 1.2, ConfigFuel.Strings.CancelFuelingPump .. extraString)
			DrawText3Ds(vehicleCoords.x, vehicleCoords.y, vehicleCoords.z + 0.5, Round(currentFuel, 1) .. "%")
		else
			DrawText3Ds(vehicleCoords.x, vehicleCoords.y, vehicleCoords.z + 0.5, ConfigFuel.Strings.CancelFuelingJerryCan .. "\nGas can: ~g~" .. Round(GetAmmoInPedWeapon(ped, 883325847) / 4500 * 100, 1) .. "% | Vehicle: " .. Round(currentFuel, 1) .. "%")
		end
		if not IsEntityPlayingAnim(ped, "timetable@gardener@filling_can", "gar_ig_5_filling_can", 3) then
			TaskPlayAnim(ped, "timetable@gardener@filling_can", "gar_ig_5_filling_can", 2.0, 8.0, -1, 50, 0, 0, 0, 0)
		end
		if IsControlJustReleased(0, 38) or DoesEntityExist(GetPedInVehicleSeat(vehicle, -1)) or (isNearPump and GetEntityHealth(pumpObject) <= 0) then isFueling = false end
		Citizen.Wait(0)
	end
	ClearPedTasks(ped)
	RemoveAnimDict("timetable@gardener@filling_can")
end)

Citizen.CreateThread(function()
	while true do
		local ped = PlayerPedId()
		if not isFueling and ((isNearPump and GetEntityHealth(isNearPump) > 0) or (GetSelectedPedWeapon(ped) == 883325847 and not isNearPump)) then
			if IsPedInAnyVehicle(ped) and GetPedInVehicleSeat(GetVehiclePedIsIn(ped), -1) == ped then
				local pumpCoords = GetEntityCoords(isNearPump)
				DrawText3Ds(pumpCoords.x, pumpCoords.y, pumpCoords.z + 1.2, ConfigFuel.Strings.ExitVehicle)
			else
				local vehicle = GetPlayersLastVehicle()
				local vehicleCoords = GetEntityCoords(vehicle)
				if DoesEntityExist(vehicle) and GetDistanceBetweenCoords(GetEntityCoords(ped), vehicleCoords) < 2.5 then
					if not DoesEntityExist(GetPedInVehicleSeat(vehicle, -1)) then
						local stringCoords = GetEntityCoords(isNearPump)
						local canFuel = true
						if GetSelectedPedWeapon(ped) == 883325847 then
							stringCoords = vehicleCoords
							if GetAmmoInPedWeapon(ped, 883325847) < 100 then canFuel = false end
						end
						if GetVehicleFuelLevel(vehicle) < 95 and canFuel then
							if currentCash > 0 then
								DrawText3Ds(stringCoords.x, stringCoords.y, stringCoords.z + 1.2, ConfigFuel.Strings.EToRefuel)
								if IsControlJustReleased(0, 38) then
									isFueling = true
									TriggerEvent('fuel:refuelFromPump', isNearPump, ped, vehicle)
									LoadAnimDict("timetable@gardener@filling_can")
								end
							else
								DrawText3Ds(stringCoords.x, stringCoords.y, stringCoords.z + 1.2, ConfigFuel.Strings.NotEnoughCash)
							end
						elseif not canFuel then
							DrawText3Ds(stringCoords.x, stringCoords.y, stringCoords.z + 1.2, ConfigFuel.Strings.JerryCanEmpty)
						else
							DrawText3Ds(stringCoords.x, stringCoords.y, stringCoords.z + 1.2, ConfigFuel.Strings.FullTank)
						end
					end
				elseif isNearPump then
					local stringCoords = GetEntityCoords(isNearPump)

					if currentCash >= ConfigFuel.JerryCanCost then
						if not HasPedGotWeapon(ped, 883325847) then
							DrawText3Ds(stringCoords.x, stringCoords.y, stringCoords.z + 1.2, ConfigFuel.Strings.PurchaseJerryCan)
							if IsControlJustReleased(0, 38) then
								GiveWeaponToPed(ped, 883325847, 4500, false, true)
								TriggerServerEvent('fuel:pay', ConfigFuel.JerryCanCost)
								currentCash = ESX.GetPlayerData().money
							end
						else
							local refillCost = Round(ConfigFuel.RefillCost * (1 - GetAmmoInPedWeapon(ped, 883325847) / 4500))
							if refillCost > 0 then
								if currentCash >= refillCost then
									DrawText3Ds(stringCoords.x, stringCoords.y, stringCoords.z + 1.2, ConfigFuel.Strings.RefillJerryCan .. refillCost)
									if IsControlJustReleased(0, 38) then
										TriggerServerEvent('fuel:pay', refillCost)
										SetPedAmmo(ped, 883325847, 4500)
									end
								else
									DrawText3Ds(stringCoords.x, stringCoords.y, stringCoords.z + 1.2, ConfigFuel.Strings.NotEnoughCashJerryCan)
								end
							else
								DrawText3Ds(stringCoords.x, stringCoords.y, stringCoords.z + 1.2, ConfigFuel.Strings.JerryCanFull)
							end
						end
					else
						DrawText3Ds(stringCoords.x, stringCoords.y, stringCoords.z + 1.2, ConfigFuel.Strings.NotEnoughCash)
					end
				else
					Citizen.Wait(250)
				end
			end
		else
			Citizen.Wait(250)
		end
		Citizen.Wait(0)
	end
end)

if ConfigFuel.ShowNearestGasStationOnly then
	Citizen.CreateThread(function()
		local currentGasBlip = 0
		while true do
			local coords = GetEntityCoords(PlayerPedId())
			local closest = 1000
			local closestCoords
			for _, gasStationCoords in pairs(ConfigFuel.GasStations) do
				local dstcheck = GetDistanceBetweenCoords(coords, gasStationCoords)
				if dstcheck < closest then
					closest = dstcheck
					closestCoords = gasStationCoords
				end
			end
			if DoesBlipExist(currentGasBlip) then RemoveBlip(currentGasBlip) end
			currentGasBlip = CreateBlip(closestCoords)
			Citizen.Wait(10000)
		end
	end)
elseif ConfigFuel.ShowAllGasStations then
	Citizen.CreateThread(function() for _, gasStationCoords in pairs(ConfigFuel.GasStations) do CreateBlip(gasStationCoords) end end)
end


