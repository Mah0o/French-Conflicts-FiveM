DrugsHandler.Functions = {}

AddEventHandler('onResourceStart', function(cxDrugs)
    if (GetCurrentResourceName() ~= cxDrugs) then
        return
    end
    Wait(200)
    DrugsHandler.Functions.GetUser()
    DrugsHandler.Functions.GetLabos()
    DrugsHandler.Functions.OwnedBlips()
end)

catName = function(value) 
    if value == "interior" then 
        return "Intérieur"
    elseif value == "details" then 
        return "Ajouts matériels"
    end
end

labName = function(value)
    if value == "none" then 
        return "Aucun"
    elseif value == "basic" then 
        return "Basique"
    elseif value == "upgrade" then 
        return "Amélioré"
    end
end

refreshInventory = function()
	CreateThread(function()
		ESX.PlayerData = ESX.GetPlayerData()
	end)
end

DrugsHandler.Functions.Input = function(entryTitle, textEntry, inputText, maxLength)
    AddTextEntry(entryTitle, textEntry)
    DisplayOnscreenKeyboard(1, entryTitle, "", inputText, "", "", "", maxLength)
	blockinput = true
    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
        Wait(0)
    end
    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult()
        Wait(500)
		blockinput = false
        return result
    else
        Wait(500)
		blockinput = false
        return nil
    end
end

DrugsHandler.Functions.GetZone = function(coords)
    StreetPos = GetStreetNameAtCoord(coords.x, coords.z, coords.z)
    StreetName = GetStreetNameFromHashKey(StreetPos)
    return StreetName
end

DrugsHandler.Functions.Anim = function(scene, pos)
    SceneHandler(DrugsHandler.Actions[scene], pos)
end

DrugsHandler.HarvestAnimation = function(laboType, laboInterior, animationType)
    if laboType == "Weed" then 
        if animationType == 1 then
            harvestTimeout = true 
            RequestAnimDict("anim@amb@business@weed@weed_inspecting_lo_med_hi@")
            while not HasAnimDictLoaded('anim@amb@business@weed@weed_inspecting_lo_med_hi@') do  
                Wait(100) 
            end
            TaskPlayAnim(PlayerPedId(), 'anim@amb@business@weed@weed_inspecting_lo_med_hi@', 'weed_spraybottle_crouch_spraying_02_inspector', 1.0, 1.0, -1)
            FreezeEntityPosition(PlayerPedId(), true)
            RequestModel("bkr_prop_weed_spray_01a")
            while not HasModelLoaded("bkr_prop_weed_spray_01a") do
                Wait(500)				
            end
            local spray = CreateObject(GetHashKey('bkr_prop_weed_spray_01a'), 0, 0, 0, true, true, true)
            AttachEntityToEntity(spray, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 57005), 0.08, -0.08, -0.05, 120.0, 180.0, 180.0, true, true, false, true, 1, true)
            if laboInterior == "upgrade" then 
                Wait(7500)
            else
                Wait(15000)
            end
            ClearPedTasks(PlayerPedId())
            DeleteEntity(spray)   
            FreezeEntityPosition(PlayerPedId(), false)
            SetTimeout(1200, function()
                harvestTimeout = false
            end)
        elseif animationType == 2 then
            harvestTimeout = true 
            RequestAnimDict("anim@amb@business@weed@weed_inspecting_lo_med_hi@") 
            while not HasAnimDictLoaded('anim@amb@business@weed@weed_inspecting_lo_med_hi@') do 
                Wait(100) 
            end
            FreezeEntityPosition(PlayerPedId(), true)
            TaskPlayAnim(PlayerPedId(), 'anim@amb@business@weed@weed_inspecting_lo_med_hi@', 'weed_crouch_checkingleaves_idle_01_inspector', 1.0, 1.0, -1)
            if laboInterior == "upgrade" then 
                Wait(7500)
            else
                Wait(15000)
            end
            ClearPedTasks(PlayerPedId())
            FreezeEntityPosition(PlayerPedId(), false)
            SetTimeout(1200, function()
                harvestTimeout = false
            end)
        end
    end
    if laboType == "Cocaïne" then 
        harvestTimeout = true 
        RequestAnimDict("anim@amb@business@coc@coc_unpack_cut_left@") 
        while not HasAnimDictLoaded('anim@amb@business@coc@coc_unpack_cut_left@') do 
            Wait(100) 
        end
        RequestModel("prop_cs_business_card")
        while not HasModelLoaded("prop_cs_business_card") do
            Wait(500)				
        end
        local cardRight = CreateObject(GetHashKey('prop_cs_business_card'), 0, 0, 0, true, true, true)
        AttachEntityToEntity(cardRight, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 57005), 0.125, 0, -0.05, 0, 180.0, 110.0, true, true, false, true, 1, true)
        local cardLeft = CreateObject(GetHashKey('prop_cs_business_card'), 0, 0, 0, true, true, true)
        AttachEntityToEntity(cardLeft, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 18905), 0.125, 0, 0.06, 0, 180.0, 110.0, true, true, false, true, 1, true)
        for i=1, 3 do
            TaskPlayAnim(PlayerPedId(), 'anim@amb@business@coc@coc_unpack_cut_left@', 'coke_cut_coccutter', 1.0, 1.0, -1)
            Wait(5000)
            ClearPedTasks(PlayerPedId())
        end
        DeleteEntity(cardRight)
        DeleteEntity(cardLeft)
        SetTimeout(1200, function()
            harvestTimeout = false
        end)
    end
