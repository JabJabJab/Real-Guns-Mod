# Real-Guns-Mod

Git repository for the Real Guns Mod for Project Zomboid.

By ORMtmMan. 

(reloaded by Fenris_Wolf)

Changes from 1.24:

* ORGMMods.txt: 
    SA80SA223 listed as SA80223SA in multiple mods
    HK91762 listed as KH91762 in multiple mods
    Missing ; between HKSL8556 and AIAW308 in multiple mods
    x2 Scope listed as 'WeaponMod' not 'WeaponPart', removed 'MountType = SD'
    x4 Scope had SR-25 not SR25
    Multipe mods missing slug variants of shotguns
    

* ORGMPistols.txt: 
    BreakSound missing from RugerMKII and WaltherP22

* ORGMSMGS.txt: 
    BreakSound missing from AM180, FNP90, HKMP5, HKUMP, Kriss, KTPLR, M1A1
    
* ORGMRifles.txt: 
    item AR10308SA should be AR10SA308 (as listed in ReloadUtil.lua scripts, and following previous defined naming conventions)
    item SA80223SA should be SA80SA223
    All rifles missing BreakSound

* ORGMRepair.txt:
    Added missing guns: Glock20, HKMK23, WaltherPPK, ColtAnac, FNP90, Garand, 
    RugAlas45C required RugAlas
    HKG3SA308 required HKG3SA
    R25762 required SR25308
    BenelliXM1014 and BenelliXM1014Sl required BenelliM1014 and BenelliM1014Sl (missing the X)
    M1216 and M1216Sl listed as M1213

* ORGMRecipes.txt:
    fixed all recipes from calling non-existent OnCreate functions
    BenelliM3 and Spas12 pump to semi-auto conversions moved into ORGMRecipes.txt and ORGMRecipecode.lua, bulky lua conversion code removed (ORGMConversionMenu2.lua, ORGMConversions2.lua and ORGMConvertAction2.lua)

* ORGMRecipecode.lua (new file)
    Handling OnCreate functions for Pump/Semi-Auto and Semi/Full-Auto changes.
    Switching from Semi to Full-Auto (and back) now keeps all weapon mods and ammo loaded.

* ORGMReloadUtil.lua: 
    BrownHPMag had type incorrectly listed as BrownHP
    removed double entries of Glock18 and Glock17Mag.
    SIG550223 listed twice, SIG550SA223 missing. SIG550223 using the 5.56 mags (same issues with SIG551223)
    LEN04308Mag had type listed as LEN04308Mag (0 not o)
    LENo4308 had type listed as LEN04308 (0 not o), ammoType as LENo4Mag308 (not LENo4308Mag)
    All weapon shootSound keys now point to the proper sound files.
    All items sorted into groups (and in alphabetical order for ease of finding: mags, revolvers, pistols, smgs, rifles, shotguns).
    ReloadUtil:addMagazineType() for each magazine placed directly under the mag definition table, ensuring quick checking so no magazine is forgotten.
    ReloadUtil:addWeaponType() called directly on the definition table, skipping pointless variable creation.
    
* ORGMReloadUtil2.lua: 
    Merged with ORGMReloadUtil.lua fixing variable scope issues
    Glock18SA uses Glock17Mag, which was defined as a local variable in ORGMReloadUtil.lua
    addMagazineType() passed nil variable (VEPR12SlugMag instead of VEPR12SlMag)
    M1216Sl clipData = M1216SlMag (nil variable, correct variable was named M1216SlugMag)

* FlashlightFix.lua: removed pointless table from the global namespace.

* ORGMDistribution.lua: completely reworked to a more compact and manageable code.

* ORGMInventoryUnloadMenu.lua: 
    removed pointless table from polluting global namespace, fixed multiple variables not defined local.

* ORGMWeaponManualMF:
    function :isChainUnloading() incorrectly assigned to ORGMWeaponAutoMF table

* ORGMWeaponManualIMNC:
    functions :isUnloadValid(), :unloadStart(), :isChainUnloading() incorrectly assigned to ORGMWeaponManualIM table