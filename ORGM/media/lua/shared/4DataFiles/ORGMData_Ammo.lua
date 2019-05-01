--[[- This file contains all default ammo data.

All calls made by this script are to `ORGM.Ammo.AmmoGroup.new` and `ORGM.Ammo.AmmoType.newCollction`
See the documention there.

@script ORGMData_Ammo.lua
@author Fenris_Wolf
@release 4.0
@copyright 2018 **File:** shared/4DataFiles/ORGMData_Ammo.lua

]]

local Ammo = ORGM.Ammo
local AmmoGroup = Ammo.AmmoGroup
local AmmoType = Ammo.AmmoType
local Flags = Ammo.Flags

AmmoGroup:new("AmmoGroup_Pistols")
AmmoGroup:new("AmmoGroup_Rifles")
AmmoGroup:new("AmmoGroup_Shotguns")
AmmoGroup:new("AmmoGroup_Rimfires")
AmmoGroup:new("AmmoGroup_NATO")
AmmoGroup:new("AmmoGroup_Surplus")
AmmoGroup:new("AmmoGroup_MatchGrade")


AmmoGroup:new("AmmoGroup_177mm")
AmmoGroup:new("AmmoGroup_22LR", { Groups = { AmmoGroup_Pistols = 1, AmmoGroup_Rimfires = 1 }}) -- super sonic in long barrels or hot loads
AmmoGroup:new("AmmoGroup_22Hornet", { Groups = { AmmoGroup_Pistols = 1 }})
AmmoGroup:new("AmmoGroup_32ACP",  { Groups = { AmmoGroup_Pistols = 1 }}) -- subsonic in short barrels
AmmoGroup:new("AmmoGroup_357Magnum", { Groups = { AmmoGroup_Pistols = 1 }})
AmmoGroup:new("AmmoGroup_38Special", { Groups = { AmmoGroup_Pistols = 1 }}) -- subsonic in medium
AmmoGroup:new("AmmoGroup_38Super", { Groups = { AmmoGroup_Pistols = 1 }}) -- 'might' go sub in a snub
AmmoGroup:new("AmmoGroup_380ACP", { Groups = { AmmoGroup_Pistols = 1 }})    -- sub in a snub
AmmoGroup:new("AmmoGroup_40SW", { Groups = { AmmoGroup_Pistols = 1 }})
AmmoGroup:new("AmmoGroup_41Magnum", { Groups = { AmmoGroup_Pistols = 1 }})
AmmoGroup:new("AmmoGroup_44Special", { Groups = { AmmoGroup_Pistols = 1 }}) -- subsonic
AmmoGroup:new("AmmoGroup_44Magnum", { Groups = { AmmoGroup_Pistols = 1 }})
AmmoGroup:new("AmmoGroup_45ACP", { Groups = { AmmoGroup_Pistols = 1 }})     -- subsonic
AmmoGroup:new("AmmoGroup_45Colt", { Groups = { AmmoGroup_Pistols = 1 }})    -- subsonic
AmmoGroup:new("AmmoGroup_454Casull", { Groups = { AmmoGroup_Pistols = 1 }})
AmmoGroup:new("AmmoGroup_480Ruger", { Groups = { AmmoGroup_Pistols = 1 }})
AmmoGroup:new("AmmoGroup_50AE", { Groups = { AmmoGroup_Pistols = 1 }})
AmmoGroup:new("AmmoGroup_57x28mm", { Groups = { AmmoGroup_Pistols = 1 }})
AmmoGroup:new("AmmoGroup_9x19mm", { Groups = { AmmoGroup_Pistols = 1 }})
AmmoGroup:new("AmmoGroup_10x25mm", { Groups = { AmmoGroup_Pistols = 1 }})

AmmoGroup:new("AmmoGroup_223Remington", { Groups = { AmmoGroup_Rifles = 1 }})
AmmoGroup:new("AmmoGroup_30Carbine", { Groups = { AmmoGroup_Rifles = 1 }})
AmmoGroup:new("AmmoGroup_3006Springfield", { Groups = { AmmoGroup_Rifles = 1 }})
AmmoGroup:new("AmmoGroup_3030Winchester", { Groups = { AmmoGroup_Rifles = 1 }})
AmmoGroup:new("AmmoGroup_308Winchester", { Groups = { AmmoGroup_Rifles = 1 }})
AmmoGroup:new("AmmoGroup_556x45mm", { Groups = { AmmoGroup_Rifles = 1 }})
AmmoGroup:new("AmmoGroup_762x39mm", { Groups = { AmmoGroup_Rifles = 1 }})
AmmoGroup:new("AmmoGroup_762x51mm", { Groups = { AmmoGroup_Rifles = 1 }})
AmmoGroup:new("AmmoGroup_762x54mm", { Groups = { AmmoGroup_Rifles = 1 }})

