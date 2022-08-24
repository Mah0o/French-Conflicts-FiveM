ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


-- LOGS WEBHOOK --
local function isWebhookSet(val)
  return val ~= nil and val ~= ""
end
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
--- Avoir le timestamp ---
local date = os.date('*t')
if date.day < 10 then date.day = '' .. tostring(date.day) end
if date.month < 10 then date.month = '' .. tostring(date.month) end
if date.hour < 10 then date.hour = '' .. tostring(date.hour) end
if date.min < 10 then date.min = '' .. tostring(date.min) end
if date.sec < 10 then date.sec = '' .. tostring(date.sec) end
--------------------------
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
------------------

RegisterServerEvent('esx_skin:save')
AddEventHandler('esx_skin:save', function(skin)

  local xPlayer = ESX.GetPlayerFromId(source)

  MySQL.Async.execute(
    'UPDATE users SET `skin` = @skin WHERE identifier = @identifier',
    {
      ['@identifier'] = xPlayer.identifier,
      ['@skin'] = json.encode(skin),
    }
  )
end)

RegisterServerEvent('izakkk:saveoff')
AddEventHandler('izakkk:saveoff', function(Sex, Prenom, Nom, Data, Taille)
  local xPlayer = ESX.GetPlayerFromId(source)
  _source = source
  mySteamID = GetPlayerIdentifiers(_source)
  mySteam = mySteamID[1]

  MySQL.Async.execute('UPDATE users SET firstname = @firstname, lastname = @lastname, dateofbirth = @dateofbirth, sex = @sex, height = @height WHERE identifier = @identifier', {
    ['@identifier'] = xPlayer.identifier,
    ['@firstname'] = Prenom,
    ['@lastname'] = Nom,
    ['@dateofbirth'] = Data,
    ['@sex'] = Sex,
    ['@height'] = Taille
  }, function(rowsChanged)
    if callback then
      callback(true)
    end
  end)

  --- LOGS ---
  local source = source
  local playerName = GetPlayerName(source)
  local playerID = source
  local playerLicence = "Aucun"
  local playerSteam = "Aucun"
  local playerDiscord = "Aucun"
  for k, v in ipairs(GetPlayerIdentifiers(source)) do
    if string.match(v, "license:") then playerLicence = v end
    if string.match(v, "steam:") then playerSteam = v end
    if string.match(v, "discord:") then playerDiscord = v end
  end
  playerDiscord = playerDiscord:gsub("discord:", "")
  -- Message Discord --
  local titre = playerName.." à crée son personnage"
  local desc = "- ["..playerID.."] "..playerName.." - <@"..playerDiscord..">\n- ("..playerSteam..")\n- "..playerLicence
  local info = "- Prénom & Nom : "..Prenom.." "..Nom.."\n- Date de Naissance : "..Data.."\n- Sexe : "..Sex.."\n- Taile : "..Taille
  local descFinal = desc.."\n\n"..info
  local footer = "Nouveau Joueur "..playerSteam
  sendWebhook(titre,descFinal,footer,"gris",Config.webhook.onAll)
end)