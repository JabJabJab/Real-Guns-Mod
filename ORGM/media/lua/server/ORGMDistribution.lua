--[[ ORGMDistributions

    This file controls spawning of weapons and ammo.
    It is no longer necessary to edit this file when new guns or ammo are added to the mod.
    However, new upgrade parts still need to be added to the AllModsTable, as well as 
    repair kit in the RepairTable.
    All guns and ammo are only defined in ORGMWeaponData.lua
    
]]


--[[ WeaponUpgrades table (global, override SuburbsDistributions)
    
    used when randomly spawning weapons with ItemPicker.lua
    This table is automatically filled out below.

]]
WeaponUpgrades = { }

--[[ AllRoundsTable

    A list of all rounds to use when spawning random ammo
    This table is automatically built on startup from ORGMAmmoStatsTable
]]
local AllRoundsTable = { }

--[[ WeaponsTable

    A list of all guns, sorted into civilian, police and military, and rarity.
    This table is automatically built on startup from ORGMMasterWeaponTable
    
]]
local WeaponsTable = {
    Civilian = { Common = {},Rare = {}, VeryRare = {} },
    Police = { Common = {}, Rare = {}, VeryRare = {} },
    Military = { Common = {}, Rare = {}, VeryRare = {} },
}

--[[ AllModsTable
    A list of all ORGM weapon mods. Unfortunately I haven't found a way to auto generate this one yet
]]
local AllModsTable = {
    '2xScope', 
    '4xScope', 
    '8xScope', 
    'FibSig', 
    'Foregrip', 
    'FullCh', 
    'HalfCh', 
    'PistolLas', 
    'PistolTL', 
    'RDS', 
    'Recoil', 
    'Reflex', 
    'RifleLas', 
    'RifleTL', 
    'Rifsling', 
    'SkeletalStock', 
    'CollapsingStock'
}


local RepairTable = {
    "WD40",
    "Brushkit",
    "Maintkit",
}

----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------

--[[ Rnd(maxValue)
    
    Returns a value between 1 and maxValue (including lower and upper values)

]]
local Rnd = function(maxValue)
    return ZombRand(maxValue) + 1;
end

--[[ SpawnReloadable(container, itemType, ammoType, spawnChance, maxCount, isLoaded)

    Spawns a reloadable weapon or magazine.
    
    container = the container object to spawn the item in.
    itemType = the name of the gun or magazine (without the ORGM. prefix)
    ammoType = the bullets to load into the gun (depending on lootType)
    spawnChance = the % chance to spawn the item.
    maxCount = the max number of items to spawn. A random # is chosen between 1 and maxCount
    isLoaded = controls if the gun/magazine is loaded with ammoType

]]
local SpawnReloadable = function(container, itemType, ammoType, spawnChance, maxCount, isLoaded)
    -- ZomboidGlobals.WeaponLootModifier
    -- 0.2 extremely rare, 0.6 rare, 1.0 normal, 2.0 common, 4 abundant
    if Rnd(100) > math.ceil(spawnChance*ZomboidGlobals.WeaponLootModifier) then return end
    -- TODO: readd code that sets the weapon's condition
    local count = Rnd(maxCount)
    
    for i=1, count do
        local item = container:AddItems('ORGM.' .. itemType, 1)

        for i=0, item:size()-1 do
            local additem = item:get(i)
            ReloadUtil:syncItemToReloadable(additem, getPlayer()) -- seems this can cause a exception at times 
            -- like resetting the world while a player is in a place that spawns guns ie: gunstore.
            -- this is due to ISReloadUtil:getReloadableForPlayer() not having the required setup
            local data = additem:getModData()
            local maxammo = data.maxCapacity
            local fill = 0

            if data.roundChambered ~= nil then
                maxammo = maxammo + 1
            end
            
            if isLoaded then
                if Rnd(10) >= 3 then fill = Rnd(maxammo) end
            end
            
            if fill > 0 then
                if data.roundChambered ~= nil then
                    data.roundChambered = 1
                    data.lastRound = ammoType
                    fill = fill - 1
                end
                
                for i=1, fill do
                    data.magazineData[i] = ammoType
                end
                data.currentCapacity = fill
                data.loadedAmmo = ammoType
            end
            if WeaponUpgrades[additem:getType()] then
                ItemPicker.doWeaponUpgrade(additem)
            end
        end
    end
end


