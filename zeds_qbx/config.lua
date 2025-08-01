Config = {}

------------------------------------------------------------------------------------------------------
-- ZOMBIES
------------------------------------------------------------------------------------------------------

Config.MaxDensity = 0.8

Config.ZombieTypes = {

    normal = {
        models = {
            "a_f_y_juggalo_01"
        },
        damage = 10,
        armor = 0,
        speed = 2.0,
        ragdollChance = 1,
        clipsets = {"move_m@drunk@verydrunk"},
        sound = "normal.ogg",
        special = nil,
        density = 0.1,

        loot = {
		--Junk Items--
			{item = 'plastic', min = 5, max = 10, chance = 80},
			{item = 'glass', min = 5, max = 15, chance = 80},
			{item = 'rubber', min = 10, max = 20, chance = 80},
			{item = 'paperbag', min = 5, max = 10, chance = 80},
			{item = 'garbage', min = 5, max = 15, chance = 80},
			{item = 'metalscrap', min = 10, max = 20, chance = 80},			
			{item = 'lighter', min = 1, max = 5, chance = 60},
			{item = 'binoculars', min = 1, max = 1, chance = 60},
			{item = 'stickynote', min = 1, max = 1, chance = 60},
			{item = 'trojan_usb', min = 1, max = 1, chance = 30},
			{item = 'cryptostick', min = 1, max = 1, chance = 30},
			{item = 'radio', min = 1, max = 1, chance = 10},
			{item = 'radiocell', min = 1, max = 1, chance = 10},
			{item = 'phone', min = 1, max = 1, chance = 10},
			{item = 'tablet', min = 1, max = 1, chance = 10},
			{item = 'laptop', min = 1, max = 1, chance = 10},
			{item = 'lockpick', min = 1, max = 1, chance = 10},
			{item = 'advancedlockpick', min = 1, max = 1, chance = 10},
			{item = 'electronickit', min = 1, max = 1, chance = 10},
			{item = 'repairkit', min = 1, max = 1, chance = 10},
			{item = 'advancedrepairkit', min = 1, max = 1, chance = 10},
			{item = 'drill', min = 1, max = 1, chance = 10},
			{item = 'screwdriverset', min = 1, max = 1, chance = 10},
			{item = 'security_card_01', min = 1, max = 1, chance = 1},
			{item = 'security_card_02', min = 1, max = 1, chance = 1},
			{item = 'thermite', min = 1, max = 3, chance = 5},
			{item = 'empty_evidence_bag', min = 1, max = 1, chance = 1},
			{item = 'harness', min = 1, max = 1, chance = 1},
			{item = 'handcuffs', min = 1, max = 1, chance = 1},
			{item = 'diving_gear', min = 1, max = 1, chance = 1},
			{item = 'diving_fill', min = 1, max = 1, chance = 1},			
		--Medical Items--
			{item = 'painkillers', min = 1, max = 1, chance = 1}, --The Cure--
			{item = 'firstaid', min = 1, max = 1, chance = 3},
			{item = 'ifaks', min = 1, max = 1, chance = 5},
			{item = 'bandage', min = 1, max = 3, chance = 5},
			{item = 'armour', min = 1, max = 1, chance = 5},
		--Food Items--
			{item = 'water', min = 1, max = 5, chance = 5},
			{item = 'coffee', min = 1, max = 1, chance = 10},
			{item = 'grapejuice', min = 1, max = 1, chance = 10},
			{item = 'cola', min = 1, max = 1, chance = 10},
			{item = 'sprunk', min = 1, max = 1, chance = 10},
			{item = 'whiskey', min = 1, max = 1, chance = 10},
			{item = 'vodka', min = 1, max = 1, chance = 10},
			{item = 'beer', min = 1, max = 1, chance = 10},
			{item = 'burger', min = 1, max = 5, chance = 5},
			{item = 'sandwich', min = 1, max = 5, chance = 10},
		--Ammo Items--
			{item = 'ammo-flare', min = 1, max = 5, chance = 30},
			{item = 'ammo-22', min = 15, max = 30, chance = 20},
			{item = 'ammo-38', min = 6, max = 12, chance = 20}, 
			{item = 'ammo-44', min = 6, max = 12, chance = 20}, 
			{item = 'ammo-45', min = 30, max = 60, chance = 10}, 	
			{item = 'ammo-9', min = 30, max = 60, chance = 10}, 
			{item = 'ammo-rifle', min = 30, max = 60, chance = 5},
			{item = 'ammo-rifle2', min = 30, max = 60, chance = 5},
			{item = 'ammo-shotgun', min = 12, max = 24, chance = 30},
			{item = 'ammo-sniper', min = 1, max = 2, chance = 10},
			{item = 'ammo-heavysniper', min = 1, max = 2, chance = 10},
			{item = 'ammo-rocket', min = 1, max = 1, chance = 5},
			{item = 'weapon_grenade', min = 1, max = 2, chance = 5},
			{item = 'weapon_pipebomb', min = 1, max = 1, chance = 5},
			{item = 'weapon_bzgas', min = 1, max = 2, chance = 5},
			{item = 'weapon_molotov', min = 1, max = 2, chance = 10},
			{item = 'weapon_flare', min = 1, max = 5, chance = 40},
			{item = 'weapon_smokegrenade', min = 1, max = 1, chance = 40},
			{item = 'weapon_stickybomb', min = 1, max = 1, chance = 1},
			{item = 'weapon_proxmine', min = 1, max = 1, chance = 1},
		--Pistols--
			{item = 'weapon_stungun', min = 1, max = 1, chance = 50},
			{item = 'weapon_flaregun', min = 1, max = 1, chance = 50},
			{item = 'weapon_vintagepistol', min = 1, max = 1, chance = 40},
			{item = 'weapon_ceramicpistol', min = 1, max = 1, chance = 40},
			{item = 'weapon_vintagepistol', min = 1, max = 1, chance = 40},
			{item = 'weapon_pistol', min = 1, max = 1, chance = 30},
			{item = 'weapon_pistolxm3', min = 1, max = 1, chance = 20},
			{item = 'weapon_combatpistol', min = 1, max = 1, chance = 10},
			{item = 'weapon_heavypistol', min = 1, max = 1, chance = 10},
			{item = 'weapon_pistol_mk2', min = 1, max = 1, chance = 5},
			{item = 'weapon_pistol50', min = 1, max = 1, chance = 20},
			{item = 'weapon_navyrevolver', min = 1, max = 1, chance = 20},
			{item = 'weapon_doubleaction', min = 1, max = 1, chance = 20},
			{item = 'weapon_revolver', min = 1, max = 1, chance = 20},
		--SMGS & Rifles--
			{item = 'weapon_tecpistol', min = 1, max = 1, chance = 20},
			{item = 'weapon_smg', min = 1, max = 1, chance = 15},
			{item = 'weapon_microsmg', min = 1, max = 1, chance = 15},
			{item = 'weapon_combatpdw', min = 1, max = 1, chance = 15},
			{item = 'weapon_compactrifle', min = 1, max = 1, chance = 15},
			{item = 'weapon_assaultrifle', min = 1, max = 1, chance = 10},
			{item = 'weapon_assaultrifle_mk2', min = 1, max = 1, chance = 1},
			{item = 'weapon_compactrifle', min = 1, max = 1, chance = 15},
			{item = 'weapon_heavyrifle', min = 1, max = 1, chance = 8},
			{item = 'weapon_tacticalrifle', min = 1, max = 1, chance = 5},
			{item = 'weapon_battlerifle', min = 1, max = 1, chance = 3},
		--Shotguns & Heavy--
			{item = 'weapon_dbshotgun', min = 1, max = 1, chance = 25},
			{item = 'weapon_sawnoffshotgun', min = 1, max = 1, chance = 20},
			{item = 'weapon_pumpshotgun', min = 1, max = 1, chance = 20},
			{item = 'weapon_pumpshotgun_mk2', min = 1, max = 1, chance = 5},
			{item = 'weapon_heavyshotgun', min = 1, max = 1, chance = 5},
			{item = 'weapon_bullpupshotgun', min = 1, max = 1, chance = 10},
			{item = 'weapon_combatshotgun', min = 1, max = 1, chance = 8},
			{item = 'weapon_assaultshotgun', min = 1, max = 1, chance = 1},
			{item = 'weapon_marksmanrifle', min = 1, max = 1, chance = 1},
			{item = 'weapon_sniperrifle', min = 1, max = 1, chance = 1},
			{item = 'weapon_heavysniper', min = 1, max = 1, chance = 1},
			{item = 'weapon_heaysniper_mk2', min = 1, max = 1, chance = 1},
			{item = 'weapon_rpg', min = 1, max = 1, chance = 1},
			{item = 'weapon_mg', min = 1, max = 1, chance = 1},
			{item = 'weapon_combatmg', min = 1, max = 1, chance = 1},
			{item = 'weapon_combatmg_mk2', min = 1, max = 1, chance = 1},
        }
    },

    fast = {
        models = {
            "a_m_m_eastsa_02"
        },
        damage = 8,
        armor = 0,
        speed = 3.0,
        ragdollChance = 1,
        clipsets = {"move_m@drunk@verydrunk"},
        sound = "fast.ogg",
        special = nil,
        density = 0.1,

        loot = {
		--Junk Items--
			{item = 'plastic', min = 5, max = 10, chance = 80},
			{item = 'glass', min = 5, max = 15, chance = 80},
			{item = 'rubber', min = 10, max = 20, chance = 80},
			{item = 'paperbag', min = 5, max = 10, chance = 80},
			{item = 'garbage', min = 5, max = 15, chance = 80},
			{item = 'metalscrap', min = 10, max = 20, chance = 80},			
			{item = 'lighter', min = 1, max = 5, chance = 60},
			{item = 'binoculars', min = 1, max = 1, chance = 60},
			{item = 'stickynote', min = 1, max = 1, chance = 60},
			{item = 'trojan_usb', min = 1, max = 1, chance = 30},
			{item = 'cryptostick', min = 1, max = 1, chance = 30},
			{item = 'radio', min = 1, max = 1, chance = 10},
			{item = 'radiocell', min = 1, max = 1, chance = 10},
			{item = 'phone', min = 1, max = 1, chance = 10},
			{item = 'tablet', min = 1, max = 1, chance = 10},
			{item = 'laptop', min = 1, max = 1, chance = 10},
			{item = 'lockpick', min = 1, max = 1, chance = 10},
			{item = 'advancedlockpick', min = 1, max = 1, chance = 10},
			{item = 'electronickit', min = 1, max = 1, chance = 10},
			{item = 'repairkit', min = 1, max = 1, chance = 10},
			{item = 'advancedrepairkit', min = 1, max = 1, chance = 10},
			{item = 'drill', min = 1, max = 1, chance = 10},
			{item = 'screwdriverset', min = 1, max = 1, chance = 10},
			{item = 'security_card_01', min = 1, max = 1, chance = 1},
			{item = 'security_card_02', min = 1, max = 1, chance = 1},
			{item = 'thermite', min = 1, max = 3, chance = 5},
			{item = 'empty_evidence_bag', min = 1, max = 1, chance = 1},
			{item = 'harness', min = 1, max = 1, chance = 1},
			{item = 'handcuffs', min = 1, max = 1, chance = 1},
			{item = 'diving_gear', min = 1, max = 1, chance = 1},
			{item = 'diving_fill', min = 1, max = 1, chance = 1},			
		--Medical Items--
			{item = 'painkillers', min = 1, max = 1, chance = 1}, --The Cure--
			{item = 'firstaid', min = 1, max = 1, chance = 3},
			{item = 'ifaks', min = 1, max = 1, chance = 5},
			{item = 'bandage', min = 1, max = 3, chance = 5},
			{item = 'armour', min = 1, max = 1, chance = 5},
		--Food Items--
			{item = 'water', min = 1, max = 5, chance = 5},
			{item = 'coffee', min = 1, max = 1, chance = 10},
			{item = 'grapejuice', min = 1, max = 1, chance = 10},
			{item = 'cola', min = 1, max = 1, chance = 10},
			{item = 'sprunk', min = 1, max = 1, chance = 10},
			{item = 'whiskey', min = 1, max = 1, chance = 10},
			{item = 'vodka', min = 1, max = 1, chance = 10},
			{item = 'beer', min = 1, max = 1, chance = 10},
			{item = 'burger', min = 1, max = 5, chance = 5},
			{item = 'sandwich', min = 1, max = 5, chance = 10},
		--Ammo Items--
			{item = 'ammo-flare', min = 1, max = 5, chance = 30},
			{item = 'ammo-22', min = 15, max = 30, chance = 20},
			{item = 'ammo-38', min = 6, max = 12, chance = 20}, 
			{item = 'ammo-44', min = 6, max = 12, chance = 20}, 
			{item = 'ammo-45', min = 30, max = 60, chance = 10}, 	
			{item = 'ammo-9', min = 30, max = 60, chance = 10}, 
			{item = 'ammo-rifle', min = 30, max = 60, chance = 5},
			{item = 'ammo-rifle2', min = 30, max = 60, chance = 5},
			{item = 'ammo-shotgun', min = 12, max = 24, chance = 30},
			{item = 'ammo-sniper', min = 1, max = 2, chance = 10},
			{item = 'ammo-heavysniper', min = 1, max = 2, chance = 10},
			{item = 'ammo-rocket', min = 1, max = 1, chance = 5},
			{item = 'weapon_grenade', min = 1, max = 2, chance = 5},
			{item = 'weapon_pipebomb', min = 1, max = 1, chance = 5},
			{item = 'weapon_bzgas', min = 1, max = 2, chance = 5},
			{item = 'weapon_molotov', min = 1, max = 2, chance = 10},
			{item = 'weapon_flare', min = 1, max = 5, chance = 40},
			{item = 'weapon_smokegrenade', min = 1, max = 1, chance = 40},
			{item = 'weapon_stickybomb', min = 1, max = 1, chance = 1},
			{item = 'weapon_proxmine', min = 1, max = 1, chance = 1},
		--Pistols--
			{item = 'weapon_stungun', min = 1, max = 1, chance = 50},
			{item = 'weapon_flaregun', min = 1, max = 1, chance = 50},
			{item = 'weapon_vintagepistol', min = 1, max = 1, chance = 40},
			{item = 'weapon_ceramicpistol', min = 1, max = 1, chance = 40},
			{item = 'weapon_vintagepistol', min = 1, max = 1, chance = 40},
			{item = 'weapon_pistol', min = 1, max = 1, chance = 30},
			{item = 'weapon_pistolxm3', min = 1, max = 1, chance = 20},
			{item = 'weapon_combatpistol', min = 1, max = 1, chance = 10},
			{item = 'weapon_heavypistol', min = 1, max = 1, chance = 10},
			{item = 'weapon_pistol_mk2', min = 1, max = 1, chance = 5},
			{item = 'weapon_pistol50', min = 1, max = 1, chance = 20},
			{item = 'weapon_navyrevolver', min = 1, max = 1, chance = 20},
			{item = 'weapon_doubleaction', min = 1, max = 1, chance = 20},
			{item = 'weapon_revolver', min = 1, max = 1, chance = 20},
		--SMGS & Rifles--
			{item = 'weapon_tecpistol', min = 1, max = 1, chance = 20},
			{item = 'weapon_smg', min = 1, max = 1, chance = 15},
			{item = 'weapon_microsmg', min = 1, max = 1, chance = 15},
			{item = 'weapon_combatpdw', min = 1, max = 1, chance = 15},
			{item = 'weapon_compactrifle', min = 1, max = 1, chance = 15},
			{item = 'weapon_assaultrifle', min = 1, max = 1, chance = 10},
			{item = 'weapon_assaultrifle_mk2', min = 1, max = 1, chance = 1},
			{item = 'weapon_compactrifle', min = 1, max = 1, chance = 15},
			{item = 'weapon_heavyrifle', min = 1, max = 1, chance = 8},
			{item = 'weapon_tacticalrifle', min = 1, max = 1, chance = 5},
			{item = 'weapon_battlerifle', min = 1, max = 1, chance = 3},
		--Shotguns & Heavy--
			{item = 'weapon_dbshotgun', min = 1, max = 1, chance = 25},
			{item = 'weapon_sawnoffshotgun', min = 1, max = 1, chance = 20},
			{item = 'weapon_pumpshotgun', min = 1, max = 1, chance = 20},
			{item = 'weapon_pumpshotgun_mk2', min = 1, max = 1, chance = 5},
			{item = 'weapon_heavyshotgun', min = 1, max = 1, chance = 5},
			{item = 'weapon_bullpupshotgun', min = 1, max = 1, chance = 10},
			{item = 'weapon_combatshotgun', min = 1, max = 1, chance = 8},
			{item = 'weapon_assaultshotgun', min = 1, max = 1, chance = 1},
			{item = 'weapon_marksmanrifle', min = 1, max = 1, chance = 1},
			{item = 'weapon_sniperrifle', min = 1, max = 1, chance = 1},
			{item = 'weapon_heavysniper', min = 1, max = 1, chance = 1},
			{item = 'weapon_heaysniper_mk2', min = 1, max = 1, chance = 1},
			{item = 'weapon_rpg', min = 1, max = 1, chance = 1},
			{item = 'weapon_mg', min = 1, max = 1, chance = 1},
			{item = 'weapon_combatmg', min = 1, max = 1, chance = 1},
			{item = 'weapon_combatmg_mk2', min = 1, max = 1, chance = 1},
        }
    },

    tank = {
        models = {
            "a_m_m_og_boss_01"
        },
        damage = 20,
        armor = 200,
        speed = 1.0,
        ragdollChance = 1,
        clipsets = {"move_m@drunk@verydrunk"},
        sound = "tank.ogg",
        special = nil,
        density = 0.1,

        loot = {
		--Junk Items--
			{item = 'plastic', min = 5, max = 10, chance = 80},
			{item = 'glass', min = 5, max = 15, chance = 80},
			{item = 'rubber', min = 10, max = 20, chance = 80},
			{item = 'paperbag', min = 5, max = 10, chance = 80},
			{item = 'garbage', min = 5, max = 15, chance = 80},
			{item = 'metalscrap', min = 10, max = 20, chance = 80},			
			{item = 'lighter', min = 1, max = 5, chance = 60},
			{item = 'binoculars', min = 1, max = 1, chance = 60},
			{item = 'stickynote', min = 1, max = 1, chance = 60},
			{item = 'trojan_usb', min = 1, max = 1, chance = 30},
			{item = 'cryptostick', min = 1, max = 1, chance = 30},
			{item = 'radio', min = 1, max = 1, chance = 10},
			{item = 'radiocell', min = 1, max = 1, chance = 10},
			{item = 'phone', min = 1, max = 1, chance = 10},
			{item = 'tablet', min = 1, max = 1, chance = 10},
			{item = 'laptop', min = 1, max = 1, chance = 10},
			{item = 'lockpick', min = 1, max = 1, chance = 10},
			{item = 'advancedlockpick', min = 1, max = 1, chance = 10},
			{item = 'electronickit', min = 1, max = 1, chance = 10},
			{item = 'repairkit', min = 1, max = 1, chance = 10},
			{item = 'advancedrepairkit', min = 1, max = 1, chance = 10},
			{item = 'drill', min = 1, max = 1, chance = 10},
			{item = 'screwdriverset', min = 1, max = 1, chance = 10},
			{item = 'security_card_01', min = 1, max = 1, chance = 1},
			{item = 'security_card_02', min = 1, max = 1, chance = 1},
			{item = 'thermite', min = 1, max = 3, chance = 5},
			{item = 'empty_evidence_bag', min = 1, max = 1, chance = 1},
			{item = 'harness', min = 1, max = 1, chance = 1},
			{item = 'handcuffs', min = 1, max = 1, chance = 1},
			{item = 'diving_gear', min = 1, max = 1, chance = 1},
			{item = 'diving_fill', min = 1, max = 1, chance = 1},			
		--Medical Items--
			{item = 'painkillers', min = 1, max = 1, chance = 1}, --The Cure--
			{item = 'firstaid', min = 1, max = 1, chance = 3},
			{item = 'ifaks', min = 1, max = 1, chance = 5},
			{item = 'bandage', min = 1, max = 3, chance = 5},
			{item = 'armour', min = 1, max = 1, chance = 5},
		--Food Items--
			{item = 'water', min = 1, max = 5, chance = 5},
			{item = 'coffee', min = 1, max = 1, chance = 10},
			{item = 'grapejuice', min = 1, max = 1, chance = 10},
			{item = 'cola', min = 1, max = 1, chance = 10},
			{item = 'sprunk', min = 1, max = 1, chance = 10},
			{item = 'whiskey', min = 1, max = 1, chance = 10},
			{item = 'vodka', min = 1, max = 1, chance = 10},
			{item = 'beer', min = 1, max = 1, chance = 10},
			{item = 'burger', min = 1, max = 5, chance = 5},
			{item = 'sandwich', min = 1, max = 5, chance = 10},
		--Ammo Items--
			{item = 'ammo-flare', min = 1, max = 5, chance = 30},
			{item = 'ammo-22', min = 15, max = 30, chance = 20},
			{item = 'ammo-38', min = 6, max = 12, chance = 20}, 
			{item = 'ammo-44', min = 6, max = 12, chance = 20}, 
			{item = 'ammo-45', min = 30, max = 60, chance = 10}, 	
			{item = 'ammo-9', min = 30, max = 60, chance = 10}, 
			{item = 'ammo-rifle', min = 30, max = 60, chance = 5},
			{item = 'ammo-rifle2', min = 30, max = 60, chance = 5},
			{item = 'ammo-shotgun', min = 12, max = 24, chance = 30},
			{item = 'ammo-sniper', min = 1, max = 2, chance = 10},
			{item = 'ammo-heavysniper', min = 1, max = 2, chance = 10},
			{item = 'ammo-rocket', min = 1, max = 1, chance = 5},
			{item = 'weapon_grenade', min = 1, max = 2, chance = 5},
			{item = 'weapon_pipebomb', min = 1, max = 1, chance = 5},
			{item = 'weapon_bzgas', min = 1, max = 2, chance = 5},
			{item = 'weapon_molotov', min = 1, max = 2, chance = 10},
			{item = 'weapon_flare', min = 1, max = 5, chance = 40},
			{item = 'weapon_smokegrenade', min = 1, max = 1, chance = 40},
			{item = 'weapon_stickybomb', min = 1, max = 1, chance = 1},
			{item = 'weapon_proxmine', min = 1, max = 1, chance = 1},
		--Pistols--
			{item = 'weapon_stungun', min = 1, max = 1, chance = 50},
			{item = 'weapon_flaregun', min = 1, max = 1, chance = 50},
			{item = 'weapon_vintagepistol', min = 1, max = 1, chance = 40},
			{item = 'weapon_ceramicpistol', min = 1, max = 1, chance = 40},
			{item = 'weapon_vintagepistol', min = 1, max = 1, chance = 40},
			{item = 'weapon_pistol', min = 1, max = 1, chance = 30},
			{item = 'weapon_pistolxm3', min = 1, max = 1, chance = 20},
			{item = 'weapon_combatpistol', min = 1, max = 1, chance = 10},
			{item = 'weapon_heavypistol', min = 1, max = 1, chance = 10},
			{item = 'weapon_pistol_mk2', min = 1, max = 1, chance = 5},
			{item = 'weapon_pistol50', min = 1, max = 1, chance = 20},
			{item = 'weapon_navyrevolver', min = 1, max = 1, chance = 20},
			{item = 'weapon_doubleaction', min = 1, max = 1, chance = 20},
			{item = 'weapon_revolver', min = 1, max = 1, chance = 20},
		--SMGS & Rifles--
			{item = 'weapon_tecpistol', min = 1, max = 1, chance = 20},
			{item = 'weapon_smg', min = 1, max = 1, chance = 15},
			{item = 'weapon_microsmg', min = 1, max = 1, chance = 15},
			{item = 'weapon_combatpdw', min = 1, max = 1, chance = 15},
			{item = 'weapon_compactrifle', min = 1, max = 1, chance = 15},
			{item = 'weapon_assaultrifle', min = 1, max = 1, chance = 10},
			{item = 'weapon_assaultrifle_mk2', min = 1, max = 1, chance = 1},
			{item = 'weapon_compactrifle', min = 1, max = 1, chance = 15},
			{item = 'weapon_heavyrifle', min = 1, max = 1, chance = 8},
			{item = 'weapon_tacticalrifle', min = 1, max = 1, chance = 5},
			{item = 'weapon_battlerifle', min = 1, max = 1, chance = 3},
		--Shotguns & Heavy--
			{item = 'weapon_dbshotgun', min = 1, max = 1, chance = 25},
			{item = 'weapon_sawnoffshotgun', min = 1, max = 1, chance = 20},
			{item = 'weapon_pumpshotgun', min = 1, max = 1, chance = 20},
			{item = 'weapon_pumpshotgun_mk2', min = 1, max = 1, chance = 5},
			{item = 'weapon_heavyshotgun', min = 1, max = 1, chance = 5},
			{item = 'weapon_bullpupshotgun', min = 1, max = 1, chance = 10},
			{item = 'weapon_combatshotgun', min = 1, max = 1, chance = 8},
			{item = 'weapon_assaultshotgun', min = 1, max = 1, chance = 1},
			{item = 'weapon_marksmanrifle', min = 1, max = 1, chance = 1},
			{item = 'weapon_sniperrifle', min = 1, max = 1, chance = 1},
			{item = 'weapon_heavysniper', min = 1, max = 1, chance = 1},
			{item = 'weapon_heaysniper_mk2', min = 1, max = 1, chance = 1},
			{item = 'weapon_rpg', min = 1, max = 1, chance = 1},
			{item = 'weapon_mg', min = 1, max = 1, chance = 1},
			{item = 'weapon_combatmg', min = 1, max = 1, chance = 1},
			{item = 'weapon_combatmg_mk2', min = 1, max = 1, chance = 1},
        }
    },

    psycho = {
        models = { 
            "s_m_y_prisoner_01" 
        },
        damage = 15,
        armor = 0,
        speed = 3.0,
        ragdollChance = 50,
        clipsets = {"move_m@drunk@verydrunk"},
        sound = "psycho.ogg",
        special = "psycho",
        teleport_interval = 5000,
        force_application_interval = 5000,
        density = 0.1,

        loot = {
		--Junk Items--
			{item = 'plastic', min = 5, max = 10, chance = 80},
			{item = 'glass', min = 5, max = 15, chance = 80},
			{item = 'rubber', min = 10, max = 20, chance = 80},
			{item = 'paperbag', min = 5, max = 10, chance = 80},
			{item = 'garbage', min = 5, max = 15, chance = 80},
			{item = 'metalscrap', min = 10, max = 20, chance = 80},			
			{item = 'lighter', min = 1, max = 5, chance = 60},
			{item = 'binoculars', min = 1, max = 1, chance = 60},
			{item = 'stickynote', min = 1, max = 1, chance = 60},
			{item = 'trojan_usb', min = 1, max = 1, chance = 30},
			{item = 'cryptostick', min = 1, max = 1, chance = 30},
			{item = 'radio', min = 1, max = 1, chance = 10},
			{item = 'radiocell', min = 1, max = 1, chance = 10},
			{item = 'phone', min = 1, max = 1, chance = 10},
			{item = 'tablet', min = 1, max = 1, chance = 10},
			{item = 'laptop', min = 1, max = 1, chance = 10},
			{item = 'lockpick', min = 1, max = 1, chance = 10},
			{item = 'advancedlockpick', min = 1, max = 1, chance = 10},
			{item = 'electronickit', min = 1, max = 1, chance = 10},
			{item = 'repairkit', min = 1, max = 1, chance = 10},
			{item = 'advancedrepairkit', min = 1, max = 1, chance = 10},
			{item = 'drill', min = 1, max = 1, chance = 10},
			{item = 'screwdriverset', min = 1, max = 1, chance = 10},
			{item = 'security_card_01', min = 1, max = 1, chance = 1},
			{item = 'security_card_02', min = 1, max = 1, chance = 1},
			{item = 'thermite', min = 1, max = 3, chance = 5},
			{item = 'empty_evidence_bag', min = 1, max = 1, chance = 1},
			{item = 'harness', min = 1, max = 1, chance = 1},
			{item = 'handcuffs', min = 1, max = 1, chance = 1},
			{item = 'diving_gear', min = 1, max = 1, chance = 1},
			{item = 'diving_fill', min = 1, max = 1, chance = 1},			
		--Medical Items--
			{item = 'painkillers', min = 1, max = 1, chance = 1}, --The Cure--
			{item = 'firstaid', min = 1, max = 1, chance = 3},
			{item = 'ifaks', min = 1, max = 1, chance = 5},
			{item = 'bandage', min = 1, max = 3, chance = 5},
			{item = 'armour', min = 1, max = 1, chance = 5},
		--Food Items--
			{item = 'water', min = 1, max = 5, chance = 5},
			{item = 'coffee', min = 1, max = 1, chance = 10},
			{item = 'grapejuice', min = 1, max = 1, chance = 10},
			{item = 'cola', min = 1, max = 1, chance = 10},
			{item = 'sprunk', min = 1, max = 1, chance = 10},
			{item = 'whiskey', min = 1, max = 1, chance = 10},
			{item = 'vodka', min = 1, max = 1, chance = 10},
			{item = 'beer', min = 1, max = 1, chance = 10},
			{item = 'burger', min = 1, max = 5, chance = 5},
			{item = 'sandwich', min = 1, max = 5, chance = 10},
		--Ammo Items--
			{item = 'ammo-flare', min = 1, max = 5, chance = 30},
			{item = 'ammo-22', min = 15, max = 30, chance = 20},
			{item = 'ammo-38', min = 6, max = 12, chance = 20}, 
			{item = 'ammo-44', min = 6, max = 12, chance = 20}, 
			{item = 'ammo-45', min = 30, max = 60, chance = 10}, 	
			{item = 'ammo-9', min = 30, max = 60, chance = 10}, 
			{item = 'ammo-rifle', min = 30, max = 60, chance = 5},
			{item = 'ammo-rifle2', min = 30, max = 60, chance = 5},
			{item = 'ammo-shotgun', min = 12, max = 24, chance = 30},
			{item = 'ammo-sniper', min = 1, max = 2, chance = 10},
			{item = 'ammo-heavysniper', min = 1, max = 2, chance = 10},
			{item = 'ammo-rocket', min = 1, max = 1, chance = 5},
			{item = 'weapon_grenade', min = 1, max = 2, chance = 5},
			{item = 'weapon_pipebomb', min = 1, max = 1, chance = 5},
			{item = 'weapon_bzgas', min = 1, max = 2, chance = 5},
			{item = 'weapon_molotov', min = 1, max = 2, chance = 10},
			{item = 'weapon_flare', min = 1, max = 5, chance = 40},
			{item = 'weapon_smokegrenade', min = 1, max = 1, chance = 40},
			{item = 'weapon_stickybomb', min = 1, max = 1, chance = 1},
			{item = 'weapon_proxmine', min = 1, max = 1, chance = 1},
		--Pistols--
			{item = 'weapon_stungun', min = 1, max = 1, chance = 50},
			{item = 'weapon_flaregun', min = 1, max = 1, chance = 50},
			{item = 'weapon_vintagepistol', min = 1, max = 1, chance = 40},
			{item = 'weapon_ceramicpistol', min = 1, max = 1, chance = 40},
			{item = 'weapon_vintagepistol', min = 1, max = 1, chance = 40},
			{item = 'weapon_pistol', min = 1, max = 1, chance = 30},
			{item = 'weapon_pistolxm3', min = 1, max = 1, chance = 20},
			{item = 'weapon_combatpistol', min = 1, max = 1, chance = 10},
			{item = 'weapon_heavypistol', min = 1, max = 1, chance = 10},
			{item = 'weapon_pistol_mk2', min = 1, max = 1, chance = 5},
			{item = 'weapon_pistol50', min = 1, max = 1, chance = 20},
			{item = 'weapon_navyrevolver', min = 1, max = 1, chance = 20},
			{item = 'weapon_doubleaction', min = 1, max = 1, chance = 20},
			{item = 'weapon_revolver', min = 1, max = 1, chance = 20},
		--SMGS & Rifles--
			{item = 'weapon_tecpistol', min = 1, max = 1, chance = 20},
			{item = 'weapon_smg', min = 1, max = 1, chance = 15},
			{item = 'weapon_microsmg', min = 1, max = 1, chance = 15},
			{item = 'weapon_combatpdw', min = 1, max = 1, chance = 15},
			{item = 'weapon_compactrifle', min = 1, max = 1, chance = 15},
			{item = 'weapon_assaultrifle', min = 1, max = 1, chance = 10},
			{item = 'weapon_assaultrifle_mk2', min = 1, max = 1, chance = 1},
			{item = 'weapon_compactrifle', min = 1, max = 1, chance = 15},
			{item = 'weapon_heavyrifle', min = 1, max = 1, chance = 8},
			{item = 'weapon_tacticalrifle', min = 1, max = 1, chance = 5},
			{item = 'weapon_battlerifle', min = 1, max = 1, chance = 3},
		--Shotguns & Heavy--
			{item = 'weapon_dbshotgun', min = 1, max = 1, chance = 25},
			{item = 'weapon_sawnoffshotgun', min = 1, max = 1, chance = 20},
			{item = 'weapon_pumpshotgun', min = 1, max = 1, chance = 20},
			{item = 'weapon_pumpshotgun_mk2', min = 1, max = 1, chance = 5},
			{item = 'weapon_heavyshotgun', min = 1, max = 1, chance = 5},
			{item = 'weapon_bullpupshotgun', min = 1, max = 1, chance = 10},
			{item = 'weapon_combatshotgun', min = 1, max = 1, chance = 8},
			{item = 'weapon_assaultshotgun', min = 1, max = 1, chance = 1},
			{item = 'weapon_marksmanrifle', min = 1, max = 1, chance = 1},
			{item = 'weapon_sniperrifle', min = 1, max = 1, chance = 1},
			{item = 'weapon_heavysniper', min = 1, max = 1, chance = 1},
			{item = 'weapon_heaysniper_mk2', min = 1, max = 1, chance = 1},
			{item = 'weapon_rpg', min = 1, max = 1, chance = 1},
			{item = 'weapon_mg', min = 1, max = 1, chance = 1},
			{item = 'weapon_combatmg', min = 1, max = 1, chance = 1},
			{item = 'weapon_combatmg_mk2', min = 1, max = 1, chance = 1},
        }
    },

    explosive = {
        models = {
            "a_m_m_farmer_01"
        },
        damage = 25,
        armor = 0,
        speed = 2.0,
        ragdollChance = 1,
        clipsets = {"move_m@drunk@verydrunk"},
        sound = "explosive.ogg",
        special = "explosive",
        explosion_radius = 3.0,
        explodeDamage = 40,
        density = 0.1,

        loot = {
		--Junk Items--
			{item = 'plastic', min = 5, max = 10, chance = 80},
			{item = 'glass', min = 5, max = 15, chance = 80},
			{item = 'rubber', min = 10, max = 20, chance = 80},
			{item = 'paperbag', min = 5, max = 10, chance = 80},
			{item = 'garbage', min = 5, max = 15, chance = 80},
			{item = 'metalscrap', min = 10, max = 20, chance = 80},			
			{item = 'lighter', min = 1, max = 5, chance = 60},
			{item = 'binoculars', min = 1, max = 1, chance = 60},
			{item = 'stickynote', min = 1, max = 1, chance = 60},
			{item = 'trojan_usb', min = 1, max = 1, chance = 30},
			{item = 'cryptostick', min = 1, max = 1, chance = 30},
			{item = 'radio', min = 1, max = 1, chance = 10},
			{item = 'radiocell', min = 1, max = 1, chance = 10},
			{item = 'phone', min = 1, max = 1, chance = 10},
			{item = 'tablet', min = 1, max = 1, chance = 10},
			{item = 'laptop', min = 1, max = 1, chance = 10},
			{item = 'lockpick', min = 1, max = 1, chance = 10},
			{item = 'advancedlockpick', min = 1, max = 1, chance = 10},
			{item = 'electronickit', min = 1, max = 1, chance = 10},
			{item = 'repairkit', min = 1, max = 1, chance = 10},
			{item = 'advancedrepairkit', min = 1, max = 1, chance = 10},
			{item = 'drill', min = 1, max = 1, chance = 10},
			{item = 'screwdriverset', min = 1, max = 1, chance = 10},
			{item = 'security_card_01', min = 1, max = 1, chance = 1},
			{item = 'security_card_02', min = 1, max = 1, chance = 1},
			{item = 'thermite', min = 1, max = 3, chance = 5},
			{item = 'empty_evidence_bag', min = 1, max = 1, chance = 1},
			{item = 'harness', min = 1, max = 1, chance = 1},
			{item = 'handcuffs', min = 1, max = 1, chance = 1},
			{item = 'diving_gear', min = 1, max = 1, chance = 1},
			{item = 'diving_fill', min = 1, max = 1, chance = 1},			
		--Medical Items--
			{item = 'painkillers', min = 1, max = 1, chance = 1}, --The Cure--
			{item = 'firstaid', min = 1, max = 1, chance = 3},
			{item = 'ifaks', min = 1, max = 1, chance = 5},
			{item = 'bandage', min = 1, max = 3, chance = 5},
			{item = 'armour', min = 1, max = 1, chance = 5},
		--Food Items--
			{item = 'water', min = 1, max = 5, chance = 5},
			{item = 'coffee', min = 1, max = 1, chance = 10},
			{item = 'grapejuice', min = 1, max = 1, chance = 10},
			{item = 'cola', min = 1, max = 1, chance = 10},
			{item = 'sprunk', min = 1, max = 1, chance = 10},
			{item = 'whiskey', min = 1, max = 1, chance = 10},
			{item = 'vodka', min = 1, max = 1, chance = 10},
			{item = 'beer', min = 1, max = 1, chance = 10},
			{item = 'burger', min = 1, max = 5, chance = 5},
			{item = 'sandwich', min = 1, max = 5, chance = 10},
		--Ammo Items--
			{item = 'ammo-flare', min = 1, max = 5, chance = 30},
			{item = 'ammo-22', min = 15, max = 30, chance = 20},
			{item = 'ammo-38', min = 6, max = 12, chance = 20}, 
			{item = 'ammo-44', min = 6, max = 12, chance = 20}, 
			{item = 'ammo-45', min = 30, max = 60, chance = 10}, 	
			{item = 'ammo-9', min = 30, max = 60, chance = 10}, 
			{item = 'ammo-rifle', min = 30, max = 60, chance = 5},
			{item = 'ammo-rifle2', min = 30, max = 60, chance = 5},
			{item = 'ammo-shotgun', min = 12, max = 24, chance = 30},
			{item = 'ammo-sniper', min = 1, max = 2, chance = 10},
			{item = 'ammo-heavysniper', min = 1, max = 2, chance = 10},
			{item = 'ammo-rocket', min = 1, max = 1, chance = 5},
			{item = 'weapon_grenade', min = 1, max = 2, chance = 5},
			{item = 'weapon_pipebomb', min = 1, max = 1, chance = 5},
			{item = 'weapon_bzgas', min = 1, max = 2, chance = 5},
			{item = 'weapon_molotov', min = 1, max = 2, chance = 10},
			{item = 'weapon_flare', min = 1, max = 5, chance = 40},
			{item = 'weapon_smokegrenade', min = 1, max = 1, chance = 40},
			{item = 'weapon_stickybomb', min = 1, max = 1, chance = 1},
			{item = 'weapon_proxmine', min = 1, max = 1, chance = 1},
		--Pistols--
			{item = 'weapon_stungun', min = 1, max = 1, chance = 50},
			{item = 'weapon_flaregun', min = 1, max = 1, chance = 50},
			{item = 'weapon_vintagepistol', min = 1, max = 1, chance = 40},
			{item = 'weapon_ceramicpistol', min = 1, max = 1, chance = 40},
			{item = 'weapon_vintagepistol', min = 1, max = 1, chance = 40},
			{item = 'weapon_pistol', min = 1, max = 1, chance = 30},
			{item = 'weapon_pistolxm3', min = 1, max = 1, chance = 20},
			{item = 'weapon_combatpistol', min = 1, max = 1, chance = 10},
			{item = 'weapon_heavypistol', min = 1, max = 1, chance = 10},
			{item = 'weapon_pistol_mk2', min = 1, max = 1, chance = 5},
			{item = 'weapon_pistol50', min = 1, max = 1, chance = 20},
			{item = 'weapon_navyrevolver', min = 1, max = 1, chance = 20},
			{item = 'weapon_doubleaction', min = 1, max = 1, chance = 20},
			{item = 'weapon_revolver', min = 1, max = 1, chance = 20},
		--SMGS & Rifles--
			{item = 'weapon_tecpistol', min = 1, max = 1, chance = 20},
			{item = 'weapon_smg', min = 1, max = 1, chance = 15},
			{item = 'weapon_microsmg', min = 1, max = 1, chance = 15},
			{item = 'weapon_combatpdw', min = 1, max = 1, chance = 15},
			{item = 'weapon_compactrifle', min = 1, max = 1, chance = 15},
			{item = 'weapon_assaultrifle', min = 1, max = 1, chance = 10},
			{item = 'weapon_assaultrifle_mk2', min = 1, max = 1, chance = 1},
			{item = 'weapon_compactrifle', min = 1, max = 1, chance = 15},
			{item = 'weapon_heavyrifle', min = 1, max = 1, chance = 8},
			{item = 'weapon_tacticalrifle', min = 1, max = 1, chance = 5},
			{item = 'weapon_battlerifle', min = 1, max = 1, chance = 3},
		--Shotguns & Heavy--
			{item = 'weapon_dbshotgun', min = 1, max = 1, chance = 25},
			{item = 'weapon_sawnoffshotgun', min = 1, max = 1, chance = 20},
			{item = 'weapon_pumpshotgun', min = 1, max = 1, chance = 20},
			{item = 'weapon_pumpshotgun_mk2', min = 1, max = 1, chance = 5},
			{item = 'weapon_heavyshotgun', min = 1, max = 1, chance = 5},
			{item = 'weapon_bullpupshotgun', min = 1, max = 1, chance = 10},
			{item = 'weapon_combatshotgun', min = 1, max = 1, chance = 8},
			{item = 'weapon_assaultshotgun', min = 1, max = 1, chance = 1},
			{item = 'weapon_marksmanrifle', min = 1, max = 1, chance = 1},
			{item = 'weapon_sniperrifle', min = 1, max = 1, chance = 1},
			{item = 'weapon_heavysniper', min = 1, max = 1, chance = 1},
			{item = 'weapon_heaysniper_mk2', min = 1, max = 1, chance = 1},
			{item = 'weapon_rpg', min = 1, max = 1, chance = 1},
			{item = 'weapon_mg', min = 1, max = 1, chance = 1},
			{item = 'weapon_combatmg', min = 1, max = 1, chance = 1},
			{item = 'weapon_combatmg_mk2', min = 1, max = 1, chance = 1},
        }
    },

    toxic = {
        models = { 
            "a_m_m_salton_02" 
        },
        damage = 5,
        armor = 0,
        speed = 2.0,
        ragdollChance = 1,
        clipsets = {"move_m@drunk@verydrunk"},
        sound = "smoke.ogg",
        special = "smoke",
        smoke_duration = 3000,
        smoke_interval = 5000,
        density = 0.1,

        loot = {
		--Junk Items--
			{item = 'plastic', min = 5, max = 10, chance = 80},
			{item = 'glass', min = 5, max = 15, chance = 80},
			{item = 'rubber', min = 10, max = 20, chance = 80},
			{item = 'paperbag', min = 5, max = 10, chance = 80},
			{item = 'garbage', min = 5, max = 15, chance = 80},
			{item = 'metalscrap', min = 10, max = 20, chance = 80},			
			{item = 'lighter', min = 1, max = 5, chance = 60},
			{item = 'binoculars', min = 1, max = 1, chance = 60},
			{item = 'stickynote', min = 1, max = 1, chance = 60},
			{item = 'trojan_usb', min = 1, max = 1, chance = 30},
			{item = 'cryptostick', min = 1, max = 1, chance = 30},
			{item = 'radio', min = 1, max = 1, chance = 10},
			{item = 'radiocell', min = 1, max = 1, chance = 10},
			{item = 'phone', min = 1, max = 1, chance = 10},
			{item = 'tablet', min = 1, max = 1, chance = 10},
			{item = 'laptop', min = 1, max = 1, chance = 10},
			{item = 'lockpick', min = 1, max = 1, chance = 10},
			{item = 'advancedlockpick', min = 1, max = 1, chance = 10},
			{item = 'electronickit', min = 1, max = 1, chance = 10},
			{item = 'repairkit', min = 1, max = 1, chance = 10},
			{item = 'advancedrepairkit', min = 1, max = 1, chance = 10},
			{item = 'drill', min = 1, max = 1, chance = 10},
			{item = 'screwdriverset', min = 1, max = 1, chance = 10},
			{item = 'security_card_01', min = 1, max = 1, chance = 1},
			{item = 'security_card_02', min = 1, max = 1, chance = 1},
			{item = 'thermite', min = 1, max = 3, chance = 5},
			{item = 'empty_evidence_bag', min = 1, max = 1, chance = 1},
			{item = 'harness', min = 1, max = 1, chance = 1},
			{item = 'handcuffs', min = 1, max = 1, chance = 1},
			{item = 'diving_gear', min = 1, max = 1, chance = 1},
			{item = 'diving_fill', min = 1, max = 1, chance = 1},			
		--Medical Items--
			{item = 'painkillers', min = 1, max = 1, chance = 1}, --The Cure--
			{item = 'firstaid', min = 1, max = 1, chance = 3},
			{item = 'ifaks', min = 1, max = 1, chance = 5},
			{item = 'bandage', min = 1, max = 3, chance = 5},
			{item = 'armour', min = 1, max = 1, chance = 5},
		--Food Items--
			{item = 'water', min = 1, max = 5, chance = 5},
			{item = 'coffee', min = 1, max = 1, chance = 10},
			{item = 'grapejuice', min = 1, max = 1, chance = 10},
			{item = 'cola', min = 1, max = 1, chance = 10},
			{item = 'sprunk', min = 1, max = 1, chance = 10},
			{item = 'whiskey', min = 1, max = 1, chance = 10},
			{item = 'vodka', min = 1, max = 1, chance = 10},
			{item = 'beer', min = 1, max = 1, chance = 10},
			{item = 'burger', min = 1, max = 5, chance = 5},
			{item = 'sandwich', min = 1, max = 5, chance = 10},
		--Ammo Items--
			{item = 'ammo-flare', min = 1, max = 5, chance = 30},
			{item = 'ammo-22', min = 15, max = 30, chance = 20},
			{item = 'ammo-38', min = 6, max = 12, chance = 20}, 
			{item = 'ammo-44', min = 6, max = 12, chance = 20}, 
			{item = 'ammo-45', min = 30, max = 60, chance = 10}, 	
			{item = 'ammo-9', min = 30, max = 60, chance = 10}, 
			{item = 'ammo-rifle', min = 30, max = 60, chance = 5},
			{item = 'ammo-rifle2', min = 30, max = 60, chance = 5},
			{item = 'ammo-shotgun', min = 12, max = 24, chance = 30},
			{item = 'ammo-sniper', min = 1, max = 2, chance = 10},
			{item = 'ammo-heavysniper', min = 1, max = 2, chance = 10},
			{item = 'ammo-rocket', min = 1, max = 1, chance = 5},
			{item = 'weapon_grenade', min = 1, max = 2, chance = 5},
			{item = 'weapon_pipebomb', min = 1, max = 1, chance = 5},
			{item = 'weapon_bzgas', min = 1, max = 2, chance = 5},
			{item = 'weapon_molotov', min = 1, max = 2, chance = 10},
			{item = 'weapon_flare', min = 1, max = 5, chance = 40},
			{item = 'weapon_smokegrenade', min = 1, max = 1, chance = 40},
			{item = 'weapon_stickybomb', min = 1, max = 1, chance = 1},
			{item = 'weapon_proxmine', min = 1, max = 1, chance = 1},
		--Pistols--
			{item = 'weapon_stungun', min = 1, max = 1, chance = 50},
			{item = 'weapon_flaregun', min = 1, max = 1, chance = 50},
			{item = 'weapon_vintagepistol', min = 1, max = 1, chance = 40},
			{item = 'weapon_ceramicpistol', min = 1, max = 1, chance = 40},
			{item = 'weapon_vintagepistol', min = 1, max = 1, chance = 40},
			{item = 'weapon_pistol', min = 1, max = 1, chance = 30},
			{item = 'weapon_pistolxm3', min = 1, max = 1, chance = 20},
			{item = 'weapon_combatpistol', min = 1, max = 1, chance = 10},
			{item = 'weapon_heavypistol', min = 1, max = 1, chance = 10},
			{item = 'weapon_pistol_mk2', min = 1, max = 1, chance = 5},
			{item = 'weapon_pistol50', min = 1, max = 1, chance = 20},
			{item = 'weapon_navyrevolver', min = 1, max = 1, chance = 20},
			{item = 'weapon_doubleaction', min = 1, max = 1, chance = 20},
			{item = 'weapon_revolver', min = 1, max = 1, chance = 20},
		--SMGS & Rifles--
			{item = 'weapon_tecpistol', min = 1, max = 1, chance = 20},
			{item = 'weapon_smg', min = 1, max = 1, chance = 15},
			{item = 'weapon_microsmg', min = 1, max = 1, chance = 15},
			{item = 'weapon_combatpdw', min = 1, max = 1, chance = 15},
			{item = 'weapon_compactrifle', min = 1, max = 1, chance = 15},
			{item = 'weapon_assaultrifle', min = 1, max = 1, chance = 10},
			{item = 'weapon_assaultrifle_mk2', min = 1, max = 1, chance = 1},
			{item = 'weapon_compactrifle', min = 1, max = 1, chance = 15},
			{item = 'weapon_heavyrifle', min = 1, max = 1, chance = 8},
			{item = 'weapon_tacticalrifle', min = 1, max = 1, chance = 5},
			{item = 'weapon_battlerifle', min = 1, max = 1, chance = 3},
		--Shotguns & Heavy--
			{item = 'weapon_dbshotgun', min = 1, max = 1, chance = 25},
			{item = 'weapon_sawnoffshotgun', min = 1, max = 1, chance = 20},
			{item = 'weapon_pumpshotgun', min = 1, max = 1, chance = 20},
			{item = 'weapon_pumpshotgun_mk2', min = 1, max = 1, chance = 5},
			{item = 'weapon_heavyshotgun', min = 1, max = 1, chance = 5},
			{item = 'weapon_bullpupshotgun', min = 1, max = 1, chance = 10},
			{item = 'weapon_combatshotgun', min = 1, max = 1, chance = 8},
			{item = 'weapon_assaultshotgun', min = 1, max = 1, chance = 1},
			{item = 'weapon_marksmanrifle', min = 1, max = 1, chance = 1},
			{item = 'weapon_sniperrifle', min = 1, max = 1, chance = 1},
			{item = 'weapon_heavysniper', min = 1, max = 1, chance = 1},
			{item = 'weapon_heaysniper_mk2', min = 1, max = 1, chance = 1},
			{item = 'weapon_rpg', min = 1, max = 1, chance = 1},
			{item = 'weapon_mg', min = 1, max = 1, chance = 1},
			{item = 'weapon_combatmg', min = 1, max = 1, chance = 1},
			{item = 'weapon_combatmg_mk2', min = 1, max = 1, chance = 1},
        }
    },

    electric = {
        models = { 
            "a_m_m_tennis_01" 
        },
        damage = 10,
        armor = 0,
        speed = 2.0,
        ragdollChance = 1,
        clipsets = {"move_m@drunk@verydrunk"},
        sound = "electric.ogg",
        special = "electric",
        electric_duration = 1000,
        electric_interval = 5000,
        electricDamage = 20,
        density = 0.1,

        loot = {
		--Junk Items--
			{item = 'plastic', min = 5, max = 10, chance = 80},
			{item = 'glass', min = 5, max = 15, chance = 80},
			{item = 'rubber', min = 10, max = 20, chance = 80},
			{item = 'paperbag', min = 5, max = 10, chance = 80},
			{item = 'garbage', min = 5, max = 15, chance = 80},
			{item = 'metalscrap', min = 10, max = 20, chance = 80},			
			{item = 'lighter', min = 1, max = 5, chance = 60},
			{item = 'binoculars', min = 1, max = 1, chance = 60},
			{item = 'stickynote', min = 1, max = 1, chance = 60},
			{item = 'trojan_usb', min = 1, max = 1, chance = 30},
			{item = 'cryptostick', min = 1, max = 1, chance = 30},
			{item = 'radio', min = 1, max = 1, chance = 10},
			{item = 'radiocell', min = 1, max = 1, chance = 10},
			{item = 'phone', min = 1, max = 1, chance = 10},
			{item = 'tablet', min = 1, max = 1, chance = 10},
			{item = 'laptop', min = 1, max = 1, chance = 10},
			{item = 'lockpick', min = 1, max = 1, chance = 10},
			{item = 'advancedlockpick', min = 1, max = 1, chance = 10},
			{item = 'electronickit', min = 1, max = 1, chance = 10},
			{item = 'repairkit', min = 1, max = 1, chance = 10},
			{item = 'advancedrepairkit', min = 1, max = 1, chance = 10},
			{item = 'drill', min = 1, max = 1, chance = 10},
			{item = 'screwdriverset', min = 1, max = 1, chance = 10},
			{item = 'security_card_01', min = 1, max = 1, chance = 1},
			{item = 'security_card_02', min = 1, max = 1, chance = 1},
			{item = 'thermite', min = 1, max = 3, chance = 5},
			{item = 'empty_evidence_bag', min = 1, max = 1, chance = 1},
			{item = 'harness', min = 1, max = 1, chance = 1},
			{item = 'handcuffs', min = 1, max = 1, chance = 1},
			{item = 'diving_gear', min = 1, max = 1, chance = 1},
			{item = 'diving_fill', min = 1, max = 1, chance = 1},			
		--Medical Items--
			{item = 'painkillers', min = 1, max = 1, chance = 1}, --The Cure--
			{item = 'firstaid', min = 1, max = 1, chance = 3},
			{item = 'ifaks', min = 1, max = 1, chance = 5},
			{item = 'bandage', min = 1, max = 3, chance = 5},
			{item = 'armour', min = 1, max = 1, chance = 5},
		--Food Items--
			{item = 'water', min = 1, max = 5, chance = 5},
			{item = 'coffee', min = 1, max = 1, chance = 10},
			{item = 'grapejuice', min = 1, max = 1, chance = 10},
			{item = 'cola', min = 1, max = 1, chance = 10},
			{item = 'sprunk', min = 1, max = 1, chance = 10},
			{item = 'whiskey', min = 1, max = 1, chance = 10},
			{item = 'vodka', min = 1, max = 1, chance = 10},
			{item = 'beer', min = 1, max = 1, chance = 10},
			{item = 'burger', min = 1, max = 5, chance = 5},
			{item = 'sandwich', min = 1, max = 5, chance = 10},
		--Ammo Items--
			{item = 'ammo-flare', min = 1, max = 5, chance = 30},
			{item = 'ammo-22', min = 15, max = 30, chance = 20},
			{item = 'ammo-38', min = 6, max = 12, chance = 20}, 
			{item = 'ammo-44', min = 6, max = 12, chance = 20}, 
			{item = 'ammo-45', min = 30, max = 60, chance = 10}, 	
			{item = 'ammo-9', min = 30, max = 60, chance = 10}, 
			{item = 'ammo-rifle', min = 30, max = 60, chance = 5},
			{item = 'ammo-rifle2', min = 30, max = 60, chance = 5},
			{item = 'ammo-shotgun', min = 12, max = 24, chance = 30},
			{item = 'ammo-sniper', min = 1, max = 2, chance = 10},
			{item = 'ammo-heavysniper', min = 1, max = 2, chance = 10},
			{item = 'ammo-rocket', min = 1, max = 1, chance = 5},
			{item = 'weapon_grenade', min = 1, max = 2, chance = 5},
			{item = 'weapon_pipebomb', min = 1, max = 1, chance = 5},
			{item = 'weapon_bzgas', min = 1, max = 2, chance = 5},
			{item = 'weapon_molotov', min = 1, max = 2, chance = 10},
			{item = 'weapon_flare', min = 1, max = 5, chance = 40},
			{item = 'weapon_smokegrenade', min = 1, max = 1, chance = 40},
			{item = 'weapon_stickybomb', min = 1, max = 1, chance = 1},
			{item = 'weapon_proxmine', min = 1, max = 1, chance = 1},
		--Pistols--
			{item = 'weapon_stungun', min = 1, max = 1, chance = 50},
			{item = 'weapon_flaregun', min = 1, max = 1, chance = 50},
			{item = 'weapon_vintagepistol', min = 1, max = 1, chance = 40},
			{item = 'weapon_ceramicpistol', min = 1, max = 1, chance = 40},
			{item = 'weapon_vintagepistol', min = 1, max = 1, chance = 40},
			{item = 'weapon_pistol', min = 1, max = 1, chance = 30},
			{item = 'weapon_pistolxm3', min = 1, max = 1, chance = 20},
			{item = 'weapon_combatpistol', min = 1, max = 1, chance = 10},
			{item = 'weapon_heavypistol', min = 1, max = 1, chance = 10},
			{item = 'weapon_pistol_mk2', min = 1, max = 1, chance = 5},
			{item = 'weapon_pistol50', min = 1, max = 1, chance = 20},
			{item = 'weapon_navyrevolver', min = 1, max = 1, chance = 20},
			{item = 'weapon_doubleaction', min = 1, max = 1, chance = 20},
			{item = 'weapon_revolver', min = 1, max = 1, chance = 20},
		--SMGS & Rifles--
			{item = 'weapon_tecpistol', min = 1, max = 1, chance = 20},
			{item = 'weapon_smg', min = 1, max = 1, chance = 15},
			{item = 'weapon_microsmg', min = 1, max = 1, chance = 15},
			{item = 'weapon_combatpdw', min = 1, max = 1, chance = 15},
			{item = 'weapon_compactrifle', min = 1, max = 1, chance = 15},
			{item = 'weapon_assaultrifle', min = 1, max = 1, chance = 10},
			{item = 'weapon_assaultrifle_mk2', min = 1, max = 1, chance = 1},
			{item = 'weapon_compactrifle', min = 1, max = 1, chance = 15},
			{item = 'weapon_heavyrifle', min = 1, max = 1, chance = 8},
			{item = 'weapon_tacticalrifle', min = 1, max = 1, chance = 5},
			{item = 'weapon_battlerifle', min = 1, max = 1, chance = 3},
		--Shotguns & Heavy--
			{item = 'weapon_dbshotgun', min = 1, max = 1, chance = 25},
			{item = 'weapon_sawnoffshotgun', min = 1, max = 1, chance = 20},
			{item = 'weapon_pumpshotgun', min = 1, max = 1, chance = 20},
			{item = 'weapon_pumpshotgun_mk2', min = 1, max = 1, chance = 5},
			{item = 'weapon_heavyshotgun', min = 1, max = 1, chance = 5},
			{item = 'weapon_bullpupshotgun', min = 1, max = 1, chance = 10},
			{item = 'weapon_combatshotgun', min = 1, max = 1, chance = 8},
			{item = 'weapon_assaultshotgun', min = 1, max = 1, chance = 1},
			{item = 'weapon_marksmanrifle', min = 1, max = 1, chance = 1},
			{item = 'weapon_sniperrifle', min = 1, max = 1, chance = 1},
			{item = 'weapon_heavysniper', min = 1, max = 1, chance = 1},
			{item = 'weapon_heaysniper_mk2', min = 1, max = 1, chance = 1},
			{item = 'weapon_rpg', min = 1, max = 1, chance = 1},
			{item = 'weapon_mg', min = 1, max = 1, chance = 1},
			{item = 'weapon_combatmg', min = 1, max = 1, chance = 1},
			{item = 'weapon_combatmg_mk2', min = 1, max = 1, chance = 1},
        }
    },

    jumper = {
        models = {
            "a_m_m_beach_01"
        },
        damage = 15,
        armor = 0,
        speed = 2.5,
        ragdollChance = 1,
        clipsets = {"move_m@drunk@verydrunk"},
        sound = "super_jump.ogg",
        special = "super_jump",
        jump_interval = 5000,
        density = 0.1,

        loot = {
		--Junk Items--
			{item = 'plastic', min = 5, max = 10, chance = 80},
			{item = 'glass', min = 5, max = 15, chance = 80},
			{item = 'rubber', min = 10, max = 20, chance = 80},
			{item = 'paperbag', min = 5, max = 10, chance = 80},
			{item = 'garbage', min = 5, max = 15, chance = 80},
			{item = 'metalscrap', min = 10, max = 20, chance = 80},			
			{item = 'lighter', min = 1, max = 5, chance = 60},
			{item = 'binoculars', min = 1, max = 1, chance = 60},
			{item = 'stickynote', min = 1, max = 1, chance = 60},
			{item = 'trojan_usb', min = 1, max = 1, chance = 30},
			{item = 'cryptostick', min = 1, max = 1, chance = 30},
			{item = 'radio', min = 1, max = 1, chance = 10},
			{item = 'radiocell', min = 1, max = 1, chance = 10},
			{item = 'phone', min = 1, max = 1, chance = 10},
			{item = 'tablet', min = 1, max = 1, chance = 10},
			{item = 'laptop', min = 1, max = 1, chance = 10},
			{item = 'lockpick', min = 1, max = 1, chance = 10},
			{item = 'advancedlockpick', min = 1, max = 1, chance = 10},
			{item = 'electronickit', min = 1, max = 1, chance = 10},
			{item = 'repairkit', min = 1, max = 1, chance = 10},
			{item = 'advancedrepairkit', min = 1, max = 1, chance = 10},
			{item = 'drill', min = 1, max = 1, chance = 10},
			{item = 'screwdriverset', min = 1, max = 1, chance = 10},
			{item = 'security_card_01', min = 1, max = 1, chance = 1},
			{item = 'security_card_02', min = 1, max = 1, chance = 1},
			{item = 'thermite', min = 1, max = 3, chance = 5},
			{item = 'empty_evidence_bag', min = 1, max = 1, chance = 1},
			{item = 'harness', min = 1, max = 1, chance = 1},
			{item = 'handcuffs', min = 1, max = 1, chance = 1},
			{item = 'diving_gear', min = 1, max = 1, chance = 1},
			{item = 'diving_fill', min = 1, max = 1, chance = 1},			
		--Medical Items--
			{item = 'painkillers', min = 1, max = 1, chance = 1}, --The Cure--
			{item = 'firstaid', min = 1, max = 1, chance = 3},
			{item = 'ifaks', min = 1, max = 1, chance = 5},
			{item = 'bandage', min = 1, max = 3, chance = 5},
			{item = 'armour', min = 1, max = 1, chance = 5},
		--Food Items--
			{item = 'water', min = 1, max = 5, chance = 5},
			{item = 'coffee', min = 1, max = 1, chance = 10},
			{item = 'grapejuice', min = 1, max = 1, chance = 10},
			{item = 'cola', min = 1, max = 1, chance = 10},
			{item = 'sprunk', min = 1, max = 1, chance = 10},
			{item = 'whiskey', min = 1, max = 1, chance = 10},
			{item = 'vodka', min = 1, max = 1, chance = 10},
			{item = 'beer', min = 1, max = 1, chance = 10},
			{item = 'burger', min = 1, max = 5, chance = 5},
			{item = 'sandwich', min = 1, max = 5, chance = 10},
		--Ammo Items--
			{item = 'ammo-flare', min = 1, max = 5, chance = 30},
			{item = 'ammo-22', min = 15, max = 30, chance = 20},
			{item = 'ammo-38', min = 6, max = 12, chance = 20}, 
			{item = 'ammo-44', min = 6, max = 12, chance = 20}, 
			{item = 'ammo-45', min = 30, max = 60, chance = 10}, 	
			{item = 'ammo-9', min = 30, max = 60, chance = 10}, 
			{item = 'ammo-rifle', min = 30, max = 60, chance = 5},
			{item = 'ammo-rifle2', min = 30, max = 60, chance = 5},
			{item = 'ammo-shotgun', min = 12, max = 24, chance = 30},
			{item = 'ammo-sniper', min = 1, max = 2, chance = 10},
			{item = 'ammo-heavysniper', min = 1, max = 2, chance = 10},
			{item = 'ammo-rocket', min = 1, max = 1, chance = 5},
			{item = 'weapon_grenade', min = 1, max = 2, chance = 5},
			{item = 'weapon_pipebomb', min = 1, max = 1, chance = 5},
			{item = 'weapon_bzgas', min = 1, max = 2, chance = 5},
			{item = 'weapon_molotov', min = 1, max = 2, chance = 10},
			{item = 'weapon_flare', min = 1, max = 5, chance = 40},
			{item = 'weapon_smokegrenade', min = 1, max = 1, chance = 40},
			{item = 'weapon_stickybomb', min = 1, max = 1, chance = 1},
			{item = 'weapon_proxmine', min = 1, max = 1, chance = 1},
		--Pistols--
			{item = 'weapon_stungun', min = 1, max = 1, chance = 50},
			{item = 'weapon_flaregun', min = 1, max = 1, chance = 50},
			{item = 'weapon_vintagepistol', min = 1, max = 1, chance = 40},
			{item = 'weapon_ceramicpistol', min = 1, max = 1, chance = 40},
			{item = 'weapon_vintagepistol', min = 1, max = 1, chance = 40},
			{item = 'weapon_pistol', min = 1, max = 1, chance = 30},
			{item = 'weapon_pistolxm3', min = 1, max = 1, chance = 20},
			{item = 'weapon_combatpistol', min = 1, max = 1, chance = 10},
			{item = 'weapon_heavypistol', min = 1, max = 1, chance = 10},
			{item = 'weapon_pistol_mk2', min = 1, max = 1, chance = 5},
			{item = 'weapon_pistol50', min = 1, max = 1, chance = 20},
			{item = 'weapon_navyrevolver', min = 1, max = 1, chance = 20},
			{item = 'weapon_doubleaction', min = 1, max = 1, chance = 20},
			{item = 'weapon_revolver', min = 1, max = 1, chance = 20},
		--SMGS & Rifles--
			{item = 'weapon_tecpistol', min = 1, max = 1, chance = 20},
			{item = 'weapon_smg', min = 1, max = 1, chance = 15},
			{item = 'weapon_microsmg', min = 1, max = 1, chance = 15},
			{item = 'weapon_combatpdw', min = 1, max = 1, chance = 15},
			{item = 'weapon_compactrifle', min = 1, max = 1, chance = 15},
			{item = 'weapon_assaultrifle', min = 1, max = 1, chance = 10},
			{item = 'weapon_assaultrifle_mk2', min = 1, max = 1, chance = 1},
			{item = 'weapon_compactrifle', min = 1, max = 1, chance = 15},
			{item = 'weapon_heavyrifle', min = 1, max = 1, chance = 8},
			{item = 'weapon_tacticalrifle', min = 1, max = 1, chance = 5},
			{item = 'weapon_battlerifle', min = 1, max = 1, chance = 3},
		--Shotguns & Heavy--
			{item = 'weapon_dbshotgun', min = 1, max = 1, chance = 25},
			{item = 'weapon_sawnoffshotgun', min = 1, max = 1, chance = 20},
			{item = 'weapon_pumpshotgun', min = 1, max = 1, chance = 20},
			{item = 'weapon_pumpshotgun_mk2', min = 1, max = 1, chance = 5},
			{item = 'weapon_heavyshotgun', min = 1, max = 1, chance = 5},
			{item = 'weapon_bullpupshotgun', min = 1, max = 1, chance = 10},
			{item = 'weapon_combatshotgun', min = 1, max = 1, chance = 8},
			{item = 'weapon_assaultshotgun', min = 1, max = 1, chance = 1},
			{item = 'weapon_marksmanrifle', min = 1, max = 1, chance = 1},
			{item = 'weapon_sniperrifle', min = 1, max = 1, chance = 1},
			{item = 'weapon_heavysniper', min = 1, max = 1, chance = 1},
			{item = 'weapon_heaysniper_mk2', min = 1, max = 1, chance = 1},
			{item = 'weapon_rpg', min = 1, max = 1, chance = 1},
			{item = 'weapon_mg', min = 1, max = 1, chance = 1},
			{item = 'weapon_combatmg', min = 1, max = 1, chance = 1},
			{item = 'weapon_combatmg_mk2', min = 1, max = 1, chance = 1},
        }
    }
}

