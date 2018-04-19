--[[ ORGMDistributions

    This file controls spawning of weapons and ammo.

]]


local Server = ORGM.Server
local Settings = ORGM.Settings
--[[ AllRoundsTable

    A list of all rounds to use when spawning random ammo
    This table is automatically built on startup from ORGM.AmmoTable
]]
local AllRoundsTable = { }
local AllRepairKitsTable = { }
local AllComponentsTable = { } 

Server.ReplacementsTable = { -- testing stuff
    ["Base.Pistol"] = "ORGM.Beretta92",
    ["Base.Shotgun"] = "ORGM.Rem870",
    ["Base.Sawnoff"] = "ORGM.Rem870SO",
    ["Base.VarmintRifle"] = "ORGM.Mini14",
    ["Base.HuntingRifle"] = "ORGM.LENo4",
    ["Base.Bullets9mm"] = "ORGM.Ammo_9x19mm_FMJ",
    ["Base.ShotgunShells"] = "ORGM.Ammo_12g_00Buck",
    ["Base.223Bullets"] = "ORGM.Ammo_223Remington_FMJ",
    ["Base.308Bullets"] = "ORGM.Ammo_308Winchester_FMJ",
    ["Base.BulletsBox"] = "ORGM.Ammo_9x19mm_FMJ_Box",
    ["Base.ShotgunShellsBox"] = "ORGM.Ammo_12g_00Buck_Box",
    ["Base.223Box"] = "ORGM.Ammo_223Remington_FMJ_Box",
    ["Base.308Box"] = "ORGM.Ammo_308Winchester_FMJ_Box",
    ["Base.HuntingRifleExtraClip"] = "ORGM.LENo4Mag",
    ["Base.IronSight"] = "ORGM.FibSig",
    ["Base.x2Scope"] = "ORGM.2xScope",
    ["Base.x4Scope"] = "ORGM.4xScope",
    ["Base.x8Scope"] = "ORGM.8xScope",
    ["Base.AmmoStraps"] = "ORGM.Rifsling",
    ["Base.Sling"] = "ORGM.Rifsling",
    ["Base.FiberglassStock"] = "ORGM.CollapsingStock",
    ["Base.RecoilPad"] = "ORGM.Recoil",
    ["Base.Laser"] = "ORGM.PistolLas",
    ["Base.RedDot"] = "ORGM.RDS",
    ["Base.ChokeTubeFull"] = "ORGM.FullCh",
    ["Base.ChokeTubeImproved"] = "ORGM.HalfCh",
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

Server.generateSerialNumber = function(item)
    local sn = {}
    for i=1, 6 do
        sn[i] = tostring(ZombRand(10))
    end
    item:getModData().serialnumber = table.concat(sn, '')
end


Server.doWeaponUpgrade = function(item)
    local upgradeList = WeaponUpgrades[item:getType()]
    local randUpgrade = ZombRand(#upgradeList)
    for i=1,randUpgrade do
        -- TODO: this needs to check civ/police/military
        local upgrade = WeaponUpgrades[item:getType()][ZombRand(#upgradeList) + 1]
        local part = InventoryItemFactory.CreateItem(upgrade)
        if ZombRandFloat(0,100) <= 100*Settings.ComponentSpawnModifier then
            part:getModData().BUILD_ID = ORGM.BUILD_ID
            item:attachWeaponPart(part)
        end
    end
end


--[[ Server.spawnReloadable(container, itemType, ammoType, spawnChance, maxCount, isLoaded)

    Spawns a reloadable weapon or magazine.  It called by Server.spawnFirearm and Server.spawnMagazine.
    
    container is a ItemContainer object.
    itemType is the name of the gun or magazine (without the ORGM. prefix)
    ammoType is the bullets to load into the gun if isLoaded = true. (A key from ORGM.AmmoTable)
    spawnChance is the % chance to spawn the item.
    maxCount is the max number of items to spawn. A random # is chosen between 1 and maxCount
    isLoaded is true/false. controls if the gun/magazine is loaded with ammoType

    returns false if nothing is spawned, true if the reloadable spawned

]]
Server.spawnReloadable = function(container, itemType, ammoType, spawnChance, maxCount, isLoaded)
    -- ZomboidGlobals.WeaponLootModifier
    -- 0.2 extremely rare, 0.6 rare, 1.0 normal, 2.0 common, 4 abundant
    --ORGM.log(ORGM.DEBUG, "Server.spawnReloadable called for " .. itemType .. " with " .. spawnChance .. "% chance.")
    local roll = ZombRandFloat(0,100)
    --if Rnd(100) > math.ceil(spawnChance) then return false end
    ORGM.log(ORGM.DEBUG, "Server.spawnReloadable for " .. itemType .. ": " ..roll.. " roll vs ".. spawnChance .. "% chance.")
    
    if roll > spawnChance*ORGM.NVAL then return false end
    local count = Rnd(maxCount)
    
    local itemOrgmData = nil
    local isFirearm = ORGM.isFirearm(itemType)
    --ORGM.log(ORGM.DEBUG, "Server.spawnReloadable isFireaarm:"..tostring(isFirearm))
    --isFirearm = ORGM.getFirearmData(itemType)
    --ORGM.log(ORGM.DEBUG, "Server.spawnReloadable isFireaarm (from data):"..tostring(isFirearm and true))
    if isFirearm then
        itemOrgmData = ORGM.getFirearmData(itemType)
    elseif ORGM.isMagazine(itemType) then
        itemOrgmData = ORGM.getMagazineData(itemType)
    else
        ORGM.log(ORGM.ERROR, "Tried to spawn reloadable " .. itemType .. " but item is not a registered firearm or magazine.")
        return nil
    end

    
    for i=1, count do
        local additem = ItemPicker.tryAddItemToContainer(container, itemOrgmData.moduleName .. '.' .. itemType)
        if not additem then return false end
        ORGM.log(ORGM.DEBUG, "Spawned " .. itemOrgmData.moduleName .. '.' .. itemType)
        if isFirearm then
            ORGM.setupGun(ReloadUtil:getWeaponData(itemType), additem)
            Server.generateSerialNumber(additem)
            if isLoaded then additem:setCondition(Rnd(additem:getConditionMax())) end
        else
            ORGM.setupMagazine(ReloadUtil:getClipData(itemType), additem)
        end
        local data = additem:getModData()
        local maxammo = data.maxCapacity
        local fill = 0

        if data.roundChambered ~= nil then
            maxammo = maxammo + 1
        end
        
        if isLoaded then
            if Rnd(100) >= 30*Settings.AmmoSpawnModifier then fill = Rnd(maxammo) end 
        end
        
        if fill > 0 then
            if data.roundChambered ~= nil then
                data.roundChambered = 1
                data.lastRound = ammoType
                fill = fill - 1
                if itemOrgmData.triggerType ~= ORGM.DOUBLEACTIONONLY then data.hammerCocked = 1 end
            end
            
            for i=1, fill do
                data.magazineData[i] = ammoType
            end
            data.currentCapacity = fill
            data.loadedAmmo = ammoType
        end
        if WeaponUpgrades[additem:getType()] then
            Server.doWeaponUpgrade(additem)
        end

    end
    return true
end


--[[ Server.spawnFirearm(container, gunType, ammoType, spawnChance, maxCount, isLoaded)
    
    A wrapper function for Server.spawnReloadable()

    container is a ItemContainer object.
    gunType is the name of the gun to spawn magazines for (without the ORGM. prefix)
    ammoType is the bullets to load into the gun if isLoaded = true. (A key from ORGM.AmmoTable)
    spawnChance is the % chance to spawn the item.
    maxCount is the max number of items to spawn. A random # is chosen between 1 and maxCount
    isLoaded is true/false. controls if the gun/magazine is loaded with ammoType

    returns nil
    
]]
Server.spawnFirearm = function(container, gunType, ammoType, spawnChance, maxCount, isLoaded)
    spawnChance = spawnChance * ZomboidGlobals.WeaponLootModifier * Settings.FirearmSpawnModifier
    Server.spawnReloadable(container, gunType, ammoType, spawnChance, maxCount, isLoaded)
end


--[[ Server.spawnMagazine(container, gunType, ammoType, spawnChance, maxCount, isLoaded)
    
    A wrapper function for Server.spawnReloadable(), spawning magazines for the gun specified by gunType

    container is a ItemContainer object.
    gunType is the name of the gun to spawn magazines for (without the ORGM. prefix)
    ammoType is the bullets to load into the gun if isLoaded = true. (A key from ORGM.AmmoTable)
    spawnChance is the % chance to spawn the item.
    maxCount is the max number of items to spawn. A random # is chosen between 1 and maxCount
    isLoaded is true/false. controls if the gun/magazine is loaded with ammoType

    returns nil
    
]]
Server.spawnMagazine = function(container, gunType, ammoType, spawnChance, maxCount, isLoaded)
    spawnChance = spawnChance * ZomboidGlobals.WeaponLootModifier * Settings.MagazineSpawnModifier
    local weaponData = ORGM.getFirearmData(gunType)
    local magType = weaponData.ammoType
    if ORGM.isMagazine(magType) then -- gun uses mags
        Server.spawnReloadable(container, magType, ammoType, spawnChance, maxCount, isLoaded)
    end
    
    local magType = weaponData.speedLoader
    if ORGM.isMagazine(magType) then -- gun uses speedloaders
        Server.spawnReloadable(container, magType, ammoType, spawnChance, maxCount, isLoaded)
    end
    
end


--[[ Server.spawnItem(container, itemType, spawnChance, maxCount)

    Generic spawn function for non-reloadable items (ie: ammo or repair stuff).
    
    container is a ItemContainer object.
    itemType is the name of the item (WITH the module prefix)
    spawnChance is the % chance to spawn the item.
    maxCount is the max number of items to spawn. A random # is chosen between 1 and maxCount
    
    returns table of spawned items

]]
Server.spawnItem = function(container, itemType, spawnChance, maxCount)
    local roll = ZombRandFloat(0,100)
    ORGM.log(ORGM.DEBUG, "Server.spawnItem for " .. itemType .. ": " ..roll.. " roll vs ".. spawnChance .. "% chance.")
    local result = {}
    if roll > spawnChance*ORGM.NVAL then return result end
    local count = Rnd(maxCount)
    for i=1, count do
        local item = ItemPicker.tryAddItemToContainer(container, itemType)
        if not item then break end
        table.insert(result, item)
    end
    return result
end


Server.spawnAmmo = function(container, ammoType, spawnChance, maxCount)
    spawnChance = spawnChance * ZomboidGlobals.WeaponLootModifier * Settings.AmmoSpawnModifier
    Server.spawnItem(container, ORGM.getAmmoData(ammoType).moduleName .. '.' .. ammoType, spawnChance, maxCount)
end

Server.spawnAmmoBox = function(container, ammoType, spawnChance, maxCount)
    spawnChance = spawnChance * ZomboidGlobals.WeaponLootModifier * Settings.AmmoSpawnModifier
    Server.spawnItem(container, ORGM.getAmmoData(ammoType).moduleName .. '.' .. ammoType .. '_Box', spawnChance, maxCount)
end

Server.spawnAmmoCan = function(container, ammoType, spawnChance, maxCount)
    spawnChance = spawnChance * ZomboidGlobals.WeaponLootModifier * Settings.AmmoSpawnModifier
    Server.spawnItem(container, ORGM.getAmmoData(ammoType).moduleName .. '.' .. ammoType .. '_Can', spawnChance, maxCount)
end


--[[ Server.spawnRandomBox(container, spawnChance)

    Spawns a random box of ammo

    container is a ItemContainer object.
    spawnChance is the % chance to spawn the item.

    returns nil

]]
Server.spawnRandomBox = function(container, spawnChance, maxCount)
    Server.spawnAmmoBox(container, AllRoundsTable[Rnd(#AllRoundsTable)], spawnChance, maxCount)
end


--[[ Server.spawnRandomCan(container, spawnChance)

    Spawns a random can of ammo

    container is a ItemContainer object.
    spawnChance is the % chance to spawn the item.

    returns nil

]]
Server.spawnRandomCan = function(container, spawnChance, maxCount)
    Server.spawnAmmoCan(container, AllRoundsTable[Rnd(#AllRoundsTable)], spawnChance, maxCount)
end

Server.spawnRepairKit = function(container, spawnChance, maxCount)
    spawnChance = spawnChance * ZomboidGlobals.WeaponLootModifier * Settings.RepairKitSpawnModifier
    local choice = AllRepairKitsTable[Rnd(#AllRepairKitsTable)]
    Server.spawnItem(container, ORGM.RepairKitTable[choice].moduleName .. '.' .. choice, spawnChance, maxCount)
end

Server.spawnFirearmPart = function(container, spawnChance, maxCount)
    spawnChance = spawnChance * ZomboidGlobals.WeaponLootModifier * Settings.ComponentSpawnModifier
    local choice = AllComponentsTable[Rnd(#AllComponentsTable)]
    local result = Server.spawnItem(container, ORGM.getComponentData(choice).moduleName .. '.' .. choice, spawnChance, maxCount)
    for _, item in ipairs(result) do
        item:getModData().BUILD_ID = ORGM.BUILD_ID
    end
end

--[[ Server.selectFirearm(civilian, police, military)
    
    Chooses a gun from the ORGM.FirearmRarityTable and appropriate ammo type.

    civilian is the chance of using the civilian table (int weight value)
    police is the chance of using the police table (int weight value)
    military is the chance of using the military table (int weight value)
    
    returns a table with 2 keys: .gun and .ammo

]]
Server.selectFirearm = function(civilian, police, military)
    -----------------------
    -- select the table
    civilian = civilian * Settings.CivilianFirearmSpawnModifier
    police = police * Settings.PoliceFirearmSpawnModifier
    military = military * Settings.MilitaryFirearmSpawnModifier
    local roll = Rnd(civilian + police + military)
    local gunTbl = nil
    if roll <= civilian then -- civ
        gunTbl = ORGM.FirearmRarityTable.Civilian
        ORGM.log(ORGM.DEBUG, "Selecting firearm from civilian table")
    elseif roll <= civilian + police then -- police
        gunTbl = ORGM.FirearmRarityTable.Police
        ORGM.log(ORGM.DEBUG, "Selecting firearm from police table")
    else  -- military
        gunTbl = ORGM.FirearmRarityTable.Military
        ORGM.log(ORGM.DEBUG, "Selecting firearm from military table")
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
    ORGM.log(ORGM.DEBUG, "Selecting " .. rarity .." firearm")
    gunTbl = gunTbl[rarity]
    
    local gunType = gunTbl[Rnd(#gunTbl)] -- randomly pick a gun
    ORGM.log(ORGM.DEBUG, "Selected " .. tostring(gunType))

    local weaponData = ORGM.getFirearmData(gunType)
    
    --print("spawning="..gunType)
    local ammoType = weaponData.ammoType
    if ORGM.isMagazine(ammoType) then -- ammoType is a mag, get its default ammo
        ammoType = ORGM.getMagazineData(ammoType).ammoType
    end
    
    local altTable = ORGM.getAmmoGroup(ammoType)
    if Rnd(100) > 50 then
        ammoType = altTable[Rnd(#altTable)]
    else 
        ammoType = altTable[1]
    end

    return {gun = gunType, ammo = ammoType}
end


--[[ Server.addToCorpse(container)
    
    Function called when spawning items on corpses.

    container is a ItemContainer object.

    returns nil

]]
Server.addToCorpse = function(container)
    local choice = Server.selectFirearm(80, 14, 6)
    Server.spawnFirearm(container, choice.gun, choice.ammo, 3*Settings.CorpseSpawnModifier, 1, true) -- has gun
    Server.spawnMagazine(container, choice.gun, choice.ammo, 1*Settings.CorpseSpawnModifier, 3, true) -- has mags
    Server.spawnAmmo(container, choice.ammo, 3*Settings.CorpseSpawnModifier, 15) -- loose shells
    Server.spawnAmmoBox(container, choice.ammo, 1*Settings.CorpseSpawnModifier, 1) -- has box
end


--[[ Server.addToCivRoom(container)

    Adds a gun to a civilian room: bedrooms, gas stations, etc.

    container is a ItemContainer object.

    returns nil

]]
Server.addToCivRoom = function(container)
    local choice = Server.selectFirearm(80, 14, 6)
    Server.spawnFirearm(container, choice.gun, choice.ammo, 3*Settings.CivilianBuildingSpawnModifier, 1, true) -- has gun
    Server.spawnMagazine(container, choice.gun, choice.ammo, 1*Settings.CivilianBuildingSpawnModifier, 1, true) -- has mags
    Server.spawnAmmo(container, choice.ammo, 2*Settings.CivilianBuildingSpawnModifier, 29) -- loose shells
    Server.spawnAmmoBox(container, choice.ammo, 1*Settings.CivilianBuildingSpawnModifier, 1) -- has box
    Server.spawnFirearmPart(container, 1*Settings.CivilianBuildingSpawnModifier, 1) -- has a mod
    Server.spawnRepairKit(container, 1*Settings.CivilianBuildingSpawnModifier, 1) -- has repair stuff
end



-----------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------

--[[ onFillContainer.Add

    Called when filling a container with loot. Controls the spawn chances.
    
]]

Server.onFillContainer = function(roomName, containerType, container)
    -- pull functions into local namespace
    ORGM.log(ORGM.DEBUG, "Checking spawns for "..tostring(roomName) ..", ".. tostring(containerType))
    local addToCorpse = Server.addToCorpse
    local addToCivRoom = Server.addToCivRoom
    local spawnFirearm = Server.spawnFirearm
    local spawnMagazine = Server.spawnMagazine
    local spawnAmmoBox = Server.spawnAmmoBox
    local spawnAmmoCan = Server.spawnAmmoCan
    local spawnRandomBox = Server.spawnRandomBox
    local spawnRandomCan = Server.spawnRandomCan
    local spawnFirearmPart = Server.spawnFirearmPart
    local spawnRepairKit = Server.spawnRepairKit
    
    -- find and remove any default base weapons, ie: stash handling
    -- damnit...not didnt work for removing stashes...
    --[[
    if ORGM.Settings.RemoveBaseFirearms then 
        for key, value in pairs(Server.ReplacementsTable) do
            local count = container:FindAll(key):size()
            if count > 0 then
                container:RemoveAll(key)
                container:AddItems(value, count)
            end
        end    
    end
    ]]
    
    -- room control
    if roomName == "all" and containerType == "inventorymale" then
        addToCorpse(container)
    elseif roomName == "all" and containerType == "inventoryfemale" then
        addToCorpse(container)
    elseif roomName == "bedroom" and containerType == "wardrobe" then
        addToCivRoom(container)
    elseif roomName == "zippeestore" and containerType == "counter" then
        addToCivRoom(container)
    elseif roomName == "fossoil" and containerType == "counter" then
        addToCivRoom(container)
    elseif roomName == "gasstore" and containerType == "counter" then
        addToCivRoom(container)
    elseif roomName == "bar" and containerType == "counter" then
        addToCivRoom(container)
    elseif roomName == "policestorage" then
        local mod = Settings.PoliceStorageSpawnModifier
        local count = Rnd(3)
        while count ~= 0 do
            local choice = Server.selectFirearm(0, 70*mod, 30)
            spawnFirearm(container, choice.gun, choice.ammo, 60*mod, 1, false)
            spawnMagazine(container, choice.gun, choice.ammo, 80*mod, 2, false)

            spawnAmmoBox(container, choice.ammo, 80*mod, 4)
            spawnAmmoCan(container, choice.ammo, 20*mod, 1)
            spawnFirearmPart(container, 30*mod, 2)
            spawnRepairKit(container, 40*mod, 2)
            if Rnd(10) > 4 then count = count -1 end
        end
    elseif roomName == "gunstore" then
        local mod = Settings.GunStoreSpawnModifier
        if containerType == "locker" then
            spawnRandomBox(container, 70*mod, 1)
            spawnRandomBox(container, 60*mod, 1)
            spawnRandomBox(container, 50*mod, 1)
            spawnRandomBox(container, 40*mod, 1)
            spawnRandomBox(container, 30*mod, 1)
            spawnRandomCan(container, 10*mod, 1)
            spawnRandomCan(container, 5*mod, 1)
            spawnRepairKit(container, 20*mod, 2)
            
        elseif containerType == "counter" then
            spawnRandomBox(container, 70*mod, 1)
            spawnRandomBox(container, 60*mod, 1)
            spawnRandomBox(container, 50*mod, 1)
            spawnRandomBox(container, 40*mod, 1)
            spawnRandomBox(container, 30*mod, 1)
            spawnRandomCan(container, 10*mod, 1)
            spawnRandomCan(container, 5*mod, 1)
            spawnRepairKit(container, 20*mod, 2)
            
        elseif containerType == "displaycase" or containerType == "metal_shelves" then
            local choice = Server.selectFirearm(85, 10, 5)
            spawnFirearm(container, choice.gun, choice.ammo, 60*mod, 1, false)
            spawnMagazine(container, choice.gun, choice.ammo, 40*mod, 2, false)
            choice = Server.selectFirearm(85, 10, 5)
            spawnFirearm(container, choice.gun, choice.ammo, 40*mod, 1, false)
            spawnMagazine(container, choice.gun, choice.ammo, 30*mod, 2, false)
            spawnFirearmPart(container, 40*mod, 2)
            spawnRepairKit(container, 30*mod, 2)
        end
    elseif roomName == "gunstorestorage" then --and containerType == "metal_shelves" then
        local mod = Settings.GunStoreSpawnModifier
        local choice = Server.selectFirearm(85, 10, 5)
        spawnFirearm(container, choice.gun, choice.ammo, 60*mod, 1, false)
        spawnMagazine(container, choice.gun, choice.ammo, 40*mod, 2, false)
        choice = Server.selectFirearm(85, 10, 5)
        spawnFirearm(container, choice.gun, choice.ammo, 40*mod, 1, false)
        spawnMagazine(container, choice.gun, choice.ammo, 30*mod, 2, false)
        spawnFirearmPart(container, 40*mod, 2)
        spawnRepairKit(container, 30*mod, 2)

        spawnRandomBox(container, 70*mod, 1)
        spawnRandomBox(container, 60*mod, 1)
        spawnRandomBox(container, 50*mod, 1)
        spawnRandomBox(container, 40*mod, 1)
        spawnRandomBox(container, 30*mod, 1)
        spawnRandomCan(container, 10*mod, 1)
        spawnRandomCan(container, 5*mod, 1)
        spawnRepairKit(container, 20*mod, 2)
    
    elseif roomName == "storageunit" and containerType == "crate" then
        local mod = Settings.StorageUnitSpawnModifier
        local choice = Server.selectFirearm(85, 10, 5)
        spawnFirearm(container, choice.gun, choice.ammo, 10*mod, 1, false)
        spawnMagazine(container, choice.gun, choice.ammo, 5*mod, 3, false)
        choice = Server.selectFirearm(85, 10, 5)
        spawnFirearm(container, choice.gun, choice.ammo, 10*mod, 1, false)
        spawnMagazine(container, choice.gun, choice.ammo, 5*mod, 3, false)
        spawnFirearmPart(container, 5*mod, 2)
        spawnFirearmPart(container, 2*mod, 2)
        spawnRepairKit(container, 10*mod, 2)

        if Rnd(100) <= 3 then
            spawnRandomBox(container, 70*mod, 1)
            spawnRandomBox(container, 60*mod, 1)
            spawnRandomBox(container, 50*mod, 1)
            spawnRandomBox(container, 40*mod, 1)
            spawnRandomBox(container, 30*mod, 1)
            spawnRandomCan(container, 10*mod, 1)
            spawnRandomCan(container, 5*mod, 1)
            spawnRepairKit(container, 20*mod, 2)
        end

    elseif roomName == "garagestorage" and containerType == "smallbox" then
        local mod = Settings.GarageSpawnModifier
        local choice = Server.selectFirearm(85, 10, 5)
        spawnFirearm(container, choice.gun, choice.ammo, 10*mod, 1, false)
        spawnMagazine(container, choice.gun, choice.ammo, 5*mod, 3, false)
        choice = Server.selectFirearm(85, 10, 5)
        spawnFirearm(container, choice.gun, choice.ammo, 10*mod, 1, false)
        spawnMagazine(container, choice.gun, choice.ammo, 5*mod, 3, false)
        spawnFirearmPart(container, 5*mod, 2)
        spawnFirearmPart(container, 2*mod, 2)
        spawnRepairKit(container, 10*mod, 2)

        if Rnd(100) <= 3 then
            spawnRandomBox(container, 70*mod, 1)
            spawnRandomBox(container, 60*mod, 1)
            spawnRandomBox(container, 50*mod, 1)
            spawnRandomBox(container, 40*mod, 1)
            spawnRandomBox(container, 30*mod, 1)
            spawnRandomCan(container, 10*mod, 1)
            spawnRandomCan(container, 5*mod, 1)
            spawnRepairKit(container, 20*mod, 2)
        end

    elseif roomName == "hunting" and (containerType == "metal_shelves" or containerType == "locker") then
        local mod = Settings.HuntingSpawnModifier
        local choice = Server.selectFirearm(85, 10, 5)
        spawnFirearm(container, choice.gun, choice.ammo, 30*mod, 1, false)
        spawnMagazine(container, choice.gun, choice.ammo, 10*mod, 3, false)
        
        choice = Server.selectFirearm(85, 10, 5)
        spawnFirearm(container, choice.gun, choice.ammo, 20*mod, 1, false)
        spawnMagazine(container, choice.gun, choice.ammo, 8*mod, 3, false)
        spawnFirearmPart(container, 15*mod, 2)
        spawnFirearmPart(container, 2*mod, 1)
        spawnRepairKit(container, 20*mod, 2)

        spawnRandomBox(container, 70*mod, 1)
        spawnRandomBox(container, 60*mod, 1)
        spawnRandomBox(container, 50*mod, 1)
        spawnRandomBox(container, 40*mod, 1)
        spawnRandomBox(container, 30*mod, 1)
        spawnRandomCan(container, 10*mod, 1)
        spawnRandomCan(container, 5*mod, 1)
        spawnRepairKit(container, 20*mod, 2)

    end
end



Server.insertIntoRarityTables = function(name, definition)
    if definition.isCivilian then
        if ORGM.FirearmRarityTable.Civilian[definition.isCivilian] ~= nil then
            table.insert(ORGM.FirearmRarityTable.Civilian[definition.isCivilian], name)
        else
            ORGM.log(ORGM.ERROR, "Invalid civilian rarity for " .. name .. " (" .. definition.isCivilian .. ")")
        end
    end
    if definition.isPolice then
        if ORGM.FirearmRarityTable.Police[definition.isPolice] ~= nil then
            table.insert(ORGM.FirearmRarityTable.Police[definition.isPolice], name)
        else
            ORGM.log(ORGM.ERROR, "Invalid police rarity for " .. name .. " (" .. definition.isPolice .. ")")
        end                
    end
    if definition.isMilitary then
        if ORGM.FirearmRarityTable.Military[definition.isMilitary] ~= nil then
            table.insert(ORGM.FirearmRarityTable.Military[definition.isMilitary], name)
        else
            ORGM.log(ORGM.ERROR, "Invalid military rarity for " .. name .. " (" .. definition.isMilitary .. ")")
        end                
    end
end

--[[  Server.buildRarityTables()

    Purges and recalculates the ORGM.FirearmRarityTable. This must be called if another mod edit the weapon rarity values for any
    firearms after the OnGameBoot event has been triggered.

]]
Server.buildRarityTables = function()
    ORGM.log(ORGM.INFO, "Recalculating Firearm Rarity Tables")
    ORGM.FirearmRarityTable = {
        Civilian = { Common = {},Rare = {}, VeryRare = {} },
        Police = { Common = {}, Rare = {}, VeryRare = {} },
        Military = { Common = {}, Rare = {}, VeryRare = {} },
    }
    for name, definition in pairs(ORGM.FirearmTable) do
        Server.insertIntoRarityTables(name, definition)
    end
end


Server.buildUpgradeTables = function()
    local modItems = {}
    for name, definition in pairs(ORGM.ComponentTable) do
        modItems[name] = InventoryItemFactory.CreateItem(definition.moduleName..'.' .. name)    
    end
    -- loop through once, clearing all old data for ORGM guns
    for gunName, gunDef in pairs(ORGM.FirearmTable) do
        WeaponUpgrades[gunName] = {}
    end
    -- build the WeaponUpgrades table
    for gunName, gunDef in pairs(ORGM.FirearmTable) do
        local gunItem = getScriptManager():FindItem(gunDef.moduleName .. '.' .. gunName)
        for modName, modItem in pairs(modItems) do
            if modItem:getMountOn():contains(gunItem:getDisplayName()) then
                table.insert(WeaponUpgrades[gunName], modItem:getModule() .. '.' .. modName)
                ORGM.log(ORGM.DEBUG, "Added upgrade option "..modItem:getModule() .. '.' .. modName .. " to " .. gunDef.moduleName .. '.' .. gunName)
            end
        end
    end
    ORGM.log(ORGM.INFO, "WeaponUpgrades table built.")
end

Server.buildSpawnTables = function()
    -- build the AllRoundsTable
    AllRoundsTable = { }
    for name, def in pairs(ORGM.AmmoTable) do
        table.insert(AllRoundsTable, name)
    end
    AllComponentsTable = { }
    for name, def in pairs(ORGM.ComponentTable) do
        table.insert(AllComponentsTable, name)
    end
    AllRepairKitsTable = { }
    for name, def in pairs(ORGM.RepairKitTable) do
        table.insert(AllRepairKitsTable, name)
    end
    ORGM.log(ORGM.INFO, "Spawn tables built.")
end
