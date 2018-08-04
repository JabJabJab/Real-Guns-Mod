--[[    Nolan's Survivors Mod Compatibility

    Due to the extensive amount of changes that need to be patched into,
    Survivors mod compatibility requires a seperate file.

    This file needs to do several things to make the survivors mod compatible.
    1) Replace the ranged weapon list that npcs can spawn with.
    2) Replace the loot lists
    3) Replace the functions that give firearms to npcs, and handle attacking.

]]
local isSuperSurvivor = false

local RangeWeaponsOverride = {}
for name, def in pairs(ORGM.Firearm.getTable()) do
    -- this doesn't take into account weapon rarity but meh w/e
    table.insert(RangeWeaponsOverride, def.moduleName .. '.' .. name)
end

-- RareNPCLoot and NPCLoot are declared local, we can't quite override the tables...
-- we can override the functions that use the tables though!

local RareNPCLoot = {
    "camping.CampfireKit",
    "camping.CampfireKit",
    "Base.Map",
    "Base.Axe",
    "Base.PipeBomb",
    "camping.CampingTentKit",
    "camping.CampingTentKit",
    "Base.HuntingKnife",
    "Base.Saw",
    "farming.HandShovel",
    "Base.Screwdriver",
    "Radio.HamRadio1",
    "Base.Sledgehammer",
    "Base.SmokeBomb",
    "Base.PeanutButter",

    "ORGM.Ammo_9x19mm_FMJ_Box",
    "ORGM.M16",
    "ORGM.Ber92",
    "ORGM.Ammo_556x45mm_FMJ_Box",
}
local NPCLoot = {
    "Base.TinnedBeans",
    "Base.CannedSardines",
    "Base.TinnedSoup",
    "Base.Lighter",
    "Base.CannedTomato2",
    "Base.Bandage",
    "Base.TinOpener",
    "Base.BathTowel",
    "Base.Nails",
    "Base.Needle",
    "Base.Pot",
    "Base.Thread",
    "Base.Sheet",
    "Base.PillsVitamins",
    "Base.Pills",
    "Base.Antibiotics",
    "Base.Matches",
    "Base.CannedBroccoli",
    "Base.CannedCarrots",
    "Base.CannedLeek",
    "Base.CannedPotato",
    "Base.KitchenKnife",
    "Base.Garbagebag",
    "Base.SutureNeedle",
    "Base.Splint",
    "Base.Radio",
    "Base.Torch",
    "Base.Crisps2",
    "Base.Disinfectant",
    "Base.Crisps4",
    "Base.Chocolate",
    "Base.PopBottle",
    "Base.CannedChili",
    "Base.CannedBolognese",
    "Base.CannedCarrots2",
    "Base.CannedChili",
    "Base.CannedCorn",
    "Base.CannedCornedBeef",
    "Base.CannedMushroomSoup",
    "Base.CannedPeas",
    "Base.WaterBottleFull",
    "Base.WaterBottleFull",
    "Base.WaterBottleFull",
    "Base.WaterBottleFull",
    "Base.CannedChili",
    "Base.TinnedBeans",

    "ORGM.Ammo_9x19mm_FMJ_Box",
    "ORGM.Ammo_10x25mm_FMJ_Box",
    "ORGM.Ammo_57x28mm_FMJ_Box",
    "ORGM.Ammo_556x45mm_FMJ_Box",
    "ORGM.Ammo_38Special_FMJ_Box",
    "ORGM.Ammo_45ACP_FMJ_Box",
    "ORGM.Ammo_308Winchester_FMJ_Box",
    "ORGM.Ammo_9x19mm_FMJ_Box",
}

if ORGM.isModLoaded("Hydrocraft") then
    table.insert(NPCLoot,"Hydrocraft.HCJackknife")
    table.insert(NPCLoot,"Hydrocraft.HCMeatcleaver")
    table.insert(NPCLoot,"Hydrocraft.HCMasontrowel")
    table.insert(NPCLoot,"Hydrocraft.HCMRE")
    table.insert(NPCLoot,"Hydrocraft.HCTrailmix")
    table.insert(NPCLoot,"Hydrocraft.HCVodka")
    table.insert(NPCLoot,"Hydrocraft.HCWorkgloves")
    table.insert(NPCLoot,"Hydrocraft.HCPliers")
    table.insert(NPCLoot,"Hydrocraft.HCElectricmultitooloff")
    table.insert(NPCLoot,"Hydrocraft.HCSawlumber")

    table.insert(RareNPCLoot,"Hydrocraft.HCShieldriot")
    table.insert(RareNPCLoot,"Hydrocraft.HCDownjacket")
    table.insert(RareNPCLoot,"Hydrocraft.HCTentkit")
    table.insert(RareNPCLoot,"Hydrocraft.HCSleepingbag")
    table.insert(RareNPCLoot,"Hydrocraft.HCSleepingbag")
    table.insert(RareNPCLoot,"Hydrocraft.HCBatterymedium")
    table.insert(RareNPCLoot,"Hydrocraft.HCBatterymedium")
    table.insert(RareNPCLoot,"Hydrocraft.HCMagnesiumstriker")

