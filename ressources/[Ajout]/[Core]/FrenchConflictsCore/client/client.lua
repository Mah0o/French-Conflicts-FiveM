ESX = nil 
local FirstSpawn, PlayerLoaded = true, false
Nombreinter = 0
IsDead = false
local coordsVisible = false

Citizen.CreateThread(function()
	while ESX == nil do TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end) Normal() Citizen.Wait(0) end
	while ESX.GetPlayerData().job == nil do Citizen.Wait(100) end
	PlayerLoaded = true
	ESX.PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
	PlayerLoaded = true
end)

--- Commande /me
local peds = {}
local GetGameTimer = GetGameTimer
local function draw3dText(coords, text)
    local camCoords = GetGameplayCamCoord()
    local dist = #(coords - camCoords)
    -- Mathématiques expérimentales pour réduire le texte
    local scale = 200 / (GetGameplayCamFov() * dist)
    -- Mettre en forme le texte
    SetTextColour(ConfigME.color.r, ConfigME.color.g, ConfigME.color.b, ConfigME.color.a)
    SetTextScale(0.0, ConfigME.scale * scale)
    SetTextFont(ConfigME.font)
    SetTextDropshadow(0, 0, 0, 0, 55)
    SetTextDropShadow()
    SetTextCentre(true)
    -- Afficher le texte
    BeginTextCommandDisplayText("STRING")
    AddTextComponentSubstringPlayerName(text)
    SetDrawOrigin(coords, 0)
    EndTextCommandDisplayText(0.0, 0.0)
    ClearDrawOrigin()
end
local function displayText(ped, text)
    local playerPed = PlayerPedId()
    local playerPos = GetEntityCoords(playerPed)
    local targetPos = GetEntityCoords(ped)
    local dist = #(playerPos - targetPos)
    local los = HasEntityClearLosToEntity(playerPed, ped, 17)
    if dist <= ConfigME.dist and los then
        local exists = peds[ped] ~= nil
        peds[ped] = { time = GetGameTimer() + ConfigME.time, text = text }
        if not exists then
            local display = true
            while display do
                Wait(0)
                local pos = GetOffsetFromEntityInWorldCoords(ped, 0.0, 0.0, 1.0)
                draw3dText(pos, peds[ped].text)
                display = GetGameTimer() <= peds[ped].time
            end
            peds[ped] = nil
        end
    end
end
local function onShareDisplay(text, target)
    local player = GetPlayerFromServerId(target)
    if player ~= -1 or target == GetPlayerServerId(PlayerId()) then
        local ped = GetPlayerPed(player)
        displayText(ped, text)
    end
end
RegisterNetEvent('3dme:shareDisplay', onShareDisplay)
-----------

--- Pour gérer le revive
function Normal()
    local playerPed = GetPlayerPed(-1)
    ClearTimecycleModifier()
    ResetScenarioTypesEnabled()
    SetPedMotionBlur(playerPed, false)
end
function RespawnPed(ped, coords, heading)
	SetEntityCoordsNoOffset(ped, coords.x, coords.y, coords.z, false, false, false, true)
	NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, heading, true, false)
	SetPlayerInvincible(ped, false)
	TriggerEvent('playerSpawned', coords.x, coords.y, coords.z)
	ClearPedBloodDamage(ped)
	--ESX.UI.Menu.CloseAll()
end
function RemoveItemsAfterRPDeath()
	--Nombreinter = Nombreinter - 1
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)
	--TriggerServerEvent('esx_ambulancejob:setDeathStatus', false)
	Citizen.CreateThread(function()
		DoScreenFadeOut(800)
		while not IsScreenFadedOut() do Citizen.Wait(10) end
		local formattedCoords = vector3(361.46710205078, -582.30456542969, 43.284099578857)
		ESX.SetPlayerData('lastPosition', formattedCoords)
		TriggerServerEvent('esx:updateLastPosition', formattedCoords)
		RespawnPed(playerPed, formattedCoords, 0.0)
		StopScreenEffect('DeathFailOut')
		DoScreenFadeIn(800)
		Citizen.Wait(10)
		ClearPedTasksImmediately(playerPed)
		SetTimecycleModifier("spectator5") -- Je sait pas se que ça fait lel
		SetPedMotionBlur(playerPed, true)
		RequestAnimSet("move_injured_generic")
		while not HasAnimSetLoaded("move_injured_generic") do Citizen.Wait(0) end
		SetPedMovementClipset(playerPed, "move_injured_generic", true)
		PlaySoundFrontend(-1, "1st_Person_Transition", "PLAYER_SWITCH_CUSTOM_SOUNDSET", 0)
		PlaySoundFrontend(-1, "1st_Person_Transition", "PLAYER_SWITCH_CUSTOM_SOUNDSET", 0)
		ESX.ShowAdvancedNotification('REANIMATION X', 'Unité X réanimation', 'Vous avez été réanimé par l\'unité X.', 'CHAR_MICHAEL', 1)
		local ped = GetPlayerPed(PlayerId())
		local coords = GetEntityCoords(ped, false)
		local name = GetPlayerName(PlayerId())
		local x, y, z = table.unpack(GetEntityCoords(ped, false))
		--TriggerServerEvent('esx_ambulance:NotificationBlipsX', x, y, z, name)
		Citizen.Wait(7500) -- Effets de la réanmation pendant 30 secondes
		Normal()
	end)
