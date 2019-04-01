--[[- This file contains all default ammo data.

All calls made by this script are to `ORGM.Ammo.register`. See the documention there.

@script ORGMData_Ammo.lua
@author Fenris_Wolf
@release 3.09
@copyright 2018 **File:** shared/4DataFiles/ORGMData_Ammo.lua

]]
local register = ORGM.Ammo.register

register("Ammo_117BB",
    { OptimalBarrel = 12, Range = 15, Recoil = 2, MinDamage = 0.1, MaxDamage = 0.1, Penetration = false, UseWith = {"Ammo_117BB"}, BoxCount = 250, CanCount = 1000, DisplayName = ".117", RoundType = "BB", Weight = 0.001 }
)
register("Ammo_22LR_FMJ",
    { OptimalBarrel = 30, Range = 18, Recoil = 5, MinDamage = 0.4, MaxDamage = 0.8, Penetration = 10, Case = "Case_Ammo_22LR", UseWith = {"Ammo_22LR"}, BoxCount = 100, CanCount = 1000, DisplayName = ".22LR FMJ", Weight = 0.003 }
)
register("Ammo_22LR_HP",
    { OptimalBarrel = 30, Range = 18, Recoil = 5, MinDamage = 0.5, MaxDamage = 0.9, Penetration = 2,  Case = "Case_Ammo_22LR", UseWith = {"Ammo_22LR"}, BoxCount = 100, CanCount = 1000, DisplayName = ".22LR HP", Weight = 0.003}
)
register("Ammo_32ACP_FMJ",
    { OptimalBarrel = 30, Range = 15, Recoil = 6, MinDamage = 0.7, MaxDamage = 1.3, Penetration = 15, Case = "Case_32ACP", UseWith = {"Ammo_32ACP"}, BoxCount = 50, CanCount = 500, DisplayName = ".32ACP FMJ", Weight = 0.01}
)
register("Ammo_32ACP_HP",
    { OptimalBarrel = 30, Range = 15, Recoil = 6, MinDamage = 0.9, MaxDamage = 1.3, Penetration = 3,  Case = "Case_32ACP", UseWith = {"Ammo_32ACP"}, BoxCount = 50, CanCount = 500, DisplayName = ".32ACP HP", Weight = 0.01}
)
register("Ammo_357Magnum_FMJ",
    { OptimalBarrel = 30, Range = 25, Recoil = 13, MinDamage = 0.9, MaxDamage = 1.9, Penetration = 50, Case = "Case_357Magnum", UseWith = {"Ammo_357Magnum"}, BoxCount = 50, CanCount = 500, DisplayName = ".357 Magnum FMJ", Weight = 0.01}
)
register("Ammo_357Magnum_HP",
    { OptimalBarrel = 30, Range = 25, Recoil = 13, MinDamage = 1.2, MaxDamage = 1.9, Penetration = 10, Case = "Case_357Magnum", UseWith = {"Ammo_357Magnum"}, BoxCount = 50, CanCount = 500, DisplayName = ".357 Magnum HP", Weight = 0.01 }
)
register("Ammo_38Special_FMJ",
    { OptimalBarrel = 30, Range = 15, Recoil = 7, MinDamage = 0.7, MaxDamage = 1.6, Penetration = 30, Case = "Case_38Special", UseWith = {"Ammo_357Magnum", "Ammo_38Special"}, BoxCount = 50, CanCount = 500, DisplayName = ".38 Special FMJ", Weight = 0.01 }
)
register("Ammo_38Special_HP",
    { OptimalBarrel = 30, Range = 15, Recoil = 7, MinDamage = 1.0, MaxDamage = 1.6, Penetration = 8,  Case = "Case_38Special", UseWith = {"Ammo_357Magnum", "Ammo_38Special"}, BoxCount = 50, CanCount = 500, DisplayName = ".38 Special HP", Weight = 0.01 }
)
register("Ammo_38Super_FMJ",
    { OptimalBarrel = 30, Range = 20, Recoil = 7, MinDamage = 0.7, MaxDamage = 1.7, Penetration = 30, Case = "Case_38Super", UseWith = {"Ammo_38Super"}, BoxCount = 50, CanCount = 500, DisplayName = ".38 Super FMJ", Weight = 0.01 }
)
register("Ammo_38Super_HP",
    { OptimalBarrel = 30, Range = 20, Recoil = 7, MinDamage = 1.0, MaxDamage = 1.7, Penetration = 8,  Case = "Case_38Super", UseWith = {"Ammo_38Super"}, BoxCount = 50, CanCount = 500, DisplayName = ".38 Super HP", Weight = 0.01 }
)
register("Ammo_380ACP_FMJ",
    { OptimalBarrel = 30, Range = 18, Recoil = 8, MinDamage = 0.7, MaxDamage = 1.5, Penetration = 25, Case = "Case_380ACP", UseWith = {"Ammo_380ACP"}, BoxCount = 50, CanCount = 500, DisplayName = ".380ACP FMJ", Weight = 0.01 }
)
register("Ammo_380ACP_HP",
    { OptimalBarrel = 30, Range = 18, Recoil = 8, MinDamage = 1.0, MaxDamage = 1.5, Penetration = 7,  Case = "Case_380ACP", UseWith = {"Ammo_380ACP"}, BoxCount = 50, CanCount = 500, DisplayName = ".380ACP HP", Weight = 0.01 }
)
register("Ammo_40SW_FMJ",
    { OptimalBarrel = 30, Range = 20, Recoil = 11, MinDamage = 0.8, MaxDamage = 1.7, Penetration = 50, Case = "Case_40SW", UseWith = {"Ammo_40SW"}, BoxCount = 50, CanCount = 500, DisplayName = ".40S&W FMJ", Weight = 0.01 }
)
register("Ammo_40SW_HP",
    { OptimalBarrel = 30, Range = 20, Recoil = 11, MinDamage = 1.1, MaxDamage = 1.7, Penetration = 10, Case = "Case_40SW", UseWith = {"Ammo_40SW"}, BoxCount = 50, CanCount = 500, DisplayName = ".40S&W HP", Weight = 0.01 }
)
register("Ammo_44Magnum_FMJ",
    { OptimalBarrel = 30, Range = 25, Recoil = 15, MinDamage = 1.2, MaxDamage = 2.2, Penetration = 65, Case = "Case_44Magnum", UseWith = {"Ammo_44Magnum"}, BoxCount = 50, CanCount = 500, DisplayName = ".44 Magnum FMJ", Weight = 0.012 }
)
register("Ammo_44Magnum_HP",
    { OptimalBarrel = 30, Range = 25, Recoil = 15, MinDamage = 1.6, MaxDamage = 2.2, Penetration = 13, Case = "Case_44Magnum", UseWith = {"Ammo_44Magnum"}, BoxCount = 50, CanCount = 500, DisplayName = ".44 Magnum HP", Weight = 0.012 }
)
register("Ammo_45ACP_FMJ",
    { OptimalBarrel = 30, Range = 17, Recoil = 13, MinDamage = 1.0, MaxDamage = 1.8, Penetration = 45, Case = "Case_45ACP", UseWith = {"Ammo_45ACP"}, BoxCount = 50, CanCount = 500, DisplayName = ".45ACP FMJ", Weight = 0.01 }
)
register("Ammo_45ACP_HP",
    { OptimalBarrel = 30, Range = 17, Recoil = 13, MinDamage = 1.3, MaxDamage = 1.8, Penetration = 10, Case = "Case_45ACP", UseWith = {"Ammo_45ACP"}, BoxCount = 50, CanCount = 500, DisplayName = ".45ACP HP", Weight = 0.01 }
)
register("Ammo_45Colt_FMJ",
    { OptimalBarrel = 30, Range = 25, Recoil = 15, MinDamage = 1.1, MaxDamage = 2.1, Penetration = 60, Case = "Case_45Colt", UseWith = {"Ammo_45Colt", "Ammo_454Casull"}, BoxCount = 50, CanCount = 500, DisplayName = ".45 Colt FMJ", Weight = 0.01 }
)
register("Ammo_45Colt_HP",
    { OptimalBarrel = 30, Range = 25, Recoil = 15, MinDamage = 1.5, MaxDamage = 2.1, Penetration = 12, Case = "Case_45Colt", UseWith = {"Ammo_45Colt", "Ammo_454Casull"}, BoxCount = 50, CanCount = 500, DisplayName = ".45 Colt HP", Weight = 0.01 }
)
register("Ammo_454Casull_FMJ",
    { OptimalBarrel = 30, Range = 25, Recoil = 15, MinDamage = 1.3, MaxDamage = 2.3, Penetration = 67, Case = "Case_454Casull", UseWith = {"Ammo_454Casull"}, BoxCount = 50, CanCount = 500, DisplayName = ".454 Casull FMJ", Weight = 0.012 }
)
register("Ammo_454Casull_HP",
    { OptimalBarrel = 30, Range = 25, Recoil = 15, MinDamage = 1.7, MaxDamage = 2.3, Penetration = 14, Case = "Case_454Casull", UseWith = {"Ammo_454Casull"}, BoxCount = 50, CanCount = 500, DisplayName = ".454 Casull", Weight = 0.012 }
)
register("Ammo_50AE_FMJ",
    { OptimalBarrel = 30, Range = 25, Recoil = 15, MinDamage = 1.3, MaxDamage = 2.3, Penetration = 67, Case = "Case_50AE", UseWith = {"Ammo_50AE"}, BoxCount = 50, CanCount = 500, DisplayName = ".50AE FMJ", Weight = 0.012 }
)
register("Ammo_50AE_HP",
    { OptimalBarrel = 30, Range = 25, Recoil = 15, MinDamage = 1.7, MaxDamage = 2.3, Penetration = 14, Case = "Case_50AE", UseWith = {"Ammo_50AE"}, BoxCount = 50, CanCount = 500, DisplayName = ".50AE HP", Weight = 0.012 }
)
register("Ammo_223Remington_FMJ",
    { OptimalBarrel = 80, Range = 30, Recoil = 20, MinDamage = 1.4, MaxDamage = 2.4, Penetration = 75, Case = "Case_223Remington", UseWith = {"Ammo_223Remington", "Ammo_556x45mm"}, BoxCount = 25, CanCount = 250, DisplayName = ".223 Remington FMJ", Weight = 0.015 }
)
register("Ammo_223Remington_HP",
    { OptimalBarrel = 80, Range = 30, Recoil = 20, MinDamage = 1.8, MaxDamage = 2.4, Penetration = 15, Case = "Case_223Remington", UseWith = {"Ammo_223Remington", "Ammo_556x45mm"}, BoxCount = 25, CanCount = 250, DisplayName = ".223 Remington HP", Weight = 0.015 }
)
register("Ammo_3006Springfield_FMJ",
    { OptimalBarrel = 80, Range = 35, Recoil = 28, MinDamage = 1.4, MaxDamage = 2.7, Penetration = 75, Case = "Case_3006Springfield", UseWith = {"Ammo_3006Springfield"}, BoxCount = 20, CanCount = 200, DisplayName = ".30-06 Springfield FMJ", Weight = 0.02 }
)
register("Ammo_3006Springfield_HP",
    { OptimalBarrel = 80, Range = 35, Recoil = 28, MinDamage = 1.7, MaxDamage = 2.7, Penetration = 15, Case = "Case_3006Springfield", UseWith = {"Ammo_3006Springfield"}, BoxCount = 20, CanCount = 200, DisplayName = ".30-06 Springfield HP", Weight = 0.02 }
)
register("Ammo_3030Winchester_FMJ",
    { OptimalBarrel = 80, Range = 30, Recoil = 20, MinDamage = 0.8, MaxDamage = 1.9, Penetration = 30, Case = "Case_3030Winchester", UseWith = {"Ammo_3030Winchester"}, BoxCount = 20, CanCount = 200, DisplayName = ".30-30 Winchester FMJ", Weight = 0.02 }
)
register("Ammo_3030Winchester_HP",
    { OptimalBarrel = 80, Range = 30, Recoil = 20, MinDamage = 1.0, MaxDamage = 1.9, Penetration = 8,  Case = "Case_3030Winchester", UseWith = {"Ammo_3030Winchester"}, BoxCount = 20, CanCount = 200, DisplayName = ".30-30 Winchester HP", Weight = 0.02 }
)
register("Ammo_308Winchester_FMJ",
    { OptimalBarrel = 80, Range = 33, Recoil = 25, MinDamage = 1.4, MaxDamage = 2.6, Penetration = 80, Case = "Case_308Winchester", UseWith = {"Ammo_308Winchester", "Ammo_762x51mm"}, BoxCount = 20, CanCount = 200, DisplayName = ".308 Winchester FMJ", Weight = 0.02 }
)
register("Ammo_308Winchester_HP",
    { OptimalBarrel = 80, Range = 33, Recoil = 25, MinDamage = 1.8, MaxDamage = 2.6, Penetration = 20, Case = "Case_308Winchester", UseWith = {"Ammo_308Winchester", "Ammo_762x51mm"}, BoxCount = 20, CanCount = 200, DisplayName = ".308 Winchester HP", Weight = 0.02 }
)
register("Ammo_57x28mm_FMJ",
    { OptimalBarrel = 30, Range = 25, Recoil = 7, MinDamage = 0.7, MaxDamage = 1.6, Penetration = 90, Case = "Case_57x28mm", UseWith = {"Ammo_57x28mm"}, BoxCount = 50, CanCount = 500, DisplayName = "5.7x28mm HP", Weight = 0.01 }
)
register("Ammo_57x28mm_HP",
    { OptimalBarrel = 30, Range = 25, Recoil = 7, MinDamage = 1.0, MaxDamage = 1.6, Penetration = 40, Case = "Case_57x28mm", UseWith = {"Ammo_57x28mm"}, BoxCount = 50, CanCount = 500, DisplayName = "5.7x28mm HP", Weight = 0.01 }
)
register("Ammo_9x19mm_FMJ",
    { OptimalBarrel = 30, Range = 20, Recoil = 10, MinDamage = 0.7, MaxDamage = 1.6, Penetration = 50, Case = "Case_9x19mm", UseWith = {"Ammo_9x19mm"}, BoxCount = 50, CanCount = 500, DisplayName = "9x19mm Parabellum FMJ", Weight = 0.01 }
)
register("Ammo_9x19mm_HP",
    { OptimalBarrel = 30, Range = 20, Recoil = 10, MinDamage = 1.0, MaxDamage = 1.6, Penetration = 10, Case = "Case_9x19mm", UseWith = {"Ammo_9x19mm"}, BoxCount = 50, CanCount = 500, DisplayName = "9x19mm Parabellum HP", Weight = 0.01 }
)
register("Ammo_10x25mm_FMJ",
    { OptimalBarrel = 30, Range = 20, Recoil = 12, MinDamage = 0.9, MaxDamage = 1.9, Penetration = 55, Case = "Case_10x25mm", UseWith = {"Ammo_10x25mm"}, BoxCount = 50, CanCount = 500, DisplayName = "10x25mm FMJ", Weight = 0.01 }
)
register("Ammo_10x25mm_HP",
    { OptimalBarrel = 30, Range = 20, Recoil = 12, MinDamage = 1.2, MaxDamage = 1.9, Penetration = 12, Case = "Case_10x25mm", UseWith = {"Ammo_10x25mm"}, BoxCount = 50, CanCount = 500, DisplayName = "10x25mm HP", Weight = 0.01 }
)
register("Ammo_556x45mm_FMJ",
    { OptimalBarrel = 80, Range = 30, Recoil = 20, MinDamage = 1.4, MaxDamage = 2.4, Penetration = 75, Case = "Case_556x45mm", UseWith = {"Ammo_223Remington", "Ammo_556x45mm"}, BoxCount = 25, CanCount = 250, DisplayName = "5.56x45mm FMJ", Weight = 0.015 }
)
register("Ammo_556x45mm_HP",
    { OptimalBarrel = 80, Range = 30, Recoil = 20, MinDamage = 1.8, MaxDamage = 2.4, Penetration = 15, Case = "Case_556x45mm", UseWith = {"Ammo_223Remington", "Ammo_556x45mm"}, BoxCount = 25, CanCount = 250, DisplayName = "5.56x45mm HP", Weight = 0.015 }
)
register("Ammo_762x39mm_FMJ",
    { OptimalBarrel = 80, Range = 28, Recoil = 20, MinDamage = 1.2, MaxDamage = 2.5, Penetration = 65, Case = "Case_762x39mm", UseWith = {"Ammo_762x39mm"}, BoxCount = 20, CanCount = 200, DisplayName = "7.62x39mm FMJ", Weight = 0.02 }
)
register("Ammo_762x39mm_HP",
    { OptimalBarrel = 80, Range = 28, Recoil = 20, MinDamage = 1.6, MaxDamage = 2.5, Penetration = 13, Case = "Case_762x39mm", UseWith = {"Ammo_762x39mm"}, BoxCount = 20, CanCount = 200, DisplayName = "7.62x39mm HP", Weight = 0.02 }
)
register("Ammo_762x51mm_FMJ",
    { OptimalBarrel = 80, Range = 33, Recoil = 25, MinDamage = 1.4, MaxDamage = 2.6, Penetration = 80, Case = "Case_762x51mm", UseWith = {"Ammo_308Winchester", "Ammo_762x51mm"}, BoxCount = 20, CanCount = 200, DisplayName = "7.62x51mm FMJ", Weight = 0.02 }
)
register("Ammo_762x51mm_HP",
    { OptimalBarrel = 80, Range = 33, Recoil = 25, MinDamage = 1.8, MaxDamage = 2.6, Penetration = 20, Case = "Case_762x51mm", UseWith = {"Ammo_308Winchester", "Ammo_762x51mm"}, BoxCount = 20, CanCount = 200, DisplayName = "7.62x51mm HP", Weight = 0.02 }
)
register("Ammo_762x54mm_FMJ",
    { OptimalBarrel = 80, Range = 35, Recoil = 25, MinDamage = 1.6, MaxDamage = 2.8, Penetration = 80, Case = "Case_762x54mm", UseWith = {"Ammo_762x54mm"}, BoxCount = 20, CanCount = 200, DisplayName = "7.62x54mm FMJ", Weight = 0.025 }
)
register("Ammo_762x54mm_HP",
    { OptimalBarrel = 80, Range = 35, Recoil = 25, MinDamage = 2.0, MaxDamage = 2.8, Penetration = 20, Case = "Case_762x54mm", UseWith = {"Ammo_762x54mm"}, BoxCount = 20, CanCount = 200, DisplayName = "7.62x54mm FMJ", Weight = 0.025 }
)
register("Ammo_12g_00Buck",
    { OptimalBarrel = 60, Range = 10, Recoil = 50, MinDamage = 1.0, MaxDamage = 2.2, MaxHitCount = 4, Penetration = false, Case = "Case_12g", UseWith = {"Ammo_12g"}, BoxCount = 25, CanCount = 250, DisplayName = "12 Gauge 00 Buck", Weight = 0.04, RoundType = "Shell" }
)
register("Ammo_12g_Slug",
    { OptimalBarrel = 60, Range = 12, Recoil = 50, MinDamage = 2.0, MaxDamage = 2.8, MaxHitCount = 1, Penetration = 95, Case = "Case_12g", UseWith = {"Ammo_12g"}, BoxCount = 25, CanCount = 250, DisplayName = "12 Gauge Slug", Weight = 0.04, RoundType = "Shell" }
)
ORGM.log(ORGM.INFO, "All default ammo registered.")
