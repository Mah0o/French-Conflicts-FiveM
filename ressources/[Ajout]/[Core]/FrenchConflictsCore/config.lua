Config = {}
ConfigFuel = {}
ConfigRichPresence = {}
ConfigME = {}

Config.changertemps = { 'steam:1100001335da201' }
Config.dynamicWeather = true -- true ou false
Config.webhook = { onAll = "https://discord.com/api/webhooks/1001873657175482448/Et6L7DuVI1_jl8sbrWlK6SaNEU98jEjp-RJ2unbGq9rY_m5GnSbd095y-IKRbFqH9hIf" }
Config.vitessemaxchangerplace = 30

Config.PList = {
    { PropsHASH = "prop_vintage_pump", x = 4933.81, y = -5197.17, z = 2.44-1, r = 252.782, f = false, inv = false}, --(f = pour fixer vos accessoires sur les coordonnées / inv = invicibilité)
}

--- Commande /me ---
ConfigME = {
	color = { r = 230, g = 230, b = 230, a = 255 }, -- Text color
    font = 0, -- Police du texte
    time = 5000, -- Durée d'affichage du texte (en ms)
    scale = 0.5, -- Échelle du texte
    dist = 250, -- Min. distance affichage
}

--- skRichPresence ---
ConfigRichPresence.ClientID = 985611008221511690
ConfigRichPresence.RessourceTimer = 30 -- Actualisation en seconde
ConfigRichPresence.image = "https://zupimages.net/up/22/32/a384.png"
ConfigRichPresence.Buttons = {
    {index = 0, name = "DISCORD", url = "https://discord.gg/9qVuYQtqMr"}
    --{index = 1, name = "CONNECT", url = "fivem://connect/0.0.0.0:00000" },
    --{index = 2, name = "SITE", url = "https://www.frenchconflicts.fr" },
}

--- LegacyFuel ---
ConfigFuel.JerryCanCost = 100 --Quel devrait être le prix des jerricans ?
ConfigFuel.RefillCost = 50 --S'il manque la moitié de sa capacité, ce montant sera divisé par deux, et ainsi de suite.

--Décor de carburant - Pas besoin de changer cela, laissez-le simplement.
ConfigFuel.FuelDecor = "_FUEL_LEVEL"

--Quelles touches sont désactivées pendant que vous faites le plein.
ConfigFuel.DisableKeys = {0, 22, 23, 24, 29, 30, 31, 37, 44, 56, 82, 140, 166, 167, 168, 170, 288, 289, 311, 323}

ConfigFuel.EnableHUD = true --Vous voulez utiliser le HUD ? Transformez cela en true.
ConfigFuel.RemoveHUDForBlacklistedVehicle = true --Voulez-vous que le HUD ne s'affiche plus dans les véhicules blacklist ?

--Configurez les blips ici. Réglez les deux sur false pour désactiver les blips tous ensemble.
ConfigFuel.ShowNearestGasStationOnly = true
ConfigFuel.ShowAllGasStations = false

--Modifiez le coût du carburant ici, en utilisant une valeur multiplicatrice. Définir la valeur sur 2,0 entraînerait une augmentation doublée.
ConfigFuel.CostMultiplier = 1.0

--Configurez les chaînes comme vous le souhaitez ici.
ConfigFuel.Strings = {
	ExitVehicle = "Sortir du véhicule pour faire le plein",
	EToRefuel = "Appui sur ~g~E ~w~pour faire le plein de véhicule",
	JerryCanEmpty = "Le jerrican est vide",
	FullTank = "Réservoir est plein",
	PurchaseJerryCan = "Appui sur ~g~E ~w~pour acheter un jerrycan pour ~g~$" .. ConfigFuel.JerryCanCost,
	CancelFuelingPump = "Appui sur ~g~E ~w~pour annuler le ravitaillement",
	CancelFuelingJerryCan = "Appui sur ~g~E ~w~pour annuler le ravitaillement",
	NotEnoughCash = "Pas assez d'argent",
	RefillJerryCan = "Appui sur ~g~E ~w~pour remplir le jerrican pour ",
	NotEnoughCashJerryCan = "Pas assez d'argent pour remplir le jerrycan",
	JerryCanFull = "Le jerrican est plein",
	TotalCost = "Prix",
}

ConfigFuel.PumpModels = {
	[-2007231801] = true,
	[1339433404] = true,
	[1694452750] = true,
	[1933174915] = true,
	[-462817101] = true,
	[-469694731] = true,
	[-164877493] = true
}

--Blacklist certains véhicules. Utilisez des noms ou des hachages. https://wiki.gtanet.work/index.php?title=Vehicle_Models
ConfigFuel.Blacklist = {
	--"Adder",
	--276773164
}

--Multiplicateurs de classe. Si vous voulez que les SUV consomment moins de carburant, vous pouvez le changer en n'importe quoi en dessous de 1.0, et vice versa.
ConfigFuel.Classes = {
	[0] = 1.0, -- Compacts
	[1] = 1.0, -- Sedans
	[2] = 1.0, -- SUVs
	[3] = 1.0, -- Coupes
	[4] = 1.0, -- Muscle
	[5] = 1.0, -- Sports Classics
	[6] = 1.0, -- Sports
	[7] = 1.0, -- Super
	[8] = 1.0, -- Motorcycles
	[9] = 1.0, -- Off-road
	[10] = 1.0, -- Industrial
	[11] = 1.0, -- Utility
	[12] = 1.0, -- Vans
	[13] = 0.0, -- Cycles
	[14] = 1.0, -- Boats
	[15] = 1.0, -- Helicopters
	[16] = 1.0, -- Planes
	[17] = 1.0, -- Service
	[18] = 1.0, -- Emergency
	[19] = 1.0, -- Military
	[20] = 1.0, -- Commercial
	[21] = 1.0, -- Trains
}

--La partie gauche est au pourcentage RPM, et la droite est la quantité de carburant (divisée par 10) que vous souhaitez retirer du réservoir chaque seconde
ConfigFuel.FuelUsage = {
	[1.0] = 1.4,
	[0.9] = 1.2,
	[0.8] = 1.0,
	[0.7] = 0.9,
	[0.6] = 0.8,
	[0.5] = 0.7,
	[0.4] = 0.5,
	[0.3] = 0.4,
	[0.2] = 0.2,
	[0.1] = 0.1,
	[0.0] = 0.0,
}

ConfigFuel.GasStations = {
	vector3(4424.5795898438, -4474.3037109375, 4.3282732963562), 
	vector3(4422.2495117188, -4469.5493164063, 4.3282732963562),
	vector3(5142.484375, -4632.6357421875, 2.6981236934662),
	vector3(5134.349609375, -4630.705078125, 2.6981236934662),
}
