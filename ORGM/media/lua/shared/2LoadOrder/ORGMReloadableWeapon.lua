--[[- This module serves as a lower level API to the ISORGMWeapon class.

It allows for the data its operating on be either a ISReloadableWeapon class object,
or a HandWeapon/InventoryItem's modData.

@module ORGM.ReloadableWeapon
@release v3.10
@author Fenris_Wolf
@copyright 2018 **File:** shared/2LoadOrder/ORGMReloadableWeapon.lua

]]

local ORGM = ORGM
local Settings = ORGM.Settings
-- pull subtables of reloadable class functions into the global namespace.
local Reloadable = ORGM.ReloadableWeapon
local Fire = Reloadable.Fire
local Ammo = Reloadable.Ammo
local Magazine = Reloadable.Magazine
local Cylinder = Reloadable.Cylinder
local Bolt = Reloadable.Bolt
local Break = Reloadable.Break
local Reload = Reloadable.Reload
local Unload = Reloadable.Unload
local Rack = Reloadable.Rack
local Hammer = Reloadable.Hammer
local Status = Reloadable.Status

-- pull in some more locals as functions, avoiding conflicting namespaces.
local _Ammo = ORGM.Ammo
local _Magazine = ORGM.Magazine
local Firearm = ORGM.Firearm
local _Stats = ORGM.Firearm.Stats
local Flags = ORGM.Firearm.Flags

local Bit = BitNumber.bit32

local getSoundManager = getSoundManager
--local ISInventoryPage = ISInventoryPage
local InventoryItemFactory = InventoryItemFactory
local ZombRand = ZombRand


Status.SINGLESHOT = 8 -- Singleshot or semi auto mode
Status.FULLAUTO = 16 -- full-atuo mode.
Status.BURST2 = 32 -- fire 2 shot bursts
Status.BURST3 = 64 -- fire 3 shot bursts
Status.SAFETY = 128 -- manual safety
Status.OPEN = 256 -- slide/bolt is open.
Status.COCKED = 512 -- gun is currently cocked
Status.FORCEOPEN = 1024 -- user specifically requested gun should be open. To prevent normal reloading from auto racking.
local FIREMODESTATES = Status.SINGLESHOT+Status.FULLAUTO+Status.BURST2+Status.BURST3


Reloadable.isFeature = function(this, thisData, feature)
    return Firearm.isFeature(this.type, thisData, feature)
end
Reloadable.isStatus = function(this, status)
    if not this.status then return end
    return Bit.band(this.status, status) ~= 0
end
local function isForceOpen(this)
    return Reloadable.isStatus(this, Status.FORCEOPEN)
end


Reloadable.isFeed = function(this, feedType)
    if not this.feedSystem then return end
    return Bit.band(this.feedSystem, feedType) ~= 0
end
Reloadable.isRotary = function(this)
    return Reloadable.isFeed(this, Flags.ROTARY)
end
Reloadable.isBreak = function(this)
    return Reloadable.isFeed(this, Flags.BREAK)
end
Reloadable.isAuto = function(this)
    return Reloadable.isFeed(this, Flags.AUTO)
end
Reloadable.isPump = function(this)
    return Reloadable.isFeed(this, Flags.PUMP)
end
Reloadable.isLever = function(this)
    return Reloadable.isFeed(this, Flags.LEVER)
end




--- Firing Functions
-- @section Fire

--[[- Called when checking if a shot will attempt to fire when the trigger is pulled.

@usage ORGM.ReloadableWeapon.Fire.valid(weaponItem:getModData())
@tparam ISReloadableWeapon|HandWeapon:getModData() this

@treturn bool true if pulling the trigger 'should' fire the gun.

]]
Fire.valid = function(this)
    -- cant fire with a open slide
    if Bolt.isOpen(this) then
        if Firearm.isOpenBolt(this.type) and this.currentCapacity > 0 then
            return true
        end

        return false
    end
    if Fire.isSafe(this) then return false end
    -- single action with hammer at rest cant fire
    --
    if Firearm.Trigger.isSAO(this.type) and not Hammer.isCocked(this) then
        return false
    end


    if Reloadable.isRotary(this) then
        local ammoType = nil
        if Hammer.isCocked(this) then -- hammer is cocked, check this position
            ammoType = Ammo.get(this, this.cylinderPosition)
        else -- uncocked doubleaction, the chamber will rotate when the player pulls
            ammoType = Ammo.peek(this, true)
        end
        return ammoType and _Ammo.isAmmo(ammoType) or false
        --if ammoType == nil or _Ammo.isCase(ammoType) then return false end
        --return true

    elseif Reloadable.isBreak(this) then
        local ammoType = Ammo.get(this, this.cylinderPosition)
        return ammoType and _Ammo.isAmmo(ammoType) or false
        --if ammoType == nil or _Ammo.isCase(ammoType) then return false end
        --return true
    end

    -- anything else needs a live round chambered
    return this.chambered and _Ammo.isAmmo(this.chambered) or false
end

--[[- Called as just as the trigger is pulled.

@usage ORGM.ReloadableWeapon.Fire.pre(weaponItem:getModData(), playerObj, weaponItem)
@tparam ISReloadableWeapon|HandWeapon:getModData() this
@tparam IsoPlayer playerObj
@tparam HandWeapon weaponItem

]]
Fire.pre = function(this, playerObj, weaponItem)
    -- check for dud round, hangfire and other malfunctions
    -- check mechanical failures and malfunctions
    -- check squib
    -- check for dud, note dud should probably behave as fire empty
    -- open bolt designs need to close and feed the round


    -- SA already has hammer cocked by this point, but we dont need to check here.
    Hammer.cock(this, playerObj, false, weaponItem) -- chamber rotates here for revolvers
    Hammer.release(this, playerObj, false)

    if Firearm.isOpenBolt(this.type) then
        Bolt.close(this, playerObj, false, weaponItem)
    end

    -- set piercing bullets here.
    local ammoData = _Ammo.getData(this.setAmmoType)
    if not ammoData then return true end -- loaded but no setAmmoType?
    _Stats.setPenetration(weaponItem, ammoData.Penetration)
    return true
