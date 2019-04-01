--[[- This module serves as a lower level API to the ISORGMWeapon class.

It allows for the data its operating on be either a ISReloadableWeapon class object,
or a HandWeapon/InventoryItem's modData.

@module ORGM.ReloadableWeapon
@release v3.09
@author Fenris_Wolf
@copyright 2018 **File:** shared/2LoadOrder/ORGMReloadableWeapon.lua

]]

local ORGM = ORGM
local Settings = ORGM.Settings
-- pull subtables of reloadable class functions into the global namespace.
local Fire = ORGM.ReloadableWeapon.Fire
local Ammo = ORGM.ReloadableWeapon.Ammo
local Magazine = ORGM.ReloadableWeapon.Magazine
local Cylinder = ORGM.ReloadableWeapon.Cylinder
local Bolt = ORGM.ReloadableWeapon.Bolt
local Break = ORGM.ReloadableWeapon.Break
local Reload = ORGM.ReloadableWeapon.Reload
local Unload = ORGM.ReloadableWeapon.Unload
local Rack = ORGM.ReloadableWeapon.Rack
local Hammer = ORGM.ReloadableWeapon.Hammer

-- pull in some more locals as functions, avoiding conflicting namespaces.
local _Ammo = ORGM.Ammo
local _Magazine = ORGM.Magazine
local _Stats = ORGM.Firearm.Stats

local getSoundManager = getSoundManager
--local ISInventoryPage = ISInventoryPage
local InventoryItemFactory = InventoryItemFactory
local ZombRand = ZombRand
--- Firing Functions
-- @section Fire

--[[- Called when checking if a shot will attempt to fire when the trigger is pulled.

@usage ORGM.Reloadable.Fire.valid(weaponItem:getModData())
@tparam ISReloadableWeapon|HandWeapon:getModData() this

@treturn bool true if pulling the trigger 'should' fire the gun.

]]
function Fire.valid(this)
    -- cant fire with a open slide
    if this.isOpen == 1 then
        return false
    end
    -- single action with hammer at rest cant fire
    if (this.hammerCocked == 0 and this.triggerType == ORGM.SINGLEACTION) then
        return false
    end

    if this.actionType == ORGM.ROTARY then
        local ammoType = nil
        if this.hammerCocked == 1 then -- hammer is cocked, check this position
            ammoType = Ammo.get(this, this.cylinderPosition)
        else -- uncocked doubleaction, the chamber will rotate when the player pulls
            ammoType = Ammo.peek(this, true)
        end
        if ammoType == nil or _Ammo.isCase(ammoType) then return false end
        return true

    elseif this.actionType == ORGM.BREAK then
        local ammoType = Ammo.get(this, this.cylinderPosition)
        if ammoType == nil or _Ammo.isCase(ammoType) then return false end
        return true
    end

    -- anything else needs a live round chambered
    return this.roundChambered > 0
end

--[[- Called as just as the trigger is pulled.

@usage ORGM.Reloadable.Fire.pre(weaponItem:getModData(), playerObj, weaponItem)
@tparam ISReloadableWeapon|HandWeapon:getModData() this
@tparam IsoPlayer playerObj
@tparam HandWeapon weaponItem

]]
function Fire.pre(this, playerObj, weaponItem)
    -- check for dud round, hangfire and other malfunctions
    -- check mechanical failures and malfunctions
    -- check squib
    -- check for dud, note dud should probably behave as fire empty

    -- set piercing bullets here.
    local ammoData = _Ammo.getData(this.lastRound)
    if not ammoData then return true end -- loaded but no lastRound? 
    _Stats.setPenetration(weaponItem, ammoData.Penetration or ammoData.PiercingBullets)
    return true
end