------------------------------------------------------------------------------------------------------
-- ZOMBIES | GENERAL SETTINGS
------------------------------------------------------------------------------------------------------

-- Lvl  ----------------------------------------------------------------------------------------------
Config.ZombieLevels = {
    [1] = { extraHealth = 0,   extraArmor = 0,   extraSpeed = 0.0,  extraDamage = 0 },
    [2] = { extraHealth = 50,  extraArmor = 20,  extraSpeed = 0.2,  extraDamage = 5 },
    [3] = { extraHealth = 100, extraArmor = 50,  extraSpeed = 0.5,  extraDamage = 10 }
}

Config.MinZombieLevel = 1
Config.MaxZombieLevel = 3

Config.ShowZombieHealthBar = true
Config.ShowZombieLevel = true

-- Infection -----------------------------------------------------------------------------------------
Config.Infection = {
    chance = 100, -- % to be infected by zombie (30%)
    duration = 600000, -- How long will it be
    cureItem = "painkillers", -- Cure item name
    visualEffect = "dying",  -- Visual effect (TimeCycleModifier)
    visualTransitionStep = 0.05,
    visualTransitionDelay = 100,
    coughAnimation = {
        dict = "timetable@gardener@smoking_joint",
        anim = "idle_cough",
        duration = 3000,
        flag = 49,
        interval = 10000
    },
    DamagePerInterval = 15, -- How much health will be reduced by timelapse.
    DamageInterval = 10000 -- Timelapse
}