end

-- not sure why these functions even exists, its redundant and pointlessly pollutes the global space.
-- but w/e at least we can use them to override the tables.
local getNPCLootOverride = function()
    return NPCLoot[ZombRand(#RareNPCLoot) + 1]
end

local getRareNPCLootOverride = function()
    return RareNPCLoot[ZombRand(#RareNPCLoot) + 1]
end

-- this function is a bugfix for the survivors mod.
local getWeaponOverride = function(kind)
    --if kind == "Base.Shotgun" then return "ORGM.Silverhawk" end
    if kind == "Base.Shotgun" then return "ORGM.Rem870" end
    if kind == "Base.HuntingRifle" then return "ORGM.Garand" end
    if kind == "Base.HuntingRiflel" then return "ORGM.Garand" end -- theres the fix, some preset NPC's have a typo in their weapon names
    if kind == "Base.VarmintRifle" then return "ORGM.AR15" end
    if kind == "Base.Pistol" then return "ORGM.Ber92" end
    return kind
end

-- reloadWeapon function
-- this needs to use the real ammo instead of AmmoGroup rounds. it also needs
-- to properly reload so if the real player gets the gun later its actually useable
-- instead of having nerfed modData stats.
local reloadWeaponOriginal = nil
local reloadWeaponOverride = function(primary, player)
    if primary == nil or player == nil then
        return true
    end
    if not ORGM.Firearm.isFirearm(primary) then
        -- not a orgm gun, call the original function
        return reloadWeaponOriginal(primary, player)
    end

    primary:setCondition(primary:getConditionMax())
    if primary:isRanged() == false then return true end
    --local ammoType = getAmmoBullets(primary, false)
    local ammoType = ORGM.Ammo.itemGroup(primary)
    if ammoType == nil then return true end

    local modData = primary:getModData()
    modData.isJammed = nil -- lose any jammed flag
    if modData.roundChambered == 1 then return true end -- gun is already loaded
    if modData.currentCapacity and modData.currentCapacity > 0 then -- gun still has ammo, don't reload yet
        return true
    end

    local secondaryHand = player:getSecondaryHandItem()
    local container = player:getInventory()

    -- local allAmmo = ORGM.findAllAmmoInContianer(ammoType, container)
    -- local ammoItem = nil
    -- if ammo.rounds:size() > 0 then ammoItem = ammo.rounds:get(1) end

    local ammoItem = ORGM.Ammo.findIn(ammoType, 'any', container)
    if ammoItem == nil and secondaryHand ~= nil and secondaryHand:getCategory() == "Container" then
        -- allAmmo = ORGM.findAllAmmoInContianer(ammoType, container)
        -- if ammo.rounds:size() > 0 then ammoItem = ammo.rounds:get(1) end
        container = secondaryHand:getItemContainer()
        ammoItem = ORGM.Ammo.findIn(ammoType, 'any', container)
    end
    if ammoItem == nil and player:getClothingItem_Back() ~= nil then
        -- allAmmo = ORGM.findAllAmmoInContianer(ammoType, container)
        -- if ammo.rounds:size() > 0 then ammoItem = ammo.rounds:get(1) end
        container = player:getClothingItem_Back():getItemContainer()
        ammoItem = ORGM.Ammo.findIn(ammoType, 'any', container)
    end
    if ammoItem == nil then
        if not SurvivorInfiniteAmmo then return false end
        ammoType = ORGM.Ammo.getGroup(ammoType)[1]
    else
        ammoType = ammoItem:getType()
    end

    --if ammoItem == nil then return false end
    local ammoCount = container:getNumItems(ammoType)
    if SurvivorInfiniteAmmo then ammoCount = 999 end
    if ammoCount < 20 then player:Say("Almost out of ammo here!") end
    if ammoCount > 0 and (modData.actionType ~= ORGM.ROTARY and modData.actionType ~= ORGM.BREAK) then
        modData.roundChambered = 1
        ammoCount = ammoCount -1
        if not SurvivorInfiniteAmmo then container:RemoveOneOf(ammoType) end
    end
    for index=1, ammoCount do
        if modData.currentCapacity >= modData.maxCapacity then break end
        modData.magazineData[index] = ammoType
        modData.currentCapacity = modData.currentCapacity + 1
        if not SurvivorInfiniteAmmo then container:RemoveOneOf(ammoType) end
    end
    return true
end



-- giveWeapon function
-- this needs to call ORGM.Firearm.setup to properly setup the modData
-- it also needs to pick a alternate ammo instead of the AmmoGroup rounds
local giveWeaponOverride = function(player, weaponType, seenZombie)
    local weapon = InventoryItemFactory.CreateItem(weaponType)
    if weapon == nil then return end
    player:getInventory():AddItem(weapon)
    --local weapon = player:getInventory():AddItem(weaponType)

    local ammoType = nil
    if ORGM.Firearm.isFirearm(weapon) then
        if WeaponUpgrades[weapon:getType()] then
            ItemPicker.doWeaponUpgrade(weapon)
        end

        ORGM.Firearm.setup(ReloadUtil:getWeaponData(weapon:getType()), weapon)
        ammoType = getAmmoBullets(weapon, false)
        local AmmoTbl = ORGM.Ammo.getGroup(ammoType)
        if AmmoTbl then
            ammoType = AmmoTbl[ZombRand(#AmmoTbl) + 1] -- randomly pick ammo
            ammoType = ORGM.Ammo.getData(ammoType).moduleName ..'.'.. ammoType
        elseif not ORGM.Ammo.isAmmo(ammoType) then
            ORGM.log(ORGM.WARN, "Survivors mod tried to give non-registered and non-AmmoGroup round ammo for a gun.")
        end
    else
        ammoType = getAmmoBullets(weapon, true)
    end

    if ammoType then
        local tempammoitem = player:getInventory():AddItem(ammoType)

        if tempammoitem ~= nil then
            local groupcount = tempammoitem:getCount()
            local randomammo = math.floor(ZombRand(25,80)/groupcount)

            for i=0, randomammo do
                player:getInventory():AddItem(ammoType)
            end
        end
    end
    if seenZombie then player:setPrimaryHandItem(weapon) end

end
local LoadSurvivorOriginal = nil
local LoadSurvivorOverride = function(ID, square)
    if LoadSurvivorOriginal(ID, square) == false then return end
    local survivor = Survivors[ID]
    if survivor == nil then return end
    -- requip the primary hand item, to handle orgm backwards compatibility functions.
    local primary = survivor:getPrimaryHandItem()
    survivor:setPrimaryHandItem(nil)
    survivor:setPrimaryHandItem(primary)
end



local SSWeaponReadyOriginal = nil

local SSWeaponReadyOverride = function(self)
	local primary = self.player:getPrimaryHandItem()

    if primary == nil or self.player == nil then
        return true
    end

    if not ORGM.Firearm.isFirearm(primary) then
        -- not a orgm gun, call the original function
        return SSWeaponReadyOriginal(self)
    end
    -- code is basically the same as the old survivors reloadWeapon, we can just call our legacy patch function
    return reloadWeaponOverride(primary, self.player)
end

local SSgiveWeaponOverride = function(self, weaponType, equipIt)
--function SuperSurvivor:giveWeapon(weaponType,equipIt )
    if weaponType == "Base.Pistol" then
        weaponType = RangeWeaponsOverride[ZombRand(#RangeWeaponsOverride) +1]
    end
	giveWeaponOverride(self.player, weaponType, equipIt)
end

local SSloadPlayerOriginal = nil
local SSloadPlayerOverride = function(self, square, ID)
    local player = SSloadPlayerOriginal(self, square, ID)
    if not player then return end
    local primary = player:getPrimaryHandItem()
    player:setPrimaryHandItem(nil)
    player:setPrimaryHandItem(primary)
    return player
end

Events.OnGameBoot.Add(function()
    if ORGM.isModLoaded("Survivors") == true and ORGM.Settings.UseSurvivorsPatch then
        ORGM.log(ORGM.INFO, "Injecting Survivors Mod Overwrites")

        RangeWeapons = RangeWeaponsOverride
        reloadWeaponOriginal = reloadWeapon
        reloadWeapon = reloadWeaponOverride
        getWeapon = getWeaponOverride -- bugfix...not my bug :P
        giveWeapon = giveWeaponOverride
        getNPCLoot = getNPCLootOverride
        getRareNPCLoot = getRareNPCLootOverride
        LoadSurvivorOriginal = LoadSurvivor
        LoadSurvivor = LoadSurvivorOverride
    end
--[[
    if ORGM.isModLoaded("SuperSurvivors") == true and ORGM.Settings.UseSurvivorsPatch then
        ORGM.log(ORGM.INFO, "Injecting SuperSurvivors Mod Overwrites")
        isSuperSurvivor = true

        SSloadPlayerOriginal = SuperSurvivor.loadPlayer
        SuperSurvivor.loadPlayer = SSloadPlayerOverride
        getWeapon = getWeaponOverride -- this override is kinda useless with super
        SSWeaponReadyOriginal = SuperSurvivor.WeaponReady
        SuperSurvivor.WeaponReady = SSWeaponReadyOverride
        SuperSurvivor.giveWeapon = SSgiveWeaponOverride
    end
]]
end)
