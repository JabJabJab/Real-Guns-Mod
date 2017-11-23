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
    
    
    TODO: fix speed loader code
    TODO: slides should lock open after last shot

    
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
    local o = {}
    o = ISReloadableWeapon:new()
    setmetatable(o, self)
    self.__index = self
    return o
end

--[[ Debugging function, delete all instances in code before stable release
]]
function ISORGMWeapon:testDebug(text)
    -- sometimes self.playerObj is not quite real and has no :Say() method.  Seems to be the case
    -- when this class is accessed from odd places (like context menus). Strangely cant seem to find
    -- where playerObj is actually set (must be in the java components on events?)
    if self.playerObj and self.playerObj.Say then self.playerObj:Say(text) end
    print(text)
end


--[[ ISORGMWeapon:isLoaded(difficulty)

    called when the player clicks to determine if ISORGMWeapon:fireShot should be called
    also called after the shot is taken
    
    return true|false
]] 
function ISORGMWeapon:isLoaded(difficulty)
    -- cant fire with a open slide
    if self.isOpen == 1 then 
        return false
    end
    -- single action with hammer at rest cant fire
    if (self.hammerCocked == 0 and self.triggerType == "SingleAction") then
        return false
    end

    if self.actionType == "Rotary" then 
        local round = nil
        if self.hammerCocked == 1 then
            round = self.magazineData[self.cylinderPosition]
        else
            round = self:getMagazineAtNextPosition(true)
        end
        if round == nil or round == 'shell' then return false end
        return true
    
    elseif self.actionType == "Break" then
        local round = self.magazineData[self.cylinderPosition]
        if round == nil or round == 'shell' then return false end
        return true        
    end
    
    -- anything else needs a live round chambered
    return self.roundChambered > 0
end


--[[ ISORGMWeapon:fireShot(weapon, difficulty)

    called when the actual shot is fired

    Note: self has variables changed and Reloadable is synced.
    
]]
function ISORGMWeapon:fireShot(weapon, difficulty)
    if self.hammerCocked == 0 then -- SA already has hammer cocked by this point, 
        self:cockHammer(self.playerObj, false, weapon) -- chamber rotates here for revolvers
    end
    self:releaseHammer(self.playerObj, false)
    
    if self.actionType == "Auto" then
        --fire shot
        self.roundChambered = 0
        self.emptyShellChambered = 1
        self:openSlide(self.playerObj, false, weapon)
        self:closeSlide(self.playerObj, false, weapon) -- chambers next shot, cocks hammer for SA/DA

    elseif self.actionType == "Rotary" then
        -- fire shot
        self.magazineData[self.cylinderPosition] = "shell"
        self.currentCapacity = self.currentCapacity - 1
        
    elseif self.actionType == "Break" then
        -- fire shot
        self.magazineData[self.cylinderPosition] = "shell"
        self.currentCapacity = self.currentCapacity - 1
        self.cylinderPosition = self.cylinderPosition + 1 -- this can bypass our maxCapacity limit
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

    called when the trigger is pulled on a empty chamber

    Note: self MIGHT have variable changed and Reloadable is synced.

]]
function ISORGMWeapon:fireEmpty(char, weapon)
    if self.hammerCocked == 1 then
        self:releaseHammer(char, false)
    elseif self.actionType ~= "SingleAction" then
        self:cockHammer(char, false, weapon)
        self:releaseHammer(char, false)
    end
    self:syncReloadableToItem(weapon)
end