-- Zombie Blips ---------------------------------------------------------------------------------------
Config.ShowZombieBlips = true
Config.ZombieBlipRadius = 80.0
Config.ZombieBlip = {
    Sprite = 630, -- Icon
    Colour = 1,
    Scale = 0.9,
    Name = "Zombie"
}

-- Spawn ----------------------------------------------------------------------------------------------
Config.SpawnRadius = 50.0
Config.ZombieAttackInterval = 1000
Config.DespawnTime = 15000
Config.MaxZombiesPerPlayer = 10

-- Eating ---------------------------------------------------------------------------------------------
Config.EatingDistance = 1.0

-- Vehicles -------------------------------------------------------------------------------------------
Config.ZombiesCanPullOut = false -- Zombies can pull out players from vehicle
Config.PullOutChance = 50 -- How probably is
Config.VehicleDamageOnAttack = 25
Config.VehicleAttackDistance = 1.5  -- Distance to get vehicle damage by zombies around
Config.VehiclePullOutDistance = 3.0
Config.PushForce = 2.0 -- Push force for vehicle by zombies
Config.DistanceTarget = 5.0

-- Vision ---------------------------------------------------------------------------------------------
Config.DayVisionDistance = 80.0
Config.NightVisionDistance = 40.0
Config.SearchTime = 10000

