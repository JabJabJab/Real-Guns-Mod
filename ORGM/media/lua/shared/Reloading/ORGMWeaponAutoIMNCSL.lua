require "Reloading/ISReloadableWeapon"
require "Reloading/ISReloadableMagazine"

ORGMWeaponAutoIMNCSL =  ISReloadableWeapon:derive("ORGMWeaponAutoIMNCSL");

--************************************************************************--
--** ORGMWeaponAutoIMNCSL:initialise
--**
--************************************************************************--
function ORGMWeaponAutoIMNCSL:initialise()

end

--************************************************************************--
--** ORGMWeaponAutoIMNCSL:new
--**
--************************************************************************--
function ORGMWeaponAutoIMNCSL:new()
	local o = {}
	--o.data = {}
	o = ISReloadableWeapon:new();
    setmetatable(o, self)
    self.__index = self
	o.reloadText = getText('ContextMenu_Reload');
	return o;
end

--************************************************************************--
--** ORGMWeaponAutoIMNCSL:isLoaded
--**
--** Returns whether or not the gun will fire when the mouse is next
--** clicked
--**
--************************************************************************--
function ORGMWeaponAutoIMNCSL:isLoaded(difficulty)
	return self.currentCapacity > 0;
end

--************************************************************************--
--** ORGMWeaponAutoIMNCSL:fireShot
--**
--** Action performed when a shot is fired. Should typically decrease
--** the current amount of ammo in the weapon
--**
--************************************************************************--
function ORGMWeaponAutoIMNCSL:fireShot(weapon, difficulty)
	if self.currentCapacity > 0 then
		self.currentCapacity = self.currentCapacity - 1;
	end
	self:syncReloadableToItem(weapon)
end

--************************************************************************--
--** ORGMWeaponAutoIMNCSL:canReload
--**
--** Whether the character attempting to reload has the necessary
--** prerequisites to perform the reload action. Called prior to
--** the timed action and not to be confused with isReloadValid
--**
--************************************************************************--
function ORGMWeaponAutoIMNCSL:canReload(chr)
	if(difficulty == 1) then
		if(chr:getInventory():FindAndReturn(ReloadUtil:getClipData(self.ammoType).ammoType)) then
			return true;
		end
	elseif(chr:getInventory():FindAndReturn(ReloadUtil:getClipData(self.ammoType).ammoType) ~= nil or chr:getInventory():FindAndReturn(self.ammoType) ~= nil) then
		return true;
	end
	return false;
end

function ORGMWeaponAutoIMNCSL:canUnload(chr)
	if(self.currentCapacity > 0) then
		return true;
	end
	return false;
end

--************************************************************************--
--** ORGMWeaponAutoIMNCSL:isReloadValid
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
function ORGMWeaponAutoIMNCSL:isReloadValid(char, square, difficulty)
	if self.maxCapacity == self.currentCapacity then
		return false
	end
	if(char:getInventory():FindAndReturn(ReloadUtil:getClipData(self.ammoType).ammoType) or chr:getInventory():FindAndReturn(self.ammoType)) then
		return true;
	end
	return false;
end

function ORGMWeaponAutoIMNCSL:isUnloadValid(char, square, difficulty)
	if(self.currentCapacity > 0) then
		return true;
	end
	self.unloadInProgress = false;
	return false;
end

--************************************************************************--
--** ORGMWeaponAutoIMNCSL:reloadStart
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
function ORGMWeaponAutoIMNCSL:reloadStart(char, square, difficulty)
	self.reloadInProgress = true;
end

function ORGMWeaponAutoIMNCSL:unloadStart(char, square, difficulty)
	self.unloadInProgress = true;
end