--[[- Called after the trigger is pulled.

@usage ORGM.Reloadable.Fire.post(weaponItem:getModData(), playerObj, weaponItem)
@tparam ISReloadableWeapon|HandWeapon:getModData() this
@tparam IsoPlayer playerObj
@tparam HandWeapon weaponItem

]]
function Fire.post(this, playerObj, weaponItem)
    if this.hammerCocked == 0 then -- SA already has hammer cocked by this point,
        Hammer.cock(this, playerObj, false, weaponItem) -- chamber rotates here for revolvers
    end
    Hammer.release(this, playerObj, false)

    --this.roundsSinceCleaned = this.roundsSinceCleaned + 1
    this.roundsFired = this.roundsFired + 1
    if this.actionType == ORGM.AUTO then
        --fire shot
        this.roundChambered = 0
        this.emptyShellChambered = 1
        Bolt.open(this, playerObj, false, weaponItem)
        Bolt.close(this, playerObj, false, weaponItem) -- chambers next shot, cocks hammer for SA/DA

    elseif this.actionType == ORGM.ROTARY then
        -- fire shot
        local ammoData = _Ammo.getData(this.magazineData[this.cylinderPosition])
        this.magazineData[this.cylinderPosition] = ammoData and ammoData.Case or nil
        this.currentCapacity = this.currentCapacity - 1

    elseif this.actionType == ORGM.BREAK then
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
        this.roundChambered = this.roundChambered - 1
        this.emptyShellChambered = this.emptyShellChambered + 1
    end
end

--[[- Called when the trigger is pulled on a empty chamber.

@usage ORGM.Reloadable.Fire.dry(weaponItem:getModData(), playerObj, weaponItem)
@tparam ISReloadableWeapon|HandWeapon:getModData() this
@tparam IsoPlayer playerObj
@tparam HandWeapon weaponItem

]]
function Fire.dry(this, playerObj, weaponItem)
    if this.hammerCocked == 1 then
        Hammer.release(this, playerObj, false)
    elseif this.triggerType ~= ORGM.SINGLEACTION then
        Hammer.cock(this, playerObj, false, weaponItem)
        Hammer.release(this, playerObj, false)
    end
end

--- Reloading Functions
-- @section Reload


--[[- Checks if a reload action can be performed.

@usage ORGM.Reloadable.Reload.valid(weaponItem:getModData(), playerObj)
@tparam ISReloadableWeapon|HandWeapon:getModData() this
@tparam IsoPlayer playerObj

@return boolean, true if a reload action can be performed, otherwise false.

]]
function Reload.valid(this, playerObj)
    local result = false
    if this.speedLoader ~= nil then
        local speed = Magazine.findBest(this, playerObj, this.speedLoader)
        -- we have a speedLoader, check if its .max is less then .max - .current
        -- ie: a gun that holds 10 rounds but uses a 5 round loader must have at least 5 rounds free
        if speed and this.containsClip ~= 0 then
            speed = speed:getModData()
            if speed.currentCapacity > 0 then
                -- revolver will dump out all ammo prior to load anyways, so capacity checks don't matter
                if this.actionType == ORGM.ROTARY and this.maxCapacity ~= this.currentCapacity then
                    return true
                -- rifles however, do
                elseif speed.maxCapacity <= this.maxCapacity - this.currentCapacity then
                    return true
                end
            end
        end
    end

    if this.containsClip == 1 then -- a magazine is currently in place, we can unload
        result = true
    elseif this.containsClip == 0 then -- gun uses magazines, but none loaded. check if player has some
        result = Magazine.findBest(this, playerObj, this.ammoType) ~= nil

    elseif this.containsClip == nil then -- doesn't use a clip, check for speedloaders or bullets
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

@usage ORGM.Reloadable.Reload.start(weaponItem:getModData(), playerObj, weaponItem)
@tparam ISReloadableWeapon|HandWeapon:getModData() this
@tparam IsoPlayer playerObj
@tparam HandWeapon weaponItem

]]
function Reload.start(this, playerObj, weaponItem)
    -- NOTE: weaponItem is nil! not passed from ISORGMWeapon:reloadStart
    if this.containsClip == 1 then
        getSoundManager():PlayWorldSound(this.ejectSound, playerObj:getSquare(), 0, 10, 1.0, false)
    elseif this.containsClip == 0 then
        getSoundManager():PlayWorldSound(this.insertSound, playerObj:getSquare(), 0, 10, 1.0, false)
    else
        if this.actionType == ORGM.ROTARY then
            -- TODO: this needs to sync, causes issues,
            Cylinder.open(this, playerObj, true, weaponItem) -- play the open sound
            -- if rotary and contains spent shells, we need to empty the cylinder. this is all or nothing
            if Ammo.hasCases(this) > 0 then
                Ammo.ejectAll(this, playerObj, true)
            end
        elseif this.actionType == ORGM.BREAK then
            Break.open(this, playerObj, true, weaponItem)
        end
    end
