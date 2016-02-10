require "Reloading/ISReloadableWeapon"

ORGMWeaponManualIM = ISReloadableWeapon:derive("ORGMWeaponManualIM");

--************************************************************************--
--** ORGMWeaponManualIM:initialise
--**
--************************************************************************--
function ORGMWeaponManualIM:initialise()

end

--************************************************************************--
--** ORGMWeaponManualIM:new
--**
--** Constructor for the ORGMWeaponManualIM reloadable
--************************************************************************--
function ORGMWeaponManualIM:new()
	local o = {}
	--o.data = {}
	o = ISReloadableWeapon:new();
    setmetatable(o, self)
    self.__index = self
	return o;
end

--************************************************************************--
--** ORGMWeaponManualIM:isLoaded
--**
--** Returns whether or not the gun will fire when the mouse is next
--** clicked
--**
--************************************************************************--
function ORGMWeaponManualIM:isLoaded(difficulty)
	return self.roundChambered == 1;
end

--************************************************************************--
--** ORGMWeaponManualIM:fireShot
--**
--** Action performed when a shot is fired. Should typically decrease
--** the current amount of ammo in the weapon
--**
--************************************************************************--
function ORGMWeaponManualIM:fireShot(weapon, difficulty)
	self.roundChambered = 0;
	self.emptyShellChambered = 1;
	self:syncReloadableToItem(weapon);
end

--************************************************************************--
--** ORGMWeaponManualIM:canReload
--**
--** Whether the character attempting to reload has the necessary
--** prerequisites to perform the reload action. Called prior to
--** the timed action and not to be confused with isReloadValid
--**
--************************************************************************--
function ORGMWeaponManualIM:canReload(chr)
	if(self.currentCapacity < self.maxCapacity
	and chr:getInventory():FindAndReturn(self.ammoType) ~= nil) then
		return true;
	end
	return false;
end

function ORGMWeaponManualIM:canUnload(chr)
	if(self.roundChambered > 0 or self.currentCapacity > 0) then
		return true;
	end
	return false;
end

--************************************************************************--
--** ORGMWeaponManualIM:isReloadValid
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
function ORGMWeaponManualIM:isReloadValid(char, square, difficulty)
	if(self.currentCapacity < self.maxCapacity
		and char:getInventory():FindAndReturn(self.ammoType) ~= nil) then
			return true;
	end
	self.reloadInProgress = false;
	return false;
end

function ORGMWeaponManualIM:isUnloadValid(char, square, difficulty)
	if(self.roundChambered > 0 or self.currentCapacity > 0) then
		return true;
	end
	self.unloadInProgress = false;
	return false;
end

--************************************************************************--
--** ORGMWeaponManualIM:reloadStart
--**
--** Function that should be performed upon the start of the timed action
--**
--** @param char - the character performing the action. Must not be nil
--** @param square - not used
--**
--************************************************************************--
function ORGMWeaponManualIM:reloadStart(char, square, difficulty)
	self.reloadInProgress = true;
end

function ORGMWeaponManualIM:unloadStart(char, square, difficulty)
	self.unloadInProgress = true;
end

--************************************************************************--
--** ORGMWeaponManualIM:reloadPerform
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
function ORGMWeaponManualIM:reloadPerform(char, square, difficulty, weapon)
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

function ORGMWeaponManualIM:unloadPerform(char, square, difficulty, weapon)
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
--** ORGMWeaponManualIM:rackingStart
--**
--** Function that should be performed upon the start of the timed action
--**
--** @param char - the character performing the action. Must not be nil
--** @param square - not used
--**
--************************************************************************--
function ORGMWeaponManualIM:rackingStart(char, square, weapon)
    getSoundManager():PlayWorldSound(self.rackSound, char:getSquare(), 0, 10, 1.0, false);
	if self.emptyShellChambered == 1 and weapon:getShellFallSound() and weapon:getShellFallSound() ~= '' then
		getSoundManager():PlayWorldSound(weapon:getShellFallSound(), char:getSquare(), 0, 7, 1.0, false);
	end
