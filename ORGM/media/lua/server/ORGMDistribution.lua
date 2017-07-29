--[[ Changes by Fenris_Wolf:
    functions and tables polluting the global namespace have been converted into locals.
    All weapons tables have been merged: see WeaponsTable and SelectTable()
    Large amounts of redundant/repetitive code have been merged into functions.
    Naming conventions: Tables and Functions in the file are UpperCase, variables passed as arguments to functions are
        camelCase, variables created in functions are lower_cased
]]


-- possible upgrades, not local!
WeaponUpgrades = {
    Ber92 = { 
        "ORGM.FibSig",
    };

    BrenTen = { 
        "ORGM.FibSig",
    };

    BrownHP = { 
        "ORGM.FibSig",
    };

    ColtDelta = { 
        "ORGM.FibSig",
    };

    Glock20 = { 
        "ORGM.FibSig",
    };

    FN57 = { 
        "ORGM.FibSig",
    };

    Glock17 = { 
        "ORGM.FibSig",
    };

    WaltherPPK = { 
        "ORGM.FibSig",
    };

    Glock22 = { 
        "ORGM.FibSig",
    };

    Glock21 = { 
        "ORGM.FibSig",
    };

    M1911 = { 
        "ORGM.FibSig",
    };

    RugerMKII = { 
        "ORGM.FibSig",
    };

    SIGP226 = { 
        "ORGM.FibSig",
    };

    WaltherP22 = { 
        "ORGM.FibSig",
    };

    Colt38S = { 
        "ORGM.FibSig",
    };

    Taurus38 = { 
        "ORGM.FibSig",
    };

    DEagle = { 
        "ORGM.FibSig",
    };

    DEagleXIX = { 
        "ORGM.FibSig",
    };

    AutomagV = { 
        "ORGM.FibSig",
    };

    XD40 = { 
        "ORGM.FibSig",
    };
    
    Glock18 = { 
        "ORGM.FibSig",
    };
    
    Ber93R = { 
        "ORGM.FibSig",
    };
    
    CZ75 = { 
        "ORGM.FibSig",
    };
    
    KTP32 = { 
        "ORGM.FibSig",
    };
    
    TaurusP132 = { 
        "ORGM.FibSig",
    };
    
    SPR19119 = { 
        "ORGM.FibSig",
    };

    RugerSR9 = { 
        "ORGM.FibSig",
    };

    KahrCT40 = { 
        "ORGM.FibSig",
    };

    KahrP380 = { 
        "ORGM.FibSig",
    };

    ColtAnac = { 
        "ORGM.2xScope",
    };

    RugRH = { 
        "ORGM.2xScope",
    };

    SWM29 = { 
        "ORGM.2xScope",
    };

    Taurus454 = { 
        "ORGM.2xScope",
    };

    HKMP5 = { 
        "ORGM.Foregrip",
    };

    HKUMP = { 
        "ORGM.Foregrip",
    };

    Kriss = { 
        "ORGM.Foregrip",
    };
    
    KrissA = { 
        "ORGM.Foregrip",
    };

    AKM = { 
        "ORGM.Rifsling",
    };
    
    AKMA = { 
        "ORGM.Rifsling",
    };

    AR10= { 
        "ORGM.Rifsling",
    };

    AR15 = { 
        "ORGM.Rifsling",
    };
    
    SIG550 = { 
        "ORGM.Rifsling",
    };
    
    SIG551 = { 
        "ORGM.Rifsling",
    };

    M249 = { 
        "ORGM.Rifsling",
    };

    FNFAL = { 
        "ORGM.Rifsling",
    };
    
    FNFALA = { 
        "ORGM.Rifsling",
    };

    HK91 = { 
        "ORGM.Rifsling",
    };

    HKG3 = { 
        "ORGM.Rifsling",
    };

    Garand = { 
        "ORGM.Rifsling",
    };

    M16 = { 
        "ORGM.Rifsling",
    };

    Rug1022 = { 
        "ORGM.Rifsling",
    };
    
    Marlin60 = { 
        "ORGM.Rifsling",
    };

    Mini14 = { 
        "ORGM.Rifsling",
    };

    SKS = { 
        "ORGM.Rifsling",
    };

    M21 = { 
        "ORGM.Rifsling",
        "ORGM.8xScope",
    };

    Rem700 = { 
        "ORGM.Rifsling",
        "ORGM.8xScope",
    };

    BLR = { 
        "ORGM.Rifsling",
    };

    HenryBB = { 
        "ORGM.Rifsling",
    };
    
    WinM94 = { 
        "ORGM.Rifsling",
    };

    Mosin = { 
        "ORGM.Rifsling",
    };

    SA80 = { 
        "ORGM.Rifsling",
    };

    HKSL8 = { 
        "ORGM.Rifsling",
    };
    
    LENo4 = { 
        "ORGM.Rifsling",
    };

    WinM70 = { 
        "ORGM.Rifsling",
        "ORGM.8xScope",
    };
    
    Rem788 = { 
        "ORGM.Rifsling",
        "ORGM.8xScope",
    };
    
    SR25 = { 
        "ORGM.Rifsling",
        "ORGM.8xScope",
    };

    AIAW308 = { 
        "ORGM.Rifsling",
        "ORGM.8xScope",
    };

    SVD = { 
        "ORGM.Rifsling",
        "ORGM.8xScope",
    };
    
    M1903 = { 
        "ORGM.Rifsling",
        "ORGM.8xScope",
    };

    M4C = { 
        "ORGM.Rifsling",
    };

    BenelliM3 = { 
        "ORGM.Rifsling",
        "ORGM.FullCh",
        "ORGM.HalfCh",
    };

    Ithaca37 = { 
        "ORGM.Rifsling",
        "ORGM.FullCh",
        "ORGM.HalfCh",
    };

    Moss590 = { 
        "ORGM.Rifsling",
        "ORGM.FullCh",
        "ORGM.HalfCh",
    };

    Rem870 = { 
        "ORGM.Rifsling",
        "ORGM.FullCh",
        "ORGM.HalfCh",
    };

    Silverhawk = { 
        "ORGM.Rifsling",
        "ORGM.FullCh",
        "ORGM.HalfCh",
    };

    Spas12 = { 
        "ORGM.Rifsling",
        "ORGM.FullCh",
        "ORGM.HalfCh",
    };

    Stevens320 = { 
        "ORGM.Rifsling",
        "ORGM.FullCh",
        "ORGM.HalfCh",
    };

    Vepr12 = { 
        "ORGM.Rifsling",
        "ORGM.FullCh",
        "ORGM.HalfCh",
    };

    M1216 = { 
        "ORGM.Rifsling",
        "ORGM.FullCh",
        "ORGM.HalfCh",
    };
    
    Hawk982 = { 
        "ORGM.Rifsling",
        "ORGM.FullCh",
        "ORGM.HalfCh",
    };
    
    Win1887 = { 
        "ORGM.Rifsling",
        "ORGM.FullCh",
        "ORGM.HalfCh",
    };
    
    Striker = { 
        "ORGM.FullCh",
        "ORGM.HalfCh",
    };

};

