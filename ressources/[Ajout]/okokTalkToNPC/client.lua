ESX = nil
PlayerData = {}
local pedList = {}
local cam = nil
local name = ''
local waitMore = true
local inMenu = false
local hasEntered = false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent("esx:getSharedObject", function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end
	PlayerData = ESX.GetPlayerData()
end)

-- CREATE NPCs

Citizen.CreateThread(function()
	local pedInfo = {}
	local camCoords = nil
	local camRotation = nil

	for k, v in pairs(Config.TalkToNPC) do
		RequestModel(GetHashKey(v.npc))
		while not HasModelLoaded(GetHashKey(v.npc)) do
			Wait(1)
		end

		RequestAnimDict("mini@strip_club@idles@bouncer@base")
		while not HasAnimDictLoaded("mini@strip_club@idles@bouncer@base") do
			Wait(1)
		end

		ped =  CreatePed(4, v.npc, v.coordinates[1], v.coordinates[2], v.coordinates[3], v.heading, false, true)
		SetEntityHeading(ped, v.heading)
		FreezeEntityPosition(ped, true)
		SetEntityInvincible(ped, true)
		SetBlockingOfNonTemporaryEvents(ped, true)
		TaskPlayAnim(ped,"mini@strip_club@idles@bouncer@base","base", 8.0, 0.0, -1, 1, 0, 0, 0, 0)

		if Config.AutoCamPosition then
			local px, py, pz = table.unpack(GetEntityCoords(ped, true))
			local x, y, z = px + GetEntityForwardX(ped) * 1.2, py + GetEntityForwardY(ped) * 1.2, pz + 0.52

			camCoords = vector3(x, y, z)
		end

		if Config.AutoCamRotation then
			local rx = GetEntityRotation(ped, 2)

			camRotation = rx + vector3(0.0, 0.0, 181)
		end

		pedInfo = {
			name = v.name,
			model = v.npc,
			pedCoords = v.coordinates,
			entity = ped,
			camCoords = camCoords,
			camRotation = camRotation,
		}

		table.insert(pedList, pedInfo)
	end
end)

-- CHECK DISTANCE & JOB