end


--[[- Called at successful completion of the reload action.

@usage ORGM.Reloadable.Reload.perform(weaponItem:getModData(), playerObj, weaponItem)
@tparam ISReloadableWeapon|HandWeapon:getModData() this
@tparam IsoPlayer playerObj
@tparam HandWeapon weaponItem

@treturn bool false if the reloading should stop

]]
function Reload.perform(this, playerObj, weaponItem)
    if this.speedLoader ~= nil then
        local speed = Magazine.findBest(this, playerObj, this.speedLoader)
        -- we have a speedLoader, check if its .max is less then .max - .current
        -- ie: a gun that holds 10 rounds but uses a 5 round loader must have at least 5 rounds free
        if speed and this.containsClip ~= 0 then
            speed = speed:getModData()
            if speed.currentCapacity > 0 and speed.maxCapacity <= this.maxCapacity - this.currentCapacity then
                getSoundManager():PlayWorldSound(this.insertSound, playerObj:getSquare(), 0, 10, 1.0, false)
                for i=1, speed.maxCapacity do repeat
                    if speed.magazineData[i] == nil then break end
                    Ammo.load(this, speed.magazineData[i], weaponItem)
                    speed.magazineData[i] = nil
                    speed.currentCapacity = speed.currentCapacity - 1
                until true end
                speed.loadedAmmo = nil
                -- self.reloadInProgress = false
                -- self:syncReloadableToItem(weaponItem)
                playerObj:getXp():AddXP(Perks.Reloading, 1)
                return false -- return reloadInProgress
            end
        end
    end

    if this.containsClip ~= nil then
        if this.containsClip == 1 then -- eject the current clip
            Magazine.eject(this, playerObj, false)
        else
            Magazine.insert(this, playerObj, false)
        end
        -- self.reloadInProgress = false
        -- self:syncReloadableToItem(weaponItem)
        return false -- return reloadInProgress

    else -- internal mag, rotary or break barrel
        local ammoItem = Ammo.findBest(this, playerObj)
        if not ammoItem then return end
        local ammoType = ammoItem:getType()
        if this.actionType == ORGM.ROTARY then
            Cylinder.rotate(this, 1, playerObj, true, weaponItem)
            if this.magazineData[this.cylinderPosition] ~= nil then -- something is in this spot, return now
                -- self:syncReloadableToItem(weaponItem)
                return true
            end
        end
        getSoundManager():PlayWorldSound(this.insertSound, playerObj:getSquare(), 0, 10, 1.0, false)

        Ammo.load(this, ammoType, weaponItem, this.cylinderPosition) -- cylinderPosition will be nil for non-rotary
        if this.actionType == ORGM.BREAK then
            this.cylinderPosition = this.cylinderPosition + 1 -- increment to load the next chamber, it resets on close
        end
        -- remove the necessary ammo
        playerObj:getInventory():RemoveOneOf(ammoType)
        -- self.reloadInProgress = false
        -- self:syncReloadableToItem(weaponItem)
        playerObj:getXp():AddXP(Perks.Reloading, 1)
        return false -- return reloadInProgress
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

@usage ORGM.Reloadable.Unload.valid(weaponItem:getModData(), playerObj)
@tparam ISReloadableWeapon|HandWeapon:getModData() this
@tparam IsoPlayer playerObj

@treturn bool true if a unload action can be performed

]]
function Unload.valid(this, playerObj)
    if this.currentCapacity > 0 then return true end
    if (this.roundChambered ~= nil and this.roundChambered > 0) then
        return true
    end
    return false
end

--[[- Called at the start of a unload action.

This mostly just plays sounds, and opens the break barrel (for shotguns)
or revolver cylinder.

@usage ORGM.Reloadable.Unload.start(weaponItem:getModData(), playerObj, weaponItem)
@tparam ISReloadableWeapon|HandWeapon:getModData() this
@tparam IsoPlayer playerObj
@tparam HandWeapon weaponItem

]]
function Unload.start(this, playerObj, weaponItem)
    -- we dont actually need to do anything here
    return