-- Audio ----------------------------------------------------------------------------------------------
Config.HearingRadius = 250.0 -- General hearing distance by zombies
Config.NoiseMemoryTime = 15000 -- How long zombies will remember your last location
Config.FootstepsNoiseRadius = 30.0
Config.VehicleHighSpeedNoise = 100.0
Config.VehicleSpeedThreshold = 15.0 -- m/s | If you are up this, it will be detected as vehicle noise
Config.ClaxonNoiseRadius = 80.0
Config.CollisionNoiseRadius = 120.0
Config.CollisionSpeedDrop = 10.0 -- If you are up this, it will be detected as vehicle colision noise
Config.AttackRadius = 500.0 -- If one zombie is under attack by players, zombies around this radius will detect you

------------------------------------------------------------------------------------------------------
-- LOOT SETTINGS
------------------------------------------------------------------------------------------------------
Config.EnableZombieLoot = true

Config.LootMode = "zombie" -- Loot mode: "global" or "zombie"

Config.LootKey = 38 -- E = 38 on GTA KeyMapping
Config.LootDistance = 4.0

Config.ZombieLootItems = {
		--Junk Items--
			{item = 'plastic', min = 5, max = 10, chance = 80},
			{item = 'glass', min = 5, max = 15, chance = 80},
			{item = 'rubber', min = 10, max = 20, chance = 80},
			{item = 'paperbag', min = 5, max = 10, chance = 80},
			{item = 'garbage', min = 5, max = 15, chance = 80},
			{item = 'metalscrap', min = 10, max = 20, chance = 80},			
			{item = 'lighter', min = 1, max = 5, chance = 60},
			{item = 'binoculars', min = 1, max = 1, chance = 60},
			{item = 'stickynote', min = 1, max = 1, chance = 60},
			{item = 'trojan_usb', min = 1, max = 1, chance = 30},
			{item = 'cryptostick', min = 1, max = 1, chance = 30},
			{item = 'radio', min = 1, max = 1, chance = 10},
			{item = 'radiocell', min = 1, max = 1, chance = 10},
			{item = 'phone', min = 1, max = 1, chance = 10},
			{item = 'tablet', min = 1, max = 1, chance = 10},
			{item = 'laptop', min = 1, max = 1, chance = 10},
			{item = 'lockpick', min = 1, max = 1, chance = 10},
			{item = 'advancedlockpick', min = 1, max = 1, chance = 10},
			{item = 'electronickit', min = 1, max = 1, chance = 10},
			{item = 'repairkit', min = 1, max = 1, chance = 10},
			{item = 'advancedrepairkit', min = 1, max = 1, chance = 10},
			{item = 'drill', min = 1, max = 1, chance = 10},
			{item = 'screwdriverset', min = 1, max = 1, chance = 10},
			{item = 'security_card_01', min = 1, max = 1, chance = 1},
			{item = 'security_card_02', min = 1, max = 1, chance = 1},
			{item = 'thermite', min = 1, max = 3, chance = 5},
			{item = 'empty_evidence_bag', min = 1, max = 1, chance = 1},
			{item = 'harness', min = 1, max = 1, chance = 1},
			{item = 'handcuffs', min = 1, max = 1, chance = 1},
			{item = 'diving_gear', min = 1, max = 1, chance = 1},
			{item = 'diving_fill', min = 1, max = 1, chance = 1},			
		--Medical Items--
			{item = 'painkillers', min = 1, max = 1, chance = 1}, --The Cure--
			{item = 'firstaid', min = 1, max = 1, chance = 3},
			{item = 'ifaks', min = 1, max = 1, chance = 5},
			{item = 'bandage', min = 1, max = 3, chance = 5},
			{item = 'armour', min = 1, max = 1, chance = 5},
		--Food Items--
			{item = 'water', min = 1, max = 5, chance = 5},
			{item = 'coffee', min = 1, max = 1, chance = 10},
			{item = 'grapejuice', min = 1, max = 1, chance = 10},
			{item = 'cola', min = 1, max = 1, chance = 10},
			{item = 'sprunk', min = 1, max = 1, chance = 10},
			{item = 'whiskey', min = 1, max = 1, chance = 10},
			{item = 'vodka', min = 1, max = 1, chance = 10},
			{item = 'beer', min = 1, max = 1, chance = 10},
			{item = 'burger', min = 1, max = 5, chance = 5},
			{item = 'sandwich', min = 1, max = 5, chance = 10},
		--Ammo Items--
			{item = 'ammo-flare', min = 1, max = 5, chance = 30},
			{item = 'ammo-22', min = 15, max = 30, chance = 20},
			{item = 'ammo-38', min = 6, max = 12, chance = 20}, 
			{item = 'ammo-44', min = 6, max = 12, chance = 20}, 
			{item = 'ammo-45', min = 30, max = 60, chance = 10}, 	
			{item = 'ammo-9', min = 30, max = 60, chance = 10}, 
			{item = 'ammo-rifle', min = 30, max = 60, chance = 5},
			{item = 'ammo-rifle2', min = 30, max = 60, chance = 5},
			{item = 'ammo-shotgun', min = 12, max = 24, chance = 30},
			{item = 'ammo-sniper', min = 1, max = 2, chance = 10},
			{item = 'ammo-heavysniper', min = 1, max = 2, chance = 10},
			{item = 'ammo-rocket', min = 1, max = 1, chance = 5},
			{item = 'weapon_grenade', min = 1, max = 2, chance = 5},
			{item = 'weapon_pipebomb', min = 1, max = 1, chance = 5},
			{item = 'weapon_bzgas', min = 1, max = 2, chance = 5},
			{item = 'weapon_molotov', min = 1, max = 2, chance = 10},
			{item = 'weapon_flare', min = 1, max = 5, chance = 40},
			{item = 'weapon_smokegrenade', min = 1, max = 1, chance = 40},
			{item = 'weapon_stickybomb', min = 1, max = 1, chance = 1},
			{item = 'weapon_proxmine', min = 1, max = 1, chance = 1},
		--Pistols--
			{item = 'weapon_stungun', min = 1, max = 1, chance = 50},
			{item = 'weapon_flaregun', min = 1, max = 1, chance = 50},
			{item = 'weapon_vintagepistol', min = 1, max = 1, chance = 40},
			{item = 'weapon_ceramicpistol', min = 1, max = 1, chance = 40},
			{item = 'weapon_vintagepistol', min = 1, max = 1, chance = 40},
			{item = 'weapon_pistol', min = 1, max = 1, chance = 30},
			{item = 'weapon_pistolxm3', min = 1, max = 1, chance = 20},
			{item = 'weapon_combatpistol', min = 1, max = 1, chance = 10},
			{item = 'weapon_heavypistol', min = 1, max = 1, chance = 10},
			{item = 'weapon_pistol_mk2', min = 1, max = 1, chance = 5},
			{item = 'weapon_pistol50', min = 1, max = 1, chance = 20},
			{item = 'weapon_navyrevolver', min = 1, max = 1, chance = 20},
			{item = 'weapon_doubleaction', min = 1, max = 1, chance = 20},
			{item = 'weapon_revolver', min = 1, max = 1, chance = 20},
		--SMGS & Rifles--
			{item = 'weapon_tecpistol', min = 1, max = 1, chance = 20},
			{item = 'weapon_smg', min = 1, max = 1, chance = 15},
			{item = 'weapon_microsmg', min = 1, max = 1, chance = 15},
			{item = 'weapon_combatpdw', min = 1, max = 1, chance = 15},
			{item = 'weapon_compactrifle', min = 1, max = 1, chance = 15},
			{item = 'weapon_assaultrifle', min = 1, max = 1, chance = 10},
			{item = 'weapon_assaultrifle_mk2', min = 1, max = 1, chance = 1},
			{item = 'weapon_compactrifle', min = 1, max = 1, chance = 15},
			{item = 'weapon_heavyrifle', min = 1, max = 1, chance = 8},
			{item = 'weapon_tacticalrifle', min = 1, max = 1, chance = 5},
			{item = 'weapon_battlerifle', min = 1, max = 1, chance = 3},
		--Shotguns & Heavy--
			{item = 'weapon_dbshotgun', min = 1, max = 1, chance = 25},
			{item = 'weapon_sawnoffshotgun', min = 1, max = 1, chance = 20},
			{item = 'weapon_pumpshotgun', min = 1, max = 1, chance = 20},
			{item = 'weapon_pumpshotgun_mk2', min = 1, max = 1, chance = 5},
			{item = 'weapon_heavyshotgun', min = 1, max = 1, chance = 5},
			{item = 'weapon_bullpupshotgun', min = 1, max = 1, chance = 10},
			{item = 'weapon_combatshotgun', min = 1, max = 1, chance = 8},
			{item = 'weapon_assaultshotgun', min = 1, max = 1, chance = 1},
			{item = 'weapon_marksmanrifle', min = 1, max = 1, chance = 1},
			{item = 'weapon_sniperrifle', min = 1, max = 1, chance = 1},
			{item = 'weapon_heavysniper', min = 1, max = 1, chance = 1},
			{item = 'weapon_heaysniper_mk2', min = 1, max = 1, chance = 1},
			{item = 'weapon_rpg', min = 1, max = 1, chance = 1},
			{item = 'weapon_mg', min = 1, max = 1, chance = 1},
			{item = 'weapon_combatmg', min = 1, max = 1, chance = 1},
			{item = 'weapon_combatmg_mk2', min = 1, max = 1, chance = 1},
}