end


--[[- Called after the trigger is pulled.

@usage ORGM.ReloadableWeapon.Fire.post(weaponItem:getModData(), playerObj, weaponItem)
@tparam ISReloadableWeapon|HandWeapon:getModData() this
@tparam IsoPlayer playerObj
@tparam HandWeapon weaponItem

]]
Fire.post = function(this, playerObj, weaponItem)
    local ammoData = _Ammo.getData(this.magazineData[this.cylinderPosition])
    --this.roundsSinceCleaned = this.roundsSinceCleaned + 1
    this.roundsFired = 1 + this.roundsFired
    if Reloadable.isAuto(this) then
        --fire shot

        this.chambered = ammoData and ammoData.Case or nil
        Bolt.open(this, playerObj, false, weaponItem)
        if (this.currentCapacity ~= 0 or not Firearm.hasSlideLock(weaponItem)) and not Firearm.isOpenBolt(this.type) then
            Bolt.close(this, playerObj, false, weaponItem) -- chambers next shot, cocks hammer for SA/DA
        end

    elseif Reloadable.isRotary(this) then
        -- fire shot
        local ammoData = _Ammo.getData(this.magazineData[this.cylinderPosition])
        this.magazineData[this.cylinderPosition] = ammoData and ammoData.Case or nil
        this.currentCapacity = this.currentCapacity - 1

    elseif Reloadable.isBreak(this) then
        -- fire shot
        local ammoData = _Ammo.getData(this.magazineData[this.cylinderPosition])
        this.magazineData[this.cylinderPosition] = ammoData and ammoData.Case or nil
        this.currentCapacity = this.currentCapacity - 1
        this.cylinderPosition = this.cylinderPosition + 1 -- this can bypass our maxCapacity limit
        -- TODO: if there are barrels left, auto recock the hammer (dual hammer double barrels)
        if this.magazineData[this.cylinderPosition] then -- set the next round
            Ammo.setCurrent(this, this.magazineData[this.cylinderPosition], weaponItem)
        end

    else -- bolt, lever,and pump actions
        -- fire shot
        this.chambered = ammoData and ammoData.Case or nil
    end
end

--[[- Called when the trigger is pulled on a empty chamber.

@usage ORGM.ReloadableWeapon.Fire.dry(weaponItem:getModData(), playerObj, weaponItem)
@tparam ISReloadableWeapon|HandWeapon:getModData() this
@tparam IsoPlayer playerObj
@tparam HandWeapon weaponItem

]]
Fire.dry = function(this, playerObj, weaponItem)
    if Hammer.isCocked(this) then
        Hammer.release(this, playerObj, false)
    elseif not Firearm.Trigger.isSAO(this.type) then
        Hammer.cock(this, playerObj, false, weaponItem)
        Hammer.release(this, playerObj, false)
    end
end

