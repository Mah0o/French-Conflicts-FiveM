ESX, Labo = nil, {}

TriggerEvent("esx:getSharedObject", function(obj) 
    ESX = obj 
end)

local drugsBasicInfos = function(Table)
    if Table == nil then return end
    Table.Data = {}
    if Table.Type == "Meth" then 
        Table.Data = {
            interior = {"meth_lab_basic", "meth_lab_setup"}, 
            interiorStatus = "basic"
        }
    elseif Table.Type == "Cocaïne" then 
        Table.Data = {
            interior = {"set_up", "equipment_basic", "coke_press_basic", "production_basic", "table_equipment"}, 
            interiorStatus = "basic"
        }
    elseif Table.Type == "Weed" then 
        Table.Data = {
            interior = "weed_standard_equip",
            interiorStatus = "basic",
            details = {
                drying = false,
                chairs = false,
                production = false
            }
        }
    end
end 

local DrugsUpgradeInfos = function(type, value)
    if type == "Meth" then 
        if value == "basic" then 
            return {"meth_lab_basic", "meth_lab_setup"}
        end
        if value == "upgrade" then 
            return {"meth_lab_upgrade", "meth_lab_setup"}
        end
    end
    if type == "Weed" then 
        if value == "upgrade" then 
            return "weed_upgrade_equip"
        end
    end
    if type == "Cocaïne" then 
        if value == "upgrade" then 
            return {"set_up", "equipment_upgrade", "coke_press_upgrade", "production_upgrade", "table_equipment_upgrade"}
        end
    end
end

local DrugsProductionInfos = function(type, value, count)
    if type == "Meth" then
        local table = {}
        for i=1, 1 do
            table[i] = value
        end
        return json.encode(table)
    end
    if type == "Weed" then 
        local table = {}
        for i=1, 9 do
            table[i] = value
        end
        return json.encode(table)
    end
    if type == "Cocaïne" then 
        local table = {}
        if count then
            for i=1, count do
                table[i] = value
            end
        else
            for i=1, 5 do
                table[i] = value
            end
        end
        return json.encode(table)
    end 
end

local saveLabo = function(laboId, laboData)
    if laboId == nil then return end
    MySQL.Async.execute("UPDATE drugs SET data = @data WHERE id = @id", {
        ["id"] = laboId,
        ["data"] = json.encode(laboData)
    })
end

local saveProduction = function(laboId, laboProduction)
    if laboId == nil then return end
    MySQL.Async.execute("UPDATE drugs SET production = @production WHERE id = @id", {
        ["id"] = laboId,
        ["production"] = laboProduction
    })
end

RegisterServerEvent("Laboratories:SetPlayerIntoBucket")
AddEventHandler("Laboratories:SetPlayerIntoBucket", function(bucketId)
    local _src = source 
    SetPlayerRoutingBucket(_src, bucketId)
end)

RegisterServerEvent("Laboratories:SetPlayerIntoNormalBucket")
AddEventHandler("Laboratories:SetPlayerIntoNormalBucket", function()
    local _src = source 
    SetPlayerRoutingBucket(_src, 0)
end)

ESX.RegisterServerCallback("Laboratories:GetUserInfos", function(source, cb)
    local _src = source 
    local xPlayer = ESX.GetPlayerFromId(_src)     
    MySQL.Async.fetchAll('SELECT * FROM users WHERE identifier = @identifier', {
        ["identifier"] = xPlayer.identifier
    }, function(userData)
    	cb(userData)
    end)
end)

ESX.RegisterServerCallback("Laboratories:GetLaboratories", function(source, cb)
    SetTimeout(350, function()
        MySQL.Async.fetchAll('SELECT * FROM drugs', {}, function(drugsData)
            for k, v in pairs(drugsData) do
                drugsData[k].data = json.decode(v.data)
            end
            cb(drugsData)
        end)
    end)
end)

