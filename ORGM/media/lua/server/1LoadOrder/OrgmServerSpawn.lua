--[[- Spawning Functions.

@module ORGM.Server.Spawn
@author Fenris_Wolf
@release v3.10
@copyright 2018 **File:** server/1LoadOrder/ORGMServerSpawn.lua

]]

local ORGM = ORGM
local Server = ORGM.Server
local Spawn = ORGM.Server.Spawn
local Settings = ORGM.Settings
local Ammo = ORGM.Ammo
local Component = ORGM.Component
local Maintance = ORGM.Maintance
local Firearm = ORGM.Firearm
local Magazine = ORGM.Magazine
local Reloadable = ORGM.ReloadableWeapon
local Status = Reloadable.Status

-- more namespace pullins for performance
local ZombRand = ZombRand
local ZombRandFloat = ZombRandFloat
local tostring = tostring
local table = table
local InventoryItemFactory = InventoryItemFactory
local ZomboidGlobals = ZomboidGlobals
local ItemPicker = ItemPicker
local ipairs = ipairs

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

--[[ Rnd(maxValue)

Returns a value between 1 and maxValue (including lower and upper values)

]]
local Rnd = function(maxValue)
    return ZombRand(maxValue) + 1
end


--[[- Attaches random components on a newly spawned firearm.

@tparam HandWeapon item

]]
Spawn.attach = function(item)
    -- TODO: tweak this damn function
    local componentList = Component.getValid(item)
    for i=1, ZombRand(#componentList) do
        -- TODO: this needs to check civ/police/military
        local compName = componentList[ZombRand(#componentList) + 1]
        local compData = Component.getData(compName)
        if not compData then
            -- TODO: log errors here
            break
        end
        if ZombRandFloat(0,100) <= 100*Settings.ComponentSpawnModifier then
            local part = InventoryItemFactory.CreateItem(compData.moduleName .. '.' .. compName)
            part:getModData().BUILD_ID = ORGM.BUILD_ID
            item:attachWeaponPart(part)
        end
    end
end


--[[- Attempts to spawns reloadable weapon or magazine.

It called by `Spawn.firearm` and `Spawn.magazine`.

@tparam ItemContainer container
@tparam string itemType name of the gun or magazine without the ORGM. prefix.
@tparam string ammoType ammo name to load into the gun if isLoaded = true.
@tparam float chance % chance to spawn the item.
@tparam int max max number of items to spawn. A random # is chosen between 1 and max
@tparam bool isLoaded if true the gun/magazine is loaded with ammoType

@treturn bool true if the reloadable spawned

]]

--[[ Spawn.reloadable = function(container, itemType, ammoType, chance, max, isLoaded)
    -- ZomboidGlobals.WeaponLootModifier
    -- 0.2 extremely rare, 0.6 rare, 1.0 normal, 2.0 common, 4 abundant
    --ORGM.log(ORGM.DEBUG, "Spawn.reloadable called for " .. itemType .. " with " .. chance .. "% chance.")
    local roll = ZombRandFloat(0,100)
    --if Rnd(100) > math.ceil(chance) then return false end
    ORGM.log(ORGM.DEBUG, "Spawn.reloadable for " .. itemType .. ": " ..roll.. " roll vs ".. chance .. "% chance.")

    if roll > chance then return false end
    --if roll > chance*(ORGM.NVAL/ORGM.PVAL/ORGM.NVAL) then return false end
    local count = Rnd(max)

    local itemOrgmData = nil
    local isFirearm = Firearm.isFirearm(itemType)
    --ORGM.log(ORGM.DEBUG, "Spawn.reloadable isFirearm (from data):"..tostring(isFirearm and true))
    if isFirearm then
        itemOrgmData = Firearm.getDesign(itemType)
    elseif Magazine.isMagazine(itemType) then
        itemOrgmData = Magazine.getData(itemType)
    else
        ORGM.log(ORGM.ERROR, "Tried to spawn reloadable " .. itemType .. " but item is not a registered firearm or magazine.")
        return nil
    end


    for i=1, count do
        local additem = ItemPicker.tryAddItemToContainer(container, itemOrgmData.moduleName .. '.' .. itemType)
        if not additem then return false end
        ORGM.log(ORGM.DEBUG, "Spawned " .. itemOrgmData.moduleName .. '.' .. itemType)
        if isFirearm then
            Firearm.setup(Firearm.getDesign(itemType), additem)
            Spawn.generateSerialNumber(additem)
            if isLoaded then additem:setCondition(Rnd(additem:getConditionMax())) end
        else
            Magazine.setup(Magazine.getData(itemType), additem)
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
                data.chambered = ammoType
                fill = fill - 1

                if not Firearm.Trigger.isDAO(additem, itemOrgmData) then
                    data.status = data.status + Status.COCKED
                end
            end

            for i=1, fill do
                data.magazineData[i] = ammoType
            end
            data.currentCapacity = fill
            data.loadedAmmo = ammoType
        end
        if isFirearm then
            Spawn.attach(additem)
            Firearm.Stats.set(additem)
        end
    end
    return true
end
]]


--[[- A wrapper function for `Spawn.reloadable`.

@tparam ItemContainer container
@tparam string gunType name of the gun without the ORGM. prefix.
@tparam string ammoType ammo name to load into the gun if isLoaded = true.
@tparam float chance % chance to spawn the item.
@tparam int max max number of items to spawn. A random # is chosen between 1 and max
@tparam bool isLoaded if true the gun/magazine is loaded with ammoType

@treturn bool true if the reloadable spawned

]]
--Spawn.firearm = function(container, gunType, ammoType, chance, max, isLoaded)
--    chance = chance * ZomboidGlobals.WeaponLootModifier * Settings.FirearmSpawnModifier
--    return Spawn.reloadable(container, gunType, ammoType, chance, max, isLoaded)
--end


--[[- A wrapper function for `Spawn.reloadable`

@tparam ItemContainer container
@tparam string gunType name of the gun to spawn magazines for without the ORGM. prefix.
@tparam string ammoType ammo name to load into the gun if isLoaded = true.
@tparam float chance % chance to spawn the item.
@tparam int max max number of items to spawn. A random # is chosen between 1 and max
@tparam bool isLoaded if true the gun/magazine is loaded with ammoType

]]

--[[Spawn.magazine = function(container, gunType, ammoType, chance, max, isLoaded)
    chance = chance * ZomboidGlobals.WeaponLootModifier * Settings.MagazineSpawnModifier
    local weaponData = Firearm.getDesign(gunType)
    local magType = weaponData.ammoType
    if Magazine.isMagazine(magType) then -- gun uses mags
        Spawn.reloadable(container, magType, ammoType, chance, max, isLoaded)
    end

    local magType = weaponData.speedLoader
    if Magazine.isMagazine(magType) then -- gun uses speedloaders
        Spawn.reloadable(container, magType, ammoType, chance, max, isLoaded)
    end
end
]]

Spawn.magazine = function(container, group, chance, minCount, maxCount, isLoaded)
    chance = chance * ZomboidGlobals.WeaponLootModifier * Settings.MagazineSpawnModifier
    group = Magazine.getGroup(group)
    if not group then return end
    return group:spawn(nil, nil, container, isLoaded)
end


--[[- Generic spawn function for non-reloadable items (ie: ammo or repair stuff).

This does not factor in Sandbox Loot Rarity or ORGM Spawn Settings. It is advised you use
one of the wrapper functions to spawn items.

**Note** the itemType argument **must** have the module prefix, unlike the wrapper functions.

@tparam ItemContainer container
@tparam string itemType
@tparam float % chance to spawn the item.
@tparam int max between 1 and max number of items may spawn.

@treturn table list of spawned InventoryItem objects

]]

--[[ Spawn.item = function(container, itemType, chance, max)
    local roll = ZombRandFloat(0,100)
    ORGM.log(ORGM.DEBUG, "Spawn.item for " .. itemType .. ": " ..roll.. " roll vs ".. chance .. "% chance.")
    local result = {}
    if roll > chance then return result end
    -- if roll > chance*(ORGM.NVAL/ORGM.PVAL/ORGM.NVAL) then return result end
    local count = Rnd(max)
    for i=1, count do
        local item = ItemPicker.tryAddItemToContainer(container, itemType)
        if not item then break end
        table.insert(result, item)
    end
    return result
end
]]


--[[- Attempts to spawn loose ammo in the container.

Wrapper function for `Spawn.item`, modifying the `chance` argument by Sandbox Weapon
Loot and ORGM Ammo Spawn Settings.

The ammoType argument must **not** contain the moduleName prefix

@tparam ItemContainer container
@tparam nil|string ammoType name of the ammo, randomly chosen if nil.
@tparam float chance base % chance to spawn the item.
@tparam int max between 1 and max number of items may spawn.

@treturn table list of spawned InventoryItem objects

]]
Spawn.ammo = function(container, ammoType, chance, max)
    if not ammoType then ammoType = Ammo.random() end
    chance = chance * ZomboidGlobals.WeaponLootModifier * Settings.AmmoSpawnModifier
    return Spawn.item(container, Ammo.getData(ammoType).moduleName .. '.' .. ammoType, chance, max)
end

--[[- Attempts to spawn ammo boxes in the container.

Wrapper function for `Spawn.item`, modifying the `chance` argument by Sandbox Weapon
Loot and ORGM Ammo Spawn Settings.

The ammoType argument must **not** contain the moduleName prefix, or `_Box` suffex.

@tparam ItemContainer container
@tparam nil|string ammoType name of the ammo, randomly chosen if nil.
@tparam float chance base % chance to spawn the item.
@tparam int max between 1 and max number of items may spawn.

@treturn table list of spawned InventoryItem objects

]]
Spawn.ammoBox = function(container, ammoType, chance, max)
    if not ammoType then ammoType = Ammo.random() end
    chance = chance * ZomboidGlobals.WeaponLootModifier * Settings.AmmoSpawnModifier
    return Spawn.item(container, Ammo.getData(ammoType).moduleName .. '.' .. ammoType .. '_Box', chance, max)
end

--[[- Attempts to spawn ammo canisters in the container.

Wrapper function for `Spawn.item`, modifying the `chance` argument by Sandbox Weapon
Loot and ORGM Ammo Spawn Settings.

The ammoType argument must **not** contain the moduleName prefix, or `_Can` suffex.

@tparam ItemContainer container
@tparam nil|string ammoType name of the ammo, randomly chosen if nil.
@tparam float chance base % chance to spawn the item.
@tparam int max between 1 and max number of items may spawn.

@treturn table list of spawned InventoryItem objects

]]
Spawn.ammoCan = function(container, ammoType, chance, max)
    if not ammoType then ammoType = Ammo.random() end
    chance = chance * ZomboidGlobals.WeaponLootModifier * Settings.AmmoSpawnModifier
    return Spawn.item(container, Ammo.getData(ammoType).moduleName .. '.' .. ammoType .. '_Can', chance, max)
end


--[[- Attempts to spawns a random maintance item.

Wrapper function for `Spawn.item`, modifying the `chance` argument by Sandbox Weapon
Loot and ORGM Repair Kit Spawn Settings.

@tparam ItemContainer container
@tparam float chance base % chance to spawn the item.
@tparam int max between 1 and max number of items may spawn.

@treturn table list of spawned InventoryItem objects

]]
Spawn.maintance = function(container, chance, max)
    local choice = Maintance.random()
    chance = chance * ZomboidGlobals.WeaponLootModifier * Settings.RepairKitSpawnModifier
    return Spawn.item(container, Maintance.getData(choice).moduleName .. '.' .. choice, chance, max)
end

--[[- Attempts to spawns a firearm component.

Wrapper function for `Spawn.item`, modifying the `chance` argument by Sandbox Weapon
Loot and ORGM Component Spawn Settings.

@tparam ItemContainer container
@tparam float chance base % chance to spawn the item.
@tparam int max between 1 and max number of items may spawn.

@treturn table list of spawned InventoryItem objects

]]
Spawn.component = function(container, chance, max)
    chance = chance * ZomboidGlobals.WeaponLootModifier * Settings.ComponentSpawnModifier
    local choice = Component.random() -- AllComponentsTable[Rnd(#AllComponentsTable)]
    local result = Spawn.item(container, ORGM.Component.getData(choice).moduleName .. '.' .. choice, chance, max)
    for _, item in ipairs(result) do
        item:getModData().BUILD_ID = ORGM.BUILD_ID
    end
    return result
end

--[[- Chooses a gun from the rarity tables and appropriate ammo type.

@tparam int civilian chance of using the civilian table (weight value)
@tparam int police chance of using the police table (weight value)
@tparam int military chance of using the military table (weight value)

@treturn table table with 2 keys: .gun and .ammo

@see ORGM.Firearm.randomRarity

]]


--[[
Spawn.select = function(civilian, police, military)
    -- select the table
    civilian = civilian * Settings.CivilianFirearmSpawnModifier
    police = police * Settings.PoliceFirearmSpawnModifier
    military = military * Settings.MilitaryFirearmSpawnModifier
    local thisTable = Firearm.randomRarity(civilian, police, military)

    local gunType = Firearm.random(thisTable)
    ORGM.log(ORGM.DEBUG, "Selected " .. tostring(gunType))
    if not gunType then
        return {gun = nil, ammo = nil}
    end

    local weaponData = Firearm.getDesign(gunType)

    local ammoType = weaponData.ammoType
    if Magazine.isMagazine(ammoType) then -- ammoType is a mag, get its default ammo
        ammoType = Magazine.getData(ammoType).ammoType
    end

    local altTable = Ammo.getGroup(ammoType)
    if Rnd(100) > 50 then
        ammoType = altTable[Rnd(#altTable)]
    else
        ammoType = altTable[1]
    end

    return {gun = gunType, ammo = ammoType}
end
]]

--[[- Generic spawn function for corpses.

Attempts to spawn items on the corpse.

@tparam ItemContainer container

]]
Spawn.addToCorpse = function(container)
    -- local choice = Spawn.select(80, 14, 6)
    -- if not choice then return end
    -- Spawn.firearm(container, choice.gun, choice.ammo, 3*Settings.CorpseSpawnModifier, 1, true) -- has gun
    -- Spawn.magazine(container, choice.gun, choice.ammo, 1*Settings.CorpseSpawnModifier, 3, true) -- has mags
    -- Spawn.ammo(container, choice.ammo, 3*Settings.CorpseSpawnModifier, 15) -- loose shells
    -- Spawn.ammoBox(container, choice.ammo, 1*Settings.CorpseSpawnModifier, 1) -- has box
    return
end

--local rollChance = function(base, modifiers)
--end

Spawn.spawnWeapons = function(firearmGroup, container, loaded, chances, modifiers, counts)
    local choice = Firearm.getGroup(firearmGroup):random()
    if not choice then return false end
    --ORGM.log(ORGM.DEBUG, "Spawn.reloadable for " .. itemType .. ": " ..roll.. " roll vs ".. chance .. "% chance.")
    for i=1, counts[1] or 0 do
        choice:spawn(container, loaded, (chances[1] and chances[1]*modifier or nil), true)
    end
    for i=1, counts[2] or 0 do
        -- spawn magazines
    end
    -- spawn ammo, boxes and cans
end

--[[- Generic spawn function for Civilian rooms.

Attempts to spawn items in the room.

@tparam ItemContainer container

]]
Spawn.addToCivRoom = function(container)
    Spawn.spawnWeapons("Group_Main", container, true, { 3, 1, 2, 1 }, Settings.CivilianBuildingSpawnModifier, { 1, 2, 30, 2 })

    --Spawn.component(container, 1*Settings.CivilianBuildingSpawnModifier, 1) -- has a mod
    --Spawn.maintance(container, 1*Settings.CivilianBuildingSpawnModifier, 1) -- has repair stuff
end

Spawn.RoomHandlers.all = function(roomName, containterType, container)
    if containerType == "inventorymale" then
        Spawn.addToCorpse(container)
    elseif roomName == "all" and containerType == "inventoryfemale" then
        Spawn.addToCorpse(container)
    end
end
--[[
Spawn.RoomHandlers.bedroom = function(roomName, containterType, container)
    if containerType == "wardrobe" then addToCivRoom(container) end
end
Spawn.RoomHandlers.zippeestore = function(roomName, containterType, container)
    if containerType == "counter" then addToCivRoom(container) end
end
Spawn.RoomHandlers.fossoil = function(roomName, containterType, container)
    if containerType == "counter" then addToCivRoom(container) end
end
Spawn.RoomHandlers.gasstore = function(roomName, containterType, container)
    if containerType == "counter" then addToCivRoom(container) end
end
Spawn.RoomHandlers.bar = function(roomName, containterType, container)
    if containerType == "counter" then addToCivRoom(container) end
end
Spawn.RoomHandlers.policestorage = function(roomName, containterType, container)
    local mod = Settings.PoliceStorageSpawnModifier
    local count = Rnd(3)
    while count ~= 0 do
        local choice = Spawn.select(0, 70, 30)
        if choice then
            Spawn.firearm(container, choice.gun, choice.ammo, 60*mod, 1, false)
            Spawn.magazine(container, choice.gun, choice.ammo, 80*mod, 2, false)

            Spawn.ammoBox(container, choice.ammo, 80*mod, 4)
            Spawn.ammoCan(container, choice.ammo, 20*mod, 1)
        end
        Spawn.component(container, 30*mod, 2)
        Spawn.maintance(container, 40*mod, 2)
        if Rnd(10) > 4 then count = count -1 end
    end
end
Spawn.RoomHandlers.gunstore = function(roomName, containterType, container)
    local mod = Settings.GunStoreSpawnModifier
    if containerType == "locker" then
        Spawn.ammoBox(container, nil, 70*mod, 1)
        Spawn.ammoBox(container, nil, 60*mod, 1)
        Spawn.ammoBox(container, nil, 50*mod, 1)
        Spawn.ammoBox(container, nil, 40*mod, 1)
        Spawn.ammoBox(container, nil, 30*mod, 1)
        Spawn.ammoCan(container, nil, 10*mod, 1)
        Spawn.ammoCan(container, nil, 5*mod, 1)
        Spawn.maintance(container, 20*mod, 2)

    elseif containerType == "counter" then
        Spawn.ammoBox(container, nil, 70*mod, 1)
        Spawn.ammoBox(container, nil, 60*mod, 1)
        Spawn.ammoBox(container, nil, 50*mod, 1)
        Spawn.ammoBox(container, nil, 40*mod, 1)
        Spawn.ammoBox(container, nil, 30*mod, 1)
        Spawn.ammoCan(container, nil, 10*mod, 1)
        Spawn.ammoCan(container, nil, 5*mod, 1)
        Spawn.maintance(container, 20*mod, 2)

    elseif containerType == "displaycase" or containerType == "metal_shelves" then
        local choice = Spawn.select(85, 10, 5)
        if choice then
            Spawn.firearm(container, choice.gun, choice.ammo, 60*mod, 1, false)
            Spawn.magazine(container, choice.gun, choice.ammo, 40*mod, 2, false)
        end
        choice = Spawn.select(85, 10, 5)
        if choice then
            Spawn.firearm(container, choice.gun, choice.ammo, 40*mod, 1, false)
            Spawn.magazine(container, choice.gun, choice.ammo, 30*mod, 2, false)
        end
        Spawn.component(container, 40*mod, 2)
        Spawn.maintance(container, 30*mod, 2)
    end
end
Spawn.RoomHandlers.gunstorestorage = function(roomName, containterType, container)
    local mod = Settings.GunStoreSpawnModifier
    local choice = Spawn.select(85, 10, 5)
    if choice then
        Spawn.firearm(container, choice.gun, choice.ammo, 60*mod, 1, false)
        Spawn.magazine(container, choice.gun, choice.ammo, 40*mod, 2, false)
    end
    choice = Spawn.select(85, 10, 5)
    if choice then
        Spawn.firearm(container, choice.gun, choice.ammo, 40*mod, 1, false)
        Spawn.magazine(container, choice.gun, choice.ammo, 30*mod, 2, false)
    end
    Spawn.component(container, 40*mod, 2)
    Spawn.maintance(container, 30*mod, 2)

    Spawn.ammoBox(container, nil, 70*mod, 1)
    Spawn.ammoBox(container, nil, 60*mod, 1)
    Spawn.ammoBox(container, nil, 50*mod, 1)
    Spawn.ammoBox(container, nil, 40*mod, 1)
    Spawn.ammoBox(container, nil, 30*mod, 1)
    Spawn.ammoCan(container, nil, 10*mod, 1)
    Spawn.ammoCan(container, nil, 5*mod, 1)
    Spawn.maintance(container, 20*mod, 2)
end
Spawn.RoomHandlers.storageunit = function(roomName, containterType, container)
    if containerType == "crate" then
        local mod = Settings.StorageUnitSpawnModifier
        local choice = Spawn.select(85, 10, 5)
        if choice then
            Spawn.firearm(container, choice.gun, choice.ammo, 10*mod, 1, false)
            Spawn.magazine(container, choice.gun, choice.ammo, 5*mod, 3, false)
        end
        choice = Spawn.select(85, 10, 5)
        if choice then
            Spawn.firearm(container, choice.gun, choice.ammo, 10*mod, 1, false)
            Spawn.magazine(container, choice.gun, choice.ammo, 5*mod, 3, false)
        end
        Spawn.component(container, 5*mod, 2)
        Spawn.component(container, 2*mod, 2)
        Spawn.maintance(container, 10*mod, 2)

        if Rnd(100) <= 3 then
            Spawn.ammoBox(container, nil, 70*mod, 1)
            Spawn.ammoBox(container, nil, 60*mod, 1)
            Spawn.ammoBox(container, nil, 50*mod, 1)
            Spawn.ammoBox(container, nil, 40*mod, 1)
            Spawn.ammoBox(container, nil, 30*mod, 1)
            Spawn.ammoCan(container, nil, 10*mod, 1)
            Spawn.ammoCan(container, nil, 5*mod, 1)
            Spawn.maintance(container,20*mod, 2)
        end
    end
end
Spawn.RoomHandlers.garagestorage = function(roomName, containterType, container)
    if containerType == "smallbox" then
        local mod = Settings.GarageSpawnModifier
        local choice = Spawn.select(85, 10, 5)
        if choice then
            Spawn.firearm(container, choice.gun, choice.ammo, 10*mod, 1, false)
            Spawn.magazine(container, choice.gun, choice.ammo, 5*mod, 3, false)
        end
        choice = Spawn.select(85, 10, 5)
        if choice then
            Spawn.firearm(container, choice.gun, choice.ammo, 10*mod, 1, false)
            Spawn.magazine(container, choice.gun, choice.ammo, 5*mod, 3, false)
        end
        Spawn.component(container, 5*mod, 2)
        Spawn.component(container, 2*mod, 2)
        Spawn.maintance(container, 10*mod, 2)

        if Rnd(100) <= 3 then
            Spawn.ammoBox(container, nil, 70*mod, 1)
            Spawn.ammoBox(container, nil, 60*mod, 1)
            Spawn.ammoBox(container, nil, 50*mod, 1)
            Spawn.ammoBox(container, nil, 40*mod, 1)
            Spawn.ammoBox(container, nil, 30*mod, 1)
            Spawn.ammoCan(container, nil, 10*mod, 1)
            Spawn.ammoCan(container, nil, 5*mod, 1)
            Spawn.maintance(container, 20*mod, 2)
        end
    end
end
Spawn.RoomHandlers.hunting = function(roomName, containterType, container)
    if (containerType == "metal_shelves" or containerType == "locker") then
        local mod = Settings.HuntingSpawnModifier
        local choice = Spawn.select(85, 10, 5)
        if choice then
            Spawn.firearm(container, choice.gun, choice.ammo, 30*mod, 1, false)
            Spawn.magazine(container, choice.gun, choice.ammo, 10*mod, 3, false)
        end
        choice = Spawn.select(85, 10, 5)
        if choice then
            Spawn.firearm(container, choice.gun, choice.ammo, 20*mod, 1, false)
            Spawn.magazine(container, choice.gun, choice.ammo, 8*mod, 3, false)
        end
        Spawn.component(container, 15*mod, 2)
        Spawn.component(container, 2*mod, 1)
        Spawn.maintance(container, 20*mod, 2)

        Spawn.ammoBox(container, nil, 70*mod, 1)
        Spawn.ammoBox(container, nil, 60*mod, 1)
        Spawn.ammoBox(container, nil, 50*mod, 1)
        Spawn.ammoBox(container, nil, 40*mod, 1)
        Spawn.ammoBox(container, nil, 30*mod, 1)
        Spawn.ammoCan(container, nil, 10*mod, 1)
        Spawn.ammoCan(container, nil, 5*mod, 1)
        Spawn.maintance(container, 20*mod, 2)
    end
end

-- patch for snake's military complex mod
Spawn.RoomHandlers.mcgunstorestorage = function(roomName, containterType, container)

    local type = Rnd(3)
    if type == 1 then
        Spawn.spawnWeapons("Group_NATO", container, false, { 50, 50 }, Settings.PoliceStorageSpawnModifier, { 5, 10 })
    elseif type == 2 then
    end
    local mod = Settings.PoliceStorageSpawnModifier
    local count = Rnd(3)
    while count ~= 0 do
        local choice = Spawn.select(0, 30, 70)
        if choice then
            Spawn.firearm(container, choice.gun, choice.ammo, 60*mod, 1, false)
            Spawn.magazine(container, choice.gun, choice.ammo, 80*mod, 2, false)

            Spawn.ammoBox(container, choice.ammo, 80*mod, 4)
            Spawn.ammoCan(container, choice.ammo, 20*mod, 1)
        end
        Spawn.component(container, 30*mod, 2)
        Spawn.maintance(container, 40*mod, 2)
        if Rnd(10) > 4 then count = count -1 end
    end
end
Spawn.RoomHandlers.ammomakerroom = Spawn.RoomHandlers.mcgunstorestorage

Spawn.RoomHandlers.trainingcamp = function(roomName, containterType, container)
    local mod = Settings.PoliceStorageSpawnModifier
    if containerType == "metal_shelves" or containerType == "crate" then
        local count = Rnd(3)
        while count ~= 0 do
            local choice = Spawn.select(0, 30, 70)
            if choice then
                Spawn.firearm(container, choice.gun, choice.ammo, 60*mod, 1, false)
                Spawn.magazine(container, choice.gun, choice.ammo, 80*mod, 2, false)

                Spawn.ammoBox(container, choice.ammo, 80*mod, 4)
                Spawn.ammoCan(container, choice.ammo, 20*mod, 1)
            end
            Spawn.component(container, 30*mod, 2)
            Spawn.maintance(container, 40*mod, 2)
            if Rnd(10) > 4 then count = count -1 end
        end
    else
        local count = Rnd(3)
        while count ~= 0 do
            local choice = Spawn.select(0, 30, 70)
            if choice then
                Spawn.ammoBox(container, choice.ammo, 80*mod, 4)
                Spawn.ammoCan(container, choice.ammo, 20*mod, 1)
            end
            Spawn.component(container, 30*mod, 2)
            Spawn.maintance(container, 40*mod, 2)
            if Rnd(10) > 3 then count = count -1 end
        end
    end
end
]]

--[[- Triggered by the OnFillContainer Event.

The bulk of the other functions in the spawning system are directly or indirectly called from this.

]]

Spawn.fillContainer = function(roomName, containerType, container)
    if Spawn.RoomHandlers[roomName] then
        ORGM.log(ORGM.DEBUG, "Spawn: Checking "..tostring(roomName) ..", ".. tostring(containerType))
        Spawn.RoomHandlers[roomName](roomName, containerType, container)
    end
end