AmmoGroup:new("AmmoGroup_10g", { Groups = { AmmoGroup_Shotguns = 1 }})
AmmoGroup:new("AmmoGroup_12g", { Groups = { AmmoGroup_Shotguns = 1 }})
AmmoGroup:new("AmmoGroup_20g", { Groups = { AmmoGroup_Shotguns = 1 }})
AmmoGroup:new("AmmoGroup_410", { Groups = { AmmoGroup_Shotguns = 1 }})



AmmoType:newCollection("Ammo_22LR", {
        Case = "Case_22LR",    category = Flags.PISTOL,
        Range = 18, Recoil = 5, MinDamage = 0.4, MaxDamage = 0.8, Weight = 0.003,
        Penetration = 10, BoxCount = 100, CanCount = 1000,
        Groups = { AmmoGroup_22LR = 1, },
    }, {
        FMJ = {
            features = Flags.JACKETED + Flags.RIMFIRE,
        },
        HP = {
            features = Flags.JACKETED + Flags.HOLLOWPOINT + Flags.FLATPOINT + Flags.RIMFIRE,
        }
})
AmmoType:newCollection("Ammo_32ACP", {
        Case = "Case_32ACP",    category = Flags.PISTOL,
        Range = 15, Recoil = 6, MinDamage = 0.7, MaxDamage = 1.3, Weight = 0.01,
        Penetration = 15, BoxCount = 50, CanCount = 500,
        Groups = { AmmoGroup_32ACP = 1, },
    }, {
        FMJ = {
            features = Flags.JACKETED
        },
        HP = {
            features = Flags.JACKETED + Flags.HOLLOWPOINT + Flags.FLATPOINT,
        }
})
AmmoType:newCollection("Ammo_357Magnum", {
        Case = "Case_357Magnum",    category = Flags.PISTOL,
        Range = 25, Recoil = 13, MinDamage = 0.9, MaxDamage = 1.9, Weight = 0.010,
        Penetration = 50, BoxCount = 50, CanCount = 500,
        Groups = { AmmoGroup_357Magnum = 1, },
    }, {
        FMJ = {
            features = Flags.JACKETED
        },
        HP = {
            features = Flags.JACKETED + Flags.HOLLOWPOINT + Flags.FLATPOINT,
        }
})
AmmoType:newCollection("Ammo_38Special", {
        Case = "Case_38Special",    category = Flags.PISTOL,
        Range = 15, Recoil = 7, MinDamage = 0.7, MaxDamage = 1.6, Weight = 0.010,
        Penetration = 30, BoxCount = 50, CanCount = 500,
        Groups = { AmmoGroup_38Special = 1, AmmoGroup_357Magnum = 0.4, },
    }, {
        FMJ = {
            features = Flags.JACKETED
        },
        HP = {
            features = Flags.JACKETED + Flags.HOLLOWPOINT + Flags.FLATPOINT,
        }
})
AmmoType:newCollection("Ammo_38Super", {
        Case = "Case_38Super",    category = Flags.PISTOL,
        Range = 20, Recoil = 7, MinDamage = 0.7, MaxDamage = 1.7, Weight = 0.010,
        Penetration = 30, BoxCount = 50, CanCount = 500,
        Groups = { AmmoGroup_38Super = 1, },
    }, {
        FMJ = {
            features = Flags.JACKETED
        },
        HP = {
            features = Flags.JACKETED + Flags.HOLLOWPOINT + Flags.FLATPOINT,
        }
})
AmmoType:newCollection("Ammo_380ACP", {
        Case = "Case_380ACP",    category = Flags.PISTOL,
        Range = 18, Recoil = 8, MinDamage = 0.7, MaxDamage = 1.5, Weight = 0.010,
        Penetration = 25, BoxCount = 50, CanCount = 500,
        Groups = { AmmoGroup_380ACP = 1, AmmoGroup_9x19mm = 04, },
    }, {
        FMJ = {
            features = Flags.JACKETED
        },
        HP = {
            features = Flags.JACKETED + Flags.HOLLOWPOINT + Flags.FLATPOINT,
        }
})
AmmoType:newCollection("Ammo_40SW", {
        Case = "Case_40SW",    category = Flags.PISTOL,
        Range = 20, Recoil = 11, MinDamage = 0.8, MaxDamage = 1.7, Weight = 0.010,
        Penetration = 50, BoxCount = 50, CanCount = 500,
        Groups = { AmmoGroup_40SW = 1, AmmoGroup_10x25mm = 0.4 },
    }, {
        FMJ = {
            features = Flags.JACKETED
        },
        HP = {
            features = Flags.JACKETED + Flags.HOLLOWPOINT + Flags.FLATPOINT,
        }
})
AmmoType:newCollection("Ammo_44Magnum", {
        Case = "Case_44Magnum",     category = Flags.PISTOL,
        Range = 25, Recoil = 15, MinDamage = 1.2, MaxDamage = 2.2, Weight = 0.012,
        Penetration = 65, BoxCount = 50, CanCount = 400,
        Groups = { AmmoGroup_44Magnum = 1, },
    }, {
        FMJ = {
            features = Flags.JACKETED
        },
        HP = {
            features = Flags.JACKETED + Flags.HOLLOWPOINT + Flags.FLATPOINT,
        }
})
AmmoType:newCollection("Ammo_45ACP", {
        Case = "Case_45ACP",    category = Flags.PISTOL,
        Range = 17, Recoil = 13, MinDamage = 1.0, MaxDamage = 1.8, Weight = 0.010,
        Penetration = 45, BoxCount = 50, CanCount = 500,
        Groups = { AmmoGroup_45ACP = 1, },
    }, {
        FMJ = {
            features = Flags.JACKETED
        },
        HP = {
            features = Flags.JACKETED + Flags.HOLLOWPOINT + Flags.FLATPOINT,
        }
})
AmmoType:newCollection("Ammo_45Colt", {
        Case = "Case_45Colt",    category = Flags.PISTOL,
        Range = 25, Recoil = 15, MinDamage = 1.1, MaxDamage = 2.1, Weight = 0.010,
        Penetration = 60, BoxCount = 50, CanCount = 500,
        Groups = { AmmoGroup_45Colt = 1, AmmoGroup_454Casull = 0.7 },
    }, {
        FMJ = {
            features = Flags.JACKETED
        },
        HP = {
            features = Flags.JACKETED + Flags.HOLLOWPOINT + Flags.FLATPOINT,
        }
})
AmmoType:newCollection("Ammo_454Casull", {
        Case = "Case_454Casull",    category = Flags.PISTOL,
        Range = 25, Recoil = 15, MinDamage = 1.3, MaxDamage = 2.3, Weight = 0.012,
        Penetration = 67, BoxCount = 50, CanCount = 500,
        Groups = { AmmoGroup_45Colt = 0.7, AmmoGroup_454Casull = 1 },
    }, {
        FMJ = {
            features = Flags.JACKETED
        },
        HP = {
            features = Flags.JACKETED + Flags.HOLLOWPOINT + Flags.FLATPOINT,
        }
})
AmmoType:newCollection("Ammo_50AE", {
        Case = "Case_50AE",    category = Flags.PISTOL,
        Range = 25, Recoil = 15, MinDamage = 1.3, MaxDamage = 2.3, Weight = 0.012,
        Penetration = 67, BoxCount = 50, CanCount = 500,
        Groups = { AmmoGroup_50AE = 1 },
    }, {
        FMJ = {
            features = Flags.JACKETED
        },
        HP = {
            features = Flags.JACKETED + Flags.HOLLOWPOINT + Flags.FLATPOINT,
        }
})
AmmoType:newCollection("Ammo_57x28mm", {
        Case = "Case_57x28mm",    category = Flags.PISTOL,
        Range = 25, Recoil = 7, MinDamage = 0.6, MaxDamage = 1.4, Weight = 0.010,
        Penetration = 90, BoxCount = 50, CanCount = 500,
        Groups = { AmmoGroup_57x28mm = 1 },
    }, {
        FMJ = {
            features = Flags.JACKETED
        },
        HP = {
            features = Flags.JACKETED + Flags.HOLLOWPOINT + Flags.FLATPOINT,
        }
})
AmmoType:newCollection("Ammo_9x19mm", {
        Case = "Case_57x28mm",    category = Flags.PISTOL,
        Range = 20, Recoil = 10, MinDamage = 0.7, MaxDamage = 1.6, Weight = 0.010,
        Penetration = 50, BoxCount = 50, CanCount = 500,
        Groups = { AmmoGroup_9x19mm = 1 },
    }, {
        FMJ = {
            features = Flags.JACKETED
        },
        HP = {
            features = Flags.JACKETED + Flags.HOLLOWPOINT + Flags.FLATPOINT,
        }
})
AmmoType:newCollection("Ammo_10x25mm", {
        Case = "Case_10x25mm",    category = Flags.PISTOL,
        Range = 20, Recoil = 12, MinDamage = 0.9, MaxDamage = 1.9, Weight = 0.010,
        Penetration = 55, BoxCount = 50, CanCount = 500,
        Groups = { AmmoGroup_10x25mm = 1 },
    }, {
        FMJ = {
            features = Flags.JACKETED
        },
        HP = {
            features = Flags.JACKETED + Flags.HOLLOWPOINT + Flags.FLATPOINT,
        }
})