RegisterServerEvent("Laboratories:BuyLaboratories")
AddEventHandler("Laboratories:BuyLaboratories", function(Drugs)
    local _src = source 
    local xPlayer = ESX.GetPlayerFromId(_src)
    if Drugs == nil then return end 
    local randomNumber = math.random(1111, 9999)
    if xPlayer.getMoney() < Drugs.Price then 
        return TriggerClientEvent("esx:showNotification", _src, "Vous n'avez pas assez d'argent...")
    end
    SetTimeout(350, function()
        MySQL.Async.fetchAll("SELECT * FROM drugs WHERE owner = @owner AND type = @type AND value = @value", {
            ["owner"] = xPlayer.identifier,
            ["type"] = Drugs.Type,
            ["value"] = Drugs.Value
        }, function(result)
            if result[1] then 
                TriggerClientEvent("esx:showNotification", _src, "~r~Vous avez déjà ce laboratoire de "..string.lower(Drugs.Type))
            else
                drugsBasicInfos(Drugs)
                xPlayer.removeMoney(Drugs.Price)
                MySQL.Async.execute('INSERT INTO drugs (owner, type, value, data, production, password) VALUES (@owner, @type, @value, @data, @production, @password)', {
                    ['owner'] = xPlayer.identifier,
                    ['type'] = Drugs.Type,
                    ['value'] = Drugs.Value,
                    ['data'] = json.encode(Drugs.Data),
                    ['production'] = DrugsProductionInfos(Drugs.Type, 1),
                    ['password'] = randomNumber
                })
                Wait(350)
                TriggerClientEvent("esx:showNotification", _src, "Vous avez acheté un laboratoire de "..string.lower(Drugs.Type).." pour ~g~"..Drugs.Price.."$")
                TriggerClientEvent("Laboratories:AddWaypoint", _src, Drugs)
                TriggerClientEvent("Laboratories:refreshLaboratories", -1)
                Drugs = {}
            end
        end)
    end)
end)

RegisterServerEvent("Laboratories:Interact")
AddEventHandler("Laboratories:Interact", function(LaboType, LaboIndex)
    local _src = source
    local xPlayer = ESX.GetPlayerFromId(_src)
    SetTimeout(350, function()
        MySQL.Async.fetchAll('SELECT * FROM drugs WHERE type = @type AND value = @value', {
            ["type"] = LaboType,
            ["value"] = LaboIndex
        }, function(drugsData)
            if drugsData[1] then 
                for k,v in pairs(drugsData) do
                    drugsData[k].data = json.decode(v.data)
                    drugsData[k].storage = json.decode(v.storage)
                    drugsData[k].production = json.decode(v.production)
                end
                TriggerClientEvent("Laboratories:OpenInteractMenu", _src, drugsData, xPlayer.identifier)
            end
        end)
    end)
end)

RegisterServerEvent("Laboratories:OpenComputer")
AddEventHandler("Laboratories:OpenComputer", function()
    local _src = source
    local xPlayer = ESX.GetPlayerFromId(_src)
    TriggerClientEvent("Laboratories:OpenComputerMenu", _src, xPlayer.getIdentifier())
end)

RegisterServerEvent("Laboratories:EnteringLaboratories")
AddEventHandler("Laboratories:EnteringLaboratories", function(laboId, LaboType, LaboIndex)
    local _src = source
    local xPlayer = ESX.GetPlayerFromId(_src)
    local coords = {}
    if Labo[laboId] then 
        for k,v in pairs(Labo) do 
            if k == laboId then
                if Labo[k] then 
                    if Labo[k].players then 
                        table.insert(Labo[k].players, {
                            id = _src
                        })
                    else
                        Labo[k].players = {}
                        table.insert(Labo[k].players, {
                            id = _src
                        })
                    end
                end
            end
        end 
    else
        Labo[laboId] = {}
        Labo[laboId].players = {}
        table.insert(Labo[laboId].players, {
            id = _src
        })
    end
    local bucketId = 1545477 + laboId
    if LaboType == nil then return end 
    SetTimeout(350, function()
        MySQL.Async.fetchAll('SELECT * FROM drugs WHERE id = @id AND type = @type AND value = @value', {
            ["id"] = laboId,
            ["type"] = LaboType,
            ["value"] = LaboIndex
        }, function(laboData)
            if laboData[1] then 
                for k,v in pairs(laboData) do
                    laboData[k].data = json.decode(v.data)
                    laboData[k].storage = json.decode(v.storage)
                    laboData[k].production = json.decode(v.production)
                end
                for key, value in pairs (DrugsHandler.Interiors) do 
                    if key == LaboType then 
                        coords = value.Position
                        TriggerClientEvent("Laboratories:SetIntoLaboratories", _src, coords, laboData, LaboType, bucketId)
                    end
                end 
            end
        end)
    end)
end)