--************************************************************************--
--** ORGMWeaponAutoIMNCSL:reloadPerform
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
function ORGMWeaponAutoIMNCSL:reloadPerform(char, square, difficulty, weapon)
	local clip = nil;
	local mostAmmo = -1;
	local items = char:getInventory():getItems();
	-- look for the magazine in the inventory with the most ammo
	for i = 0, items:size()-1 do
		local currentItem = items:get(i);
		-- This may be the first time the item is used
		-- best call setupMagazine and see if it's a clip
		local requiredClipData = ReloadUtil:getClipData(self.ammoType)
		local currentReloadable = ReloadUtil:setupMagazine(currentItem, requiredClipData, char);
		-- Was the item a clip?
		if(currentReloadable ~= nil) then
			if(currentReloadable.clipType == requiredClipData.clipType) then
				-- check the amount of ammo
				if(currentReloadable.currentCapacity > mostAmmo) then
					clip = currentItem;
					mostAmmo = currentReloadable.currentCapacity;
				end
			end
		end
	end
	if (clip ~= nil) then
		if (clip:getModData().currentCapacity == clip:getModData().maxCapacity) then
			local clip2 = self:createMagazine();	
			char:getInventory():AddItem(clip2);
			ISInventoryPage.dirtyUI();				
			self.currentCapacity = clip:getModData().currentCapacity;
			char:getInventory():Remove(clip);
			ISInventoryPage.dirtyUI();
			self.reloadInProgress = false;
			char:getXp():AddXP(Perks.Reloading, 1);
		elseif (clip:getModData().currentCapacity == 0) then
			getSoundManager():PlayWorldSound(self.insertSound, char:getSquare(), 0, 10, 1.0, false);
			self.currentCapacity = self.currentCapacity + 1;
			-- remove the necessary ammo
			char:getInventory():RemoveOneOf(ReloadUtil:getClipData(self.ammoType).ammoType);
			self.reloadInProgress = false;
			self:syncReloadableToItem(weapon);
			char:getXp():AddXP(Perks.Reloading, 1);
			if(self.currentCapacity == self.maxCapacity) then
				return false;
			end
			return true;	
		else
			local sltester = 0;
			local slcc = clip:getModData().currentCapacity;
			if self.currentCapacity == 0 then
				sltester = 1
			end
			while sltester == 0 do
				self.currentCapacity = self.currentCapacity - 1;
				slcc = slcc + 1
				if (self.currentCapacity == 0 or slcc == clip:getModData().maxCapacity) then
					sltester = 1
				end
			end
			local clip2 = self:createMagazine();	
			char:getInventory():AddItem(clip2);
			ISInventoryPage.dirtyUI();		
			self.currentCapacity = slcc;
			char:getInventory():Remove(clip);
			ISInventoryPage.dirtyUI();
			self.reloadInProgress = false;
			char:getXp():AddXP(Perks.Reloading, 1);				
		end
	else
		getSoundManager():PlayWorldSound(self.insertSound, char:getSquare(), 0, 10, 1.0, false);
		self.currentCapacity = self.currentCapacity + 1;
		-- remove the necessary ammo
		char:getInventory():RemoveOneOf(ReloadUtil:getClipData(self.ammoType).ammoType);
		self.reloadInProgress = false;
		self:syncReloadableToItem(weapon);
		char:getXp():AddXP(Perks.Reloading, 1);
		if(self.currentCapacity == self.maxCapacity) then
			return false;
		end
		return true;
	end
	self:syncReloadableToItem(weapon);
	return false;
end

function ORGMWeaponAutoIMNCSL:unloadPerform(char, square, difficulty, weapon)
	getSoundManager():PlayWorldSound(self.insertSound, char:getSquare(), 0, 10, 1.0, false);
	self.currentCapacity = self.currentCapacity - 1;
	char:getInventory():AddItem('ORGM.'..ReloadUtil:getClipData(self.ammoType).ammoType);
	self.unloadInProgress = false;
	self:syncReloadableToItem(weapon);
	char:getXp():AddXP(Perks.Reloading, 1);
	if(self.currentCapacity == 0) then
		return false;
	end
	return true;
end

--************************************************************************--
--** ORGMWeaponAutoIMNCSL:rackingStart
--**
--** Function that should be performed upon the start of the timed action
--**
--** @param char - the character performing the action. Must not be nil
--** @param square - not used
--**
--************************************************************************--
function ORGMWeaponAutoIMNCSL:rackingStart(char, square, weapon)
    getSoundManager():PlayWorldSound(self.rackSound, char:getSquare(), 0, 10, 1.0, false);
end

--************************************************************************--
--** ORGMWeaponAutoIMNCSL:rackingPerform
--**
--** Function that should be performed upon successful completion of the
--** timed action
--**
--** @param char - the character performing the action. Must not be nil
--** @param square - not used
--** @param weapon - the item being reloaded
--**
--************************************************************************--
function ORGMWeaponAutoIMNCSL:rackingPerform(char, square, weapon)
	self:syncReloadableToItem(weapon);
end