AmmoType:newCollection("Ammo_223Remington", {
        Case = "Case_223Remington",     category = Flags.RIFLE,
        Range = 30, Recoil = 20, MinDamage = 1.4, MaxDamage = 2.4, Weight = 0.015,
        Penetration = 75, BoxCount = 20, CanCount = 200,

        Groups = { AmmoGroup_223Remington = 1, AmmoGroup_556x45mm = 0.7 },
    }, {
        FMJ = {
            features = Flags.JACKETED
        },
        HP = {
            features = Flags.JACKETED + Flags.HOLLOWPOINT,
        }
})
AmmoType:newCollection("Ammo_3006Springfield", {
        Case = "Case_3006Springfield",     category = Flags.RIFLE,
        Range = 35, Recoil = 28, MinDamage = 1.4, MaxDamage = 2.7, Weight = 0.020,
        Penetration = 80, BoxCount = 20, CanCount = 200,

        Groups = { AmmoGroup_3006Springfield = 1 },
    }, {
        FMJ = {
            features = Flags.JACKETED
        },
        HP = {
            features = Flags.JACKETED + Flags.HOLLOWPOINT,
        }
})
AmmoType:newCollection("Ammo_3030Winchester", {
        Case = "Case_3030Winchester",     category = Flags.RIFLE,
        Range = 30, Recoil = 20, MinDamage = 0.8, MaxDamage = 1.9, Weight = 0.020,
        Penetration = 80, BoxCount = 20, CanCount = 200,

        Groups = { AmmoGroup_3030Winchester = 1 },
    }, {
        FMJ = {
            features = Flags.JACKETED + Flags.FLATPOINT
        },
        HP = {
            features = Flags.JACKETED + Flags.HOLLOWPOINT + Flags.FLATPOINT,
        }
})
AmmoType:newCollection("Ammo_308Winchester", {
        Case = "Case_308Winchester",     category = Flags.RIFLE,
        Range = 33, Recoil = 25, MinDamage = 1.4, MaxDamage = 2.6, Weight = 0.020,
        Penetration = 80, BoxCount = 20, CanCount = 200,

        Groups = { AmmoGroup_308Winchester = 1, AmmoGroup_762x51mm = 0.7 },
    }, {
        FMJ = {
            features = Flags.JACKETED + Flags.FLATPOINT
        },
        HP = {
            features = Flags.JACKETED + Flags.HOLLOWPOINT + Flags.FLATPOINT,
        }
})
AmmoType:newCollection("Ammo_556x45mm", {
        Case = "Case_556x45mm",     category = Flags.RIFLE,
        Range = 30, Recoil = 20, MinDamage = 1.4, MaxDamage = 2.4, Weight = 0.015,
        Penetration = 75, BoxCount = 20, CanCount = 200,

        Groups = { AmmoGroup_223Remington = 0.8, AmmoGroup_556x45mm = 1 },
    }, {
        M193 = {
            --M193: 5.56×45mm 55-grain [3.56 g] ball cartridge. This was type-standardized and designated by the US Army in September, 1963.
            features = Flags.JACKETED + Flags.SURPLUS + Flags.BULK,
            addGroups = { NATO = 1, },
        },
        M855 = {
            -- standardized on October 28, 1980
            features = Flags.JACKETED + Flags.SURPLUS,
            addGroups = { NATO = 1, },
        },

        FMJ = {
            features = Flags.JACKETED + Flags.FLATPOINT
        },
        HP = {
            features = Flags.JACKETED + Flags.HOLLOWPOINT + Flags.FLATPOINT,
        }
})
AmmoType:newCollection("Ammo_762x39mm", {
        Case = "Case_762x39mm",     category = Flags.RIFLE,
        Range = 28, Recoil = 20, MinDamage = 1.2, MaxDamage = 2.5, Weight = 0.020,
        Penetration = 80, BoxCount = 20, CanCount = 200,

        Groups = { AmmoGroup_762x39mm = 1 },
    }, {
        FMJ = {
            features = Flags.JACKETED + Flags.FLATPOINT
        },
        HP = {
            features = Flags.JACKETED + Flags.HOLLOWPOINT + Flags.FLATPOINT,
        }
})
AmmoType:newCollection("Ammo_762x51mm", {
        Case = "Case_762x51mm",     category = Flags.RIFLE,
        Range = 33, Recoil = 25, MinDamage = 1.4, MaxDamage = 2.6, Weight = 0.020,
        Penetration = 80, BoxCount = 20, CanCount = 200,

        Groups = { AmmoGroup_308Winchester = 0.7, AmmoGroup_762x51mm = 1 },
    }, {
        FMJ = {
            features = Flags.JACKETED + Flags.FLATPOINT
        },
        HP = {
            features = Flags.JACKETED + Flags.HOLLOWPOINT + Flags.FLATPOINT,
        }
})
AmmoType:newCollection("Ammo_762x54mm", {
        Case = "Case_762x54mm",     category = Flags.RIFLE,
        Range = 35, Recoil = 25, MinDamage = 1.6, MaxDamage = 2.8, Weight = 0.025,
        Penetration = 80, BoxCount = 20, CanCount = 200,

        Groups = { AmmoGroup_762x39mm = 1 },
    }, {
        FMJ = {
            features = Flags.JACKETED + Flags.FLATPOINT
        },
        HP = {
            features = Flags.JACKETED + Flags.HOLLOWPOINT + Flags.FLATPOINT,
        }
})
AmmoType:newCollection("Ammo_12g", {
        Case = "Case_12g",     category = Flags.SHOTGUN,
        Range = 35, Recoil = 50, MinDamage = 1.0, MaxDamage = 2.2, Weight = 0.04,
        Penetration = 0, MaxHitCount = 4, BoxCount = 20, CanCount = 200,

        Groups = { AmmoGroup_12g = 1 },
    }, {
        Buck00 = {
            features = Flags.BUCKSHOT,
        },
        Slug = {
            features = Flags.SLUG,
            MinDamage = 2.0, MaxDamage = 2.8, MaxHitCount = 1, Penetration = 95,
        }
})