------------------------------------------------------------------------------------------------------
-- PROP LOOT
------------------------------------------------------------------------------------------------------
Config.LootKey = 38 -- E

Config.PropLoot = {
    ["prop_dumpster_01a"] = {
        cooldown = 60,
        globalMin = 1,
        globalMax = 3,
        items = {
		--Junk Items--
			{item = 'plastic', min = 5, max = 10, chance = 80},
			{item = 'glass', min = 5, max = 15, chance = 80},
			{item = 'rubber', min = 10, max = 20, chance = 80},
			{item = 'paperbag', min = 5, max = 10, chance = 80},
			{item = 'garbage', min = 5, max = 15, chance = 80},
			{item = 'metalscrap', min = 10, max = 20, chance = 80},			
			{item = 'lighter', min = 1, max = 5, chance = 60},
			{item = 'binoculars', min = 1, max = 1, chance = 60},
			{item = 'stickynote', min = 1, max = 1, chance = 60},
			{item = 'trojan_usb', min = 1, max = 1, chance = 30},
			{item = 'cryptostick', min = 1, max = 1, chance = 30},
			{item = 'radio', min = 1, max = 1, chance = 10},
			{item = 'radiocell', min = 1, max = 1, chance = 10},
			{item = 'phone', min = 1, max = 1, chance = 10},
			{item = 'tablet', min = 1, max = 1, chance = 10},
			{item = 'laptop', min = 1, max = 1, chance = 10},
			{item = 'lockpick', min = 1, max = 1, chance = 10},
			{item = 'advancedlockpick', min = 1, max = 1, chance = 10},
			{item = 'electronickit', min = 1, max = 1, chance = 10},
			{item = 'repairkit', min = 1, max = 1, chance = 10},
			{item = 'advancedrepairkit', min = 1, max = 1, chance = 10},
			{item = 'drill', min = 1, max = 1, chance = 10},
			{item = 'screwdriverset', min = 1, max = 1, chance = 10},
			{item = 'security_card_01', min = 1, max = 1, chance = 1},
			{item = 'security_card_02', min = 1, max = 1, chance = 1},
			{item = 'thermite', min = 1, max = 3, chance = 5},
			{item = 'empty_evidence_bag', min = 1, max = 1, chance = 1},
			{item = 'harness', min = 1, max = 1, chance = 1},
			{item = 'handcuffs', min = 1, max = 1, chance = 1},
			{item = 'diving_gear', min = 1, max = 1, chance = 1},
			{item = 'diving_fill', min = 1, max = 1, chance = 1},			
		--Medical Items--
			{item = 'painkillers', min = 1, max = 1, chance = 1}, --The Cure--
			{item = 'firstaid', min = 1, max = 1, chance = 3},
			{item = 'ifaks', min = 1, max = 1, chance = 5},
			{item = 'bandage', min = 1, max = 3, chance = 5},
			{item = 'armour', min = 1, max = 1, chance = 5},
		--Food Items--
			{item = 'water', min = 1, max = 5, chance = 5},
			{item = 'coffee', min = 1, max = 1, chance = 10},
			{item = 'grapejuice', min = 1, max = 1, chance = 10},
			{item = 'cola', min = 1, max = 1, chance = 10},
			{item = 'sprunk', min = 1, max = 1, chance = 10},
			{item = 'whiskey', min = 1, max = 1, chance = 10},
			{item = 'vodka', min = 1, max = 1, chance = 10},
			{item = 'beer', min = 1, max = 1, chance = 10},
			{item = 'burger', min = 1, max = 5, chance = 5},
			{item = 'sandwich', min = 1, max = 5, chance = 10},
		--Ammo Items--
			{item = 'ammo-flare', min = 1, max = 5, chance = 30},
			{item = 'ammo-22', min = 15, max = 30, chance = 20},
			{item = 'ammo-38', min = 6, max = 12, chance = 20}, 
			{item = 'ammo-44', min = 6, max = 12, chance = 20}, 
			{item = 'ammo-45', min = 30, max = 60, chance = 10}, 	
			{item = 'ammo-9', min = 30, max = 60, chance = 10}, 
			{item = 'ammo-rifle', min = 30, max = 60, chance = 5},
			{item = 'ammo-rifle2', min = 30, max = 60, chance = 5},
			{item = 'ammo-shotgun', min = 12, max = 24, chance = 30},
			{item = 'ammo-sniper', min = 1, max = 2, chance = 10},
			{item = 'ammo-heavysniper', min = 1, max = 2, chance = 10},
			{item = 'ammo-rocket', min = 1, max = 1, chance = 5},
			{item = 'weapon_grenade', min = 1, max = 2, chance = 5},
			{item = 'weapon_pipebomb', min = 1, max = 1, chance = 5},
			{item = 'weapon_bzgas', min = 1, max = 2, chance = 5},
			{item = 'weapon_molotov', min = 1, max = 2, chance = 10},
			{item = 'weapon_flare', min = 1, max = 5, chance = 40},
			{item = 'weapon_smokegrenade', min = 1, max = 1, chance = 40},
			{item = 'weapon_stickybomb', min = 1, max = 1, chance = 1},
			{item = 'weapon_proxmine', min = 1, max = 1, chance = 1},
		--Pistols--
			{item = 'weapon_stungun', min = 1, max = 1, chance = 50},
			{item = 'weapon_flaregun', min = 1, max = 1, chance = 50},
			{item = 'weapon_vintagepistol', min = 1, max = 1, chance = 40},
			{item = 'weapon_ceramicpistol', min = 1, max = 1, chance = 40},
			{item = 'weapon_vintagepistol', min = 1, max = 1, chance = 40},
			{item = 'weapon_pistol', min = 1, max = 1, chance = 30},
			{item = 'weapon_pistolxm3', min = 1, max = 1, chance = 20},
			{item = 'weapon_combatpistol', min = 1, max = 1, chance = 10},
			{item = 'weapon_heavypistol', min = 1, max = 1, chance = 10},
			{item = 'weapon_pistol_mk2', min = 1, max = 1, chance = 5},
			{item = 'weapon_pistol50', min = 1, max = 1, chance = 20},
			{item = 'weapon_navyrevolver', min = 1, max = 1, chance = 20},
			{item = 'weapon_doubleaction', min = 1, max = 1, chance = 20},
			{item = 'weapon_revolver', min = 1, max = 1, chance = 20},
		--SMGS & Rifles--
			{item = 'weapon_tecpistol', min = 1, max = 1, chance = 20},
			{item = 'weapon_smg', min = 1, max = 1, chance = 15},
			{item = 'weapon_microsmg', min = 1, max = 1, chance = 15},
			{item = 'weapon_combatpdw', min = 1, max = 1, chance = 15},
			{item = 'weapon_compactrifle', min = 1, max = 1, chance = 15},
			{item = 'weapon_assaultrifle', min = 1, max = 1, chance = 10},
			{item = 'weapon_assaultrifle_mk2', min = 1, max = 1, chance = 1},
			{item = 'weapon_compactrifle', min = 1, max = 1, chance = 15},
			{item = 'weapon_heavyrifle', min = 1, max = 1, chance = 8},
			{item = 'weapon_tacticalrifle', min = 1, max = 1, chance = 5},
			{item = 'weapon_battlerifle', min = 1, max = 1, chance = 3},
		--Shotguns & Heavy--
			{item = 'weapon_dbshotgun', min = 1, max = 1, chance = 25},
			{item = 'weapon_sawnoffshotgun', min = 1, max = 1, chance = 20},
			{item = 'weapon_pumpshotgun', min = 1, max = 1, chance = 20},
			{item = 'weapon_pumpshotgun_mk2', min = 1, max = 1, chance = 5},
			{item = 'weapon_heavyshotgun', min = 1, max = 1, chance = 5},
			{item = 'weapon_bullpupshotgun', min = 1, max = 1, chance = 10},
			{item = 'weapon_combatshotgun', min = 1, max = 1, chance = 8},
			{item = 'weapon_assaultshotgun', min = 1, max = 1, chance = 1},
			{item = 'weapon_marksmanrifle', min = 1, max = 1, chance = 1},
			{item = 'weapon_sniperrifle', min = 1, max = 1, chance = 1},
			{item = 'weapon_heavysniper', min = 1, max = 1, chance = 1},
			{item = 'weapon_heaysniper_mk2', min = 1, max = 1, chance = 1},
			{item = 'weapon_rpg', min = 1, max = 1, chance = 1},
			{item = 'weapon_mg', min = 1, max = 1, chance = 1},
			{item = 'weapon_combatmg', min = 1, max = 1, chance = 1},
			{item = 'weapon_combatmg_mk2', min = 1, max = 1, chance = 1},
        }
    },

    -- Add more here
}