--[[ WeaponsTable
    All the various weapon and ammo tables have been merged into a single multi layered table for clarity and maintainability.
    (see SelectTable function below)
]]
local WeaponsTable = {
    Civilian = {
        { -- common
            Weapon = {
                "ORGM.Ber92",
                "ORGM.BrownHP",
                "ORGM.BBPistol",
                "ORGM.Glock17",
                "ORGM.Glock22",
                "ORGM.Glock21",
                "ORGM.M1911",
                "ORGM.RugerMKII",
                "ORGM.SIGP226",
                "ORGM.WaltherP22",
                "ORGM.ColtAnac",
                "ORGM.ColtPyth",
                "ORGM.RugSec6",
                "ORGM.SWM36",
                "ORGM.Taurus454",
                "ORGM.Garand",
                "ORGM.BBGun",
                "ORGM.Rem700",
                "ORGM.Rug1022",
                "ORGM.Mini14",
                "ORGM.SKS",
                "ORGM.Ithaca37",
                "ORGM.Ithaca37SO",
                "ORGM.Moss590",
                "ORGM.Moss590SO",
                "ORGM.Rem870",
                "ORGM.Rem870SO",
                "ORGM.Silverhawk",
                "ORGM.SilverHawkSO",
                "ORGM.WaltherPPK",
                "ORGM.Mosin",
                "ORGM.BLR",
                "ORGM.Glock20",
                "ORGM.Stevens320",
                "ORGM.RugerSR9",
                "ORGM.XD40",
                "ORGM.KahrP380",
                "ORGM.KahrCT40",
                "ORGM.Hawk982",
                "ORGM.Marlin60",
                "ORGM.KTP32",
                "ORGM.TaurusP132",
                "ORGM.Spr19119",
                "ORGM.SWM10",
                "ORGM.AR15",
            },
            Ammo = {
                "ORGM.9mmRounds",
                "ORGM.9mmRounds",
                "ORGM.BBs",
                "ORGM.9mmRounds",
                "ORGM.40Rounds",
                "ORGM.45Rounds",
                "ORGM.45Rounds",
                "ORGM.22Rounds",
                "ORGM.40Rounds",
                "ORGM.22Rounds",
                "ORGM.44Rounds",
                "ORGM.357Rounds",
                "ORGM.38Rounds",
                "ORGM.38Rounds",
                "ORGM.454Rounds",
                "ORGM.3006Rounds",
                "ORGM.BBs",
                "ORGM.3006Rounds",
                "ORGM.22Rounds",
                "ORGM.223Rounds",
                "ORGM.762Rounds",
                "ORGM.12gRounds",
                "ORGM.12gRounds",
                "ORGM.12gRounds",
                "ORGM.12gRounds",
                "ORGM.12gRounds",
                "ORGM.12gRounds",
                "ORGM.12gRounds",
                "ORGM.12gRounds",
                "ORGM.380Rounds",
                "ORGM.762x54Rounds",
                "ORGM.308Rounds",
                "ORGM.10mmRounds",
                "ORGM.12gRounds",
                "ORGM.9mmRounds",
                "ORGM.40Rounds",
                "ORGM.380Rounds",
                "ORGM.40Rounds",
                "ORGM.12gRounds",
                "ORGM.22Rounds",
                "ORGM.32Rounds",
                "ORGM.32Rounds",
                "ORGM.9mmRounds",
                "ORGM.38Rounds",
                "ORGM.223Rounds",
            },
            Ammo2 = {
    "ORGM.9mmRounds",
    "ORGM.9mmRounds",
    "ORGM.BBs",
    "ORGM.9mmRounds",
    "ORGM.40Rounds",
    "ORGM.45Rounds",
    "ORGM.45Rounds",
    "ORGM.22Rounds",
    "ORGM.40Rounds",
    "ORGM.22Rounds",
    "ORGM.44Rounds",
    "ORGM.38Rounds",
    "ORGM.38Rounds",
    "ORGM.38Rounds",
    "ORGM.45ColtRounds",
    "ORGM.3006Rounds",
    "ORGM.BBs",
    "ORGM.3006Rounds",
    "ORGM.22Rounds",
    "ORGM.556Rounds",
    "ORGM.762Rounds",
    "ORGM.12gSlugRounds",
    "ORGM.12gSlugRounds",
    "ORGM.12gSlugRounds",
    "ORGM.12gSlugRounds",
    "ORGM.12gSlugRounds",
    "ORGM.12gSlugRounds",
    "ORGM.12gSlugRounds",
    "ORGM.12gSlugRounds",
    "ORGM.380Rounds",
    "ORGM.762x54Rounds",
    "ORGM.762x51Rounds",
    "ORGM.10mmRounds",
    "ORGM.12gSlugRounds",
    "ORGM.9mmRounds",
    "ORGM.40Rounds",
    "ORGM.380Rounds",
    "ORGM.40Rounds",
    "ORGM.12gSlugRounds",
    "ORGM.22Rounds",
    "ORGM.32Rounds",
    "ORGM.32Rounds",
    "ORGM.9mmRounds",
    "ORGM.38Rounds",
    "ORGM.556Rounds",
            },
            Box = {
    "ORGM.9mmBox",
    "ORGM.9mmBox",
    "ORGM.BBCan",
    "ORGM.9mmBox",
    "ORGM.40Box",
    "ORGM.45Box",
    "ORGM.45Box",
    "ORGM.22Box",
    "ORGM.40Box",
    "ORGM.22Box",
    "ORGM.44Box",
    "ORGM.357Box",
    "ORGM.38Box",
    "ORGM.38Box",
    "ORGM.454Box",
    "ORGM.3006Box",
    "ORGM.BBCan",
    "ORGM.3006Box",
    "ORGM.22Box",
    "ORGM.223RemBox",
    "ORGM.762Box",
    "ORGM.12gBox",
    "ORGM.12gBox",
    "ORGM.12gBox",
    "ORGM.12gBox",
    "ORGM.12gBox",
    "ORGM.12gBox",
    "ORGM.12gBox",
    "ORGM.12gBox",
    "ORGM.380Box",
    "ORGM.762x54Box",
    "ORGM.308wBox",
    "ORGM.10mmBox",
    "ORGM.12gBox",
    "ORGM.9mmBox",
    "ORGM.40Box",
    "ORGM.380Box",
    "ORGM.40Box",
    "ORGM.12gBox",
    "ORGM.22Box",
    "ORGM.32Box",
    "ORGM.32Box",
    "ORGM.9mmBox",
    "ORGM.38Box",
    "ORGM.223RemBox",
            },
            Box2 = {
    "ORGM.9mmBox",
    "ORGM.9mmBox",
    "ORGM.BBCan",
    "ORGM.9mmBox",
    "ORGM.40Box",
    "ORGM.45Box",
    "ORGM.45Box",
    "ORGM.22Box",
    "ORGM.40Box",
    "ORGM.22Box",
    "ORGM.44Box",
    "ORGM.38Box",
    "ORGM.38Box",
    "ORGM.38Box",
    "ORGM.45ColtBox",
    "ORGM.3006Box",
    "ORGM.BBCan",
    "ORGM.3006Box",
    "ORGM.22Box",
    "ORGM.556Box",
    "ORGM.762Box",
    "ORGM.12gSlugBox",
    "ORGM.12gSlugBox",
    "ORGM.12gSlugBox",
    "ORGM.12gSlugBox",
    "ORGM.12gSlugBox",
    "ORGM.12gSlugBox",
    "ORGM.12gSlugBox",
    "ORGM.12gSlugBox",
    "ORGM.380Box",
    "ORGM.762x54Box",
    "ORGM.762x51Box",
    "ORGM.10mmBox",
    "ORGM.12gSlugBox",
    "ORGM.9mmBox",
    "ORGM.40Box",
    "ORGM.380Box",
    "ORGM.40Box",
    "ORGM.12gSlugBox",
    "ORGM.22Box",
    "ORGM.32Box",
    "ORGM.32Box",
    "ORGM.9mmBox",
    "ORGM.38Box",
    "ORGM.556Box",
            },
            Can = {
    "ORGM.9mmCan",
    "ORGM.9mmCan",
    "ORGM.BBCan",
    "ORGM.9mmCan",
    "ORGM.40Can",
    "ORGM.45Can",
    "ORGM.45Can",
    "ORGM.22Can",
    "ORGM.40Can",
    "ORGM.22Can",
    "ORGM.44Can",
    "ORGM.357Can",
    "ORGM.38Can",
    "ORGM.38Can",
    "ORGM.454Can",
    "ORGM.3006Can",
    "ORGM.BBCan",
    "ORGM.3006Can",
    "ORGM.22Can",
    "ORGM.223RemCan",
    "ORGM.762Can",
    "ORGM.12gCan",
    "ORGM.12gCan",
    "ORGM.12gCan",
    "ORGM.12gCan",
    "ORGM.12gCan",
    "ORGM.12gCan",
    "ORGM.12gCan",
    "ORGM.12gCan",
    "ORGM.380Can",
    "ORGM.762x54Can",
    "ORGM.308wCan",
    "ORGM.10mmCan",
    "ORGM.12gCan",
    "ORGM.9mmCan",
    "ORGM.40Can",
    "ORGM.380Can",
    "ORGM.40Can",
    "ORGM.12gCan",
    "ORGM.22Can",
    "ORGM.32Can",
    "ORGM.32Can",
    "ORGM.9mmCan",
    "ORGM.38Can",
    "ORGM.223RemCan",
            },
            Can2 = {
    "ORGM.9mmCan",
    "ORGM.9mmCan",
    "ORGM.BBCan",
    "ORGM.9mmCan",
    "ORGM.40Can",
    "ORGM.45Can",
    "ORGM.45Can",
    "ORGM.22Can",
    "ORGM.40Can",
    "ORGM.22Can",
    "ORGM.44Can",
    "ORGM.38Can",
    "ORGM.38Can",
    "ORGM.38Can",
    "ORGM.45ColtCan",
    "ORGM.3006Can",
    "ORGM.BBCan",
    "ORGM.3006Can",
    "ORGM.22Can",
    "ORGM.556Can",
    "ORGM.762Can",
    "ORGM.12gSlugCan",
    "ORGM.12gSlugCan",
    "ORGM.12gSlugCan",
    "ORGM.12gSlugCan",
    "ORGM.12gSlugCan",
    "ORGM.12gSlugCan",
    "ORGM.12gSlugCan",
    "ORGM.12gSlugCan",
    "ORGM.380Can",
    "ORGM.762x54Can",
    "ORGM.762x51Can",
    "ORGM.10mmCan",
    "ORGM.12gSlugCan",
    "ORGM.9mmCan",
    "ORGM.40Can",
    "ORGM.380Can",
    "ORGM.40Can",
    "ORGM.12gSlugCan",
    "ORGM.22Can",
    "ORGM.32Can",
    "ORGM.32Can",
    "ORGM.9mmCan",
    "ORGM.38Can",
    "ORGM.556Can",
            },
            Mag = {
    "ORGM.Ber92Mag",
    "ORGM.BrownHPMag",
    "ORGM.BBPistolMag",
    "ORGM.Glock17Mag",
    "ORGM.Glock22Mag",
    "ORGM.Glock21Mag",
    "ORGM.M1911Mag",
    "ORGM.RugerMKIIMag",
    "ORGM.SIGP226Mag",
    "ORGM.WaltherP22Mag",
    "ORGM.SpeedLoader446",
    "ORGM.SpeedLoader3576",
    "ORGM.SpeedLoader386",
    "ORGM.SpeedLoader385",
    "ORGM.SpeedLoader4546",
    "ORGM.GarandClip",
    "",
    "",
    "ORGM.Rug1022Mag",
    "ORGM.Mini14Mag",
    "ORGM.SKSStripperClip",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "ORGM.WaltherPPKMag",
    "ORGM.MosinStripperClip",
    "",
    "ORGM.Glock20Mag",
    "",
    "ORGM.RugerSR9Mag",
    "ORGM.XD40Mag",
    "ORGM.KahrP380Mag",
    "ORGM.KahrCT40Mag",
    "",
    "",
    "ORGM.KTP32Mag",
    "ORGM.TaurusP132Mag",
    "ORGM.Spr19119Mag",
    "ORGM.SpeedLoader386",
    "ORGM.STANAG223Mag",
            },
        },
        { -- rare
            Weapon = {
    "ORGM.BrenTen",
    "ORGM.ColtDelta",
    "ORGM.FN57",
    "ORGM.Colt38S",
    "ORGM.Taurus38",
    "ORGM.RugAlas",
    "ORGM.RugGP100",
    "ORGM.RugRH",
    "ORGM.SWM19",
    "ORGM.SWM29",
    "ORGM.SWM610",
    "ORGM.AKM",
    "ORGM.R25",
    "ORGM.FNFAL",
    "ORGM.HK91",
    "ORGM.WinM70",
    "ORGM.AIAW308",
    "ORGM.Spas12",
    "ORGM.HKSL8",
    "ORGM.M1A1",
    "ORGM.DEagle",
    "ORGM.Kriss",
    "ORGM.KTPLR",
    "ORGM.Mac10",
    "ORGM.Mac11",
    "ORGM.Uzi",
    "ORGM.M1216",
    "ORGM.VEPR12",
    "ORGM.SVD",
    "ORGM.HenryBB",
    "ORGM.ColtSAA",
    "ORGM.DEagleXIX",
    "ORGM.AutomagV",
    "ORGM.Striker",
    "ORGM.WinM94",
    "ORGM.Rem788",
    "ORGM.CZ75",
    "ORGM.HKMK23",
    "ORGM.M1903",
    "ORGM.LENo4",
    "ORGM.RugBH",
    "ORGM.SWM252",
            },
            Ammo = {
    "ORGM.10mmRounds",
    "ORGM.10mmRounds",
    "ORGM.57Rounds",
    "ORGM.38SRounds",
    "ORGM.38SRounds",
    "ORGM.454Rounds",
    "ORGM.357Rounds",
    "ORGM.44Rounds",
    "ORGM.357Rounds",
    "ORGM.44Rounds",
    "ORGM.10mmRounds",
    "ORGM.762Rounds",
    "ORGM.308Rounds",
    "ORGM.308Rounds",
    "ORGM.308Rounds",
    "ORGM.3006Rounds",
    "ORGM.308Rounds",
    "ORGM.12gRounds",
    "ORGM.223Rounds",
    "ORGM.45Rounds",
    "ORGM.44Rounds",
    "ORGM.45Rounds",
    "ORGM.223Rounds",
    "ORGM.45Rounds",
    "ORGM.380Rounds",
    "ORGM.9mmRounds",
    "ORGM.12gRounds",
    "ORGM.12gRounds",
    "ORGM.762x54Rounds",
    "ORGM.45ColtRounds",
    "ORGM.45ColtRounds",
    "ORGM.50AERounds",
    "ORGM.50AERounds",
    "ORGM.12gRounds",
    "ORGM.3030Rounds",
    "ORGM.3030Rounds",
    "ORGM.40Rounds",
    "ORGM.45Rounds",
    "ORGM.3006Rounds",
    "ORGM.762x51Rounds",
    "ORGM.357Rounds",
    "ORGM.45Rounds",
            },
            Ammo2 = {
    "ORGM.10mmRounds",
    "ORGM.10mmRounds",
    "ORGM.57Rounds",
    "ORGM.38SRounds",
    "ORGM.38SRounds",
    "ORGM.45ColtRounds",
    "ORGM.38Rounds",
    "ORGM.44Rounds",
    "ORGM.38Rounds",
    "ORGM.44Rounds",
    "ORGM.10mmRounds",
    "ORGM.762Rounds",
    "ORGM.762x51Rounds",
    "ORGM.762x51Rounds",
    "ORGM.762x51Rounds",
    "ORGM.3006Rounds",
    "ORGM.762x51Rounds",
    "ORGM.12gSlugRounds",
    "ORGM.556Rounds",
    "ORGM.45Rounds",
    "ORGM.44Rounds",
    "ORGM.45Rounds",
    "ORGM.556Rounds",
    "ORGM.45Rounds",
    "ORGM.380Rounds",
    "ORGM.9mmRounds",
    "ORGM.12gSlugRounds",
    "ORGM.12gSlugRounds",
    "ORGM.762x54Rounds",
    "ORGM.45ColtRounds",
    "ORGM.45ColtRounds",
    "ORGM.50AERounds",
    "ORGM.50AERounds",
    "ORGM.12gSlugRounds",
    "ORGM.3030Rounds",
    "ORGM.3030Rounds",
    "ORGM.40Rounds",
    "ORGM.45Rounds",
    "ORGM.3006Rounds",
    "ORGM.308Rounds",
    "ORGM.38Rounds",
    "ORGM.45Rounds",
            },
            Box = {
    "ORGM.10mmBox",
    "ORGM.10mmBox",
    "ORGM.57Box",
    "ORGM.38SBox",
    "ORGM.38SBox",
    "ORGM.454Box",
    "ORGM.357Box",
    "ORGM.44Box",
    "ORGM.357Box",
    "ORGM.44Box",
    "ORGM.10mmBox",
    "ORGM.762Box",
    "ORGM.308wBox",
    "ORGM.308wBox",
    "ORGM.308wBox",
    "ORGM.3006Box",
    "ORGM.308wBox",
    "ORGM.12gBox",
    "ORGM.223RemBox",
    "ORGM.45Box",
    "ORGM.44Box",
    "ORGM.45Box",
    "ORGM.223RemBox",
    "ORGM.45Box",
    "ORGM.380Box",
    "ORGM.9mmBox",
    "ORGM.12gBox",
    "ORGM.12gBox",
    "ORGM.762x54Box",
    "ORGM.45ColtBox",
    "ORGM.45ColtBox",
    "ORGM.50AEBox",
    "ORGM.50AEBox",
    "ORGM.12gBox",
    "ORGM.3030Box",
    "ORGM.3030Box",
    "ORGM.40Box",
    "ORGM.45Box",
    "ORGM.3006Box",
    "ORGM.762x51Box",
    "ORGM.357Box",
    "ORGM.45Box",
            },
            Box2 = {
    "ORGM.10mmBox",
    "ORGM.10mmBox",
    "ORGM.57Box",
    "ORGM.38SBox",
    "ORGM.38SBox",
    "ORGM.45ColtBox",
    "ORGM.38Box",
    "ORGM.44Box",
    "ORGM.38Box",
    "ORGM.44Box",
    "ORGM.10mmBox",
    "ORGM.762Box",
    "ORGM.762x51Box",
    "ORGM.762x51Box",
    "ORGM.762x51Box",
    "ORGM.3006Box",
    "ORGM.762x51Box",
    "ORGM.12gSlugBox",
    "ORGM.556Box",
    "ORGM.45Box",
    "ORGM.44Box",
    "ORGM.45Box",
    "ORGM.556Box",
    "ORGM.45Box",
    "ORGM.380Box",
    "ORGM.9mmBox",
    "ORGM.12gSlugBox",
    "ORGM.12gSlugBox",
    "ORGM.762x54Box",
    "ORGM.45ColtBox",
    "ORGM.45ColtBox",
    "ORGM.50AEBox",
    "ORGM.50AEBox",
    "ORGM.12gSlugBox",
    "ORGM.3030Box",
    "ORGM.3030Box",
    "ORGM.40Box",
    "ORGM.45Box",
    "ORGM.3006Box",
    "ORGM.308wBox",
    "ORGM.38Box",
    "ORGM.45Box",
            },
            Can = {
    "ORGM.10mmCan",
    "ORGM.10mmCan",
    "ORGM.57Can",
    "ORGM.38SCan",
    "ORGM.38SCan",
    "ORGM.454Can",
    "ORGM.357Can",
    "ORGM.44Can",
    "ORGM.357Can",
    "ORGM.44Can",
    "ORGM.10mmCan",
    "ORGM.762Can",
    "ORGM.308wCan",
    "ORGM.308wCan",
    "ORGM.308wCan",
    "ORGM.3006Can",
    "ORGM.308wCan",
    "ORGM.12gCan",
    "ORGM.223RemCan",
    "ORGM.45Can",
    "ORGM.44Can",
    "ORGM.45Can",
    "ORGM.223RemCan",
    "ORGM.45Can",
    "ORGM.380Can",
    "ORGM.9mmCan",
    "ORGM.12gCan",
    "ORGM.12gCan",
    "ORGM.762x54Can",
    "ORGM.45ColtCan",
    "ORGM.45ColtCan",
    "ORGM.50AECan",
    "ORGM.50AECan",
    "ORGM.12gCan",
    "ORGM.3030Can",
    "ORGM.3030Can",
    "ORGM.40Can",
    "ORGM.45Can",
    "ORGM.3006Can",
    "ORGM.762x51Can",
    "ORGM.357Can",
    "ORGM.45Can",
            },
            Can2 = {
    "ORGM.10mmCan",
    "ORGM.10mmCan",
    "ORGM.57Can",
    "ORGM.38SCan",
    "ORGM.38SCan",
    "ORGM.45ColtCan",
    "ORGM.38Can",
    "ORGM.44Can",
    "ORGM.38Can",
    "ORGM.44Can",
    "ORGM.10mmCan",
    "ORGM.762Can",
    "ORGM.762x51Can",
    "ORGM.762x51Can",
    "ORGM.762x51Can",
    "ORGM.3006Can",
    "ORGM.762x51Can",
    "ORGM.12gSlugCan",
    "ORGM.556Can",
    "ORGM.45Can",
    "ORGM.44Can",
    "ORGM.45Can",
    "ORGM.556Can",
    "ORGM.45Can",
    "ORGM.380Can",
    "ORGM.9mmCan",
    "ORGM.12gSlugCan",
    "ORGM.12gSlugCan",
    "ORGM.762x54Can",
    "ORGM.45ColtCan",
    "ORGM.45ColtCan",
    "ORGM.50AECan",
    "ORGM.50AECan",
    "ORGM.12gSlugCan",
    "ORGM.3030Can",
    "ORGM.3030Can",
    "ORGM.40Can",
    "ORGM.45Can",
    "ORGM.3006Can",
    "ORGM.308wCan",
    "ORGM.38Can",
    "ORGM.45Can",
            },
            Mag = {
    "ORGM.BrenTenMag",
    "ORGM.ColtDeltaMag",
    "ORGM.FN57Mag",
    "ORGM.Colt38SMag",
    "ORGM.Taurus38Mag",
    "ORGM.SpeedLoader4546",
    "ORGM.SpeedLoader3576",
    "ORGM.SpeedLoader446",
    "ORGM.SpeedLoader3576",
    "ORGM.SpeedLoader446",
    "ORGM.SpeedLoader10mm6",
    "ORGM.AKMMag",
    "ORGM.R25Mag",
    "ORGM.FNFALMag",
    "ORGM.HK91Mag",
    "",
    "ORGM.AIAW308Mag",
    "",
    "ORGM.HKSL8Mag",
    "ORGM.M1A1Mag",
    "ORGM.DEagleMag",
    "ORGM.Glock21Mag",
    "ORGM.STANAG223Mag",
    "ORGM.Mac10Mag",
    "ORGM.Mac11Mag",
    "ORGM.UziMag",
    "ORGM.M1216Mag",
    "ORGM.VEPR12Mag",
    "ORGM.SVDMag",
    "",
    "",
    "ORGM.DEagleXIXMag",
    "ORGM.AutomagVMag",
    "",
    "",
    "ORGM.Rem788Mag",
    "ORGM.CZ75Mag",
    "ORGM.HKMK23Mag",
    "ORGM.M1903StripperClip",
    "ORGM.LENo4Mag",
    "",
    "ORGM.SpeedLoader456",
            },
        },
        { -- super rare
            Weapon = {
    "ORGM.AKMA",
    "ORGM.FNFALA",
    "ORGM.HKG3",
    "ORGM.KrissA",  
    "ORGM.SIG550",  
    "ORGM.SIG551",
    "ORGM.Skorpion",
    "ORGM.Glock18",
    "ORGM.Ber93R",
    "ORGM.Win1887",
    "ORGM.AM180",           
            },
            Ammo = {
    "ORGM.762Rounds",
    "ORGM.762x51Rounds",
    "ORGM.762x51Rounds",
    "ORGM.45Rounds",
    "ORGM.556Rounds",
    "ORGM.556Rounds",
    "ORGM.32Rounds",
    "ORGM.9mmRounds",
    "ORGM.9mmRounds",
    "ORGM.12gRounds",
    "ORGM.22Rounds",
            },
            Ammo2 = {
    "ORGM.762Rounds",
    "ORGM.308Rounds",
    "ORGM.308Rounds",
    "ORGM.45Rounds",
    "ORGM.223Rounds",
    "ORGM.223Rounds",
    "ORGM.32Rounds",
    "ORGM.9mmRounds",
    "ORGM.9mmRounds",
    "ORGM.12gSlugRounds",
    "ORGM.22Rounds",
            },
            Box = {
    "ORGM.762Box",
    "ORGM.762x51Box",
    "ORGM.762x51Box",
    "ORGM.45Box",
    "ORGM.556Box",
    "ORGM.556Box",
    "ORGM.32Box",
    "ORGM.9mmBox",
    "ORGM.9mmBox",
    "ORGM.12gBox",
    "ORGM.22Box",
            },
            Box2 = {
    "ORGM.762Box",
    "ORGM.308wBox",
    "ORGM.308wBox",
    "ORGM.45Box",
    "ORGM.223RemBox",
    "ORGM.223RemBox",
    "ORGM.32Box",
    "ORGM.9mmBox",
    "ORGM.9mmBox",
    "ORGM.12gSlugBox",
    "ORGM.22Box",
            },
            Can = {
    "ORGM.762Can",
    "ORGM.762x51Can",
    "ORGM.762x51Can",
    "ORGM.45Can",
    "ORGM.556Can",
    "ORGM.556Can",
    "ORGM.32Can",
    "ORGM.9mmCan",
    "ORGM.9mmCan",
    "ORGM.12gCan",
    "ORGM.22Can",
            },
            Can2 = {
    "ORGM.762Can",
    "ORGM.308wCan",
    "ORGM.308wCan",
    "ORGM.45Can",
    "ORGM.223RemCan",
    "ORGM.223RemCan",
    "ORGM.32Can",
    "ORGM.9mmCan",
    "ORGM.9mmCan",
    "ORGM.12gSlugCan",
    "ORGM.22Can",
            },
            Mag = {
    "ORGM.AKMMag",
    "ORGM.FNFALAMag",
    "ORGM.HKG3Mag",
    "ORGM.Glock21Mag",
    "ORGM.SIG550Mag",
    "ORGM.SIG550Mag",
    "ORGM.SkorpionMag",
    "ORGM.Glock17Mag",
    "ORGM.Ber93RMag",
    "ORGM.AM180Mag",
    "",
            },
        }
    },
    Police = {
        { -- common
            Weapon = {
    "ORGM.Ber92",
    "ORGM.BenelliM3",
    "ORGM.Rem870",
            },
            Ammo = {
    "ORGM.9mmRounds",
    "ORGM.12gRounds",
    "ORGM.12gRounds",
            },
            Ammo2 = {
    "ORGM.9mmRounds",
    "ORGM.12gSlugRounds",
    "ORGM.12gSlugRounds",
            },
            Box = {
    "ORGM.9mmBox",
    "ORGM.12gBox",
    "ORGM.12gBox",
            },
            Box2 = {
    "ORGM.9mmBox",
    "ORGM.12gSlugBox",
    "ORGM.12gSlugBox",
            },
            Can = {
    "ORGM.9mmCan",
    "ORGM.12gCan",
    "ORGM.12gCan",
            },
            Can2 = {
    "ORGM.9mmCan",
    "ORGM.12gSlugCan",
    "ORGM.12gSlugCan",
            },
            Mag = {
    "ORGM.Ber92Mag",
    "",
    "",
            },
        },
        { -- rare
            Weapon = {
    "ORGM.FN57",
    "ORGM.AR10",
    "ORGM.M16",
    "ORGM.M21",
    "ORGM.M4C",
    "ORGM.Rem700",
    "ORGM.Mini14",
    "ORGM.AIAW308",
    "ORGM.Spas12",
    "ORGM.HKMP5",
    "ORGM.HKUMP",
    "ORGM.FNP90",
    "ORGM.Striker",
            },
            Ammo = {
    "ORGM.57Rounds",
    "ORGM.762x51Rounds",
    "ORGM.556Rounds",
    "ORGM.762x51Rounds",
    "ORGM.556Rounds",
    "ORGM.3006Rounds",
    "ORGM.223Rounds",
    "ORGM.308Rounds",
    "ORGM.12gRounds",
    "ORGM.9mmRounds",
    "ORGM.45Rounds",
    "ORGM.57Rounds",
    "ORGM.12gRounds",
            },
            Ammo2 = {
    "ORGM.57Rounds",
    "ORGM.308Rounds",
    "ORGM.223Rounds",
    "ORGM.308Rounds",
    "ORGM.223Rounds",
    "ORGM.3006Rounds",
    "ORGM.556Rounds",
    "ORGM.762x51Rounds",
    "ORGM.12gSlugRounds",
    "ORGM.9mmRounds",
    "ORGM.45Rounds",
    "ORGM.57Rounds",
    "ORGM.12gSlugRounds",
            },
            Box = {
    "ORGM.57Box",
    "ORGM.762x51Box",
    "ORGM.556Box",
    "ORGM.762x51Box",
    "ORGM.556Box",
    "ORGM.3006Box",
    "ORGM.223RemBox",
    "ORGM.308wBox",
    "ORGM.12gBox",
    "ORGM.9mmBox",
    "ORGM.45Box",
    "ORGM.57Box",
    "ORGM.12gBox",
            },
            Box2 = {
    "ORGM.57Box",
    "ORGM.308wBox",
    "ORGM.223RemBox",
    "ORGM.308wBox",
    "ORGM.223RemBox",
    "ORGM.3006Box",
    "ORGM.556Box",
    "ORGM.762x51Box",
    "ORGM.12gSlugBox",
    "ORGM.9mmBox",
    "ORGM.45Box",
    "ORGM.57Box",
    "ORGM.12gSlugBox",
            },
            Can = {
    "ORGM.57Can",
    "ORGM.762x51Can",
    "ORGM.556Can",
    "ORGM.762x51Can",
    "ORGM.556Can",
    "ORGM.3006Can",
    "ORGM.223RemCan",
    "ORGM.308wCan",
    "ORGM.12gCan",
    "ORGM.9mmCan",
    "ORGM.45Can",
    "ORGM.57Can",
    "ORGM.12gCan",
            },
            Can2 = {
    "ORGM.57Can",
    "ORGM.308wCan",
    "ORGM.223RemCan",
    "ORGM.308wCan",
    "ORGM.223RemCan",
    "ORGM.3006Can",
    "ORGM.556Can",
    "ORGM.762x51Can",
    "ORGM.12gSlugCan",
    "ORGM.9mmCan",
    "ORGM.45Can",
    "ORGM.57Can",
    "ORGM.12gSlugCan",
            },
            Mag = {
    "ORGM.FN57Mag",
    "ORGM.AR10Mag",
    "ORGM.STANAGMag",
    "ORGM.M21Mag",
    "ORGM.STANAGMag",
    "",
    "ORGM.Mini14Mag",
    "ORGM.AIAW308Mag",
    "",
    "ORGM.HKMP5Mag",
    "ORGM.HKUMPMag",
    "ORGM.FNP90Mag",
    "",
            },
        }
    },
    Military = {
        { -- common
            Weapon = {
    "ORGM.Ber92",
    "ORGM.M1911",
    "ORGM.M16",
    "ORGM.M4C",
    "ORGM.BenelliXM1014",
    "ORGM.HKMP5",
    "ORGM.HKUMP",
    "ORGM.SR25",
            },
            Ammo = {
    "ORGM.9mmRounds",
    "ORGM.45Rounds",
    "ORGM.556Rounds",
    "ORGM.556Rounds",
    "ORGM.12gRounds",
    "ORGM.9mmRounds",
    "ORGM.45Rounds",
    "ORGM.762x51Rounds",
            },
            Ammo2 = {
    "ORGM.9mmRounds",
    "ORGM.45Rounds",
    "ORGM.223Rounds",
    "ORGM.223Rounds",
    "ORGM.12gSlugRounds",
    "ORGM.9mmRounds",
    "ORGM.45Rounds",
    "ORGM.308Rounds",
            },
            Box = {
    "ORGM.9mmBox",
    "ORGM.45Box",
    "ORGM.556Box",
    "ORGM.556Box",
    "ORGM.12gBox",
    "ORGM.9mmBox",
    "ORGM.45Box",
    "ORGM.762x51Box",
            },
            Box2 = {
    "ORGM.9mmBox",
    "ORGM.45Box",
    "ORGM.223RemBox",
    "ORGM.223RemBox",
    "ORGM.12gSlugBox",
    "ORGM.9mmBox",
    "ORGM.45Box",
    "ORGM.308wBox",
            },
            Can = {
    "ORGM.9mmCan",
    "ORGM.45Can",
    "ORGM.556Can",
    "ORGM.556Can",
    "ORGM.12gCan",
    "ORGM.9mmCan",
    "ORGM.45Can",
    "ORGM.762x51Can",
            },
            Can2 = {
    "ORGM.9mmCan",
    "ORGM.45Can",
    "ORGM.223RemCan",
    "ORGM.223RemCan",
    "ORGM.12gSlugCan",
    "ORGM.9mmCan",
    "ORGM.45Can",
    "ORGM.308wCan",
            },
            Mag = {
    "ORGM.Ber92Mag",
    "ORGM.M1911Mag",
    "ORGM.STANAGMag",
    "ORGM.STANAGMag",
    "",
    "ORGM.HKMP5Mag",
    "ORGM.HKUMPMag",
    "ORGM.SR25Mag",
            },
        },
        { -- rare
            Weapon = {
    "ORGM.FN57",
    "ORGM.SIGP226",
    "ORGM.M21",
    "ORGM.WinM70",
    "ORGM.AIAW308",
    "ORGM.Spas12",
    "ORGM.FNP90",
    "ORGM.SA80",
    "ORGM.M249",
            },
            Ammo = {
    "ORGM.57Rounds",
    "ORGM.40Rounds",
    "ORGM.762x51Rounds",
    "ORGM.3006Rounds",
    "ORGM.308Rounds",
    "ORGM.12gRounds",
    "ORGM.57Rounds",
    "ORGM.556Rounds",
    "ORGM.556Rounds",
            },
            Ammo2 = {
    "ORGM.57Rounds",
    "ORGM.40Rounds",
    "ORGM.308Rounds",
    "ORGM.3006Rounds",
    "ORGM.762x51Rounds",
    "ORGM.12gSlugRounds",
    "ORGM.57Rounds",
    "ORGM.223Rounds",
    "ORGM.223Rounds",
            },
            Box = {
    "ORGM.57Box",
    "ORGM.9mmBox",
    "ORGM.762x51Box",
    "ORGM.3006Box",
    "ORGM.308wBox",
    "ORGM.12gBox",
    "ORGM.57Box",
    "ORGM.556Box",
    "ORGM.556Box",
            },
            Box2 = {
    "ORGM.57Box",
    "ORGM.9mmBox",
    "ORGM.308wBox",
    "ORGM.3006Box",
    "ORGM.762x51Box",
    "ORGM.12gSlugBox",
    "ORGM.57Box",
    "ORGM.223RemBox",
    "ORGM.223RemBox",
            },
            Can = {
    "ORGM.57Can",
    "ORGM.9mmCan",
    "ORGM.762x51Can",
    "ORGM.3006Can",
    "ORGM.308wCan",
    "ORGM.12gCan",
    "ORGM.57Can",
    "ORGM.556Can",
    "ORGM.556Can",
            },
            Can2 = {
    "ORGM.57Can",
    "ORGM.9mmCan",
    "ORGM.308wCan",
    "ORGM.3006Can",
    "ORGM.762x51Can",
    "ORGM.12gSlugCan",
    "ORGM.57Can",
    "ORGM.223RemCan",
    "ORGM.223RemCan",
            },
            Mag = {
    "ORGM.FN57Mag",
    "ORGM.SIGP226Mag",
    "ORGM.M21Mag",
    "",
    "ORGM.AIAW308Mag",
    "",
    "ORGM.FNP90Mag",
    "ORGM.STANAGMag",
    "ORGM.M249Belt",
            },
        },
    },
}
    