--[[


register("Ammo_177BB",
    { OptimalBarrel = 12, Range = 15, Recoil = 2, MinDamage = 0.1, MaxDamage = 0.1, Penetration = false, Groups = {"AmmoGroup_177BB"}, BoxCount = 250, CanCount = 1000, DisplayName = ".177", RoundType = "BB", Weight = 0.001 }
)


register("Ammo_12g_00Buck",
    { OptimalBarrel = 60, Range = 10, Recoil = 50, MinDamage = 1.0, MaxDamage = 2.2, MaxHitCount = 4, Penetration = false, Case = "Case_12g", Groups = {"AmmoGroup_12g"}, BoxCount = 25, CanCount = 250, DisplayName = "12 Gauge 00 Buck", Weight = 0.04, RoundType = "Shell" }
)
register("Ammo_12g_Slug",
    { OptimalBarrel = 60, Range = 12, Recoil = 50, MinDamage = 2.0, MaxDamage = 2.8, MaxHitCount = 1, Penetration = 95, Case = "Case_12g", Groups = {"AmmoGroup_12g"}, BoxCount = 25, CanCount = 250, DisplayName = "12 Gauge Slug", Weight = 0.04, RoundType = "Shell" }
)
]]
ORGM.log(ORGM.INFO, "All default ammo registered.")