end

--[[- Called at successful completion of the unload action.

@usage ORGM.Reloadable.Unload.perform(weaponItem:getModData(), playerObj, weaponItem)
@tparam ISReloadableWeapon|HandWeapon:getModData() this
@tparam IsoPlayer playerObj
@tparam HandWeapon weaponItem

@treturn bool false if the unloading should stop

]]
function Unload.perform(this, playerObj, weaponItem)
    if this.actionType == ORGM.ROTARY then
        Cylinder.open(this, playerObj, true)
        -- revolvers drop them all at once
        Ammo.ejectAll(this, playerObj, false)
        return false
    end
    if this.actionType == ORGM.BREAK then
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

@usage ORGM.Reloadable.Magazine.eject(weaponItem:getModData(), playerObj, true)

@tparam ISReloadableWeapon|HandWeapon:getModData() this
@tparam IsoPlayer playerObj
@tparam[opt] bool playSound if true plays the ejectSound

]]
function Magazine.eject(this, playerObj, playSound)
    local clip = Magazine.create(this, playerObj)
    this.currentCapacity = 0
    this.magazineData = {}
    playerObj:getInventory():AddItem(clip)
    ISInventoryPage.dirtyUI()
    this.containsClip = 0
    this.loadedAmmo = nil -- might still have a round in chamber, but this is only required for magazine setup anyways
    if (playSound and this.ejectSound) then playerObj:playSound(this.ejectSound, false) end
end


--[[- Inserts the best magazine from the players inventory into the firearm.

@usage ORGM.Reloadable.Magazine.insert(weaponItem:getModData(), playerObj, true)

@tparam ISReloadableWeapon|HandWeapon:getModData() this
@tparam IsoPlayer playerObj
@tparam[opt] bool playSound if true plays the insertSound

]]
function Magazine.insert(this, playerObj, playSound)
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
    this.magazineData = modData.magazineData
    playerObj:getInventory():Remove(magItem)
    ISInventoryPage.dirtyUI()
    this.containsClip = 1
    this.loadedAmmo = modData.loadedAmmo
    playerObj:getXp():AddXP(Perks.Reloading, 1)
    if (playSound and this.insertSound) then playerObj:playSound(this.insertSound, false) end
end

--[[- Creates a new magazine InventoryItem with modData.

This is called on Reloadable.Magazine.eject()
Copies some data from the firearm into the magazines modData, setting up the ammo count.
@usage local magItem = ORGM.Reloadable.Magazine.create(weaponItem:getModData(), playerObj)

@tparam ISReloadableWeapon|HandWeapon:getModData() this
@tparam IsoPlayer playerObj

@treturn InventoryItem the magazine with setup modData.

]]
function Magazine.create(this, playerObj)
    local magData = _Magazine.getData(this.ammoType)
    local magItem = InventoryItemFactory.CreateItem(magData.moduleName .. '.' .. this.ammoType)
    ReloadUtil:setupMagazine(magItem, magData, playerObj)
    modData = magItem:getModData()
    -- TODO: transfer fault ammo back to the magazine.
    modData.currentCapacity = this.currentCapacity
    modData.magazineData = this.magazineData
    modData.preferredAmmoType = this.preferredAmmoType
    modData.loadedAmmo = this.loadedAmmo
    return magItem
end

--[[- Sets up the ISReloadableMagazine on the InventoryItem

@usage ORGM.Reloadable.Magazine.setup(weaponItem:getModData(), magItem, playerObj)
@tparam ISReloadableWeapon|HandWeapon:getModData() this
@tparam InventoryItem magItem the magazine to setup
@tparam IsoPlayer playerObj

]]
function Magazine.setup(this, magItem, playerObj)
    local magData = _Magazine.getData(magItem)
    ReloadUtil:setupMagazine(magItem, magData, playerObj)
end

--[[- Finds and returns the best magazine available in the players inventory.

@usage local magItem = ORGM.Reloadable.Magazine.findBest(weaponItem:getModData(), playerObj, nil)
@tparam ISReloadableWeapon|HandWeapon:getModData() this
@tparam IsoPlayer playerObj
@tparam nil|string ammoType name of a registered ORGM magazine, auto detected if nil

@treturn nil|InventoryItem the best suited magazine
@see ORGM.Magazine.findIn

]]
function Magazine.findBest(this, playerObj, ammoType)
    if ammoType == nil then ammoType = this.ammoType end
    return _Magazine.findIn(ammoType, this.preferredAmmoType, playerObj:getInventory())