end

DrugsHandler.actionFarm = function(laboId, laboInterior, laboType, laboZone, laboAction, laboProduction)
    if laboType == "Weed" then 
        if laboAction == 1 then 
            DrugsHandler.HarvestAnimation(laboType, laboInterior, 1)  
            if laboZone == 1 then 
                BikerWeedFarm.Plant1.Set(BikerWeedFarm.Plant1.Stage.medium, BikerWeedFarm.Plant1.Light.basic)
            elseif laboZone == 2 then 
                BikerWeedFarm.Plant2.Set(BikerWeedFarm.Plant2.Stage.medium, BikerWeedFarm.Plant2.Light.basic)
            elseif laboZone == 3 then 
                BikerWeedFarm.Plant3.Set(BikerWeedFarm.Plant3.Stage.medium, BikerWeedFarm.Plant3.Light.basic)
            elseif laboZone == 4 then 
                BikerWeedFarm.Plant4.Set(BikerWeedFarm.Plant4.Stage.medium, BikerWeedFarm.Plant4.Light.basic)
            elseif laboZone == 5 then 
                BikerWeedFarm.Plant5.Set(BikerWeedFarm.Plant5.Stage.medium, BikerWeedFarm.Plant5.Light.basic)
            elseif laboZone == 6 then 
                BikerWeedFarm.Plant6.Set(BikerWeedFarm.Plant6.Stage.medium, BikerWeedFarm.Plant6.Light.basic) 
            elseif laboZone == 7 then
                BikerWeedFarm.Plant7.Set(BikerWeedFarm.Plant7.Stage.medium, BikerWeedFarm.Plant7.Light.basic)
            elseif laboZone == 8 then 
                BikerWeedFarm.Plant8.Set(BikerWeedFarm.Plant8.Stage.medium, BikerWeedFarm.Plant8.Light.basic)
            elseif laboZone == 9 then  
                BikerWeedFarm.Plant9.Set(BikerWeedFarm.Plant9.Stage.medium, BikerWeedFarm.Plant9.Light.basic)
            end
            TriggerServerEvent("Laboratories:harvest", laboId, laboType, laboZone, laboAction, laboProduction)
        end
        if laboAction == 2 then 
            DrugsHandler.HarvestAnimation(laboType, laboInterior, 2) 
            if laboZone == 1 then 
                BikerWeedFarm.Plant1.Clear(true)
            elseif laboZone == 2 then 
                BikerWeedFarm.Plant2.Clear(true)
            elseif laboZone == 3 then 
                BikerWeedFarm.Plant3.Clear(true)
            elseif laboZone == 4 then 
                BikerWeedFarm.Plant4.Clear(true)
            elseif laboZone == 5 then 
                BikerWeedFarm.Plant5.Clear(true)
            elseif laboZone == 6 then 
                BikerWeedFarm.Plant6.Clear(true)
            elseif laboZone == 7 then
                BikerWeedFarm.Plant7.Clear(true)
            elseif laboZone == 8 then 
                BikerWeedFarm.Plant8.Clear(true)
            elseif laboZone == 9 then  
                BikerWeedFarm.Plant9.Clear(true)
            end
            TriggerServerEvent("Laboratories:harvest", laboId, laboType, laboZone, laboAction, laboProduction)
        end
    end
    if laboType == "Cocaïne" then 
        if laboAction == 1 then 
            DrugsHandler.HarvestAnimation(laboType, laboInterior, 1)  
            if laboZone == 1 then
                BikerCocaine.Details.Enable(BikerCocaine.Details.cokeBasic1, false)
            elseif laboZone == 2 then 
                BikerCocaine.Details.Enable(BikerCocaine.Details.cokeBasic2, false)
            elseif laboZone == 3 then 
                BikerCocaine.Details.Enable(BikerCocaine.Details.cokeBasic3, false)
            elseif laboZone == 4 then 
                BikerCocaine.Details.Enable(BikerCocaine.Details.cokeUpgrade1, false)
            elseif laboZone == 5 then 
                BikerCocaine.Details.Enable(BikerCocaine.Details.cokeUpgrade2, false)
            end
        end
        TriggerServerEvent("Laboratories:harvest", laboId, laboType, laboZone, laboAction, laboProduction)
    end
    if laboType == "Meth" then 
        if laboAction == 1 then 
            DrugsHandler.Functions.Anim(3, DrugsHandler.Interiors[laboType].Harvest[1].pos)
        end
        TriggerServerEvent("Laboratories:harvest", laboId, laboType, laboZone, laboAction, laboProduction)
    end
