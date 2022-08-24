ESX = nil
Citizen.CreateThread(function() while ESX == nil do TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end) Citizen.Wait(0) end end)

local playerName = nil 
local playerLoaded = false 
local firstSpawn = true 
RegisterNetEvent("esx:playerLoaded")
AddEventHandler("esx:playerLoaded", function(xPlayer)
    ESX.PlayerData = xPlayer
    playerLoaded = true
end)
AddEventHandler("playerSpawned", function()
    if firstSpawn then
        for _,v in pairs(ConfigRichPresence.Buttons) do SetDiscordRichPresenceAction(v.index, v.name, v.url) end
        firstSpawn = false
    end 
end)

function SetRP()
    local name = GetPlayerName(PlayerId())
    local id = GetPlayerServerId(PlayerId())
    SetDiscordAppId(ConfigRichPresence.ClientID)
    SetDiscordRichPresenceAsset(ConfigRichPresence.image)
    SetDiscordRichPresenceAssetSmall(ConfigRichPresence.image)
end

Citizen.CreateThread(function()
    while not playerLoaded do Citizen.Wait(100) end 
    while true do 
        SetRP()
        SetRichPresence("French Army Roleplay\nJoueur : "..GetPlayerName(PlayerId()).." | ID: " ..GetPlayerServerId(PlayerId()))
        Citizen.Wait(ConfigRichPresence.RessourceTimer*1000)
    end 
end)