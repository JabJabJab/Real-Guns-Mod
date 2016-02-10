require "Reloading/ISReloadableWeapon"
require "Reloading/ISReloadableMagazine"

ORGMWeaponAutoIM =  ISReloadableWeapon:derive("ORGMWeaponAutoIM");

--************************************************************************--
--** ORGMWeaponAutoIM:initialise
--**
--************************************************************************--
function ORGMWeaponAutoIM:initialise()

end

--************************************************************************--
--** ORGMWeaponAutoIM:new
--**
--************************************************************************--
function ORGMWeaponAutoIM:new()
	local o = {}
	--o.data = {}
	o = ISReloadableWeapon:new();
    setmetatable(o, self)
    self.__index = self
	o.reloadText = getText('ContextMenu_Reload');
	return o;
end

--************************************************************************--
--** ORGMWeaponAutoIM:isLoaded
--**
--** Returns whether or not the gun will fire when the mouse is next
--** clicked
--**
--************************************************************************--
function ORGMWeaponAutoIM:isLoaded(difficulty)
	return self.roundChambered == 1
end

--************************************************************************--
--** ORGMWeaponAutoIM:fireShot
--**
--** Action performed when a shot is fired. Should typically decrease
--** the current amount of ammo in the weapon
--**
--************************************************************************--
function ORGMWeaponAutoIM:fireShot(weapon, difficulty)
	self.roundChambered = 0;
	if self.currentCapacity > 0 then
		self.currentCapacity = self.currentCapacity - 1;
		self.roundChambered = 1;
	end
	self:syncReloadableToItem(weapon)
end

--************************************************************************--
--** ORGMWeaponAutoIM:canReload
--**
--** Whether the character attempting to reload has the necessary
--** prerequisites to perform the reload action. Called prior to
--** the timed action and not to be confused with isReloadValid
--**
--************************************************************************--
function ORGMWeaponAutoIM:canReload(chr)
	if(self.currentCapacity < self.maxCapacity
	and chr:getInventory():FindAndReturn(self.ammoType) ~= nil) then
		return true;
	end
	return false;
end

function ORGMWeaponAutoIM:canUnload(chr)
	if(self.roundChambered > 0 or self.currentCapacity > 0) then
		return true;
	end
	return false;
end

--************************************************************************--
--** ORGMWeaponAutoIM:isReloadValid
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
function ORGMWeaponAutoIM:isReloadValid(char, square, difficulty)
	if(self.currentCapacity < self.maxCapacity
		and char:getInventory():FindAndReturn(self.ammoType) ~= nil) then
			return true;
	end
	self.reloadInProgress = false;
	return false;
end

function ORGMWeaponAutoIM:isUnloadValid(char, square, difficulty)
	if(self.roundChambered > 0 or self.currentCapacity > 0) then
		return true;
	end
	self.unloadInProgress = false;
	return false;
end

--************************************************************************--
--** ORGMWeaponAutoIM:reloadStart
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
function ORGMWeaponAutoIM:reloadStart(char, square, difficulty)
	self.reloadInProgress = true;
end

function ORGMWeaponAutoIM:unloadStart(char, square, difficulty)
	self.unloadInProgress = true;
end

--************************************************************************--
--** ORGMWeaponAutoIM:reloadPerform
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
function ORGMWeaponAutoIM:reloadPerform(char, square, difficulty, weapon)
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

function ORGMWeaponAutoIM:unloadPerform(char, square, difficulty, weapon)
	getSoundManager():PlayWorldSound(self.rackSound, char:getSquare(), 0, 10, 1.0, false);
	if(self.roundChambered == 1) then
		self.roundChambered = 0
	else
		self.currentCapacity = self.currentCapacity - 1;
	end
	char:getInventory():AddItem('ORGM.'..self.ammoType);
	self.unloadInProgress = false;
	self:syncReloadableToItem(weapon);
	char:getXp():AddXP(Perks.Reloading, 1);
	if(self.currentCapacity == 0 and self.roundChambered == 0) then
		return false;
	end
	return true;
end

