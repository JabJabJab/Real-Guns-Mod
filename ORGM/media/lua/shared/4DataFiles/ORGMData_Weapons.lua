--[[- This file contains all default firearm data.

All calls made by this script are to `ORGM.Firearm.register`. See the documention there.

@script ORGMData_Weapons.lua
@author Fenris_Wolf
@release 4.0
@copyright 2018 **File:** shared/4DataFiles/ORGMData_Weapons.lua

]]
local Firearm = ORGM.Firearm
local FirearmGroup = Firearm.FirearmGroup
local FirearmType = Firearm.FirearmType
local Flags = Firearm.Flags

-- Top level groups
FirearmGroup:new("Group_Main")
FirearmGroup:new("Group_RareCollectables")


FirearmGroup:new("Group_Classifications", { Groups = { Group_Main = 1, } })
FirearmGroup:new("Group_Pistols", { Groups = { Group_Classifications = 1, } })
FirearmGroup:new("Group_Revolvers", { Groups = { Group_Classifications = 1, } })
FirearmGroup:new("Group_Rifles", { Groups = { Group_Classifications = 1, } })
FirearmGroup:new("Group_Shotguns", { Groups = { Group_Classifications = 1, } })
FirearmGroup:new("Group_SubMachineGuns", { Groups = { Group_Classifications = 1, } })
FirearmGroup:new("Group_LightMachineGuns", { Groups = { Group_Classifications = 1, } })

FirearmGroup:new("Group_Manufacturers", { Groups = { Group_Main = 1, } })
FirearmGroup:new("Group_Colt", { Groups = { Group_Manufacturers = 1, } })

-- Mid level Groups - groups that are members of multiple groups
FirearmGroup:new("Group_Colt_Revolvers", { Groups = { Group_Colt = 1, Group_Revolvers = 1 } })
FirearmGroup:new("Group_Colt_Pistols", { Groups = { Group_Colt = 1, Group_Rifles = 1 } })
FirearmGroup:new("Group_Colt_Rifles", { Groups = { Group_Colt = 1, Group_Rifles = 1 } })

-- Bottom level groups
FirearmGroup:new("Group_Colt_Anaconda", { Groups = { Group_Colt_Revolvers = 1, } })
FirearmGroup:new("Group_Colt_CAR15", { Groups = { Group_Colt_Rifles = 1, } })