end

--- Ammo Functions
-- @section Ammo

--[[- Loads a round into the firearm (internal magazine or cylinder).

@usage ORGM.Reloadable.Ammo.load(weaponItem:getModData(), "Ammo_9x19mm_FMJ", weaponItem, nil)
@tparam ISReloadableWeapon|HandWeapon:getModData() this
@tparam string ammoType name of a registered ORGM ammo
@tparam HandWeapon weaponItem
@tparam[opt] int position to insert the round at. If nil it is appended to the list.

]]
function Ammo.load(this, ammoType, weaponItem, position)
    -- TODO: ammoType should allow for InventoryItems, so we can check for modData
    -- and flag any faulty ammo
    if this.currentCapacity == this.maxCapacity then return end
    this.currentCapacity = this.currentCapacity + 1
    if position == nil then position = this.currentCapacity end
    this.magazineData[position] = Ammo.convert(this, ammoType)

    if this.loadedAmmo == nil then
        this.loadedAmmo = ammoType
    elseif this.loadedAmmo ~= ammoType then
        this.loadedAmmo = 'mixed'
    end
end


--[[- Converts a AmmoGroup round to a real round if required.

This is a safety check performed to ensure we can properly get the ammo stats.

@usage local ammoType = ORGM.Reloadable.Ammo.convert(weaponItem:getModData(), "Ammo_9x19mm",)
@tparam ISReloadableWeapon|HandWeapon:getModData() this
@tparam string ammoType name of a AmmoGroup or a registered ammo.

@treturn string name of the first ammo in the group or ammoType if a real ammo was already passed in.

]]
function Ammo.convert(this, ammoType)
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

@usage ORGM.Reloadable.Ammo.findBest(weaponItem:getModData(), playerObj)
@tparam ISReloadableWeapon|HandWeapon:getModData() this
@tparam IsoPlayer playerObj

@treturn nil|InventoryItem the best suited ammo
@see ORGM.Ammo.findIn

]]
function Ammo.findBest(this, playerObj)
    return _Ammo.findIn(this.ammoType, this.preferredAmmoType, playerObj:getInventory())
end

--[[- Gets the ammo at specified position.

@usage local ammoType = ORGM.Reloadable.Ammo.get(weaponItem:getModData(), position)
@tparam ISReloadableWeapon|HandWeapon:getModData() this
@tparam int position the index position to get

@treturn nil|string the ammo (or case) name at the position

]]
function Ammo.get(this, position)
    return this.magazineData[position] -- arrays start at 1
end


--[[- Gets the ammo at the next position.

@usage local ammoType = ORGM.Reloadable.Ammo.peek(weaponItem:getModData(), true)
@tparam ISReloadableWeapon|HandWeapon:getModData() this
@tparam[opt] bool wrap if true wraps around the end of the list to the begining past maxCapacity. true for rotary actions.

@treturn nil|string ammo (or case) name at the next position

]]
function Ammo.peek(this, wrap)
    if wrap then
        return this.magazineData[(this.cylinderPosition % this.maxCapacity) +1]
    end
    return this.magazineData[this.currentCapacity]
end


--[[- Ejects all shells (live and spent) onto the ground.

Used primarly with revolvers and break barrels on opening.

@usage ORGM.Reloadable.Ammo.ejectAll(weaponItem:getModData(), playerObj, true)

@tparam ISReloadableWeapon|HandWeapon:getModData() this
@tparam IsoPlayer playerObj
@tparam[opt] bool playSound if true plays the ejectSound

]]
function Ammo.ejectAll(this, playerObj, playSound)
    if this.isOpen == 0 then return end
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
    this.loadedAmmo = nil
    this.currentCapacity = 0
end


--[[- Gets the number of empty cases in the magazine/cylinder.

@usage local count = ORGM.Reloadable.Ammo.hasCases(weaponItem:getModData())
@tparam ISReloadableWeapon|HandWeapon:getModData() this

@treturn int number of spent cases

]]
function Ammo.hasCases(this)
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

