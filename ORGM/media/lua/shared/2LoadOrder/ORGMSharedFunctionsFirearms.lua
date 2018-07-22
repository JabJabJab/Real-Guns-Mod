local getTableData = ORGM.getTableData

--[[ ORGM.getFirearmData(itemType, moduleName)

    Safer way of accessing the ORGM.FirearmTable table, supports module checking.
    Less to break in the future.

    itemType is a string firearm name, or a InventoryItem object
    moduleName is a string module name to compare (optional)

    returns nil or the data table setup from ORGM.registerFirearm()

]]
ORGM.getFirearmData = function(itemType, moduleName)
    return getTableData(itemType, moduleName, "HandWeapon", ORGM.FirearmTable)
end


--[[ ORGM.isFirearm(itemType, moduleName)

    Safer way of accessing the ORGM.FirearmTable table, supports module checking.
    Less to break in the future.

    itemType is a string firearm name, or a InventoryItem object
    moduleName is a string module name to compare (optional)

    returns true|false if the item is a ORGM registered firearm

]]
ORGM.isFirearm = function(itemType, moduleName)
    if ORGM.getFirearmData(itemType, moduleName) then return true end
    return false
end


--[[ ORGM.setupGun(gunData, item)

    Sets up a gun, applying key/values into the items modData. Basically the same as
    ReloadUtil:setupGun and ISORGMWeapon:setupReloadable but called without needing
    a player or reloadable object.

    gunData is the data returned from ReloadUtil:getWeaponData(gunType)
    item is a InventoryItem object

    return nil

]]
ORGM.setupGun = function(gunData, item)
    local modData = item:getModData()
    ---------------------------------------------
    -- ISReloadableWeapon.setupReloadable(self, weapon, v)
    modData.defaultAmmo = item:getAmmoType()
    modData.defaultSwingSound = item:getSwingSound()
    ---------------------------------------------

    --ISReloadable:setupReloadable(item, v)
    modData.type = gunData.type
    modData.moduleName = gunData.moduleName
    modData.reloadClass = gunData.reloadClass
    modData.ammoType = gunData.ammoType
    modData.loadStyle = gunData.reloadStyle -- TODO: unused?
    modData.ejectSound = gunData.ejectSound
    modData.clickSound = gunData.clickSound
    modData.insertSound = gunData.insertSound
    modData.rackSound = gunData.rackSound
    modData.maxCapacity = gunData.maxCapacity or item:getClipSize()
    modData.reloadTime = gunData.reloadTime or item:getReloadTime()
    modData.rackTime = gunData.rackTime
    modData.currentCapacity = 0
    ---------------------------------------------

    -- custom stuff
    modData.cockSound = gunData.cockSound
    modData.openSound = gunData.openSound
    modData.closeSound = gunData.closeSound

    if gunData.clipData then modData.containsClip = 1 end
    modData.clipName = gunData.clipName
    modData.clipIcon = gunData.clipIcon

    modData.actionType = gunData.actionType -- Auto, Pump, Lever, Rotary, Break
    modData.triggerType = gunData.triggerType -- SingleAction, DoubleAction
    modData.speedLoader = gunData.speedLoader -- speedloader/stripperclip name
    -- alternate action type, ie: semi auto that can also be pump, etc. This is a table list of all actionTypes used by the gun
    modData.altActionType = gunData.altActionType
    -- selectFire is nil for no selection possible, 0 if the weapon is CURRENTLY in semi-auto, 1 if CURRENTLY in full-auto
    modData.selectFire = gunData.selectFire

    if modData.actionType == ORGM.ROTARY or modData.actionType == ORGM.BREAK then
        modData.cylinderPosition = 1 -- position is 1 to maxCapacity (required for % oper to work properly)
        modData.roundChambered = nil
        modData.emptyShellChambered = nil
    else
        modData.roundChambered = 0 -- 0 or 1, a round is currently chambered
        modData.emptyShellChambered = 0 -- 0 or 1, a empty shell is currently chambered
    end
    modData.isOpen = 0 -- 0 or 1, slide/bolt/cylinder is currently open
    modData.hammerCocked = 0 -- 0 or 1, hammer is currently cocked
    modData.magazineData = {} -- current rounds, LIFO list
    modData.preferredAmmoType = nil -- preferred ammo type, this is set by the UI context menu
    -- last round that was in the chamber, used for knowing what to eject, and if we should change weapon stats when chambering next round
    modData.lastRound = nil
    -- what type of rounds are loaded, either ammo name, or 'mixed'. This is only really used when ejecting a magazine, so the mag's modData
    -- has this flagged (used when loading new mags to match self.preferredAmmoType). Also used in tooltips
    modData.loadedAmmo = nil
    modData.roundsFired = 0
    modData.roundsSinceCleaned = 0
    if ZombRand(100) > 50 and gunData.barrelLengthOpt then
        -- pick random length from our options
        modData.barrelLength = gunData.barrelLengthOpt[ZombRand(#gunData.barrelLengthOpt)+1]
    else
        modData.barrelLength = gunData.barrelLength
    end
    modData.BUILD_ID = ORGM.BUILD_ID
end


--[[  ORGM.checkFirearmBuildID(item)

    item is a HandWeapon/InventoryItem

    returns a new HandWeapon/InventoryItem or nil

]]
ORGM.checkFirearmBuildID = function(item)
    if item == nil then return nil end
    local data = item:getModData()
    local def = ORGM.getFirearmData(item)
    if not def then return nil end

    if def.lastChanged and (data.BUILD_ID == nil or data.BUILD_ID < def.lastChanged) then
        ORGM.log(ORGM.INFO, "Obsolete firearm detected (" .. item:getType() .."). Running update function.")
        -- this gun has changed. reset it.
        return true
    end
    -- update the gun's build ID value.
    data.BUILD_ID = ORGM.BUILD_ID
    return false
end


--[[  ORGM.replaceFirearmWithNewCopy(item, container)

    Replaces a firearm with a brand new copy of itself, using default values.
    This is primarily for backwards compatibility with older versions of ORGM when the guns stats
    have changed.  The new gun will be in the same condition as the old, and have the same upgrades
    attached. Any ammo loaded will be returned to the container.

    item is a HandWeapon/InventoryItem
    container is the ItemContainer the item exists in

    returns a new HandWeapon/InventoryItem

]]
ORGM.replaceFirearmWithNewCopy = function(item, container)
    if item == nil then return end

    local newItem = InventoryItemFactory.CreateItem(item:getModule()..'.' .. item:getType())
    ORGM.setupGun(ORGM.getFirearmData(newItem), newItem)
    local data = item:getModData()
    local newData = newItem:getModData()

    if item:getCondition() < newItem:getConditionMax() then
        newItem:setCondition(item:getCondition())
    end
    newItem:setHaveBeenRepaired(item:getHaveBeenRepaired())

    local upgrades = {}
    if item:getCanon() then table.insert(upgrades, item:getCanon()) end
    if item:getScope() then table.insert(upgrades, item:getScope()) end
    if item:getSling() then table.insert(upgrades, item:getSling()) end
    if item:getStock() then table.insert(upgrades, item:getStock()) end
    if item:getClip() then table.insert(upgrades, item:getClip()) end
    if item:getRecoilpad() then table.insert(upgrades, item:getRecoilpad()) end
    for _, mod in ipairs(upgrades) do
        local new = ORGM.copyFirearmComponent(mod)
        newItem:attachWeaponPart(new)
    end
    if data.barrelLength then -- copy barrel lengh if the gun has one
        newData.barrelLength = data.barrelLength
    end

    newData.serialnumber = data.serialnumber -- copy the guns serial number

    -- empty the magazine, return all rounds to the container.
    if data.magazineData then -- no mag data, this gun has not properly been setup, or is legacy orgm
        for _, value in pairs(data.magazineData) do
            local def = ORGM.getAmmoData(value)
            if def then container:AddItem(def.moduleName ..'.'.. value) end
        end
    end
    if data.roundChambered ~= nil and data.roundChambered > 0 then
        for i=1, data.roundChambered do
            local def = ORGM.getAmmoData(data.lastRound)
            if def then container:AddItem(def.moduleName ..'.'.. data.lastRound) end
        end
    end
    if data.containsClip ~= nil and newData.containsClip ~= nil then
        newData.containsClip = data.containsClip
    end
    container:Remove(item)
    container:AddItem(newItem)
    container:setDrawDirty(true)
    return newItem
end
ORGM[16] = "\116\111\110\117"
