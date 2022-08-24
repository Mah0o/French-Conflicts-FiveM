DrugsHandler = {}
DrugsHandler.Utilities = {}
DrugsHandler.Users = {}
DrugsHandler.Infos = {}
DrugsHandler.LaboData = {}
DrugsHandler.MenuIsOpen = false 
DrugsHandler.CurrentLabo = nil 
DrugsHandler.WaitingFor = false 

DrugsHandler.Settings = { 
    PedSellHash = "s_m_m_bouncer_01", 
    PedSellPosition = { -- 
        {pos = vector3(4725.83, -5724.56, 13.90-1), heading = 141.25},  -- Lieux pour l'achat d'un labo 
    },
    PedDrugSellActivate = true, -- Aficher les Peds pour la revente 
    PedDrugSellHash = "g_m_y_mexgoon_02", 
    PedDrugSellPosition = { 
        ["Weed"] = {
            {pos = vector3(5586.50, -5223.36, 14.35-1), heading = 316.72}, --Vente Weed
        },
        ["Cocaïne"] = {
            {pos = vector3(5213.72, -5227.15, 17.52-1), heading = 38.786}, --Vente Cocaine
        },
        ["Meth"] = {
            {pos = vector3(5423.954, -5241.418, 35.47-1), heading = 55.446}, --Vente Meth
        }
    }
}

DrugsHandler.Builds = { -- Liste des différents laboratoires ( Meth / Weed / Coke )
    ["Meth"] = {  
        Preview = "meth_labo",
        Labo = { -- Liste des laboratoires disponibles  
            {
                Index = 1, 
                Price = 400000, 
                Entering = vector3(5265.30, -5418.85, 65.60) --Labo Meth
            }
        }
    },
    ["Weed"] = {  
        Preview = "weed_labo",
        Labo = {
            {
                Index = 1, 
                Price = 300000,
                Entering = vector3(5108.225, -4700.944, 3.578)  --Labo Weed
            }
        }
    },
    ["Cocaïne"] = { 
        Preview = "coke_labo", 
        Labo = {
            {
                Index = 1, 
                Price = 500000,
                Entering = vector3(5599.80, -5666.08, 11.44)    --Labo Cocaine
            }
        }
    }
}

DrugsHandler.Interiors = { -- Ne pas toucher / Don't touch
    ["Meth"] = {
        Position = {
            pos = vector3(997.54, -3200.58, -36.393), 
            heading = 274.55
        },
        Harvest = {
            {pos = vector3(1005.80, -3200.40, -38.90)},
        },
        Treatment = vector3(1011.80, -3194.90, -38.99),
        Computer = vector3(1001.97, -3195.11, -38.99)
    },
    ["Weed"] = {
        Position = {
            pos = vector3(1065.97, -3183.45, -39.16), 
            heading = 95.18
        },
        Harvest = {
            {pos = vector3(1051.658, -3196.057, -39.12837)},
            {pos = vector3(1051.605, -3190.533, -39.13086)},
            {pos = vector3(1056.194, -3189.949, -39.10868)},
            {pos = vector3(1062.883, -3193.293, -39.12915)},
            {pos = vector3(1063.073, -3198.179, -39.11026)},
            {pos = vector3(1063.658, -3204.737, -39.1482)},
            {pos = vector3(1057.423, -3205.962, -39.12839)},
            {pos = vector3(1057.647, -3199.784, -39.10919)},
            {pos = vector3(1051.781, -3205.776, -39.13504)}
        },
        Treatment = vector3(1039.759, -3204.596, -38.15),
        Computer = vector3(1044.22, -3194.85, -38.15)
    },
    ["Cocaïne"] = {
        Position = {
            pos = vector3(1088.67, -3187.83, -38.99), 
            heading = 180.90
        },
        Harvest = {
            {pos = vector3(1090.54, -3196.65, -38.99)},
            {pos = vector3(1093.09, -3196.59, -38.99)},
            {pos = vector3(1095.34, -3196.65, -38.99)},
            {pos = vector3(1099.62, -3194.41, -38.99)},
            {pos = vector3(1101.75, -3193.77, -38.99)}
        },
        Treatment = vector3(1101.245, -3198.82, -39.60),
        Computer = vector3(1087.40, -3194.17, -38.99)
    }
}

DrugsHandler.Items = {
    ["Meth"] = {
        harvest = 40, -- Ajoute 5 de meth dans l'inventaire du joueur a chaque récolte.
        treatment = {20, 4}, -- [1] = 1ère valeur soit le nombre d'item(s) enlevé(s) au traitement, [2] = 2ème valeur soit le nombre d'item(s) ajouté(s) au joueur au traitement.
        resellPrice = 120
    },  
    ["Weed"] = {
        harvest = 5,
        treatment = {5, 1},
        resellPrice = 240
    },
    ["Cocaïne"] = {
        harvest = 5,
        treatment = {5, 1},
        resellPrice = 170
    }
}

DrugsHandler.Upgrades = { 
    ["Meth"] = {
        ["interior"] = {
            {name = "Basique", value = "basic", price = 200000, desc = "Ajoutez une touche de modernité dans votre laboratoire."},
            {name = "Avancé", value = "upgrade", price = 600000, desc = "Ajoutez une touche de modernité dans votre laboratoire, tout en étant équipé."}
        }
    },  
    ["Weed"] = {
        ["interior"] = {
            {name = "Avancé", value = "upgrade", price = 450000, desc = "Ajoutez une touche de modernité dans votre laboratoire, tout en étant équipé."}
        },
        ["details"] = {
            {name = "Chaise", value = "weed_chairs", price = 100000, desc = "Ajoutez des chaises, pour pouvoir traiter votre récolte comme il se doit."}
        }
    },
    ["Cocaïne"] = {
        ["interior"] = {
            {name = "Avancé", value = "upgrade", price = 750000, desc = "Ajoutez une touche de modernité dans votre laboratoire, tout en étant équipé."}
        }
    }
}

DrugsHandler.Supplies = { 
    ["Meth"] = {
        {name = "Matières premières", price = 20000, desc = "Ce lot contient différents éléments permettant la production de meth.\nDe la méthylamine, de l'acide sulfurique, de l'acétone, et du lithium."}
    },  
    ["Weed"] = {
        {name = "Matières premières", price = 15000, desc = "Ce lot contient différents éléments permettant la production de weed sur un terrain.\nDe l'eau minérale (6.4PH), des graines de weeds, ainsi que de la terre fertile."}
    },
    ["Cocaïne"] = {
        {name = "Matières premières", price = 25000, desc = "Ce lot contient différents éléments permettant la production de cocaïne.\nDes feuilles de coca, du kérosène, paracétamol, glucoses."}
    }
}