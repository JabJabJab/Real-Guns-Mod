--[[-

Everything in here exists for compatibility.

Expect functions in here to be phased out.
If you have a 3d party mod that uses any of these tables it needs to be updated.

Earliest current version support is ORGM 2.03

@script ORGMCompatibility.lua
@author Fenris_Wolf
@release 3.09
@copyright **File:** shared/ORGMCompatibility.lua

]]
-- 3.09
ORGM.SoundProfiles = ORGM.Sounds.Profiles

-- these tables are now marked private.
ORGM.AmmoTable = ORGM.Ammo.getTable()
ORGM.AmmoGroupTable = ORGM.Ammo.getGroupTable()
ORGM.FirearmTable = ORGM.Firearm.getTable()
ORGM.MagazineTable = ORGM.Magazine.getTable()
ORGM.RepairKitTable = ORGM.Maintance.getTable()
ORGM.ComponentTable = ORGM.Component.getTable()

-- depreciated functions
ORGM.addToSoundBankQueue = ORGM.Sounds.add

ORGM.registerAmmo = ORGM.Ammo.register
ORGM.getAmmoData = ORGM.Ammo.getData
ORGM.isAmmo = ORGM.Ammo.isAmmo
ORGM.getAmmoGroup = ORGM.Ammo.getGroup
ORGM.getItemAmmoGroup = ORGM.Ammo.itemGroup
ORGM.findAmmoInContainer = ORGM.Ammo.findIn
ORGM.findAllAmmoInContainer = ORGM.Ammo.findAllIn
ORGM.convertAllAmmoGroupRounds = ORGM.Ammo.convertAllIn
ORGM.getAmmoTypeForBox = ORGM.Ammo.boxType
ORGM.unboxAmmoItem = ORGM.Ammo.unbox

ORGM.registerComponent = ORGM.Component.register
ORGM.getComponentData = ORGM.Component.getData
ORGM.isComponent = ORGM.Component.isComponent
ORGM.getItemComponents = ORGM.Component.getAttached
ORGM.copyFirearmComponent = ORGM.Component.copy
ORGM.toggleTacticalLight = ORGM.Component.toggleLight

ORGM.registerFirearm = ORGM.Firearm.register
ORGM.getFirearmData = ORGM.Firearm.getData
ORGM.isFirearm = ORGM.Firearm.isFirearm
ORGM.setupGun = ORGM.Firearm.setup
ORGM.getFirearmNeedsUpdate = ORGM.Firearm.needsUpdate
ORGM.replaceFirearmWithNewCopy = ORGM.Firearm.replace
ORGM.isFullAuto = ORGM.Firearm.isFullAuto
ORGM.getBarrelLength = ORGM.Firearm.Barrel.getLength
ORGM.getBarrelWeightModifier = ORGM.Firearm.Barrel.getWeight
--ORGM.getOptimalBarrelLength
ORGM.setFirearmStats = ORGM.Firearm.set
ORGM.getInitialFirearmStats = ORGM.Firearm.initial
ORGM.adjustFirearmStatsByCategory = ORGM.Firearm.adjustByCategory
ORGM.adjustFirearmStatsByBarrel = ORGM.Firearm.adjustByBarrel
ORGM.adjustFirearmStatsByComponents = ORGM.Firearm.adjustByComponents
ORGM.adjustFirearmStatsByFeedSystem = ORGM.Firearm.adjustByFeed
ORGM.setFirearmPiercingBullets = ORGM.Firearm.setPenetration_DEPRECIATED

ORGM.registerMagazine = ORGM.Magazine.register
ORGM.getMagazineData = ORGM.Magazine.getData
ORGM.isMagazine = ORGM.Magazine.isMagazine
ORGM.setupMagazine = ORGM.Magazine.setup
ORGM.findBestMagazineInContainer = ORGM.Magazine.findIn

ORGM.registerRepairKit = ORGM.Maintance.register

-- 3.07 change
ORGM.AlternateAmmoTable = ORGM.Ammo.getGroupTable()


-- 2.03 stuff
ORGMAlternateAmmoTable = ORGM.Ammo.getGroupTable()
ORGMMasterAmmoTable = ORGM.Ammo.getTable()
ORGMMasterMagTable = ORGM.Magazine.getTable()
ORGMMasterWeaponTable = ORGM.Firearm.getTable()
ORGMRepairKitsTable = { }
ORGMWeaponModsTable = { }
