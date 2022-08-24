Shared = {}

Shared.prefix = "skafir:"
Shared.esxGet = "esx:getSharedObject"

Shared.header = {
    ["Lunettes"] = "Lunettes",
    ["Masque"] = "Masque",
    ["Chapeau"] = "Chapeau",
    ["Sac"] = "Sac",
    ["Oreille"] = "Accessoires d'oreille",
    ["T-shirt"] = "T-shirt",
    ["Pantalon"] = "Pantalon",
    ["Chaussures"] = "Chaussures",
    ["Torse"] = "Torse",
    ["Gants"] = "Gants",
    ["Bracelet"] = "Bracelet",
    ["Montres"] = "Montres",
    ["Calques"] = "Calques",
    ["Chaines"] = "Chaines",
    ["Main"] = "Magasin"
}

Shared.price = {
    ["Lunettes"] = 15, -- [$]
    ["Masque"] = 30, -- [$]
    ["Chapeau"] = 20, -- [$]
    ["Sac"] = 25,  -- [$]
    ["Oreille"] = 10, -- [$]
    ["T-shirt"] = 15, -- [$]
    ["Pantalon"] = 20, -- [$]
    ["Chaussures"] = 25, -- [$]
    ["Torse"] = 20, -- [$]
    ["Montres"] = 55, -- [$]
    ["Bracelet"] = 20, -- [$]
    ["Gants"] = 5, -- [$]
    ["Calques"] = 2, -- [$]
    ["Chaines"] = 10 -- [$]
}

Shared.shops = {
    {pos = vector3(4495.861328125, -4453.6787109375, 3.3664608001709), shop = "Main", color = {r = 200, g= 118, b = 51}},

    {pos = vector3(4499.6845703125, -4452.9389648438, 3.3675770759583), shop = "Bracelet"},
    {pos = vector3(4500.40234375, -4454.9111328125, 3.3664608001709), shop = "Montres"},
    {pos = vector3(4500.8715820313, -4456.5708007813, 3.3664612770081), shop = "Chaines"},

    {pos = vector3(4497.7456054688, -4458.84765625, 3.3664603233337), shop = "Sac"},

    {pos = vector3(4491.8715820313, -4458.2700195313, 3.3673367500305), shop = "Gants"},


    {pos = vector3(4487.5576171875, -4451.6044921875, 3.3679494857788), shop = "Calques"},

    {pos = vector3(4590.8637695313, -4449.3056640625, 4.3723673439026), shop = "Masque"},  

    {pos = vector3(4490.9638671875, -4462.1884765625, 3.3710317611694), shop = "Lunettes"},

    {pos = vector3(4488.5434570313, -4454.3354492188, 3.3664622306824), shop = "Chapeau"},

    {pos = vector3(4496.4931640625, -4459.3662109375, 3.3664608001709), shop = "Oreille"},
    {pos = vector3(4495.111328125, -4457.9956054688, 3.3664617538452), shop = "T-shirt"},
    {pos = vector3(4492.0927734375, -4460.1459960938, 3.3664584159851), shop = "Pantalon"},
    {pos = vector3(4494.7211914063, -4460.3979492188, 3.3664522171021), shop = "Chaussures"},
    {pos = vector3(4493.623046875, -4456.5380859375, 3.3746027946472), shop = "Torse"},

}

