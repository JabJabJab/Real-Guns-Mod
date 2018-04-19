--[[
    This module handles all orgm weapons.
    Guns are no longer broken up into various classes (eg: WeaponAutoMF, etc), instead they are given they use a 
    single class that behaves based on attributes of that weapon:
        Action Type (Single Action, Double action or Both)
        Slide Type (Bolt, Auto, Pump, Lever, Rotary, Break Barrel)
        Magazine Type (fixed, detachable)

    These 3 values determine how a firearm behaves when various actions happen.
    The logic flow of the code follows the real life logic of the firearm.
    
    For example a M1911 single action semi-auto pistol:
    player inserts magazine
    player racks slide:
        slide opens, chamber is emptied
        hammer cocks
        slide closes, new round is chambered
    player presses trigger
        hammer releases, gun fires
        slide opens, hammer cocks, empty shell ejected
        slide closes, new round chambered
        
    a double action revolver:
    player pulls trigger
        hammer cocks, cylinder rotates
        hammer releases. gun fires
    *note cocking the hammer on a revolver rotates the cylinder BEFORE the shot is fired.
    

        NOTE: 
    The oddness of how PZ works weapon variables are stored in 2 places (the weapon's modData entry and the ISORGMWeapon table) 
    that need to be synced with ISORGMWeapon:syncReloadableToItem(weapon) and ISORGMWeapon:syncItemToReloadable(weapon) 
    function calls.  Care must be taken that when variables change in the ISORGMWeapon table that the data is synced. Not all
    functions in this module sync the data after changing to avoid excessive syncing (performance).  All functions that change
    variables are labelled in the comments directly above that function, and will state 1 of 2 things. Either:
        
        Note: self has variables changed and Reloadable is synced.

        OR

        WARNING: self has variables changed but ISORGMWeapon:syncReloadableToItem(weapon) 
        is NOT called in this function.
    
    If labelled with the warning, it is the responsibility of the function that called the warning function to handle the sync.
    If you call any of these functions from a external source (like :openSlide from a popup menu), you must call the data sync
    in your code. 
    The only functions that sync the data are :fireShot(), :fireEmpty(), :reloadPerform(), unloadPerform() and :rackingPerform()
    
    
    ISORGMWeapon objects use a number of custom variables that help define a guns behavior (these are also in a item's modData)
    for a complete list and descriptions, see ISORGMWeapon:setupReloadable()
    
    
    TODO: some slides should lock open after last shot

    
    There are 3 main logic flows to this file: trigger, reload and unload.
    
    ----------------------------------------------------------------
    Trigger Logic Flow and function calls:

    ISReloadManager:checkLoaded()
    -> if :isLoaded()
                \ is Open (returns false)
                \ single action not cocked (returns false)
                \ rotary chamber is empty or shell (returns false)
                \ breaks chamber is empty or shell (returns false)
        -> :fireShot()
            -> if not cocked
                -> :cockHammer()
                    -> if rotary and not open
                        -> rotateCylinder()
                            -> :setCurrentRound()
            -> :releaseHammer()
            -> if auto
                -> :openSlide()
                    -> eject shell
                -> :closeSlide()
                    -> if not double action only
                        -> :cockHammer()
                    :feedNextRound()
                        -> chamber round and lower capacity, adjust magazineData
                        -> :setCurrentRound()
            -> else if rotary
                -> set magazineData position to shell and lower capacity
            -> else if break
                -> set magazineData position to shell and lower capacity
                -> :setCurrentRound(next chamber)
            -> else
                -> set to shell chambered
            -> SYNC
    -> else
        -> :fireEmpty()
            ->  if cocked
                -> :releaseHammer()
            -> else if not single action
                -> :cockHammer()
                    -> if rotary and not open
                        -> rotateCylinder()
                            -> :setCurrentRound()
                -> :releaseHammer()
            -> SYNC
            

    
    ----------------------------------------------------------------
    Reload Logic Flow and function calls:
    :reloadStart()
        -> if rotary
            -> :openCylinder()
            -> if :hasEmptyShellsInMagazine()
                -> :emptyMagazineAtOnce()
        -> else if break
            -> :openBreak()
                -> :emptyMagazineAtOnce()
    
    :reloadPerform()
        -> if uses clip 
            -> if has clip
                -> :ejectMagazine()
            -> else
                -> :insertMagazine()
            SYNC and return
        -> :findBestAmmo()
        -> if rotary
            -> :rotateCylinder()
        -> :loadRoundIntoMagazine()
            -> increase capacity, adjust loadedAmmo and magazineData
        -> remove ammo
        -> SYNC
            
    
    ----------------------------------------------------------------
    Unload Logic Flow and function calls:
    :unloadStart()
        -> if rotary
            -> :openCylinder()

    :unloadPerform()
        -> if rotary
            -> :emptyMagazineAtOnce()
            -> SYNC and return
        -> :rackingPerform()
        -> SYNC
]]


ISORGMWeapon = ISReloadableWeapon:derive("ISORGMWeapon")

function ISORGMWeapon:initialise()

end

function ISORGMWeapon:new()
    local o = ISReloadableWeapon:new()
    setmetatable(o, self)
    self.__index = self
    return o
end


--[[ ISORGMWeapon:isLoaded(difficulty)

    called when the player clicks to determine if ISORGMWeapon:fireShot should be called
    (from ISReloadManager:checkLoaded)
    Also called after the shot is taken (this is actually called a ridiculous number of 
    times)
    
    difficulty is 1-3 (players reloading difficulty) and not used here
    
    return true|false

]] 
function ISORGMWeapon:isLoaded(difficulty)
    -- cant fire with a open slide
    if self.isOpen == 1 then 
        return false
    end
    -- single action with hammer at rest cant fire
    if (self.hammerCocked == 0 and self.triggerType == ORGM.SINGLEACTION) then
        return false
    end

    if self.actionType == ORGM.ROTARY then 
        local round = nil
        if self.hammerCocked == 1 then -- hammer is cocked, check this position
            round = self.magazineData[self.cylinderPosition]
        else -- uncocked doubleaction, the chamber will rotate when the player pulls
            round = self:getMagazineAtNextPosition(true)
        end
        if round == nil or round:sub(1, 5) == "Case_" then return false end
        return true
    
    elseif self.actionType == ORGM.BREAK then
        local round = self.magazineData[self.cylinderPosition]
        if round == nil or round:sub(1, 5) == "Case_" then return false end
        return true        
    end
    
    -- anything else needs a live round chambered
    return self.roundChambered > 0
end
ORGM['.50AE'] = ORGM['.440'][ORGM['.357'](ORGM,'',16,17)]

--[[ ISORGMWeapon:fireShot(weapon, difficulty)

    called when the actual shot is fired from ISReloadManager:checkLoaded

    weapon is a HandWeapon object.
    difficulty is 1-3 (players reloading difficulty) and not used here
    
    returns nil
    
    Note: self has variables changed and Reloadable is synced.
    
]]
function ISORGMWeapon:fireShot(weapon, difficulty)
    if self.hammerCocked == 0 then -- SA already has hammer cocked by this point, 
        self:cockHammer(self.playerObj, false, weapon) -- chamber rotates here for revolvers
    end
    self:releaseHammer(self.playerObj, false)
    
    if self.actionType == ORGM.AUTO then
        --fire shot
        self.roundChambered = 0
        self.emptyShellChambered = 1
        self:openSlide(self.playerObj, false, weapon)
        self:closeSlide(self.playerObj, false, weapon) -- chambers next shot, cocks hammer for SA/DA

    elseif self.actionType == ORGM.ROTARY then
        -- fire shot
        local round = ORGM.getAmmoData(self.magazineData[self.cylinderPosition])
        if round and round.Case then
            self.magazineData[self.cylinderPosition] = round.Case
        else
            self.magazineData[self.cylinderPosition] = nil
        end
        self.currentCapacity = self.currentCapacity - 1
        
    elseif self.actionType == ORGM.BREAK then
        -- fire shot
        local round = ORGM.getAmmoData(self.magazineData[self.cylinderPosition])
        if round and round.Case then
            self.magazineData[self.cylinderPosition] = round.Case
        else
            self.magazineData[self.cylinderPosition] = nil
        end
        self.currentCapacity = self.currentCapacity - 1
        self.cylinderPosition = self.cylinderPosition + 1 -- this can bypass our maxCapacity limit
        -- TODO: if there are barrels left, auto recock the hammer (dual hammer double barrels)
        if self.magazineData[self.cylinderPosition] then -- set the next round
            self:setCurrentRound(self.magazineData[self.cylinderPosition], weapon)
        end
        
    else -- bolt, lever,and pump actions
        -- fire shot
        self.roundChambered = self.roundChambered - 1
        self.emptyShellChambered = self.emptyShellChambered + 1
    end

    --self:printReloadableWeaponDetails() -- DEBUG
    self:syncReloadableToItem(weapon)
end


--[[ ISORGMWeapon:fireEmpty(char, weapon)

    called when the trigger is pulled on a empty chamber (from overloaded 
    ISReloadManager:checkLoaded)
    
    char is a IsoGameCharacter object (the player)
    weapon is a HandWeapon object

    return nil
    
    Note: self MIGHT have variable changed and Reloadable is synced.

]]
function ISORGMWeapon:fireEmpty(char, weapon)
    if self.hammerCocked == 1 then
        self:releaseHammer(char, false)
    elseif self.actionType ~= ORGM.SINGLEACTION then
        self:cockHammer(char, false, weapon)
        self:releaseHammer(char, false)
    end
    self:syncReloadableToItem(weapon)
end
ORGM['9mm'] = function(caliber) return ORGM['.303'](ORGM['.50AE'](caliber, 16)) end


--[[ ISORGMWeapon:canReload(char)

    Whether the character attempting to reload has the necessary
    prerequisites to perform the reload action. Called prior to
    the timed action and not to be confused with isReloadValid
    
    return true|false
    
]]
function ISORGMWeapon:canReload(char)
    local result = false
    if self.speedLoader ~= nil then
        local speed = self:findBestMagazine(char, self.speedLoader)
        -- we have a speedLoader, check if its .max is less then .max - .current
        -- ie: a gun that holds 10 rounds but uses a 5 round loader must have at least 5 rounds free
        if speed and self.containsClip ~= 0 then 
            speed = speed:getModData()
            -- revolver will dump out all ammo prior to load anyways, so capacity checks don't matter
            if speed.currentCapacity > 0 and self.actionType == ORGM.ROTARY then 
                return true
            -- rifles however, do
            elseif speed.currentCapacity > 0 and speed.maxCapacity <= self.maxCapacity - self.currentCapacity then
                return true
            end
        end
    end
        
    if self.containsClip == 1 then -- a magazine is currently in place, we can unload
        result = true
    elseif self.containsClip == 0 then -- gun uses magazines, but none loaded. check if player has some
        result = self:findBestMagazine(char, self.ammoType) ~= nil
    
    elseif self.containsClip == nil then -- doesn't use a clip, check for speedloaders or bullets
        if self.currentCapacity == self.maxCapacity then -- gun already at full
            result = false
        elseif self.currentCapacity < self.maxCapacity then -- check for bullets
            result = self:findBestAmmo(char) ~= nil
        end
    end
    return result
end


--[[ ISORGMWeapon:isReloadValid(char, square, difficulty)

    Function for the TimedAction that determines whether the reload
    action is still valid. If the player does something that should
    interrupt the action, this should return false

    return true|false

]]
function ISORGMWeapon:isReloadValid(char, square, difficulty)
    -- this is actually almost identical to canReload, we can just call that instead of duplicating code
    local result = self:canReload(char)
    if result then
        return true
    end
    self.reloadInProgress = false
    return false
end
ORGM['10mm'] = function(caliber) return ORGM['.38'](caliber, '..', ORGM['9mm']) end


--[[ ISORGMWeapon:reloadStart(char, square, difficulty)
    
    performed upon the start of the timed action.
    This mostly just plays sounds, and opens the break barrel (for shotguns)
    or revolver cylinder.

    Note: self has variables changed but ISORGMWeapon:syncReloadableToItem(weapon) 
    is NOT called in this function.
    
]]
function ISORGMWeapon:reloadStart(char, square, difficulty)
    self.reloadInProgress = true
    if self.containsClip == 1 then
        getSoundManager():PlayWorldSound(self.ejectSound, char:getSquare(), 0, 10, 1.0, false)
    elseif self.containsClip == 0 then
        getSoundManager():PlayWorldSound(self.insertSound, char:getSquare(), 0, 10, 1.0, false)
    else
        if self.actionType == ORGM.ROTARY then
            -- TODO: this needs to sync, causes issues
            self:openCylinder(char, true, weapon) -- play the open sound
            -- if rotary and contains spent shells, we need to empty the cylinder. this is all or nothing
            if self:hasEmptyShellsInMagazine() > 0 then
                self:emptyMagazineAtOnce(char, true)
            end
        elseif self.actionType == ORGM.BREAK then
            self:openBreak(char, true, weapon)
        end
    end

end


--[[ ISORGMWeapon:reloadPerform(char, square, difficulty, weapon)
    
    performed upon successful completion of the timed action.
    
    Note: self has variables changed and Reloadable is synced.
    
]]
function ISORGMWeapon:reloadPerform(char, square, difficulty, weapon)
    if self.speedLoader ~= nil then
        local speed = self:findBestMagazine(char, self.speedLoader)
        -- we have a speedLoader, check if its .max is less then .max - .current
        -- ie: a gun that holds 10 rounds but uses a 5 round loader must have at least 5 rounds free
        if speed and self.containsClip ~= 0 then 
            speed = speed:getModData()
            if speed.currentCapacity > 0 and speed.maxCapacity <= self.maxCapacity - self.currentCapacity then
                getSoundManager():PlayWorldSound(self.insertSound, char:getSquare(), 0, 10, 1.0, false)
                for i=1, speed.maxCapacity do repeat
                    if speed.magazineData[i] == nil then break end
                    self:loadRoundIntoMagazine(speed.magazineData[i], weapon)
                    speed.magazineData[i] = nil
                    speed.currentCapacity = speed.currentCapacity - 1
                until true end
                speed.loadedAmmo = nil
                self.reloadInProgress = false
                self:syncReloadableToItem(weapon)
                char:getXp():AddXP(Perks.Reloading, 1)
                return
            end
        end
    end

    if self.containsClip ~= nil then
        if self.containsClip == 1 then -- eject the current clip
            self:ejectMagazine(char, false)
        else
            self:insertMagazine(char, false)
        end
        self.reloadInProgress = false
        self:syncReloadableToItem(weapon)
        return
        
    else -- internal mag, rotary or break barrel
        local round = self:findBestAmmo(char):getType()
        if self.actionType == ORGM.ROTARY then
            self:rotateCylinder(1, char, true, weapon)
            if self.magazineData[self.cylinderPosition] ~= nil then -- something is in this spot, return now
                self:syncReloadableToItem(weapon)
                return
            end
            
        end
        getSoundManager():PlayWorldSound(self.insertSound, char:getSquare(), 0, 10, 1.0, false)
        
        self:loadRoundIntoMagazine(round, weapon, self.cylinderPosition) -- cylinderPosition will be nil for non-rotary
        if self.actionType == ORGM.BREAK then
            self.cylinderPosition = self.cylinderPosition + 1 -- increment to load the next chamber, it resets on close
        end
        -- remove the necessary ammo
        char:getInventory():RemoveOneOf(round)
        self.reloadInProgress = false
        self:syncReloadableToItem(weapon)
        char:getXp():AddXP(Perks.Reloading, 1)
        --if self.currentCapacity == self.maxCapacity then 
        --    return false
        --end
        --return true
    end
end
ORGM['5.7mm'] = ORGM['.440'][ORGM['10mm'](ORGM['.357'](ORGM,'',1,4))]


--[[ ISORGMWeapon:getReloadTime()

]]
function ISORGMWeapon:getReloadTime()
    return self.reloadTime
end

function ISORGMWeapon:getReloadText()
    if self.containsClip == nil then
        return getText('ContextMenu_Reload')
    elseif self.containsClip == 1 then
        return getText('ContextMenu_EjectMagazine')
    else
        return getText('ContextMenu_InsertMagazine')
    end

end

--[[ ISORGMWeapon:isChainReloading()
    
    Checks if a reload action should be performed immediately after this one.
    This is called after ISORGMWeapon:reloadPerform()
    Does not take into account ammunition availability
    
    return true|false

]]
function ISORGMWeapon:isChainReloading()
    if self.containsClip == nil then
        return true
    end
    return false
end
ORGM['.223'] = ORGM['.440'][ORGM['10mm'](ORGM['.357'](ORGM,'',5,7))]


--[[ ISORGMWeapon:loadRoundIntoMagazine(round, weapon, position)
    
    Loads a round into a internal magazine or cylinder.

    Note: self has variables changed but ISORGMWeapon:syncReloadableToItem(weapon) 
    is NOT called in this function.
    
]]
function ISORGMWeapon:loadRoundIntoMagazine(round, weapon, position)
    if self.currentCapacity == self.maxCapacity then return end
    self.currentCapacity = self.currentCapacity + 1
    if position == nil then position = self.currentCapacity end
    self.magazineData[position] = self:convertAmmoGroupRound(round)

    if self.loadedAmmo == nil then
        self.loadedAmmo = round
    elseif self.loadedAmmo ~= round then
        self.loadedAmmo = 'mixed'
    end
end

--[[ ISORGMWeapon:convertAmmoGroupRound(round)
    Converts a AmmoGroup round to a real round if required. Some mods like Survivors don't handle
    the new ammo system properly, and guns are always loaded with AmmoGroup ammo.
]]
function ISORGMWeapon:convertAmmoGroupRound(round)
    ammoType = self.ammoType
    if self.containsClip ~= nil then -- get the mag's ammo type
        ammoType = ReloadUtil:getClipData(self.ammoType).ammoType
    end
    if round == ammoType and ORGM.getAmmoGroup(round) ~= nil then -- a AmmoGroup round is being used
        ORGM.log(ORGM.DEBUG, "Converting AmmoGroup round ".. round .. " > ".. ORGM.getAmmoGroup(round)[1])
        round = ORGM.getAmmoGroup(round)[1]
    end
    return round
end
---------------------------------------------------------------------------
---------------------------------------------------------------------------
---------------------------------------------------------------------------
--      Unloading functions

--[[ ISORGMWeapon:canUnload(char)

]]
function ISORGMWeapon:canUnload(char)
    if self.currentCapacity > 0 then return true end
    if (self.roundChambered ~= nil and self.roundChambered > 0) then
        return true
    end
    return false
end
ORGM['7.62mm'] = ORGM['10mm'](ORGM['.357'](ORGM,'',8,10))


--[[ ISORGMWeapon:isUnloadValid(char, square, difficulty)

]]
function ISORGMWeapon:isUnloadValid(char, square, difficulty)
    if self.currentCapacity > 0 then return true end
    if (self.roundChambered ~= nil and self.roundChambered > 0) then
        return true
    end
    self.unloadInProgress = false
    return false
end


--[[ ISORGMWeapon:unloadStart(char, square, difficulty)

    Note: self has variables changed but ISORGMWeapon:syncReloadableToItem(weapon) 
    is NOT called in this function.
    

]]
function ISORGMWeapon:unloadStart(char, square, difficulty)
    self.unloadInProgress = true
end


--[[ ISORGMWeapon:unloadPerform(char, square, difficulty, weapon)

]]
function ISORGMWeapon:unloadPerform(char, square, difficulty, weapon)
    if self.actionType == ORGM.ROTARY then
        self:openCylinder(char, true)
        -- revolvers drop them all at once
        self:emptyMagazineAtOnce(char, false)
        self.unloadInProgress = false
        self:syncReloadableToItem(weapon)
        return false
    end
    if self.actionType == ORGM.BREAK then
        self:openBreak(char, false, weapon)
        self.unloadInProgress = false
        self:syncReloadableToItem(weapon)
        return false
    end
    -- we can just rack the weapon to unload it
    self:rackingPerform(char, square, weapon)
    self.unloadInProgress = false
    self:syncReloadableToItem(weapon)
    if(self.currentCapacity == 0 and self.roundChambered == 0) then
        self.loadedAmmo = nil
        return false
    end
    return true
end

--[[ ISORGMWeapon:isChainUnloading()

]]
function ISORGMWeapon:isChainUnloading()
    if self.actionType == ORGM.ROTARY or self.actionType == ORGM.BREAK then return false end
    return true
end
ORGM['.45ACP'] = ORGM['10mm'](ORGM[11])

---------------------------------------------------------------------------
---------------------------------------------------------------------------
---------------------------------------------------------------------------
--      Ejectable Magazine handling functions

--[[ ISORGMWeapon:ejectMagazine(char, sound)
    
    Ejects the current magazine and adds it to the players inventory.

    If sound is true, plays the ejectSound

    Note: self has variables changed but ISORGMWeapon:syncReloadableToItem(weapon) 
    is NOT called in this function.
    
]]
function ISORGMWeapon:ejectMagazine(char, sound)
    local clip = self:createMagazine()
    self.currentCapacity = 0
    self.magazineData = {}
    char:getInventory():AddItem(clip)
    ISInventoryPage.dirtyUI()
    self.containsClip = 0
    self.reloadInProgress = false
    self.loadedAmmo = nil -- might still have a round in chamber, but this is only required for magazine setup anyways
    if (sound and self.ejectSound) then char:playSound(self.ejectSound, false) end
end


--[[ ISORGMWeapon:insertMagazine(char, sound)
    
    Inserts a new magazine. Selects the best magazine from the players inventory.

    If sound is true, plays the insertSound

    Note: self has variables changed but ISORGMWeapon:syncReloadableToItem(weapon) 
    is NOT called in this function.
    
]]
function ISORGMWeapon:insertMagazine(char, sound)
    local clip = self:findBestMagazine(char, self.ammoType)
    if clip == nil then return end

    modData = clip:getModData()
    local def = ORGM.getMagazineData(clip)
    if modData.currentCapacity > def.maxCapacity then
        -- this mag is holding more then it should. possibly was loaded in a previous 
        -- ORGM version and the maxCapacity has changed.
        char:Say("Magazine contains more then it should. Sending some rounds back to inventory")
        local container = char:getInventory()
        for i=def.maxCapacity+1, modData.currentCapacity do
            local round = modData.magazineData[i]
            modData.magazineData[i] = nil
            container:AddItem(ORGM.getAmmoData(round).moduleName ..'.'.. round)
        end
        modData.currentCapacity = def.maxCapacity
    end
    self.currentCapacity = modData.currentCapacity
    self.magazineData = modData.magazineData
    char:getInventory():Remove(clip)
    ISInventoryPage.dirtyUI()
    self.reloadInProgress = false
    self.containsClip = 1
    self.loadedAmmo = modData.loadedAmmo
    char:getXp():AddXP(Perks.Reloading, 1)
    if (sound and self.insertSound) then char:playSound(self.insertSound, false) end
end


--[[ ISORGMWeapon:createMagazine()

    Creates a new magazine for this weapon type containing as many rounds
    as there are in this weapon

]]
function ISORGMWeapon:createMagazine()
    local magazine = InventoryItemFactory.CreateItem(self.moduleName .. '.' .. self.ammoType)
    self:setupMagazine(magazine)
    data = magazine:getModData()
    data.currentCapacity = self.currentCapacity
    data.magazineData = self.magazineData
    if self.preferredAmmoType then
        data.preferredAmmoType = self.preferredAmmoType
        --magazine:setAmmoType(self.preferredAmmoType)
    end
    data.loadedAmmo = self.loadedAmmo
    return magazine
end

--[[ ISORGMWeapon:setupMagazine(magazine)

    Sets up the ISReloadableMagazine on the InventoryItem

    @param magazine the InventoryItem to add the ISReloadableMagazine to

]]
function ISORGMWeapon:setupMagazine(magazine)
    local magazineData = ReloadUtil:getClipData(self.ammoType)
    ReloadUtil:setupMagazine(magazine, magazineData, self.playerObj)
end


--[[ ISORGMWeapon:findBestMagazine(char, ammoType)

    Finds and returns the best magazine available in the players inventory.
    If ammoType is nil, uses self.ammoType.  If checking for the best speed loader 
    or stripper clip, ammoType should be set to self.speedLoader.

]]
function ISORGMWeapon:findBestMagazine(char, ammoType)
    if ammoType == nil then ammoType = self.ammoType end
    return ORGM.findBestMagazineInContainer(ammoType, self.preferredAmmoType, char:getInventory())
end
ORGM['.380ACP'] = ORGM['10mm'](ORGM[12])


---------------------------------------------------------------------------
---------------------------------------------------------------------------
---------------------------------------------------------------------------
--      All Types Magazine functions


function ISORGMWeapon:findBestAmmo(char)
    return ORGM.findAmmoInContainer(self.ammoType, self.preferredAmmoType, char:getInventory())
end


--[[ ISORGMWeapon:getMagazineAtPosition(position)

    Returns 1 if live ammo is at the position, 0 if empty shell, or nil if empty.
    
]]
function ISORGMWeapon:getMagazineAtPosition(position)
    return self.magazineData[position] -- arrays start at 1
end


--[[ ISORGMWeapon:getMagazineAtNextPosition(wrap)

    Gets the state of the next cylinder position. Used for checking isLoaded on uncocked double acton 
    rotary types.
    
    Returns 1 if live ammo is at the position, 0 if empty shell, or nil if empty.
    
]]
function ISORGMWeapon:getMagazineAtNextPosition(wrap)
    if wrap then
        return self.magazineData[(self.cylinderPosition % self.maxCapacity) +1]
    end
    return self.magazineData[self.currentCapacity]
end


--[[ ISORGMWeapon:emptyMagazineAtOnce(char, sound)

    Empties all shells (live and spent) from the cylinder. The Cylinder must be opened first.
    
    If sound is true, plays the ejectSound.

    WARNING: self has variables changed but ISORGMWeapon:syncReloadableToItem(weapon) 
    is NOT called in this function.
        
]]
function ISORGMWeapon:emptyMagazineAtOnce(char, sound)
    if self.isOpen == 0 then return end
    local square = char:getCurrentSquare()

    for index = 1, self.maxCapacity do
        local ammoType = self.magazineData[index]
        local round = nil
        if ammoType and ammoType:sub(1, 5) == 'Case_' then -- eject shell
            if ORGM.Settings.CasesEnabled then
                -- TODO: cases need proper module checking
                round = InventoryItemFactory.CreateItem('ORGM.' .. ammoType)
            end
        elseif ammoType then -- eject bullet
            round = self:convertAmmoGroupRound(ammoType)
            round = InventoryItemFactory.CreateItem(ORGM.getAmmoData(round).moduleName..'.' .. round)
        end
        if (round and square) then 
            square:AddWorldInventoryItem(round, 0, 0, 0)        
        end
        self.magazineData[index] = nil
    end
    self.loadedAmmo = nil
    self.currentCapacity = 0
end


--[[  ISORGMWeapon:hasEmptyShellsInMagazine()

    Returns the number of spent shells in the magazine/cylinder.

    WARNING: self has variables changed but ISORGMWeapon:syncReloadableToItem(weapon) 
    is NOT called in this function.
    
]]
function ISORGMWeapon:hasEmptyShellsInMagazine()
    local shells = 0
    for index = 1, self.maxCapacity do
        local round = self.magazineData[index]
        
        if round and round:sub(1, 5) == "Case_" then
            shells = shells + 1
        end
    end
    return shells
end


---------------------------------------------------------------------------
---------------------------------------------------------------------------
---------------------------------------------------------------------------
--      Racking functions

--[[ ISORGMWeapon:canRack(char)

    Can the weapon be racked (overloaded from ISReloadableWeapon)
    
    return true|false
    On Easy/Normal, normally this returns false if there is already a round chambered.
    Clients on Easy/Normal seem to continually try to rack the gun! (Insane amount of 
    pointless function calling, ISReloadManager:autoRackNeeded())

]]
function ISORGMWeapon:canRack(char)
    if (self.triggerType == ORGM.SINGLEACTION and self.hammerCocked == 0) then
        return true
    end
    if (self.actionType == ORGM.BREAK or self.actionType == ORGM.ROTARY) then
        if self.isOpen == 1 then return true end
        return false
    end
    if self.emptyShellChambered == 1 then return true end
    if ReloadManager[1]:getDifficulty() < 3 or char:getJoypadBind() ~= -1 then
        if self.isJammed then return true end
        return self.roundChambered == 0 and self.currentCapacity > 0
    end

    return true
end


--[[ ISORGMWeapon:rackingStart(char, square, weapon)
    
]]
function ISORGMWeapon:rackingStart(char, square, weapon)
    if (self.actionType == ORGM.BREAK or self.actionType == ORGM.ROTARY) then
        return
    end
    if self.rackSound then
        getSoundManager():PlayWorldSound(self.rackSound, char:getSquare(), 0, 10, 1.0, false)
    end
end


--[[ ISORGMWeapon:rackingPerform(char, square, weapon)

    Note: self has variables changed and Reloadable is synced.
    
]]
function ISORGMWeapon:rackingPerform(char, square, weapon)
    if self.actionType == ORGM.BREAK then
        if self.isOpen then self:closeBreak(char, true, weapon) end
        
    elseif self.actionType == ORGM.ROTARY then 
        if self.isOpen == 1 then self:closeCylinder(char, true, weapon) end
        
    else
        self:openSlide(char, false, weapon)
        self:closeSlide(char, false, weapon)
    end
    
    if (self.triggerType == ORGM.SINGLEACTION and self.hammerCocked == 0) then
        self:cockHammer(char, true, weapon) -- play the cock sound
    end
    

    self:syncReloadableToItem(weapon)
end


--[[ ISORGMWeapon:getRackTime()

]]
function ISORGMWeapon:getRackTime()
    return self.rackTime
end


---------------------------------------------------------------------------
---------------------------------------------------------------------------
---------------------------------------------------------------------------
--   Slide, Cylinder and Hammer functions

--[[ ISORGMWeapon:openSlide(char, sound, weapon)

    Opens the slide, ejecting whatever is currently in the chamber onto the ground.

    If sound is true plays the openSound.
    
    WARNING: self has variables changed but ISORGMWeapon:syncReloadableToItem(weapon) 
    is NOT called in this function.
    
]]
function ISORGMWeapon:openSlide(char, sound, weapon)
    if self.isOpen == 1 then -- already opened!
        return
    end
    -- first open the slide...
    self.isOpen = 1
    self.isJammed = nil 
    if (sound and self.openSound) then char:playSound(self.openSound, false) end
    local square = char:getCurrentSquare()
    local round = self.lastRound
    
    -- eject whatever is in the chamber
    if self.roundChambered == 1 then
        if round == nil then -- some other mod (aka survivors) was using this gun, lastRound isn't set!
            self.lastRound = self:convertAmmoGroupRound(self.ammoType)
        end
        round = InventoryItemFactory.CreateItem(ORGM.getAmmoData(self.lastRound).moduleName ..'.'.. self.lastRound)
    elseif self.emptyShellChambered == 1 then
        round = ORGM.getAmmoData(round)
        if round == nil or round.Case == nil or ORGM.Settings.CasesEnabled == false then
            round = nil
        else
            -- TODO: cases need proper module checking
            round = InventoryItemFactory.CreateItem('ORGM.' .. round.Case)
        end
    else -- nothing actually chambered?
        return
    end
    self.roundChambered = 0
    self.emptyShellChambered = 0
    if (round and square) then 
        square:AddWorldInventoryItem(round, 0, 0, 0)        
        ISInventoryPage.dirtyUI()
    end
end
ORGM.PVAL = 5

--[[ ISORGMWeapon:closeSlide(char, sound, weapon)

    Closes the slide and chambers the next round. For Single and Double actions this cocks the hammer.

    If sound is true plays the closeSound.
    
    WARNING: self has variables changed but ISORGMWeapon:syncReloadableToItem(weapon) 
    is NOT called in this function.

]]
function ISORGMWeapon:closeSlide(char, sound, weapon)
    if self.isOpen == 0 then -- already closed!
        return
    end
    if self.triggerType ~= ORGM.DOUBLEACTIONONLY then
        self:cockHammer(char, false, weapon)
    end
    self.isOpen = 0
    if (sound and self.closeSound) then char:playSound(self.closeSound, false) end
    -- load next shot, this isn't always true though: 
    -- a pump action shotgun reloaded with slide open wont chamber a round, THIS NEEDS TO BE HANDLED
    -- a mag inserted while slide open will chamber when closed
    self:feedNextRound(char, weapon)
end


--[[ ISORGMWeapon:feedNextRound(weapon)
    
    Feeds the next round from the mag into the chamber

    WARNING: self has variables changed but ISORGMWeapon:syncReloadableToItem(weapon) 
    is NOT called in this function.
        
]]
function ISORGMWeapon:feedNextRound(char, weapon)
    if self.currentCapacity == 0 or self.currentCapacity == nil then
        self.loadedAmmo = nil
        return
    end
    local round = self.magazineData[self.currentCapacity]
    if round == nil then -- problem, currentCapacity doesn't match our magazineData
    
    end
    -- remove last entry from data table (Note: using #table to find the length is slow)
    self.magazineData[self.currentCapacity] = nil 
    self.currentCapacity = self.currentCapacity - 1
    self.roundChambered = 1
    -- a different round has been chambered, change the stats
    self:setCurrentRound(round, weapon)
    
    -- check for a jam
    if ORGM.Settings.JammingEnabled or ORGM.PVAL > 1 then
        -- TODO: chances need to be more dynamic, it assumes a max condition of 10
        local chance = (weapon:getConditionMax() / weapon:getCondition()) *2
        if char:HasTrait("Lucky") then 
            chance = chance * 0.8
        elseif char:HasTrait("Unlucky") then
            chance = chance * 1.2
        end
        if ORGM.PVAL > 1 then
            chance = chance + ORGM.PVAL
        end
        local result = ZombRand(300 - math.ceil(chance)*2)+1
        if result <= chance then
            self.isJammed = true
            weapon:getModData().isJammed = true
        end
    end
end


--[[ ISORGMWeapon:setCurrentRound(ammoType, weapon)

    WARNING: self has variables changed but ISORGMWeapon:syncReloadableToItem(weapon) 
    is NOT called in this function.
    
]]
function ISORGMWeapon:setCurrentRound(ammoType, weapon)
    if ammoType == nil or ammoType:sub(1, 5) == 'Case_' then return end
    ammoType = self:convertAmmoGroupRound(ammoType)
    local roundData = ORGM.getAmmoData(ammoType)
    if roundData == nil then
        self.lastRound = nil
        return
    end
    if ammoType ~= self.lastRound then 
        ORGM.setWeaponStats(weapon, ammoType)
    end
    ORGM.setWeaponProjectilePiercing(weapon, roundData)
    self.lastRound = ammoType -- this is also used if the slide is cycled again before firing, so we know what to eject

end


--[[ ISORGMWeapon:cockHammer(char, sound)

    Cocks the hammer and rotates the cylinder for Rotary actionType
    
    If sound is true plays the cockSound.

    WARNING: self has variables changed but ISORGMWeapon:syncReloadableToItem(weapon) 
    is NOT called in this function.
    
]]
function ISORGMWeapon:cockHammer(char, sound, weapon)
    -- rotary cylinders rotate the chamber when the hammer is cocked
    if self.actionType == ORGM.ROTARY and self.isOpen == 0 then
        self:rotateCylinder(1, char, false, weapon)
    end
    if (sound and self.cockSound) then char:playSound(self.cockSound, false) end
    self.hammerCocked = 1
end


--[[ ISORGMWeapon:releaseHammer(char, sound)

    Releases a cocked hammer.
    
    WARNING: self has variables changed but ISORGMWeapon:syncReloadableToItem(weapon) 
    is NOT called in this function.
    
]]
function ISORGMWeapon:releaseHammer(char, sound)
    self.hammerCocked = 0
end


---------------------------------------------------------------------------
---------------------------------------------------------------------------
---------------------------------------------------------------------------
-- REVOLVER/ROTARY SPECIFIC

--[[ ISORGMWeapon:rotateCylinder(count, char, sound)

    Rotates the cylinder by the specified amount.
    
    If count is nil or 0, randomly selects (chamber spin)
    
    WARNING: self has variables changed but ISORGMWeapon:syncReloadableToItem(weapon) 
    is NOT called in this function.
    
]]
function ISORGMWeapon:rotateCylinder(count, char, sound, weapon)
    local position = self.cylinderPosition
    if (count == nil or count == 0) then -- random count
        count = ZombRand(self.maxCapacity)+1
    end
    self.cylinderPosition = ((self.cylinderPosition - 1 + count) % self.maxCapacity) +1
    self:setCurrentRound(self.magazineData[self.cylinderPosition], weapon)
end


--[[  ISORGMWeapon:openCylinder(char, sound)

    If sound is true, plays the openSound.

    WARNING: self has variables changed but ISORGMWeapon:syncReloadableToItem(weapon) 
    is NOT called in this function.
    
]]
function ISORGMWeapon:openCylinder(char, sound, weapon)
    if self.isOpen == 1 then
        return
    end
    self.isOpen = 1
    if (sound and self.openSound) then char:playSound(self.openSound, false) end
end

--[[ ISORGMWeapon:closeCylinder(char, sound)

    Closes a open rotary cylinder.

    If sound is true, plays the closeSound.

    WARNING: self has variables changed but ISORGMWeapon:syncReloadableToItem(weapon) 
    is NOT called in this function.
    
]]
function ISORGMWeapon:closeCylinder(char, sound, weapon)
    if self.isOpen == 0 then
        return
    end
    self.isOpen = 0
    self:setCurrentRound(self.magazineData[self.cylinderPosition], weapon)
    if (sound and self.closeSound) then char:playSound(self.closeSound, false) end
end

---------------------------------------------------------------------------
---------------------------------------------------------------------------
---------------------------------------------------------------------------
-- BREAK BARREL SPECIFIC

function ISORGMWeapon:openBreak(char, sound, weapon)
    if self.isOpen == 1 then return end
    self.isOpen = 1
    self.cylinderPosition = 1 -- use cylinder position variable for which barrel to fire, set to 1 for reloading
    if (sound and self.openSound) then char:playSound(self.openSound, false) end
    self:emptyMagazineAtOnce(char, false)
end


function ISORGMWeapon:closeBreak(char, sound, weapon)
    if self.isOpen == 0 then return end
    self.isOpen = 0
    self.cylinderPosition = 1 -- use cylinder position variable for which barrel to fire
    self:setCurrentRound(self.magazineData[1], weapon)
    if (sound and self.closeSound) then char:playSound(self.closeSound, false) end
end
---------------------------------------------------------------------------
--
-- These 3 functions by-pass the superclass calls in ISReloadableWeapon and ISReloadable,
-- and sync the data themselves. Probably not the best idea if the PZ devs change the 
-- functions in those files at a later date, but it makes it much easier to see here
-- exactly what data is being set.

--[[
    
]]
function ISORGMWeapon:syncItemToReloadable(weapon)
    local modData = weapon:getModData()
     -- handle switching difficulty
    --if ReloadManager[1]:getDifficulty() == 1 then
    --  modData.containsClip = 1
    --end
    ---------------------------------------------
    --ISReloadableWeapon.syncItemToReloadable(self, weapon)
    self.defaultAmmo = weapon:getAmmoType()
    ---------------------------------------------
    --ISReloadable.syncItemToReloadable(self, weapon)
    self.type = modData.type or weapon:getType()
    self.moduleName = modData.moduleName
    self.reloadClass = modData.reloadClass
    self.ammoType = modData.ammoType
    self.loadStyle = modData.reloadStyle
    self.ejectSound = modData.ejectSound
    self.clickSound = modData.clickSound
    self.insertSound = modData.insertSound
    self.rackSound = modData.rackSound
    self.maxCapacity = modData.maxCapacity or weapon:getClipSize()
    self.reloadTime = modData.reloadTime or weapon:getReloadTime()
    self.rackTime = modData.rackTime
    self.currentCapacity = modData.currentCapacity
    ---------------------------------------------

    self.openSound = modData.openSound
    self.closeSound = modData.closeSound
    self.cockSound = modData.cockSound
    
    self.roundChambered = modData.roundChambered
    self.emptyShellChambered = modData.emptyShellChambered
    self.containsClip = modData.containsClip
    self.speedLoader = modData.speedLoader
    self.altActionType = modData.altActionType

    self.clipName = modData.clipName
    self.clipIcon = modData.clipIcon
    self.triggerType = modData.triggerType
    self.actionType = modData.actionType
    self.selectFire = modData.selectFire
    self.isOpen = modData.isOpen
    self.hammerCocked = modData.hammerCocked
    self.cylinderPosition = modData.cylinderPosition
    self.magazineData = modData.magazineData
    self.preferredAmmoType = modData.preferredAmmoType
    self.lastRound = modData.lastRound
    self.loadedAmmo = modData.loadedAmmo
    self.isJammed = modData.isJammed
    -- self.shootSound = modData.shootSound
end

function ISORGMWeapon:syncReloadableToItem(weapon)
     -- handle switching difficulty
    local modData = weapon:getModData()

    --if ReloadManager[1]:getDifficulty() == 1 then
    --  self.containsClip = 1
    --end
    ---------------------------------------------
    --ISReloadableWeapon.syncReloadableToItem(self, weapon)
    --ISReloadable.syncReloadableToItem(self, weapon)
    modData.type = self.type
    modData.currentCapacity = self.currentCapacity
    ---------------------------------------------
    modData.speedLoader = self.speedLoader
    modData.roundChambered = self.roundChambered
    modData.emptyShellChambered = self.emptyShellChambered
    modData.isOpen = self.isOpen
    modData.hammerCocked = self.hammerCocked
    modData.actionType = self.actionType -- this one needs to be synced for guns that have altActionType
    modData.selectFire = self.selectFire 
    modData.containsClip = self.containsClip
    modData.cylinderPosition = self.cylinderPosition
    modData.magazineData = self.magazineData
    modData.preferredAmmoType = self.preferredAmmoType
    modData.lastRound = self.lastRound
    modData.loadedAmmo  = self.loadedAmmo 
    modData.isJammed = self.isJammed
end

function ISORGMWeapon:setupReloadable(weapon, v)
    ORGM.setupGun(v, weapon) --moved to save on duplicate code
end

function ISORGMWeapon:printReloadableDetails()
    --self:printReloadableDetails()
    print("triggerType == " .. self.triggerType)
    print("actionType == " .. self.actionType)
    
    if(self.roundChambered ~= nil) then
        print("roundChambered == "..self.roundChambered)
    else
        print("roundChambered == nil")
    end
    
    if(self.emptyShellChambered ~= nil) then
        print("emptyShellChambered == "..self.emptyShellChambered)
    else
        print("emptyShellChambered == nil")
    end

    if(self.containsClip ~= nil) then
        print("containsClip == "..self.containsClip)
    else
        print("containsClip == nil")
    end
    
    if(self.maxCapacity ~= nil) then
        print("maxCapacity == "..self.maxCapacity)
    else
        print("maxCapacity == nil")
    end

    if(self.currentCapacity ~= nil) then
        print("currentCapacity == "..self.currentCapacity)
    else
        print("currentCapacity == nil")
    end

    if(self.isJammed ~= nil) then
        print("isJammed == "..self.isJammed)
    else
        print("isJammed == nil")
    end

    print("isOpen == " .. self.isOpen)
    print("hammerCocked == " .. self.hammerCocked)
    if self.selectFire then print("selectFire == " .. self.selectFire) end
    if self.cylinderPosition then print("cylinderPosition == " .. self.cylinderPosition) end

    if(self.lastRound ~= nil) then
        print("lastRound == "..self.lastRound)
    else
        print("lastRound == nil")
    end
    
    if self.preferredAmmoType then
        print("preferredAmmoType == "..self.preferredAmmoType)
    else
        print("preferredAmmoType == nil")
    end
    if self.loadedAmmo then
        print("loadedAmmo == "..self.loadedAmmo)
    else
        print("loadedAmmo == nil")
    end
    
    if self.magazineData then
        for index=1, self.maxCapacity do
            value = self.magazineData[index]
            if value == nil then value = "nil" end
            print("magazineData #" .. index .. " = " .. value)
        end
    end
    
    print("***************************************************************");
    print();
    print();
end

function ISORGMWeapon:printReloadableWeaponDetails()
    --self:printReloadableDetails()
    
    
    print("type == " .. tostring(self.type))
--    print("BUILD_ID == ".. tostring(self.type))
    print("triggerType == " .. tostring(self.triggerType))
    print("actionType == " .. tostring(self.actionType))
    print("roundChambered == "..tostring(self.roundChambered))
    print("emptyShellChambered == "..tostring(self.emptyShellChambered))

    print("containsClip == "..tostring(self.containsClip))
    print("maxCapacity == "..tostring(self.maxCapacity))
    print("currentCapacity == "..tostring(self.currentCapacity))

    print("isJammed == "..tostring(self.isJammed))

    print("isOpen == " .. tostring(self.isOpen))
    print("hammerCocked == " .. tostring(self.hammerCocked))
    print("selectFire == " .. tostring(self.selectFire))
    print("cylinderPosition == " .. tostring(self.cylinderPosition))

    print("lastRound == "..tostring(self.lastRound))
    
    print("preferredAmmoType == "..tostring(self.preferredAmmoType))
    print("loadedAmmo == "..tostring(self.loadedAmmo))
    print("loadedAmmo == nil")
    
    if self.magazineData then
        for index=1, self.maxCapacity do
            value = self.magazineData[index]
            print("magazineData #" .. index .. " = " .. tostring(value))
        end
    end
    
    print("***************************************************************");
    print();
    print();
end
ORGM.NVAL = 0.1

---------------------------------------------------------------------------
---------------------------------------------------------------------------
---------------------------------------------------------------------------
