local cokeCounter = 3
local openCooldown = false 

treatmentTimeout = false 
harvestTimeout = false 

CreateThread(function()
    pSell = DrugsHandler.Settings.PedSellHash
    RequestModel(GetHashKey(pSell))
    while not HasModelLoaded(GetHashKey(pSell)) do
        Wait(1)
    end
    for k,v in pairs (DrugsHandler.Settings.PedSellPosition) do 
        local pCreateSellPed = CreatePed("PED_TYPE_CIVMALE", pSell, v.pos, v.heading, false, true)
        FreezeEntityPosition(pCreateSellPed, true)
        SetEntityInvincible(pCreateSellPed, true) 
        SetBlockingOfNonTemporaryEvents(pCreateSellPed, true)
        Wait(200)
        TaskStartScenarioInPlace(pCreateSellPed, "WORLD_HUMAN_SMOKING_POT", 0, 1)
    end
    if DrugsHandler.Settings.PedDrugSellActivate == true then 
        pDrugSell = DrugsHandler.Settings.PedDrugSellHash
        RequestModel(GetHashKey(pDrugSell))
        while not HasModelLoaded(GetHashKey(pDrugSell)) do
            Wait(1)
        end
        for k,v in pairs (DrugsHandler.Settings.PedDrugSellPosition) do 
            for t,b in pairs(v) do 
                local pDrugCreateSellPed = CreatePed("PED_TYPE_CIVMALE", pDrugSell, b.pos, b.heading, false, true)
                FreezeEntityPosition(pDrugCreateSellPed, true)
                SetEntityInvincible(pDrugCreateSellPed, true) 
                SetBlockingOfNonTemporaryEvents(pDrugCreateSellPed, true)
                Wait(200)
                TaskStartScenarioInPlace(pDrugCreateSellPed, "WORLD_HUMAN_SMOKING_POT", 0, 1)
            end
        end
    end
    while true do
        local pCoords = GetEntityCoords(PlayerPedId())
        local OnMarker = false 
        for k,v in pairs (DrugsHandler.Settings.PedSellPosition) do 
            if #(pCoords - v.pos) < 1.2 then
                OnMarker = true
                if not DrugsHandler.MenuIsOpen then 
                    ESX.ShowHelpNotification("Appuyer sur ~INPUT_PICKUP~ pour gérer votre ~b~laboratoire~s~.")
                    if IsControlJustPressed(1, 51) then
                        OpenSellDrugPointMenu()
                    end
                end                                
            end  
        end
        if DrugsHandler.Settings.PedDrugSellActivate == true then 
            for k,v in pairs (DrugsHandler.Settings.PedDrugSellPosition) do 
                for t,b in pairs(v) do 
                    if #(pCoords - b.pos) < 1.2 then
                        OnMarker = true
                        if not DrugsHandler.MenuIsOpen then 
                            ESX.ShowHelpNotification(("Appuyer sur ~INPUT_PICKUP~ pour parler avec le ~b~revendeur de %s"):format(string.lower(k)))
                            if IsControlJustPressed(1, 51) then
                                local resellCount = DrugsHandler.Functions.Input("resellCount", ("Combien souhaitez-vous revendre de pochon de %s ?"):format(string.lower(k)), "", 3)
                                if resellCount ~= "" and resellCount ~= nil then 
                                    resellCount = tonumber(resellCount)
                                    TriggerServerEvent("Laboratories:resellDrugs", k, resellCount)
                                else
                                    ESX.ShowNotification("~r~Somme non-reconnu.")
                                end
                            end
                        end                                
                    end             
                end
            end
        end
        for k,v in pairs (DrugsHandler.Builds) do
            for t,b in pairs (DrugsHandler.Builds[k].Labo) do 
                for _,owner in pairs(DrugsHandler.Utilities) do 
                    if owner.type == k then 
                        if owner.value == b.Index then 
                            if #(pCoords - b.Entering) < 15.0 then
                                OnMarker = true
                                if not DrugsHandler.MenuIsOpen then 
                                    DrawMarker(22, b.Entering, 0, 0, 0, 0, 0, 0, 0.25, 0.25, 0.25, 255, 170, 0, 255, 1, 0, 0, 2)                              
                                end
                            end
                            if #(pCoords - b.Entering) < 1.2 then
                                if not DrugsHandler.MenuIsOpen then 
                                    ESX.ShowHelpNotification("Appuyer sur ~INPUT_PICKUP~ pour accéder au ~b~laboratoire~s~ de "..string.lower(k))
                                    if IsControlJustPressed(1, 51) then
                                        if not openCooldown then 
                                            openCooldown = true 
                                            TriggerServerEvent("Laboratories:Interact", k, b.Index)
                                            SetTimeout(450, function()
                                                openCooldown = false
                                            end)
                                        end
                                    end 
                                end
                            end
                        end
                    end
                end
            end
        end
        if inLaboratories then
            local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
            for i = 1, #DrugsHandler.LaboData do 
                local labo = DrugsHandler.LaboData[i]
                for k,v in pairs (DrugsHandler.Builds) do 
                    if k == labo.type then 
                        for key, value in pairs (DrugsHandler.Interiors) do 
                            if key == labo.type then 
                                if #(pCoords - value.Position.pos) < 15.0 then
                                    OnMarker = true
                                    if not DrugsHandler.MenuIsOpen then 
                                        DrawMarker(22, value.Position.pos, 0, 0, 0, 0, 0, 0, 0.25, 0.25, 0.25, 255, 0, 0, 255, 1, 0, 0, 2)                              
                                    end
                                end
                                if #(pCoords - value.Position.pos) < 1.2 then
                                    if not DrugsHandler.MenuIsOpen then 
                                        ESX.ShowHelpNotification("Appuyer sur ~INPUT_PICKUP~ pour sortir du ~b~laboratoire~s~.")
                                        if IsControlJustPressed(1, 51) then
                                            TriggerServerEvent("Laboratories:ExitInteract", labo.id, DrugsHandler.Builds[labo.type].Labo[labo.value].Entering)
                                        end 
                                    end
                                end
                                for _,user in pairs(DrugsHandler.Users) do 
                                --    if labo.owner == user.identifier then 
                                        if #(pCoords - value.Computer) < 15.0 then
                                            OnMarker = true
                                            if not DrugsHandler.MenuIsOpen then 
                                                DrawMarker(22, value.Computer, 0, 0, 0, 0, 0, 0, 0.25, 0.25, 0.25, 0, 255, 178, 255, 1, 0, 0, 2)                              
                                            end
                                        end
                                        if #(pCoords - value.Computer) < 1.2 then
                                            if not DrugsHandler.MenuIsOpen then 
                                                ESX.ShowHelpNotification("Appuyer sur ~INPUT_PICKUP~ pour gérer votre ~b~laboratoire~s~.")                                        
                                                if IsControlJustPressed(1, 51) then
                                                    if closestDistance == -1 then 
                                                        TriggerServerEvent("Laboratories:OpenComputer")
                                                    else
                                                        if closestPlayer ~= -1 and closestDistance >= 1.5 then 
                                                            TriggerServerEvent("Laboratories:OpenComputer")
                                                        else
                                                            ESX.ShowNotification("~r~Action impossible.")
                                                        end
                                                    end
                                                    
                                                end 
                                            end
                                        end
                                --    end
                                end
                                if not treatmentTimeout then 
                                    if labo.type ~= "Weed" then 
                                        if #(pCoords - value.Treatment) < 15.0 then
                                            OnMarker = true
                                            DrawMarker(22, value.Treatment, 0, 0, 0, 0, 0, 0, 0.25, 0.25, 0.25, 0, 220, 255, 255, 1, 0, 0, 2)                              
                                        end
                                        if #(pCoords - value.Treatment) < 1.2 then
                                            ESX.ShowHelpNotification(("Appuyer sur ~INPUT_PICKUP~ pour traiter la %s"):format(string.lower(k)))      
                                            if IsControlJustPressed(1, 51) then
                                                if closestDistance == -1 then 
                                                    TriggerServerEvent("Laboratories:PurchaseTreatment", k)
                                                else
                                                    if closestPlayer ~= -1 and closestDistance >= 3 then 
                                                        TriggerServerEvent("Laboratories:PurchaseTreatment", k)
                                                    else
                                                        ESX.ShowNotification("~r~Action impossible.")
                                                    end
                                                end
                                            end
                                        end
                                    else
                                        if labo.data.details.chairs == true then 
                                            if #(pCoords - value.Treatment) < 15.0 then
                                                OnMarker = true
                                                DrawMarker(22, value.Treatment, 0, 0, 0, 0, 0, 0, 0.25, 0.25, 0.25, 0, 220, 255, 255, 1, 0, 0, 2)                              
                                            end
                                            if #(pCoords - value.Treatment) < 1.2 then
                                                ESX.ShowHelpNotification(("Appuyer sur ~INPUT_PICKUP~ pour traiter la %s"):format(string.lower(k)))      
                                                if IsControlJustPressed(1, 51) then
                                                    if closestDistance == -1 then 
                                                        TriggerServerEvent("Laboratories:PurchaseTreatment", k)
                                                    else
                                                        if closestPlayer ~= -1 and closestDistance >= 3 then 
                                                            TriggerServerEvent("Laboratories:PurchaseTreatment", k)
                                                        else
                                                            ESX.ShowNotification("~r~Action impossible.")
                                                        end
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                                for y,u in pairs (value.Harvest) do 
                                    for i = 1, #labo.production do 
                                        if not harvestTimeout then 
                                            if labo.type == "Weed" then 
                                                if #(pCoords - u.pos) < 2.5 then
                                                    OnMarker = true
                                                    if labo.production[y] == 2 then 
                                                        ESX.ShowHelpNotification(("Appuyer sur ~INPUT_PICKUP~ pour arroser le plan de %s"):format(string.lower(k)))      
                                                        if IsControlJustPressed(1, 51) then
                                                            if closestDistance == -1 then 
                                                                DrugsHandler.actionFarm(labo.id, labo.data.interiorStatus, labo.type, y, 1, labo.production)
                                                            else
                                                                if closestPlayer ~= -1 and closestDistance >= 3 then 
                                                                    DrugsHandler.actionFarm(labo.id, labo.data.interiorStatus, labo.type, y, 1, labo.production)
                                                                else
                                                                    ESX.ShowNotification("~r~Action impossible.")
                                                                end
                                                            end
                                                        end    
                                                    elseif labo.production[y] == 3 then 
                                                        ESX.ShowHelpNotification(("Appuyer sur ~INPUT_PICKUP~ pour récolter de %s"):format(string.lower(k)))      
                                                        if IsControlJustPressed(1, 51) then
                                                            if closestDistance == -1 then 
                                                                DrugsHandler.actionFarm(labo.id, labo.data.interiorStatus, labo.type, y, 2, labo.production)
                                                            else
                                                                if closestPlayer ~= -1 and closestDistance >= 3 then 
                                                                    DrugsHandler.actionFarm(labo.id, labo.data.interiorStatus, labo.type, y, 2, labo.production)
                                                                else
                                                                    ESX.ShowNotification("~r~Action impossible.")
                                                                end
                                                            end
                                                        end   
                                                    end
                                                end
                                            end
                                            if labo.type == "Cocaïne" then
                                                if labo.data.interiorStatus == "upgrade" then 
                                                    cokeCounter = 5 
                                                end
                                                if #(pCoords - u.pos) < 1.2 then
                                                    OnMarker = true
                                                    if y <= cokeCounter then 
                                                        if labo.production[y] == 2 then 
                                                            ESX.ShowHelpNotification(("Appuyer sur ~INPUT_PICKUP~ pour rassembler la %s."):format(string.lower(k)))      
                                                            if IsControlJustPressed(1, 51) then
                                                                if closestDistance == -1 then 
                                                                    DrugsHandler.actionFarm(labo.id, labo.data.interiorStatus, labo.type, y, 1, labo.production)
                                                                else
                                                                    if closestPlayer ~= -1 and closestDistance >= 3 then 
                                                                        DrugsHandler.actionFarm(labo.id, labo.data.interiorStatus, labo.type, y, 1, labo.production)
                                                                    else
                                                                        ESX.ShowNotification("~r~Action impossible.")
                                                                    end
                                                                end
                                                            end 
                                                        end
                                                    end
                                                end
                                            end
                                            if labo.type == "Meth" then
                                                if #(pCoords - u.pos) < 1.2 then
                                                    OnMarker = true
                                                    if labo.production[y] == 2 then 
                                                        ESX.ShowHelpNotification(("Appuyer sur ~INPUT_PICKUP~ pour mélanger la %s."):format(string.lower(k)))      
                                                        if IsControlJustPressed(1, 51) then
                                                            if closestDistance == -1 then 
                                                                DrugsHandler.actionFarm(labo.id, labo.data.interiorStatus, labo.type, y, 1, labo.production)
                                                            else
                                                                if closestPlayer ~= -1 and closestDistance >= 3 then 
                                                                    DrugsHandler.actionFarm(labo.id, labo.data.interiorStatus, labo.type, y, 1, labo.production)
                                                                else
                                                                    ESX.ShowNotification("~r~Action impossible.")
                                                                end
                                                            end
                                                        end    
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
        if OnMarker then
            Wait(1)
        else
            Wait(500)
        end
    end
end)
