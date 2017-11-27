--[[ ORGMUtil.lua

    This file contains helper functions designed to easy compatibility and integration of ORGM into other mods,
    as well as general utility functions that didn't belong anywhere else.

]]

ORGMUtil = {}


--[[

]]

function ORGMUtil.setupGun(gunData, item)
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
    modData.loadStyle = gunData.reloadStyle
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

    modData.weaponType = gunData.weaponType -- Rifle, SMG, Shotgun, Pistol, Revolver, LMG (currently not used)
    modData.actionType = gunData.actionType -- Auto, Pump, Lever, Rotary, Break
    modData.triggerType = gunData.triggerType -- SingleAction, DoubleAction
    modData.speedLoader = gunData.speedLoader -- speedloader/stripperclip name
    -- alternate action type, ie: semi auto that can also be pump, etc. This is a table list of all actionTypes used by the gun
    modData.altActionType = gunData.altActionType
    -- selectFire is nil for no selection possible, 0 if the weapon is CURRENTLY in semi-auto, 1 if CURRENTLY in full-auto
    modData.selectFire = gunData.selectFire
    
    if modData.actionType == "Rotary" or modData.actionType == "Break" then
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
    -- has this flagged (used when loading new mags to match self.preferredAmmoType)
    modData.loadedAmmo = nil 
end

--[[ ORGMUtil.setupMagazine(magazineType, item)
    
    Sets up a magazine. Basically the same as ReloadUtil:setupMagazine and ISORGMMagazine:setupReloadable
    but called without needing a player or reloadable object.
    
]]
function ORGMUtil.setupMagazine(magazineData, item)
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
    modData.maxCapacity = magazineData.maxCapacity or item:getClipSize()
    modData.reloadTime = magazineData.reloadTime or item:getReloadTime()
    modData.rackTime = magazineData.rackTime
    modData.currentCapacity = 0
    modData.clipType = magazineData.clipType
    modData.magazineData = { }
    modData.preferredAmmoType = 'any'
    modData.loadedAmmo = nil
end


function ORGMUtil.findBestMagazineInContainer(magazineType, preferredType, containerItem)
    if magazineType == nil then return nil end
    if ORGMMasterMagTable[magazineType] == nil then return nil end -- not a valid orgm mag
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
            ORGMUtil.setupMagazine(magazineData, currentItem)
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


--[[ ORGMUtil.findAmmoInContainer(dummyName, preferredType, containerItem)

    Finds the best matching ammo (bullets only) in a container based on the given
    dummy round name and preferred type (can be specific round name, nil/any, or mixed)

    returns a InventoryItem (not a string name)

    This is called when reloading some guns and all magazines, but placed here so mods
    like survivors can find the proper ammo without needing access to the actual reloadable
    object.
    
    Note dummyName and preferredType should NOT have the "ORGM." prefix.

]]
function ORGMUtil.findAmmoInContainer(dummyName, preferredType, containerItem)
    if dummyName == nil then return nil end
    if containerItem == nil then return nil end
    if preferredType == nil then preferredType = 'any' end
    
    if preferredType ~= "any" and preferredType ~= 'mixed' then
        -- a preferred ammo is set, we only look for these bullets
        return containerItem:FindAndReturn(preferredType)
    end
    
    -- this shouldn't actually be here, self.ammoType is just a dummy round
    local round = containerItem:FindAndReturn(dummyName)
    if round then return round end
    
    -- check if there are alternate ammo types we can use
    local roundTable = ORGMAlternateAmmoTable[dummyName]
    -- there should always be a entry, unless we were given a bad dummyName
    if roundTable == nil then return nil  end 
    
    if preferredType == 'mixed' then
        local options = {}
        for _, value in ipairs(roundTable) do
            -- check what rounds the player has
            if containerItem:FindAndReturn(value) then table.insert(options, value) end
        end
        -- randomly pick one
        return containerItem:FindAndReturn(options[ZombRand(#options) + 1])
        
    else -- not a random picking, go through the list in order
        for _, value in ipairs(roundTable) do
            round = containerItem:FindAndReturn(value)
            if round then return round end
        end
    end
    if round then return round end
    return nil
end

--[[ ORGMUtil.convertAllDummyRounds(dummyName, containerItem)
    
    Converts all dummy rounds of the given name to the first entry in the ORGMAlternateAmmoTable (FMJ or Buck)

]]
function ORGMUtil.convertAllDummyRounds(dummyName, containerItem)
    if dummyName == nil then return nil end
    if containerItem == nil then return nil end
    local roundTable = ORGMAlternateAmmoTable[dummyName]
    -- there should always be a entry, unless we were given a bad dummyName
    if roundTable == nil then return nil end
    local count = containerItem:getNumberOfItem(dummyName)
    if count == nil or count == 0 then return nil end
    containerItem:RemoveAll(dummyName)
    containerItem:AddItems('ORGM'.. roundTable[1], count)
end

function ORGMUtil.setWeaponProjectilePiercing(weapon, roundData)
    if roundData.PiercingBullets == true or roundData.PiercingBullets == false then
        weapon:setPiercingBullets(roundData.PiercingBullets)
    elseif roundData.PiercingBullets ~= nil then 
        local result = ZombRand(100) + 1
        if result <= roundData.PiercingBullets then
            weapon:setPiercingBullets(true)
        else
            weapon:setPiercingBullets(false)
        end
    end
end 
function ORGMUtil.setWeaponProjectileStats(weapon, roundData)
    if roundData.MaxDamage then weapon:setMaxDamage(roundData.MaxDamage) end
    if roundData.MinDamage then weapon:setMinDamage(roundData.MinDamage) end
    if roundData.CriticalChance then weapon:setCriticalChance(roundData.CriticalChance) end
    if roundData.DoorDamage then weapon:setDoorDamage(roundData.DoorDamage) end
    if roundData.HitChance then weapon:setHitChance(roundData.HitChance) end
    -- shotguns: we can't change the ProjectileCount for buckshot/slug swapping, theres no function for it.
    -- but we can change the MaxHitCount, so while the slug ends up firing multiple projectiles, only 1 will hit
    -- in testing this works.
    if roundData.MaxHitCount then weapon:setMaxHitCount(roundData.MaxHitCount) end
end