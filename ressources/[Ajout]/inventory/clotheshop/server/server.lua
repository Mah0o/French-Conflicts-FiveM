
ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


RegisterServerEvent(Shared.prefix..'getclothes')
AddEventHandler(Shared.prefix..'getclothes', function(type, name, lunettes,variation, Nom1, Nom2)
  local ident = GetPlayerIdentifier(source)
  maskx = {[Nom1]=tonumber(lunettes),[Nom2]=tonumber(variation)} 
	MySQL.Async.execute('INSERT INTO vetement (identifier, type, nom, clothe) VALUES (@identifier, @type, @nom, @clothe)',
	{ 
	['@identifier']   = ident,
    ['@type']   = type,
    ['@nom']   = name,
    ['@clothe'] = json.encode(maskx)
	}, function(rowsChanged) 
	end)
end) 

RegisterServerEvent(Shared.prefix..'inserttenue')
AddEventHandler(Shared.prefix..'inserttenue', function(type, name, clothe)
  local ident = GetPlayerIdentifier(source)
	MySQL.Async.execute('INSERT INTO vetement (identifier, type, nom, clothe) VALUES (@identifier, @type, @nom, @clothe)',
	{ 
	['@identifier']   = ident,
    ['@type']   = type,
    ['@nom']   = name,
    ['@clothe'] = json.encode(clothe)
	}, function(rowsChanged) 
	end)
end) 

RegisterServerEvent(Shared.prefix..'changename')
AddEventHandler(Shared.prefix..'changenom', function(id, Actif)   
	MySQL.Sync.execute('UPDATE vetement SET nom = @nom WHERE id = @id', {
		['@id'] = id,   
		['@nom'] = Actif        
	})
end) 

ESX.RegisterServerCallback(Shared.prefix..'getmask', function(source, cb)
	local identifier = GetPlayerIdentifier(source)
	local masque = {}
	MySQL.Async.fetchAll('SELECT * FROM vetement WHERE identifier = @identifier', {
		['@identifier'] = identifier
	}, function(result) 
		for i = 1, #result, 1 do  
			table.insert(masque, {      
                type      = result[i].type,  
				clothe      = result[i].clothe,
				id      = result[i].id,
				nom      = result[i].nom,

			})
		end  
		cb(masque) 
	end)  
end)   

RegisterServerEvent(Shared.prefix..'giveitem')
AddEventHandler(Shared.prefix..'giveitem', function(id, target)   
	local xaplayertarget = GetPlayerIdentifier(target)
	MySQL.Sync.execute('UPDATE vetement SET identifier = @identifier WHERE id = @id', {
		['@id'] = id, 
		['@identifier'] = xaplayertarget        
	})
end) 

 
ESX.RegisterServerCallback(Shared.prefix..'getalltenues', function(source, cb)
	MySQL.Async.fetchAll('SELECT id, clothe, nom, type FROM vetement', {}, function(result)
		cb(result)
	end)
end) 

ESX.RegisterServerCallback('Checkmoney', function(source, cb, price)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.getMoney() >= price then
		cb(true)
		xPlayer.removeMoney(tonumber(price))
		TriggerClientEvent('esx:showNotification', source, "~b~Vous venez de faire un payment de~s~ (~g~"..tonumber(price).."$~s~)")  
	else 
		TriggerClientEvent('esx:showNotification', source, "~r~Vous n'avez pas assez d'argent.")  
		cb(false)
	end
end)