end


DrugsHandler.Functions.loadIpl = function()
    for i =1, #DrugsHandler.LaboData do 
        local lab = DrugsHandler.LaboData[i]
        if lab.type == "Meth" then 
            BikerMethLab = exports['bob74_ipl']:GetBikerMethLabObject()
            BikerMethLab.Style.Set(lab.data.interior)
            setFarmProduction()
            RefreshInterior(BikerMethLab.interiorId)
        elseif lab.type == "Cocaïne" then 
            BikerCocaine = exports['bob74_ipl']:GetBikerCocaineObject()
            BikerCocaine.Style.Set(lab.data.interior)
            BikerCocaine.Details.Enable(BikerCocaine.Details.cokeBasic1, false)
            BikerCocaine.Details.Enable(BikerCocaine.Details.cokeBasic2, false)
            BikerCocaine.Details.Enable(BikerCocaine.Details.cokeBasic3, false)
            BikerCocaine.Details.Enable(BikerCocaine.Details.cokeUpgrade1, false)
            BikerCocaine.Details.Enable(BikerCocaine.Details.cokeUpgrade2, false)
            setFarmProduction()
            RefreshInterior(BikerCocaine.interiorId)
        elseif lab.type == "Weed" then
            BikerWeedFarm = exports['bob74_ipl']:GetBikerWeedFarmObject()
            BikerWeedFarm.Style.Set(lab.data.interior)
            setFarmProduction()
            BikerWeedFarm.Details.Enable(BikerWeedFarm.Details.fans, true)
            BikerWeedFarm.Details.Enable(BikerWeedFarm.Details.chairs, lab.data.details.chairs)
            BikerWeedFarm.Details.Enable(BikerWeedFarm.Details.drying, lab.data.details.drying)
            RefreshInterior(BikerWeedFarm.interiorId)
        end
    end
end

DrugsHandler.Functions.GetLabos = function()
    ESX.TriggerServerCallback("Laboratories:GetLaboratories", function(Data) 
        DrugsHandler.Utilities = Data
    end)
end

DrugsHandler.Functions.GetUser = function()
    ESX.TriggerServerCallback("Laboratories:GetUserInfos", function(User) 
        DrugsHandler.Users = User
    end)
end

