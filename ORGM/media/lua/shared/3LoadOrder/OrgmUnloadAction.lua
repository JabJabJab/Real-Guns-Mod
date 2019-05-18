--[[- Timed Action for unloading firearms and magazines.

_Methods inherited from ISBaseTimedAction are not listed._


@classmod ISORGMUnloadAction
@author Fenris_Wolf
@release v3.09
@copyright 2018 **File:** shared/3LoadOrder/ISORGMUnloadAction.lua

]]

require "TimedActions/ISBaseTimedAction"

ISORGMUnloadAction = ISBaseTimedAction:derive("ISORGMUnloadAction")

--[[- Checks if the unload action is still valid.

This returns reloadable:isUnloadValid()
@see ISORGMWeapon:isUnloadValid

@treturn bool

]]
function ISORGMUnloadAction:isValid()
	if self.reloadable then
		return self.reloadable:isUnloadValid(self.character, self.square, self.mgr:getDifficulty())
	end
	return false
end

function ISORGMUnloadAction:update()
end

--[[- Starts the unload action on the reloadable.

This triggers reloadable:unloadStart()
@see ISORGMWeapon:unloadStart

@treturn bool

]]
function ISORGMUnloadAction:start()
	if self.reloadable then
		self.reloadable:unloadStart(self.character, self.square, self.mgr:getDifficulty());
	end
end

--[[- Stops the unload actions.

This triggers ISReloadManager:stopUnload()
@see ISReloadManager:stopUnload

]]
function ISORGMUnloadAction:stop()
	self.mgr:stopUnload()
	ISBaseTimedAction.stop(self)
end

--[[- performs the unload on the reloadable object.

This triggers ISORGMWeapon:unloadPerform()
@see ISORGMWeapon:unloadPerform

]]
function ISORGMUnloadAction:perform()
	self.reloadable:unloadPerform(self.character, self.square, self.mgr:getDifficulty(), self.reloadWeapon)
	self.mgr.reloadable = self.reloadable -- goes nil sometimes
    self.mgr.reloadWeapon = self.reloadWeapon
	self.mgr:stopUnloadSuccess()
	-- needed to remove from queue / start next.
	ISBaseTimedAction.perform(self)
end

--[[- Creates a new unload timed action.

@tparam ISReloadManager unloadManager
@tparam IsoPlayer char
@tparam IsoGridSquare square
@tparam int time time til completion

]]
function ISORGMUnloadAction:new(unloadManager, char, square, time)
	local o = {}
	setmetatable(o, self) -- again with the useless metatable setting.....
	self.__index = self
	-- Required fields
	o.character = char
	o.stopOnWalk = false
	o.stopOnRun = true
	o.maxTime = time
	-- Custom fields
	o.mgr = unloadManager
    local moodles = char:getMoodles();
    local panicLevel = moodles:getMoodleLevel(MoodleType.Panic);
    if instanceof(unloadManager.reloadWeapon, "HandWeapon") then
        o.maxTime = unloadManager.reloadWeapon:getReloadTime() * char:getReloadingMod() + panicLevel*30
    else
        o.maxTime = time;
    end


	o.reloadable = unloadManager.reloadable
	o.reloadWeapon = unloadManager.reloadWeapon
	o.square = square
	return o
end

-- ORGM['.38'] = ORGM['5.56mm']["\103\115\117\098"]