------------------------------------------------------------------------------------------------------
-- SAFEZONES & REDZONES
------------------------------------------------------------------------------------------------------
Config.SpawnZoneMode = "zombie"  -- Spawn zones mode: "global" o "zombie"

-- Blips ---------------------------------------------------------------------------------------------

Config.ShowRedZoneBlips = true

Config.RedZoneBlip = {
    Sprite = 310,
    Colour = 1,
    Scale = 1.0,
    Name = "Redzone"
}

Config.ShowSafeZoneBlips = true

Config.SafeZoneBlip = {
    Sprite = 305,
    Colour = 2,
    Scale = 1.0,
    Name = "Safezone"
}

-- ZONES --------------------------------------------------------------------------------------------

Config.RedZones = {
    -- CIRCLE ZONE
    {
        id = "circle_zone_1",
        type = "circle", -- use "circle" to identify as a circle blip with its radius.
        coords = vector3(-1975.6323, -638.2188, 5.6892),
        radius = 120.0,
        zTypes = { "normal", "fast", "explosive" },

        blip = {
            sprite = 310,
            colour = 1,
            scale  = 1.2,
            name   = "Zona Roja 1"
        }
    },

    -- ZONE POLYZONE
    {
        id = "poly_zone_1",
        type = "poly", -- use "poly" to identify as a custom zone by polyzone script
        points = {
            vector2(-1745.5881, -940.0174),
            vector2(-1809.3463, -970.5012),
            vector2(-1829.7374, -906.0463),
            vector2(-1781.0654, -867.1609)
        },
        minZ = -10.0,
        maxZ = 20.0,
        debug = true, -- Make Polyzone visible
        zTypes = { "toxic", "electric" },

        blip = {
            sprite = 310,
            colour = 3,
            scale  = 1.0,
            name   = "Zona Roja Poly"
        }
    }
}