DrugsHandler.Functions.OwnedBlips = function()
    RemoveBlip(Blip)
    SetTimeout(2200, function()
        RemoveBlip(Blip)
        for k,v in pairs (DrugsHandler.Builds) do
            for t,b in pairs (DrugsHandler.Builds[k].Labo) do 
                for _,owner in pairs(DrugsHandler.Utilities) do 
                    for _,user in pairs(DrugsHandler.Users) do 
                        if owner.owner == user.identifier then 
                            if owner.type == k then 
                                if owner.value == b.Index then 
                                    Blip = AddBlipForCoord(b.Entering)
                                    SetBlipSprite (Blip, blipsSprite(k)[1])
                                    SetBlipDisplay(Blip, 4)
                                    SetBlipScale  (Blip, 0.8)
                                    SetBlipColour(Blip, blipsSprite(k)[2])
                                    SetBlipAsShortRange(Blip, true)
                                    BeginTextCommandSetBlipName("STRING")
                                    AddTextComponentString(("Laboratoire de %s"):format(k))
                                    EndTextCommandSetBlipName(Blip)  
                                end
                            end
                        end
                    end
                end
            end
        end
    end)
end

blipsSprite = function(value)
    if value == "Meth" then 
        return {499, 0}
    elseif value == "Weed" then
        return {496, 0}
    elseif value == "Cocaïne" then 
        return {497, 0}
    end
end

RegisterNetEvent("Laboratories:AddWaypoint")
AddEventHandler("Laboratories:AddWaypoint", function(Drugs)
    ESX.ShowAdvancedNotification("Informateur ( Illégal )", "~b~GPS", "Je t'ai placé un point GPS de ton laboratoire, vas y jeter un coup d'oeil.", "CHAR_MALC", 2)
    SetNewWaypoint(DrugsHandler.Builds[Drugs.Type].Labo[Drugs.Value].Entering.x, DrugsHandler.Builds[Drugs.Type].Labo[Drugs.Value].Entering.y)
end)

RegisterNetEvent("Laboratories:refreshLaboratories")
AddEventHandler("Laboratories:refreshLaboratories", function()
    DrugsHandler.Functions.GetUser()
    DrugsHandler.Functions.GetLabos()
    DrugsHandler.Functions.OwnedBlips()
end)

countData = function()
    supplies = 0
    wares = 0
    for i =1, #DrugsHandler.LaboData do 
        local lab = DrugsHandler.LaboData[i]
        local production = lab.production
        if production ~= nil then 
            for k,v in pairs(lab.production) do 
                if lab.type == "Weed" then 
                    if string.find(tostring(v), tostring(2)) then 
                        supplies = supplies + 0.11111111111111111
                    end
                    if string.find(tostring(v), tostring(3)) then 
                        wares = wares + 0.11111111111111111
                    end
                elseif lab.type == "Cocaïne" then
                    if string.find(tostring(v), tostring(2)) then 
                        supplies = supplies + 0.20
                    end
                elseif lab.type == "Meth" then
                    if string.find(tostring(v), tostring(2)) then 
                        supplies = 1.0
                    end
                end
            end
        end
    end
end

RegisterNetEvent("Laboratories:SetIntoLaboratories")
AddEventHandler("Laboratories:SetIntoLaboratories", function(coords, laboData, laboType, bucketId)
    InteractDrugMenu.Closed()
    DrugsHandler.LaboData = laboData
    DoScreenFadeOut(800)
    while not IsScreenFadedOut() do 
        Wait(1)
    end
    countData()
    stat1 = DrawBar("Matières premières : ", {percentage = supplies, bg = {92, 92, 92, 220}, fg = {0, 190, 0, 220}})
    if laboType == "Weed" then 
        stat2 = DrawBar("Marchandises : ", {percentage = wares, bg = {92, 92, 92, 220}, fg = {0, 200, 240, 220}})
    end
    SetEntityCoords(PlayerPedId(), coords.pos)
    SetEntityHeading(PlayerPedId(), coords.heading)
    TriggerServerEvent("Laboratories:SetPlayerIntoBucket", bucketId)
    Wait(200)
    inLaboratories = true
    DrugsHandler.Functions.loadIpl()
    DoScreenFadeIn(600)
    while not IsScreenFadedIn() do 
        Wait(1)
    end
end)