Shared.info = {
    ["Sac"] = {nom1 = "bags_1", nom2 = "bags_2", nom3 = "ssac", var = 5, slidemax = "Texture"},
    ["Masque"] = {nom1 = "mask_1", nom2 = "mask_2", nom3 = "smasque", var = 1, slidemax = "Texture"},
    ["Torse"] = {nom1 = "torso_1", nom2 = "torso_2", nom3 = "storse", var = 11, slidemax = "Texture"}, 
    ["T-shirt"] = {nom1 = "tshirt_1", nom2 = "tshirt_2", nom3 = "stshirt", var = 8, slidemax = "Texture"},
    ["Pantalon"] = {nom1 = "pants_1", nom2 = "pants_2", nom3 = "spantalon", var = 4, slidemax = "Texture"},
    ["Chaussures"] = {nom1 = "shoes_1", nom2 = "shoes_2", nom3 = "schaussures", var = 6, slidemax = "Texture"}, 
    ["Calques"] = {nom1 = "decals_1", nom2 = "decals_2", nom3 = "scalques", var = 1, slidemax = "Prop"},
    ["Gants"] = {nom1 = "arms", nom2 = "arms_2", nom3 = "sgant", var = 1, slidemax = 10},
    ["Chaines"] = {nom1 = "chain_1", nom2 = "chain_2", nom3 = "schaine", var = 1, slidemax = "Prop"},
    ["Oreille"] = {nom1 = "ears_1", nom2 = "ears_2", nom3 = "soreille", var = 1, slidemax = "Prop"},
    ["Bracelet"] = {nom1 = "bracelets_1", nom2 = "bracelets_2", nom3 = "sbracelet", var = 1, slidemax = "Prop"},
    ["Montres"] = {nom1 = "watches_1", nom2 = "watches_2", nom3 = "smontre", var = 1, slidemax = "Prop"},
    ["Chapeau"] = {nom1 = "helmet_1", nom2 = "helmet_2", nom3 = "schapeau", var = 0, slidemax = "Prop"},
    ["Lunettes"] = {nom1 = "glasses_1", nom2 = "glasses_2", nom3 = "slunettes", var = 1, slidemax = "Prop"},
}

-- Inventory

Shared.Locale = "fr"
Shared.IncludeCash = true
Shared.IncludeAccounts = true
Shared.ExcludeAccountsList = {"bank", "money"}
Shared.OpenControl = 289

---- HUD 

Shared.AlwaysShowRadar = true -- set to true if you always want the radar to show
Shared.ShowStress = true -- set to true if you want a stress indicator
Shared.ShowSpeedo = true -- set to true if you want speedometer enabled
Shared.ShowVoice = true -- set to false if you want to hide mic indicator
Shared.ShowFuel = true -- Show fuel indicator

Shared.CloseUiItems = {
    "carteidentite",
    "permis",
    "carte",
}

