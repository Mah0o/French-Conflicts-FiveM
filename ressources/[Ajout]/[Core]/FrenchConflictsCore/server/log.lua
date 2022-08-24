ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

--- Avoir le timestamp ---
local date = os.date('*t')
if date.day < 10 then date.day = '' .. tostring(date.day) end
if date.month < 10 then date.month = '' .. tostring(date.month) end
if date.hour < 10 then date.hour = '' .. tostring(date.hour) end
if date.min < 10 then date.min = '' .. tostring(date.min) end
if date.sec < 10 then date.sec = '' .. tostring(date.sec) end
--------------------------

-- Webhook Logs --
local webhookColors = {
    ["red"] = 16711680,
    ["green"] = 56108,
    ["orange"] = 16744192,
	["jaune"] = 16777036,
	["magenta"] = 16711935,
	["violet"] = 15619071,
	["rose"] = 16716947,
	["bleu"] = 255,
	["bleuclair"] = 49151,
	["gris"] = 11119017,
	["blanc"] = 16777215,
	["noir"] = 0
}
function sendWebhook(titre,description,footer,color,url)
    local DiscordWebHook = url
    local embeds = {
        {
            ["title"] = titre,
			["description"] = description,
            ["type"] = "rich",
            ["color"] = webhookColors[color],
            ["footer"] =  {
                ["text"]= footer.." / "..os.date("%Y").." • "..os.date("%x %X %p")
            },
        }
    }
    PerformHttpRequest(DiscordWebHook, function(err, text, headers) end, 'POST', json.encode({ username = "sk_system",embeds = embeds}), { ['Content-Type'] = 'application/json' })
end

-- Logs Connection --
AddEventHandler("playerConnecting", function(name, setReason, deferrals)
    -- Joueur Connecté --
    local source = source
    local coords = GetEntityCoords(GetPlayerPed(source), true)
    local playerCoords = ESX.Math.Round(coords.x,3).." "..ESX.Math.Round(coords.y,3).." "..ESX.Math.Round(coords.z,3)
    local playerName = GetPlayerName(source)
    local playerLicence = "Aucun"
    local playerSteam = "Aucun"
    local playerDiscord = "Aucun"
    for k, v in ipairs(GetPlayerIdentifiers(source)) do
        if string.match(v, "license:") then playerLicence = v end
        if string.match(v, "steam:") then playerSteam = v end
        if string.match(v, "discord:") then playerDiscord = v end
    end
    playerDiscord = playerDiscord:gsub("discord:", "")
    -- Message Send Webhook --
    local titre = playerName.." se connecte"
    local desc = "- ["..source.."] "..playerName.." - <@"..playerDiscord..">\n- ("..playerSteam..")\n- "..playerLicence.."\n- Coords : "..playerCoords
    local footer = "Joueur Connection "..playerSteam
	sendWebhook(titre,desc,footer,"blanc",Config.webhook.onAll)
end)

-- Logs Déconnecté -- 
AddEventHandler('playerDropped', function(reason)
	-- Joueur Leave --
    local source = source
    local coords = GetEntityCoords(GetPlayerPed(source), true)
    local playerCoords = ESX.Math.Round(coords.x,3).." "..ESX.Math.Round(coords.y,3).." "..ESX.Math.Round(coords.z,3)
    local playerName = GetPlayerName(source)
    local playerLicence = "Aucun"
    local playerSteam = "Aucun"
    local playerDiscord = "Aucun"
    for k, v in ipairs(GetPlayerIdentifiers(source)) do
        if string.match(v, "license:") then playerLicence = v end
        if string.match(v, "steam:") then playerSteam = v end
        if string.match(v, "discord:") then playerDiscord = v end
    end
    playerDiscord = playerDiscord:gsub("discord:", "")
    -- Message Send Webhook --
    local titre = playerName.." c'est déconnecté : "..reason
    local desc = "- ["..source.."] "..playerName.." - <@"..playerDiscord..">\n- ("..playerSteam..")\n- "..playerLicence.."\n- Coords : "..playerCoords
    local footer = "Joueur Déconnecté "..playerSteam
	sendWebhook(titre,desc,footer,"blanc",Config.webhook.onAll)
end)

