require "Reloading/ISReloadableWeapon"

ORGMWeaponManualIMNC = ISReloadableWeapon:derive("ORGMWeaponManualIMNC");

--************************************************************************--
--** ORGMWeaponManualIMNC:initialise
--**
--************************************************************************--
function ORGMWeaponManualIMNC:initialise()

end

--************************************************************************--
--** ORGMWeaponManualIMNC:new
--**
--** Constructor for the ORGMWeaponManualIMNC reloadable
--************************************************************************--
function ORGMWeaponManualIMNC:new()
	local o = {}
	--o.data = {}
	o = ISReloadableWeapon:new();
    setmetatable(o, self)
    self.__index = self
	return o;
end

--************************************************************************--
--** ORGMWeaponManualIMNC:isLoaded
--**
--** Returns whether or not the gun will fire when the mouse is next
--** clicked
--**
--************************************************************************--
function ORGMWeaponManualIMNC:isLoaded(difficulty)
	return self.currentCapacity > 0;
end

--************************************************************************--
--** ORGMWeaponManualIMNC:fireShot
--**
--** Action performed when a shot is fired. Should typically decrease
--** the current amount of ammo in the weapon
--**
--************************************************************************--
function ORGMWeaponManualIMNC:fireShot(weapon, difficulty)
	if self.currentCapacity > 0 then
		self.currentCapacity = self.currentCapacity - 1;
	end
	self.racked = 0
	self:syncReloadableToItem(weapon)
end

--************************************************************************--
--** ORGMWeaponManualIMNC:canReload
--**
--** Whether the character attempting to reload has the necessary
--** prerequisites to perform the reload action. Called prior to
--** the timed action and not to be confused with isReloadValid
--**
--************************************************************************--
function ORGMWeaponManualIMNC:canReload(chr)
	if(self.currentCapacity < self.maxCapacity
	and chr:getInventory():FindAndReturn(self.ammoType) ~= nil) then
		return true;
	end
	return false;
end

function ORGMWeaponManualIMNC:canUnload(chr)
	if(self.currentCapacity > 0) then
		return true;
	end
	return false;
end

--************************************************************************--
--** ORGMWeaponManualIMNC:isReloadValid
--**
--** Function for the TimedAction that determines whether the reload
--** action is still valid. If the player does something that should
--** interrupt the action, this should return false
--**
--** @param char - the character performing the action. Must not be nil
--** @param square - not used
--**
--** @return true if the action may continue to be performed
--**
--************************************************************************--
function ORGMWeaponManualIMNC:isReloadValid(char, square, difficulty)
	if(self.currentCapacity < self.maxCapacity
		and char:getInventory():FindAndReturn(self.ammoType) ~= nil) then
			return true;
	end
	self.reloadInProgress = false;
	return false;
end

function ORGMWeaponManualIM:isUnloadValid(char, square, difficulty)
	if(self.currentCapacity > 0) then
		return true;
	end
	self.unloadInProgress = false;
	return false;
end

--************************************************************************--
--** ORGMWeaponManualIMNC:reloadStart
--**
--** Function that should be performed upon the start of the timed action
--**
--** @param char - the character performing the action. Must not be nil
--** @param square - not used
--**
--************************************************************************--
function ORGMWeaponManualIMNC:reloadStart(char, square, difficulty)
	self.reloadInProgress = true;
end

function ORGMWeaponManualIM:unloadStart(char, square, difficulty)
	self.unloadInProgress = true;
end

--************************************************************************--
--** ORGMWeaponManualIMNC:reloadPerform
--**
--** Function that should be performed upon successful completion of the
--** timed action
--**
--** @param char - the character performing the action. Must not be nil
--** @param square - not used
--** @param difficulty - the current reload difficulty
--** @param weapon - the item being reloaded
--**
--************************************************************************--
function ORGMWeaponManualIMNC:reloadPerform(char, square, difficulty, weapon)
	getSoundManager():PlayWorldSound(self.insertSound, char:getSquare(), 0, 10, 1.0, false);
	self.currentCapacity = self.currentCapacity + 1;
	-- remove the necessary ammo
	char:getInventory():RemoveOneOf(self.ammoType);
	self.reloadInProgress = false;
	self:syncReloadableToItem(weapon);
	char:getXp():AddXP(Perks.Reloading, 1);
	if(self.currentCapacity == self.maxCapacity) then
		return false;
	end
	return true;
end

