--[[
    Everything in here exists for backwards compatibility
]]


-- these tables and function will be removed at a later time.
ORGMAlternateAmmoTable = ORGM.AlternateAmmoTable
ORGMMasterAmmoTable = ORGM.AmmoTable
ORGMMasterMagTable = ORGM.MagazineTable
ORGMMasterWeaponTable = ORGM.FirearmTable
ORGMRepairKitsTable = { }
ORGMWeaponModsTable = { }

ORGM.onBootBackwardsCompatibility = function()
    for key, value in pairs(ORGM.ComponentTable) do
        table.insert(ORGMWeaponModsTable, key)
    end
    for key, value in pairs(ORGM.RepairKitTable) do
        table.insert(ORGMRepairKitsTable, key)
    end
end


--[[    This is the backwards compatibility internal changelog for firearms
    If the guns ModData.BUILD_ID is lower then the id's listed below, the weapon
    needs to be reset to default values. It is only necessary to list weapons
    here when the stats have changed on ORGM updates.

]]
ORGM.FIREARM_HISTORY['CZ75'] = 12 -- changed in 3.00-alpha
ORGM.FIREARM_HISTORY['Taurus38'] = 12 -- changed in 3.00-alpha
ORGM.FIREARM_HISTORY['BLR'] = 12 -- changed in 3.00-alpha
ORGM.FIREARM_HISTORY['HenryBB'] = 12 -- changed in 3.00-alpha
ORGM.FIREARM_HISTORY['M1903'] = 12 -- changed in 3.00-alpha










