require "TimedActions/ISBaseTimedAction"

ORGMUnloadAction = ISBaseTimedAction:derive("ORGMUnloadAction")

function ORGMUnloadAction:isValid()
	if self.unloadable then
		return self.unloadable:isUnloadValid(self.character, self.square, self.mgr:getDifficulty())
	end
	return false
end

function ORGMUnloadAction:update()
end

function ORGMUnloadAction:start()
	if self.unloadable then
		self.unloadable:unloadStart(self.character, self.square, self.mgr:getDifficulty());
	end
end

function ORGMUnloadAction:stop()
	self.mgr:stopUnload()
	ISBaseTimedAction.stop(self)
end

function ORGMUnloadAction:perform()
	self.unloadable:unloadPerform(self.character, self.square, self.mgr:getDifficulty(), self.unloadWeapon)
	self.mgr.unloadable = self.unloadable -- goes nil sometimes
	self.mgr:stopUnloadSuccess()
	-- needed to remove from queue / start next.
	ISBaseTimedAction.perform(self)
end

function ORGMUnloadAction:new(unloadManager, char, square, time)
	local o = {}
	setmetatable(o, self)
	self.__index = self
	-- Required fields
	o.character = char
	o.stopOnWalk = false
	o.stopOnRun = true
	o.maxTime = time
	-- Custom fields
	o.mgr = unloadManager
	o.unloadable = unloadManager.unloadable
	o.unloadWeapon = unloadManager.unloadWeapon
	o.square = square
	return o
end