--[[ ISORGMWeapon:canReload(char)

    Whether the character attempting to reload has the necessary
    prerequisites to perform the reload action. Called prior to
    the timed action and not to be confused with isReloadValid
    
    return true|false
    
]]
function ISORGMWeapon:canReload(char)
    -- TODO: implement SpeedLoader check
    local result = false
    if self.containsClip == 1 then -- a magazine is currently in place, we can unload
        result = true
    elseif self.containsClip == 0 then -- gun uses magazines, but none loaded. check if player has some
       result = char:getInventory():FindAndReturn(self.ammoType) ~= nil         
    
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
        if self.actionType == "Rotary" then
            -- TODO: this needs to sync, causes issues
            self:openCylinder(char, true, weapon) -- play the open sound
            -- if rotary and contains spent shells, we need to empty the cylinder. this is all or nothing
            if self:hasEmptyShellsInMagazine() > 0 then
                self:emptyMagazineAtOnce(char, true)
            end
        elseif self.actionType == "Break" then
            self:openBreak(char, true, weapon)
        end
    end

end


--[[ ISORGMWeapon:reloadPerform(char, square, difficulty, weapon)
    
    performed upon successful completion of the timed action.
    
    Note: self has variables changed and Reloadable is synced.
    
]]
function ISORGMWeapon:reloadPerform(char, square, difficulty, weapon)
    -- TODO: Implement SpeedLoaders
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
        if self.actionType == "Rotary" then
            self:rotateCylinder(1, char, true, weapon)
            if self.magazineData[self.cylinderPosition] ~= nil then -- something is in this spot, return now
                return
            end
        end
        getSoundManager():PlayWorldSound(self.insertSound, char:getSquare(), 0, 10, 1.0, false)
        
        self:loadRoundIntoMagazine(round, weapon, self.cylinderPosition) -- cylinderPosition will be nil for non-rotary
        if self.actionType == "Break" then
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


--[[ ISORGMWeapon:loadRoundIntoMagazine(round, weapon, position)
    
    Loads a round into a internal magazine or cylinder.

    Note: self has variables changed but ISORGMWeapon:syncReloadableToItem(weapon) 
    is NOT called in this function.
    
]]
function ISORGMWeapon:loadRoundIntoMagazine(round, weapon, position)
    if self.currentCapacity == self.maxCapacity then return end
    self.currentCapacity = self.currentCapacity + 1
    if position == nil then position = self.currentCapacity end
    self.magazineData[position] = self:convertDummyRound(round)

    if self.loadedAmmo == nil then
        self.loadedAmmo = round
    elseif self.loadedAmmo ~= round then
        self.loadedAmmo = 'mixed'
    end
end

--[[ ISORGMWeapon:convertDummyRound(round)
    Converts a dummy round to a real round if required. Some mods like Survivors don't handle
    the new ammo system properly, and guns are always loaded with dummy ammo.
]]
function ISORGMWeapon:convertDummyRound(round)
    ammoType = self.ammoType
    if self.containsClip ~= nil then -- get the mag's ammo type
        ammoType = ReloadUtil:getClipData(self.ammoType).ammoType
    end
    --print("R: " .. round .. " A: " .. ammoType)
    if round == ammoType then -- a dummy round is being used
        print("CONVERTING DUMMY ROUND " .. round .. " > ".. ORGMAlternateAmmoTable[round][1])
        round = ORGMAlternateAmmoTable[round][1]
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
    if self.actionType == "Rotary" then
        self:openCylinder(char, true)
        -- revolvers drop them all at once
        self:emptyMagazineAtOnce(char, false)
        self.unloadInProgress = false
        self:syncReloadableToItem(weapon)
        return false
    end
    if self.actionType == "Break" then
        self:openBreak()
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
    if self.actionType == "Rotary" or self.actionType == "Break" then return false end
    return true