--[[- Sets the position of the Select Fire switch.

@tparam ISReloadableWeapon|HandWeapon:getModData() this
@tparam[opt] nil|int mode If nil, a random valid fire mode is selected.

]]
Fire.set = function(this, mode)
    if not mode then
        -- find all firing modes allowed
        local thisData = Firearm.getData(this.type)
        local opt = {}
        if thisData:isSemiAuto() then table.insert(opt, Status.SINGLESHOT) end
        if thisData:isFullAuto() then table.insert(opt, Status.FULLAUTO) end
        if thisData:is2ShotBurst() then table.insert(opt, Status.BURST2) end
        if thisData:is3ShotBurst() then table.insert(opt, Status.BURST3) end
        if #opt == 0 then
            mode = Status.SINGLESHOT
        else
            mode = opt[ZombRand(#opt) +1]
        end
    end
    this.status = this.status - Bit.band(this.status, FIREMODESTATES) + mode
    return mode
end

Fire.isFullAuto = function(this)
    return Reloadable.isStatus(this, Status.FULLAUTO)
end

Fire.isSingle = function(this)
    return Reloadable.isStatus(this, Status.SINGLESHOT)
end

Fire.is2ShotBurst = function(this)
    return Reloadable.isStatus(this, Status.BURST2)
end

Fire.is3ShotBurst = function(this)
    return Reloadable.isStatus(this, Status.BURST3)
end

Fire.isSafe = function(this)
    return Reloadable.isStatus(this, Status.SAFETY)
end

Fire.safe = function(this, engage)
    local isSafe = Fire.isSafe(this)
    if not isSafe and engage then
        this.status = this.status + Status.SAFETY
    elseif isSafe and not engage then
        this.status = this.status - Status.SAFETY
    end
end

--- Reloading Functions
-- @section Reload


--[[- Checks if a reload action can be performed.

@usage ORGM.ReloadableWeapon.Reload.valid(weaponItem:getModData(), playerObj)
@tparam ISReloadableWeapon|HandWeapon:getModData() this
@tparam IsoPlayer playerObj

@return boolean, true if a reload action can be performed, otherwise false.

]]
Reload.valid = function(this, playerObj)
    local result = false
    if this.speedLoader ~= nil then
        local speed = Magazine.findBest(this, playerObj, this.speedLoader)
        -- we have a speedLoader, check if its .max is less then .max - .current
        -- ie: a gun that holds 10 rounds but uses a 5 round loader must have at least 5 rounds free
        if speed and (this.magazineType or not Firearm.hasMagazine(this.type)) then
            speed = speed:getModData()
            if speed.currentCapacity > 0 then
                -- revolver will dump out all ammo prior to load anyways, so capacity checks don't matter
                if Reloadable.isRotary(this) and this.maxCapacity ~= this.currentCapacity then
                    return true
                -- rifles however, do
                elseif speed.maxCapacity <= this.maxCapacity - this.currentCapacity then
                    return true
                end
            end
        end
    end

    if this.magazineType then -- a magazine is currently in place, we can unload
        result = true
    elseif Firearm.hasMagazine(this.type) then -- gun uses magazines, but none loaded. check if player has some
        result = Magazine.findBest(this, playerObj, this.ammoType) ~= nil
    else -- doesn't use a clip, check for speedloaders or bullets
        if this.currentCapacity == this.maxCapacity then -- gun already at full
            result = false
        elseif this.currentCapacity < this.maxCapacity then -- check for bullets
            result = Ammo.findBest(this, playerObj) ~= nil
        end
    end
    return result
end

--[[- Called at the start of a reload action.

This mostly just plays sounds, and opens the break barrel (for shotguns)
or revolver cylinder.

@usage ORGM.ReloadableWeapon.Reload.start(weaponItem:getModData(), playerObj, weaponItem)
@tparam ISReloadableWeapon|HandWeapon:getModData() this
@tparam IsoPlayer playerObj
@tparam HandWeapon weaponItem

]]
Reload.start = function(this, playerObj, weaponItem)
    -- NOTE: weaponItem is nil! not passed from ISORGMWeapon:reloadStart
    local tData = Firearm.getData(this.type)
    if this.magazineType then
        --getSoundManager():PlayWorldSound(this.ejectSound, playerObj:getSquare(), 0, 10, 1.0, false)
        playerObj:playSound(tData.ejectSound, false)
    elseif Firearm.hasMagazine(this.type) then --
        --getSoundManager():PlayWorldSound(this.insertSound, playerObj:getSquare(), 0, 10, 1.0, false)
        playerObj:playSound(tData.insertSound, false)
    else
        if Reloadable.isRotary(this) then
            -- TODO: this needs to sync, causes issues,
            Cylinder.open(this, playerObj, true, weaponItem) -- play the open sound
            -- if rotary and contains spent shells, we need to empty the cylinder. this is all or nothing
            if Ammo.hasCases(this) > 0 then
                Ammo.ejectAll(this, playerObj, true)
            end
        elseif Reloadable.isBreak(this) then
            Break.open(this, playerObj, true, weaponItem)
        end
    end
end


--[[- Called at successful completion of the reload action.

@usage ORGM.ReloadableWeapon.Reload.perform(weaponItem:getModData(), playerObj, weaponItem)
@tparam ISReloadableWeapon|HandWeapon:getModData() this
@tparam IsoPlayer playerObj
@tparam HandWeapon weaponItem

@treturn bool false if the reloading should stop

]]
Reload.perform = function(this, playerObj, weaponItem)
    local tData = Firearm.getData(this.type)

    if this.speedLoader ~= nil then
        local speed = Magazine.findBest(this, playerObj, this.speedLoader)
        -- we have a speedLoader, check if its .max is less then .max - .current
        -- ie: a gun that holds 10 rounds but uses a 5 round loader must have at least 5 rounds free
        if speed and this.containsClip ~= 0 then
            speed = speed:getModData()
            if speed.currentCapacity > 0 and speed.maxCapacity <= this.maxCapacity - this.currentCapacity then
                playerObj:playSound(tData.insertSound, false)
                --getSoundManager():PlayWorldSound(this.insertSound, playerObj:getSquare(), 0, 10, 1.0, false)
                for i=1, speed.maxCapacity do repeat
                    if speed.magazineData[i] == nil then break end
                    Ammo.load(this, speed.magazineData[i], weaponItem)
                    speed.magazineData[i] = nil
                    speed.currentCapacity = speed.currentCapacity - 1
                until true end
                speed.loadedAmmoType = nil
                playerObj:getXp():AddXP(Perks.Reloading, 1)
                return false
            end
        end
    end

    if Firearm.hasMagazine(this.type) then
        if this.magazineType then -- eject the current clip
            Magazine.eject(this, playerObj, false)
        else
            Magazine.insert(this, playerObj, false)
        end
        return false

    else -- internal mag, rotary or break barrel
        local ammoItem = Ammo.findBest(this, playerObj)
        if not ammoItem then return end
        local ammoType = ammoItem:getType()
        if Reloadable.isRotary(this) then
            Cylinder.rotate(this, 1, playerObj, true, weaponItem)
            if this.magazineData[this.cylinderPosition] ~= nil then -- something is in this spot, return now
                return true
            end
        end
        --getSoundManager():PlayWorldSound(this.insertSound, playerObj:getSquare(), 0, 10, 1.0, false)
        playerObj:playSound(tData.insertSound, false)

        Ammo.load(this, ammoType, weaponItem, this.cylinderPosition) -- cylinderPosition will be nil for non-rotary
        if Reloadable.isBreak(this) then
            this.cylinderPosition = this.cylinderPosition + 1 -- increment to load the next chamber, it resets on close
        end
        -- remove the necessary ammo
        playerObj:getInventory():RemoveOneOf(ammoType)
        playerObj:getXp():AddXP(Perks.Reloading, 1)
        return false
        --if self.currentCapacity == self.maxCapacity then
        --    return false
        --end
        --return true
    end
    return true
end

--- Unloading Functions
-- @section Unload

--[[- Checks if a unload action can be performed.

@usage ORGM.ReloadableWeapon.Unload.valid(weaponItem:getModData(), playerObj)
@tparam ISReloadableWeapon|HandWeapon:getModData() this
@tparam IsoPlayer playerObj

@treturn bool true if a unload action can be performed

]]
Unload.valid = function(this, playerObj)
    if this.currentCapacity > 0 then return true end
    if this.chambered then
        return true
    end
    return false
end

--[[- Called at the start of a unload action.

This mostly just plays sounds, and opens the break barrel (for shotguns)
or revolver cylinder.

@usage ORGM.ReloadableWeapon.Unload.start(weaponItem:getModData(), playerObj, weaponItem)
@tparam ISReloadableWeapon|HandWeapon:getModData() this
@tparam IsoPlayer playerObj
@tparam HandWeapon weaponItem

]]
Unload.start = function(this, playerObj, weaponItem)
    -- we dont actually need to do anything here
    return
end

--[[- Called at successful completion of the unload action.

@usage ORGM.ReloadableWeapon.Unload.perform(weaponItem:getModData(), playerObj, weaponItem)
@tparam ISReloadableWeapon|HandWeapon:getModData() this
@tparam IsoPlayer playerObj
@tparam HandWeapon weaponItem

@treturn bool false if the unloading should stop

]]
Unload.perform = function(this, playerObj, weaponItem)
    if Reloadable.isRotary(this) then
        Cylinder.open(this, playerObj, true)
        -- revolvers drop them all at once
        Ammo.ejectAll(this, playerObj, false)
        return false
    elseif Reloadable.isBreak(this) then
        Break.open(this, playerObj, false, weaponItem)
        return false
    end
    -- we can just rack the weaponItem to unload it
    Rack.perform(this, playerObj, weaponItem)
    return false
end

--- Magazine Functions
-- @section Magazine

--[[- Ejects the current magazine and adds it to the players inventory.

@usage ORGM.ReloadableWeapon.Magazine.eject(weaponItem:getModData(), playerObj, true)

@tparam ISReloadableWeapon|HandWeapon:getModData() this
@tparam IsoPlayer playerObj
@tparam[opt] bool playSound if true plays the ejectSound

]]
Magazine.eject = function(this, playerObj, playSound)
    local clip = Magazine.create(this, playerObj)
    this.currentCapacity = 0
    this.maxCapacity = 0
    this.magazineData = {}
    playerObj:getInventory():AddItem(clip)
    ISInventoryPage.dirtyUI()
    this.magazineType = nil
    this.loadedAmmoType = nil -- might still have a round in chamber, but this is only required for magazine setup anyways
    local tData = Firearm.getData(this.type)

    if (playSound and tData.ejectSound) then playerObj:playSound(tData.ejectSound, false) end
end


--[[- Inserts the best magazine from the players inventory into the firearm.

@usage ORGM.ReloadableWeapon.Magazine.insert(weaponItem:getModData(), playerObj, true)

@tparam ISReloadableWeapon|HandWeapon:getModData() this
@tparam IsoPlayer playerObj
@tparam[opt] bool playSound if true plays the insertSound

]]
Magazine.insert = function(this, playerObj, playSound)
    local magItem = Magazine.findBest(this, playerObj, this.ammoType)

    if magItem == nil then return end
    modData = magItem:getModData()
    local magData = _Magazine.getData(magItem)
    if modData.currentCapacity > magData.maxCapacity then
        -- this mag is holding more then it should. possibly was loaded in a previous
        -- ORGM version and the maxCapacity has changed.
        playerObj:Say("Magazine contains more then it should. Sending some rounds back to inventory")
        local container = playerObj:getInventory()
        for i=magData.maxCapacity+1, modData.currentCapacity do
            local round = modData.magData[i]
            modData.magData[i] = nil
            container:AddItem(_Ammo.getData(round).moduleName ..'.'.. round)
        end
        modData.currentCapacity = magData.maxCapacity
    end
    -- TODO: flag more of the magazines mod data, faulty ammo and its positions
    this.currentCapacity = modData.currentCapacity
    this.maxCapacity = modData.maxCapacity
    this.magazineData = modData.magazineData
    this.magazineType = modData.type
    playerObj:getInventory():Remove(magItem)
    ISInventoryPage.dirtyUI()
    this.loadedAmmoType = modData.loadedAmmoType
    playerObj:getXp():AddXP(Perks.Reloading, 1)

    local tData = Firearm.getData(this.type)
    if (playSound and tData.insertSound) then playerObj:playSound(tData.insertSound, false) end
end

--[[- Creates a new magazine InventoryItem with modData.

This is called on ReloadableWeapon.Magazine.eject()
Copies some data from the firearm into the magazines modData, setting up the ammo count.
@usage local magItem = ORGM.ReloadableWeapon.Magazine.create(weaponItem:getModData(), playerObj)

@tparam ISReloadableWeapon|HandWeapon:getModData() this
@tparam IsoPlayer playerObj

@treturn InventoryItem the magazine with setup modData.

]]
Magazine.create = function(this, playerObj)
    local magData = _Magazine.getData(this.magazineType)
    local item = InventoryItemFactory.CreateItem(magData.moduleName .. '.' .. magData.type)
    magData:setup(item)
    --ReloadUtil:setupMagazine(magItem, magData, playerObj)
    modData = item:getModData()
    -- TODO: transfer faulty ammo back to the magazine.
    modData.currentCapacity = this.currentCapacity
    modData.magazineData = this.magazineData
    modData.strictAmmoType = this.stictAmmoType
    modData.loadedAmmoType = this.loadedAmmoType
    return item
end

--[[- Sets up the ISReloadableMagazine on the InventoryItem

@usage ORGM.ReloadableWeapon.Magazine.setup(weaponItem:getModData(), magItem, playerObj)
@tparam ISReloadableWeapon|HandWeapon:getModData() this
@tparam InventoryItem magItem the magazine to setup
@tparam IsoPlayer playerObj

]]
Magazine.setup = function(this, magItem, playerObj)
    local magData = _Magazine.getData(magItem)
    ReloadUtil:setupMagazine(magItem, magData, playerObj)
end

--[[- Finds and returns the best magazine available in the players inventory.

@usage local magItem = ORGM.ReloadableWeapon.Magazine.findBest(weaponItem:getModData(), playerObj, nil)
@tparam ISReloadableWeapon|HandWeapon:getModData() this
@tparam IsoPlayer playerObj
@tparam nil|string ammoType name of a registered ORGM magazine, auto detected if nil

@treturn nil|InventoryItem the best suited magazine
@see ORGM.Magazine.findIn

]]
Magazine.findBest = function(this, playerObj, ammoType)
    if ammoType == nil then ammoType = this.ammoType end
    return _Magazine.getGroup(ammoType):find(this.strictAmmoType, playerObj:getInventory())
    --return _Magazine.findIn(ammoType, this.strictAmmoType, playerObj:getInventory())
end

--- Ammo Functions
-- @section Ammo

--[[- Loads a round into the firearm (internal magazine or cylinder).

@usage ORGM.ReloadableWeapon.Ammo.load(weaponItem:getModData(), "Ammo_9x19mm_FMJ", weaponItem, nil)
@tparam ISReloadableWeapon|HandWeapon:getModData() this
@tparam string ammoType name of a registered ORGM ammo
@tparam HandWeapon weaponItem
@tparam[opt] int position to insert the round at. If nil it is appended to the list.

]]
Ammo.load = function(this, ammoType, weaponItem, position)
    -- TODO: ammoType should allow for InventoryItems, so we can check for modData
    -- and flag any faulty ammo
    if this.currentCapacity == this.maxCapacity then return end
    this.currentCapacity = this.currentCapacity + 1
    if position == nil then position = this.currentCapacity end
    this.magazineData[position] = Ammo.convert(this, ammoType)

    if this.loadedAmmoType == nil then
        this.loadedAmmoType = ammoType
    elseif this.loadedAmmoType ~= ammoType then
        this.loadedAmmoType = 'mixed'
    end
end


--[[- Converts a AmmoGroup round to a real round if required.

This is a safety check performed to ensure we can properly get the ammo stats.

@usage local ammoType = ORGM.ReloadableWeapon.Ammo.convert(weaponItem:getModData(), "Ammo_9x19mm",)
@tparam ISReloadableWeapon|HandWeapon:getModData() this
@tparam string ammoType name of a AmmoGroup or a registered ammo.

@treturn string name of the first ammo in the group or ammoType if a real ammo was already passed in.

]]
Ammo.convert = function(this, ammoType)
    local groupName = this.ammoType
    if this.containsClip ~= nil then -- get the mag's ammo type
        groupName = _Magazine.getData(this.ammoType).ammoType
    end
    if ammoType == groupName and _Ammo.getGroup(ammoType) ~= nil then -- a AmmoGroup round is being used
        ORGM.log(ORGM.DEBUG, "Converting AmmoGroup round ".. ammoType .. " > ".. _Ammo.getGroup(ammoType)[1])
        ammoType = _Ammo.getGroup(ammoType)[1]
    end
    return ammoType
end


--[[- Finds and returns the best ammo available in the players inventory.

@usage ORGM.ReloadableWeapon.Ammo.findBest(weaponItem:getModData(), playerObj)
@tparam ISReloadableWeapon|HandWeapon:getModData() this
@tparam IsoPlayer playerObj

@treturn nil|InventoryItem the best suited ammo
@see ORGM.Ammo.findIn

]]
Ammo.findBest = function(this, playerObj)
    return _Ammo.findIn(this.ammoType, this.strictAmmoType, playerObj:getInventory())
end

--[[- Gets the ammo at specified position.

@usage local ammoType = ORGM.ReloadableWeapon.Ammo.get(weaponItem:getModData(), position)
@tparam ISReloadableWeapon|HandWeapon:getModData() this
@tparam int position the index position to get

@treturn nil|string the ammo (or case) name at the position

]]
Ammo.get = function(this, position)
    return this.magazineData[position] -- arrays start at 1
end


--[[- Gets the ammo at the next position.

@usage local ammoType = ORGM.ReloadableWeapon.Ammo.peek(weaponItem:getModData(), true)
@tparam ISReloadableWeapon|HandWeapon:getModData() this
@tparam[opt] bool wrap if true wraps around the end of the list to the begining past maxCapacity. true for rotary actions.

@treturn nil|string ammo (or case) name at the next position

]]
Ammo.peek = function(this, wrap)
    if wrap then
        return this.magazineData[(this.cylinderPosition % this.maxCapacity) +1]
    end
    return this.magazineData[this.currentCapacity]
end


--[[- Ejects all shells (live and spent) onto the ground.

Used primarly with revolvers and break barrels on opening.

@usage ORGM.ReloadableWeapon.Ammo.ejectAll(weaponItem:getModData(), playerObj, true)

@tparam ISReloadableWeapon|HandWeapon:getModData() this
@tparam IsoPlayer playerObj
@tparam[opt] bool playSound if true plays the ejectSound

]]
Ammo.ejectAll = function(this, playerObj, playSound)
    if not Cylinder.isOpen(this) then return end
    local square = playerObj:getCurrentSquare()

    for index = 1, this.maxCapacity do
        local ammoType = this.magazineData[index]
        local ammoItem = nil
        if ammoType and _Ammo.isCase(ammoType) then -- eject shell
            if Settings.CasesEnabled then
                -- TODO: cases need proper module checking
                ammoItem = InventoryItemFactory.CreateItem('ORGM.' .. ammoType)
            end
        elseif ammoType then -- eject bullet
            ammoItem = Ammo.convert(this, ammoType)
            ammoItem = InventoryItemFactory.CreateItem(_Ammo.getData(ammoItem).moduleName..'.' .. ammoItem)
            -- TODO: check if this is faulty ammo and flag it
        end
        if (ammoItem and square) then
            square:AddWorldInventoryItem(ammoItem, 0, 0, 0)
        end
        this.magazineData[index] = nil
    end
    this.loadedAmmoType = nil
    this.currentCapacity = 0
end


--[[- Gets the number of empty cases in the magazine/cylinder.

@usage local count = ORGM.ReloadableWeapon.Ammo.hasCases(weaponItem:getModData())
@tparam ISReloadableWeapon|HandWeapon:getModData() this

@treturn int number of spent cases

]]
Ammo.hasCases = function(this)
    local count = 0
    for index = 1, this.maxCapacity do
        local ammoType = this.magazineData[index]

        if ammoType and _Ammo.isCase(ammoType) then
            count = count + 1
        end
    end
    return count
end

--[[- Loads the next round into the chamber

@usage ORGM.ReloadableWeapon.Ammo.next(weaponItem:getModData(), playerObj, weaponItem)
@tparam ISReloadableWeapon|HandWeapon:getModData() this
@tparam IsoPlayer playerObj
@tparam HandWeapon weaponItem

]]
Ammo.next = function(this, playerObj, weaponItem)
    if this.currentCapacity == 0 or this.currentCapacity == nil then
        this.loadedAmmoType = nil
        return
    end
    local ammoType = this.magazineData[this.currentCapacity]
    if ammoType == nil then -- problem, currentCapacity doesn't match our magazineData
        -- TODO: seems i missed filling out this part...
    end
    -- remove last entry from data table (Note: using #table to find the length is slow)
    -- TODO: check failure to feed jams here

    -- WARNING
    -- WARNING
    -- WARNING
    -- WARNING
    this.chambered = ammoType -- TODO: HEY! this is bad for revolvers! double check all instance of .chambered make sure we're not doing something stupid
    -- WARNING
    -- WARNING
    -- WARNING
    -- WARNING
    this.magazineData[this.currentCapacity] = nil
    this.currentCapacity = this.currentCapacity - 1
    -- a different round has been chambered, change the stats
    Ammo.setCurrent(this, ammoType, weaponItem)

    -- check for a jam
    if ORGM.Settings.JammingEnabled then
    --if ORGM.Settings.JammingEnabled or ORGM.PVAL > 1 then
        -- TODO: chances need to be more dynamic, it assumes a max condition of 10
        local chance = (weaponItem:getConditionMax() / weaponItem:getCondition()) *2
        if playerObj:HasTrait("Lucky") then
            chance = chance * 0.8
        elseif playerObj:HasTrait("Unlucky") then
            chance = chance * 1.2
        end
        -- if ORGM.PVAL > 1 then chance = chance + ORGM.PVAL end
        local result = ZombRand(300 - math.ceil(chance)*2)+1
        if result <= chance then
            this.isJammed = true
            weaponItem:getModData().isJammed = true
        end
    end
end


--[[- Triggers a recalcuation of firearm stats on ammo changes.

@usage ORGM.ReloadableWeapon.Ammo.setCurrent(weaponItem:getModData(), ammoType, weaponItem)
@tparam ISReloadableWeapon|HandWeapon:getModData() this
@tparam string ammoType name of the ammo in use
@tparam HandWeapon weaponItem

]]
Ammo.setCurrent = function(this, ammoType, weaponItem)
    if ammoType == nil or _Ammo.isCase(ammoType) then return end
    --ammoType = Ammo.convert(this, ammoType)
    local roundData = _Ammo.getData(ammoType)
    if roundData == nil then
        this.setAmmoType = nil
        --weaponItem:getModData().setAmmoType = nil -- NOTE: this seems redundant..left over junk?
        return
    end
    if ammoType ~= this.setAmmoType then
        print("----->", ammoType, tostring(this.setAmmoType))
        this.setAmmoType = ammoType -- this is also used if the slide is cycled again before firing, so we know what to eject
        --weaponItem:getModData().setAmmoType = ammoType
        _Stats.set(weaponItem)
    end
    -- NOTE: moved to Fire.pre
    -- _Stats.setPenetration_DEPRECIATED(weaponItem, roundData)
end


--- Racking Functions
-- @section Rack

--[[- Checks if the weapon can be racked.

On Easy/Normal reloading, this returns false if there is already a round chambered.
@usage local result = ORGM.ReloadableWeapon.rack.setCurrent(weaponItem:getModData(), playerObj)
@tparam ISReloadableWeapon|HandWeapon:getModData() this
@tparam IsoPlayer playerObj

@treturn bool true if the gun can be racked.

]]
Rack.valid = function(this, playerObj)
    if not Hammer.isCocked(this) and Firearm.Trigger.isSAO(this.type) then
        return true
    end
    if Reloadable.isBreak(this) or Reloadable.isRotary(this) then
        if Cylinder.isOpen(this) then return true end
        return false
    end
    if this.chambered and _Ammo.isCase(this.chambered) then return true end
    if ReloadManager[1]:getDifficulty() < 3 or playerObj:getJoypadBind() ~= -1 then
        -- TODO: proper jamming checks
        if this.isJammed then return true end

        if Firearm.isOpenBolt(this.type) and Bolt.isOpen(this) then
            return false
        end

        if Bolt.isOpen(this) and isForceOpen(this) then
            return true
        end
        -- TODO: check for rotary/break...just checking this.currentCapacity fails for them
        return (not this.chambered and not _Ammo.isAmmo(this.chambered)) and this.currentCapacity > 0
        --return this.roundChambered == 0 and this.currentCapacity > 0
    end

    return true
end


--[[- Called at the start of a rack action.

This mostly just plays sounds.

@usage ORGM.ReloadableWeapon.Rack.start(weaponItem:getModData(), playerObj, weaponItem)
@tparam ISReloadableWeapon|HandWeapon:getModData() this
@tparam IsoPlayer playerObj
@tparam HandWeapon weaponItem

]]
Rack.start = function(this, playerObj, weaponItem)
    return
end


--[[- Called at successful completion of a rack action.

@usage ORGM.ReloadableWeapon.Rack.perform(weaponItem:getModData(), playerObj, weaponItem)
@tparam ISReloadableWeapon|HandWeapon:getModData() this
@tparam IsoPlayer playerObj
@tparam HandWeapon weaponItem

]]
Rack.perform = function(this, playerObj, weaponItem)
    if Reloadable.isBreak(this) then
        Break.close(this, playerObj, true, weaponItem)

    elseif Reloadable.isRotary(this) then
        Cylinder.close(this, playerObj, true, weaponItem)

    else
        --getSoundManager():PlayWorldSound(this.rackSound, playerObj:getSquare(), 0, 10, 1.0, false)
        local tData = Firearm.getData(this.type)
        playerObj:playSound(tData.rackSound, false)
        Bolt.open(this, playerObj, false, weaponItem)
        if not Firearm.isOpenBolt(this.type) then
            Bolt.close(this, playerObj, false, weaponItem)
        end
    end

    if not Hammer.isCocked(this) and Firearm.Trigger.isSAO(this.type) then
        Hammer.cock(this, playerObj, true, weaponItem) -- play the cock sound
    end
end


--- Hammer Functions
-- @section Hammer


--[[- Cocks the hammer and rotates the cylinder for Rotary actionType.

@usage ORGM.ReloadableWeapon.Hammer.cock(weaponItem:getModData(), playerObj, true, weaponItem)
@tparam ISReloadableWeapon|HandWeapon:getModData() this
@tparam IsoPlayer playerObj
@tparam nil|bool playSound if true plays the cockSound
@tparam HandWeapon weaponItem

]]
Hammer.cock = function(this, playerObj, playSound, weaponItem)
    -- rotary cylinders rotate the chamber when the hammer is cocked
    if Hammer.isCocked(this) then return end
    if Reloadable.isRotary(this) and not Bolt.isOpen(this) then
        Cylinder.rotate(this, 1, playerObj, false, weaponItem)
    end
    local tData = Firearm.getData(this.type)
    if (playSound and tData.cockSound) then playerObj:playSound(tData.cockSound, false) end
    this.status = this.status + Status.COCKED
end

--[[- Releases a cocked hammer.

@usage ORGM.ReloadableWeapon.Hammer.release(weaponItem:getModData(), playerObj, true)
@tparam ISReloadableWeapon|HandWeapon:getModData() this
@tparam IsoPlayer playerObj
@tparam nil|bool playSound not used atm

]]
Hammer.release = function(this, playerObj, playSound)
    if not Hammer.isCocked(this) then return end
    this.status = this.status - Status.COCKED
end

Hammer.isCocked = function(this)
    return Reloadable.isStatus(this, Status.COCKED)
end
--- Bolt Functions
-- @section Bolt

--[[- tests if the bolt is open.

@usage ORGM.ReloadableWeapon.Bolt.isOpen(weaponItem:getModData())
@tparam ISReloadableWeapon|HandWeapon:getModData() this
@treturn bool true if the bolt is currently open.

]]

Bolt.isOpen = function(this)
    return Reloadable.isStatus(this, Status.OPEN)
end

--[[- Opens the bolt, ejecting whatever is currently in the chamber onto the ground.

@usage ORGM.ReloadableWeapon.Bolt.open(weaponItem:getModData(), playerObj, true, weaponItem)
@tparam ISReloadableWeapon|HandWeapon:getModData() this
@tparam IsoPlayer playerObj
@tparam nil|bool playSound if true plays the openSound
@tparam HandWeapon weaponItem

]]
Bolt.open = function(this, playerObj, playSound, weaponItem)
    if Bolt.isOpen(this) then return end -- already opened!
    -- first open the slide...
    this.status = this.status + Status.OPEN
    -- TODO: fix sound
    local tData = Firearm.getData(this.type)

    if (playSound and tData.openSound) then playerObj:playSound(tData.openSound, false) end
    local square = playerObj:getCurrentSquare()
    local ammoType = this.chambered
    this.chambered = nil
    local ammoItem = InventoryItemFactory.CreateItem('ORGM.'.. this.ammoType)
    -- TODO: check if its a case and Settings.CasesEnabled

    -- TODO: check failure to extract
    this.isJammed = nil
    -- TODO: check failure to eject

    if (ammoItem and square) then
        -- TODO: fall out sound
        square:AddWorldInventoryItem(ammoItem, 0, 0, 0)
        ISInventoryPage.dirtyUI()
    end
end

--[[- Closes the bolt and chambers the next round.

Single and Double actions this also cocks the hammer.

@usage ORGM.ReloadableWeapon.Bolt.close(weaponItem:getModData(), playerObj, true, weaponItem)
@tparam ISReloadableWeapon|HandWeapon:getModData() this
@tparam IsoPlayer playerObj
@tparam nil|bool playSound if true plays the closeSound
@tparam HandWeapon weaponItem

]]
Bolt.close = function(this, playerObj, playSound, weaponItem)
    if not Bolt.isOpen(this) then return end -- already closed!
    if not Firearm.Trigger.isDAO(this.type) then
        Hammer.cock(this, playerObj, false, weaponItem)
    end
    if isForceOpen(this) then this.status = this.status - Status.FORCEOPEN end
    this.status = this.status - Status.OPEN
    -- TODO: fix sound
    local tData = Firearm.getData(this.type)
    if (playSound and tData.closeSound) then playerObj:playSound(tData.closeSound, false) end
    -- TODO: load next shot, this isn't always true though:
    -- a pump action shotgun reloaded with slide open wont chamber a round, THIS NEEDS TO BE HANDLED
    -- open bolt designs dont chamber at all until firing.

    Ammo.next(this, playerObj, weaponItem)
end


--- Cylinder Functions
-- @section Cylinder

--[[- tests if the cylinder is open.

@usage ORGM.ReloadableWeapon.Cylinder.isOpen(weaponItem:getModData())
@tparam ISReloadableWeapon|HandWeapon:getModData() this
@treturn bool true if the cylinder is currently open.

]]

Cylinder.isOpen = function(this)
    return Reloadable.isStatus(this, Status.OPEN)
end


--[[- Rotates the cylinder by the specified amount.

@usage ORGM.ReloadableWeapon.Cylinder.rotate(weaponItem:getModData(), 1, playerObj, true, weaponItem)
@tparam ISReloadableWeapon|HandWeapon:getModData() this
@tparam int count Number of positions to rotate. If nil or 0, randomly selects (chamber spin)
@tparam IsoPlayer playerObj
@tparam nil|bool playSound not used atm
@tparam HandWeapon weaponItem

]]
Cylinder.rotate = function(this, count, playerObj, playSound, weaponItem)
    local position = this.cylinderPosition
    if (count == nil or count == 0) then -- random count
        count = ZombRand(this.maxCapacity)+1
    end
    this.cylinderPosition = ((this.cylinderPosition - 1 + count) % this.maxCapacity) +1
    Ammo.setCurrent(this, this.magazineData[this.cylinderPosition], weaponItem)
end


--[[- Opens the cylinder.

@usage ORGM.ReloadableWeapon.Cylinder.open(weaponItem:getModData(), playerObj, true, weaponItem)
@tparam ISReloadableWeapon|HandWeapon:getModData() this
@tparam IsoPlayer playerObj
@tparam nil|bool playSound if true plays the openSound
@tparam HandWeapon weaponItem

]]
Cylinder.open = function(this, playerObj, playSound, weaponItem)
    if Cylinder.isOpen(this) then return end
    this.status = this.status + Status.OPEN
    local tData = Firearm.getData(this.type)
    if (playSound and tData.openSound) then playerObj:playSound(tData.openSound, false) end
end

--[[- Closes the cylinder and sets the current round.

@usage ORGM.ReloadableWeapon.Cylinder.close(weaponItem:getModData(), playerObj, true, weaponItem)
@tparam ISReloadableWeapon|HandWeapon:getModData() this
@tparam IsoPlayer playerObj
@tparam nil|bool playSound if true plays the closeSound
@tparam HandWeapon weaponItem

]]
Cylinder.close = function(this, playerObj, playSound, weaponItem)
    if not Cylinder.isOpen(this) then return end
    if isForceOpen(this) then this.status = this.status - Status.FORCEOPEN end
    this.status = this.status - Status.OPEN
    Ammo.setCurrent(this, this.magazineData[this.cylinderPosition], weaponItem)
    local tData = Firearm.getData(this.type)
    if (playSound and tData.closeSound) then playerObj:playSound(tData.closeSound, false) end
end

--- Break Barrel Functions
-- @section Break

--[[- tests if the breach is open.

@usage ORGM.ReloadableWeapon.Break.isOpen(weaponItem:getModData())
@tparam ISReloadableWeapon|HandWeapon:getModData() this
@treturn bool true if the breach is currently open.

]]

Break.isOpen = function(this)
    return Reloadable.isStatus(this, Status.OPEN)
end

--[[- Opens the breech and ejects any shells.

@usage ORGM.ReloadableWeapon.Break.open(weaponItem:getModData(), playerObj, true, weaponItem)
@tparam ISReloadableWeapon|HandWeapon:getModData() this
@tparam IsoPlayer playerObj
@tparam nil|bool playSound if true plays the openSound
@tparam HandWeapon weaponItem

]]
Break.open = function(this, playerObj, playSound, weaponItem)
    if Break.isOpen(this) then return end
    this.status = this.status + Status.OPEN
    this.cylinderPosition = 1 -- use cylinder position variable for which barrel to fire, set to 1 for reloading
    local tData = Firearm.getData(this.type)
    if (playSound and tData.openSound) then playerObj:playSound(tData.openSound, false) end
    Ammo.ejectAll(this, playerObj, false)
end


--[[- Closes the breech and sets the current round.

@usage ORGM.ReloadableWeapon.Break.close(weaponItem:getModData(), playerObj, true, weaponItem)
@tparam ISReloadableWeapon|HandWeapon:getModData() this
@tparam IsoPlayer playerObj
@tparam nil|bool playSound if true plays the closeSound
@tparam HandWeapon weaponItem

]]
Break.close = function(this, playerObj, playSound, weaponItem)
    if not Break.isOpen(this) then return end
    if isForceOpen(this) then this.status = this.status - Status.FORCEOPEN end
    this.status = this.status - Status.OPEN
    this.cylinderPosition = 1 -- use cylinder position variable for which barrel to fire
    Ammo.setCurrent(this, this.magazineData[1], weaponItem)
    local tData = Firearm.getData(this.type)
    if (playSound and tData.closeSound) then playerObj:playSound(tData.closeSound, false) end
end