end
AddEventHandler('playerSpawned', function()
	IsDead = false
	if FirstSpawn then
		exports.spawnmanager:setAutoSpawn(false) -- disable respawn
		FirstSpawn = false
		ESX.TriggerServerCallback('esx_ambulancejob:getDeathStatus', function(isDead)
			if isDead and false then
				while not PlayerLoaded do Citizen.Wait(1000) end
				ESX.ShowNotification("Vous avez été réanimé de force car vous avez quitté le serveur.")
				RemoveItemsAfterRPDeath()
			end
		end)
	end
end)
RegisterNetEvent('esx_ambulancejob:revive')
AddEventHandler('esx_ambulancejob:revive', function()
	Nombreinter = Nombreinter - 1
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)
	--TriggerServerEvent('esx_ambulancejob:setDeathStatus', false)
	Citizen.CreateThread(function()
		DoScreenFadeOut(800)
		while not IsScreenFadedOut() do Citizen.Wait(50) end
		local formattedCoords = {x = ESX.Math.Round(coords.x, 1), y = ESX.Math.Round(coords.y, 1), z = ESX.Math.Round(coords.z, 1)}
		ESX.SetPlayerData('lastPosition', formattedCoords)
		TriggerServerEvent('esx:updateLastPosition', formattedCoords)
		RespawnPed(playerPed, formattedCoords, 0.0)
		StopScreenEffect('DeathFailOut')
		DoScreenFadeIn(800)
	end)
end)

RegisterCommand("coords", function() ToggleCoords() end)

FormatCoord = function(coord)
	if coord == nil then return "unknown" end
	return tonumber(string.format("%.2f", coord))
end

ToggleCoords = function() coordsVisible = not coordsVisible end

function DrawGenericText(text)
	SetTextColour(186, 186, 186, 255)
	SetTextFont(7)
	SetTextScale(0.378, 0.378)
	SetTextWrap(0.0, 1.0)
	SetTextCentre(false)
	SetTextDropshadow(0, 0, 0, 0, 255)
	SetTextEdge(1, 0, 0, 0, 205)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(0.40, 0.00)
end

local function sendNotification(message)   
    SetNotificationTextEntry("STRING")
    AddTextComponentString(message)
    DrawNotification(true, false)
end

Citizen.CreateThread(function()
    while true do
		local sleepThread = 250
		if coordsVisible then
			sleepThread = 5
			local playerPed = PlayerPedId()
			local playerX, playerY, playerZ = table.unpack(GetEntityCoords(playerPed))
			local playerH = GetEntityHeading(playerPed)
			DrawGenericText(("Kave - Coords Systsem : ~g~X~w~: %s ~g~Y~w~: %s ~g~Z~w~: %s ~g~H~w~: %s"):format(FormatCoord(playerX), FormatCoord(playerY), FormatCoord(playerZ), FormatCoord(playerH)))
		end
		Citizen.Wait(sleepThread)
	end
end)

Citizen.CreateThread(function()
    local blip = AddBlipForCoord(4879.56, -5264.19, 9.16) -- HOPITAL 1 CAYO
    SetBlipSprite (blip, 61) 
    SetBlipDisplay(blip, 4)
    SetBlipScale  (blip, 0.6)
    SetBlipColour (blip, 69)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName('Centre de secours Cayo Perico') 
    EndTextCommandSetBlipName(blip)
end) 

Citizen.CreateThread(function()
    local blip = AddBlipForCoord(5076.68, -4566.2, 5.99) -- HOPITAL 2 CAYO
    SetBlipSprite (blip, 61) 
    SetBlipDisplay(blip, 4)
    SetBlipScale  (blip, 0.6)
    SetBlipColour (blip, 69)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName('Centre de secours Cayo Perico') 
    EndTextCommandSetBlipName(blip)
end) 

