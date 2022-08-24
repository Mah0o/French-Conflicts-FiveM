Config = {}

Config.Key = 38 -- [E] Key to open the interaction, check here the keys ID: https://docs.fivem.net/docs/game-references/controls/#controls

Config.AutoCamPosition = true -- If true it'll set the camera position automatically

Config.AutoCamRotation = true -- If true it'll set the camera rotation automatically

Config.HideMinimap = true -- If true it'll hide the minimap when interacting with an NPC

Config.UseOkokTextUI = true -- If true it'll use okokTextUI 

Config.CameraAnimationTime = 1000 -- Camera animation time: 1000 = 1 second

Config.TalkToNPC = {
	{
		npc = 'ig_priest', 										-- Website too see peds name: https://wiki.rage.mp/index.php?title=Peds
		header = "l'Homme pleureur", 								-- Text over the name
		name = 'John', 										-- Text under the header
		uiText = "l'homme déchu",							-- Name shown on the notification when near the NPC
		dialog = 'Salut ... ça va ?',						-- Text showm on the message bubble 
		coordinates = vector3(4765.1801757813, -4557.0141601563, 24.7), 				-- coordinates of NPC
		heading = 160.0,											-- Heading of NPC (needs decimals, 0.0 for example)
		camOffset = vector3(0.0, 0.0, 0.0), 						-- Camera position relative to NPC 	| (only works if Config.AutoCamPosition = false)
		camRotation = vector3(0.0, 0.0, 0.0),						-- Camera rotation 					| (only works if Config.AutoCamRotation = false)
		interactionRange = 2.5, 									-- From how far the player can interact with the NPC
		options = {													-- Options shown when interacting (Maximum 6 options per NPC)
			{'Salut, ça va ?', 'okokTalk:toilet', 'c'},		-- 'c' for client
			{'Que fais tu ici?', 'okokTalk:rob', 'c'},		-- 's' for server (if you write something else it'll be server by default)
			{"Depuis quand habite tu ici ?", 'okokTalk:safe', 'c'}, 
			{"Tu as besoin de quelque chose ?", 'okokTalk:card', 'c'}, 
		},
		jobs = {													-- Jobs that can interact with the NPC
			
		},
	},
	{
		npc = 's_m_y_marine_03', 										-- Website too see peds name: https://wiki.rage.mp/index.php?title=Peds
		header = "Militaire Français", 								-- Text over the name
		name = 'Stéphane', 										-- Text under the header
		uiText = "Militaire Français",							-- Name shown on the notification when near the NPC
		dialog = "Casse toi vite d'ici, les talibans trainent dans le coin...",						-- Text showm on the message bubble 
		coordinates = vector3(4074.203125, -4670.6572265625, 3.3180766105652), 				-- coordinates of NPC
		heading = 131.19973754882812,											-- Heading of NPC (needs decimals, 0.0 for example)
		camOffset = vector3(0.0, 0.0, 0.0), 						-- Camera position relative to NPC 	| (only works if Config.AutoCamPosition = false)
		camRotation = vector3(0.0, 0.0, 0.0),						-- Camera rotation 					| (only works if Config.AutoCamRotation = false)
		interactionRange = 2.5, 									-- From how far the player can interact with the NPC
		options = {													-- Options shown when interacting (Maximum 6 options per NPC)
			{'Ça va ?', 'okokTalk:a', 'c'},		-- 'c' for client
			{"Qu'attend tu ?", 'okokTalk:b', 'c'},		-- 's' for server (if you write something else it'll be server by default)
			{"Où puis-je trouver à manger ?", 'okokTalk:c', 'c'}, 
			{"Où puis-je trouver des affaires de rechange ?", 'okokTalk:d', 'c'}, 
		},
		jobs = {													-- Jobs that can interact with the NPC
			
		},
	},
	--[[
	-- This is the template to create new NPCs
	{
		npc = "",
		header = "",
		name = "",
		uiText = "",
		dialog = "",
		coordinates = vector3(0.0, 0.0, 0.0),
		heading = 0.0,
		camOffset = vector3(0.0, 0.0, 0.0),
		camRotation = vector3(0.0, 0.0, 0.0),
		interactionRange = 0,
		options = {
			{"", 'client:event', 'c'},
			{"", 'client:event', 'c'},
			{"", 'client:event', 'c'}, 
			{"", 'server:event', 's'}, 
			{"", 'server:event', 's'}, 
			{"", 'server:event', 's'}, 
		},
		jobs = {	-- Example jobs
			'police',
			'ambulance',
		},
	},
	]]--
}