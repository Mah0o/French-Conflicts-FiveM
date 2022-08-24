ESX = nil

local currentsho, currentactionmenu

function DrawTopNotification(txt, beep)
	SetTextComponentFormat("jamyfafi")
	AddTextComponentString(txt)
	if string.len(txt) > 99 and AddLongString then AddLongString(txt) end
	DisplayHelpTextFromStringLabel(0, 0, beep, -1)
end

Cam = nil

ControlDisable = {24, 27, 178, 177, 189, 190, 187, 188, 202, 239, 240, 201, 172, 173, 174, 175}

function CloseCamera()
    local pPed = PlayerPedId()
    ClearPedTasks(pPed)
    TriggerEvent('skinchanger:modelLoaded')
    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
        TriggerEvent('skinchanger:loadSkin', skin)
    end)
    DestroyCam(Cam)
    RenderScriptCams(false, 0, 1, false, false)

    for _, i in pairs(GetActivePlayers()) do
        NetworkConcealPlayer(i, false, false)
    end
end

function OpenCamera()
    for k, v in pairs(GetActivePlayers()) do 
		if v ~= GetPlayerIndex() then 
			NetworkConcealPlayer(v, true, true) 
		end 
	end

    local pPed = PlayerPedId()
    Cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
    SetCamRot(Cam, 0.0, 0.0, 270.0, true)
    local pCoords, pHeading = GetEntityCoords(pPed), GetEntityHeading(pPed)
    local cCoords = pHeading * math.pi / 180.0
    SetCamCoord(Cam, pCoords.x - 1.5 * math.sin(cCoords), pCoords.y + 1.5 * math.cos(cCoords), pCoords.z + .5)
    SetCamRot(Cam, .0, .0, 120.0, 2)
    PointCamAtEntity(Cam, pPed, .0, .0, .0, true)
    SetCamActive(Cam, true)
    RenderScriptCams(1, 0, 500, 1, 0)
end

function ButtonMessage(text)
    BeginTextCommandScaleformString("STRING")
    AddTextComponentScaleform(text)
    EndTextCommandScaleformString()
end

function setupScaleform()
    local scaleform = RequestScaleformMovie("instructional_buttons")

    PushScaleformMovieFunction(scaleform, "CLEAR_ALL")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_CLEAR_SPACE")
    PushScaleformMovieFunctionParameterInt(200)
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(1)
    N_0xe83a3e3557a56640(GetControlInstructionalButton(2, 51, true))
    ButtonMessage("Rotation personnage à droite")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(0)
    N_0xe83a3e3557a56640(GetControlInstructionalButton(2, 44, true))
    ButtonMessage("Rotation personnage à gauche")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "DRAW_INSTRUCTIONAL_BUTTONS")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_BACKGROUND_COLOUR")
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(80)
    PopScaleformMovieFunctionVoid()

    return scaleform
end

RegisterCommand('refreshskin', function()
    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
        TriggerEvent('skinchanger:loadSkin', skin)
    end)
end)