RegisterServerEvent("Laboratories:EnteringIntoOtherLaboratories")
AddEventHandler("Laboratories:EnteringIntoOtherLaboratories", function(laboId, LaboType, LaboIndex)
    local _src = source
    local xPlayer = ESX.GetPlayerFromId(_src)
    local coords = {}
    for k,v in pairs(Labo) do 
        if k == laboId then
            if Labo[k] then 
                if Labo[k].players then 
                    table.insert(Labo[k].players, {
                        id = _src
                    })
                else
                    Labo[k].players = {}
                    table.insert(Labo[k].players, {
                        id = _src
                    })
                end
            end
        end
    end 
    local bucketId = 1545477 + laboId
    if LaboType == nil then return end 
    SetTimeout(350, function()
        MySQL.Async.fetchAll('SELECT * FROM drugs WHERE id = @id AND type = @type AND value = @value', {
            ["id"] = laboId,
            ["type"] = LaboType,
            ["value"] = LaboIndex
        }, function(laboData)
            if laboData[1] then 
                for k,v in pairs(laboData) do
                    laboData[k].data = json.decode(v.data)
                    laboData[k].storage = json.decode(v.storage)
                    laboData[k].production = json.decode(v.production)
                end
                for key, value in pairs (DrugsHandler.Interiors) do 
                    if key == LaboType then 
                        coords = value.Position
                        TriggerClientEvent("Laboratories:SetIntoLaboratories", _src, coords, laboData, LaboType, bucketId)
                    end
                end 
            end
        end)
    end)
end)

RegisterServerEvent("Laboratories:ExitInteract")
AddEventHandler("Laboratories:ExitInteract", function(laboId, coords)
    local _src = source
    local xPlayer = ESX.GetPlayerFromId(_src)
    for k,v in pairs(Labo) do 
        if k == laboId then
            if Labo[k] then 
                if Labo[k].players then 
                    for t,b in pairs(v.players) do 
                        if #v.players > 1 then 
                            if b.id == _src then 
                                b.id = nil 
                            end
                        else
                            v.players = {}
                        end
                    end
                end
            end
        end
    end
    SetTimeout(350, function()
        TriggerClientEvent("Laboratories:ExitLaboratories", _src, coords)
    end)
end)

RegisterServerEvent("Laboratories:DeleteLaboratories")
AddEventHandler("Laboratories:DeleteLaboratories", function(laboId, laboType, laboValue)
    local _src = source
    local xPlayer = ESX.GetPlayerFromId(_src)
    if laboId == nil then return end
    MySQL.Sync.execute("DELETE FROM drugs WHERE id = @id", {
        ["id"] = laboId 
    })
    for key, value in pairs (DrugsHandler.Builds[laboType].Labo) do 
        if key == laboValue then 
            coords = value.Entering
            TriggerClientEvent("Laboratories:ExitLaboratories", _src, coords)
            TriggerClientEvent("Laboratories:refreshLaboratories", _src)
        end
    end    
    for k,v in pairs(Labo) do 
        if laboId == k then 
            for t,b in pairs(v.players) do 
                if b.id ~= nil then 
                    TriggerClientEvent("Laboratories:ExitLaboratories", b.id, coords)
                    TriggerClientEvent("Laboratories:refreshLaboratories", b.id)
                end
            end
        end
    end
    Labo[laboId] = nil 
    TriggerClientEvent("esx:showNotification", _src, "Vous ne possèdez plus ce laboratoire.") 
end)

