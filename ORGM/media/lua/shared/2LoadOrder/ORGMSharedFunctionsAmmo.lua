local getTableData = ORGM.getTableData

--[[ ORGM.getMagazineData(itemType, moduleName)

    Safer way of accessing the ORGM.MagazineTable table, supports module checking.
    Less to break in the future.

    itemType is a string magazine name, or a InventoryItem object
    moduleName is a string module name to compare (optional)

    returns nil or the data table setup from ORGM.registerMagazine()

]]
ORGM.getMagazineData = function(itemType, moduleName)
    return getTableData(itemType, moduleName, "InventoryItem", ORGM.MagazineTable)
end


--[[ ORGM.isMagazine(itemType, moduleName)

    Safer way of accessing the ORGM.MagazineTable table, supports module
    checking. Less to break in the future.

    itemType is a string magazine name, or a InventoryItem object
    moduleName is a string module name to compare (optional)

    returns true|false if the item is a ORGM registered magazine

]]
ORGM.isMagazine = function(itemType, moduleName)
    if ORGM.getMagazineData(itemType, moduleName) then return true end
    return false
end


--[[ ORGM.getAmmoData(itemType, moduleName)

    Safer way of accessing the ORGM.AmmoTable table, supports module
    checking. Less to break in the future.

    itemType is a string component name, or a InventoryItem object
    moduleName is a string module name to compare (optional)

    returns nil or the data table setup from ORGM.registerAmmo()

]]
ORGM.getAmmoData = function(itemType, moduleName)
    return getTableData(itemType, moduleName, "InventoryItem", ORGM.AmmoTable)
end


--[[ ORGM.isAmmo(itemType, moduleName)

    Safer way of accessing the ORGM.AmmoTable table, supports module
    checking. Less to break in the future.

    itemType is a string ammo name, or a InventoryItem object
    moduleName is a string module name to compare (optional)

    returns true|false if the item is a ORGM registered ammo

]]
ORGM.isAmmo = function(itemType, moduleName)
    if ORGM.getAmmoData(itemType, moduleName) then return true end
    return false
end


--[[ ORGM.getAmmoGroup(itemType)

    Returns the ammo group table for the specified itemType. The table contains
    all the ammo types that can be used for this group.

    itemType is a string name of a ammo group

    return nil or the table of real ammo names.

]]
ORGM.getAmmoGroup = function(itemType)
    return ORGM.AmmoGroupTable[itemType]
end


--[[  ORGM.getItemAmmoGroup(item)

    return the AmmoGroup for the item.
    item is a string of the item, or a InventoryItem weapon or magazine

    returns a string ammo group name
]]
ORGM.getItemAmmoGroup = function(item)
    local gun = ORGM.getFirearmData(item)
    local mag = ORGM.getMagazineData(item)
    if gun then
        mag = gun.clipData
    end
    if mag then return mag.ammoType end
    if not gun then return nil end
    return gun.ammoType
    --return item:getAmmoType()
end


--[[ ORGM.setupMagazine(magazineType, item)

    Sets up a magazine, applying key/values into the items modData. Basically the same as
    ReloadUtil:setupMagazine and ISORGMMagazine:setupReloadable but called without needing
    a player or reloadable object.

    magazineData is the data returned from ReloadUtil:getClipData(magazineType)
    item is a InventoryItem object

    return nil

]]
ORGM.setupMagazine = function(magazineData, item)
    --local magazineData = ReloadUtil:getClipData(magazineType)
    local modData = item:getModData()
    modData.type = magazineData.type
    modData.moduleName = magazineData.moduleName
    modData.reloadClass = magazineData.reloadClass
    modData.ammoType = magazineData.ammoType
    modData.loadStyle = magazineData.reloadStyle
    modData.ejectSound = magazineData.ejectSound
    modData.clickSound = magazineData.clickSound
    modData.insertSound = magazineData.insertSound
    modData.rackSound = magazineData.rackSound
    modData.maxCapacity = magazineData.maxCapacity or item:getClipSize() -- item: calls are pointless, this data isnt in the script
    modData.reloadTime = magazineData.reloadTime or item:getReloadTime() -- item: calls are pointless, this data isnt in the script
    modData.rackTime = magazineData.rackTime
    modData.currentCapacity = 0
    modData.clipType = magazineData.clipType
    modData.magazineData = { }
    modData.preferredAmmoType = 'any'
    modData.loadedAmmo = nil
    modData.BUILD_ID = ORGM.BUILD_ID