Citizen.CreateThread(function()
    local blip = AddBlipForCoord(5530.55, -5223.95, 13.77) -- HOPITAL 3 CAYO
    SetBlipSprite (blip, 61) 
    SetBlipDisplay(blip, 4)
    SetBlipScale  (blip, 0.6)
    SetBlipColour (blip, 69)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName('Centre de secours Cayo Perico') 
    EndTextCommandSetBlipName(blip)
end)  

Citizen.CreateThread(function()
    local blip = AddBlipForRadius(4969.49, -5279.58, 6.29, 100.0) -- ZONE BLANCHE ARMEE TERRE
	SetBlipSprite(blip,9)
	SetBlipColour(blip,37)
	SetBlipAlpha(blip,80)
    return blip
end)


Citizen.CreateThread(function()
    local blip = AddBlipForRadius(3080.9052734375, -4690.6865234375, 27.250305175781, 100.0) -- ZONE BLANCHE ARMEE TERRE
	SetBlipSprite(blip,9)
	SetBlipColour(blip,37)
	SetBlipAlpha(blip,80)
    return blip
end)



Citizen.CreateThread(function()
    local blip = AddBlipForCoord(5011.06, -5754.29, 28.85) -- QG TALIBAN
    SetBlipSprite (blip, 429) 
    SetBlipDisplay(blip, 4)
    SetBlipScale  (blip, 0.9)
    SetBlipColour (blip, 1)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName('Siège du régime Taliban') 
    EndTextCommandSetBlipName(blip)
end) 

Citizen.CreateThread(function()
    local blip = AddBlipForCoord(5143.1020507813,-4954.1020507813,14.361157417297) -- DOUANE
    SetBlipSprite (blip, 467) 
    SetBlipDisplay(blip, 4)
    SetBlipScale  (blip, 0.9)
    SetBlipColour (blip, 1)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName('Poste de Douane') 
    EndTextCommandSetBlipName(blip)
end) 

Citizen.CreateThread(function()
    local talib = AddBlipForRadius(5011.06, -5754.29, 28.85, 100.0) -- ZONE BLANCHE QG TALIBAN
	SetBlipSprite(talib,9)
	SetBlipColour(talib,1)
	SetBlipAlpha(talib,80)
    return talib
  end)

Citizen.CreateThread(function()
    local hash = GetHashKey("ig_floyd")
    while not HasModelLoaded(hash) do
    RequestModel(hash)
    Wait(20)
    end
    ped = CreatePed("PED_TYPE_CIVFEMALE", "ig_floyd", 4521.4311523438,-4458.517578125,4.1931414604187, 200.3697967529297, false, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    FreezeEntityPosition(ped, true)
end)

Citizen.CreateThread(function()
    local hash = GetHashKey("u_m_y_mani")
    while not HasModelLoaded(hash) do
    RequestModel(hash)
    Wait(20)
    end
    ped = CreatePed("PED_TYPE_CIVFEMALE", "u_m_y_mani", 4495.630859375,-4452.1845703125, 3.3664612770081, 200.3697967529297, false, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    FreezeEntityPosition(ped, true)
end)


Citizen.CreateThread(function()
    while true do
        local plyPed = PlayerPedId()
        if IsPedSittingInAnyVehicle(plyPed) then
            local plyVehicle = GetVehiclePedIsIn(plyPed, false)
			CarSpeed = GetEntitySpeed(plyVehicle) * 3.6 -- On définit la vitesse du véhicule en km/h
			if CarSpeed <= Config.vitessemaxchangerplace then -- On ne peux pas changer de place si la vitesse du véhicule est au dessus ou égale à 60 km/h
				if IsControlJustReleased(0, 157) then -- conducteur
					SetPedIntoVehicle(plyPed, plyVehicle, -1)
					Citizen.Wait(10)
				end
				if IsControlJustReleased(0, 158) then -- avant droit
					SetPedIntoVehicle(plyPed, plyVehicle, 0)
					Citizen.Wait(10)
				end
				if IsControlJustReleased(0, 160) then -- arriere gauche
					SetPedIntoVehicle(plyPed, plyVehicle, 1)
					Citizen.Wait(10)
				end
				if IsControlJustReleased(0, 164) then -- arriere gauche
					SetPedIntoVehicle(plyPed, plyVehicle, 2)
					Citizen.Wait(10)
				end
			end
		end
		Citizen.Wait(10) -- anti crash
	end
end)
