--[[- Timed Action for cleaning firearms and magazines.

_Methods inherited from ISBaseTimedAction are not listed._

This file is a work in progress, and not currently enabled.

@classmod ISORGCleanFirarmAction
@author Fenris_Wolf
@release v3.09
@copyright 2018 **File:** shared/3LoadOrder/ISORGMUnloadAction.lua

]]

require "TimedActions/ISBaseTimedAction"

ISCleanFirearmAction = ISBaseTimedAction:derive("ISCleanFirearmAction")

--[[- Checks if the unload action is still valid.

This returns reloadable:isUnloadValid()
@see ISORGMWeapon:isUnloadValid

@treturn bool

]]
function ISCleanFirearmAction:isValid()
    if self.character:getPrimaryHandItem() ~= self.item then return false end
    -- TODO: check other conditions
    return true
end

function ISCleanFirearmAction:update()
    -- TODO: for sanity run our check again
end

--[[- Starts the unload action on the reloadable.

This triggers reloadable:unloadStart()
@see ISORGMWeapon:unloadStart

@treturn bool

]]
function ISCleanFirearmAction:start()
    -- TODO: check if the gun is loaded (opps!)
end

--[[- Stops the unload actions.

This triggers ISReloadManager:stopUnload()
@see ISReloadManager:stopUnload

]]
function ISCleanFirearmAction:stop()
    --
    ISBaseTimedAction.stop(self)
end

--[[- performs the unload on the reloadable object.

This triggers ISORGMWeapon:unloadPerform()
@see ISORGMWeapon:unloadPerform

]]
function ISCleanFirearmAction:perform()
    -- TODO: check and log if we're cleaning with WD-40
    --
	-- needed to remove from queue / start next.
	ISBaseTimedAction.perform(self)
end

--[[- Creates a new unload timed action.

@tparam IsoPlayer char
@tparam IsoGridSquare square
@tparam HandWeapon weaponItem
@tparam InventoryItem maintanceItem
@tparam int time time til completion

]]
function ISCleanFirearmAction:new(char, square, weaponItem, maintanceItem, time)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o.character = char
    o.stopOnWalk = true
    o.stopOnRun = true
    local moodles = char:getMoodles()
    local panicLevel = moodles:getMoodleLevel(MoodleType.Panic)
    -- TODO: modify time by dirt levels, WD-40 previously used, and WD-40 currently used
    -- local dirt = rounds fired since cleaned * 0.05

    local modData = weaponItem:getModData()

    o.maxTime = time * char:getReloadingMod() + panicLevel*30

    o.weaponItem = weaponItem
    o.maintanceItem = maintanceItem
    o.square = square
    return o
end