local AllRoundsTable = {
    "ORGM.762Rounds",
    "ORGM.9mmRounds",
    "ORGM.12gRounds",
    "ORGM.12gSlugRounds",
    "ORGM.22Rounds",
    "ORGM.38Rounds",
    "ORGM.40Rounds",
    "ORGM.44Rounds",
    "ORGM.45Rounds",
    "ORGM.38SRounds",
    "ORGM.357Rounds",
    "ORGM.223Rounds",
    "ORGM.3006Rounds",
    "ORGM.3030Rounds",
    "ORGM.308Rounds",
    "ORGM.454Rounds",
    "ORGM.BBsRounds",
    "ORGM.57Rounds",
    "ORGM.10mmRounds",
    "ORGM.762x51Rounds",
    "ORGM.762x54Rounds",
    "ORGM.556Rounds",
    "ORGM.380Rounds",
    "ORGM.45ColtRounds",
    "ORGM.50AERounds",
    };
    
local AllBoxTable = {
    "ORGM.762Box",
    "ORGM.9mmBox",
    "ORGM.12gBox",
    "ORGM.12gSlugBox",
    "ORGM.22Box",
    "ORGM.38Box",
    "ORGM.40Box",
    "ORGM.44Box",
    "ORGM.45Box",
    "ORGM.38SBox",
    "ORGM.357Box",
    "ORGM.223RemBox",
    "ORGM.3006Box",
    "ORGM.3030Box",
    "ORGM.308wBox",
    "ORGM.454Box",
    "ORGM.BBCan",
    "ORGM.57Box",
    "ORGM.10mmBox",
    "ORGM.762x51Box",
    "ORGM.762x54Box",
    "ORGM.556Box",
    "ORGM.380Box",
    "ORGM.45ColtBox",
    "ORGM.50AEBox",
    };
    