Shared.Blacklistitem = {
    ["gps"] = true,
    ["phone"] = true,
    ["white_phone"] = true,
    ['hei_prop_yah_table_01'] = true,
    ['hei_prop_yah_table_03'] = true,
    ['prop_chateau_table_01'] = true,
    ['prop_patio_lounger1_table'] = true,
    ['prop_proxy_chateau_table'] = true,
    ['prop_rub_table_02'] = true,
    ['prop_rub_table_01'] = true,
    ['prop_table_01'] = true,
    ['prop_table_02'] = true,
    ['prop_table_03'] = true,
    ['prop_table_04'] = true,
    ['prop_table_05'] = true,
    ['prop_table_06'] = true,
    ['prop_table_07'] = true,
    ['prop_table_08'] = true,
    ['prop_ven_market_table1'] = true,
    ['prop_yacht_table_01'] = true,
    ['prop_yacht_table_02'] = true,
    ['v_ret_fh_dinetable'] = true,
    ['v_ret_fh_dinetble'] = true,
    ['v_res_mconsoletrad'] = true,
    ['prop_rub_table_02'] = true,
    ['ba_prop_int_trad_table'] = true,
    ['xm_prop_x17_desk_cover_01a'] = true,
    ['xm_prop_lab_desk_02'] = true,
    ['xm_prop_lab_desk_01'] = true,
    ['ex_mp_h_din_table_05'] = true,
    ['hei_prop_yah_table_02'] = true,
    ['prop_ld_farm_table02'] = true,
    ['prop_t_coffe_table'] = true,
    ['prop_t_coffe_table_02'] = true,
    ['prop_ld_greenscreen_01'] = true,
    ['prop_tv_cam_02'] = true,
    ['p_pharm_unit_02'] = true,
    ['p_pharm_unit_01'] = true,
    ['p_v_43_safe_s'] = true,
    ['prop_bin_03a'] = true,
    ['prop_bin_07c'] = true,
    ['prop_bin_08open'] = true,
    ['prop_bin_10a'] = true,
    ['prop_devin_box_01'] = true,
    ['prop_ld_int_safe_01'] = true,
    ['prop_dress_disp_01'] = true,
    ['prop_dress_disp_02'] = true,
    ['prop_dress_disp_03'] = true,
    ['prop_dress_disp_04'] = true,
    ['v_ret_fh_displayc'] = true,
    ['apa_mp_h_bed_double_08'] = true,
    ['apa_mp_h_bed_double_09'] = true,
    ['apa_mp_h_bed_wide_05'] = true,
    ['imp_prop_impexp_sofabed_01a'] = true,
    ['apa_mp_h_bed_with_table_02'] = true,
    ['bka_prop_biker_campbed_01'] = true,
    ['apa_mp_h_yacht_bed_01'] = true,
    ['apa_mp_h_yacht_bed_02'] = true,
    ['p_lestersbed_s'] = true,
    ['p_mbbed_s'] = true,
    ['v_res_d_bed'] = true,
    ['v_res_tre_bed2'] = true,
    ['v_res_tre_bed1'] = true,
    ['v_res_mdbed'] = true,
    ['v_res_msonbed'] = true,
    ['v_res_tt_bed'] = true,
    ['prop_barrier_work05'] = true,
    ['prop_boxpile_07d'] = true,
    ['p_ld_stinger_s'] = true,
    ['prop_roadcone02a'] = true,
    ['hei_prop_yah_lounger'] = true,
    ['hei_prop_yah_seat_01'] = true,
    ['hei_prop_yah_seat_02'] = true,
    ['hei_prop_yah_seat_03'] = true,
    ['miss_rub_couch_01'] = true,
    ['p_armchair_01_s'] = true,
    ['p_ilev_p_easychair_s'] = true,
    ['p_lev_sofa_s'] = true,
    ['p_patio_lounger1_s'] = true,
    ['p_res_sofa_l_s'] = true,
    ['p_v_med_p_sofa_s'] = true,
    ['prop_bench_01a'] = true,
    ['prop_bench_06'] = true,
    ['prop_ld_farm_chair01'] = true,
    ['prop_ld_farm_couch01'] = true,
    ['prop_ld_farm_couch02'] = true,
    ['prop_rub_couch04'] = true,
    ['prop_t_sofa'] = true,
    ['prop_t_sofa_02'] = true,
    ['v_ilev_m_sofa'] = true,
    ['v_res_tre_sofa_s'] = true,
    ['v_tre_sofa_mess_a_s'] = true,
    ['v_tre_sofa_mess_b_s'] = true,
    ['v_tre_sofa_mess_c_s'] = true,
    ['bkr_prop_duffel_bag_01a'] = true,
    ['v_med_emptybed'] = true,
    ['v_med_cor_emblmtable'] = true,
    ['v_ret_gc_bag01'] = true,
    ['xm_prop_body_bag'] = true,
    ['prop_chair_01a'] = true,
    ['prop_chair_01b'] = true,
    ['prop_chair_02'] = true,
    ['prop_chair_03'] = true,
    ['prop_chair_04'] = true,
    ['prop_chair_05'] = true,
    ['prop_chair_06'] = true,
    ['prop_chair_07'] = true,
    ['prop_chair_08'] = true,
    ['prop_chair_09'] = true,
    ['prop_chair_10'] = true,
    ['apa_mp_h_din_chair_04'] = true,
    ['apa_mp_h_din_chair_08'] = true,
    ['apa_mp_h_din_chair_09'] = true,
    ['apa_mp_h_din_chair_12'] = true,
    ['apa_mp_h_stn_chairarm_01'] = true,
    ['apa_mp_h_stn_chairarm_02'] = true,
    ['apa_mp_h_stn_chairarm_09'] = true,
    ['apa_mp_h_stn_chairarm_11'] = true,
    ['apa_mp_h_stn_chairarm_12'] = true,
    ['apa_mp_h_stn_chairarm_13'] = true,
    ['apa_mp_h_stn_chairarm_23'] = true,
    ['apa_mp_h_stn_chairarm_24'] = true,
    ['apa_mp_h_stn_chairarm_25'] = true,
    ['apa_mp_h_stn_chairarm_26'] = true,
    ['apa_mp_h_stn_chairstrip_08'] = true,
    ['apa_mp_h_stn_chairstrip_04'] = true,
    ['apa_mp_h_stn_chairstrip_05'] = true,
    ['apa_mp_h_stn_chairstrip_06'] = true,
    ['apa_mp_h_yacht_armchair_03'] = true,
    ['apa_mp_h_yacht_armchair_04'] = true,
    ['ba_prop_battle_club_chair_02'] = true,
    ['apa_mp_h_yacht_strip_chair_01'] = true,
    ['ba_prop_battle_club_chair_01'] = true,
    ['ba_prop_battle_club_chair_03'] = true,
    ['bka_prop_biker_boardchair01'] = true,
    ['bka_prop_biker_chairstrip_01'] = true,
    ['bka_prop_biker_chairstrip_02'] = true
}