RegisterServerEvent("Laboratories:UpgradeLaboratories")
AddEventHandler("Laboratories:UpgradeLaboratories", function(upgradeType, upgradeValue, upgradePrice, laboType, laboId, laboData)
    local _src = source
    local xPlayer = ESX.GetPlayerFromId(_src)
    local upgrade = DrugsUpgradeInfos(laboType, upgradeValue)
    if xPlayer.getMoney() < upgradePrice then 
        return TriggerClientEvent("esx:showNotification", _src, "Vous n'avez pas assez d'argent pour effectuer l'amélioration...")
    end
    if upgradeType == "interior" then 
        laboData.interiorStatus = upgradeValue
        laboData.interior = upgrade
    end
    if upgradeType == "details" then 
        if laboType == "Weed" then 
            if upgradeValue == "weed_chairs" then 
                if laboData.details.chairs == true then 
                    return TriggerClientEvent("esx:showNotification", _src, "Vous avez déjà effectué cette amélioration..") 
                end
                laboData.details.chairs = true
            end
        end
    end
    xPlayer.removeMoney(upgradePrice)
    TriggerClientEvent("esx:showNotification", _src, "L'amélioration a été effectuée.")
    saveLabo(laboId, laboData)
    SetTimeout(350, function()
        MySQL.Async.fetchAll('SELECT * FROM drugs WHERE id = @id', {
            ["id"] = laboId
        }, function(laboData)
            if laboData[1] then 
                for k,v in pairs(laboData) do
                    laboData[k].data = json.decode(v.data)
                    laboData[k].storage = json.decode(v.storage)
                    laboData[k].production = json.decode(v.production)
                end
                for k,v in pairs(Labo) do 
                    if laboId == k then 
                        for t,b in pairs(v.players) do 
                            if b.id ~= nil then
                                TriggerClientEvent("Laboratories:reloadUpgrade", b.id, laboData, laboType, nil, true)      
                            end
                        end
                    end
                end
            end
        end)
    end)
end)

RegisterServerEvent("Laboratories:DepositItems")
AddEventHandler("Laboratories:DepositItems", function(laboId, laboStorage, itemName, itemCount)
    local _src = source 
    local xPlayer = ESX.GetPlayerFromId(_src)
    if xPlayer.getInventoryItem(itemName).count >= itemCount then 
        if not laboStorage[itemName] then 
            laboStorage[itemName] = {}
            laboStorage[itemName].label = ESX.GetItemLabel(itemName)
            laboStorage[itemName].count = itemCount
        else
            laboStorage[itemName].count = laboStorage[itemName].count + itemCount
        end
        MySQL.Async.execute("UPDATE drugs SET storage = @storage WHERE id = @id", {
            ["id"] = laboId,
            ["storage"] = json.encode(laboStorage)
        })
        xPlayer.removeInventoryItem(itemName, itemCount)
        for k,v in pairs(Labo) do 
            if laboId == k then 
                for t,b in pairs(v.players) do 
                    if b.id ~= nil then
                        TriggerClientEvent("Laboratories:updateStorage", b.id, laboStorage)
                    end
                end
            end
        end
    else
        TriggerClientEvent("esx:showNotification", _src, ("~r~Vous n'avez pas assez de %s.."):format(ESX.GetItemLabel(itemName)))
    end
end)

RegisterServerEvent("Laboratories:changePassword")
AddEventHandler("Laboratories:changePassword", function(laboId, password)
    local _src = source 
    local xPlayer = ESX.GetPlayerFromId(_src)
    if laboId then 
        if password == nil then return TriggerClientEvent("esx:showNotification", _src, "Une erreur est survenu..") end 
        MySQL.Async.execute("UPDATE drugs SET password = @password WHERE id = @id", {
            ["id"] = laboId,
            ["password"] = password
        })
        for k,v in pairs(Labo) do 
            if laboId == k then 
                for t,b in pairs(v.players) do 
                    if b.id ~= nil then
                        TriggerClientEvent("Laboratories:updatePassword", b.id, password)
                    end
                end
            end
        end
    end
end)