Config.SafeZones = {
    -- CIRCLE ZONE
    {
        id = "safe_circle_1",
        type = "circle", -- use "circle" to identify as a circle blip with its radius.
        coords = vector3(-1832.7397, -797.3159, 6.9027),
        radius = 110.0,

        blip = {
            sprite = 305,
            colour = 2,
            scale  = 1.0,
            name   = "Safezone"
        }
    },

    -- ZONE POLYZONE
    {
        id = "safe_poly_1",
        type = "poly", -- use "poly" to identify as a custom zone by polyzone script
        points = {
            vector2(-47.1029, 34.9536),
            vector2(-23.9447, 26.2777),
            vector2(-4.8489, 61.1527),
            vector2(-36.1399, 74.5558) 
        },
        minZ = 60.0,
        maxZ = 100.0,
        debug = true, -- Make Polyzone visible
        blip = {
            sprite = 253,
            colour = 5,
            scale  = 1.0,
            name   = "PolySafeZone"
        }
    }
}

------------------------------------------------------------------------------------------------------
-- ZUPPORT TEAM
------------------------------------------------------------------------------------------------------

-- Zombies Relationship ------------------------------------------------------------------------------

Config.ZombieRelationshipGroup = "zombies" -- Name to identify the zombies group and config relationships

-- Allies Relationship -------------------------------------------------------------------------------
Config.Allies = {
    vehicleModel = "baller6",
    pedModels = {
        "cs_karen_daniels",
        "s_f_y_cop_01",
		"s_f_y_sheriff_01",
	    "s_m_m_fibsec_01",
        "s_m_m_ciasec_01",
		"s_m_y_cop_01"
    },
    weapons = {
        "WEAPON_COMBATPISTOL",
        "WEAPON_COMBATPDW",
        "WEAPON_SAWNOFFSHOTGUN"
    },
    SupportCooldown = 60000,
    maxAlliesInVehicle = 4,
    spawnRadius = 10.0,
    attackRange = 50.0,
    followDistance = 35.0,
    AllowAlliesRevive = true,
    relationshipGroup = "ALLIES"
}

