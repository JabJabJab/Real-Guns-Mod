require "ISBaseObject"
require "Reloading/ISReloadUtil"
require "Reloading/ISRackAction"
require "Reloading/ORGMUnloadAction"

ORGMUnloadManager = ISReloadManager:derive("ORGMUnloadManager");

function ORGMUnloadManager:initialise()

end

function ORGMUnloadManager:new(player)
	local o = {}
	setmetatable(o, self)
    self.__index = self
	o.reloadAction = nil;
	o.reloadWeapon = nil;
	o.chainReload = false;
	o.spaceIsPressed = false;
	o.rIsPressed = false;
	--o.kIsPressed = false; -- debugging tool
	o.reloadAction = nil;
	o.unloadAction = nil;
	o.rackingAction = nil;
	o.reloadable = nil;
	o.unloadable = nil;
	o.playerid = player;
	o.lastClickTime = 0

	-- Debug hooks
    --o.managerDetails = function()
	    --return ReloadManager:printManagerDetails();
	--end
	--Events.OnPlayerUpdate.Add(o.managerDetails);

    return o;
end

aaa = {}

function ORGMUnloadManager:isWeaponUnloadable()
	local playerObj = getSpecificPlayer(self.playerid)
	self.unloadWeapon = playerObj:getPrimaryHandItem();
	if(self.unloadWeapon == nil) then
        return false;
	end

	self.unloadable = UnloadUtil:getReloadableWeapon(self.unloadWeapon, playerObj);
	if self.unloadable == nil then return false; end
	local isUnloadable = self.unloadable:canUnload(playerObj);
	self.unloadable = nil;
    return isUnloadable;
end

function ORGMUnloadManager:unloadStarted()
	return ISTimedActionQueue.hasAction(self.unloadAction)
end

function ORGMUnloadManager:stopUnload(noSound)
	self.unloadAction.javaAction = nil;
	self.unloadWeapon = nil;
	self.unloadable = nil;
	self.chainUnload = false;
end

function ORGMUnloadManager:stopUnloadSuccess()
	local playerObj = getPlayer()
	self.chainUnload = ReloadUtil:getReloadableWeapon(self.unloadWeapon, playerObj):isChainUnloading();
	if(self.unloadWeapon ~= nil and self.chainUnload == true and self:unloadStarted() == true) then
		if(self.unloadable:canUnload(playerObj)) then
			self:startUnloading();
		else
			self:stopUnload()
		end
	elseif(self.chainUnload == false) then
		self:stopUnload();
	end
end

function ORGMUnloadManager:startUnloading()
	local player = getPlayer()
	local moodles = player:getMoodles();
	local panicLevel = moodles:getMoodleLevel(MoodleType.Panic);
	self.unloadable = ReloadUtil:getReloadableWeapon(self.unloadWeapon, player);
	self.unloadAction = ORGMUnloadAction:new(self, player, player:getSquare(),
		(10*player:getReloadingMod())+(panicLevel*30))
	if not self.chainUnload then
        ISTimedActionQueue.clear(player)
    end
	ISTimedActionQueue.add(self.unloadAction)
end

function ORGMUnloadManager:startUnloadFromUi(item)
	if(self:unloadStarted() == false or ORGMConversions.counter ~= 0) then
		self.unloadWeapon = item;
		self:startUnloading();
	end
end