--************************************************************************--
--** ORGMWeaponAutoIMNCSL:getRackTime
--**
--** Returns the time take to perform the reload action
--**
--************************************************************************--
function ORGMWeaponAutoIMNCSL:getRackTime()
	return self.rackTime;
end


--************************************************************************--
--** ORGMWeaponAutoIMNCSL:createMagazine
--**
--** Creates a new magazine for this weapon type containing as many rounds
--** as there are in this weapon
--**
--************************************************************************--
function ORGMWeaponAutoIMNCSL:createMagazine()
--	local magazine = InventoryItemFactory.CreateItem(self.moduleName, self.clipName, self.ammoType, self.clipIcon);
	local magazine = InventoryItemFactory.CreateItem(self.moduleName .. '.' .. self.ammoType);
	self:setupMagazine(magazine);
	magazine:getModData().currentCapacity = self.currentCapacity;
	return magazine;
end

--************************************************************************--
--** ORGMWeaponAutoIMNCSL:setupMagazine
--**
--** Sets up the ISReloadableMagazine on the InventoryItem
--**
--** @param magazine the InventoryItem to add the ISReloadableMagazine to
--**
--************************************************************************--
function ORGMWeaponAutoIMNCSL:setupMagazine(magazine)
	local magazineData = ReloadUtil:getClipData(self.ammoType)
	ReloadUtil:setupMagazine(magazine, magazineData, self.playerObj);
end

--************************************************************************--
--** ORGMWeaponAutoIMNCSL:getReloadTime
--**
--** Returns the time take to perform a single reload action
--**
--************************************************************************--
function ORGMWeaponAutoIMNCSL:getReloadTime()
	return self.reloadTime;
end

function ORGMWeaponAutoIMNCSL:isChainUnloading()
	return true;
end

--************************************************************************--
--** ORGMWeaponAutoIMNCSL:syncItemToReloadable
--**
--** Function that copies details from an Item's modData to the instance
--** of this ORGMWeaponAutoIMNCSL
--**
--** @param weapon - the weapon from which the reloadable information
--** should be retrieved
--**
--************************************************************************--
function ORGMWeaponAutoIMNCSL:syncItemToReloadable(weapon)
	local modData = weapon:getModData();
	 -- handle switching difficulty
	ISReloadableWeapon.syncItemToReloadable(self, weapon);
end

--************************************************************************--
--** ORGMWeaponAutoIMNCSL:syncReloadableToItem
--**
--** Function that copies details from the instance of this
--** ORGMWeaponAutoIMNCSL to an Item's modData
--**
--** @param weapon - the weapon to which the reloadable information
--** should be copied
--**
--************************************************************************--
function ORGMWeaponAutoIMNCSL:syncReloadableToItem(weapon)
	 -- handle switching difficulty
	ISReloadableWeapon.syncReloadableToItem(self, weapon);
	local modData = weapon:getModData();
end

--************************************************************************--
--** ORGMWeaponAutoIMNCSL:setupReloadable
--**
--** Function that initialises all the required modData on an item.
--**
--** @param weapon - the weapon to setup
--** @param v - the lua table containing the key value pairs to attach
--** to the modData
--************************************************************************--
function ORGMWeaponAutoIMNCSL:setupReloadable(weapon, v)
	ISReloadableWeapon.setupReloadable(self, weapon, v);
	local modData = weapon:getModData();
end

function WeaponChg_OnSawn(items, result, player)
	for i=0,items:size()-1 do
		local item = items:get(i)
			local modData = result:getModData()
			for k,v in pairs(item:getModData()) do
				modData[k] = v
			end
			modData.reloadClass = result:getModData().reloadClass
			result:attachWeaponPart(item:getScope())
			getPlayer():getInventory():AddItem(item:getCanon())
			getPlayer():getInventory():AddItem(item:getSling())
			getPlayer():getInventory():AddItem(item:getRecoilpad())
			getPlayer():getInventory():AddItem(item:getStock())
			return
    end
end

function ORGMWeaponAutoIMNCSL:printWeaponDetails(item)
    self:printItemDetails(item);
    local modData = item:getModData();
    local outString  = '';
    print(outString);
    print('***************************************************************');
    print();
    print();
end


function ORGMWeaponAutoIMNCSL:printReloadableWeaponDetails()
    self:printReloadableDetails();
    local outString  = '';
    print(outString);
    print('***************************************************************');
    print();
    print();
end