------------------------------------------------------------------------------------------------------
-- ZOMBIE BOSSES
------------------------------------------------------------------------------------------------------
Config.BossBlips = true
Config.ShowBossZoneBlips = true
Config.BossRespawnCooldown = 60000
Config.BossCorpseLifetime = 120

Config.BossInfectionEnabled = false

Config.BossLoot = {
    distance  = 3.0,
    globalCooldown = 180,

    marker    = {
        type  = 27,
        scale = vec3(0.4,0.4,0.4),
        colour= {r = 200, g = 0, b = 0, a = 180}
    }
}

Config.BossZones = {
    -- CIRCLE ZONE
    {
        id = "boss_zone_1",
        type = "circle",
        coords = vector3(614.9282, -936.2230, 10.6631),
        radius = 80.0,
        model = "u_m_y_juggernaut_01",
        clipset = "MOVE_M@DRUNK@MODERATEDRUNK_HEAD_UP",
        health = 100000,
        armor = 1000,
        damage = 10,
        speed = 1.2,
        specialSound = "tank.ogg",
        special = "flameAura",
        abilityInterval = {min = 1000, max = 15000},
        maxBosses = 1,

        loot = {
            {item = 'goldbar',  min = 1, max = 3, chance = 70},
            {item = 'ammo-50',  min = 5, max = 8, chance = 50}
        },

        blip = {
            name = "Boss Zone",
            sprite = 310,
            colour = 1,
            scale = 1.0,
            bossSprite = 303,
            bossColour = 1,
            bossScale = 1.2,
            bossName = "Boss"
        }
    },

    -- ZONE POLY
    {
        id = "boss_zone_poly_1",
        type = "poly",
        points = {
            vector2(40.5319, 2.8175),
            vector2(-17.0917, 22.7232),
            vector2(-69.4557, -115.7497),
            vector2(68.5234, -169.9114)
        },
        minZ = 50.0,
        maxZ = 100.0,
        debug = true, -- Make Polyzone visible
        model = "u_m_y_mani",
        clipset = "MOVE_M@DRUNK@MODERATEDRUNK_HEAD_UP",
        health = 100,
        armor = 1000,
        damage = 10,
        speed = 1.2,
        specialSound = "tank.ogg",
        special = "flameAura",
        abilityInterval = {min = 1000, max = 15000},
        maxBosses = 1,

        loot = {
            {item = 'bread',  min = 1, max = 3, chance = 70},
            {item = 'ammo-50',  min = 5, max = 8, chance = 50}
        },

        blip = {
            name = "Boss Zone Poly",
            sprite = 310,
            colour = 5,
            scale = 1.0,
            bossSprite = 303,
            bossColour = 5,
            bossScale = 1.2,
            bossName = "Boss"
        }
    }
}