--- WEAPON ITEM 

Shared.Throwables = {
    WEAPON_MOLOTOV = 615608432,
    WEAPON_GRENADE = -1813897027,
    WEAPON_STICKYBOMB = 741814745,
    WEAPON_PROXMINE = -1420407917,
    WEAPON_SMOKEGRENADE = -37975472,
    WEAPON_PIPEBOMB = -1169823560,
    WEAPON_SNOWBALL = 126349499
}

Shared.FuelCan = 883325847

Shared.Ammo = {
    {
        name = 'ammo_pistol',
        weapons = {
            `WEAPON_PISTOL`,
            `WEAPON_APPISTOL`,
            `WEAPON_SNSPISTOL`,
            `WEAPON_COMBATPISTOL`,
            `WEAPON_HEAVYPISTOL`,
            `WEAPON_MACHINEPISTOL`,
            `WEAPON_MARKSMANPISTOL`,
            `WEAPON_PISTOL50`,
            `WEAPON_VINTAGEPISTOL`,
            `WEAPON_PISTOL`,
            `WEAPON_APPISTOL`,
			`WEAPON_SNSPISTOL`,
            `WEAPON_COMBATPISTOL`,
            `WEAPON_HEAVYPISTOL`,
            `WEAPON_MACHINEPISTOL`,
            `WEAPON_MARKSMANPISTOL`,
            `WEAPON_PISTOL50`,
            `WEAPON_VINTAGEPISTOL`
        },
        count = 10
    },
	{
        name = 'ammo_shotgun',
        weapons = {
            `WEAPON_ASSAULTSHOTGUN`,
	        `WEAPON_AUTOSHOTGUN`,
            `WEAPON_BULLPUPSHOTGUN`,
	        `WEAPON_DBSHOTGUN`,
            `WEAPON_HEAVYSHOTGUN`,
            `WEAPON_PUMPSHOTGUN`,
            `WEAPON_SAWNOFFSHOTGUN`,
            `WEAPON_ASSAULTSHOTGUN`,
	        `WEAPON_AUTOSHOTGUN`,
            `WEAPON_BULLPUPSHOTGUN`,
	        `WEAPON_DBSHOTGUN`,
            `WEAPON_HEAVYSHOTGUN`,
            `WEAPON_PUMPSHOTGUN`,
            `WEAPON_SAWNOFFSHOTGUN`
        },
        count = 10
    },
	{
        name = 'ammo_smg',
        weapons = {
            `WEAPON_ASSAULTSMG`,
	        `WEAPON_MICROSMG`,
            `WEAPON_MINISMG`,
            `WEAPON_SMG`
        },
        count = 10
    },
	{
        name = 'ammo_smg_large',
        weapons = {
            `WEAPON_ASSAULTSMG`,
	        `WEAPON_MICROSMG`,
            `WEAPON_MINISMG`,
            `WEAPON_SMG`
        },
        count = 10
    },
	{
        name = 'ammo_rifle',
        weapons = {
            `WEAPON_ADVANCEDRIFLE`,
	        `WEAPON_ASSAULTRIFLE`,
            `WEAPON_BULLPUPRIFLE`,
            `WEAPON_CARBINERIFLE`,
	        `WEAPON_SPECIALCARBINE`,
	        `WEAPON_COMPACTRIFLE`,
            `WEAPON_ADVANCEDRIFLE`,
	        `WEAPON_ASSAULTRIFLE`,
            `WEAPON_BULLPUPRIFLE`,
            `WEAPON_CARBINERIFLE`,
	        `WEAPON_SPECIALCARBINE`,
	        `WEAPON_COMPACTRIFLE`
        },
        count = 10
    },
	{
        name = 'ammo_snp',
        weapons = {
            `WEAPON_SNIPERRIFLE`,
	        `WEAPON_HEAVYSNIPER`,
            `WEAPON_MARKSMANRIFLE`,
            `WEAPON_SNIPERRIFLE`,
	        `WEAPON_HEAVYSNIPER`,
            `WEAPON_MARKSMANRIFLE`
        },
        count = 10
    }
}