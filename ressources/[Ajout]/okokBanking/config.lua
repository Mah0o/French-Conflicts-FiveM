Config = {}

Config.okokTextUI = true -- true = okokTextUI (I recommend you using this since it is way more optimized than the default ShowHelpNotification) | false = ShowHelpNotification

Config.IBANPrefix = "CAYO" -- the prefix of the IBAN

Config.IBANNumbers = 6 -- How many characters the IBAN has by default

Config.CustomIBANMaxChars = 10 -- How many characters the IBAN can have when changing it to a custom one (on Settings tab)

Config.CustomIBANAllowLetters = true -- If the custom IBAN can have letters or only numbers (on Settings tab)

Config.IBANChangeCost = 400 -- How much it costs to change the IBAN to a custom one (on Settings tab)

Config.PINChangeCost = 200 -- How much it costs to change the PIN (on Settings tab)

Config.AnimTime = 2 * 1000 -- 2 * 1000 = 2 seconds (ATM animation)

Config.Societies = { -- Which societies have bank accounts
	"police",
	"ambulance",
}

Config.SocietyAccessRanks = { -- Which ranks of the society have access to it
	"boss",
	"chief",
}

Config.ShowBankBlips = true -- true = show bank blips on the map | false = don't show blips
--vector4(-1040.354, -2846.866, 27.72107, 100.2394)
Config.BankLocations = { -- to get blips and colors check this: https://wiki.gtanet.work/index.php?title=Blips
	{blip = 108, blipColor = 2, blipScale = 0.5, x = 4477.400390625, y = -4464.0244140625, z = 4.2424392700195, blipText = "Service | Banque", BankDistance = 3},
}

Config.ATMDistance = 1.5 -- How close you need to be in order to access the ATM

Config.ATM = { -- ATM models, do not remove any
	{model = -870868698}, 
	{model = -1126237515}, 
	{model = -1364697528}, 
	{model = 506770882}
}