@usage ORGM.Reloadable.Ammo.next(weaponItem:getModData(), playerObj, weaponItem)
@tparam ISReloadableWeapon|HandWeapon:getModData() this
@tparam IsoPlayer playerObj
@tparam HandWeapon weaponItem

]]
function Ammo.next(this, playerObj, weaponItem)
    if this.currentCapacity == 0 or this.currentCapacity == nil then
        this.loadedAmmo = nil
        return
    end
    local ammoType = this.magazineData[this.currentCapacity]
    if ammoType == nil then -- problem, currentCapacity doesn't match our magazineData
        -- TODO: seems i missed filling out this part...
    end
    -- remove last entry from data table (Note: using #table to find the length is slow)
    -- TODO: check failure to feed jams here
    this.magazineData[this.currentCapacity] = nil
    this.currentCapacity = this.currentCapacity - 1
    this.roundChambered = 1
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

@usage ORGM.Reloadable.Ammo.setCurrent(weaponItem:getModData(), ammoType, weaponItem)
@tparam ISReloadableWeapon|HandWeapon:getModData() this
@tparam string ammoType name of the ammo in use
@tparam HandWeapon weaponItem

]]
function Ammo.setCurrent(this, ammoType, weaponItem)
    if ammoType == nil or _Ammo.isCase(ammoType) then return end
    ammoType = Ammo.convert(this, ammoType)
    local roundData = _Ammo.getData(ammoType)
    if roundData == nil then
        this.lastRound = nil
        weaponItem:getModData().lastRound = nil -- NOTE: this seems redundant..left over junk?
        return
    end
    if ammoType ~= this.lastRound then
        this.lastRound = ammoType -- this is also used if the slide is cycled again before firing, so we know what to eject
        weaponItem:getModData().lastRound = ammoType
        _Stats.set(weaponItem)
    end
    -- NOTE: moved to Fire.pre
    -- _Stats.setPenetration_DEPRECIATED(weaponItem, roundData)
end


--- Racking Functions
-- @section Rack

--[[- Checks if the weapon can be racked.

On Easy/Normal reloading, this returns false if there is already a round chambered.
@usage local result = ORGM.Reloadable.rack.setCurrent(weaponItem:getModData(), playerObj)
@tparam ISReloadableWeapon|HandWeapon:getModData() this
@tparam IsoPlayer playerObj

@treturn bool true if the gun can be racked.

]]
function Rack.valid(this, playerObj)
    if (this.triggerType == ORGM.SINGLEACTION and this.hammerCocked == 0) then
        return true
    end
    if (this.actionType == ORGM.BREAK or this.actionType == ORGM.ROTARY) then
        if this.isOpen == 1 then return true end
        return false
    end
    if this.emptyShellChambered == 1 then return true end
    if ReloadManager[1]:getDifficulty() < 3 or playerObj:getJoypadBind() ~= -1 then
        if this.isJammed then return true end
        return this.roundChambered == 0 and this.currentCapacity > 0
    end

    return true
end


--[[- Called at the start of a rack action.

This mostly just plays sounds.

@usage ORGM.Reloadable.Rack.start(weaponItem:getModData(), playerObj, weaponItem)
@tparam ISReloadableWeapon|HandWeapon:getModData() this
@tparam IsoPlayer playerObj
@tparam HandWeapon weaponItem

]]
function Rack.start(this, playerObj, weaponItem)
    if (this.actionType == ORGM.BREAK or this.actionType == ORGM.ROTARY) then
        return
    end
    if this.rackSound then
        getSoundManager():PlayWorldSound(this.rackSound, playerObj:getSquare(), 0, 10, 1.0, false)
    end
end


--[[- Called at successful completion of a rack action.

@usage ORGM.Reloadable.Rack.perform(weaponItem:getModData(), playerObj, weaponItem)
@tparam ISReloadableWeapon|HandWeapon:getModData() this
@tparam IsoPlayer playerObj
@tparam HandWeapon weaponItem

]]
function Rack.perform(this, playerObj, weaponItem)
    if this.actionType == ORGM.BREAK then
        if this.isOpen then Break.close(this, playerObj, true, weaponItem) end

    elseif this.actionType == ORGM.ROTARY then
        if this.isOpen == 1 then Cylinder.close(this, playerObj, true, weaponItem) end

    else
        Bolt.open(this, playerObj, false, weaponItem)
        Bolt.close(this, playerObj, false, weaponItem)
    end

    if (this.triggerType == ORGM.SINGLEACTION and this.hammerCocked == 0) then
        Hammer.cock(this, playerObj, true, weaponItem) -- play the cock sound
    end
