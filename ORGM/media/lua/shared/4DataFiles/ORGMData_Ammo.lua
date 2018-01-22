--[[
    This file contains all default ammo data.
]]

--[[  ORGM.registerAmmo(name, definition)
    
    Registers a ammo type with ORGM.  This must be called before any registerMagazine or registerFirearm that plans
    to use that ammo.
    NOTE: this should only be called with real ammo (ie: Ammo_9x19mm_FMJ) and not dummy rounds (ie: Ammo_9x19mm)
    
    name = string name of the ammo (without module prefix)
    definition = a table containing the ammo stats. Valid table keys/value pairs are:
        moduleName = nil, or string module name this item is from. If nil, ORGM is used
        MinDamage = float, the min damage of the bullet. This overrides the firearm item MinDamage 
        MaxDamage = float, the max damage of the bullet. This overrides the firearm item MaxDamage 
        PiercingBullets = boolean | integer (% chance). This overrides the firearm item PiercingBullets
        MaxHitCount = nil | integer. This overrides the firearm item MaxHitCount. Only valid for firearms with multiple 
            projectiles (ie: shotguns)
        Case = string | the empty case to eject
        UseWith = nil | table, the 'dummy round' names this ammo can be used for. if nil, the name parameter is used

    returns true on success, false if the ammo fails to register

]]
local register = ORGM.registerAmmo