function ORGMWeaponManualIMNC:unloadPerform(char, square, difficulty, weapon)
	getSoundManager():PlayWorldSound(self.rackSound, char:getSquare(), 0, 10, 1.0, false);
	self.currentCapacity = self.currentCapacity - 1;
	char:getInventory():AddItem('ORGM.'..self.ammoType);
	self.unloadInProgress = false;
	self:syncReloadableToItem(weapon);
	char:getXp():AddXP(Perks.Reloading, 1);
	if(self.currentCapacity == 0) then
		return false;
	end
	return true;
end

--************************************************************************--
--** ORGMWeaponManualIMNC:rackingStart
--**
--** Function that should be performed upon the start of the timed action
--**
--** @param char - the character performing the action. Must not be nil
--** @param square - not used
--**
--************************************************************************--
function ORGMWeaponManualIMNC:rackingStart(char, square, weapon)
    getSoundManager():PlayWorldSound(self.rackSound, char:getSquare(), 0, 10, 1.0, false);
end

--************************************************************************--
--** ORGMWeaponManualIMNC:rackingPerform
--**
--** Function that should be performed upon successful completion of the
--** timed action
--**
--** @param char - the character performing the action. Must not be nil
--** @param square - not used
--** @param weapon - the item being reloaded
--**
--************************************************************************--
function ORGMWeaponManualIMNC:rackingPerform(char, square, weapon)
    self.racked = 1;
	self:syncReloadableToItem(weapon);
end

function ORGMWeaponManualIM:isChainUnloading()
	return true;
end

--************************************************************************--
--** ORGMWeaponManualIMNC:getReloadTime
--**
--** Returns the time take to perform the reload action
--**
--************************************************************************--
function ORGMWeaponManualIMNC:getReloadTime()
	return self.reloadTime;
end

--************************************************************************--
--** ORGMWeaponManualIMNC:getRackTime
--**
--** Returns the time take to perform the reload action
--**
--************************************************************************--
function ORGMWeaponManualIMNC:getRackTime()
	return self.rackTime;
end

--************************************************************************--
--** ORGMWeaponManualIMNC:syncItemToReloadable
--**
--** Function that copies details from an Item's modData to the instance
--** of this ORGMWeaponManualIMNC
--**
--** @param weapon - the weapon from which the reloadable information
--** should be retrieved
--**
--************************************************************************--
function ORGMWeaponManualIMNC:syncItemToReloadable(weapon)
	ISReloadableWeapon.syncItemToReloadable(self, weapon);
	local modData = weapon:getModData();
	self.racked = modData.racked;
end

--************************************************************************--
--** ORGMWeaponManualIMNC:syncReloadableToItem
--**
--** Function that copies details from the instance of this
--** ORGMWeaponManualIMNC to an Item's modData
--**
--** @param weapon - the weapon to which the reloadable information
--** should be copied
--**
--************************************************************************--
function ORGMWeaponManualIMNC:syncReloadableToItem(weapon)
	ISReloadableWeapon.syncReloadableToItem(self, weapon);
	local modData = weapon:getModData();
	modData.racked = self.racked;
end

--************************************************************************--
--** ORGMWeaponManualIMNC:setupReloadable
--**
--** Function that initialises all the required modData on an item.
--**
--** @param weapon - the weapon to setup
--** @param v - the lua table containing the key value pairs to attach
--** to the modData
--************************************************************************--
function ORGMWeaponManualIMNC:setupReloadable(weapon, v)
	ISReloadableWeapon.setupReloadable(self, weapon, v);
	local modData = weapon:getModData();
	modData.racked = 0;
end

function ORGMWeaponManualIMNC:printWeaponDetails(item)
    self:printItemDetails(item);
    local modData = item:getModData();
    local outString  = '';
    if(modData.shootSoundPartial ~= nil) then
        outString = outString..', shootSoundPartial: '..modData.shootSoundPartial;
    else
        outString = outString..', shootSoundPartial == nil';
    end
    if(modData.defaultSwingSound ~= nil) then
        outString = outString..', defaultSwingSound: '..modData.defaultSwingSound;
    else
        outString = outString..', defaultSwingSound == nil';
    end
    print(outString);
    print('***************************************************************');
    print();
    print();
end


function ORGMWeaponManualIMNC:printReloadableWeaponDetails()
    self:printReloadableDetails();
    local outString  = '';
    if(self.containsClip ~= nil) then
        outString = outString..', shootSoundPartial: '..self.shootSoundPartial;
    else
        outString = outString..', shootSoundPartial == nil';
    end
    if(self.clipName ~= nil) then
        outString = outString..', defaultSwingSound: '..self.defaultSwingSound;
    else
        outString = outString..', defaultSwingSound == nil';
    end
    print(outString);
    print('***************************************************************');
    print();
    print();
end
