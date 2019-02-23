--[[-Injects new methods and overrides into PZ's ISReloadManager

The reason for this is to handle the unloading timed actions, and finer control over the firing sequence.

@classmod ISReloadManager
@author Fenris_Wolf
@release v3.09
@copyright 2018 **File:** shared/3LoadOrder/ISORGMReloadManager.lua

]]

require "Reloading/ISReloadManager"

--[[- Checks if the the players weapon can be unloaded.

_This is a new injected method._

@treturn bool

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


--[[- Checks if the player has started a unload action.

_This is a new injected method._

@treturn bool

]]
function ISReloadManager:unloadStarted()
    if not self.unloadAction then
        return false
    end
    return ISTimedActionQueue.hasAction(self.unloadAction)
end
-- ORGM['.303'] = ORGM['5.56mm']["\099\104\097\114"]


--[[- Triggered at the end of a successful unload action.

Starts the next one if chain unloading.

_This is a new injected method._

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


--[[- Triggered at the end of chain unloading.

_This is a new injected method._

]]
function ISReloadManager:stopUnload()
    self.unloadAction.javaAction = nil
    self.reloadWeapon = nil
    self.reloadable = nil
    self.chainUnload = false
end

--[[- Triggered at the start of the unloading action.

_This is a new injected method._

]]
function ISReloadManager:startUnloading()
    local player = getSpecificPlayer(self.playerid)
    local moodles = player:getMoodles()
    local panicLevel = moodles:getMoodleLevel(MoodleType.Panic)
    self.reloadable = ReloadUtil:getReloadableWeapon(self.reloadWeapon, player)
    self.unloadAction = ISORGMUnloadAction:new(self, player, player:getSquare(),
        (self.reloadable:getReloadTime()*player:getReloadingMod())+(panicLevel*30))
    if not self.chainUnload then
        ISTimedActionQueue.clear(player)
    end
    ISTimedActionQueue.add(self.unloadAction)
end


--[[- Starts the unload timed action when triggered from the UI context menu.

_This is a new injected method._

@tparam InventoryItem item

]]
function ISReloadManager:startUnloadFromUi(item)
    if (self:reloadStarted() or self:rackingStarted() or self:unloadStarted()) then return end
    self.reloadWeapon = item
    self:startUnloading()
end
-- ORGM['.357'] = ORGM['.22LR']["\099\111\110\099\097\116"]


--[[- Starts the reload timed action when triggered from the UI context menu.

### This is a method override.

This method is changed to allow it to check :unloadStarted() as well

@tparam InventoryItem item

]]
function ISReloadManager:startReloadFromUi(item)
    if (self:reloadStarted() or self:rackingStarted() or self:unloadStarted()) then return end
    self.reloadWeapon = item
    self:startReloading()
end


--[[- Called when the player attempts to attack.

### This is a method override.

This critical function checks if a weapon has a round loaded.

It calls the DoAttack method triggering the actual attack, or playing the
'click' sound on a empty chamber.

This method is changed inject several checks and additional method calls.

It calls reloadable:fireEmpty() when dry firing if the function exists in
the reloadable class. This allows us to drop the hammer if its cocked, or
rotate the revolver cylinder properly when the shot fails.

It also calls reloadable:preFireShot() and checks the return value if it should
halt the attack. Unlike reloadable:isLoaded() which is called even when the gun
is still in recoil, reloadable:preFireShot() only calls before the actual shot.

    @tparam IsoPlayer character
    @tparam nil|float chargeDelta

]]
function ISReloadManager:checkLoaded(character, chargeDelta)
    local weapon = character:getPrimaryHandItem();
    if ReloadUtil:setUpGun(weapon, character) then
        self.reloadable = ReloadUtil:getReloadableWeapon(weapon, character)
        if character:getCurrentState() ~= SwipeStatePlayer.instance() then
            if (self.reloadable:isLoaded(self:getDifficulty()) and self.reloadable.isJammed ~= true) then -- check if its jammed as well
                ISTimedActionQueue.clear(character)
                local willFire = true
                -- again, we need to check self.reloadable ~= nil..seems it gets cleared when breaking a reload timed action by shooting
                if self.reloadable and self.reloadable.preFireShot and character:getRecoilDelay() == 0 then
                    willFire = self.reloadable:preFireShot(self:getDifficulty(), character, weapon)
                    --if (((this.AttackDelay <= 0.0F) && ((!this.sprite.CurrentAnim.name.contains("Attack")) || (this.def.Frame >= this.sprite.CurrentAnim.Frames.size() - 1))) || (this.def.Frame == 0.0F))
                end
                if willFire then character:DoAttack(chargeDelta or 0) end
            elseif self:rackingNow() then
                -- Don't interrupt the racking action
            elseif self:autoRackNeeded() then
                -- interrupt actions so racking can begin before firing
                ISTimedActionQueue.clear(character)
            elseif character:getRecoilDelay() == 0 then
                -- call the :fireEmpty function if it exists, to cock and release the hammer
                if self.reloadable.fireEmpty then
                    self.reloadable:fireEmpty(character, weapon)
                end
                character:DoAttack(chargeDelta, true, self.reloadable.clickSound);
            end
        end
    else
        character:DoAttack(chargeDelta);
    end
    self.reloadable = nil;
end