Citizen.CreateThread(function()
	local inZone = false
	local hasSetName = false
	local nearPed = false
	local checkedJob = false
	local hasJob = false
	local npcModel = nil
	local npcName = nil
	local npcKey = 0
	
	while true do
		Citizen.Wait(20)
		local playerCoords = GetEntityCoords(PlayerPedId())
		
		inZone = false
		nearPed = false

		if npcName == nil and npcModel == nil then
			for k,v in pairs(Config.TalkToNPC) do
				local distance = GetDistanceBetweenCoords(playerCoords.x, playerCoords.y, playerCoords.z, v.coordinates[1], v.coordinates[2], v.coordinates[3])
			
				if v.jobs[1] ~= nil then

					if distance < v.interactionRange + 2 then
						npcName = v.name
						npcModel = v.npc
						npcKey = k
						nearPed = true

					elseif not waitMore and not nearPed then
						waitMore = true
					elseif checkedJob then
						checkedJob = false
					end
				else
					if distance < v.interactionRange + 2 then
						npcName = v.name
						npcModel = v.npc
						npcKey = k
						nearPed = true
						if not inMenu then
							waitMore = false
						end
						
					elseif not waitMore and not nearPed then
						waitMore = true
					end
				end
			end
		else
			v = Config.TalkToNPC[npcKey]
			if v ~= nil then
				local distance = GetDistanceBetweenCoords(playerCoords.x, playerCoords.y, playerCoords.z, v.coordinates[1], v.coordinates[2], v.coordinates[3])
				local zDistance = playerCoords.z - v.coordinates[3]
				
				if zDistance < 0 then
					zDistance = zDistance * -1
				end
				if zDistance < 2 then
					if v.jobs[1] ~= nil then

						if distance < v.interactionRange + 3 then
							if not checkedJob then
								hasJob = false
								checkedJob = true
								for k2,v2 in pairs(v.jobs) do
									if ESX.GetPlayerData().job.name == v2 then
										hasJob = true
									end
								end
							end
							
							if hasJob then
								if not nearPed then
									nearPed = true
								end
								if not inMenu then
									waitMore = false
								end
								if distance < v.interactionRange then
									if not hasSetName then
										name = v.uiText
										hasSetName = true
									end
									if not inZone then
										inZone = true
									end
									if not Config.UseOkokTextUI and not inMenu then
										ESX.ShowHelpNotification('~INPUT_CONTEXT~ pour parler avec ~g~'..name)
									end
									if IsControlJustReleased(0, Config.Key) then
										inMenu = true
										waitMore = true
										StartCam(v.coordinates, v.camOffset, v.camRotation, v.npc, v.name)
										if Config.UseOkokTextUI then
											exports['okokTextUI']:Close()
										end
										Citizen.Wait(500)
										if Config.HideMinimap then
											DisplayRadar(false)
										end
										SetNuiFocus(true, true)
										SendNUIMessage({
											action = 'openDialog',
											name = v.name,
											dialog = v.dialog,
											options = v.options,
										})
									end
								elseif hasSetName then
									hasSetName = false
								end
							end
						elseif not waitMore and not nearPed then
							waitMore = true
						elseif checkedJob then
							checkedJob = false
						end
						if distance > v.interactionRange + 2 and npcName ~= nil and npcModel ~= nil then
							npcModel = nil
							npcName = nil
							npcKey = 0
						end
					else
						if distance < v.interactionRange + 3 then
							if not nearPed then
								nearPed = true
							end
							if not inMenu then
								waitMore = false
							end
							if distance < v.interactionRange then
								if not hasSetName then
									name = v.uiText
									hasSetName = true
								end
								if not inZone then
									inZone = true
								end
								if not Config.UseOkokTextUI and not inMenu then
									ESX.ShowHelpNotification('~INPUT_CONTEXT~ pour parler avec ~g~'..name)
								end
								if IsControlJustReleased(0, Config.Key) then
									inMenu = true
									waitMore = true
									StartCam(v.coordinates, v.camOffset, v.camRotation, v.npc, v.name)
									if Config.UseOkokTextUI then
										exports['okokTextUI']:Close()
									end
									Citizen.Wait(500)
									if Config.HideMinimap then
										DisplayRadar(false)
									end
									SetNuiFocus(true, true)
									SendNUIMessage({
										action = 'openDialog',
										header = v.header,
										name = v.name,
										dialog = v.dialog,
										options = v.options,
									})
								end
							elseif hasSetName then
								hasSetName = false
							end
						elseif not waitMore and not nearPed then
							waitMore = true
						end
						if distance > v.interactionRange + 2 and npcName ~= nil and npcModel ~= nil then
							npcModel = nil
							npcName = nil
							npcKey = 0
						end
					end
				end
			end
		end

		

		if inZone and not hasEntered then
			if Config.UseOkokTextUI then
				exports['okokTextUI']:Open('[E] pour parler avec '..name, 'darkblue', 'left') 
			end
			hasEntered = true
		elseif not inZone and hasEntered then
			if Config.UseOkokTextUI then
				exports['okokTextUI']:Close()
			end
			hasEntered = false
		end 

		if waitMore then
			Citizen.Wait(1000)
		end
	end
end)

-- ACTIONS

RegisterNUICallback('action', function(data, cb)
	if data.action == 'close' then
		SetNuiFocus(false, false)
		exports['okokNotify']:Alert("Individu", "Pas de soucis, fais attention à toi...", 5000, 'info')
		if Config.HideMinimap then
			DisplayRadar(true)
		end
		hasEntered = true
		if Config.UseOkokTextUI then
			exports['okokTextUI']:Open('[E] pour parler avec '..name, 'darkblue', 'left') 
		end
		EndCam()
		inMenu = false
		waitMore = false
	elseif data.action == 'option' then
		SetNuiFocus(false, false)
		if Config.HideMinimap then
			DisplayRadar(true)
		end
		hasEntered = true
		if Config.UseOkokTextUI then
			exports['okokTextUI']:Open('[E] pour parler avec '..name, 'darkblue', 'left') 
		end
		EndCam()
		inMenu = false
		waitMore = false

		if data.options[3] == 'c' then
			TriggerEvent(data.options[2])
		elseif data.options[3] ~= nil then
			TriggerServerEvent(data.options[2])
		end
	end
end)