end


--[[ ORGM.findBestMagazineInContainer(magazineType, preferredType, containerItem)

    Finds the best matching magazine in a container based on the given magazine name and
    preferred type (can be specific round name, nil/any, or mixed)

    This is called when reloading some guns, but placed here so mods like survivors can find
    the proper ammo without needing access to the actual reloadable object.

    Note magazineType and preferredType should NOT have the "ORGM." prefix.

    magazineType is the name of the magazine (a key in ORGM.MagazineTable)
    preferredType is the ammo the magazine should be loaded with. Can be nil (or 'any'),
        'mixed', or a specific string matching a ORGM.AmmoTable key.
    containerItem is a ItemContainer object.

    returns nil or a InventoryItem

]]
ORGM.findBestMagazineInContainer = function(magazineType, preferredType, containerItem)
    if magazineType == nil then return nil end
    if not ORGM.isMagazine(magazineType) then return nil end -- not a valid orgm mag
    if containerItem == nil then return nil end -- forgot the container item!
    if preferredType == nil then preferredType = 'any' end
    local bestMagazine = nil
    local mostAmmo = -1
    -- TODO: this needs a extra loop here, for possible alternate magazines
    local items = containerItem:getItemsFromType(magazineType)
    local magazineData = ReloadUtil:getClipData(magazineType)

    for i = 0, items:size()-1 do repeat
        local currentItem = items:get(i)
        local modData = currentItem:getModData()
        if modData.currentCapacity == nil then -- magazine needs to be setup
            ORGM.setupMagazine(magazineData, currentItem)
        end
        if modData.currentCapacity <= mostAmmo then
            break
        end

        if preferredType ~= 'any' and preferredType ~= modData.loadedAmmo then
            break
        end
        bestMagazine = currentItem
        mostAmmo = modData.currentCapacity
    until true end
    return bestMagazine
end