Binco = {   
	Base = { Header = {"shopui_title_lowendfashion2", "shopui_title_lowendfashion2"}, Title = "Binco", HeaderColor = {250, 250, 250, 250} },
	Data = {currentMenu = "Action"},
    Events = {
		onSelected = function(self, _, btn, PMenu, Data, menuData, currentMenu, currentButton, currentBtn, currentSlt, result, slide)
            PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1) 
			if self.Data.currentMenu == "Action" and btn.name ~= "Sauvegarder votre tenue"  and btn.name ~= "Liste des tenues partager" then 
				ESX.TriggerServerCallback('Checkmoney', function(cb)
					if cb then 
						TriggerEvent('skinchanger:getSkin', function(skin)
							save()
							TriggerServerEvent(Shared.prefix..'getclothes', btn.nom3, btn.nom, skin[btn.nom1], skin[btn.nom2], btn.nom1, btn.nom2) 
						end)
					end
				end, btn.price)
			elseif self.Data.currentMenu == "Liste des tenues partager" and btn.name ~= "Publier votre tenue" then 
				ESX.TriggerServerCallback('Checkmoney', function(cb)
					if cb then 
						save()
						TriggerServerEvent(Shared.prefix..'inserttenue', "stenue", btn.name, btn.skins) 
					end    
				end, btn.price)
			end 
			if btn.name == "Sauvegarder votre tenue" then 
				ESX.TriggerServerCallback('Checkmoney', function(cb)
					if cb then 
						savetenue()
					end
				end, btn.price)
			elseif btn.name == "Liste des tenues partager" then 
				Binco.Menu["Liste des tenues partager"].b = {} 
				table.insert(Binco.Menu["Liste des tenues partager"].b, {name = "Publier votre tenue"})
				ESX.TriggerServerCallback(Shared.prefix..'getalltenues', function(Vetement)
					for k, v in pairs(Vetement) do  
						if v.type == "spublic" then 
							table.insert(Binco.Menu["Liste des tenues partager"].b, {name = v.nom, price = 45, skins = json.decode(v.clothe)})
						end
					end
					OpenMenu('Liste des tenues partager')
				end)
			elseif btn.name == "Publier votre tenue" then 
				local result = ESX.KeyboardInput('Nom', 30)
				if result ~= nil then 
					TriggerEvent('skinchanger:getSkin', function(skin)
						TriggerServerEvent(Shared.prefix..'inserttenue', "spublic", ""..result.."", skin) 
						ESX.ShowNotification('Vous avez (~b~Publier~s~) votre tenue [~y~'..result..'~s~] ')
					end)
				end
			end 
		end, 

		onRender = function()
			DisableAllControlActions(0)
			for k, v in pairs(ControlDisable) do
				EnableControlAction(0, v, true)
			end
			local ToucheGauche, ToucheDroite = IsDisabledControlPressed(1, 44), IsDisabledControlPressed(1, 51)

			DrawScaleformMovieFullscreen(setupScaleform(), 255, 255, 255, 255, 0)
			if ToucheGauche or ToucheDroite then
				local PlayerPed = PlayerPedId()
				SetEntityHeading(PlayerPed, ToucheGauche and GetEntityHeading(PlayerPed) - 2.0 or ToucheDroite and GetEntityHeading(PlayerPed) + 2.0)
			end
		end, 
		
		onOpened = function()
			Citizen.Wait(1)

			OpenCamera()

			function loadAnimDict(dict)
				while (not HasAnimDictLoaded(dict)) do
					RequestAnimDict(dict)
					Citizen.Wait(5)
				end
			end
			
			loadAnimDict("clothingshirt")
			RequestAnimDict(dict)
			TaskPlayAnim(GetPlayerPed(-1), "clothingshirt", "try_shirt_positive_d", 8.0, 0.6, -1, 49, 0, 0, 0, 0 )
		end,    
		
		onExited = function(self, _, btn, PMenu, Data, menuData, currentMenu, currentButton, currentBtn, currentSlt, result, slide)
			
			CloseCamera()

			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
				TriggerEvent('skinchanger:loadSkin', skin)
			end)
		end,

		onButtonSelected = function(currentMenu, currentBtn, menuData, newButtons, self)
            if currentMenu == "Action" then 
                for k,v in pairs(Binco.Menu["Action"].b) do 
                    if currentBtn - 1 == v.iterator then       
                        TriggerEvent('skinchanger:change',  newButtons.nom1, v.iterator)
                    end 
                end
            end
			if currentMenu == "Liste des tenues partager" then 
				if newButtons.name == "Publier votre tenue" then 
					ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
						TriggerEvent('skinchanger:loadSkin', skin)
					end)
				else
				for k,v in pairs(Binco.Menu["Liste des tenues partager"].b) do 
					TriggerEvent('skinchanger:getSkin', function(skin)
						TriggerEvent('skinchanger:loadClothes', skin, { 
								["pants_2"] = newButtons.skins["pants_2"], 
								["pants_1"] = newButtons.skins["pants_1"], 
								["tshirt_2"] = newButtons.skins["tshirt_2"], 
								["tshirt_1"] = newButtons.skins["tshirt_1"], 
								["torso_1"] = newButtons.skins["torso_1"], 
								["torso_2"] = newButtons.skins["torso_2"],
								["shoes_1"] = newButtons.skins["shoes_1"],
								["shoes_2"] = newButtons.skins["shoes_2"]})
						end)
					end
				end
            end
        end,
		
        onSlide = function(menuData, btn, currentButton, currentSlt, slide, PMenu)
            local currentMenu = menuData.currentMenu
            local slide = btn.slidenum
            if currentMenu == "Action" and btn.name ~= "Sauvegarder votre tenue" and btn.name ~= "Liste des tenues partager" then 
                bags = slide - 1    
                TriggerEvent('skinchanger:change', btn.nom2, bags) 
            end
        end,
	}, 
	Menu = { 
		["Action"] = {
            Arrowsonly = " ",
			b = {}  
		},
		["Liste des tenues partager"] = {
            Arrowsonly = " ",
			b = {}  
		},
	} 
} 