-- CAMERA

function StartCam(coords, offset, rotation, model, name)
	ClearFocus()

	if Config.AutoCamRotation then
		for k,v in pairs(pedList) do
			if v.pedCoords == coords then
				if v.name == name and v.model == model then
					rotation = v.camRotation
				end
			end
		end
	end

	if Config.AutoCamPosition then
		for k,v in pairs(pedList) do
			if v.pedCoords == coords then
				if v.name == name and v.model == model then
					coords = v.camCoords
				end
			end
		end
	else
		coords = coords + offset
	end

	cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", coords, rotation, GetGameplayCamFov())

	SetCamActive(cam, true)
	RenderScriptCams(true, true, Config.CameraAnimationTime, true, false)
end

function EndCam()
	ClearFocus()

	RenderScriptCams(false, true, Config.CameraAnimationTime, true, false)
	DestroyCam(cam, false)

	cam = nil
end








-- EXAMPLE EVENTS CALLED ON CONFIG.LUA

RegisterNetEvent("okokTalk:toilet")
AddEventHandler("okokTalk:toilet", function()
	exports['okokNotify']:Alert("l'Homme Déchu", "ça pourrait aller mieux, les temps sont très durs en ce moment suite à la reprise du pouvoir de ses putains de Talibans !", 5000, 'info')
end)

RegisterNetEvent("okokTalk:rob")
AddEventHandler("okokTalk:rob", function()
	exports['okokNotify']:Alert("l'Homme Déchu", "Je prie, je prie, je prie pour que cette foutue guerre s'arrête. Ici sont enterrés trois de mes frères. Deux exécutés en place publique, et le troisième mort au combat. ", 5000, 'info')
end)

RegisterNetEvent("okokTalk:safe")
AddEventHandler("okokTalk:safe", function()
	exports['okokNotify']:Alert("l'Homme Déchu", "J'habite ici depuis 9 ans, bien avant que cette foutue guerre ne commence. Je suis arrivé ici avec 5 frères et ma mère.", 5000, 'info')
end)

RegisterNetEvent("okokTalk:card")
AddEventHandler("okokTalk:card", function()
	exports['okokNotify']:Alert("l'Homme Déchu", "Non, je n'ai besoin de rien. Mise à part la paix", 5000, 'info')
end)



RegisterNetEvent("okokTalk:a")
AddEventHandler("okokTalk:a", function()
	exports['okokNotify']:Alert("Stéphane", "Je n'ai pas le temps pour répondre à t'es questions, bouge vite d'ici je t'ai dis !", 5000, 'info')
end)

RegisterNetEvent("okokTalk:b")
AddEventHandler("okokTalk:b", function()
	exports['okokNotify']:Alert("Stéphane", "Mes sergents m'ont ordonné de surveiller et d'avertir les mouvements talibans à l'entrée de Cayo Perico, alors je le fais.", 5000, 'info')
end)

RegisterNetEvent("okokTalk:c")
AddEventHandler("okokTalk:c", function()
	exports['okokNotify']:Alert("Stéphane", "Rend toi à la superette principale, elle se trouve un peu plus loin d'ici...", 5000, 'info')
end)

RegisterNetEvent("okokTalk:d")
AddEventHandler("okokTalk:d", function()
	exports['okokNotify']:Alert("Stéphane", "Non loin de la superette tu trouvera des magasins & surement des citoyens prêt à t'aider. Je n'ai pas ton temps.", 5000, 'info')
end)
