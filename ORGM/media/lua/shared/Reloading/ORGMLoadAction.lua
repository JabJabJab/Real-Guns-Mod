require "TimedActions/ISBaseTimedAction"

ORGMLoadAction = ISBaseTimedAction:derive("ORGMLoadAction")


function ORGMLoadAction:isValid()
	if self.loadable then
		return true
	end
	return false
end
	
function ORGMLoadAction:update()
end

function ORGMLoadAction:start()
	if self.loadable then
		if self.loadType == "reload" or self.loadType == "unload" then --if the load type comes through for reloading go to the reloading script
			self.loadable:loadStart(self.character, self.square, self.mgr:getDifficulty(), self.loadType);
		else --otherwise it is assumed the open/close slide/bolt was selected, so it goes there
			self.loadable:csOpenCloseStart(self.character, self.square, self.mgr:getDifficulty(), self.loadType);
		end
	end
end

function ORGMLoadAction:stop() --Stops the load action in the middle
	self.mgr:stopLoad()
	ISBaseTimedAction.stop(self)
end

function ORGMLoadAction:perform() --for performing the loading actions
	self.loadableData = self.loadWeapon:getModData()
	local loadStyle = self.loadableData.loadStyle
	if self.loadType == "open" then --open the gun for reloading
		self.loadable:openClosePerform(self.character, self.square, self.mgr:getDifficulty(), self.loadWeapon)
		self.mgr.loadable = self.loadable
		ISBaseTimedAction.perform(self)
	elseif self.loadableData.openClose ~= nil and self.loadableData.openClose == 1 and self.loadableData.isOpen ~= nil and self.loadableData.isOpen ~= 1 then
		self.loadable:openClosePerform(self.character, self.square, self.mgr:getDifficulty(), self.loadWeapon)
		self.mgr.loadable = self.loadable
		self.mgr:stopLoadSuccess() --a check to see if the gun can continue after the first action
	elseif self.loadType == "reload" or self.loadType == "unload" then --if the loadType is reloading then is performs the loading action
		self.loadable:loadPerform(self.character, self.square, self.mgr:getDifficulty(), self.loadWeapon, self.reloadAmmo, self.loadType, loadStyle)
		self.mgr.loadable = self.loadable
		self.mgr:stopLoadSuccess() --a check to see if the gun can continue after the first action
		ISBaseTimedAction.perform(self)
	elseif self.loadType == "close" then --closes the gun if it is open for reloading
		self.loadable:openClosePerform(self.character, self.square, self.mgr:getDifficulty(), self.loadWeapon)
		self.mgr.loadable = self.loadable
		ISBaseTimedAction.perform(self)
		self.mgr:stopLoadSuccess() --a check to see if the gun can continue after the first action
	else --otherwise it must be a half-rack action
		self.loadable:halfRackPerform(self.character, self.square, self.mgr:getDifficulty(), self.loadWeapon, self.loadType)
		ISBaseTimedAction.perform(self)
	end
end

function ORGMLoadAction:new(loadManager, char, loadtype, square, time)
	--initializing the script
	local o = {}
	setmetatable(o, self)
	self.__index = self
	o.character = char
	o.stopOnWalk = false
	o.stopOnRun = true
	o.maxTime = time
	o.mgr = loadManager
	o.loadable = loadManager.loadable
	o.loadWeapon = loadManager.loadWeapon
	o.loadType = loadtype
	o.reloadAmmo = loadManager.reloadAmmo
	o.square = square
	return o
end