RegisterServerEvent("Laboratories:resellDrugs")
AddEventHandler("Laboratories:resellDrugs", function(itemType, itemCount)
    local _src = source 
    local xPlayer = ESX.GetPlayerFromId(_src)
    if itemType == "Weed" then 
        if xPlayer.getInventoryItem("weed_pooch").count >= itemCount then 
            xPlayer.removeInventoryItem("weed_pooch", itemCount)
            xPlayer.addMoney(itemCount*DrugsHandler.Items[itemType].resellPrice)
            TriggerClientEvent("esx:showNotification", _src, ("Vous avez revendu x~b~%i %s~s~ pour ~g~%i$."):format(itemCount, ESX.GetItemLabel("weed_pooch"), itemCount*DrugsHandler.Items[itemType].resellPrice))
        else
            TriggerClientEvent("esx:showNotification", _src, ("~r~Vous n'avez pas assez de %s.."):format(ESX.GetItemLabel("weed_pooch")))
        end
    elseif itemType == "Meth" then 
        if xPlayer.getInventoryItem("meth_pooch").count >= itemCount then 
            xPlayer.removeInventoryItem("meth_pooch", itemCount)
            xPlayer.addMoney(itemCount*DrugsHandler.Items[itemType].resellPrice)
            TriggerClientEvent("esx:showNotification", _src, ("Vous avez revendu x~b~%i %s~s~ pour ~g~%i$."):format(itemCount, ESX.GetItemLabel("meth_pooch"), itemCount*DrugsHandler.Items[itemType].resellPrice))
        else
            TriggerClientEvent("esx:showNotification", _src, ("~r~Vous n'avez pas assez de %s.."):format(ESX.GetItemLabel("meth_pooch")))
        end
    elseif itemType == "Cocaïne" then 
        if xPlayer.getInventoryItem("coke_pooch").count >= itemCount then 
            xPlayer.removeInventoryItem("coke_pooch", itemCount)
            xPlayer.addMoney(itemCount*DrugsHandler.Items[itemType].resellPrice)
            TriggerClientEvent("esx:showNotification", _src, ("Vous avez revendu x~b~%i %s~s~ pour ~g~%i$."):format(itemCount, ESX.GetItemLabel("coke_pooch"), itemCount*DrugsHandler.Items[itemType].resellPrice))
        else
            TriggerClientEvent("esx:showNotification", _src, ("~r~Vous n'avez pas assez de %s.."):format(ESX.GetItemLabel("coke_pooch")))
        end
    end
end)

RegisterServerEvent("Laboratories:WithdrawItems")
AddEventHandler("Laboratories:WithdrawItems", function(laboId, laboStorage, itemName, itemCount)
    local _src = source 
    local xPlayer = ESX.GetPlayerFromId(_src)
    if not laboStorage[itemName] then 
        return TriggerClientEvent("esx:showNotification", _src, "~r~Une erreur est survenu..")            
    end
    if laboStorage[itemName].count >= itemCount then 
        if (laboStorage[itemName].count - itemCount) > 0 then 
            laboStorage[itemName].count = laboStorage[itemName].count - itemCount
        else
            laboStorage[itemName] = nil
        end
        MySQL.Async.execute("UPDATE drugs SET storage = @storage WHERE id = @id", {
            ["id"] = laboId,
            ["storage"] = json.encode(laboStorage)
        })
        xPlayer.addInventoryItem(itemName, itemCount)
        for k,v in pairs(Labo) do 
            if laboId == k then 
                for t,b in pairs(v.players) do 
                    if b.id ~= nil then
                        TriggerClientEvent("Laboratories:updateStorage", b.id, laboStorage)
                    end
                end
            end
        end
    else
        return TriggerClientEvent("esx:showNotification", _src, ("~r~Vous n'avez pas autant de %s dans le coffre.."):format(ESX.GetItemLabel(itemName)))            
    end
end)



RegisterServerEvent("Laboratories:PurchaseTreatment")
AddEventHandler("Laboratories:PurchaseTreatment", function(laboType)
    local _src = source 
    local xPlayer = ESX.GetPlayerFromId(_src)
    if laboType == "Weed" then 
        if xPlayer.getInventoryItem("weed").count >= 5 then
            TriggerClientEvent("Laboratories:TreatmentAnimation", _src, laboType)
            xPlayer.removeInventoryItem("weed", DrugsHandler.Items[laboType].treatment[1])
            xPlayer.addInventoryItem("weed_pooch", DrugsHandler.Items[laboType].treatment[2])
        else
            TriggerClientEvent("esx:showNotification", _src, ("Vous n'avez pas assez pour traiter ! Il vous faut minimum x5 ~b~%s."):format(string.lower(laboType)))
        end
    end
    if laboType == "Cocaïne" then 
        if xPlayer.getInventoryItem("coke").count >= 5 then
            TriggerClientEvent("Laboratories:TreatmentAnimation", _src, laboType)
            xPlayer.removeInventoryItem("coke", DrugsHandler.Items[laboType].treatment[1])
            xPlayer.addInventoryItem("coke_pooch", DrugsHandler.Items[laboType].treatment[2])
        else
            TriggerClientEvent("esx:showNotification", _src, ("Vous n'avez pas assez pour traiter ! Il vous faut minimum x5 ~b~%s."):format(string.lower(laboType)))
        end
    end
    if laboType == "Meth" then 
        if xPlayer.getInventoryItem("meth").count >= 20 then
            TriggerClientEvent("Laboratories:TreatmentAnimation", _src, laboType)
            xPlayer.removeInventoryItem("meth", DrugsHandler.Items[laboType].treatment[1])
            xPlayer.addInventoryItem("meth_pooch", DrugsHandler.Items[laboType].treatment[2])
        else
            TriggerClientEvent("esx:showNotification", _src, ("Vous n'avez pas assez pour traiter ! Il vous faut minimum x20 ~b~%s."):format(string.lower(laboType)))
        end
    end
end)