end

--************************************************************************--
--** ORGMWeaponManualIM:rackingPerform
--**
--** Function that should be performed upon successful completion of the
--** timed action
--**
--** @param char - the character performing the action. Must not be nil
--** @param square - not used
--** @param weapon - the item being reloaded
--**
--************************************************************************--
function ORGMWeaponManualIM:rackingPerform(char, square, weapon)
	if self.roundChambered == 1 and char:getCurrentSquare() then
		local round = InventoryItemFactory.CreateItem(self.moduleName .. '.' .. self.ammoType)
		if round then
			char:getCurrentSquare():AddWorldInventoryItem(round, 0, 0, 0)
			ISInventoryPage.dirtyUI()
		end
	end
    self.roundChambered = 0;
	self.emptyShellChambered = 0
    if(self.currentCapacity > 0) then
        self.currentCapacity = self.currentCapacity - 1;
        self.roundChambered = 1;
	end
	self:syncReloadableToItem(weapon);
end

function ORGMWeaponManualIM:isChainUnloading()
	return true;
end

--************************************************************************--
--** ORGMWeaponManualIM:getReloadTime
--**
--** Returns the time take to perform the reload action
--**
--************************************************************************--
function ORGMWeaponManualIM:getReloadTime()
	return self.reloadTime;
end

--************************************************************************--
--** ORGMWeaponManualIM:getRackTime
--**
--** Returns the time take to perform the reload action
--**
--************************************************************************--
function ORGMWeaponManualIM:getRackTime()
	return self.rackTime;
end

--************************************************************************--
--** ORGMWeaponManualIM:syncItemToReloadable
--**
--** Function that copies details from an Item's modData to the instance
--** of this ORGMWeaponManualIM
--**
--** @param weapon - the weapon from which the reloadable information
--** should be retrieved
--**
--************************************************************************--
function ORGMWeaponManualIM:syncItemToReloadable(weapon)
	ISReloadableWeapon.syncItemToReloadable(self, weapon);
	local modData = weapon:getModData();
	self.roundChambered = modData.roundChambered;
	self.emptyShellChambered = modData.emptyShellChambered or 0
end

--************************************************************************--
--** ORGMWeaponManualIM:syncReloadableToItem
--**
--** Function that copies details from the instance of this
--** ORGMWeaponManualIM to an Item's modData
--**
--** @param weapon - the weapon to which the reloadable information
--** should be copied
--**
--************************************************************************--
function ORGMWeaponManualIM:syncReloadableToItem(weapon)
	ISReloadableWeapon.syncReloadableToItem(self, weapon);
	local modData = weapon:getModData();
	modData.roundChambered = self.roundChambered;
	modData.emptyShellChambered = self.emptyShellChambered
end

--************************************************************************--
--** ORGMWeaponManualIM:setupReloadable
--**
--** Function that initialises all the required modData on an item.
--**
--** @param weapon - the weapon to setup
--** @param v - the lua table containing the key value pairs to attach
--** to the modData
--************************************************************************--
function ORGMWeaponManualIM:setupReloadable(weapon, v)
	ISReloadableWeapon.setupReloadable(self, weapon, v);
	local modData = weapon:getModData();
	modData.roundChambered = 0;
end

function ORGMWeaponManualIM:printWeaponDetails(item)
    self:printItemDetails(item);
    local modData = item:getModData();
    local outString  = '';
    if(modData.roundChambered ~= nil) then
        outString = outString..', roundChambered: '..modData.roundChambered;
    else
        outString = outString..', roundChambered == nil';
    end
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


function ORGMWeaponManualIM:printReloadableWeaponDetails()
    self:printReloadableDetails();
    local outString  = '';
    if(self.roundChambered ~= nil) then
        outString = outString..', roundChambered: '..self.roundChambered;
    else
        outString = outString..', roundChambered == nil';
    end
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
