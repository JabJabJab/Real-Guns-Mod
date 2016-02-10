require "Reloading/ISReloadableWeapon"
require "Reloading/ISReloadableMagazine"

ORGMWeaponAutoIMNC =  ISReloadableWeapon:derive("ORGMWeaponAutoIMNC");

--************************************************************************--
--** ORGMWeaponAutoIMNC:initialise
--**
--************************************************************************--
function ORGMWeaponAutoIMNC:initialise()

end

--************************************************************************--
--** ORGMWeaponAutoIMNC:new
--**
--************************************************************************--
function ORGMWeaponAutoIMNC:new()
	local o = {}
	--o.data = {}
	o = ISReloadableWeapon:new();
    setmetatable(o, self)
    self.__index = self
	o.reloadText = getText('ContextMenu_Reload');
	return o;
end

--************************************************************************--
--** ORGMWeaponAutoIMNC:isLoaded
--**
--** Returns whether or not the gun will fire when the mouse is next
--** clicked
--**
--************************************************************************--
function ORGMWeaponAutoIMNC:isLoaded(difficulty)
	return self.currentCapacity > 0;
end

--************************************************************************--
--** ORGMWeaponAutoIMNC:fireShot
--**
--** Action performed when a shot is fired. Should typically decrease
--** the current amount of ammo in the weapon
--**
--************************************************************************--
function ORGMWeaponAutoIMNC:fireShot(weapon, difficulty)
	if self.currentCapacity > 0 then
		self.currentCapacity = self.currentCapacity - 1;
	end
	self:syncReloadableToItem(weapon)
end

--************************************************************************--
--** ORGMWeaponAutoIMNC:canReload
--**
--** Whether the character attempting to reload has the necessary
--** prerequisites to perform the reload action. Called prior to
--** the timed action and not to be confused with isReloadValid
--**
--************************************************************************--
function ORGMWeaponAutoIMNC:canReload(chr)
	if(self.currentCapacity < self.maxCapacity
	and chr:getInventory():FindAndReturn(self.ammoType) ~= nil) then
		return true;
	end
	return false;
end

function ORGMWeaponAutoIMNC:canUnload(chr)
	if(self.currentCapacity > 0) then
		return true;
	end
	return false;
end

--************************************************************************--
--** ORGMWeaponAutoIMNC:isReloadValid
--**
--** Function for the TimedAction that determines whether the reload
--** action is still valid. If the player does something that should
--** interrupt the action, this should return false
--**
--** @param char - the character performing the action. Must not be nil
--** @param square - not used
--** @param difficulty - the difficulty level
--**
--** @return true if the action may continue to be performed
--**
--************************************************************************--
function ORGMWeaponAutoIMNC:isReloadValid(char, square, difficulty)
	if(self.currentCapacity < self.maxCapacity
		and char:getInventory():FindAndReturn(self.ammoType) ~= nil) then
			return true;
	end
	self.reloadInProgress = false;
	return false;
end

function ORGMWeaponAutoIMNC:isUnloadValid(char, square, difficulty)
	if(self.currentCapacity > 0) then
		return true;
	end
	self.unloadInProgress = false;
	return false;
end

--************************************************************************--
--** ORGMWeaponAutoIMNC:reloadStart
--**
--** Function that should be performed upon the start of the timed action
--** Considers the difficulty and performs the corresponding reload
--** action
--**
--** @param char - the character performing the action. Must not be nil
--** @param square - not used
--** @param difficulty - the difficulty level
--**
--************************************************************************--
function ORGMWeaponAutoIMNC:reloadStart(char, square, difficulty)
	self.reloadInProgress = true;
end

function ORGMWeaponAutoIMNC:unloadStart(char, square, difficulty)
	self.unloadInProgress = true;
end