end


--- Hammer Functions
-- @section Hammer


--[[- Cocks the hammer and rotates the cylinder for Rotary actionType.

@usage ORGM.Reloadable.Hammer.cock(weaponItem:getModData(), playerObj, true, weaponItem)
@tparam ISReloadableWeapon|HandWeapon:getModData() this
@tparam IsoPlayer playerObj
@tparam nil|bool playSound if true plays the cockSound
@tparam HandWeapon weaponItem

]]
function Hammer.cock(this, playerObj, playSound, weaponItem)
    -- rotary cylinders rotate the chamber when the hammer is cocked
    if this.actionType == ORGM.ROTARY and this.isOpen == 0 then
        Cylinder.rotate(this, 1, playerObj, false, weaponItem)
    end
    if (playSound and this.cockSound) then playerObj:playSound(this.cockSound, false) end
    this.hammerCocked = 1
end

--[[- Releases a cocked hammer.

@usage ORGM.Reloadable.Hammer.release(weaponItem:getModData(), playerObj, true)
@tparam ISReloadableWeapon|HandWeapon:getModData() this
@tparam IsoPlayer playerObj
@tparam nil|bool playSound not used atm

]]
function Hammer.release(this, playerObj, playSound)
    this.hammerCocked = 0
end


--- Bolt Functions
-- @section Bolt

--[[- Opens the bolt, ejecting whatever is currently in the chamber onto the ground.

@usage ORGM.Reloadable.Bolt.open(weaponItem:getModData(), playerObj, true, weaponItem)
@tparam ISReloadableWeapon|HandWeapon:getModData() this
@tparam IsoPlayer playerObj
@tparam nil|bool playSound if true plays the openSound
@tparam HandWeapon weaponItem

]]
function Bolt.open(this, playerObj, playSound, weaponItem)
    if this.isOpen == 1 then -- already opened!
        return
    end
    -- first open the slide...
    this.isOpen = 1
    this.isJammed = nil
    if (playSound and this.openSound) then playerObj:playSound(this.openSound, false) end
    local square = playerObj:getCurrentSquare()
    local ammoType = this.lastRound
    local ammoItem = nil
    -- eject whatever is in the chamber
    if this.roundChambered == 1 then
        if ammoType == nil then -- some other mod (aka survivors) was using this gun, lastRound isn't set!
            this.lastRound = Ammo.convert(this, this.ammoType)
        end
        ammoItem = InventoryItemFactory.CreateItem(_Ammo.getData(this.lastRound).moduleName ..'.'.. this.lastRound)
    elseif this.emptyShellChambered == 1 then
        local ammoData = _Ammo.getData(ammoType)
        if ammoData and ammoData.Case and Settings.CasesEnabled then
            -- TODO: cases need proper module checking
            ammoItem = InventoryItemFactory.CreateItem('ORGM.' .. ammoData.Case)
        end
    else -- nothing actually chambered?
        return
    end
    this.roundChambered = 0
    this.emptyShellChambered = 0
    if (ammoItem and square) then
        square:AddWorldInventoryItem(ammoItem, 0, 0, 0)
        ISInventoryPage.dirtyUI()
    end
end

--[[- Closes the bolt and chambers the next round.

Single and Double actions this also cocks the hammer.

@usage ORGM.Reloadable.Bolt.close(weaponItem:getModData(), playerObj, true, weaponItem)
@tparam ISReloadableWeapon|HandWeapon:getModData() this
@tparam IsoPlayer playerObj
@tparam nil|bool playSound if true plays the closeSound
@tparam HandWeapon weaponItem

]]
function Bolt.close(this, playerObj, playSound, weaponItem)
    if this.isOpen == 0 then -- already closed!
        return
    end
    if this.triggerType ~= ORGM.DOUBLEACTIONONLY then
        Hammer.cock(this, playerObj, false, weaponItem)
    end
    this.isOpen = 0
    if (playSound and this.closeSound) then playerObj:playSound(this.closeSound, false) end
    -- load next shot, this isn't always true though:
    -- a pump action shotgun reloaded with slide open wont chamber a round, THIS NEEDS TO BE HANDLED
    -- a mag inserted while slide open will chamber when closed
    Ammo.next(this, playerObj, weaponItem)