end

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
    if (sound and self.ejectSound) then char:playSound(self.ejectSound, true) end
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
    self.currentCapacity = modData.currentCapacity
    self.magazineData = modData.magazineData
    char:getInventory():Remove(clip)
    ISInventoryPage.dirtyUI()
    self.reloadInProgress = false
    self.containsClip = 1
    self.loadedAmmo = modData.loadedAmmo
    char:getXp():AddXP(Perks.Reloading, 1)
    if (sound and self.insertSound) then char:playSound(self.insertSound, true) end
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
    if ammoType == nil then
        ammoType = self.ammoType
    end
    local clip = nil
    local mostAmmo = -1
    -- TODO: this needs a extra loop here, for possible alternate magazines
    local items = char:getInventory():getItems()
    local requiredClipData = ReloadUtil:getClipData(ammoType)
    
    for i = 0, items:size()-1 do
        local currentItem = items:get(i)
        -- This may be the first time the item is used
        -- best call setupMagazine and see if it's a clip
        local currentReloadable = ReloadUtil:setupMagazine(currentItem, requiredClipData, char)
        -- Was the item a clip?
        if currentReloadable ~= nil then
            if currentReloadable.clipType == requiredClipData.clipType then
                if currentReloadable.currentCapacity == nil then -- not properly setup? skip it
                    -- pass
                
                elseif currentReloadable.currentCapacity > mostAmmo then -- check the amount of ammo
                    if (self.preferredAmmoType == nil or self.preferredAmmoType == 'any') then
                        -- this gun is configured to use any ammo, so this is best mag so far
                        clip = currentItem
                        mostAmmo = currentReloadable.currentCapacity
                    elseif self.preferredAmmoType == currentReloadable.loadedAmmo then
                        -- magazine is only loaded with our preferred type.
                        clip = currentItem
                        mostAmmo = currentReloadable.currentCapacity                    
                    end
                end
            end
        end
    end
    return clip
end


---------------------------------------------------------------------------
---------------------------------------------------------------------------
---------------------------------------------------------------------------
--      All Types Magazine functions


