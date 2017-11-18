--[[ ORGMDistributions

    This file controls spawning of weapons and ammo.
    It is no longer necessary to edit this file when new guns or ammo are added to the mod.
    However, new upgrade parts still need to be added to the tables, as well as repair kits.
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
    TODO: this should actually be merged into the ORGMMasterWeaponTable then automatically built on load.
    I dislike having to define crap in multiple places.
    
]]
local WeaponsTable = {
    Civilian = {
        Common = {},
        Rare = {},
        VeryRare = {},
    },
    Police = {
        Common = {},
        Rare = {},
        VeryRare = {},
    },
    Military = { 
        Common = {},
        Rare = {},
        VeryRare = {},
    },
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

--[[ SpawnReloadable(container, itemType, ammoType, spawnChance, maxCount, lootType)

    Spawns a reloadable weapon or magazine.
    
    container = the container object to spawn the item in.
    itemType = the name of the gun or magazine (without the ORGM. prefix)
    ammoType = the bullets to load into the gun (depending on lootType)
    spawnChance = the % chance to spawn the item.
    maxCount = the max number of items to spawn. A random # is chosen between 1 and maxCount
    lootType = Generally the room or container the loot is spawning in. lootType controls if
        the gun/magazine is loaded with ammoType

]]
local SpawnReloadable = function(container, itemType, ammoType, spawnChance, maxCount, lootType)
    if Rnd(100) > spawnChance then return end
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
            
            if lootType == "Body" then
                if Rnd(10) >= 3 then fill = Rnd(maxammo) end
                
            elseif lootType == "House" then
                if Rnd(10) > 7 then fill = maxammo end
            
            elseif lootType == "Gas" then
                fill = maxammo
            
            elseif lootType == "Store" then
                fill = 0
            
            elseif lootType == "Police" then
                fill = 0
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
    if Rnd(100) > spawnChance then return end
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
    SpawnReloadable(container, choice.gun, choice.ammo, 100, 1, "Body") -- has gun
    SpawnMags(container, choice.gun, choice.ammo, 70, 3, "Body") -- has mags
    SpawnItem(container, choice.ammo, 100, 15) -- loose shells
    SpawnItem(container, choice.ammo .. "_Box", 10, 1) -- has box
end


--[[ AddToCivRoom(container)

    Adds a gun to a civilian room: bedrooms, gas stations, etc.

]]
local AddToCivRoom = function(container)
    local choice = SelectGun(80, 14, 6)
    SpawnReloadable(container, choice.gun, choice.ammo, 10, 1, "House") -- has gun
    SpawnMags(container, choice.gun, choice.ammo, 5, 1, "House") -- has mags
    SpawnItem(container, choice.ammo, 20, 29) -- loose shells
    SpawnItem(container, choice.ammo .. "_Box", 10, 1) -- has box
    SpawnItem(container, AllModsTable[Rnd(#AllModsTable)], 5, 1) -- has a mod
    SpawnItem(container, RepairTable[Rnd(#RepairTable)], 5, 1) -- has repair stuff
end


--[[ SpawnAmmoStorage(container)
    merged function for adding lots of ammo to a container.
]]
local SpawnAmmoStorage = function(container)
    if Rnd(20) >= 1 then container:AddItem('ORGM.' .. AllRoundsTable[Rnd(#AllRoundsTable)] ..'_Box') end
    if Rnd(20) >= 2 then container:AddItem('ORGM.' .. AllRoundsTable[Rnd(#AllRoundsTable)] ..'_Box') end
    if Rnd(20) >= 3 then container:AddItem('ORGM.' .. AllRoundsTable[Rnd(#AllRoundsTable)] ..'_Box') end
    if Rnd(20) >= 4 then container:AddItem('ORGM.' .. AllRoundsTable[Rnd(#AllRoundsTable)] ..'_Box') end
    if Rnd(20) >= 5 then container:AddItem('ORGM.' .. AllRoundsTable[Rnd(#AllRoundsTable)] ..'_Box') end
    if Rnd(20) >= 6 then container:AddItem('ORGM.' .. AllRoundsTable[Rnd(#AllRoundsTable)] ..'_Box') end
    if Rnd(20) >= 7 then container:AddItem('ORGM.' .. AllRoundsTable[Rnd(#AllRoundsTable)] ..'_Box') end
    if Rnd(20) >= 9 then container:AddItem('ORGM.' .. AllRoundsTable[Rnd(#AllRoundsTable)] ..'_Box') end
    if Rnd(20) >= 11 then container:AddItem('ORGM.' .. AllRoundsTable[Rnd(#AllRoundsTable)] ..'_Box') end
    if Rnd(20) >= 13 then container:AddItem('ORGM.' .. AllRoundsTable[Rnd(#AllRoundsTable)] ..'_Box') end
    if Rnd(20) >= 15 then container:AddItem('ORGM.' .. AllRoundsTable[Rnd(#AllRoundsTable)] ..'_Box') end
    if Rnd(20) >= 17 then container:AddItem('ORGM.' .. AllRoundsTable[Rnd(#AllRoundsTable)] ..'_Can') end
    if Rnd(20) >= 19 then container:AddItem('ORGM.' .. AllRoundsTable[Rnd(#AllRoundsTable)] ..'_Can') end
    if Rnd(4) >= 1 then container:AddItem(RepairTable[Rnd(#RepairTable)]) end
end


-----------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------
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


--[[

]]
Events.OnFillContainer.Add(function(roomName, containerType, container)
    if roomName == "all" and containerType == "inventorymale" then
        if Rnd(100) <= 2 then AddToCorpse(container) end -- 2% chance of a gun + ammo
    elseif roomName == "all" and containerType == "inventoryfemale" then
        if Rnd(100) <= 2 then AddToCorpse(container)  end -- 2% chance of a gun + ammo
    elseif roomName == "bedroom" and containerType == "wardrobe" then
        if Rnd(100) <= 30 then AddToCivRoom(container) end -- 30% chance to call the function. Note the function also has its own % chances to spawn each item
    elseif roomName == "zippeestore" and containerType == "counter" then
        if Rnd(100) <= 10 then AddToCivRoom(container) end -- 10% chance to call the function. Note the function also has its own % chances to spawn each item
    elseif roomName == "fossoil" and containerType == "counter" then
        if Rnd(100) <= 10 then AddToCivRoom(container) end -- 10% chance to call the function. Note the function also has its own % chances to spawn each item
    elseif roomName == "gasstore" and containerType == "counter" then
        if Rnd(100) <= 10 then AddToCivRoom(container) end -- 10% chance to call the function. Note the function also has its own % chances to spawn each item
    elseif roomName == "bar" and containerType == "counter" then
        if Rnd(100) <= 15 then AddToCivRoom(container) end -- 10% chance to call the function. Note the function also has its own % chances to spawn each item
    elseif roomName == "policestorage" then
        local count = Rnd(3)
        while count ~= 0 do
            local choice = SelectGun(0, 70, 30)
            SpawnReloadable(container, choice.gun, choice.ammo, 60, 1, "Police")
            SpawnMags(container, choice.gun, choice.ammo, 80, 2, "Police") -- has mags

            SpawnItem(container, choice.ammo .. "_Box", 80, 4) -- has box
            SpawnItem(container, choice.ammo .. "_Can", 20, 1)
            SpawnItem(container, AllModsTable[Rnd(#AllModsTable)], 30, 2)
            SpawnItem(container, RepairTable[Rnd(#RepairTable)], 40, 2)
            if Rnd(10) > 5 then count = count -1 end
        end
    elseif roomName == "gunstore" then
        if containerType == "locker" then
            SpawnAmmoStorage(container)
            
        elseif containerType == "counter" then
            SpawnAmmoStorage(container)
            
        elseif containerType == "displaycase" then
            if Rnd(100) <= 95 then
                local choice = SelectGun(85, 10, 5)
                SpawnReloadable(container, choice.gun, choice.ammo, 100, 2, "Store")
                SpawnMags(container, choice.gun, choice.ammo, 80, 2, "Store") -- has mags
            end
            if Rnd(100) <= 75 then
                local choice = SelectGun(85, 10, 5)
                SpawnReloadable(container, choice.gun, choice.ammo, 100, 1, "Store")
                SpawnMags(container, choice.gun, choice.ammo, 80, 2, "Store") -- has mags
            end
            SpawnItem(container, AllModsTable[Rnd(#AllModsTable)], 90, 2)
            SpawnItem(container, RepairTable[Rnd(#RepairTable)], 20, 2)
        end
    elseif roomName == "gunstorestorage" then --and containerType == "metal_shelves" then
        if Rnd(100) <= 95 then
            local choice = SelectGun(85, 10, 5)
            SpawnReloadable(container, choice.gun, choice.ammo, 100, 1, "Store")
            SpawnMags(container, choice.gun, choice.ammo, 80, 2, "Store") -- has mags
        end
        if Rnd(100) <= 75 then
            local choice = SelectGun(85, 10, 5)
            SpawnReloadable(container, choice.gun, choice.ammo, 100, 1, "Store")
            SpawnMags(container, choice.gun, choice.ammo, 80, 2, "Store") -- has mags
        end
        SpawnItem(container, AllModsTable[Rnd(#AllModsTable)], 90, 2)
        SpawnItem(container, RepairTable[Rnd(#RepairTable)], 20, 2)

        SpawnAmmoStorage(container)
    elseif roomName == "storageunit" and containerType == "crate" then
        if Rnd(100) <= 15 then
            if Rnd(100) <= 95 then
                local choice = SelectGun(85, 10, 5)
                SpawnReloadable(container, choice.gun, choice.ammo, 100, 1, "Store")
                SpawnMags(container, choice.gun, choice.ammo, 80, 3, "Store") -- has mags
            end
            if Rnd(100) <= 50 then
                local choice = SelectGun(85, 10, 5)
                SpawnReloadable(container, choice.gun, choice.ammo, 100, 1, "Store")
                SpawnMags(container, choice.gun, choice.ammo, 80, 3, "Store") -- has mags
            end
            SpawnItem(container, AllModsTable[Rnd(#AllModsTable)], 90, 2)
            SpawnItem(container, AllModsTable[Rnd(#AllModsTable)], 20, 1)
            SpawnItem(container, RepairTable[Rnd(#RepairTable)], 20, 1)

            SpawnAmmoStorage(container)
        end
    elseif roomName == "garagestorage" and containerType == "smallbox" then
        if Rnd(100) <= 15 then
            if Rnd(100) <= 95 then
                local choice = SelectGun(85, 10, 5)
                SpawnReloadable(container, choice.gun, choice.ammo, 100, 1, "Store")
                SpawnMags(container, choice.gun, choice.ammo, 80, 2, "Store") -- has mags
            end
            if Rnd(100) <= 50 then
                local choice = SelectGun(85, 10, 5)
                SpawnReloadable(container, choice.gun, choice.ammo, 100, 1, "Store")
                SpawnMags(container, choice.gun, choice.ammo, 80, 2, "Store") -- has mags
            end
            SpawnItem(container, AllModsTable[Rnd(#AllModsTable)], 90, 2)
            SpawnItem(container, AllModsTable[Rnd(#AllModsTable)], 20, 1)
            SpawnItem(container, RepairTable[Rnd(#RepairTable)], 20, 1)

            SpawnAmmoStorage(container)
        end

    elseif roomName == "hunting" and containerType == "metal_shelves" then
        if Rnd(100) <= 65 then
            if Rnd(100) <= 95 then
                local choice = SelectGun(85, 10, 5)
                SpawnReloadable(container, choice.gun, choice.ammo, 100, 1, "Store")
                SpawnMags(container, choice.gun, choice.ammo, 80, 2, "Store") -- has mags
            end
            if Rnd(100) <= 75 then
                local choice = SelectGun(85, 10, 5)
                SpawnReloadable(container, choice.gun, choice.ammo, 100, 1, "Store")
                SpawnMags(container, choice.gun, choice.ammo, 80, 2, "Store") -- has mags
            end
            SpawnItem(container, AllModsTable[Rnd(#AllModsTable)], 90, 2)
            SpawnItem(container, AllModsTable[Rnd(#AllModsTable)], 20, 1)
            SpawnItem(container, RepairTable[Rnd(#RepairTable)], 20, 1)

            SpawnAmmoStorage(container)
        end
    end
end
)