FirearmType:newCollection("Colt_M16", {
        -- sources:
        -- https://en.wikipedia.org/wiki/M16_rifle
        -- https://en.wikipedia.org/wiki/List_of_Colt_AR-15_%26_M16_rifle_variants
        -- https://en.wikipedia.org/wiki/CAR-15
        -- https://en.wikipedia.org/wiki/M4_carbine
        -- https://en.wikipedia.org/wiki/ArmaLite_AR-15
        -- https://en.wikipedia.org/wiki/Colt_AR-15
        Groups = { Group_Colt_CAR15 = 1 },
        lastChanged = 24,               category = ORGM.RIFLE,
        soundProfile = "Rifle-AR",      SwingSound = "ORGMAR15",
        ammoType = "MagGroup_STANAG",
        Weight = 3.3,                   barrelLength = 20,
        WeaponSprite = "m16",           Icon = "M16",

        classification = "IGUI_Firearm_AssaultRifle",
        country = "IGUI_Firearm_Country_US",
        manufacturer = "IGUI_Firearm_Manuf_Colt",
        description = "IGUI_Firearm_Desc_M16",
        feedSystem = Flags.AUTO + Flags.DIRECTGAS,
        features = Flags.DOUBLEACTION + Flags.SLIDELOCK + Flags.SAFETY + Flags.SELECTFIRE + Flags.SEMIAUTO,
    }, {
        M601 = { -- Colt AR-15 Model 601
            year = 1959,
            addGroups = { Group_Colt_CAR15 = 1 },
            addFeatures = Flags.FULLAUTO,
        },

        M604 = { -- Colt M16 Model 604
            year = 1964,
            addGroups = { Group_Colt_CAR15 = 1 },
            addFeatures = Flags.FULLAUTO,
        },
        M603 = { -- Colt M16A1 Model 603
            year = 1967,
            addGroups = { Group_Colt_CAR15 = 1 },
            addFeatures = Flags.FULLAUTO,
        },
        M605A = { -- Colt CAR-15 Carbine Model 605A
            year = 1962,
            addGroups = { Group_Colt_CAR15 = 1 },
            barrelLength = 15,
            addFeatures = Flags.FULLAUTO,
        },
        M605B = { -- Colt CAR-15 Carbine Model 605B
            year = 1966,
            addGroups = { Group_Colt_CAR15 = 1 },
            barrelLength = 15,
            addFeatures = Flags.FULLAUTO + Flags.BURST3,
        },
        M607 = { -- Colt CAR-15 SMG Model 607
            year = 1966,
            barrelLength = 10,
            addFeatures = Flags.FULLAUTO,
            addGroups = { Group_Colt_CAR15 = 1, Group_RareCollectables = 50, }, -- 50 manufactured
        },
        M645 = { -- M16A2 Colt Model 645
            year = 1982,
            addGroups = { Group_Colt_CAR15 = 1 },
            addFeatures = Flags.BURST3,
        },
        M646 = { -- M16A3 Colt Model 646
            year = 1982,
            addGroups = { Group_Colt_CAR15 = 1 },
            addFeatures = Flags.FULLAUTO,
        },
        M945 = { -- M16A4 Colt Model 945
            year = 1998,
            addGroups = { Group_Colt_CAR15 = 1 },
            addFeatures = Flags.BURST3,
        },
        M920 = { -- M4 Model 920
            barrelLength = 14.5,
            addGroups = { Group_Colt_CAR15 = 1 },
            addFeatures = Flags.BURST3,
            --classification = "IGUI_Firearm_AssaultCarbine",
            year = 1984,
            --country = "IGUI_Firearm_Country_US",
            --manufacturer = "IGUI_Firearm_Manuf_Colt",
            --description = "IGUI_Firearm_Desc_M4C",
        },
        M921 = { -- M4A1 Model 921
            barrelLength = 14.5,
            addGroups = { Group_Colt_CAR15 = 1 },
            addFeatures = Flags.FULLAUTO,
        },
        M933 = { -- M4 Commando Model 933
            barrelLength = 11.5,
            addGroups = { Group_Colt_CAR15 = 1 },
            addFeatures = Flags.FULLAUTO,
        },
        M935 = { -- M4 Commando Model 935
            barrelLength = 11.5,
            addGroups = { Group_Colt_CAR15 = 1 },
            addFeatures = Flags.BURST3,
        },
})
FirearmType:newCollection("Colt_Anaconda", {
        -- sources:
        -- http://www.coltfever.com/Anaconda.html
        -- https://en.wikipedia.org/wiki/Colt_Anaconda
        -- https://www.coltforum.com/forums/colt-revolvers/73849-anaconda-bsts-3-print.html
        -- https://www.coltforum.com/forums/colt-revolvers/46474-fyi-colt-model-numbers.html
        Groups = { Group_Revolvers = 1, Group_Colt_Anaconda = 1, },
        lastChanged = 24,               category = ORGM.REVOLVER,
        soundProfile = "Revolver",      SwingSound = "ORGMColtAnac",

        ammoType = "AmmoGroup_44Magnum", speedLoader = 'SpeedLoader446',
        Weight = 1.5,                   barrelLength = 6,
        WeaponSprite = "coltanaconda",  Icon = "ColtAnac",
        maxCapacity = 6,

        classification = "IGUI_Firearm_Revolver",
        year = 1990,
        country = "IGUI_Firearm_Country_US",
        manufacturer = "IGUI_Firearm_Manuf_Colt",
        description = "IGUI_Firearm_Desc_ColtAnac",

        features = Flags.SINGLEACTION + Flags.DOUBLEACTION + Flags.SAFETY,
        feedSystem = Flags.ROTARY,
    },{
        MM3040 = { --  Anaconda Revolver 44 Magnum 4" SS
            barrelLength = 4,       Weight = 1.3,
        },
        MM3040DT = {  --  Anaconda Revolver 44 Magnum 4" SS (Drilled & Tapped)
            barrelLength = 4,       Weight = 1.3,
        },
        MM3040MP = {  --  Anaconda Revolver 44 Magnum 4" SS Mag-Na-Ported
            barrelLength = 4,       Weight = 1.3,
        },
        MM3040KD = { -- Kodiak Revolver 44 Magnum 4" SS Mag-Na-Ported
            barrelLength = 4,       Weight = 1.3,
            year = 1993,
            addGroups = {Group_RareCollectables = 1000,}, -- 1000 manufactured
        },
        MM3050 = { -- Anaconda Revolver 44 Magnum 5" ONLY 150 MANUFACTURERED
            barrelLength = 5,       Weight = 1.4,
            addGroups = {Group_RareCollectables = 150,}, -- 150 manufactured
        },
        MM3060 = { -- Anaconda Revolver 44 Magnum 6" SS
        },
        MM3060DT = { -- Anaconda Revolver 44 Magnum 6" SS (Drilled & Tapped)
        },
        MM3060MP = { -- Anaconda Revolver 44 Magnum 6" SS Mag-Na-Ported
        },
        MM3060KD = { -- Kodiak Revolver 44 Magnum 6" SS Mag-Na-Ported
            year = 1993,
            addGroups = {Group_RareCollectables = 1000,}, -- 1000 manufactured
        },
        MM3061FE = { -- Anaconda First Edition Revolver 44 magnum 6" Bright SS
            year = 1990,
            addGroups = {Group_RareCollectables = 1000,}, -- 1000 manufactured
        },
        MM3080 = { -- Anaconda Revolver 44 Magnum 8" SS
            barrelLength = 8,       Weight = 1.7,
        },
        MM3080L = { -- Colt Limited Edition Anaconda Legacy Model MM3080
            -- 24K Gold embellishments and Black Pearl Titanium finish.
            -- This model number is probably wrong, but i need some sort of model prefix.
            -- The model number on the factory box simply reads MM3080
            year = 1993,
            barrelLength = 8,       Weight = 1.7,
            addGroups = {Group_RareCollectables = 1000,}, -- 1000 manufactured
        },
        MM3080DT = { -- Anaconda Revolver 44 Magnum 8" SS (Drilled & Tapped)
            barrelLength = 8,       Weight = 1.7,
        },
        MM3080MP = { -- Anaconda Revolver 44 Magnum 8" SS Mag-Na-Ported
            barrelLength = 8,       Weight = 1.7,
        },
        MM3080HT = { -- Anaconda Revolver 44 Magnum 8" SS (Hunter)
            year = 1991,
            barrelLength = 8,       Weight = 1.7,
        },
        MM3080PDT = { -- Anaconda Revolver 44 Magnum 8" Ported SS ProPorting
            year = 1991,
            barrelLength = 8,       Weight = 1.7,
        },
        MM3080RT = { -- Anaconda Realtree Revolver 44 Magnum 8" Camo
            year = 1996,
            addFeatures = Flags.NOSIGHTS,
            barrelLength = 8,       Weight = 1.7,
        },
        MM4540 = { -- Anaconda Revolver 45 Colt 4" SS VERY RARE
            year = 1993,
            barrelLength = 4,       Weight = 1.3,
            ammoType = "AmmoGroup_45Colt",
            speedLoader = nil,
            addGroups = {Group_RareCollectables = 100,},
        },
        MM4560 = { -- Anaconda Revolver 45 Colt 6" SS
            year = 1993,
            ammoType = "AmmoGroup_45Colt",
            speedLoader = nil,
        },
        MM4580 = { -- Anaconda Revolver 45 Colt 8" SS
            year = 1993,
            ammoType = "AmmoGroup_45Colt",
            barrelLength = 8,       Weight = 1.7,
            speedLoader = nil,
        },
    }
)
FirearmType:newCollection("Colt_Python", {
        -- sources:
        -- https://en.wikipedia.org/wiki/Colt_Python
        -- http://www.coltfever.com/Python.html
        -- https://www.handgunsmag.com/editorial/colt_python_complete_history/138916
        -- https://www.coltforum.com/forums/python/71904-3-python-question-5.html
        -- https://www.coltforum.com/forums/colt-revolvers/46474-fyi-colt-model-numbers.html
        Groups = { Group_Revolvers = 1, Group_Colt_Python = 1, },
        lastChanged = 24,               category = ORGM.REVOLVER,
        soundProfile = "Revolver",      SwingSound = "ORGMColtPyth",

        ammoType = "AmmoGroup_357Magnum", speedLoader = 'SpeedLoader3576',
        Weight = 1.1,                   barrelLength = 6,
        WeaponSprite = "coltpython",    Icon = "ColtAnac",
        maxCapacity = 6,
        --38 ounces (1.1 kg) to 48 ounces (1.4 kg)

        classification = "IGUI_Firearm_Revolver",
        year = 1955,
        country = "IGUI_Firearm_Country_US",
        manufacturer = "IGUI_Firearm_Manuf_Colt",
        description = "IGUI_Firearm_Desc_ColtPyth",

        features = Flags.SINGLEACTION + Flags.DOUBLEACTION + Flags.SAFETY,
        feedSystem = Flags.ROTARY,
        --barrelLengthOpt = { 2.5, 3, 4, 6, 8},
    },{

        I1986 = { -- Double Diamond Python Model I1986
            -- 6" Bright SS
            --A stainless steel Ultimate polish six inch Python and an Officer's Model ACP .45, smooth rosewood grips, presentation cased.
            year = 1986,
        },
        -- I3020 Python Revolver 357 Magnum 2-1/2" SS
        I3020 = {
        },
        -- I3021 Python Revolver 357 Magnum 2-1/2" Bright SS
        I3021 = {
        },

        I3030 = { -- Colt Combat Python Model I3030
            -- 3" SS
            --2003 a handful? of 3" Stainless guns were produced by Colt for Carol Wilkerson.
            -- given colt reporting a total of 1100 3" inchers, 500 of which are "combat pythons"
            -- (I3630 and I3631) and 300 for the I3630CP, maybe 300 produced for this one as well?
            year = 2003,
        },
        -- I3040 Python Revolver 357 Magnum 4" SS
        I3040 = {
        },

        I3040CS = { -- Colt Python Elite Model I3040CS
            -- 4" SS
            year = 1997,
        },
        -- I3041 Python Revolver 357 Magnum 4" Bright SS
        I3041 = {
        },
        -- I3060 Python Revolver 357 Magnum 6" SS
        I3060 = {
        },

        I3060CS = { -- Colt Python Elite Model I3060CS
            -- 6" SS
            year = 1997,
        },
        I3060ESS = { -- Colt Python Silver Snake Model I3060ESS
            --   6" SS -- 250 produced
            year = 1983,
        },
        -- I3061 Python Revolver 357 Magnum 6" Bright SS
        I3061 = {
        },
        -- I3080 Python Revolver 357 Magnum 8" SS (1980?)
        I3080 = {
        },
        -- I3081 Python Revolver 357 Magnum 8" Bright SS (1980?)
        I3081 = {
        },

        -- I3620 Python Revolver 357 Magnum 2-1/2" Blue
        I3620 = {
        },


        I3620SE = { -- Colt Python Snake Eyes Model I3620SE
            -- 2-1/2" Blue
            year = 1989, -- 500 produced
        },
        I3621SE = { -- Colt Python Snake Eyes Model I3621SE
            -- 2-1/2" Bright SS
            year = 1989, -- 500 produced
        },
        I3630 = { -- Colt Combat Python Model I3630
            -- 3" Blue
            -- 200 produced by Pacific International. 8" Target model cut and rechambered
            -- 1983 colt used this model number themselves, 500 produced by colt (K serial number)
            year = 1980,
        },
        I3630CP = { -- Colt Combat Python Model I3630CP
            -- 3" Blue
            -- 1987-88 Colt produces 300 3" Combat Pythons for Lew Horton
            year = 1987,
        },
        I3631 = { -- Colt Combat Python Model I3631
            -- 3" Nickel
            -- 50 produced by Pacific International. 8" Target model cut and rechambered
            -- 1983 colt used this model number themselves, 23 produced by colt (K serial number)
            year = 1980,
        },
        -- I3640 Python Revolver 357 Magnum 4" Blue
        I3640 = {
        },
        I3640CS = { -- Colt Python Elite Model I3640CS
            -- 4" Blued
            year = 1997,
        },

        -- I3660 Python Revolver 357 Magnum 6" Blue (1979?)
        I3660 = {
        },
        I3660CS = { -- Colt Python Elite Model I3660CS
            -- 6" Blue
            year = 1997,
        },
        I3660H = { -- Colt Custom Python Model I3660H
            -- 6" Blue - Custom Tuned with Elliason Sights
            year = 1980,
        },
        -- I3661 Python Revolver 357 Magnum 6" Nickel
        I3661 = {
        },

        I3680 = { -- Colt Python Hunter Model I3680
            --  8" Blue (note: this might not be the  hunter, info is sketchy)
            year = 1981,
            barrelLength = 8,
        },
        I3681 = { -- Colt Python Silhouette Model I3681
            --  8" Blue (note: pure assumption here, i'm guesing the model number)
            year = 1983,
            barrelLength = 8,
        },
        I3682 = { -- Colt Python Target Model I3682
            -- 38 Special 8" Blue -- 3,489 produced
            year = 1980,
            barrelLength = 8,
        },
        I3683 = { -- Colt Python Target Model I3683
            -- 38 Special 8" Nickel -- 251 produced
            year = 1980,
            barrelLength = 8,
        },
        -- I3840 Python Revolver 357 Magnum 4" Electroless Nickel
        I3840 = {
        },

    }
)--[[
register("ColtSAA", {
    features = Flags.SINGLEACTION + Flags.SAFETY,
    feedSystem = Flags.ROTARY,

    lastChanged = 24,
    category = ORGM.REVOLVER,
    barrelLength = 5.5,
    barrelLengthOpt = {5.5, 7.5 },
    isCivilian = ORGM.RARE,
    soundProfile = "Revolver",

    classification = "IGUI_Firearm_Revolver",
    year = 1873,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_Colt",
    description = "IGUI_Firearm_Desc_ColtSAA",
})
register("RugAlas", {
    features = Flags.SINGLEACTION + Flags.DOUBLEACTION + Flags.SAFETY,
    feedSystem = Flags.ROTARY,

    lastChanged = 24,
    category = ORGM.REVOLVER,
    barrelLength = 2.5,
    barrelLengthOpt = { 2.5, 7.5, 9.5 },
    isCivilian = ORGM.RARE,
    speedLoader = 'SpeedLoader4546',
    soundProfile = "Revolver",

    classification = "IGUI_Firearm_Revolver",
    year = 2005,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_Ruger",
    description = "IGUI_Firearm_Desc_RugAlas",
})
register("RugBH", {
    features = Flags.SINGLEACTION + Flags.SAFETY,
    feedSystem = Flags.ROTARY,

    lastChanged = 24,
    category = ORGM.REVOLVER,
    barrelLength = 4.65,
    barrelLengthOpt = { 4.65, 6.5, 7.5 },
    isCivilian = ORGM.RARE,
    soundProfile = "Revolver",

    classification = "IGUI_Firearm_Revolver",
    year = 1955,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_Ruger",
    description = "IGUI_Firearm_Desc_RugBH",
})
register("RugGP100", {
    features = Flags.SINGLEACTION + Flags.DOUBLEACTION + Flags.SAFETY,
    feedSystem = Flags.ROTARY,

    lastChanged = 24,
    category = ORGM.REVOLVER,
    barrelLength = 4.2,
    barrelLengthOpt = { 3, 4.2, 6 },
    isCivilian = ORGM.COMMON,
    speedLoader = 'SpeedLoader3576',
    soundProfile = "Revolver",

    classification = "IGUI_Firearm_Revolver",
    year = 1985,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_Ruger",
    description = "IGUI_Firearm_Desc_RugGP100",
})
register("RugRH", {
    features = Flags.SINGLEACTION + Flags.DOUBLEACTION + Flags.SAFETY,
    feedSystem = Flags.ROTARY,

    lastChanged = 24,
    category = ORGM.REVOLVER,
    barrelLength = 5.5,
    barrelLengthOpt = { 4, 5.5, 7.5 },
    isCivilian = ORGM.RARE,
    speedLoader = 'SpeedLoader446',
    soundProfile = "Revolver",

    classification = "IGUI_Firearm_Revolver",
    year = 1979,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_Ruger",
    description = "IGUI_Firearm_Desc_RugRH",
})
register("RugSec6", {
    features = Flags.SINGLEACTION + Flags.DOUBLEACTION + Flags.SAFETY,
    feedSystem = Flags.ROTARY,

    lastChanged = 24,
    category = ORGM.REVOLVER,
    barrelLength = 4,
    barrelLengthOpt = {2.74, 3, 4, 6},
    isCivilian = ORGM.COMMON,
    speedLoader = 'SpeedLoader386',
    soundProfile = "Revolver",

    classification = "IGUI_Firearm_Revolver",
    year = 1972,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_Ruger",
    description = "IGUI_Firearm_Desc_RugSec6",
})
register("SWM10", {
    features = Flags.SINGLEACTION + Flags.DOUBLEACTION + Flags.SAFETY,
    feedSystem = Flags.ROTARY,

    lastChanged = 24,
    category = ORGM.REVOLVER,
    barrelLength = 4,
    barrelLengthOpt = {2, 2.5, 3, 4, 5, 6},
    isCivilian = ORGM.COMMON,
    isPolice = ORGM.VERYRARE, -- old armory stock
    speedLoader = 'SpeedLoader386',
    soundProfile = "Revolver",

    classification = "IGUI_Firearm_Revolver",
    year = 1899,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_SW",
    description = "IGUI_Firearm_Desc_SWM10",
})
register("SWM19", {
    features = Flags.SINGLEACTION + Flags.DOUBLEACTION + Flags.SAFETY,
    feedSystem = Flags.ROTARY,

    lastChanged = 24,
    category = ORGM.REVOLVER,
    barrelLength = 4,
    barrelLengthOpt = {2.5, 3, 4, 6},
    isCivilian = ORGM.RARE,
    speedLoader = 'SpeedLoader3576',
    soundProfile = "Revolver",

    classification = "IGUI_Firearm_Revolver",
    year = 1957,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_SW",
    description = "IGUI_Firearm_Desc_SWM19",
})
register("SWM252", {
    features = Flags.SINGLEACTION + Flags.DOUBLEACTION + Flags.SAFETY,
    feedSystem = Flags.ROTARY,

    lastChanged = 24,
    category = ORGM.REVOLVER,
    barrelLength = 6, -- 4, 5 (very rare!), 6, 6.5, 8.4
    barrelLengthOpt = {4, 5, 6, 6.5, 8.4},
    isCivilian = ORGM.RARE,
    speedLoader = 'SpeedLoader456',
    soundProfile = "Revolver",

    classification = "IGUI_Firearm_Revolver",
    year = 1955,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_SW",
    description = "IGUI_Firearm_Desc_SWM252",
})
register("SWM29", {
    features = Flags.SINGLEACTION + Flags.DOUBLEACTION + Flags.SAFETY,
    feedSystem = Flags.ROTARY,

    lastChanged = 24,
    category = ORGM.REVOLVER,
    barrelLength = 6, -- 4, 6, 6.5, 8.425, 10.63
    barrelLengthOpt = { 4, 6, 6.5, 8.425, 10.63 },
    isCivilian = ORGM.COMMON,
    speedLoader = 'SpeedLoader446',
    soundProfile = "Revolver",

    classification = "IGUI_Firearm_Revolver",
    year = 1955,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_SW",
    description = "IGUI_Firearm_Desc_SWM29",
})
register("SWM36", {
    features = Flags.SINGLEACTION + Flags.DOUBLEACTION + Flags.SAFETY,
    feedSystem = Flags.ROTARY,

    lastChanged = 24,
    category = ORGM.REVOLVER,
    barrelLength = 1.875,
    barrelLengthOpt = { 1.875, 2, 3 },
    isCivilian = ORGM.COMMON,
    speedLoader = 'SpeedLoader385',
    soundProfile = "Revolver",

    classification = "IGUI_Firearm_Revolver",
    year = 1950,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_SW",
    description = "IGUI_Firearm_Desc_SWM36",
})
register("SWM610", {
    features = Flags.SINGLEACTION + Flags.DOUBLEACTION + Flags.SAFETY,
    feedSystem = Flags.ROTARY,

    lastChanged = 24,
    category = ORGM.REVOLVER,
    barrelLength = 6.5, -- 3.875, 6.5
    barrelLengthOpt = { 3.875, 6.5 },
    isCivilian = ORGM.RARE,
    speedLoader = 'SpeedLoader10mm6',
    soundProfile = "Revolver",

    classification = "IGUI_Firearm_Revolver",
    year = 1990,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_SW",
    description = "IGUI_Firearm_Desc_SWM610",
})
register("Taurus454", {
    features = Flags.SINGLEACTION + Flags.DOUBLEACTION + Flags.SAFETY,
    feedSystem = Flags.ROTARY,

    lastChanged = 25,
    category = ORGM.REVOLVER,
    barrelLength = 6.5, -- 2.25, 3, 4, 5, 6, 6.5, 8.425, 10
    barrelLengthOpt = { 2.25, 3, 4, 5, 6, 6.5, 8.425, 10 },
    isCivilian = ORGM.RARE,
    --speedLoader = 'SpeedLoader4546',
    soundProfile = "Revolver",

    classification = "IGUI_Firearm_Revolver",
    year = 1997,
    country = "IGUI_Firearm_Country_BR",
    manufacturer = "IGUI_Firearm_Manuf_Taurus",
    description = "IGUI_Firearm_Desc_Taurus454",
})
    --************************************************************************--
    -- semi pistols
    --************************************************************************--
register("AutomagV", {
    features = Flags.SINGLEACTION + Flags.SAFETY + Flags.SLIDELOCK,
    feedSystem = Flags.AUTO + Flags.DELAYEDBLOWBACK,

    lastChanged = 24,
    category = ORGM.PISTOL,
    barrelLength = 6.5, -- no aditional lengths
    isCivilian = ORGM.RARE,
    soundProfile = "Pistol-Large",

    classification = "IGUI_Firearm_SemiPistol",
    year = 1993,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_AMT",
    description = "IGUI_Firearm_Desc_AutomagV"
})
register("BBPistol", {
    features = Flags.DOUBLEACTION + Flags.SAFETY,
    feedSystem = Flags.AUTO + Flags.SHORTGAS,

    lastChanged = 24,
    category = ORGM.PISTOL,
    barrelLength = 8,
    isCivilian = ORGM.COMMON,
    soundProfile = "Pistol-Small",

    classification = "IGUI_Firearm_AirPistol",
    year = 2007, -- unknown, earliest reference i can find for this model dates to 2008
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_Daisy",
    description = "IGUI_Firearm_Desc_BBPistol",
})
register("Ber92", {
    features = Flags.SINGLEACTION + Flags.DOUBLEACTION + Flags.SAFETY + Flags.SLIDELOCK,
    feedSystem = Flags.AUTO + Flags.SHORTRECOIL,

    lastChanged = 24,
    category = ORGM.PISTOL,
    barrelLength = 4.9, -- 4.7 an 4.3 for other variants (not FS)
    isCivilian = ORGM.COMMON,
    isPolice = ORGM.COMMON,
    isMilitary = ORGM.COMMON,
    soundProfile = "Pistol-Small",

    classification = "IGUI_Firearm_SemiPistol",
    year = 1975,
    country = "IGUI_Firearm_Country_IT",
    manufacturer = "IGUI_Firearm_Manuf_Beretta",
    description = "IGUI_Firearm_Desc_Ber92",
})
register("BrenTen", {
    features = Flags.SINGLEACTION + Flags.DOUBLEACTION + Flags.SAFETY + Flags.SLIDELOCK,
    feedSystem = Flags.AUTO + Flags.SHORTRECOIL,

    lastChanged = 24,
    category = ORGM.PISTOL,
    barrelLength = 5,
    isCivilian = ORGM.RARE,
    soundProfile = "Pistol-Small",

    classification = "IGUI_Firearm_SemiPistol",
    year = 1983,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_Dixon",
    description = "IGUI_Firearm_Desc_BrenTen",
})
register("BrownHP", {
    features = Flags.SINGLEACTION + Flags.SAFETY + Flags.SLIDELOCK,
    feedSystem = Flags.AUTO + Flags.SHORTRECOIL,

    lastChanged = 24,
    category = ORGM.PISTOL,
    barrelLength = 4.7,
    isCivilian = ORGM.COMMON,
    soundProfile = "Pistol-Small",

    classification = "IGUI_Firearm_SemiPistol",
    year = 1935,
    country = "IGUI_Firearm_Country_BE",
    manufacturer = "IGUI_Firearm_Manuf_FN",
    description = "IGUI_Firearm_Desc_BrownHP",
})
register("Colt38S", {
    features = Flags.SINGLEACTION + Flags.SAFETY + Flags.SLIDELOCK,
    feedSystem = Flags.AUTO + Flags.SHORTRECOIL,

    lastChanged = 24,
    category = ORGM.PISTOL,
    barrelLength = 4.5,
    isCivilian = ORGM.RARE,
    soundProfile = "Pistol-Small",

    classification = "IGUI_Firearm_SemiPistol",
    year = 1950,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_Colt",
    description = "IGUI_Firearm_Desc_Colt38S",
})
register("ColtDelta", {
    features = Flags.SINGLEACTION + Flags.SAFETY + Flags.SLIDELOCK,
    feedSystem = Flags.AUTO + Flags.SHORTRECOIL,

    lastChanged = 24,
    category = ORGM.PISTOL,
    barrelLength = 5.03,
    isCivilian = ORGM.RARE,
    soundProfile = "Pistol-Small",

    classification = "IGUI_Firearm_SemiPistol",
    year = 1987,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_Colt",
    description = "IGUI_Firearm_Desc_ColtDelta",
})
register("CZ75", {
    features = Flags.SINGLEACTION + Flags.DOUBLEACTION + Flags.SAFETY + Flags.SLIDELOCK,
    feedSystem = Flags.AUTO + Flags.SHORTRECOIL,

    lastChanged = 24,
    category = ORGM.PISTOL,
    barrelLength = 4.7,
    isCivilian = ORGM.COMMON,
    soundProfile = "Pistol-Small",

    classification = "IGUI_Firearm_SemiPistol",
    year = 1975,
    country = "IGUI_Firearm_Country_CZ",
    manufacturer = "IGUI_Firearm_Manuf_CZUB",
    description = "IGUI_Firearm_Desc_CZ75",
})
register("DEagle", {
    features = Flags.SINGLEACTION + Flags.SAFETY + Flags.SLIDELOCK,
    feedSystem = Flags.AUTO + Flags.SHORTGAS,

    lastChanged = 24,
    category = ORGM.PISTOL,
    barrelLength = 10,
    barrelLengthOpt = { 6, 10, 14 },
    isCivilian = ORGM.RARE,
    soundProfile = "Pistol-Large",

    classification = "IGUI_Firearm_SemiPistol",
    year = 1982,
    country = "IGUI_Firearm_Country_USIL",
    manufacturer = "IGUI_Firearm_Manuf_IMI",
    description = "IGUI_Firearm_Desc_DEagle",
})
register("DEagleXIX", {
    features = Flags.SINGLEACTION + Flags.SAFETY + Flags.SLIDELOCK,
    feedSystem = Flags.AUTO + Flags.SHORTGAS,

    lastChanged = 24,
    category = ORGM.PISTOL,
    barrelLength = 10,
    barrelLengthOpt = { 6, 10 },
    isCivilian = ORGM.RARE,
    soundProfile = "Pistol-Large",

    classification = "IGUI_Firearm_SemiPistol",
    year = 1982,
    country = "IGUI_Firearm_Country_USIL",
    manufacturer = "IGUI_Firearm_Manuf_IMI",
    description = "IGUI_Firearm_Desc_DEagleXIX",
})
register("FN57", {
    -- depending on model, this can be SA (FN57 Tactical)
    features = Flags.DOUBLEACTION + Flags.SAFETY + Flags.SLIDELOCK,
    feedSystem = Flags.AUTO + Flags.DELAYEDBLOWBACK,

    lastChanged = 24,
    category = ORGM.PISTOL,
    barrelLength = 4.8,
    isCivilian = ORGM.VERYRARE,
    isMilitary = ORGM.RARE,
    soundProfile = "Pistol-Small",

    classification = "IGUI_Firearm_SemiPistol",
    year = 1998,
    country = "IGUI_Firearm_Country_BE",
    manufacturer = "IGUI_Firearm_Manuf_FN",
    description = "IGUI_Firearm_Desc_FN57",
})
register("Glock17", {
    -- technically not quite DAO, but as close as its going to get
    features = Flags.DOUBLEACTION + Flags.SLIDELOCK,
    feedSystem = Flags.AUTO + Flags.SHORTRECOIL,

    lastChanged = 24,
    category = ORGM.PISTOL,
    barrelLength = 4.48,
    isCivilian = ORGM.COMMON,
    soundProfile = "Pistol-Small",

    classification = "IGUI_Firearm_SemiPistol",
    year = 1982,
    country = "IGUI_Firearm_Country_AT",
    manufacturer = "IGUI_Firearm_Manuf_Glock",
    description = "IGUI_Firearm_Desc_Glock17",
})
register("Glock20", {
    features = Flags.DOUBLEACTION + Flags.SLIDELOCK,
    feedSystem = Flags.AUTO + Flags.SHORTRECOIL,

    lastChanged = 24,
    category = ORGM.PISTOL,
    barrelLength = 4.48,
    isCivilian = ORGM.COMMON,
    soundProfile = "Pistol-Small",

    classification = "IGUI_Firearm_SemiPistol",
    year = 1991,
    country = "IGUI_Firearm_Country_AT",
    manufacturer = "IGUI_Firearm_Manuf_Glock",
    description = "IGUI_Firearm_Desc_Glock20",
})
register("Glock21", {
    features = Flags.DOUBLEACTION + Flags.SLIDELOCK,
    feedSystem = Flags.AUTO + Flags.SHORTRECOIL,

    lastChanged = 24,
    category = ORGM.PISTOL,
    barrelLength = 4.48,
    isCivilian = ORGM.COMMON,
    soundProfile = "Pistol-Small",

    classification = "IGUI_Firearm_SemiPistol",
    year = 1991,
    country = "IGUI_Firearm_Country_AT",
    manufacturer = "IGUI_Firearm_Manuf_Glock",
    description = "IGUI_Firearm_Desc_Glock21",
})
register("Glock22", {
    features = Flags.DOUBLEACTION + Flags.SLIDELOCK,
    feedSystem = Flags.AUTO + Flags.SHORTRECOIL,

    lastChanged = 25,
    category = ORGM.PISTOL,
    barrelLength = 4.48,
    isCivilian = ORGM.COMMON,
    soundProfile = "Pistol-Small",

    classification = "IGUI_Firearm_SemiPistol",
    year = 1990,
    country = "IGUI_Firearm_Country_AT",
    manufacturer = "IGUI_Firearm_Manuf_Glock",
    description = "IGUI_Firearm_Desc_Glock22",
})
register("HKMK23", {
    features = Flags.SINGLEACTION + Flags.DOUBLEACTION + Flags.SAFETY + Flags.SLIDELOCK,
    feedSystem = Flags.AUTO + Flags.SHORTRECOIL,

    lastChanged = 24,
    category = ORGM.PISTOL,
    barrelLength = 5.87,
    isCivilian = ORGM.VERYRARE,
    isMilitary = ORGM.RARE,
    soundProfile = "Pistol-Small",

    classification = "IGUI_Firearm_SemiPistol",
    year = 1991,
    country = "IGUI_Firearm_Country_DE",
    manufacturer = "IGUI_Firearm_Manuf_HK",
    description = "IGUI_Firearm_Desc_HKMK23",
})
register("KahrCT40", {
    features = Flags.DOUBLEACTION + Flags.SAFETY + Flags.SLIDELOCK,
    feedSystem = Flags.AUTO + Flags.SHORTRECOIL,

    lastChanged = 24,
    category = ORGM.PISTOL,
    barrelLength = 4,
    isCivilian = ORGM.COMMON,
    soundProfile = "Pistol-Small",

    classification = "IGUI_Firearm_SemiPistol",
    year = 2014,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_Kahr",
    description = "IGUI_Firearm_Desc_KahrCT40",
})
register("KahrP380", {
    features = Flags.DOUBLEACTION + Flags.SAFETY + Flags.SLIDELOCK,
    feedSystem = Flags.AUTO + Flags.SHORTRECOIL,

    lastChanged = 24,
    category = ORGM.PISTOL,
    barrelLength = 2.53,
    isCivilian = ORGM.COMMON,
    soundProfile = "Pistol-Small",

    classification = "IGUI_Firearm_SemiPistol",
    year = 1999,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_Kahr",
    description = "IGUI_Firearm_Desc_KahrP380",
})
register("KTP32", {
    features = Flags.DOUBLEACTION + Flags.SAFETY + Flags.SLIDELOCK,
    feedSystem = Flags.AUTO + Flags.SHORTRECOIL,

    lastChanged = 24,
    category = ORGM.PISTOL,
    barrelLength = 2.68,
    isCivilian = ORGM.COMMON,
    soundProfile = "Pistol-Small",

    classification = "IGUI_Firearm_SemiPistol",
    year = 1999,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_KelTec",
    description = "IGUI_Firearm_Desc_KTP32",
})
register("M1911", {
    features = Flags.SINGLEACTION + Flags.SAFETY + Flags.SLIDELOCK,
    feedSystem = Flags.AUTO + Flags.SHORTRECOIL,

    lastChanged = 24,
    category = ORGM.PISTOL,
    barrelLength = 5.03,
    isCivilian = ORGM.COMMON,
    isMilitary = ORGM.COMMON,
    soundProfile = "Pistol-Small",

    classification = "IGUI_Firearm_SemiPistol",
    year = 1911,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_Colt",
    description = "IGUI_Firearm_Desc_M1911",
})
register("RugerMKII", {
    features = Flags.SINGLEACTION + Flags.SAFETY + Flags.SLIDELOCK,
    feedSystem = Flags.AUTO + Flags.BLOWBACK,

    lastChanged = 24,
    category = ORGM.PISTOL,
    barrelLength = 6.875,
    isCivilian = ORGM.COMMON,
    soundProfile = "Pistol-Small",

    classification = "IGUI_Firearm_SemiPistol",
    year = 1982,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_Ruger",
    description = "IGUI_Firearm_Desc_RugerMKII",
})
register("RugerSR9", {
    features = Flags.DOUBLEACTION + Flags.SAFETY + Flags.SLIDELOCK,
    feedSystem = Flags.AUTO + Flags.SHORTRECOIL,

    lastChanged = 24,
    category = ORGM.PISTOL,
    barrelLength = 4.14,
    isCivilian = ORGM.COMMON,
    soundProfile = "Pistol-Small",

    classification = "IGUI_Firearm_SemiPistol",
    year = 2007,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_Ruger",
    description = "IGUI_Firearm_Desc_RugerSR9",
})
register("SIGP226", {
    features = Flags.SINGLEACTION + Flags.DOUBLEACTION + Flags.SAFETY + Flags.SLIDELOCK,
    feedSystem = Flags.AUTO + Flags.SHORTRECOIL,

    lastChanged = 24,
    category = ORGM.PISTOL,
    barrelLength = 4.4,
    isCivilian = ORGM.COMMON,
    isPolice = ORGM.RARE,
    isMilitary = ORGM.RARE,
    soundProfile = "Pistol-Small",

    classification = "IGUI_Firearm_SemiPistol",
    year = 1983,
    country = "IGUI_Firearm_Country_DE",
    manufacturer = "IGUI_Firearm_Manuf_SIG",
    description = "IGUI_Firearm_Desc_SIGP226",
})
register("Spr19119", {
    features = Flags.SINGLEACTION + Flags.SAFETY + Flags.SLIDELOCK,
    feedSystem = Flags.AUTO + Flags.SHORTRECOIL,

    lastChanged = 24,
    category = ORGM.PISTOL,
    barrelLength = 5,
    isCivilian = ORGM.COMMON,
    soundProfile = "Pistol-Small",

    classification = "IGUI_Firearm_SemiPistol",
    year = 1985,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_Springfield",
    description = "IGUI_Firearm_Desc_Spr19119",
})
register("Taurus38", {
    features = Flags.SINGLEACTION + Flags.DOUBLEACTION + Flags.SAFETY + Flags.SLIDELOCK,
    feedSystem = Flags.AUTO + Flags.SHORTRECOIL,

    lastChanged = 24,
    category = ORGM.PISTOL,
    barrelLength = 4.25,
    isCivilian = ORGM.RARE,
    soundProfile = "Pistol-Small",

    classification = "IGUI_Firearm_SemiPistol",
    year = 2005,
    country = "IGUI_Firearm_Country_BR",
    manufacturer = "IGUI_Firearm_Manuf_Taurus",
    description = "IGUI_Firearm_Desc_Taurus38",
})
register("TaurusP132", {
    features = Flags.DOUBLEACTION + Flags.SAFETY + Flags.SLIDELOCK,
    feedSystem = Flags.AUTO + Flags.SHORTRECOIL,

    lastChanged = 24,
    category = ORGM.PISTOL,
    barrelLength = 3.25,
    isCivilian = ORGM.COMMON,
    soundProfile = "Pistol-Small",

    classification = "IGUI_Firearm_SemiPistol",
    year = 2005,
    country = "IGUI_Firearm_Country_BR",
    manufacturer = "IGUI_Firearm_Manuf_Taurus",
    description = "IGUI_Firearm_Desc_TaurusP132",
})
register("WaltherP22", {
    features = Flags.SINGLEACTION + Flags.DOUBLEACTION + Flags.SAFETY + Flags.SLIDELOCK,
    feedSystem = Flags.AUTO + Flags.BLOWBACK,

    lastChanged = 24,
    category = ORGM.PISTOL,
    barrelLength = 3.42, -- 5" target barrel
    barrelLengthOpt = {3.42, 5 },
    isCivilian = ORGM.COMMON,
    soundProfile = "Pistol-Small",

    classification = "IGUI_Firearm_SemiPistol",
    year = 2002,
    country = "IGUI_Firearm_Country_DE",
    manufacturer = "IGUI_Firearm_Manuf_Walther",
    description = "IGUI_Firearm_Desc_WaltherP22",
})
register("WaltherPPK", {
    features = Flags.SINGLEACTION + Flags.DOUBLEACTION + Flags.SAFETY + Flags.SLIDELOCK,
    feedSystem = Flags.AUTO + Flags.BLOWBACK,

    lastChanged = 24,
    category = ORGM.PISTOL,
    barrelLength = 3.3,
    isCivilian = ORGM.COMMON,
    soundProfile = "Pistol-Small",

    classification = "IGUI_Firearm_SemiPistol",
    year = 1935,
    country = "IGUI_Firearm_Country_DE",
    manufacturer = "IGUI_Firearm_Manuf_Walther",
    description = "IGUI_Firearm_Desc_WaltherPPK",
})
register("XD40", {
    -- striker trigger mechanism, DAO is close enough
    features = Flags.DOUBLEACTION + Flags.SAFETY + Flags.SLIDELOCK,
    feedSystem = Flags.AUTO + Flags.SHORTRECOIL,

    lastChanged = 24,
    category = ORGM.PISTOL,
    barrelLength = 4, -- 3 (compact), 4 (service), or 5 (tactical)
    barrelLengthOpt = { 3, 4, 5 },
    isCivilian = ORGM.COMMON,
    soundProfile = "Pistol-Small",

    classification = "IGUI_Firearm_SemiPistol",
    year = 1999,
    country = "IGUI_Firearm_Country_HR",
    manufacturer = "IGUI_Firearm_Manuf_HS",
    description = "IGUI_Firearm_Desc_XD40",
})
    --************************************************************************--
    -- smg/machine pistols
    --************************************************************************--

register("AM180", {
    -- not really DAO, its closer to SA, but doesnt allow for manual decocking
    features = Flags.DOUBLEACTION + Flags.SAFETY + Flags.FULLAUTO,
    feedSystem = Flags.AUTO + Flags.BLOWBACK,

    lastChanged = 24,
    category = ORGM.SUBMACHINEGUN,
    barrelLength = 9, -- 9 or 18.5
    barrelLengthOpt = { 9, 18.5 },
    isCivilian = ORGM.VERYRARE,
    soundProfile = "SMG",
    alwaysFullAuto = true,
    ejectSound = 'ORGMSMG2Out',
    insertSound = 'ORGMSMG2In',

    classification = "IGUI_Firearm_SMG",
    year = 1972,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_AAI",
    description = "IGUI_Firearm_Desc_AM180",
})
register("Ber93R", {
    features = Flags.SINGLEACTION + Flags.DOUBLEACTION + Flags.SAFETY + Flags.SLIDELOCK + Flags.SELECTFIRE + Flags.SEMIAUTO + Flags.BURST3,
    feedSystem = Flags.AUTO + Flags.SHORTRECOIL,

    lastChanged = 24,
    category = ORGM.SUBMACHINEGUN,
    barrelLength = 4.9,
    isCivilian = ORGM.VERYRARE,
    isMilitary = ORGM.VERYRARE,
    soundProfile = "Pistol-Small",

    classification = "IGUI_Firearm_MachinePistol",
    year = 1979,
    country = "IGUI_Firearm_Country_IT",
    manufacturer = "IGUI_Firearm_Manuf_Beretta",
    description = "IGUI_Firearm_Desc_Ber93R",
})
register("FNP90", {
    features = Flags.DOUBLEACTION + Flags.SAFETY + Flags.SLIDELOCK + Flags.SAFETY + Flags.SELECTFIRE + Flags.SEMIAUTO + Flags.FULLAUTO + Flags.BULLPUP,
    feedSystem = Flags.AUTO + Flags.BLOWBACK,

    lastChanged = 24,
    category = ORGM.SUBMACHINEGUN,
    barrelLength = 10.4,
    isMilitary = ORGM.VERYRARE,
    soundProfile = "SMG",

    classification = "IGUI_Firearm_SMG",
    year = 1990,
    country = "IGUI_Firearm_Country_BE",
    manufacturer = "IGUI_Firearm_Manuf_FN",
    description = "IGUI_Firearm_Desc_FNP90",
})
register("Glock18", {
    features = Flags.DOUBLEACTION + Flags.SLIDELOCK + Flags.SELECTFIRE + Flags.SEMIAUTO + Flags.FULLAUTO,
    feedSystem = Flags.AUTO + Flags.SHORTRECOIL,

    lastChanged = 24,
    category = ORGM.SUBMACHINEGUN,
    barrelLength = 4.48,
    isCivilian = ORGM.VERYRARE,
    soundProfile = "SMG",

    classification = "IGUI_Firearm_MachinePistol",
    year = 1986,
    country = "IGUI_Firearm_Country_AT",
    manufacturer = "IGUI_Firearm_Manuf_Glock",
    description = "IGUI_Firearm_Desc_Glock18",
})
register("HKMP5", {
    features = Flags.DOUBLEACTION + Flags.SLIDELOCK + Flags.SAFETY + Flags.SELECTFIRE + Flags.SEMIAUTO + Flags.FULLAUTO + Flags.FREEFLOAT,
    feedSystem = Flags.AUTO + Flags.DELAYEDBLOWBACK,

    lastChanged = 24,
    category = ORGM.SUBMACHINEGUN,
    barrelLength = 8.9,
    barrelLengthOpt = { 4.5, 5.5, 5.7, 5.8, 8.9 },
    isPolice = ORGM.VERYRARE,
    isMilitary = ORGM.COMMON,
    soundProfile = "SMG",

    classification = "IGUI_Firearm_SMG",
    year = 1966,
    country = "IGUI_Firearm_Country_DE",
    manufacturer = "IGUI_Firearm_Manuf_HK",
    description = "IGUI_Firearm_Desc_HKMP5",
})
register("HKUMP", {
    features = Flags.DOUBLEACTION + Flags.SLIDELOCK + Flags.SAFETY + Flags.SELECTFIRE + Flags.SEMIAUTO + Flags.FULLAUTO + Flags.BURST2 + Flags.FREEFLOAT,
    feedSystem = Flags.AUTO + Flags.SHORTRECOIL,

    lastChanged = 24,
    category = ORGM.SUBMACHINEGUN,
    barrelLength = 8,
    isPolice = ORGM.VERYRARE,
    isMilitary = ORGM.COMMON,
    soundProfile = "SMG",

    classification = "IGUI_Firearm_SMG",
    year = 1999,
    country = "IGUI_Firearm_Country_DE",
    manufacturer = "IGUI_Firearm_Manuf_HK",
    description = "IGUI_Firearm_Desc_HKUMP",
})
register("Kriss", {
    features = Flags.DOUBLEACTION + Flags.SLIDELOCK + Flags.SAFETY,
    feedSystem = Flags.AUTO + Flags.DELAYEDBLOWBACK,

    lastChanged = 24,
    category = ORGM.SUBMACHINEGUN,
    barrelLength = 16,
    isCivilian = ORGM.RARE,
    soundProfile = "SMG",

    classification = "IGUI_Firearm_SMG",
    year = 2009,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_Kriss",
    description = "IGUI_Firearm_Desc_Kriss",
})
register("KrissA", {
    features = Flags.DOUBLEACTION + Flags.SLIDELOCK + Flags.SAFETY + Flags.SELECTFIRE + Flags.SEMIAUTO + Flags.FULLAUTO + Flags.BURST2,
    feedSystem = Flags.AUTO + Flags.DELAYEDBLOWBACK,

    lastChanged = 24,
    category = ORGM.SUBMACHINEGUN,
    barrelLength = 5.5, -- 5.5 or 6.5
    barrelLengthOpt = { 5.5, 6.5 },
    isCivilian = ORGM.VERYRARE,
    soundProfile = "SMG",

    classification = "IGUI_Firearm_SMG",
    year = 2009,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_Kriss",
    description = "IGUI_Firearm_Desc_KrissA",
})
register("KTPLR", {
    features = Flags.DOUBLEACTION + Flags.SLIDELOCK + Flags.SAFETY,
    feedSystem = Flags.AUTO + Flags.SHORTGAS,

    lastChanged = 24,
    category = ORGM.SUBMACHINEGUN,
    barrelLength = 9.25,
    isCivilian = ORGM.RARE,
    soundProfile = "Rifle-AR",

    classification = "IGUI_Firearm_SMG",
    year = 2006,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_KelTec",
    description = "IGUI_Firearm_Desc_KTPLR",
})
register("M1A1", {
    features = Flags.DOUBLEACTION + Flags.SLIDELOCK + Flags.SAFETY + Flags.SELECTFIRE + Flags.SEMIAUTO + Flags.FULLAUTO,
    feedSystem = Flags.AUTO + Flags.BLOWBACK,

    lastChanged = 24,
    category = ORGM.SUBMACHINEGUN,
    barrelLength = 10.52,
    isCivilian = ORGM.VERYRARE,
    soundProfile = "SMG",

    classification = "IGUI_Firearm_SMG",
    year = 1921,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_AOC",
    description = "IGUI_Firearm_Desc_M1A1",

    --skins = {'gold'},
})
register("Mac10", {
    features = Flags.DOUBLEACTION + Flags.SAFETY + Flags.SELECTFIRE + Flags.SEMIAUTO + Flags.FULLAUTO + Flags.OPENBOLT,
    feedSystem = Flags.AUTO + Flags.BLOWBACK,

    lastChanged = 24,
    category = ORGM.SUBMACHINEGUN,
    barrelLength = 4.49,
    isCivilian = ORGM.RARE,
    soundProfile = "SMG",

    classification = "IGUI_Firearm_SMG",
    year = 1970,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_MAC",
    description = "IGUI_Firearm_Desc_Mac10",
})
register("Mac11", {
    features = Flags.DOUBLEACTION + Flags.SAFETY + Flags.SELECTFIRE + Flags.SEMIAUTO + Flags.FULLAUTO + Flags.OPENBOLT,
    feedSystem = Flags.AUTO + Flags.BLOWBACK,

    lastChanged = 24,
    category = ORGM.SUBMACHINEGUN,
    barrelLength = 5.08,
    isCivilian = ORGM.RARE,
    soundProfile = "SMG",

    classification = "IGUI_Firearm_MachinePistol",
    year = 1972,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_MAC",
    description = "IGUI_Firearm_Desc_Mac11",
})
register("Skorpion", {
    features = Flags.DOUBLEACTION + Flags.SLIDELOCK + Flags.SAFETY + Flags.SELECTFIRE + Flags.SEMIAUTO + Flags.FULLAUTO,
    feedSystem = Flags.AUTO + Flags.BLOWBACK,

    lastChanged = 24,
    category = ORGM.SUBMACHINEGUN,
    barrelLength = 4.5,
    isCivilian = ORGM.VERYRARE,
    soundProfile = "Pistol-Small",
    selectFire = 1,

    classification = "IGUI_Firearm_MachinePistol",
    year = 1961,
    country = "IGUI_Firearm_Country_CZ",
    --manufacturer = "Česká zbrojovka Uherský Brod",
    manufacturer = "IGUI_Firearm_Manuf_CZUB",
    description = "IGUI_Firearm_Desc_Skorpion",
})
register("Uzi", {
    features = Flags.DOUBLEACTION + Flags.SAFETY + Flags.SEMIAUTO + Flags.FULLAUTO + Flags.OPENBOLT,
    feedSystem = Flags.AUTO + Flags.BLOWBACK,

    lastChanged = 24,
    category = ORGM.SUBMACHINEGUN,
    barrelLength = 10.2,
    isCivilian = ORGM.RARE,
    soundProfile = "SMG",
    alwaysFullAuto = true,

    classification = "IGUI_Firearm_SMG",
    year = 1950,
    country = "IGUI_Firearm_Country_IL",
    manufacturer = "IGUI_Firearm_Manuf_IMI",
    description = "IGUI_Firearm_Desc_Uzi",
})
    --************************************************************************--
    -- rifles
    --************************************************************************--
register("AIAW308", {
    features = Flags.SINGLEACTION + Flags.SAFETY + Flags.FREEFLOAT,
    feedSystem = Flags.BOLT,

    lastChanged = 24,
    category = ORGM.RIFLE,
    barrelLength = 26,
    isCivilian = ORGM.RARE,
    isPolice = ORGM.RARE,
    isMilitary = ORGM.RARE,
    soundProfile = "Rifle-Bolt",

    classification = "IGUI_Firearm_BoltRifle",
    year = 1983,
    country = "IGUI_Firearm_Country_GB",
    manufacturer = "IGUI_Firearm_Manuf_AI",
    description = "IGUI_Firearm_Desc_AIAW308",
})
register("AKM", {
    features = Flags.DOUBLEACTION + Flags.SLIDELOCK + Flags.SAFETY,
    feedSystem = Flags.AUTO + Flags.LONGGAS,

    lastChanged = 24,
    category = ORGM.RIFLE,
    barrelLength = 16.3,
    isCivilian = ORGM.RARE,
    soundProfile = "Rifle-AR",

    classification = "IGUI_Firearm_AssaultRifle",
    year = 1982,
    country = "IGUI_Firearm_Country_CN",
    manufacturer = "IGUI_Firearm_Manuf_NORINCO",
    description = "IGUI_Firearm_Desc_AKM",

})
register("AKMA", {
    features = Flags.DOUBLEACTION + Flags.SLIDELOCK + Flags.SAFETY + Flags.SELECTFIRE + Flags.SEMIAUTO + Flags.FULLAUTO,
    feedSystem = Flags.AUTO + Flags.LONGGAS,

    lastChanged = 24,
    category = ORGM.RIFLE,
    barrelLength = 16.3,
    isCivilian = ORGM.VERYRARE,
    soundProfile = "Rifle-AR",

    classification = "IGUI_Firearm_AssaultRifle",
    year = 1959,
    country = "IGUI_Firearm_Country_SU",
    manufacturer = "IGUI_Firearm_Manuf_Kal",
    description = "IGUI_Firearm_Desc_AKMA",
})
register("AR10", {
    features = Flags.DOUBLEACTION + Flags.SLIDELOCK + Flags.SAFETY + Flags.SELECTFIRE + Flags.SEMIAUTO + Flags.FULLAUTO,
    feedSystem = Flags.AUTO + Flags.DIRECTGAS,

    lastChanged = 24,
    category = ORGM.RIFLE,
    barrelLength = 20.8,
    isCivilian = ORGM.VERYRARE,
    soundProfile = "Rifle-AR",

    classification = "IGUI_Firearm_BattleRifle",
    year = 1956,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_ALCOLT",
    description = "IGUI_Firearm_Desc_AR10",
})
register("AR15", {
    features = Flags.DOUBLEACTION + Flags.SLIDELOCK + Flags.SAFETY,
    feedSystem = Flags.AUTO + Flags.DIRECTGAS,

    lastChanged = 24,
    category = ORGM.RIFLE,
    barrelLength = 20, -- 16 (carbine), 20 (standard), 24 (target)
    barrelLengthOpt = { 16, 20, 24 },
    isCivilian = ORGM.COMMON,
    isPolice = ORGM.COMMON,
    soundProfile = "Rifle-AR",

    classification = "IGUI_Firearm_SemiRifle",
    year = 1963,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_Colt",
    description = "IGUI_Firearm_Desc_AR15",
})
register("BBGun", {
    features = Flags.DOUBLEACTION,
    feedSystem = Flags.LEVER,

    lastChanged = 24,
    category = ORGM.RIFLE,
    isCivilian = ORGM.COMMON,
    -- TODO: Barrel Length
    barrelLength = 11,
    rackTime = 3,
    soundProfile = "Rifle-Lever",
    rackSound = 'ORGMBBLever',
    clickSound = 'ORGMPistolEmpty',
    insertSound = 'ORGMMagBBLoad',

    classification = "IGUI_Firearm_AirRifle",
    year = 1940,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_Daisy",
    description = "IGUI_Firearm_Desc_BBGun",
})
register("BLR", {
    features = Flags.SINGLEACTION + Flags.SAFETY,
    feedSystem = Flags.LEVER,

    lastChanged = 24,
    category = ORGM.RIFLE,
    barrelLength = 22, -- 16, 18, 18.5, 20, 22, 24
    barrelLengthOpt = { 16, 18, 18.5, 20, 22, 24 },
    isCivilian = ORGM.COMMON,
    soundProfile = "Rifle-Lever",

    classification = "IGUI_Firearm_LeverRifle",
    year = 1969,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_Browning",
    description = "IGUI_Firearm_Desc_BLR",
})
register("FNFAL", {
    features = Flags.DOUBLEACTION + Flags.SLIDELOCK + Flags.SAFETY,
    feedSystem = Flags.AUTO + Flags.SHORTGAS,

    lastChanged = 24,
    category = ORGM.RIFLE,
    barrelLength = 21,
    isCivilian = ORGM.RARE,
    soundProfile = "Rifle-AR",

    classification = "IGUI_Firearm_SemiRifle",
    year = 1982,
    country = "IGUI_Firearm_Country_AR",
    manufacturer = "IGUI_Firearm_Manuf_FMAP",
    description = "IGUI_Firearm_Desc_FNFAL",
})
register("FNFALA", {
    features = Flags.DOUBLEACTION + Flags.SLIDELOCK + Flags.SAFETY + Flags.SELECTFIRE + Flags.SEMIAUTO + Flags.FULLAUTO,
    feedSystem = Flags.AUTO + Flags.SHORTGAS,

    lastChanged = 24,
    category = ORGM.RIFLE,
    barrelLength = 21, -- 17.2, 18, 21
    barrelLengthOpt = { 17.2, 18, 21 },
    isCivilian = ORGM.VERYRARE,
    soundProfile = "Rifle-AR",

    classification = "IGUI_Firearm_BattleRifle",
    year = 1953,
    country = "IGUI_Firearm_Country_BE",
    manufacturer = "IGUI_Firearm_Manuf_FN",
    description = "IGUI_Firearm_Desc_FNFALA",
})
register("Garand", {
    features = Flags.DOUBLEACTION + Flags.SLIDELOCK + Flags.SAFETY,
    feedSystem = Flags.AUTO + Flags.LONGGAS,

    lastChanged = 24,
    category = ORGM.RIFLE,
    barrelLength = 24,
    isCivilian = ORGM.COMMON,
    soundProfile = "Rifle-Auto",

    classification = "IGUI_Firearm_SemiRifle",
    year = 1934,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_Springfield",
    description = "IGUI_Firearm_Desc_Garand",
})
register("HenryBB", {
    features = Flags.SINGLEACTION + Flags.SAFETY,
    feedSystem = Flags.LEVER,

    lastChanged = 24,
    category = ORGM.RIFLE,
    barrelLength = 20,
    isCivilian = ORGM.RARE,
    soundProfile = "Rifle-Lever",

    classification = "IGUI_Firearm_LeverRifle",
    year = 2001,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_Henry",
    description = "IGUI_Firearm_Desc_HenryBB",
})
register("HK91", {
    features = Flags.DOUBLEACTION + Flags.SLIDELOCK + Flags.SAFETY,
    feedSystem = Flags.AUTO + Flags.DELAYEDBLOWBACK,

    lastChanged = 24,
    category = ORGM.RIFLE,
    barrelLength = 19.7,
    isCivilian = ORGM.RARE,
    soundProfile = "Rifle-AR",

    classification = "IGUI_Firearm_SemiRifle",
    year = 1974,
    country = "IGUI_Firearm_Country_DE",
    manufacturer = "IGUI_Firearm_Manuf_HK",
    description = "IGUI_Firearm_Desc_HK91",
})
register("HKG3", {
    features = Flags.DOUBLEACTION + Flags.SLIDELOCK + Flags.SAFETY + Flags.SELECTFIRE + Flags.SEMIAUTO + Flags.FULLAUTO,
    feedSystem = Flags.AUTO + Flags.DELAYEDBLOWBACK,

    lastChanged = 24,
    category = ORGM.RIFLE,
    barrelLength = 17.7,
    isCivilian = ORGM.VERYRARE,
    soundProfile = "Rifle-AR",

    classification = "IGUI_Firearm_BattleRifle",
    year = 1958,
    country = "IGUI_Firearm_Country_DE",
    manufacturer = "IGUI_Firearm_Manuf_HK",
    description = "IGUI_Firearm_Desc_HKG3",
})
register("HKSL8", {
    features = Flags.DOUBLEACTION + Flags.SLIDELOCK + Flags.SAFETY + Flags.FREEFLOAT,
    feedSystem = Flags.AUTO + Flags.SHORTGAS,

    lastChanged = 24,
    category = ORGM.RIFLE,
    barrelLength = 20.08,
    isCivilian = ORGM.RARE,
    soundProfile = "Rifle-AR",

    classification = "IGUI_Firearm_SemiRifle",
    year = 1998,
    country = "IGUI_Firearm_Country_DE",
    manufacturer = "IGUI_Firearm_Manuf_HK",
    description = "IGUI_Firearm_Desc_HKSL8",
})
register("L96", {
    features = Flags.SINGLEACTION + Flags.SAFETY + Flags.FREEFLOAT,
    feedSystem = Flags.BOLT,

    lastChanged = 24,
    category = ORGM.RIFLE,
    barrelLength = 26,
    isCivilian = ORGM.COMMON,
    soundProfile = "Rifle-Bolt",

    classification = "IGUI_Firearm_BoltRifle",
    year = 1982,
    country = "IGUI_Firearm_Country_GB",
    manufacturer = "IGUI_Firearm_Manuf_AI",
    description = "IGUI_Firearm_Desc_L96",
})
register("LENo4", {
    features = Flags.SINGLEACTION + Flags.SAFETY,
    feedSystem = Flags.BOLT,

    lastChanged = 24,
    category = ORGM.RIFLE,
    barrelLength = 25.2,
    isCivilian = ORGM.COMMON,
    speedLoader = "LENo4StripperClip",
    soundProfile = "Rifle-Bolt",

    classification = "IGUI_Firearm_BoltRifle",
    year = 1941,
    country = "IGUI_Firearm_Country_GB",
    manufacturer = "IGUI_Firearm_Manuf_LBASS",
    description = "IGUI_Firearm_Desc_LENo4",
})
register("M16", {
    features = Flags.DOUBLEACTION + Flags.SLIDELOCK + Flags.SAFETY + Flags.SELECTFIRE + Flags.SEMIAUTO + Flags.BURST3,
    feedSystem = Flags.AUTO + Flags.DIRECTGAS,

    lastChanged = 24,
    category = ORGM.RIFLE,
    barrelLength = 20,
    isPolice = ORGM.VERYRARE,
    isMilitary = ORGM.COMMON,
    soundProfile = "Rifle-AR",

    classification = "IGUI_Firearm_AssaultRifle",
    year = 1964,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_Colt",
    description = "IGUI_Firearm_Desc_M16",
})
register("M1903", {
    features = Flags.SINGLEACTION + Flags.SAFETY,
    feedSystem = Flags.BOLT,

    lastChanged = 24,
    category = ORGM.RIFLE,
    barrelLength = 24,
    isCivilian = ORGM.RARE,
    speedLoader = 'M1903StripperClip',
    soundProfile = "Rifle-Auto-IM",

    classification = "IGUI_Firearm_BoltRifle",
    year = 1903,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_Springfield",
    description = "IGUI_Firearm_Desc_M1903",
})
register("M21", {
    features = Flags.DOUBLEACTION + Flags.SLIDELOCK + Flags.SAFETY,
    feedSystem = Flags.AUTO + Flags.SHORTGAS,

    lastChanged = 24,
    category = ORGM.RIFLE,
    barrelLength = 22,
    isPolice = ORGM.RARE,
    isMilitary = ORGM.RARE,
    soundProfile = "Rifle-Auto",

    classification = "IGUI_Firearm_SemiRifle",
    year = 1969,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_RIA",
    description = "IGUI_Firearm_Desc_M21",
})
register("M249", {
    features = Flags.DOUBLEACTION + Flags.SLIDELOCK + Flags.SAFETY + Flags.FULLAUTO + Flags.OPENBOLT,
    feedSystem = Flags.AUTO + Flags.LONGGAS,

    lastChanged = 24,
    category = ORGM.RIFLE,
    barrelLength = 21, -- 18 or 21
    barrelLengthOpt = { 18, 21 },
    isMilitary = ORGM.RARE,
    soundProfile = "Rifle-Auto",
    clickSound = 'ORGMRifleEmpty',
    ejectSound = 'ORGMLMGOut',
    insertSound = 'ORGMLMGIn',
    rackSound = 'ORGMLMGRack',

    classification = "IGUI_Firearm_LMG",
    year = 1979,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_FN2",
    description = "IGUI_Firearm_Desc_M249",
})
register("M4C", {
    features = Flags.DOUBLEACTION + Flags.SLIDELOCK + Flags.SAFETY + Flags.SELECTFIRE + Flags.SEMIAUTO + Flags.BURST3,
    feedSystem = Flags.AUTO + Flags.DIRECTGAS,

    lastChanged = 24,
    category = ORGM.RIFLE,
    barrelLength = 14.5,
    isPolice = ORGM.VERYRARE,
    isMilitary = ORGM.COMMON,
    soundProfile = "Rifle-AR",

    classification = "IGUI_Firearm_AssaultCarbine",
    year = 1984,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_Colt",
    description = "IGUI_Firearm_Desc_M4C",
})
register("Marlin60", {
    features = Flags.DOUBLEACTION + Flags.SLIDELOCK + Flags.SAFETY,
    feedSystem = Flags.AUTO + Flags.BLOWBACK,

    lastChanged = 24,
    category = ORGM.RIFLE,
    barrelLength = 19, -- 19 or 22 (pre-1985)
    barrelLengthOpt = { 19, 22 },
    isCivilian = ORGM.COMMON,
    soundProfile = "Rifle-Auto-IM",
    rackSound = 'ORGMRifleRack',
    clickSound = 'ORGMSmallPistolEmpty',
    insertSound = 'ORGMMagLoad',

    classification = "IGUI_Firearm_SemiRifle",
    year = 1960,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_Marlin",
    description = "IGUI_Firearm_Desc_Marlin60",
})
register("Mini14", {
    features = Flags.DOUBLEACTION + Flags.SLIDELOCK + Flags.SAFETY,
    feedSystem = Flags.AUTO + Flags.LONGGAS,

    lastChanged = 24,
    category = ORGM.RIFLE,
    barrelLength = 18.5, -- 16.12 (tactical), 18.5, 22 (target)
    barrelLengthOpt = { 16.12, 18.5, 22 },
    isCivilian = ORGM.COMMON,
    isPolice = ORGM.RARE,
    soundProfile = "Rifle-AR",

    classification = "IGUI_Firearm_SemiRifle",
    year = 1973,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_Ruger",
    description = "IGUI_Firearm_Desc_Mini14",
})
register("Mosin", {
    features = Flags.SINGLEACTION + Flags.SAFETY,
    feedSystem = Flags.BOLT,

    lastChanged = 24,
    category = ORGM.RIFLE,
    barrelLength = 29, -- 22.2 carbine, 26.2, 29
    barrelLengthOpt = { 22.2, 26.2, 29 },
    isCivilian = ORGM.COMMON,
    speedLoader = 'MosinStripperClip',
    soundProfile = "Rifle-Bolt-IM",

    classification = "IGUI_Firearm_BoltRifle",
    year = 1891,
    country = "IGUI_Firearm_Country_RUSEMP",
    manufacturer = "IGUI_Firearm_Manuf_Tula",
    description = "IGUI_Firearm_Desc_Mosin",
})
register("R25", {
    features = Flags.DOUBLEACTION + Flags.SLIDELOCK + Flags.SAFETY + Flags.FREEFLOAT + Flags.NOSIGHTS,
    feedSystem = Flags.AUTO + Flags.DIRECTGAS,

    lastChanged = 27,
    category = ORGM.RIFLE,
    barrelLength = 20,
    isCivilian = ORGM.RARE,
    soundProfile = "Rifle-AR",

    classification = "IGUI_Firearm_SemiRifle",
    year = 2008,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_RA",
    description = "IGUI_Firearm_Desc_R25",
})
register("Rem700", {
    features = Flags.SINGLEACTION + Flags.SAFETY,
    feedSystem = Flags.BOLT,

    lastChanged = 24,
    category = ORGM.RIFLE,
    barrelLength = 24, -- varies widely from 16.5 to 26 depending on model and caliber. the .30-06's seem mostly in 24"
    barrelLengthOpt = {16.5, 18, 20, 22, 24, 26 },
    isCivilian = ORGM.COMMON,
    isPolice = ORGM.RARE,
    soundProfile = "Rifle-Bolt-IM",

    classification = "IGUI_Firearm_BoltRifle",
    year = 1962,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_RA",
    description = "IGUI_Firearm_Desc_Rem700",
})
register("Rem788", {
    features = Flags.SINGLEACTION + Flags.SAFETY,
    feedSystem = Flags.BOLT,

    lastChanged = 24,
    category = ORGM.RIFLE,
    barrelLength = 24, -- 18.5, 22, 24
    barrelLengthOpt = { 18.5, 22, 24 },
    isCivilian = ORGM.COMMON,
    soundProfile = "Rifle-Bolt",

    classification = "IGUI_Firearm_BoltRifle",
    year = 1967,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_RA",
    description = "IGUI_Firearm_Desc_Rem788",
})
register("Rug1022", {
    features = Flags.DOUBLEACTION + Flags.SLIDELOCK + Flags.SAFETY,
    feedSystem = Flags.AUTO + Flags.BLOWBACK,

    lastChanged = 24,
    category = ORGM.RIFLE,
    barrelLength = 18.5,
    isCivilian = ORGM.COMMON,
    soundProfile = "Pistol-Small",

    classification = "IGUI_Firearm_SemiRifle",
    year = 1964,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_Ruger",
    description = "IGUI_Firearm_Desc_Rug1022",
})
register("SA80", {
    features = Flags.DOUBLEACTION + Flags.SLIDELOCK + Flags.SAFETY + Flags.SELECTFIRE + Flags.SEMIAUTO + Flags.FULLAUTO + Flags.BULLPUP,
    feedSystem = Flags.AUTO + Flags.SHORTGAS,

    lastChanged = 24,
    category = ORGM.RIFLE,
    barrelLength = 20.4, -- 11.2, 20.4, 25.4
    barrelLengthOpt = { 11.2, 20.4, 25.4 },
    isMilitary = ORGM.RARE,
    soundProfile = "Rifle-AR",
    isBulpup = true,

    classification = "IGUI_Firearm_AssaultRifle",
    year = 1985,
    country = "IGUI_Firearm_Country_GB",
    manufacturer = "IGUI_Firearm_Manuf_RSAF",
    description = "IGUI_Firearm_Desc_SA80",
})
register("SIG550", {
    features = Flags.DOUBLEACTION + Flags.SLIDELOCK + Flags.SAFETY + Flags.SELECTFIRE + Flags.SEMIAUTO + Flags.FULLAUTO + Flags.BURST3,
    feedSystem = Flags.AUTO + Flags.LONGGAS,

    lastChanged = 24,
    category = ORGM.RIFLE,
    barrelLength = 20.8,
    isCivilian = ORGM.VERYRARE,
    soundProfile = "Rifle-AR",

    classification = "IGUI_Firearm_AssaultRifle",
    year = 1986,
    country = "IGUI_Firearm_Country_CH",
    manufacturer = "IGUI_Firearm_Manuf_SIG2",
    description = "IGUI_Firearm_Desc_SIG550",
})
register("SIG551", {
    features = Flags.DOUBLEACTION + Flags.SLIDELOCK + Flags.SAFETY + Flags.SELECTFIRE + Flags.SEMIAUTO + Flags.FULLAUTO + Flags.BURST3,
    feedSystem = Flags.AUTO + Flags.LONGGAS,

    lastChanged = 24,
    category = ORGM.RIFLE,
    barrelLength = 20.8,
    isCivilian = ORGM.VERYRARE,
    soundProfile = "Rifle-AR",

    classification = "IGUI_Firearm_AssaultCarbine",
    year = 1986,
    country = "IGUI_Firearm_Country_CH",
    manufacturer = "IGUI_Firearm_Manuf_SIG2",
    description = "IGUI_Firearm_Desc_SIG551",
})
register("SKS", {
    features = Flags.DOUBLEACTION + Flags.SLIDELOCK + Flags.SAFETY,
    feedSystem = Flags.AUTO + Flags.SHORTGAS,

    lastChanged = 24,
    category = ORGM.RIFLE,
    barrelLength = 20, -- 20 or 22
    barrelLengthOpt = { 20, 22 },
    isCivilian = ORGM.COMMON,
    speedLoader = 'SKSStripperClip',
    soundProfile = "Rifle-Auto-IM",

    classification = "IGUI_Firearm_SemiCarbine",
    year = 1945,
    country = "IGUI_Firearm_Country_SU",
    manufacturer = "IGUI_Firearm_Manuf_Tula",
    description = "IGUI_Firearm_Desc_SKS",
})
register("SR25", {
    features = Flags.DOUBLEACTION + Flags.SLIDELOCK + Flags.SAFETY + Flags.FREEFLOAT + Flags.NOSIGHTS,
    feedSystem = Flags.AUTO + Flags.DIRECTGAS,

    lastChanged = 24,
    category = ORGM.RIFLE,
    barrelLength = 24,
    isPolice = ORGM.RARE,
    isMilitary = ORGM.COMMON,
    soundProfile = "Rifle-AR",

    classification = "IGUI_Firearm_SemiRifle",
    year = 1990,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_KAC",
    description = "IGUI_Firearm_Desc_SR25",
})
register("SVD", {
    features = Flags.DOUBLEACTION + Flags.SLIDELOCK + Flags.SAFETY,
    feedSystem = Flags.AUTO + Flags.SHORTGAS,

    lastChanged = 24,
    category = ORGM.RIFLE,
    barrelLength = 24.4,
    isCivilian = ORGM.RARE,
    soundProfile = "Rifle-Auto",

    classification = "IGUI_Firearm_SemiRifle",
    year = 1963,
    country = "IGUI_Firearm_Country_SU",
    manufacturer = "IGUI_Firearm_Manuf_Kal2",
    description = "IGUI_Firearm_Desc_SVD",
})
register("WinM70", {
    features = Flags.SINGLEACTION + Flags.SAFETY,
    feedSystem = Flags.BOLT,

    lastChanged = 24,
    category = ORGM.RIFLE,
    barrelLength = 24, -- 22, 24, 26
    barrelLengthOpt = { 22, 24, 26 },
    isCivilian = ORGM.COMMON,
    isMilitary = ORGM.RARE,
    soundProfile = "Rifle-Bolt-IM",

    classification = "IGUI_Firearm_BoltRifle",
    year = 1936,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_WRA",
    description = "IGUI_Firearm_Desc_WinM70",
})
register("WinM94", {
    features = Flags.DOUBLEACTION + Flags.SAFETY,
    feedSystem = Flags.LEVER,

    lastChanged = 24,
    category = ORGM.RIFLE,
    barrelLength = 20,
    isCivilian = ORGM.COMMON,
    soundProfile = "Rifle-Lever",

    classification = "IGUI_Firearm_LeverRifle",
    year = 1894,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_WRA",
    description = "IGUI_Firearm_Desc_WinM94",
})
    --************************************************************************--
    -- shotguns
    --************************************************************************--

register("BenelliM3", {
    features = Flags.DOUBLEACTION + Flags.SLIDELOCK + Flags.SAFETY,
    feedSystem = Flags.PUMP + Flags.AUTO + Flags.LONGRECOIL,

    lastChanged = 24,
    category = ORGM.SHOTGUN,
    barrelLength = 22, -- 20 22, 24
    barrelLengthOpt = { 20, 22, 24 },
    isPolice = ORGM.COMMON,
    soundProfile = "Shotgun",

    classification = "IGUI_Firearm_DualShotgun",
    year = 1989,
    country = "IGUI_Firearm_Country_IT",
    manufacturer = "IGUI_Firearm_Manuf_Benelli",
    description = "IGUI_Firearm_Desc_BenelliM3",
})
register("BenelliM3SO", {
    features = Flags.DOUBLEACTION + Flags.SLIDELOCK + Flags.SAFETY,
    feedSystem = Flags.PUMP + Flags.AUTO + Flags.LONGRECOIL,

    lastChanged = 24,
    category = ORGM.SHOTGUN,
    barrelLength = 18, -- cant saw off much with that magazine tube, the connecting brace is very forward
    soundProfile = "Shotgun",

    classification = ORGM.Firearm.getData("BenelliM3").classification,
    year = ORGM.Firearm.getData("BenelliM3").year,
    country = ORGM.Firearm.getData("BenelliM3").country,
    manufacturer = ORGM.Firearm.getData("BenelliM3").manufacturer,
    description = ORGM.Firearm.getData("BenelliM3").description,
})
register("BenelliXM1014", {
    features = Flags.DOUBLEACTION + Flags.SLIDELOCK + Flags.SAFETY,
    feedSystem = Flags.AUTO + Flags.LONGRECOIL,

    lastChanged = 24,
    category = ORGM.SHOTGUN,
    barrelLength = 18.5,
    isMilitary = ORGM.COMMON,
    soundProfile = "Shotgun",
    rackSound = 'ORGMARRack',

    classification = "IGUI_Firearm_SemiShotgun",
    year = 1999,
    country = "IGUI_Firearm_Country_IT",
    manufacturer = "IGUI_Firearm_Manuf_Benelli",
    description = "IGUI_Firearm_Desc_BenelliXM1014"
})
register("Hawk982", {
    features = Flags.DOUBLEACTION + Flags.SAFETY,
    feedSystem = Flags.PUMP,

    lastChanged = 24,
    category = ORGM.SHOTGUN,
    barrelLength = 18.5,
    isCivilian = ORGM.COMMON,
    soundProfile = "Shotgun",

    classification = "IGUI_Firearm_PumpShotgun",
    year = 2008,
    country = "IGUI_Firearm_Country_CN",
    manufacturer = "IGUI_Firearm_Manuf_NORINCO",
    description = "IGUI_Firearm_Desc_Hawk982",
})
register("Ithaca37", {
    features = Flags.DOUBLEACTION + Flags.SAFETY + Flags.SLAMFIRE,
    feedSystem = Flags.PUMP,

    lastChanged = 24,
    category = ORGM.SHOTGUN,
    barrelLength = 20, -- 18.5, 20, -- all the way up to 30
    barrelLengthOpt = { 18.5, 20, 22, 24, 26, 28, 30 },
    isCivilian = ORGM.COMMON,
    soundProfile = "Shotgun",

    classification = "IGUI_Firearm_PumpShotgun",
    year = 1937,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_Ithaca",
    description = "IGUI_Firearm_Desc_Ithaca37",
})
register("Ithaca37SO", {
    features = Flags.DOUBLEACTION + Flags.SAFETY + Flags.SLAMFIRE,
    feedSystem = Flags.PUMP,

    lastChanged = 24,
    category = ORGM.SHOTGUN,
    barrelLength = 14, -- sawn off
    isCivilian = ORGM.COMMON,
    soundProfile = "Shotgun",

    classification = ORGM.Firearm.getData("Ithaca37").classification,
    year = ORGM.Firearm.getData("Ithaca37").year,
    country = ORGM.Firearm.getData("Ithaca37").country,
    manufacturer = ORGM.Firearm.getData("Ithaca37").manufacturer,
    description = ORGM.Firearm.getData("Ithaca37").description,
})
register("M1216", {
    features = Flags.DOUBLEACTION + Flags.SLIDELOCK + Flags.SAFETY,
    feedSystem = Flags.AUTO + Flags.DELAYEDBLOWBACK,

    lastChanged = 24,
    category = ORGM.SHOTGUN,
    barrelLength = 18,
    isCivilian = ORGM.RARE,
    soundProfile = "Rifle-AR",

    classification = "IGUI_Firearm_SemiShotgun",
    year = 2012,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_SRM",
    description = "IGUI_Firearm_Desc_M1216",
})
register("Moss590", {
    features = Flags.DOUBLEACTION + Flags.SAFETY,
    feedSystem = Flags.PUMP,

    lastChanged = 27,
    category = ORGM.SHOTGUN,
    barrelLength = 20,
    isCivilian = ORGM.COMMON,
    soundProfile = "Shotgun",

    classification = "IGUI_Firearm_PumpShotgun",
    year = 1960,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_Moss",
    description = "IGUI_Firearm_Desc_Moss590",
})
register("Moss590SO", {
    features = Flags.DOUBLEACTION + Flags.SAFETY,
    feedSystem = Flags.PUMP,

    lastChanged = 27,
    category = ORGM.SHOTGUN,
    barrelLength = 18.5,
    isCivilian = ORGM.COMMON,
    soundProfile = "Shotgun",

    classification = ORGM.Firearm.getData("Moss590").classification,
    year = ORGM.Firearm.getData("Moss590").year,
    country = ORGM.Firearm.getData("Moss590").country,
    manufacturer = ORGM.Firearm.getData("Moss590").manufacturer,
    description = ORGM.Firearm.getData("Moss590").description,
})
register("Rem870", {
    features = Flags.DOUBLEACTION + Flags.SAFETY,
    feedSystem = Flags.PUMP,

    lastChanged = 24,
    category = ORGM.SHOTGUN,
    barrelLength = 26,
    barrelLengthOpt = {20, 22, 24, 26 },
    isCivilian = ORGM.COMMON,
    isPolice = ORGM.COMMON,
    soundProfile = "Shotgun",

    classification = "IGUI_Firearm_PumpShotgun",
    year = 1951,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_RA",
    description = "IGUI_Firearm_Desc_Rem870"
})
register("Rem870SO", {
    features = Flags.DOUBLEACTION + Flags.SAFETY,
    feedSystem = Flags.PUMP,

    lastChanged = 24,
    category = ORGM.SHOTGUN,
    barrelLength = 14,
    isCivilian = ORGM.COMMON,
    soundProfile = "Shotgun",

    classification = ORGM.Firearm.getData("Rem870").classification,
    year = ORGM.Firearm.getData("Rem870").year,
    country = ORGM.Firearm.getData("Rem870").country,
    manufacturer = ORGM.Firearm.getData("Rem870").manufacturer,
    description = ORGM.Firearm.getData("Rem870").description,
})
register("Silverhawk", {
    features = Flags.SINGLEACTION + Flags.SAFETY,
    feedSystem = Flags.BREAK,

    lastChanged = 24,
    category = ORGM.SHOTGUN,
    barrelLength = 28,
    isCivilian = ORGM.COMMON,
    soundProfile = "Shotgun-Break",

    classification = "IGUI_Firearm_DoubleShotgun",
    year = 1996,
    country = "IGUI_Firearm_Country_IT",
    manufacturer = "IGUI_Firearm_Manuf_Beretta",
    description = "IGUI_Firearm_Desc_Silverhawk",
})
register("SilverHawkSO", {
    features = Flags.SINGLEACTION + Flags.SAFETY,
    feedSystem = Flags.BREAK,

    lastChanged = 24,
    category = ORGM.SHOTGUN,
    barrelLength = 10,
    isCivilian = ORGM.COMMON,
    soundProfile = "Shotgun-Break",

    classification = ORGM.Firearm.getData("Silverhawk").classification,
    year = ORGM.Firearm.getData("Silverhawk").year,
    country = ORGM.Firearm.getData("Silverhawk").country,
    manufacturer = ORGM.Firearm.getData("Silverhawk").manufacturer,
    description = ORGM.Firearm.getData("Silverhawk").description
})
register("Spas12", {
    features = Flags.DOUBLEACTION + Flags.SLIDELOCK + Flags.SAFETY,
    feedSystem = Flags.PUMP + Flags.AUTO + Flags.SHORTGAS,

    lastChanged = 24,
    category = ORGM.SHOTGUN,
    barrelLength = 21.5, -- 18, 19-7/8,21.5, 24 -- 21.5 is the shortest we can go with our mag tube
    barrelLengthOpt = { 21.5, 24 },
    isCivilian = ORGM.RARE,
    isPolice = ORGM.RARE,
    isMilitary = ORGM.RARE,
    soundProfile = "Shotgun",

    classification = "IGUI_Firearm_DualShotgun",
    year = 1979,
    country = "IGUI_Firearm_Country_IT",
    manufacturer = "IGUI_Firearm_Manuf_Luigi",
    description = "IGUI_Firearm_Desc_Spas12",
})
register("Stevens320", {
    features = Flags.DOUBLEACTION + Flags.SAFETY,
    feedSystem = Flags.PUMP,

    lastChanged = 28,
    category = ORGM.SHOTGUN,
    barrelLength = 18.5,
    isCivilian = ORGM.COMMON,
    soundProfile = "Shotgun",

    classification = "IGUI_Firearm_PumpShotgun",
    year = 2012,
    country = "IGUI_Firearm_Country_CN",
    manufacturer = "IGUI_Firearm_Manuf_SA",
    description = "IGUI_Firearm_Desc_Stevens320"
})
register("Striker", {
    features = Flags.DOUBLEACTION + Flags.SAFETY,
    feedSystem = Flags.ROTARY,

    lastChanged = 24,
    category = ORGM.SHOTGUN,
    barrelLength = 18.5, -- 7.5, 12, 14, 18.5
    barrelLengthOpt = { 7.5, 12, 14, 18.5 },
    isCivilian = ORGM.VERYRARE,
    soundProfile = "Shotgun",
    rackSound = 'ORGMARRack',

    classification = "IGUI_Firearm_SemiShotgun",
    year = 1983,
    country = "IGUI_Firearm_Country_ZA",
    manufacturer = "IGUI_Firearm_Manuf_ASARDI",
    description = "IGUI_Firearm_Desc_Striker",
})
register("VEPR12", {
    features = Flags.DOUBLEACTION + Flags.SLIDELOCK + Flags.SAFETY,
    feedSystem = Flags.AUTO + Flags.SHORTGAS,

    lastChanged = 24,
    category = ORGM.SHOTGUN,
    barrelLength = 22.44, -- 19, 22.44, 26.5
    barrelLengthOpt = { 19, 22.44, 26.5 },
    isCivilian = ORGM.RARE,
    soundProfile = "Rifle-AR",
    clickSound = 'ORGMShotgunEmpty',

    classification = "IGUI_Firearm_SemiShotgun",
    year = 2003,
    country = "IGUI_Firearm_Country_RU",
    manufacturer = "IGUI_Firearm_Manuf_Molot",
    description = "IGUI_Firearm_Desc_VEPR12",
})
register("Win1887", {
    features = Flags.DOUBLEACTION + Flags.SAFETY,
    feedSystem = Flags.LEVER,

    lastChanged = 24,
    category = ORGM.SHOTGUN,
    barrelLength = 30, -- 18, 20, 30
    barrelLengthOpt = { 18, 20, 30 },
    isCivilian = ORGM.VERYRARE,
    soundProfile = "Shotgun-Lever",

    classification = "IGUI_Firearm_LeverShotgun",
    year = 1887,
    country = "IGUI_Firearm_Country_US",
    manufacturer = "IGUI_Firearm_Manuf_WRA",
    description = "IGUI_Firearm_Desc_Win1887"
})
register("Win1887SO", {
    features = Flags.DOUBLEACTION + Flags.SAFETY,
    feedSystem = Flags.LEVER,

    lastChanged = 24,
    category = ORGM.SHOTGUN,
    barrelLength = 14,
    soundProfile = "Shotgun-Lever",

    classification = ORGM.Firearm.getData("Win1887").classification,
    year = ORGM.Firearm.getData("Win1887").year,
    country = ORGM.Firearm.getData("Win1887").country,
    manufacturer = ORGM.Firearm.getData("Win1887").manufacturer,
    description = ORGM.Firearm.getData("Win1887").description,
})
]]
-- ORGM[15] = "138363034"
ORGM.log(ORGM.INFO, "All default firearms registered.")
