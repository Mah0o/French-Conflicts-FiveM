local IsOnIsland = false
function KeyboardInput(TextEntry, ExampleText, MaxStringLenght)

	AddTextEntry('FMMC_KEY_TIP1', TextEntry)
	DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLenght)
	blockinput = true

	while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
		Citizen.Wait(0)
	end
		
	if UpdateOnscreenKeyboard() ~= 2 then
		local result = GetOnscreenKeyboardResult()
		Citizen.Wait(500)
		blockinput = false --This unblocks new Input when typing is done
		return result --Returns the result
	else
		Citizen.Wait(500) --Little Time Delay, so the Keyboard won't open again if you press enter to finish the typing
		blockinput = false --This unblocks new Input when typing is done
		return nil --Returns nil if the typing got aborted
	end
end

function PlayAnim(animDict, animName, duration)
    RequestAnimDict(animDict)
    while not HasAnimDictLoaded(animDict) do Wait(0) end
    TaskPlayAnim(PlayerPedId(), animDict, animName, 1.0, -1.0, duration, 1, 1, false, false, false)
    RemoveAnimDict(animDict)
end


function LoadCutscene(cut, flag1, flag2)
    if (not flag1) then
      RequestCutscene(cut, 8)
    else
      RequestCutsceneEx(cut, flag1, flag2)
    end
    while (not HasThisCutsceneLoaded(cut)) do Wait(0) end
    return
  end
  
  local function BeginCutsceneWithPlayer()
    local plyrId = PlayerPedId()
    local playerClone = ClonePed_2(plyrId, 0.0, false, true, 1)
  
    SetBlockingOfNonTemporaryEvents(playerClone, true)
    SetEntityVisible(playerClone, false, false)
    SetEntityInvincible(playerClone, true)
    SetEntityCollision(playerClone, false, false)
    FreezeEntityPosition(playerClone, true)
    SetPedHelmet(playerClone, false)
    RemovePedHelmet(playerClone, true)
  
    SetCutsceneEntityStreamingFlags('MP_1', 0, 1)
    RegisterEntityForCutscene(plyrId, 'MP_1', 0, GetEntityModel(plyrId), 64)
  
    Wait(10)
    StartCutscene(0)
    Wait(10)
    ClonePedToTarget(playerClone, plyrId)
    Wait(10)
    DeleteEntity(playerClone)
    Wait(50)
    DoScreenFadeIn(250)
  
    return playerClone
  end
  
  local function Finish(timer)
    local tripped = false
  
    repeat
      Wait(0)
      if (timer and (GetCutsceneTime() > timer))then
        DoScreenFadeOut(250)
        tripped = true
      end
  
      if (GetCutsceneTotalDuration() - GetCutsceneTime() <= 250) then
        DoScreenFadeOut(250)
        tripped = true
      end
    until not IsCutscenePlaying()
    if (not tripped) then
      DoScreenFadeOut(100)
      Wait(150)
    end
    return
  end
  
  local landAnim = {1, 2, 4}
  local timings = {
    [1] = 9100,
    [2] = 17500,
    [4] = 25400
  }
  
  function bateau(isIsland)
    if (isIsland) then
      RequestCollisionAtCoord(-2392.838, -2427.619, 43.1663)
  
      LoadCutscene('hs4_nimb_isd_lsa', 8, 24)
      BeginCutsceneWithPlayer()
      Finish()
      RemoveCutscene()
    else
      RequestCollisionAtCoord(-1652.79, -3117.5, 13.98)
  
      LoadCutscene('hs4_lsa_take_nimb2')
      BeginCutsceneWithPlayer()
  
      Finish()
      RemoveCutscene()
  
      if (Config.Cutscenes.long) then
        LoadCutscene('hs4_nimb_lsa_isd', 128, 24)
        BeginCutsceneWithPlayer()
        Finish(165000)
  
        LoadCutscene('hs4_nimb_lsa_isd', 256, 24)
        BeginCutsceneWithPlayer()
        Finish(170000)
  
        LoadCutscene('hs4_nimb_lsa_isd', 512, 24)
        BeginCutsceneWithPlayer()
        Finish(175200)
        RemoveCutscene()
    if (isIsland) then
            RequestCollisionAtCoord(-1652.79, -3117.5, 13.98)

            local function GetToCoordinate(location)
              local coordinate = location.IslandCoordinate
              local heading = location.IslandHeading
            
              if IsOnIsland then
                coordinate = location.LosSantosCoordinate
                heading = location.LosSantosHeading
              end
            
              return coordinate, heading
            end

            local function GetClosestLocation()
              local closestLocation = Config.TeleportLocations[1]
              local closestLocationCoords = GetFromCoordinate(closestLocation)
            
              for index, location in pairs(Config.TeleportLocations) do
                local startCoordinate = GetFromCoordinate(location)
            
                local distance = #(PedCoordinates - startCoordinate)
                local currentClosestDistance = #(PedCoordinates - closestLocationCoords)
            
                if distance < currentClosestDistance then
                  closestLocation = location
                  closestLocationCoords = startCoordinate
                end
              end
            
              ClosestTeleportLocation = closestLocation
            
              local dist = #(PedCoordinates - closestLocationCoords)
              if #(PedCoordinates - closestLocationCoords) < Config.DrawDistance then
                IsInSideTeleportLocation = true
              end
            end

            local flag = landAnim[ math.random( #landAnim ) ]
            local endCoordinate, endHeading = GetToCoordinate(ClosestTeleportLocation)
            LoadCutscene('hs4_lsa_land_nimb', flag, 24)
            BeginCutsceneWithPlayer()
            Finish(timings[flag])
            RemoveCutscene()
          else
            LoadCutscene('hs4_nimb_lsa_isd_repeat')
        
            RequestCollisionAtCoord(-2392.838, -2427.619, 43.1663)
            BeginCutsceneWithPlayer()
        
            Finish()
            RemoveCutscene()

            Wait(10)
            RemoveCutscene()
            StartPlayerTeleport(PlayerId(), 4063.6462402344,-4683.41796875,4.1839985847473, 18.45398902893066, true, true, false)
            print('Debug Maho')
            if IsScreenFadedOut() then
              DoScreenFadeIn(500)
            end
            while true do
              PedCoordinates = GetEntityCoords(PlayerPedId(), true)
              Wait(500)
            end
          end
      end
    end
  end


  Citizen.CreateThread(
  function()
    if IsScreenFadedOut() then
      DoScreenFadeIn(500)
    end
    while true do
      PedCoordinates = GetEntityCoords(PlayerPedId(), true)
      Wait(500)
    end
  end
)
  
 -- function BeginLanding(isIsland)
  --  if (isIsland) then
   --   RequestCollisionAtCoord(-1652.79, -3117.5, 13.98)
     -- local flag = landAnim[ math.random( #landAnim ) ]
    --  LoadCutscene('hs4_lsa_land_nimb', flag, 24)
    --  BeginCutsceneWithPlayer()
     -- Finish(timings[flag])
     -- RemoveCutscene()
   -- else
    --  LoadCutscene('hs4_nimb_lsa_isd_repeat')
  --
    --  RequestCollisionAtCoord(-2392.838, -2427.619, 43.1663)
    --  BeginCutsceneWithPlayer()
  -- Finish()
    --  RemoveCutscene()
  --  end
  --end-