-- Logs Mort --
RegisterServerEvent('sk:playerDied')
AddEventHandler('sk:playerDied',function(args)
	if args.type == 1 then
        --print("Suicide/died")
        -- Joueur : Suicide/died --
        local source = source
        local coords = GetEntityCoords(GetPlayerPed(source), true)
        local playerCoords = ESX.Math.Round(coords.x,3).." "..ESX.Math.Round(coords.y,3).." "..ESX.Math.Round(coords.z,3)
        local playerName = GetPlayerName(source)
        local playerLicence = "Aucun"
        local playerSteam = "Aucun"
        local playerDiscord = "Aucun"
        for k, v in ipairs(GetPlayerIdentifiers(source)) do
            if string.match(v, "license:") then playerLicence = v end
            if string.match(v, "steam:") then playerSteam = v end
            if string.match(v, "discord:") then playerDiscord = v end
        end
        playerDiscord = playerDiscord:gsub("discord:", "")
        -- Message Send Webhook --
        local titre = playerName.." "..args.death_reason.." "
        local desc = "- ["..source.."] "..playerName.." - <@"..playerDiscord..">\n- ("..playerSteam..")\n- "..playerLicence.."\n- Coords : "..playerCoords
        local footer = "Joueur Mort "..playerSteam
        sendWebhook(titre,desc,footer,"red",Config.webhook.onAll)

	elseif args.type == 2 then -- Killed by other player
        --print("Killed by other player")
        -- Joueur Mort --
        local source = source
        local coords = GetEntityCoords(GetPlayerPed(source), true)
        local playerCoords = ESX.Math.Round(coords.x,3).." "..ESX.Math.Round(coords.y,3).." "..ESX.Math.Round(coords.z,3)
        local playerName = GetPlayerName(source)
        local playerLicence = "Aucun"
        local playerSteam = "Aucun"
        local playerDiscord = "Aucun"
        for k, v in ipairs(GetPlayerIdentifiers(source)) do
            if string.match(v, "license:") then playerLicence = v end
            if string.match(v, "steam:") then playerSteam = v end
            if string.match(v, "discord:") then playerDiscord = v end
        end
        playerDiscord = playerDiscord:gsub("discord:", "")
        -- Joueur Target --
        local sourceTarget = args.player_2_id
        local coTarget = GetEntityCoords(GetPlayerPed(sourceTarget), true)
        local targetCoords = ESX.Math.Round(coTarget.x,3).." "..ESX.Math.Round(coTarget.y,3).." "..ESX.Math.Round(coTarget.z,3)
        local targetName = GetPlayerName(sourceTarget)
        local targetLicence = "Aucun"
        local targetSteam = "Aucun"
        local targetDiscord = "Aucun"
        for k, v in ipairs(GetPlayerIdentifiers(sourceTarget)) do
            if string.match(v, "license:") then targetLicence = v end
            if string.match(v, "steam:") then targetSteam = v end
            if string.match(v, "discord:") then targetDiscord = v end
        end
        targetDiscord = targetDiscord:gsub("discord:", "")
        -- Message Send Webhook --
        local titre = playerName.." c'est fais tué par "..targetName
        local descDead = "- ["..source.."] "..playerName.." - <@"..playerDiscord..">\n- ("..playerSteam..")\n- "..playerLicence.."\n- Coords : "..playerCoords
        local descTarget = "- ["..sourceTarget.."] "..targetName.." - <@"..targetDiscord..">\n- ("..targetSteam..")\n- "..targetLicence.."\n- Coords : "..targetCoords
        local desc = descDead.."\n\n"..descTarget
        local footer = "Joueur Kill "..playerSteam
        sendWebhook(titre,desc,footer,"red",Config.webhook.onAll)

	else -- When gets killed by something else
        --print("When gets killed by something else")

        sendWebhook("someting","desc ","mdr","red",Config.webhook.onAll)
	end
end)