menuvetement = {   
	Base = { Header = {"commonmenu", "interaction_bgd"}, Title = "Gestion des vêtements", HeaderColor = { 150, 150, 100, 220 } },
	Data = {currentMenu = "Action"},
    Events = {
		onSelected = function(self, _, btn, PMenu, Data, menuData, currentMenu, currentButton, currentBtn, currentSlt, result, slide)
            PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
			if self.Data.currentMenu == "Vetement" then 
				if btn.slidename == "Utiliser" then 
					TriggerEvent('skinchanger:getSkin', function(skin)
						local caca = json.decode(btn.value)
						local type  = caca[btn.infoData2] 
						local var = caca[btn.infoData3]
						if not on then
							save() 
							on = true
							TriggerEvent('skinchanger:loadClothes', skin, {[btn.infoData2] = type, [btn.infoData3] = var})  
						else
							on = false
							if btn.decals == nil then
								TriggerEvent('skinchanger:loadClothes', skin, {[btn.infoData2] = 0, [btn.infoData3] = 0}) 
							elseif btn.decals == "Torse" then 
								TriggerEvent('skinchanger:loadClothes', skin, {['torso_1'] = 15, ['torso_2'] = 0, ['arms'] = 15}) 	
							elseif btn.decals ~= nil and btn.decals ~= "Torse" then 
								TriggerEvent('skinchanger:loadClothes', skin, {[btn.infoData2] = btn.decals, [btn.infoData3] = 0})  
							end
						end
					end)
				elseif btn.slidename == "Changer le nom" then 
					local result = ESX.KeyboardInput(btn.name, 20)
					if result ~= nil then 
						TriggerServerEvent(Shared.prefix..'changename', btn.id, result)
						changeprinsmenu()
						ESX.ShowNotification('Vous avez changer le nom [~y~'..btn.name..'~s~] en [~b~'..result..'~s~]')
					end 
				elseif btn.slidename == "Effacer" then 
					TriggerServerEvent(Shared.prefix..'deleteitem', btn.id)
					changeprinsmenu()
				elseif btn.slidename == "Donner" then 
					local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
						if closestPlayer ~= -1 and closestDistance < 3 then
							TriggerServerEvent(Shared.prefix..'giveitem', btn.id, GetPlayerServerId(closestPlayer))
							changeprinsmenu()
						else
							ESX.ShowNotification('~r~Personne a proximité')
						end
				end
			elseif self.Data.currentMenu == "Action" and btn.ids == 456154 then 
				if btn.slidename == "Utiliser" then 
					TriggerEvent('skinchanger:getSkin', function(skin)
						TriggerEvent('skinchanger:loadClothes', skin, { 
								["pants_2"] = btn.skins["pants_2"], 
								["pants_1"] = btn.skins["pants_1"], 
								["tshirt_2"] = btn.skins["tshirt_2"], 
								["tshirt_1"] = btn.skins["tshirt_1"], 
								["torso_1"] = btn.skins["torso_1"], 
								["torso_2"] = btn.skins["torso_2"],
								["shoes_1"] = btn.skins["shoes_1"],
								["shoes_2"] = btn.skins["shoes_2"]})
						end)
					save()
					elseif btn.slidename == "Changer le nom" then 
						local result = ESX.KeyboardInput(btn.name, 20)
						if result ~= nil then 
							TriggerServerEvent(Shared.prefix..'changename', btn.id, result)
						end 
						changeprinsmenu()
						ESX.ShowNotification('Vous avez changer le nom [~y~'..btn.name..'~s~] en [~b~'..result..'~s~]')
					elseif btn.slidename == "Effacer" then 
						TriggerServerEvent(Shared.prefix..'deleteitem', btn.id)
						changeprinsmenu()
					elseif btn.slidename == "Donner" then 
						local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
						if closestPlayer ~= -1 and closestDistance < 3 then
							TriggerServerEvent(Shared.prefix..'giveitem', btn.id, GetPlayerServerId(closestPlayer))
							CloseMenu(true)
						else
							ESX.ShowNotification('~r~Personne a proximté')
						end
				end
			end 
			if btn.askX == true and btn.ids ~= 456154 then 
				menuvetement.Menu["Vetement"].b = {} 
				ESX.TriggerServerCallback(Shared.prefix..'getmask', function(Vetement)
					for k, v in pairs(Vetement) do  
						if v.type == btn.infoData then  
							table.insert(menuvetement.Menu["Vetement"].b, {name = v.nom, slidemax = {"Utiliser", "Donner", "Changer le nom", "Effacer"}, id = v.id, menu = 1, value = v.clothe, infoData = btn.infoData, infoData2 = btn.infoData2, infoData3 = btn.infoData3, decals = btn.decals})
						end
					end
					OpenMenu('Vetement')
				end)
			end 
		end, 
		onSlide = function(menuData, btn, currentButton, currentSlt, slide, PMenu)
            local currentMenu = menuData.currentMenu
            if currentMenu == "Action" and btn.ids ~= 456154 then 
				if btn.slidename ~= nil then  
					currentactionmenu = btn.slidename
					changeprinsmenu()
				end
            end
        end,
	}, 
	Menu = { 
		["Action"] = {
            Arrowsonly = " ",
			b = {} 
		},
		["Vetement"] = {
            Arrowsonly = " ",
			b = {} 
		}
	}
}