end


--- Cylinder Functions
-- @section Cylinder

--[[- Rotates the cylinder by the specified amount.

@usage ORGM.Reloadable.Cylinder.rotate(weaponItem:getModData(), 1, playerObj, true, weaponItem)
@tparam ISReloadableWeapon|HandWeapon:getModData() this
@tparam int count Number of positions to rotate. If nil or 0, randomly selects (chamber spin)
@tparam IsoPlayer playerObj
@tparam nil|bool playSound not used atm
@tparam HandWeapon weaponItem

]]
function Cylinder.rotate(this, count, playerObj, playSound, weaponItem)
    local position = this.cylinderPosition
    if (count == nil or count == 0) then -- random count
        count = ZombRand(this.maxCapacity)+1
    end
    this.cylinderPosition = ((this.cylinderPosition - 1 + count) % this.maxCapacity) +1
    Ammo.setCurrent(this, this.magazineData[this.cylinderPosition], weaponItem)
end


--[[- Opens the cylinder.

@usage ORGM.Reloadable.Cylinder.open(weaponItem:getModData(), playerObj, true, weaponItem)
@tparam ISReloadableWeapon|HandWeapon:getModData() this
@tparam IsoPlayer playerObj
@tparam nil|bool playSound if true plays the openSound
@tparam HandWeapon weaponItem

]]
function Cylinder.open(this, playerObj, playSound, weaponItem)
    if this.isOpen == 1 then return end
    this.isOpen = 1
    if (playSound and this.openSound) then playerObj:playSound(this.openSound, false) end
end

--[[- Closes the cylinder and sets the current round.

@usage ORGM.Reloadable.Cylinder.close(weaponItem:getModData(), playerObj, true, weaponItem)
@tparam ISReloadableWeapon|HandWeapon:getModData() this
@tparam IsoPlayer playerObj
@tparam nil|bool playSound if true plays the closeSound
@tparam HandWeapon weaponItem

]]
function Cylinder.close(this, playerObj, playSound, weaponItem)
    if this.isOpen == 0 then return end
    this.isOpen = 0
    Ammo.setCurrent(this, this.magazineData[this.cylinderPosition], weaponItem)
    if (playSound and this.closeSound) then playerObj:playSound(this.closeSound, false) end
end

--- Break Barrel Functions
-- @section Break


--[[- Opens the breech and ejects any shells.

@usage ORGM.Reloadable.Break.open(weaponItem:getModData(), playerObj, true, weaponItem)
@tparam ISReloadableWeapon|HandWeapon:getModData() this
@tparam IsoPlayer playerObj
@tparam nil|bool playSound if true plays the openSound
@tparam HandWeapon weaponItem

]]
function Break.open(this, playerObj, playSound, weaponItem)
    if this.isOpen == 1 then return end
    this.isOpen = 1
    this.cylinderPosition = 1 -- use cylinder position variable for which barrel to fire, set to 1 for reloading
    if (playSound and this.openSound) then playerObj:playSound(this.openSound, false) end
    Ammo.ejectAll(this, playerObj, false)
end


--[[- Closes the breech and sets the current round.

@usage ORGM.Reloadable.Break.close(weaponItem:getModData(), playerObj, true, weaponItem)
@tparam ISReloadableWeapon|HandWeapon:getModData() this
@tparam IsoPlayer playerObj
@tparam nil|bool playSound if true plays the closeSound
@tparam HandWeapon weaponItem

]]
function Break.close(this, playerObj, playSound, weaponItem)
    if this.isOpen == 0 then return end
    this.isOpen = 0
    this.cylinderPosition = 1 -- use cylinder position variable for which barrel to fire
    Ammo.setCurrent(this, this.magazineData[1], weaponItem)
    if (playSound and this.closeSound) then playerObj:playSound(this.closeSound, false) end
end
