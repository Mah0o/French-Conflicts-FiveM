---- DESACTIVER LE CHANGEMENT DE PLACE AUTO ----
function PlaceAuto()
	if GetPedInVehicleSeat(GetVehiclePedIsIn(GetPlayerPed(-1), false), 0) == GetPlayerPed(-1) then
		if GetIsTaskActive(GetPlayerPed(-1), 165) then
			SetPedIntoVehicle(GetPlayerPed(-1), GetVehiclePedIsIn(GetPlayerPed(-1), false), 0)
		end
	end
end
------------------------------------------------


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        SetVehicleDensityMultiplierThisFrame(0)
        SetPedDensityMultiplierThisFrame(0)
        SetRandomVehicleDensityMultiplierThisFrame(0)
        SetParkedVehicleDensityMultiplierThisFrame(0)
        SetScenarioPedDensityMultiplierThisFrame(0, 0)
    end
end)


--Citizen.CreateThread(function()
  --  while true do
    --    Citizen.Wait(1)
	--	LOCK_MINIMAP_POSITION(4516.490234375,-4052.4421386719);
  --  end
--end)
---------------------------------

---- SACCROUPIRE ----
local crouched = false
Citizen.CreateThread( function()
    while true do 
        Citizen.Wait(20)
        local ped = GetPlayerPed(-1)
        if (DoesEntityExist(ped) and not IsEntityDead(ped)) then 
            DisableControlAction(0, 36, true) -- INPUT_DUCK  
            if (not IsPauseMenuActive()) then 
                if (IsDisabledControlJustPressed(0, 36)) then 
                    RequestAnimSet("move_ped_crouched")

                    while (not HasAnimSetLoaded("move_ped_crouched")) do 
                        Citizen.Wait(100)
                    end 

                    if (crouched == true) then 
                        ResetPedMovementClipset(ped, 0)
                        crouched = false 
                    elseif (crouched == false) then
                        SetPedMovementClipset(ped, "move_ped_crouched", 0.25)
                        crouched = true 
                    end 
                end
            end 
        end 
    end
end)
---------------------