function ISORGMWeapon:findBestAmmo(char)
    if self.preferredAmmoType ~= nil and self.preferredAmmoType ~= "any" and self.preferredAmmoType ~= 'mixed' then
        -- a preferred ammo is set, we only look for these bullets
        return char:getInventory():FindAndReturn(self.preferredAmmoType)
    end
    local round = char:getInventory():FindAndReturn(self.ammoType) -- this shouldn't actually be here, self.ammoType is just a dummy round
    if round then return round end
    -- check if there are alternate ammo types we can use
    local roundTable = ORGMAlternateAmmoTable[self.ammoType]
    if roundTable == nil then return nil end -- there should always be a entry
    if self.preferredAmmoType == 'mixed' then
        local options = {}
        for _, value in ipairs(roundTable) do
            -- check what rounds the player has
            if char:getInventory():FindAndReturn(value) then table.insert(options, value) end
        end
        -- randomly pick one
        return char:getInventory():FindAndReturn(options[ZombRand(#options) + 1])
        
    else -- not a random picking, go through the list in order
        for _, value in ipairs(roundTable) do
            round = char:getInventory():FindAndReturn(value)
            if round then return round end
        end
    end
    return nil
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
        if ammoType == 'shell' then -- eject shell
            -- round = InventoryItemFactory.CreateItem('ORGM.' .. self.ammoType .. '_shell')
        elseif ammoType then -- eject bullet
            round = InventoryItemFactory.CreateItem('ORGM.' .. self:convertDummyRound(ammoType))
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
        if self.magazineData[index] == "shell" then
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
    if (self.triggerType == "SingleAction" and self.hammerCocked == 0) then
        return true
    end
    if (self.actionType == "Break" or self.actionType == "Rotary") then
        if self.isOpen == 1 then return true end
        return false
    end
    if self.emptyShellChambered == 1 then return true end
    if ReloadManager[1]:getDifficulty() < 3 or char:getJoypadBind() ~= -1 then
        return self.roundChambered == 0 and self.currentCapacity > 0
    end

    return true
end


--[[ ISORGMWeapon:rackingStart(char, square, weapon)
    
]]
function ISORGMWeapon:rackingStart(char, square, weapon)
    if (self.actionType == "Break" or self.actionType == "Rotary") then
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
    if self.actionType == "Break" then
        if self.isOpen then self:closeBreak(char, true, weapon) end
        
    elseif self.actionType == "Rotary" then 
        if self.isOpen == 1 then self:closeCylinder(char, true, weapon) end
        
    else
        self:openSlide(char, false, weapon)
        self:closeSlide(char, false, weapon)
    end
    
    if (self.triggerType == "SingleAction" and self.hammerCocked == 0) then
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
    if (sound and self.openSound) then char:playSound(self.openSound, true) end
    local square = char:getCurrentSquare()
    local round = self.lastRound
    
    -- eject whatever is in the chamber
    if self.roundChambered == 1 then
        if round == nil then -- some other mod (aka survivors) was using this gun, lastRound isn't set!
            self.lastRound = self:convertDummyRound(self.ammoType)
        end
        round = InventoryItemFactory.CreateItem('ORGM.' .. self.lastRound)
    elseif self.emptyShellChambered == 1 then
        -- round = InventoryItemFactory.CreateItem('ORGM.' .. round .. '_shell')
        round = nil -- TODO: use the above line instead when empty shells are added
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
    if self.triggerType ~= "DoubleActionOnly" then -- some double action only actions don't cock the hammer on close
        self:cockHammer(char, false, weapon)
    end
    self.isOpen = 0
    if (sound and self.closeSound) then char:playSound(self.closeSound, true) end
    -- load next shot, this isn't always true though: 
    -- a pump action shotgun reloaded with slide open wont chamber a round, THIS NEEDS TO BE HANDLED
    -- a mag inserted while slide open will chamber when closed
    self:feedNextRound(weapon)
end


--[[ ISORGMWeapon:feedNextRound(weapon)
    
    Feeds the next round from the mag into the chamber

    WARNING: self has variables changed but ISORGMWeapon:syncReloadableToItem(weapon) 
    is NOT called in this function.
        
]]
function ISORGMWeapon:feedNextRound(weapon)
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
end


--[[ ISORGMWeapon:setCurrentRound(round, weapon)

    WARNING: self has variables changed but ISORGMWeapon:syncReloadableToItem(weapon) 
    is NOT called in this function.
    
]]
function ISORGMWeapon:setCurrentRound(round, weapon)
    if round == nil or round == 'shell' then return end
    round = self:convertDummyRound(round)
    local roundData = ORGMAmmoStatsTable[round]
    if roundData == nil then
        self.lastRound = nil
        return
    end
    if round ~= self.lastRound then 
        if roundData.MaxDamage then weapon:setMaxDamage(roundData.MaxDamage) end
        if roundData.MinDamage then weapon:setMinDamage(roundData.MinDamage) end
        -- shotguns: we can't change the ProjectileCount for buckshot/slug swapping, theres no function for it.
        -- but we can change the MaxHitCount, so while the slug ends up firing multiple projectiles, only 1 will hit
        -- in testing this works.
        if roundData.MaxHitCount then weapon:setMaxHitCount(roundData.MaxHitCount) end
        
    end
    if roundData.PiercingBullets == true or roundData.PiercingBullets == false then
        weapon:setPiercingBullets(roundData.PiercingBullets)
    elseif roundData.PiercingBullets ~= nil then 
        local result = ZombRand(roundData.PiercingBullets) + 1
        if result <= roundData.PiercingBullets then
            weapon:setPiercingBullets(true)
        else
            weapon:setPiercingBullets(true)
        end
    end
    self.lastRound = round -- this is also used if the slide is cycled again before firing, so we know what to eject

end


--[[ ISORGMWeapon:cockHammer(char, sound)

    Cocks the hammer and rotates the cylinder for Rotary actionType
    
    If sound is true plays the cockSound.

    WARNING: self has variables changed but ISORGMWeapon:syncReloadableToItem(weapon) 
    is NOT called in this function.
    
]]
function ISORGMWeapon:cockHammer(char, sound, weapon)
    -- rotary cylinders rotate the chamber when the hammer is cocked
    if self.actionType == "Rotary" and self.isOpen == 0 then
        self:rotateCylinder(1, char, false, weapon)
    end
    if (sound and self.cockSound) then char:playSound(self.cockSound, true) end
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
    if (sound and self.openSound) then char:playSound(self.openSound, true) end
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
    if (sound and self.closeSound) then char:playSound(self.closeSound, true) end
end

---------------------------------------------------------------------------
---------------------------------------------------------------------------
---------------------------------------------------------------------------
-- BREAK BARREL SPECIFIC

function ISORGMWeapon:openBreak(char, sound, weapon)
    if self.isOpen == 1 then return end
    self.isOpen = 1
    self.cylinderPosition = 1 -- use cylinder position variable for which barrel to fire, set to 1 for reloading
    if (sound and self.openSound) then char:playSound(self.openSound, true) end
    self:emptyMagazineAtOnce(char, false)
end


function ISORGMWeapon:closeBreak(char, sound, weapon)
    if self.isOpen == 0 then return end
    self.isOpen = 0
    self.cylinderPosition = 1 -- use cylinder position variable for which barrel to fire
    self:setCurrentRound(self.magazineData[1], weapon)
    if (sound and self.closeSound) then char:playSound(self.closeSound, true) end    
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
end

function ISORGMWeapon:setupReloadable(weapon, v)
    local modData = weapon:getModData()

    ---------------------------------------------
    -- ISReloadableWeapon.setupReloadable(self, weapon, v)
    modData.defaultAmmo = weapon:getAmmoType()
    --weapon:setAmmoType(nil) -- this controls our tooltip
    modData.defaultSwingSound = weapon:getSwingSound()
    ---------------------------------------------

    --ISReloadable:setupReloadable(item, v)
    modData.type = v.type
    modData.moduleName = v.moduleName
    modData.reloadClass = v.reloadClass
    modData.ammoType = v.ammoType
    modData.loadStyle = v.reloadStyle
    modData.ejectSound = v.ejectSound
    modData.clickSound = v.clickSound
    modData.insertSound = v.insertSound
    modData.rackSound = v.rackSound
    modData.maxCapacity = v.maxCapacity or weapon:getClipSize()
    modData.reloadTime = v.reloadTime or weapon:getReloadTime()
    modData.rackTime = v.rackTime
    modData.currentCapacity = 0
    ---------------------------------------------

    -- custom stuff
    if v.cockSound then modData.cockSound = v.cockSound end
    if v.openSound then modData.openSound = v.openSound end
    if v.closeSound then modData.closeSound = v.closeSound end
    
    if v.clipData then modData.containsClip = 1 end
    if v.clipName then modData.clipName = v.clipName end
    if v.clipIcon then modData.clipIcon = v.clipIcon end

    modData.weaponType = v.weaponType -- Rifle, SMG, Shotgun, Pistol, Revolver, LMG (currently not used)
    modData.actionType = v.actionType -- Auto, Pump, Lever, Rotary, Break
    modData.triggerType = v.triggerType -- SingleAction, DoubleAction
    if v.speedLoader then modData.speedLoader = v.speedLoader end -- speedloader/stripperclip name
    -- alternate action type, ie: semi auto that can also be pump, etc. This is a table list of all actionTypes used by the gun
    if v.altActionType then modData.altActionType = v.altActionType end 
    -- selectFire is nil for no selection possible, 0 if the weapon is CURRENTLY in semi-auto, 1 if CURRENTLY in full-auto
    if v.selectFire then modData.selectFire = v.selectFire end 
    
    if modData.actionType == "Rotary" then
        modData.cylinderPosition = 1 -- position is 1 to maxCapacity (required for % oper to work properly)
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


function ISORGMWeapon:printReloadableWeaponDetails()
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


---------------------------------------------------------------------------
---------------------------------------------------------------------------
---------------------------------------------------------------------------