--************************************************************************--
--** ORGMWeaponAutoIMNC:reloadPerform
--**
--** Function that should be performed upon successful completion of the
--** timed action. Considers the difficulty and performs the corresponding
--** reload action
--**
--** @param char - the character performing the action. Must not be nil
--** @param square - not used
--** @param difficulty - the difficulty level
--**
--************************************************************************--
function ORGMWeaponAutoIMNC:reloadPerform(char, square, difficulty, weapon)
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

function ORGMWeaponAutoIMNC:unloadPerform(char, square, difficulty, weapon)
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
--** ORGMWeaponAutoIMNC:rackingStart
--**
--** Function that should be performed upon the start of the timed action
--**
--** @param char - the character performing the action. Must not be nil
--** @param square - not used
--**
--************************************************************************--
function ORGMWeaponAutoIMNC:rackingStart(char, square, weapon)
    getSoundManager():PlayWorldSound(self.rackSound, char:getSquare(), 0, 10, 1.0, false);
end

--************************************************************************--
--** ORGMWeaponAutoIMNC:rackingPerform
--**
--** Function that should be performed upon successful completion of the
--** timed action
--**
--** @param char - the character performing the action. Must not be nil
--** @param square - not used
--** @param weapon - the item being reloaded
--**
--************************************************************************--
function ORGMWeaponAutoIMNC:rackingPerform(char, square, weapon)

 	self:syncReloadableToItem(weapon);
end

--************************************************************************--
--** ORGMWeaponAutoIMNC:getRackTime
--**
--** Returns the time take to perform the reload action
--**
--************************************************************************--
function ORGMWeaponAutoIMNC:getRackTime()
	return self.rackTime;
end

function ORGMWeaponAutoIMNC:isChainUnloading()
	return true;
end

--************************************************************************--
--** ORGMWeaponAutoIMNC:getReloadTime
--**
--** Returns the time take to perform a single reload action
--**
--************************************************************************--
function ORGMWeaponAutoIMNC:getReloadTime()
	return self.reloadTime;
end

--************************************************************************--
--** ORGMWeaponAutoIMNC:syncItemToReloadable
--**
--** Function that copies details from an Item's modData to the instance
--** of this ORGMWeaponAutoIMNC
--**
--** @param weapon - the weapon from which the reloadable information
--** should be retrieved
--**
--************************************************************************--
function ORGMWeaponAutoIMNC:syncItemToReloadable(weapon)
	local modData = weapon:getModData();
	 -- handle switching difficulty
	ISReloadableWeapon.syncItemToReloadable(self, weapon);
end

--************************************************************************--
--** ORGMWeaponAutoIMNC:syncReloadableToItem
--**
--** Function that copies details from the instance of this
--** ORGMWeaponAutoIMNC to an Item's modData
--**
--** @param weapon - the weapon to which the reloadable information
--** should be copied
--**
--************************************************************************--
function ORGMWeaponAutoIMNC:syncReloadableToItem(weapon)
	 -- handle switching difficulty
	ISReloadableWeapon.syncReloadableToItem(self, weapon);
	local modData = weapon:getModData();
end

--************************************************************************--
--** ORGMWeaponAutoIMNC:setupReloadable
--**
--** Function that initialises all the required modData on an item.
--**
--** @param weapon - the weapon to setup
--** @param v - the lua table containing the key value pairs to attach
--** to the modData
--************************************************************************--
function ORGMWeaponAutoIMNC:setupReloadable(weapon, v)
	ISReloadableWeapon.setupReloadable(self, weapon, v);
	local modData = weapon:getModData();
end

function ORGMWeaponAutoIMNC:printWeaponDetails(item)
    self:printItemDetails(item);
    local modData = item:getModData();
    local outString  = '';
    print(outString);
    print('***************************************************************');
    print();
    print();
end


function ORGMWeaponAutoIMNC:printReloadableWeaponDetails()
    self:printReloadableDetails();
    local outString  = '';
    print(outString);
    print('***************************************************************');
    print();
    print();
end