register("Ammo_117BB", 
    { MinDamage = 0.1, MaxDamage = 0.1, PiercingBullets = false, UseWith = {"Ammo_117BB"} }
)
register("Ammo_22LR_FMJ",   
    { MinDamage = 0.4, MaxDamage = 0.8, PiercingBullets = 10, Case = "Case_Ammo_22LR", UseWith = {"Ammo_22LR"} }
)
register("Ammo_22LR_HP",
    { MinDamage = 0.5, MaxDamage = 0.9, PiercingBullets = 2,  Case = "Case_Ammo_22LR", UseWith = {"Ammo_22LR"} }
)
register("Ammo_32ACP_FMJ",
    { MinDamage = 0.7, MaxDamage = 1.3, PiercingBullets = 15, Case = "Case_32ACP", UseWith = {"Ammo_32ACP"} }
)
register("Ammo_32ACP_HP",
    { MinDamage = 0.9, MaxDamage = 1.3, PiercingBullets = 3,  Case = "Case_32ACP", UseWith = {"Ammo_32ACP"} }
)
register("Ammo_357Magnum_FMJ",
    { MinDamage = 0.9, MaxDamage = 1.9, PiercingBullets = 50, Case = "Case_357Magnum", UseWith = {"Ammo_357Magnum"} }
)
register("Ammo_357Magnum_HP",
    { MinDamage = 1.2, MaxDamage = 1.9, PiercingBullets = 10, Case = "Case_357Magnum", UseWith = {"Ammo_357Magnum"} }
)
register("Ammo_38Special_FMJ",
    { MinDamage = 0.7, MaxDamage = 1.6, PiercingBullets = 30, Case = "Case_38Special", UseWith = {"Ammo_357Magnum", "Ammo_38Special"} }
)
register("Ammo_38Special_HP",
    { MinDamage = 1.0, MaxDamage = 1.6, PiercingBullets = 8,  Case = "Case_38Special", UseWith = {"Ammo_357Magnum", "Ammo_38Special"} }
)
register("Ammo_38Super_FMJ",
    { MinDamage = 0.7, MaxDamage = 1.7, PiercingBullets = 30, Case = "Case_38Super", UseWith = {"Ammo_38Super"} }
)
register("Ammo_38Super_HP",
    { MinDamage = 1.0, MaxDamage = 1.7, PiercingBullets = 8,  Case = "Case_38Super", UseWith = {"Ammo_38Super"} }
)
register("Ammo_380ACP_FMJ",
    { MinDamage = 0.7, MaxDamage = 1.5, PiercingBullets = 25, Case = "Case_380ACP", UseWith = {"Ammo_380ACP"} }
)
register("Ammo_380ACP_HP",
    { MinDamage = 1.0, MaxDamage = 1.5, PiercingBullets = 7,  Case = "Case_380ACP", UseWith = {"Ammo_380ACP"} }
)
register("Ammo_40SW_FMJ",
    { MinDamage = 0.8, MaxDamage = 1.7, PiercingBullets = 50, Case = "Case_40SW", UseWith = {"Ammo_40SW"} }
)
register("Ammo_40SW_HP",
    { MinDamage = 1.1, MaxDamage = 1.7, PiercingBullets = 10, Case = "Case_40SW", UseWith = {"Ammo_40SW"} }
)
register("Ammo_44Magnum_FMJ",
    { MinDamage = 1.2, MaxDamage = 2.2, PiercingBullets = 65, Case = "Case_44Magnum", UseWith = {"Ammo_44Magnum"} }
)
register("Ammo_44Magnum_HP",
    { MinDamage = 1.6, MaxDamage = 2.2, PiercingBullets = 13, Case = "Case_44Magnum", UseWith = {"Ammo_44Magnum"} }
)
register("Ammo_45ACP_FMJ",
    { MinDamage = 1.0, MaxDamage = 1.8, PiercingBullets = 50, Case = "Case_45ACP", UseWith = {"Ammo_45ACP"} }
)
register("Ammo_45ACP_HP",
    { MinDamage = 1.3, MaxDamage = 1.8, PiercingBullets = 10, Case = "Case_45ACP", UseWith = {"Ammo_45ACP"} }
)
register("Ammo_45Colt_FMJ",
    { MinDamage = 1.1, MaxDamage = 2.1, PiercingBullets = 60, Case = "Case_45Colt", UseWith = {"Ammo_45Colt", "Ammo_454Casull"} }
)
register("Ammo_45Colt_HP",
    { MinDamage = 1.5, MaxDamage = 2.1, PiercingBullets = 12, Case = "Case_45Colt", UseWith = {"Ammo_45Colt", "Ammo_454Casull"} }
)
register("Ammo_454Casull_FMJ",
    { MinDamage = 1.3, MaxDamage = 2.3, PiercingBullets = 67, Case = "Case_454Casull", UseWith = {"Ammo_454Casull"} }
)
register("Ammo_454Casull_HP",
    { MinDamage = 1.7, MaxDamage = 2.3, PiercingBullets = 14, Case = "Case_454Casull", UseWith = {"Ammo_454Casull"} }
)
register("Ammo_50AE_FMJ",
    { MinDamage = 1.3, MaxDamage = 2.3, PiercingBullets = 67, Case = "Case_50AE", UseWith = {"Ammo_50AE"} }
)
register("Ammo_50AE_HP",
    { MinDamage = 1.7, MaxDamage = 2.3, PiercingBullets = 14, Case = "Case_50AE", UseWith = {"Ammo_50AE"} }
)
register("Ammo_223Remington_FMJ",
    { MinDamage = 1.4, MaxDamage = 2.4, PiercingBullets = 75, Case = "Case_223Remington", UseWith = {"Ammo_223Remington", "Ammo_556x45mm"} }
)
register("Ammo_223Remington_HP",
    { MinDamage = 1.8, MaxDamage = 2.4, PiercingBullets = 15, Case = "Case_223Remington", UseWith = {"Ammo_223Remington", "Ammo_556x45mm"} }
)
register("Ammo_3006Springfield_FMJ",
    { MinDamage = 1.4, MaxDamage = 2.4, PiercingBullets = 75, Case = "Case_3006Springfield", UseWith = {"Ammo_3006Springfield"} }
)
register("Ammo_3006Springfield_HP",
    { MinDamage = 1.7, MaxDamage = 2.4, PiercingBullets = 15, Case = "Case_3006Springfield", UseWith = {"Ammo_3006Springfield"} }
)
register("Ammo_3030Winchester_FMJ",
    { MinDamage = 0.8, MaxDamage = 1.6, PiercingBullets = 30, Case = "Case_3030Winchester", UseWith = {"Ammo_3030Winchester"} }
)
register("Ammo_3030Winchester_HP",
    { MinDamage = 1.0, MaxDamage = 1.6, PiercingBullets = 8,  Case = "Case_3030Winchester", UseWith = {"Ammo_3030Winchester"} }
)
register("Ammo_308Winchester_FMJ",
    { MinDamage = 1.4, MaxDamage = 2.6, PiercingBullets = 80, Case = "Case_308Winchester", UseWith = {"Ammo_308Winchester", "Ammo_762x51mm"} }
)
register("Ammo_308Winchester_HP",
    { MinDamage = 1.8, MaxDamage = 2.6, PiercingBullets = 20, Case = "Case_308Winchester", UseWith = {"Ammo_308Winchester", "Ammo_762x51mm"} }
)
register("Ammo_57x28mm_FMJ",
    { MinDamage = 0.7, MaxDamage = 1.6, PiercingBullets = 90, Case = "Case_57x28mm", UseWith = {"Ammo_57x28mm"} }
)
register("Ammo_57x28mm_HP",
    { MinDamage = 1.0, MaxDamage = 1.6, PiercingBullets = 40, Case = "Case_57x28mm", UseWith = {"Ammo_57x28mm"} }
)
register("Ammo_9x19mm_FMJ",
    { MinDamage = 0.7, MaxDamage = 1.6, PiercingBullets = 50, Case = "Case_9x19mm", UseWith = {"Ammo_9x19mm"} }
)
register("Ammo_9x19mm_HP",
    { MinDamage = 1.0, MaxDamage = 1.6, PiercingBullets = 10, Case = "Case_9x19mm", UseWith = {"Ammo_9x19mm"} }
)
register("Ammo_10x25mm_FMJ",
{ MinDamage = 0.9, MaxDamage = 1.9, PiercingBullets = 55, Case = "Case_10x25mm", UseWith = {"Ammo_10x25mm"} }
)
register("Ammo_10x25mm_HP",
    { MinDamage = 1.2, MaxDamage = 1.9, PiercingBullets = 12, Case = "Case_10x25mm", UseWith = {"Ammo_10x25mm"} }
)
register("Ammo_556x45mm_FMJ",
    { MinDamage = 1.4, MaxDamage = 2.4, PiercingBullets = 75, Case = "Case_556x45mm", UseWith = {"Ammo_223Remington", "Ammo_556x45mm"} }
)
register("Ammo_556x45mm_HP",
    { MinDamage = 1.8, MaxDamage = 2.4, PiercingBullets = 15, Case = "Case_556x45mm", UseWith = {"Ammo_223Remington", "Ammo_556x45mm"} }
)
register("Ammo_762x39mm_FMJ",
    { MinDamage = 1.2, MaxDamage = 2.2, PiercingBullets = 65, Case = "Case_762x39mm", UseWith = {"Ammo_762x39mm"} }
)
register("Ammo_762x39mm_HP",
    { MinDamage = 1.6, MaxDamage = 2.2, PiercingBullets = 13, Case = "Case_762x39mm", UseWith = {"Ammo_762x39mm"} }
)
register("Ammo_762x51mm_FMJ",
    { MinDamage = 1.4, MaxDamage = 2.6, PiercingBullets = 80, Case = "Case_762x51mm", UseWith = {"Ammo_308Winchester", "Ammo_762x51mm"} }
)
register("Ammo_762x51mm_HP",
    { MinDamage = 1.8, MaxDamage = 2.6, PiercingBullets = 20, Case = "Case_762x51mm", UseWith = {"Ammo_308Winchester", "Ammo_762x51mm"} }
)
register("Ammo_762x54mm_FMJ",
    { MinDamage = 1.6, MaxDamage = 2.8, PiercingBullets = 80, Case = "Case_762x54mm", UseWith = {"Ammo_762x54mm"} }
)
register("Ammo_762x54mm_HP",
    { MinDamage = 2.0, MaxDamage = 2.8, PiercingBullets = 20, Case = "Case_762x54mm", UseWith = {"Ammo_762x54mm"} }
)
register("Ammo_12g_00Buck",
    { MinDamage = 1.0, MaxDamage = 2.2, MaxHitCount = 4, PiercingBullets = false, Case = "Case_12g", UseWith = {"Ammo_12g"} }
)
register("Ammo_12g_Slug",
    { MinDamage = 2.0, MaxDamage = 2.8, MaxHitCount = 1, PiercingBullets = 95, Case = "Case_12g", UseWith = {"Ammo_12g"} }
)
ORGM.log(ORGM.INFO, "All default ammo registered.")