RegisterServerEvent("Laboratories:BuySupplies")
AddEventHandler("Laboratories:BuySupplies", function(laboId, laboType, suppliesPrice, yourProduction, yourData)
    local _src = source 
    local xPlayer = ESX.GetPlayerFromId(_src)
    if xPlayer.getMoney() < suppliesPrice then 
        return TriggerClientEvent("esx:showNotification", _src, "~r~Vous n'avez pas assez d'argent pour acheter les matières premières..")
    end
    xPlayer.removeMoney(suppliesPrice)
    if laboType == "Cocaïne" then 
        if yourData.interiorStatus == "upgrade" then 
            yourProduction = DrugsProductionInfos(laboType, 2, 5)
        else
            yourProduction = DrugsProductionInfos(laboType, 2, 3)
        end
    else
        yourProduction = DrugsProductionInfos(laboType, 2)
    end
    TriggerClientEvent("esx:showNotification", _src, "L'achat de matière première a été effectuée.")
    saveProduction(laboId, yourProduction)
    SetTimeout(350, function()
        MySQL.Async.fetchAll('SELECT * FROM drugs WHERE id = @id', {
            ["id"] = laboId
        }, function(laboData)
            if laboData[1] then 
                for k,v in pairs(laboData) do
                    laboData[k].data = json.decode(v.data)
                    laboData[k].storage = json.decode(v.storage)
                    laboData[k].production = json.decode(v.production)
                end
                for k,v in pairs(Labo) do 
                    if laboId == k then 
                        for t,b in pairs(v.players) do 
                            if b.id ~= nil then
                                TriggerClientEvent("Laboratories:reloadUpgrade", b.id, laboData, laboType, 2, true)    
                            end  
                        end
                    end
                end
            end
        end)
    end)
end)

RegisterServerEvent("Laboratories:harvest")
AddEventHandler("Laboratories:harvest", function(laboId, laboType, laboZone, laboAction, laboProduction)
    local _src = source 
    local xPlayer = ESX.GetPlayerFromId(_src)
    if not laboProduction then return TriggerClientEvent("esx:showNotification", _src, "Une erreur est survenu..") end 
    if laboType == "Weed" then 
        if laboAction == 1 then 
            laboProduction[laboZone] = 3
        end
        if laboAction == 2 then 
            laboProduction[laboZone] = 1
            xPlayer.addInventoryItem("weed", DrugsHandler.Items[laboType].harvest)
        end
    elseif laboType == "Cocaïne" then 
        if laboAction == 1 then 
            laboProduction[laboZone] = 1
            xPlayer.addInventoryItem("coke", DrugsHandler.Items[laboType].harvest)
        end
    elseif laboType == "Meth" then 
        if laboAction == 1 then 
            laboProduction[laboZone] = 1
            xPlayer.addInventoryItem("meth", DrugsHandler.Items[laboType].harvest)
        end
    end
    saveProduction(laboId, json.encode(laboProduction))
    Wait(350)
    MySQL.Async.fetchAll('SELECT * FROM drugs WHERE id = @id', {
        ["id"] = laboId
    }, function(laboData)
        if laboData[1] then 
            for k,v in pairs(laboData) do
                laboData[k].data = json.decode(v.data)
                laboData[k].storage = json.decode(v.storage)
                laboData[k].production = json.decode(v.production)
            end
            for k,v in pairs(Labo) do 
                if laboId == k then 
                    for t,b in pairs(v.players) do 
                        if b.id ~= nil then
                            TriggerClientEvent("Laboratories:reloadUpgrade", b.id, laboData, laboType, 2, false)      
                        end
                    end
                end
            end
        end
    end)
end)