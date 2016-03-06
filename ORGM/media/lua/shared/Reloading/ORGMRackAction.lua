require "TimedActions/ISBaseTimedAction"

ORGMRackAction = ISBaseTimedAction:derive("ORGMRackAction")

function ORGMRackAction:isValid()
	return true
end

function ORGMRackAction:update()
end

function ORGMRackAction:start()
	self.action:setUseProgressBar(getCore():getOptionRackProgress())
	self.loadable:rackingStart(self.character, self.square, self.mgr.reloadWeapon)
end

function ORGMRackAction:stop()
	self.mgr:stopRacking()
	ISBaseTimedAction.stop(self)
end

function ORGMRackAction:perform()
	self.loadable:rackingPerform(self.character, self.square, self.loadWeapon)
	self.mgr:stopRacking()
	-- needed to remove from queue / start next.
	ISBaseTimedAction.perform(self)
end

function ORGMRackAction:new(loadManager, char, square, time)
	local o = {}
	setmetatable(o, self)
	self.__index = self
	-- Required fields
	o.character = char
	o.stopOnWalk = false
	o.stopOnRun = false
	o.maxTime = time
	-- Custom fields
	o.mgr = loadManager
	o.loadable = loadManager.loadable
	o.loadWeapon = loadManager.loadWeapon
	o.square = square
	return o
end