--[[ SpawnMags(container, gunType, ammoType, spawnChance, maxCount, lootType)
    
    A wrapper function for SpawnReloadable(), spawning magazines for the gun specified by gunType
    
    For a list of arguments, see SpawnReloadable()

]]
local SpawnMags = function(container, gunType, ammoType, spawnChance, maxCount, lootType)
    --if ReloadManager[1]:getDifficulty() >= 2 then -- has mags

    local weaponData = ORGMMasterWeaponTable[gunType]
    local magType = weaponData.data.ammoType
    if ORGMMasterMagTable[magType] == nil then -- gun doesnt use mags
        return
    end
    -- TODO: check for speedloaders
    
    SpawnReloadable(container, magType, ammoType, spawnChance, maxCount, lootType)
    --end
end


--[[ SpawnItem(container, itemType, spawnChance, maxCount)

    Spawns a basic ORGM item (ie: ammo or repair stuff)
    
    container = the container object to spawn the item in.
    itemType = the name of the item (without the ORGM. prefix)
    spawnChance = the % chance to spawn the item.
    maxCount = the max number of items to spawn. A random # is chosen between 1 and maxCount

]]
local SpawnItem = function(container, itemType, spawnChance, maxCount)
    if Rnd(100) > math.ceil(spawnChance*ZomboidGlobals.WeaponLootModifier) then return end
    local count = Rnd(maxCount)
    for i=1, count do
        container:AddItem('ORGM.' .. itemType)
    end
end