RegisterNetEvent("Laboratories:reloadUpgrade")
AddEventHandler("Laboratories:reloadUpgrade", function(laboData, laboType, type, isScreen)
    DrugsHandler.LaboData = laboData
    if isScreen == true then 
        DoScreenFadeOut(800)
        while not IsScreenFadedOut() do 
            Wait(1)
        end
    end
    Wait(500)
    if type == 2 then 
        print("affichage des drawbar")
        countData()
        Wait(220)
        UpdateDrawBar(stat1, {percentage = supplies})
        if laboType == "Weed" then 
            UpdateDrawBar(stat2, {percentage = wares})
        end
    end
    DrugsHandler.Functions.loadIpl()
    if isScreen == true then 
        DoScreenFadeIn(600)
        while not IsScreenFadedIn() do 
            Wait(1)
        end
    end
end)

RegisterNetEvent("Laboratories:updateStorage")
AddEventHandler("Laboratories:updateStorage", function(dataStorage)
    for i = 1, #DrugsHandler.LaboData do 
        DrugsHandler.LaboData[i].storage = dataStorage
    end
    getData()
end)

RegisterNetEvent("Laboratories:updatePassword")
AddEventHandler("Laboratories:updatePassword", function(dataPassword)
    for i = 1, #DrugsHandler.LaboData do 
        DrugsHandler.LaboData[i].password = dataPassword
    end
end)

RegisterNetEvent("Laboratories:ExitLaboratories")
AddEventHandler("Laboratories:ExitLaboratories", function(coords)
    DoScreenFadeOut(800)
    while not IsScreenFadedOut() do 
        Wait(1)
    end
    RemoveDrawBar()
    SetEntityCoords(PlayerPedId(), coords)
    TriggerServerEvent("Laboratories:SetPlayerIntoNormalBucket")
    Wait(500)
    inLaboratories = false
    DoScreenFadeIn(600)
    while not IsScreenFadedIn() do 
        Wait(1)
    end
end)

RegisterNetEvent("Laboratories:TreatmentAnimation")
AddEventHandler("Laboratories:TreatmentAnimation", function(laboType)
    if laboType == "Weed" then
        RequestAnimDict("anim@amb@business@weed@weed_sorting_seated@") 
        while not HasAnimDictLoaded('anim@amb@business@weed@weed_sorting_seated@') do 
            Wait(100) 
        end
        local PropsTable1 = CreateObject(GetHashKey('bkr_prop_weed_bud_02b'), 1038.6, -3206.648, -38.28, true)
        SetEntityRotation(PropsTable1, 90.0, 0.0, 26.0)
        local PropsTable2 = CreateObject(GetHashKey('bkr_prop_weed_bud_02b'), 1038.65, -3206.648, -38.28, true)
        SetEntityRotation(PropsTable2, 90.0, 84.0, 126.0)
        local PropsTable3 = CreateObject(GetHashKey('bkr_prop_weed_bud_02b'), 1038.65, -3206.648, -38.21, true)
        SetEntityRotation(PropsTable3, 156.0, 43.0, 267.0)
        local PropsTable4 = CreateObject(GetHashKey('bkr_prop_weed_dry_01a'), 1038.7, -3205.89, -38.305, true)
        TaskPlayAnimAdvanced(GetPlayerPed(-1), 'anim@amb@business@weed@weed_sorting_seated@', 'sorter_right_sort_v3_sorter02', 1039.324, -3205.918, -38.15, 0.0, 0.0, 98.707, 1.0, 1.0, -1)
        FreezeEntityPosition(PlayerPedId(), true)
        Wait(3750)
        props = CreateObject(GetHashKey('bkr_prop_weed_bud_02b'), 0.0, 0.0, 0.0, true)
        AttachEntityToEntity(props, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 18905), 0.12, -0.025, 0.045, 260.0, 0.0, 0.0, true, true, false, true, 1, true)
        Wait(20000)
        AttachEntityToEntity(props, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 57005), 0.12, -0.025, -0.005, 260.0, 0.0, 0.0, true, true, false, true, 1, true)
        Wait(1000)
        DeleteEntity(props)
        FreezeEntityPosition(PlayerPedId(), false)
        treatmentTimeout = false 
    elseif laboType == "Cocaïne" then
        DrugsHandler.Functions.Anim(2, DrugsHandler.Interiors[laboType].Treatment)
    elseif laboType == "Meth" then
        DrugsHandler.Functions.Anim(4, DrugsHandler.Interiors[laboType].Treatment)
    end
end)