function changeprinsmenu()
	CloseMenu(true)
	menuvetement.Menu["Action"].b = {} 
	if currentactionmenu == "Tenue" then 
		table.insert(menuvetement.Menu["Action"].b, {name = "Selection", slidemax = {"Tenue", "Vetement"}})
		ESX.TriggerServerCallback(Shared.prefix..'getmask', function(Vetement)
			for k, v in pairs(Vetement) do  
				if v.type == "stenue" then 
					table.insert(menuvetement.Menu["Action"].b, {name = v.nom, skins = json.decode(v.clothe), ids = 456154, slidemax = {"Utiliser", "Donner", "Changer le nom", "Effacer"}, askX = true, id = v.id})
				end 
			end 
			CreateMenu(menuvetement)
		end)
	elseif currentactionmenu == "Vetement" then 
		table.insert(menuvetement.Menu["Action"].b, {name = "Selection", slidemax = {"Vetement", "Tenue"}})
		table.insert(menuvetement.Menu["Action"].b, {name = "Torse", ask = "→", askX = true, infoData = "storse", infoData2 = "torso_1", infoData3 = "torso_2", decals = "Torse"})
		table.insert(menuvetement.Menu["Action"].b, {name = "T-shirt", ask = "→", askX = true, infoData = "stshirt", infoData2 = "tshirt_1", infoData3 = "tshirt_2", decals = 15})
		table.insert(menuvetement.Menu["Action"].b, {name = "Pantalon", ask = "→", askX = true, infoData = "spantalon", infoData2 = "pants_1", infoData3 = "pants_2", decals = 14})
		table.insert(menuvetement.Menu["Action"].b, {name = "Chaussures", ask = "→", askX = true, infoData = "schaussures", infoData2 = "shoes_1", infoData3 = "shoes_2", decals = 34})
		table.insert(menuvetement.Menu["Action"].b, {separator = "~b~Accessoires", askX = true})
		table.insert(menuvetement.Menu["Action"].b, {name = "Chaines", ask = "→", askX = true, infoData = "schaine", infoData2 = "chain_1", infoData3 = "chain_2"})
		table.insert(menuvetement.Menu["Action"].b, {name = "Calques", ask = "→", askX = true, infoData = "scalques", infoData2 = "decals_1", infoData3 = "decals_2"})
		table.insert(menuvetement.Menu["Action"].b, {name = "Masque", ask = "→", askX = true, infoData = "smasque", infoData2 = "watches_1", infoData3 = "watches_2"})
		table.insert(menuvetement.Menu["Action"].b, {name = "Sac", ask = "→", askX = true, infoData = "ssac", infoData2 = "bags_1", infoData3 = "bags_2"})
		table.insert(menuvetement.Menu["Action"].b, {name = "Chapeau", ask = "→", askX = true, infoData = "schapeau", infoData2 = "helmet_1", infoData3 = "helmet_2", decals = 11})
		table.insert(menuvetement.Menu["Action"].b, {name = "Lunettes", ask = "→", askX = true, infoData = "slunettes", infoData2 = "glasses_1", infoData3 = "glasses_2"})
		table.insert(menuvetement.Menu["Action"].b, {name = "Gants", ask = "→", askX = true, infoData = "sgant", infoData2 = "arms", infoData3 = "arms_2", decals = 15})
		table.insert(menuvetement.Menu["Action"].b, {name = "Montres", ask = "→", askX = true, infoData = "smontre", infoData2 = "watches_1", infoData3 = "watches_2", decals = -1})
		table.insert(menuvetement.Menu["Action"].b, {name = "Bracelet", ask = "→", askX = true, infoData = "sbracelet", infoData2 = "bracelets_1", infoData3 = "bracelets_2", decals = -1})
		table.insert(menuvetement.Menu["Action"].b, {name = "Oreille", ask = "→", askX = true, infoData = "soreille", infoData2 = "ears_1", infoData3 = "ears_2", decals = -1})
	end
	if currentactionmenu ~= "Tenue" then 
	CreateMenu(menuvetement)
	end
