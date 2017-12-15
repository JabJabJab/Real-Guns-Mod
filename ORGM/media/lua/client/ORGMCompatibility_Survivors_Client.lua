--[[    Nolan's Survivors Mod Compatibility

    This file needs to do several things to make the survivors mod compatible.
    1) Replace the ranged weapon list that npcs can spawn with.
    2) Replace the loot lists
    3) Replace the functions that give firearms to npcs, and handle attacking.

]]

local RangeWeaponsOverride = {}
for name, data in pairs(ORGMMasterWeaponTable) do
    -- this doesn't take into account weapon rarity but meh w/e
    table.insert(RangeWeaponsOverride, "ORGM." .. name)
end

-----------------------------------------------------------------------------
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
    ---------------------------
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
    ----------------------
    "ORGM.Ammo_9x19mm_FMJ_Box",
    "ORGM.Ammo_10x25mm_FMJ_Box",
    "ORGM.Ammo_57x28mm_FMJ_Box",
    "ORGM.Ammo_556x45mm_FMJ_Box",
    "ORGM.Ammo_38Special_FMJ_Box",
    "ORGM.Ammo_45ACP_FMJ_Box",
    "ORGM.Ammo_308Winchester_FMJ_Box",
    "ORGM.Ammo_9x19mm_FMJ_Box",
}

if ORGMUtil.isLoaded("Hydrocraft") then
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

-----------------------------------------------------------------------------
-- reloadWeapon function
-- this needs to use the alternate ammos instead of dummy rounds.. it also needs
-- to properly reload so if the real player gets the gun later its actually useable
-- instead of having nerfed modData stats.
local reloadWeaponOriginal = nil
local reloadWeaponOverride = function(primary, player)
    if primary == nil or player == nil then
        return true
    end
    if primary:getModule() ~= "ORGM" then 
        -- not a orgm gun, call the original function
        return reloadWeaponOriginal(primary, player)
    end
    
    primary:setCondition(primary:getConditionMax())
    if primary:isRanged() == false then return true end
    local ammoType = getAmmoBullets(primary, false)			
    if ammoType == nil then return true end
    
    local modData = primary:getModData()
    modData.isJammed = nil -- lose any jammed flag
    if modData.roundChambered == 1 then return true end -- gun is already loaded
    if modData.currentCapacity and modData.currentCapacity > 0 then -- gun still has ammo, don't reload yet
        return true 
    end
    
    local secondaryHand = player:getSecondaryHandItem()
    local container = player:getInventory()
    local ammoItem = ORGMUtil.findAmmoInContainer(ammoType, 'any', container)
    if ammoItem == nil and secondaryHand ~= nil and secondaryHand:getCategory() == "Container" then
        container = secondaryHand:getItemContainer()
        ammoItem = ORGMUtil.findAmmoInContainer(ammoType, 'any', container)
    end
    if ammoItem == nil and player:getClothingItem_Back() ~= nil then 
        container = player:getClothingItem_Back():getItemContainer()
        ammoItem = ORGMUtil.findAmmoInContainer(ammoType, 'any', container)
    end
    if ammoItem == nil then return false end
    ammoType = ammoItem:getType()
    local ammoCount = container:getNumItems(ammoType)
    if SurvivorInfiniteAmmo then ammoCount = 999 end
    if ammoCount < 20 then player:Say("Almost out of ammo here!") end
    if ammoCount > 0 and (modData.actionType ~= "Rotary" and modData.actionType ~= "Break") then 
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


-----------------------------------------------------------------------------
-- giveWeapon function
-- this needs to call ORGMUtil.setupGun to properly setup the modData
-- it also needs to pick a alternate ammo instead of the dummy rounds
local giveWeaponOverride = function(player, weaponType, seenZombie)
    local weapon = InventoryItemFactory.CreateItem(weaponType)
    if weapon == nil then return end
    player:getInventory():AddItem(weapon)
    --local weapon = player:getInventory():AddItem(weaponType)
    
    local ammoType = nil
    if weapon:getModule() == "ORGM" then
        if WeaponUpgrades[weapon:getType()] then
            ItemPicker.doWeaponUpgrade(weapon)
        end

        ORGMUtil.setupGun(ReloadUtil:getWeaponData(weapon:getType()), weapon)
        ammoType = getAmmoBullets(weapon, false)
        if ORGMAlternateAmmoTable[ammoType] then
            local AmmoTbl = ORGMAlternateAmmoTable[ammoType]
            ammoType = "ORGM." .. AmmoTbl[ZombRand(#AmmoTbl) + 1] -- randomly pick ammo
        else -- huh?
            ammoType = "ORGM." .. ammoType
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

-- cant use OnGameStart, for survivor overrides, some survivors have already spawned, so use
-- OnGameBoot instead. However this will fail if the lua is reloaded while the game is running 
-- (debug mode reload?)...

Events.OnGameBoot.Add(function()
    if ORGMUtil.isLoaded("Survivors") == true and ORGMUtil.isLoaded("SurvivorsORGMPatch") == false then 
        print("ORGM Rechambered - Injecting Survivors Mod Overwrites")

        RangeWeapons = RangeWeaponsOverride
        reloadWeaponOriginal = reloadWeapon
        reloadWeapon = reloadWeaponOverride
        getWeapon = getWeaponOverride -- bugfix...not my bug :P
        giveWeapon = giveWeaponOverride
        getNPCLoot = getNPCLootOverride
        getRareNPCLoot = getRareNPCLootOverride

    end
end)
