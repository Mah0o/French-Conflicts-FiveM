CreateThread(function()
	local DeathReason, Killer, DeathCauseHash
	while true do
		Wait(500)
		if IsEntityDead(PlayerPedId()) then
			local PedKiller = GetPedSourceOfDeath(PlayerPedId())
			local killername = GetPlayerName(PedKiller)
			DeathCauseHash = GetPedCauseOfDeath(PlayerPedId())
			if IsEntityAPed(PedKiller) and IsPedAPlayer(PedKiller) then
				Killer = NetworkGetPlayerIndexFromPed(PedKiller)
			elseif IsEntityAVehicle(PedKiller) and IsEntityAPed(GetPedInVehicleSeat(PedKiller, -1)) and IsPedAPlayer(GetPedInVehicleSeat(PedKiller, -1)) then
				Killer = NetworkGetPlayerIndexFromPed(GetPedInVehicleSeat(PedKiller, -1))
			end
			if (Killer == PlayerId()) then
				DeathReason = "s'est suicidé"
			elseif (Killer == nil) then
				DeathReason = "est mort"
			else
				DeathReason = "tué"
			end

			if DeathReason == "s'est suicidé" or DeathReason == "est mort" then
				TriggerServerEvent('sk:playerDied', { type = 1, player_id = GetPlayerServerId(PlayerId()), death_reason = DeathReason})
			else
				TriggerServerEvent('sk:playerDied', { type = 2, player_id = GetPlayerServerId(PlayerId()), player_2_id = GetPlayerServerId(Killer), death_reason = DeathReason})
			end
			Killer = nil
			DeathReason = nil
			DeathCauseHash = nil
		end
		while IsEntityDead(PlayerPedId()) do
			Wait(1000)
		end
	end
end)