--[[ ORGM.findAmmoInContainer(ammoGroup, preferredType, containerItem, mode)

    Finds the best matching ammo (bullets only) in a container based on the given
    ammoGroup name and preferred type (can be specific round name, nil/any, or mixed)

    This is called when reloading some guns and all magazines, but placed here so mods
    like survivors can find the proper ammo without needing access to the actual reloadable
    object.

    Note ammoGroup and preferredType should NOT have the "ORGM." prefix.

    ammoGroup is the name of the ammo group (a key in ORGM.AmmoGroupTable)
    preferredType is nil (or 'any'), 'mixed' (a random pick from ORGM.AmmoGroupTable values)
        or a specific string matching one of the ORGM.AmmoGroupTable values.
    containerItem is a ItemContainer object.
    mode = nil | 0 (rounds) | 1 (box) | 2 (can)

    returns nil or a InventoryItem

]]
ORGM.findAmmoInContainer = function(ammoGroup, preferredType, containerItem, mode)
    if ammoGroup == nil then return nil end
    if containerItem == nil then return nil end
    if preferredType == nil then preferredType = 'any' end

    local suffex = ""
    if mode == 1 then
        suffex = "_Box"
    elseif mode == 2 then
        suffex = "_Can"
    end

    if preferredType ~= "any" and preferredType ~= 'mixed' then
        -- a preferred ammo is set, we only look for these bullets
        return containerItem:FindAndReturn(preferredType .. suffex)
    end

    -- this shouldn't actually be here, self.ammoType is just a AmmoGroup round
    local round = containerItem:FindAndReturn(ammoGroup .. suffex)
    if round then return round end

    -- check if there are alternate ammo types we can use
    local roundTable = ORGM.getAmmoGroup(ammoGroup)
    -- there should always be a entry, unless we were given a bad ammoGroup
    if roundTable == nil then return nil end

    if preferredType == 'mixed' then
        local options = {}
        for _, value in ipairs(roundTable) do
            -- check what rounds the player has
            if containerItem:FindAndReturn(value .. suffex) then table.insert(options, value .. suffex) end
        end
        -- randomly pick one
        return containerItem:FindAndReturn(options[ZombRand(#options) + 1])

    else -- not a random picking, go through the list in order
        for _, value in ipairs(roundTable) do
            round = containerItem:FindAndReturn(value .. suffex)
            if round then return round end
        end
    end
    if round then return round end
    return nil
end


--[[ ORGM.findAllAmmoInContainer(ammoGroup, preferredType, containerItem)

]]
ORGM.findAllAmmoInContainer = function(ammoGroup, containerItem)
    if ammoGroup == nil then return nil end
    if containerItem == nil then return nil end

    -- check if there are alternate ammo types we can use
    local roundTable = ORGM.getAmmoGroup(ammoGroup)
    -- there should always be a entry, unless we were given a bad ammoGroup
    if roundTable == nil then
        if ORGM.isAmmo(ammoGroup) then
            roundTable = {ammoGroup}
        else
            return nil
        end
    end
    local results = {
        rounds = container:FindAll(table.concat(roundtable, "/")),
        boxes = container:FindAll(table.concat(roundtable, "_Box/").."_Box"),
        cans = container:FindAll(table.concat(roundtable, "_Can/").."_Can"),
    }
    return results
end


--[[ ORGM.convertAllAmmoGroupRounds(ammoGroupName, containerItem)

    Converts all AmmoGroup rounds of the given name to the first entry in the ORGM.AmmoGroupTable (FMJ or Buck)
    Note ammoGroupName and preferredType should NOT have the "ORGM." prefix.

    AmmoGroupName is the name of the AmmoGroup round (a key in ORGM.AlternateAmmoTable)
    containerItem is a ItemContainer object.

    returns nil on error (invalid names), or the number of rounds converted

]]
ORGM.convertAllAmmoGroupRounds = function(ammoGroupName, containerItem)
    if ammoGroupName == nil then return nil end
    if containerItem == nil then return nil end
    local roundTable = ORGM.getAmmoGroup(ammoGroupName)
    -- there should always be a entry, unless we were given a bad AmmoGroupName
    if roundTable == nil then
        ORGM.log(ORGM.ERROR, "Tried to convert invalid dummy round ".. ammoGroupName)
        return nil
    end
    local count = containerItem:getNumberOfItem(ammoGroupName)
    if count == nil or count == 0 then return 0 end
    containerItem:RemoveAll(ammoGroupName)

    containerItem:AddItems(roundTable[1].moduleName .. roundTable[1], count)
    return count
end

ORGM.getAmmoTypeForBox = function(item)
    if instanceof(item, "InventoryItem") then
        item = item:getType()
    end
    item = string.sub(item, 1, -5)
    if ORGM.isAmmo(item) then return item end
    return nil
end


ORGM.unboxAmmoItem = function(item)
    local container = item:getContainer()
    local ammoType = ORGM.getAmmoTypeForBox(item)
    if not ammoType or not container then return end
    local boxType = string.sub(item:getType(), -3)
    local ammoData = ORGM.getAmmoData(ammoType)
    if ammoData and boxType == "Box" then
        container:AddItems(ammoType, ammoData.BoxCount or 0)
    elseif ammoData and boxType == "Can" then
        container:AddItems(ammoType, ammoData.CanCount or 0)
    else
        return
    end
    container:Remove(item)
end
ORGM[13] = "4\07052474\068"
