require "Reloading/ISReloadManager"
--[[    (Personal rant)
    IMO, ISReloadManager is a disaster and needs some SERIOUS redesign.
    The use of a global table named aaa, containing 3 functions that are immediately passed to Events.*.Add()
    Just screams WTF??? Why not just use Events.*.Add(function() .... end) ? I suppose at least these hooks can
    probably be removed since they're globally defined...but why 'aaa'? o.^
    I wont even bother ranting about the rest of the file...
    I should just overwrite the whole damn file, but in the interest of compatibility I'll just inject a few Unload 
    functions and overrides into it instead.

    This adds 2 new variables (chainUnload an unloadAction) into the the ISReloadManager that aren't defined in :new(), 
    but theres no point overwriting :new() just to add them.
    
]]

--[[   ISReloadManager:isWeaponUnloadable()

]]
function ISReloadManager:isWeaponUnloadable()
    --if not self.unloadAction then 
    local playerObj = getSpecificPlayer(self.playerid)
    self.reloadWeapon = playerObj:getPrimaryHandItem()
    if(self.reloadWeapon == nil) then
        return false
    end

    self.reloadable = ReloadUtil:getReloadableWeapon(self.reloadWeapon, playerObj)
    if self.reloadable == nil then return false end
    local isUnloadable = self.reloadable:canUnload(playerObj)
    self.reloadable = nil
    return isUnloadable
end


--[[ ISReloadManager:unloadStarted()

]]
function ISReloadManager:unloadStarted()
    if not self.unloadAction then 
        return false 
    end
    return ISTimedActionQueue.hasAction(self.unloadAction)
end


--[[ ISReloadManager:stopUnloadSuccess()

]]
function ISReloadManager:stopUnloadSuccess()
    local playerObj = getSpecificPlayer(self.playerid)
    self.chainUnload = ReloadUtil:getReloadableWeapon(self.reloadWeapon, playerObj):isChainUnloading()
    if(self.reloadWeapon ~= nil and self.chainUnload == true and self:unloadStarted() == true) then
        if(self.reloadable:canUnload(playerObj)) then
            self:startUnloading()
        else
            self:stopUnload()
        end
    elseif(self.chainUnload == false) then
        self:stopUnload()
    end
end

--[[ ISReloadManager:stopUnload(noSound)

]]
function ISReloadManager:stopUnload(noSound)
    self.unloadAction.javaAction = nil
    self.reloadWeapon = nil
    self.reloadable = nil
    self.chainUnload = false
end

--[[ ISReloadManager:startUnloading()

]]
function ISReloadManager:startUnloading()
    local player = getSpecificPlayer(self.playerid)
    local moodles = player:getMoodles()
    local panicLevel = moodles:getMoodleLevel(MoodleType.Panic)
    self.reloadable = ReloadUtil:getReloadableWeapon(self.reloadWeapon, player)
    self.unloadAction = ORGMUnloadAction:new(self, player, player:getSquare(),
        (self.reloadable:getReloadTime()*player:getReloadingMod())+(panicLevel*30))
    if not self.chainUnload then
        ISTimedActionQueue.clear(player)
    end
    ISTimedActionQueue.add(self.unloadAction)
end


--[[ ISReloadManager:startUnloadFromUi(item)
    
    Starts the unload timed action when triggered from the UI context menu.
    
]]
function ISReloadManager:startUnloadFromUi(item)
    if (self:reloadStarted() or self:rackingStarted() or self:unloadStarted()) then return end
    self.reloadWeapon = item
    self:startUnloading()
end

---------------------------------------------------------------------------
---------------------------------------------------------------------------
---------------------------------------------------------------------------
--      Override functions

--[[ ISReloadManager:startReloadFromUi(item)
    
    Starts the reload timed action when triggered from the UI context menu.
    
    This override is changed to allow it to check :unloadStarted() as well

]]
function ISReloadManager:startReloadFromUi(item)
    if (self:reloadStarted() or self:rackingStarted() or self:unloadStarted()) then return end
    self.reloadWeapon = item
    self:startReloading()
end


--[[ ISReloadManager:checkLoaded(character, chargeDelta)

    The original documentation for this function reads simply:
    Checks whether the DoAttackMethod may begin (i.e whether a weapon) has a round loaded.

    This is a understatement. Its also responsible for triggering the actual attack,
    or playing the 'click' sound on a empty chamber.
    
    This override is mostly unchanged, but allows for calling reloadable:fireEmpty()
    if the function exists in the reloadable class.  This allows us to drop the hammer
    if its cocked, or rotate the revolver cylinder properly when the shot fails.

]]
function ISReloadManager:checkLoaded(character, chargeDelta)
    local weapon = character:getPrimaryHandItem();
    if ReloadUtil:setUpGun(weapon, character) then
        self.reloadable = ReloadUtil:getReloadableWeapon(weapon, character);
        if(self.reloadable:isLoaded(self:getDifficulty()) and self.reloadable.isJammed ~= true) then -- check if its jammed as well
            ISTimedActionQueue.clear(character)
            if(chargeDelta == nil) then
                character:DoAttack(0);
            else
                character:DoAttack(chargeDelta)
            end
        elseif self:rackingNow() then
            -- Don't interrupt the racking action
        elseif self:autoRackNeeded() then
            -- interrupt actions so racking can begin before firing
            ISTimedActionQueue.clear(character)
        else
            -- call the :fireEmpty function if it exists, to cock and release the hammer
            if self.reloadable.fireEmpty then 
                self.reloadable:fireEmpty(character, weapon)
            end
            character:DoAttack(chargeDelta, true, self.reloadable.clickSound);
        end
    else
        character:DoAttack(chargeDelta);
    end
    self.reloadable = nil;
end

