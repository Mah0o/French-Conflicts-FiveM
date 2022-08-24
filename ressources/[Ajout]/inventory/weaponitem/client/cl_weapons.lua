ESX = nil

local canfire = false
local currWeapon = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(50)
	end

    while true do
        Citizen.Wait(10)
        if canfire then
            DisableControlAction(0, 25, true)
            DisablePlayerFiring(GetPlayerPed(-1), true)
        end
    end

    while true do
        Citizen.Wait(50)
        local player = PlayerPedId()
        if IsPedShooting(player) then
            for k, v in pairs(Shared.Throwables) do
                if k == currentWeapon then
                    ESX.TriggerServerCallback('disc-base:takePlayerItem', function(removed)
                        if removed then
                            TriggerEvent('WeaponItem:removeCurrentWeapon')
                        end
                    end, currentWeapon, 1)
                end
            end
        end
    end

    while true do
        Citizen.Wait(10)
        local currentWeapon = GetSelectedPedWeapon(GetPlayerPed(-1))
        DisplayAmmoThisFrame(currentWeapon)
    end
end)

local currentWeapon
local currentWeaponSlot

RegisterNetEvent('WeaponItem:useWeapon')
AddEventHandler('WeaponItem:useWeapon', function(weapon)
    if currentWeapon == weapon then
        RemoveWeapon(currentWeapon)
        currentWeapon = nil
        currentWeaponSlot = nil
        return
    elseif currentWeapon ~= nil then
        RemoveWeapon(currentWeapon)
        currentWeapon = nil
        currentWeaponSlot = nil
    end
    currentWeapon = weapon
    GiveWeapon(currentWeapon)
    exports['okokNotify']:Alert("Réussi", "Message", 5000, 'success')
    RemoveWeapon(GetHashKey("weapon_pumpshotgun"))
    ClearPedTasks(PlayerPedId())
end)

RegisterNetEvent('WeaponItem:removeCurrentWeapon')
AddEventHandler('WeaponItem:removeCurrentWeapon', function()
    if currentWeapon ~= nil then
        RemoveWeapon(currentWeapon)
        currentWeapon = nil
        currentWeaponSlot = nil
        ClearPedTasks(PlayerPedId())
    end
end)

function RemoveWeapon(weapon)
    local playerPed = GetPlayerPed(-1)
    local weapon = GetHashKey(weapon) -- weapon
    local newAmmo = GetAmmoInPedWeapon(playerPed, weapon) -- newAmmo
    TriggerServerEvent('WeaponItem:updateAmmoCount', weapon, newAmmo)
    RemoveWeaponFromPed(playerPed, weapon)
    RemoveAllPedWeapons(playerPed, true)
end

function GiveWeapon(weapon)
    local checkh = Shared.Throwables
    local playerPed = GetPlayerPed(-1)
    local hash = GetHashKey(weapon)
    ESX.TriggerServerCallback('WeaponItem:getAmmoCount', function(ammoCount)
        GiveWeaponToPed(playerPed, hash, 1, false, true)
        if checkh[weapon] == hash then
            SetPedAmmo(playerPed, hash, 1)
        elseif Shared.FuelCan == hash and ammoCount == nil then
            SetPedAmmo(playerPed, hash, 1000)
        else
            SetPedAmmo(playerPed, hash, ammoCount or 0)
        end
    end, hash)
end

---- Ammo ----

RegisterNetEvent('UseAmmo')
AddEventHandler('UseAmmo', function(ammo)
    local playerPed = GetPlayerPed(-1)
    local weapon

    local found, currentWeapon = GetCurrentPedWeapon(playerPed, true)
    if found then
        for _, v in pairs(ammo.weapons) do
            if currentWeapon == v then
                weapon = v
                break
            end
        end
        if weapon ~= nil then
            local pedAmmo = GetAmmoInPedWeapon(playerPed, weapon)
            local newAmmo = pedAmmo + ammo.count
            ClearPedTasks(playerPed)
            local found, maxAmmo = GetMaxAmmo(playerPed, weapon)
            if newAmmo < 40 then
                TriggerServerEvent('WeaponItem:updateAmmoCount', weapon, newAmmo)
                SetPedAmmo(playerPed, weapon, newAmmo)
                TriggerServerEvent('RemoveAmmo', ammo)
                ESX.ShowNotification("Vous avez recharcher votre ~g~Armes.")
            else
                ESX.ShowNotification("Le chargeur de votre ~g~arme~s~ est déjà plein.")
            end
        end
    end
end)

------------- Recule -------------

local weapons = {
	'WEAPON_PISTOL',
    'WEAPON_APPISTOL',
    'WEAPON_PISTOL50',
    'WEAPON_REVOLVER',
    'WEAPON_SNSPISTOL',
    'WEAPON_HEAVYPISTOL',
    'WEAPON_VINTAGEPISTOL',
    'WEAPON_DOUBLEACTION',
    'WEAPON_COMBATPISTOL',
}

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if DoesEntityExist( GetPlayerPed(-1) ) and not IsEntityDead( GetPlayerPed(-1) ) and not IsPedInAnyVehicle(PlayerPedId(-1), true) then
			if currWeapon ~= GetSelectedPedWeapon(GetPlayerPed(-1)) then
				pos = GetEntityCoords(GetPlayerPed(-1), true)
				rot = GetEntityHeading(GetPlayerPed(-1))

				local newWeap = GetSelectedPedWeapon(GetPlayerPed(-1))
				SetCurrentPedWeapon(GetPlayerPed(-1), currWeapon, true)
				loadAnimDict( "reaction@intimidation@1h" )

				if CheckWeapon(newWeap) then
					if newWeap ~= currWeapon then
                        canfire = true
                        print('true')
						SetCurrentPedWeapon(GetPlayerPed(-1), GetHashKey('WEAPON_UNARMED'), true)
						TaskPlayAnimAdvanced(GetPlayerPed(-1), "reaction@intimidation@1h", "intro", GetEntityCoords(GetPlayerPed(-1), true), 0, 0, rot, 8.0, 3.0, -1, 50, 0, 0, 0)
						Citizen.Wait(285)
						SetCurrentPedWeapon(GetPlayerPed(-1), newWeap, true)
						currWeapon = newWeap
						Citizen.Wait(2000)
						ClearPedTasks(GetPlayerPed(-1))
                        canfire = false
                        print('false')
					end
				else
					if CheckWeapon(currWeapon) then
						SetCurrentPedWeapon(GetPlayerPed(-1), GetHashKey('WEAPON_UNARMED'), true)
						SetCurrentPedWeapon(GetPlayerPed(-1), newWeap, true)
						currWeapon = newWeap
					else
						SetCurrentPedWeapon(GetPlayerPed(-1), newWeap, true)
						currWeapon = newWeap
					end
				end
			end
		end
	end
end)

function CheckWeapon(newWeap)
	for i = 1, #weapons do
		if GetHashKey(weapons[i]) == newWeap then
			return true
		end
	end
	return false
end

function loadAnimDict(dict)
	while (not HasAnimDictLoaded(dict)) do
		RequestAnimDict(dict)
		Citizen.Wait(5)
	end
end