end

RegisterCommand('vetement', function() 
	currentactionmenu = "Tenue"
	changeprinsmenu()
end)

function save()
	TriggerEvent('skinchanger:getSkin', function(skin)
		TriggerServerEvent('esx_skin:save', skin)
	end)
end

function savetenue()
	TriggerEvent('skinchanger:getSkin', function(skin)
		local math = math.random(1, 9200)
		TriggerServerEvent(Shared.prefix..'inserttenue', "stenue", "Tenue "..math.."", skin) 
		ESX.ShowNotification('Vous avez ~g~acheter~s~ votre tenue [~y~'..math..'~s~] ')
	end)
end

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end    
    while true do 
       time = 750
	   posplayer = GetEntityCoords(GetPlayerPed(-1), false)
        for k, v in pairs(Shared.shops) do
            if (GetDistanceBetweenCoords(posplayer, v.pos, true) < 1.2) then
				currentshop = Shared.shops[k].shop
				DrawTopNotification("Appuyez sur ~INPUT_TALK~ pour accéder au ~b~magasin~w~.")
				if IsControlJustPressed(1, 51) then 	
					save()
					Binco.Menu["Action"].b = {} 
					if currentshop ~= "Main" then 
						TriggerEvent('skinchanger:getData', function(components, maxVals)
							for i=0, maxVals[Shared.info[currentshop].nom1], 1 do  
								if Shared.info[currentshop].slidemax == "Texture" then 
									table.insert(Binco.Menu["Action"].b, {name = ""..currentshop.." N°" .. i , price = Shared.price[currentshop] , slidemax = GetNumberOfPedTextureVariations(PlayerPedId(),  Shared.info[currentshop].var, i) - 1, iterator = i, nom = ""..currentshop.." "..i.."", nom1 = Shared.info[currentshop].nom1, nom2 = Shared.info[currentshop].nom2, nom3 = Shared.info[currentshop].nom3 })
								elseif Shared.info[currentshop].slidemax == "Prop" then 
									table.insert(Binco.Menu["Action"].b, {name = ""..currentshop.." N°" .. i , price = Shared.price[currentshop] , slidemax = GetNumberOfPedPropTextureVariations(PlayerPedId(),  Shared.info[currentshop].var, i) - 1, iterator = i, nom = ""..currentshop.." "..i.."", nom1 = Shared.info[currentshop].nom1, nom2 = Shared.info[currentshop].nom2, nom3 = Shared.info[currentshop].nom3 })
								elseif Shared.info[currentshop].slidemax ~= "Prop" or onfig.info[currentshop].slidemax ~= "Texture" then
									table.insert(Binco.Menu["Action"].b, {name = ""..currentshop.." N°" .. i , price = Shared.price[currentshop] , slidemax = Shared.info[currentshop].slidemax, iterator = i, nom = ""..currentshop.." "..i.."", nom1 = Shared.info[currentshop].nom1, nom2 = Shared.info[currentshop].nom2, nom3 = Shared.info[currentshop].nom3 })
								end 
							end 
						end)	
					else
						table.insert(Binco.Menu["Action"].b, {name = "Sauvegarder votre tenue", price = 45, askX = true})
						table.insert(Binco.Menu["Action"].b, {name = "Liste des tenues partager", ask = "→", askX = true})
					end
					CreateMenu(Binco)
				end
            end
			if (GetDistanceBetweenCoords(posplayer, v.pos, true) < 5) then
				time = 1
				if v.color == nil then 
					DrawMarker(25, v.pos, 0.0, 0.0, 0.0, 0.0,0.0,0.0, 0.5, 0.5, 0.2, 52, 152, 219, 225, false, false, false, false)
				else
					DrawMarker(25, v.pos, 0.0, 0.0, 0.0, 0.0,0.0,0.0, 0.5, 0.5, 0.2, v.color.r, v.color.g, v.color.b, 225, false, false, false, false) 
				end
			end
        end  
		Wait(time)
    end
end)

local blipsvtm = {
    {title = "Magasins de vêtements", colour = 81, id= 73, x = 4596.16, y = 4453.98, z = 4.37},
}

Citizen.CreateThread(function()
    for _, infovtm in pairs(blipsvtm) do
        infovtm.blip = AddBlipForCoord(infovtm.x, infovtm.y, infovtm.z)
        SetBlipSprite(infovtm.blip, infovtm.id)
        SetBlipDisplay(infovtm.blip, 4)
        SetBlipScale(infovtm.blip, 0.745)
        SetBlipColour(infovtm.blip, infovtm.colour)
        SetBlipAsShortRange(infovtm.blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(infovtm.title)
        EndTextCommandSetBlipName(infovtm.blip)
    end
end)