local AllCanTable = {
    "ORGM.762Can",
    "ORGM.9mmCan",
    "ORGM.12gCan",
    "ORGM.12gSlugCan",
    "ORGM.22Can",
    "ORGM.38Can",
    "ORGM.40Can",
    "ORGM.44Can",
    "ORGM.45Can",
    "ORGM.38SCan",
    "ORGM.357Can",
    "ORGM.223RemCan",
    "ORGM.3006Can",
    "ORGM.3030Can",
    "ORGM.308wCan",
    "ORGM.454Can",
    "ORGM.57Can",
    "ORGM.10mmCan",
    "ORGM.762x51Can",
    "ORGM.762x54Can",
    "ORGM.556Can",
    "ORGM.380Can",
    "ORGM.45ColtCan",
    "ORGM.50AECan",
    };
    
local CivModTable = {
    "ORGM.2xScope",
    "ORGM.8xScope",
    "ORGM.FibSig",
    "ORGM.FullCh",
    "ORGM.HalfCh",
    "ORGM.PistolLas",
    "ORGM.PistolTL",
    "ORGM.RDS",
    "ORGM.Recoil",
    "ORGM.Rifsling",
    "ORGM.SkeletalStock",
    "ORGM.CollapsingStock",
    };
    
local NonCivModTable = {
    "ORGM.4xScope",
    "ORGM.8xScope",
    "ORGM.FibSig",
    "ORGM.Reflex",
    "ORGM.RifleLas",
    "ORGM.PistolLas",
    "ORGM.PistolTL",
    "ORGM.RDS",
    "ORGM.RifleTL",
    "ORGM.Rifsling",
    "ORGM.Foregrip",
    "ORGM.SkeletalStock",
    "ORGM.CollapsingStock",
    };
    