--************************************************************************--
--** ORGMWeaponAutoIM:rackingStart
--**
--** Function that should be performed upon the start of the timed action
--**
--** @param char - the character performing the action. Must not be nil
--** @param square - not used
--**
--************************************************************************--
function ORGMWeaponAutoIM:rackingStart(char, square, weapon)
    getSoundManager():PlayWorldSound(self.rackSound, char:getSquare(), 0, 10, 1.0, false);
end

--************************************************************************--
--** ORGMWeaponAutoIM:rackingPerform
--**
--** Function that should be performed upon successful completion of the
--** timed action
--**
--** @param char - the character performing the action. Must not be nil
--** @param square - not used
--** @param weapon - the item being reloaded
--**
--************************************************************************--
function ORGMWeaponAutoIM:rackingPerform(char, square, weapon)
	if self.roundChambered == 1 and char:getCurrentSquare() then
		local round = InventoryItemFactory.CreateItem(self.moduleName .. '.' .. self.ammoType)
		if round then
			char:getCurrentSquare():AddWorldInventoryItem(round, 0, 0, 0)
			ISInventoryPage.dirtyUI()
		end
	end
    self.roundChambered = 0;
    if(self.currentCapacity > 0) then
        self.currentCapacity = self.currentCapacity - 1;
        self.roundChambered = 1;
	end
	self:syncReloadableToItem(weapon);
end

--************************************************************************--
--** ORGMWeaponAutoIM:getRackTime
--**
--** Returns the time take to perform the reload action
--**
--************************************************************************--
function ORGMWeaponAutoIM:getRackTime()
	return self.rackTime;
end

function ORGMWeaponAutoIM:isChainUnloading()
	return true;
end

--************************************************************************--
--** ORGMWeaponAutoIM:getReloadTime
--**
--** Returns the time take to perform a single reload action
--**
--************************************************************************--
function ORGMWeaponAutoIM:getReloadTime()
	return self.reloadTime;
end

--************************************************************************--
--** ORGMWeaponAutoIM:syncItemToReloadable
--**
--** Function that copies details from an Item's modData to the instance
--** of this ORGMWeaponAutoIM
--**
--** @param weapon - the weapon from which the reloadable information
--** should be retrieved
--**
--************************************************************************--
function ORGMWeaponAutoIM:syncItemToReloadable(weapon)
	local modData = weapon:getModData();
	 -- handle switching difficulty
	ISReloadableWeapon.syncItemToReloadable(self, weapon);
	self.roundChambered = modData.roundChambered;
end

--************************************************************************--
--** ORGMWeaponAutoIM:syncReloadableToItem
--**
--** Function that copies details from the instance of this
--** ORGMWeaponAutoIM to an Item's modData
--**
--** @param weapon - the weapon to which the reloadable information
--** should be copied
--**
--************************************************************************--
function ORGMWeaponAutoIM:syncReloadableToItem(weapon)
	 -- handle switching difficulty
	ISReloadableWeapon.syncReloadableToItem(self, weapon);
	local modData = weapon:getModData();
	modData.roundChambered = self.roundChambered;
end

--************************************************************************--
--** ORGMWeaponAutoIM:setupReloadable
--**
--** Function that initialises all the required modData on an item.
--**
--** @param weapon - the weapon to setup
--** @param v - the lua table containing the key value pairs to attach
--** to the modData
--************************************************************************--
function ORGMWeaponAutoIM:setupReloadable(weapon, v)
	ISReloadableWeapon.setupReloadable(self, weapon, v);
	local modData = weapon:getModData();
	modData.roundChambered = 0;
end

function ORGMWeaponAutoIM:printWeaponDetails(item)
    self:printItemDetails(item);
    local modData = item:getModData();
    local outString  = '';
    if(modData.roundChambered ~= nil) then
        outString = outString..', roundChambered: '..modData.roundChambered;
    else
        outString = outString..', roundChambered == nil';
    end
    print(outString);
    print('***************************************************************');
    print();
    print();
end


function ORGMWeaponAutoIM:printReloadableWeaponDetails()
    self:printReloadableDetails();
    local outString  = '';
    if(self.roundChambered ~= nil) then
        outString = outString..', roundChambered: '..self.roundChambered;
    else
        outString = outString..', roundChambered == nil';
    end
    print(outString);
    print('***************************************************************');
    print();
    print();
end