--[[ SelectGun(civilian, police, military)
    
    Chooses a gun from the WeaponsTable and appropriate ammo type.

    civilian = the chance of using the civilian table (int weight value)
    police = the chance of using the police table (int weight value)
    military = the chance of using the military table (int weight value)
    
    returns a table with 2 keys: .gun and .ammo

]]
local SelectGun = function(civilian, police, military)
    -----------------------
    -- select the table
    local roll = Rnd(civilian + police + military)
    local gunTbl = nil
    if roll <= civilian then -- civ
        gunTbl = WeaponsTable.Civilian
    elseif roll <= civilian + police then -- police
        gunTbl = WeaponsTable.Police
    else  -- military
        gunTbl = WeaponsTable.Military
    end
    
    -----------------------
    -- select the rarity
    roll = Rnd(100)
    local rarity = "Common"
    if roll < 80 then -- common
        rarity = "Common"
    elseif roll < 96 and #gunTbl.Rare > 0 then
        rarity = "Rare"
    elseif #gunTbl.VeryRare > 0 then
        rarity = "VeryRare"
    end
    gunTbl = gunTbl[rarity]

    local gunType = gunTbl[Rnd(#gunTbl)] -- randomly pick a gun

    local weaponData = ORGMMasterWeaponTable[gunType]
    local ammoType = weaponData.data.ammoType
    if ORGMMasterMagTable[ammoType] then -- ammoType is a mag, get its default ammo
        ammoType = ORGMMasterMagTable[ammoType].data.ammoType
    end
    
    local altTable = ORGMAlternateAmmoTable[ammoType]
    if Rnd(100) > 50 then
        ammoType = altTable[Rnd(#altTable)]
    else 
        ammoType = altTable[1]
    end

    return {gun = gunType, ammo = ammoType}
end


--[[ AddToCorpse(container)
    
    Function called when spawning items on corpses.
    
]]
local AddToCorpse = function(container)
    local choice = SelectGun(80, 14, 6)
    SpawnReloadable(container, choice.gun, choice.ammo, 3, 1, true) -- has gun
    SpawnMags(container, choice.gun, choice.ammo, 1, 3, true) -- has mags
    SpawnItem(container, choice.ammo, 3, 15) -- loose shells
    SpawnItem(container, choice.ammo .. "_Box", 1, 1) -- has box
end


--[[ AddToCivRoom(container)

    Adds a gun to a civilian room: bedrooms, gas stations, etc.

]]
local AddToCivRoom = function(container)
    local choice = SelectGun(80, 14, 6)
    SpawnReloadable(container, choice.gun, choice.ammo, 3, 1, true) -- has gun
    SpawnMags(container, choice.gun, choice.ammo, 1, 1, true) -- has mags
    SpawnItem(container, choice.ammo, 2, 29) -- loose shells
    SpawnItem(container, choice.ammo .. "_Box", 1, 1) -- has box
    SpawnItem(container, AllModsTable[Rnd(#AllModsTable)], 1, 1) -- has a mod
    SpawnItem(container, RepairTable[Rnd(#RepairTable)], 1, 1) -- has repair stuff
end


local SpawnRandomBox = function(container, spawnChance)
    if Rnd(100) > math.ceil(spawnChance*ZomboidGlobals.WeaponLootModifier) then return end
    container:AddItem('ORGM.' .. AllRoundsTable[Rnd(#AllRoundsTable)] ..'_Box')
end


local SpawnRandomCan = function(container, spawnChance)
    if Rnd(100) > math.ceil(spawnChance*ZomboidGlobals.WeaponLootModifier) then return end
    container:AddItem('ORGM.' .. AllRoundsTable[Rnd(#AllRoundsTable)] ..'_Can')
end

-----------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------

--[[

]]
Events.OnFillContainer.Add(function(roomName, containerType, container)
    if roomName == "all" and containerType == "inventorymale" then
        AddToCorpse(container)
    elseif roomName == "all" and containerType == "inventoryfemale" then
        AddToCorpse(container)
    elseif roomName == "bedroom" and containerType == "wardrobe" then
        AddToCivRoom(container)
    elseif roomName == "zippeestore" and containerType == "counter" then
        AddToCivRoom(container)
    elseif roomName == "fossoil" and containerType == "counter" then
        AddToCivRoom(container)
    elseif roomName == "gasstore" and containerType == "counter" then
        AddToCivRoom(container)
    elseif roomName == "bar" and containerType == "counter" then
        AddToCivRoom(container)
    elseif roomName == "policestorage" then
        local count = Rnd(3)
        while count ~= 0 do
            local choice = SelectGun(0, 70, 30)
            SpawnReloadable(container, choice.gun, choice.ammo, 60, 1, false)
            SpawnMags(container, choice.gun, choice.ammo, 80, 2, false)

            SpawnItem(container, choice.ammo .. "_Box", 80, 4)
            SpawnItem(container, choice.ammo .. "_Can", 20, 1)
            SpawnItem(container, AllModsTable[Rnd(#AllModsTable)], 30, 2)
            SpawnItem(container, RepairTable[Rnd(#RepairTable)], 40, 2)
            if Rnd(10) > 4 then count = count -1 end
        end
    elseif roomName == "gunstore" then
        if containerType == "locker" then
            SpawnRandomBox(container, 70)
            SpawnRandomBox(container, 60)
            SpawnRandomBox(container, 50)
            SpawnRandomBox(container, 40)
            SpawnRandomBox(container, 30)
            SpawnRandomCan(container, 10)
            SpawnRandomCan(container, 5)
            SpawnItem(container, RepairTable[Rnd(#RepairTable)], 20, 2)
            
        elseif containerType == "counter" then
            SpawnRandomBox(container, 70)
            SpawnRandomBox(container, 60)
            SpawnRandomBox(container, 50)
            SpawnRandomBox(container, 40)
            SpawnRandomBox(container, 30)
            SpawnRandomCan(container, 10)
            SpawnRandomCan(container, 5)
            SpawnItem(container, RepairTable[Rnd(#RepairTable)], 20, 2)
            
        elseif containerType == "displaycase" or containerType == "metal_shelves" then
            local choice = SelectGun(85, 10, 5)
            SpawnReloadable(container, choice.gun, choice.ammo, 60, 1, false)
            SpawnMags(container, choice.gun, choice.ammo, 40, 2, false)
            choice = SelectGun(85, 10, 5)
            SpawnReloadable(container, choice.gun, choice.ammo, 40, 1, false)
            SpawnMags(container, choice.gun, choice.ammo, 30, 2, false)
            SpawnItem(container, AllModsTable[Rnd(#AllModsTable)], 40, 2)
            SpawnItem(container, RepairTable[Rnd(#RepairTable)], 30, 2)
        end
    elseif roomName == "gunstorestorage" then --and containerType == "metal_shelves" then
        local choice = SelectGun(85, 10, 5)
        SpawnReloadable(container, choice.gun, choice.ammo, 60, 1, false)
        SpawnMags(container, choice.gun, choice.ammo, 40, 2, false)
        choice = SelectGun(85, 10, 5)
        SpawnReloadable(container, choice.gun, choice.ammo, 40, 1, false)
        SpawnMags(container, choice.gun, choice.ammo, 30, 2, false)
        SpawnItem(container, AllModsTable[Rnd(#AllModsTable)], 40, 2)
        SpawnItem(container, RepairTable[Rnd(#RepairTable)], 30, 2)

        SpawnRandomBox(container, 70)
        SpawnRandomBox(container, 60)
        SpawnRandomBox(container, 50)
        SpawnRandomBox(container, 40)
        SpawnRandomBox(container, 30)
        SpawnRandomCan(container, 10)
        SpawnRandomCan(container, 5)
        SpawnItem(container, RepairTable[Rnd(#RepairTable)], 20, 2)
    
    elseif roomName == "storageunit" and containerType == "crate" then
        local choice = SelectGun(85, 10, 5)
        SpawnReloadable(container, choice.gun, choice.ammo, 10, 1, false)
        SpawnMags(container, choice.gun, choice.ammo, 5, 3, false)
        choice = SelectGun(85, 10, 5)
        SpawnReloadable(container, choice.gun, choice.ammo, 10, 1, false)
        SpawnMags(container, choice.gun, choice.ammo, 5, 3, false)
        SpawnItem(container, AllModsTable[Rnd(#AllModsTable)], 5, 2)
        SpawnItem(container, AllModsTable[Rnd(#AllModsTable)], 2, 2)
        SpawnItem(container, RepairTable[Rnd(#RepairTable)], 10, 2)

        SpawnRandomBox(container, 70)
        SpawnRandomBox(container, 60)
        SpawnRandomBox(container, 50)
        SpawnRandomBox(container, 40)
        SpawnRandomBox(container, 30)
        SpawnRandomCan(container, 10)
        SpawnRandomCan(container, 5)
        SpawnItem(container, RepairTable[Rnd(#RepairTable)], 20, 2)

    elseif roomName == "garagestorage" and containerType == "smallbox" then
        local choice = SelectGun(85, 10, 5)
        SpawnReloadable(container, choice.gun, choice.ammo, 10, 1, false)
        SpawnMags(container, choice.gun, choice.ammo, 5, 3, false)
        choice = SelectGun(85, 10, 5)
        SpawnReloadable(container, choice.gun, choice.ammo, 10, 1, false)
        SpawnMags(container, choice.gun, choice.ammo, 5, 3, false)
        SpawnItem(container, AllModsTable[Rnd(#AllModsTable)], 5, 2)
        SpawnItem(container, AllModsTable[Rnd(#AllModsTable)], 2, 2)
        SpawnItem(container, RepairTable[Rnd(#RepairTable)], 10, 2)

        SpawnRandomBox(container, 70)
        SpawnRandomBox(container, 60)
        SpawnRandomBox(container, 50)
        SpawnRandomBox(container, 40)
        SpawnRandomBox(container, 30)
        SpawnRandomCan(container, 10)
        SpawnRandomCan(container, 5)
        SpawnItem(container, RepairTable[Rnd(#RepairTable)], 20, 2)

    elseif roomName == "hunting" and (containerType == "metal_shelves" or containerType == "locker") then
        local choice = SelectGun(85, 10, 5)
        SpawnReloadable(container, choice.gun, choice.ammo, 30, 1, false)
        SpawnMags(container, choice.gun, choice.ammo, 10, 3, false)
        choice = SelectGun(85, 10, 5)
        SpawnReloadable(container, choice.gun, choice.ammo, 20, 1, false)
        SpawnMags(container, choice.gun, choice.ammo, 8, 3, false)
        SpawnItem(container, AllModsTable[Rnd(#AllModsTable)], 15, 2)
        SpawnItem(container, AllModsTable[Rnd(#AllModsTable)], 2, 1)
        SpawnItem(container, RepairTable[Rnd(#RepairTable)], 20, 2)

        SpawnRandomBox(container, 70)
        SpawnRandomBox(container, 60)
        SpawnRandomBox(container, 50)
        SpawnRandomBox(container, 40)
        SpawnRandomBox(container, 30)
        SpawnRandomCan(container, 10)
        SpawnRandomCan(container, 5)
        SpawnItem(container, RepairTable[Rnd(#RepairTable)], 20, 2)

    end
end)

-----------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------
-- auto build all required tables
do
    
    local modItems = {}
    for _, modName in ipairs(AllModsTable) do
        modItems[modName] = InventoryItemFactory.CreateItem('ORGM.' .. modName)
    end
    for gunName, gunData in pairs(ORGMMasterWeaponTable) do
        -- build up the weapons table for spawning
        if gunData.isCivilian then
            if WeaponsTable.Civilian[gunData.isCivilian] ~= nil then table.insert(WeaponsTable.Civilian[gunData.isCivilian], gunName) end
            
        end
        if gunData.isPolice then
            if WeaponsTable.Police[gunData.isPolice] ~= nil then table.insert(WeaponsTable.Police[gunData.isPolice], gunName) end
            
        end
        if gunData.isMilitary then
            if WeaponsTable.Military[gunData.isMilitary] ~= nil then table.insert(WeaponsTable.Military[gunData.isMilitary], gunName) end
            
        end
        
        -- build the WeaponUpgrades table
        local gunItem = getScriptManager():FindItem('ORGM.' .. gunName)
        WeaponUpgrades[gunName] = {}
        for modName, modItem in pairs(modItems) do
            if modItem:getMountOn():contains(gunItem:getDisplayName()) then
                table.insert(WeaponUpgrades[gunName], 'ORGM.' .. modName)
                --print("Added Upgrade: " .. gunName .. " : " .. modName)
            end
        end

    end
    
    -- build the AllRoundsTable
    for ammoType, _ in pairs(ORGMAmmoStatsTable) do
        table.insert(AllRoundsTable, ammoType)
    end
end