local RepairTable = {
    "ORGM.WD40",
    "ORGM.Brushkit",
    "ORGM.Maintkit",
    };

-------------------------------------------------------------------------------------------------------------------
-- functions

local Rnd = function(maxValue)
    return ZombRand(maxValue) + 1;
end

local GenerateItem = function(container, itemTable, index, chance, maxCount, lootType)
--local GenerateItem = function(container, add, CPM, BHGSP)
    if index == nil then
        --local guns = gunTbl.Weapon -- TODO: need to fix
        index = Rnd(#itemTable)
    end
    if chance < 100 and Rnd(99) > chance then return end -- has item
    local count = Rnd(maxCount)
    if itemTable[index] ~= "" then
        for i=1, count do
            local item = container:AddItems(itemTable[index], 1)
            for i=0, item:size()-1 do
                local additem = item:get(i)
                ReloadUtil:syncItemToReloadable(additem, getPlayer())
                local data = additem:getModData()
                local maxammo = data.maxCapacity
                local fill = 0
                local condmult = nil -- condition multiplier

                if data.roundChambered ~= nil then
                    maxammo = maxammo + 1
                end
                if lootType == "Body" then
                    if ZombRand(10) >= 3 then fill = ZombRand(maxammo) end
                    
                    condmult = ZombRand(10) / 10
                    if ZombRand(10) <= 1 then
                        condmult = 0
                    elseif ZombRand(10) <= 4 then
                        condmult = condmult / 2
                    end

                elseif lootType == "House" then
                    if ZombRand(10) > 7 then fill = maxammo end
                    
                    condmult = ZombRand(10) / 10
                    if ZombRand(10) <= 1 then
                        condmult = 0
                    elseif ZombRand(10) <= 4 then
                        condmult = condmult / 2
                    end
                
                elseif lootType == "Gas" then
                    fill = maxammo
                    condmult = ZombRand(10) / 10
                    if ZombRand(10) <= 4 then
                        condmult = condmult / 2
                    end
                
                elseif lootType == "Store" then
                    fill = 0
                    if ZombRand(10) <=4 then
                        condmod = ZombRand(3)-1
                        condmod = condmod / 2
                        condmult = 10 - condmod
                    else 
                        condmult = 1
                    end
                
                elseif lootType == "Police" then
                    fill = 0
                    if ZombRand(10) <=4 then
                        condmod = ZombRand(3)-1
                        condmod = condmod / 2
                        condmult = 10 - condmod
                    else 
                        condmult = 1
                    end
                end
                
                if fill > 0 then
                    if data.roundChambered ~= nil then
                        data.roundChambered = 1
                        fill = fill - 1
                    end
                    data.currentCapacity = fill
                end
                if additem.CurrentCapacity ~= nil and condmult ~= nil then
                    additem.CurrentCapacity = additem.CurrentCapacity * condmult
                end
                if WeaponUpgrades[additem:getType()] then
                    ItemPicker.doWeaponUpgrade(additem);
                end         
            end
        end
    end
end

local SelectGun = function(gunTbl)
    local guns = gunTbl.Weapon    
    return Rnd(#guns)
end

--[[ SelectTable(civChance, polChance)
    Selects a weapons table (civ, police, military) and rarity value.
    civChance and polChance are chances of civilian and police weapons: 
        (80, 94) is 80% chance civilian, 14% chance police, and 6% chance military
        (0, 100) is a 0% chance of civilian, 100% chance of police, and 0% chance of military
        (0, 0) is a 100% chance of military
    Rarity values are fixed inside the function code
]]
local SelectTable = function(civChance, polChance)
    local roll = Rnd(99)
    local tbl = nil
    local rarity = 1
    if roll < civChance then -- civ
        tbl = WeaponsTable.Civilian
    elseif roll < polChance then -- police
        tbl = WeaponsTable.Police
    else  -- military
        tbl = WeaponsTable.Military
    end
    
    roll = Rnd(99)
    if roll < 80 then -- common
        rarity = 1
    elseif roll < 96 then -- rare
        rarity = 2
    else -- super rare
        rarity = 3
    end
    if rarity > #tbl then rarity = #tbl end
    return tbl[rarity]
end

--[[ SelectAmmo(weaponTbl, ammoChance, boxChance, canChance)
    Selects the tables ammo1/ammo2, box1/box2, and can1/can2. The % chances arguments are the chances it picks table 1
]]
local SelectAmmo = function(weaponTbl, ammoChance, boxChance, canChance) 
    local ammo_tbl = nil
    local box_tbl = nil
    local can_tbl = nil
    if ammoChance ~= nil then
        if Rnd(100) < ammoChance then 
            ammo_tbl = weaponTbl.Ammo
        else
            ammo_tbl = weaponTbl.Ammo2
        end
    end
    
    if boxChance ~= nil then
        if Rnd(100) < boxChance then 
            box_tbl = weaponTbl.Box
        else
            box_tbl = weaponTbl.Box2
        end
    end
    
    if canChance ~= nil then
        if Rnd(100) < canChance then 
            can_tbl = weaponTbl.Can
        else
            can_tbl = weaponTbl.Can2
        end
    end
    
    return {ammo_tbl, box_tbl, can_tbl}
end

--[[ AddToCorpse(container)
    Males and females use the same code for spawning guns and ammo. Merged into a single function for maintainability.
]]
local AddAmmo = function(container, itemTable, index, chance, maxCount)
    if index == nil then index = Rnd(#itemTable) end
    if chance == 100 or Rnd(99) <= chance then -- has item
        local count = Rnd(maxCount)
        if itemTable[index] ~= "" then
          for i=1, count do
              container:AddItem(itemTable[index])
          end
        end
    end
end

local GenerateMags = function(container, weaponTable, index, chance, maxCount, lootType)
    if ReloadManager[1]:getDifficulty() >= 2 then -- has mags
        GenerateItem(container, weaponTable.Mag, index, chance, maxCount, lootType)
    end
end



local AddToCorpse = function(container)
    local tbl = SelectTable(80, 94)
    local index = SelectGun(tbl)
    local ammo = SelectAmmo(tbl, 90, 90, 90)
    GenerateItem(container, tbl.Weapon, index, 100, 0, "Body") -- has gun
    GenerateMags(container, tbl, index, 70, 2, "Body") -- has mags
    AddAmmo(container, ammo[1], index, 100, 15) -- loose shells
    AddAmmo(container, ammo[2], index, 10, 1) -- has box
end

--[[ AddToCivRoom(container)
    Adds a gun to a civilian room: bedrooms, gas stations, etc.
    Merged into a single function because commercial places are just as likely to have any civilian weapon not just shotguns :P
]]
local AddToCivRoom = function(container)
    local tbl = SelectTable(85, 97)
    local index = SelectGun(tbl)
    local ammo = SelectAmmo(tbl, 90, 90, 90)
    GenerateItem(container, tbl.Weapon, index, 10, 0, "House") -- has gun
    GenerateMags(container, tbl, index, 5, 1, "House") -- has mags
    
    AddAmmo(container, ammo[1], index, 20, 29) -- loose shells
    AddAmmo(container, ammo[2], index, 10, 1) -- has box
    AddAmmo(container, CivModTable, nil, 5, 0) -- has a mod
    AddAmmo(container, RepairTable, nil, 5, 1) -- has repair stuff
end

--[[ AddAmmoStorage(container)
    merged function for adding lots of ammo to a container.
]]
local AddAmmoStorage = function(container)
    if Rnd(20) >= 1 then container:AddItem(AllBoxTable[Rnd(#AllBoxTable)]) end
    if Rnd(20) >= 2 then container:AddItem(AllBoxTable[Rnd(#AllBoxTable)]) end
    if Rnd(20) >= 3 then container:AddItem(AllBoxTable[Rnd(#AllBoxTable)]) end
    if Rnd(20) >= 4 then container:AddItem(AllBoxTable[Rnd(#AllBoxTable)]) end
    if Rnd(20) >= 5 then container:AddItem(AllBoxTable[Rnd(#AllBoxTable)]) end
    if Rnd(20) >= 6 then container:AddItem(AllBoxTable[Rnd(#AllBoxTable)]) end
    if Rnd(20) >= 7 then container:AddItem(AllBoxTable[Rnd(#AllBoxTable)]) end
    if Rnd(20) >= 9 then container:AddItem(AllBoxTable[Rnd(#AllBoxTable)]) end
    if Rnd(20) >= 11 then container:AddItem(AllBoxTable[Rnd(#AllBoxTable)]) end
    if Rnd(20) >= 13 then container:AddItem(AllBoxTable[Rnd(#AllBoxTable)]) end
    if Rnd(20) >= 15 then container:AddItem(AllBoxTable[Rnd(#AllBoxTable)]) end
    if Rnd(20) >= 17 then container:AddItem(AllCanTable[Rnd(#AllCanTable)]) end
    if Rnd(20) >= 19 then container:AddItem(AllCanTable[Rnd(#AllCanTable)]) end
    if Rnd(4) >= 1 then container:AddItem(RepairTable[Rnd(#RepairTable)]) end
end


Events.OnFillContainer.Add(function(_roomName, _containerType, container)
    if _roomName == "all" and _containerType == "inventorymale" then
        if Rnd(100) >= 98 then AddToCorpse(container) end -- has weapon
    elseif _roomName == "all" and _containerType == "inventoryfemale" then
        if Rnd(100) >= 98 then AddToCorpse(container) end -- has weapon
    elseif _roomName == "bedroom" and _containerType == "wardrobe" then
        if Rnd(100) > 70 then AddToCivRoom(container) end -- has weapon
    elseif _roomName == "zippeestore" and _containerType == "counter" then
        if Rnd(100) >= 90 then AddToCivRoom(container) end -- has weapon
    elseif _roomName == "fossoil" and _containerType == "counter" then
        if Rnd(100) >= 90 then AddToCivRoom(container) end -- has weapon
    elseif _roomName == "gasstore" and _containerType == "counter" then
        if Rnd(100) >= 90 then AddToCivRoom(container) end -- has weapon
    elseif _roomName == "bar" and _containerType == "counter" then
        if Rnd(100) >= 85 then AddToCivRoom(container) end -- has weapon
    elseif _roomName == "policestorage" then
        local count = Rnd(3)
        while count ~= 0 do
            local tbl = SelectTable(0, 70)
            local index = SelectGun(tbl)
            local ammo = SelectAmmo(tbl, 90, 90, 90)            
            GenerateItem(container, tbl.Weapon, index, 60, 1, "Police")
            GenerateMags(container, tbl, index, 80, 2, "Police") -- has mags

            if Rnd(10) < 8 then -- add boxes
                AddAmmo(container, ammo[2], index, 100, 4) -- has box
            else -- add a can of ammo
                AddAmmo(container, ammo[3], index, 100, 1)
            end
            AddAmmo(container, NonCivModTable, nil, 30, 1)
            AddAmmo(container, RepairTable, nil, 40, 1)
            if Rnd(10) > 7 then count = count -1 end
        end
    elseif _roomName == "gunstore" and _containerType == "locker" then
        AddAmmoStorage(container)
    elseif _roomName == "gunstore" and _containerType == "counter" then
        AddAmmoStorage(container)
    elseif _roomName == "gunstore" and _containerType == "displaycase" then
        if Rnd(100) >= 5 then
            local tbl = SelectTable(85, 95)
            local index = SelectGun(tbl)
            local ammo = SelectAmmo(tbl, 90, 90, 90)            
            GenerateItem(container, tbl.Weapon, index, 100, 0, "Store")
            GenerateMags(container, tbl, index, 80, 1, "Store") -- has mags
        end
        if Rnd(100) >= 25 then
            local tbl = SelectTable(85, 95)
            local index = SelectGun(tbl)
            local ammo = SelectAmmo(tbl, 90, 90, 90)            
            GenerateItem(container, tbl.Weapon, index, 100, 0, "Store")
            GenerateMags(container, tbl, index, 80, 1, "Store") -- has mags
        end
        if Rnd(5) >= 2 then
            AddAmmo(container, CivModTable, nil, 90, 0)
            AddAmmo(container, NonCivModTable, nil, 10, 0)
        end
    elseif _roomName == "gunstorestorage" and _containerType == "metal_shelves" then
        if Rnd(100) >= 5 then
            local tbl = SelectTable(85, 95)
            local index = SelectGun(tbl)
            local ammo = SelectAmmo(tbl, 90, 90, 90)            
            GenerateItem(container, tbl.Weapon, index, 100, 0, "Store")
            GenerateMags(container, tbl, index, 80, 1, "Store") -- has mags
        end
        if Rnd(100) >= 25 then
            local tbl = SelectTable(85, 95)
            local index = SelectGun(tbl)
            local ammo = SelectAmmo(tbl, 90, 90, 90)            
            GenerateItem(container, tbl.Weapon, index, 100, 0, "Store")
            GenerateMags(container, tbl, index, 80, 1, "Store") -- has mags
        end
        if Rnd(5) >= 2 then
            AddAmmo(container, CivModTable, nil, 90, 0)
            AddAmmo(container, NonCivModTable, nil, 10, 0)
        end

        AddAmmoStorage(container)
    elseif _roomName == "storageunit" and _containerType == "crate" then
        if Rnd(100) >= 85 then
            if Rnd(100) >= 5 then
                local tbl = SelectTable(85, 95)
                local index = SelectGun(tbl)
                local ammo = SelectAmmo(tbl, 90, 90, 90)            
                GenerateItem(container, tbl.Weapon, index, 100, 0, "Store")
                GenerateMags(container, tbl, index, 80, 1, "Store") -- has mags
            end
            if Rnd(100) >= 25 then
                local tbl = SelectTable(85, 95)
                local index = SelectGun(tbl)
                local ammo = SelectAmmo(tbl, 90, 90, 90)            
                GenerateItem(container, tbl.Weapon, index, 100, 0, "Store")
                GenerateMags(container, tbl, index, 80, 1, "Store") -- has mags
            end
            if Rnd(5) >= 2 then
                AddAmmo(container, CivModTable, nil, 90, 0)
                AddAmmo(container, NonCivModTable, nil, 10, 0)
            end
            if Rnd(5) >= 4 then
                AddAmmo(container, CivModTable, nil, 90, 0)
                AddAmmo(container, NonCivModTable, nil, 10, 0)
            end
            
            AddAmmoStorage(container)
        end
    elseif _roomName == "garagestorage" and _containerType == "smallbox" then
        if Rnd(100) >= 85 then
            if Rnd(100) >= 5 then
                local tbl = SelectTable(85, 95)
                local index = SelectGun(tbl)
                local ammo = SelectAmmo(tbl, 90, 90, 90)            
                GenerateItem(container, tbl.Weapon, index, 100, 0, "Store")
                GenerateMags(container, tbl, index, 80, 1, "Store") -- has mags
            end
            if Rnd(100) >= 25 then
                local tbl = SelectTable(85, 95)
                local index = SelectGun(tbl)
                local ammo = SelectAmmo(tbl, 90, 90, 90)            
                GenerateItem(container, tbl.Weapon, index, 100, 0, "Store")
                GenerateMags(container, tbl, index, 80, 1, "Store") -- has mags
            end
            if Rnd(5) >= 2 then
                AddAmmo(container, CivModTable, nil, 90, 0)
                AddAmmo(container, NonCivModTable, nil, 10, 0)
            end
            if Rnd(5) >= 4 then
                AddAmmo(container, CivModTable, nil, 90, 0)
                AddAmmo(container, NonCivModTable, nil, 10, 0)
            end

            AddAmmoStorage(container)
        end
    elseif _roomName == "hunting" and _containerType == "metal_shelves" then
        if Rnd(100) >= 35 then
            if Rnd(100) >= 5 then
                local tbl = SelectTable(85, 95)
                local index = SelectGun(tbl)
                local ammo = SelectAmmo(tbl, 90, 90, 90)            
                GenerateItem(container, tbl.Weapon, index, 100, 0, "Store")
                GenerateMags(container, tbl, index, 80, 1, "Store") -- has mags
            end
            if Rnd(100) >= 25 then
                local tbl = SelectTable(85, 95)
                local index = SelectGun(tbl)
                local ammo = SelectAmmo(tbl, 90, 90, 90)            
                GenerateItem(container, tbl.Weapon, index, 100, 0, "Store")
                GenerateMags(container, tbl, index, 80, 1, "Store") -- has mags
            end
            if Rnd(5) >= 2 then
                AddAmmo(container, CivModTable, nil, 90, 0)
                AddAmmo(container, NonCivModTable, nil, 10, 0)
            end
            if Rnd(5) >= 4 then
                AddAmmo(container, CivModTable, nil, 90, 0)
                AddAmmo(container, NonCivModTable, nil, 10, 0)
            end
            
            AddAmmoStorage(container)
        end
    end
end
)   
