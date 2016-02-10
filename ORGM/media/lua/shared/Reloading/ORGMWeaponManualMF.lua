require "Reloading/ISReloadableWeapon"

ORGMWeaponManualMF = ISReloadableWeapon:derive("ORGMWeaponManualMF");

--************************************************************************--
--** ORGMWeaponManualMF:initialise
--**
--************************************************************************--
function ORGMWeaponManualMF:initialise()

end

--************************************************************************--
--** ORGMWeaponManualMF:new
--**
--** Constructor for the ORGMWeaponManualMF reloadable
--************************************************************************--
function ORGMWeaponManualMF:new()
	local o = {}
	--o.data = {}
	o = ISReloadableWeapon:new();
    setmetatable(o, self)
    self.__index = self
	o.removeClipText = getText('ContextMenu_EjectMagazine');
	o.insertClipText = getText('ContextMenu_InsertMagazine');
	o.reloadText = getText('ContextMenu_Reload');
	return o;
end

--************************************************************************--
--** ORGMWeaponManualMF:isLoaded
--**
--** Returns whether or not the gun will fire when the mouse is next
--** clicked
--**
--************************************************************************--
function ORGMWeaponManualMF:isLoaded(difficulty)
	return self.roundChambered == 1;
end

--************************************************************************--
--** ORGMWeaponManualMF:fireShot
--**
--** Action performed when a shot is fired. Should typically decrease
--** the current amount of ammo in the weapon
--**
--************************************************************************--
function ORGMWeaponManualMF:fireShot(weapon, difficulty)
	self.roundChambered = 0;
	self.emptyShellChambered = 1;
	self:syncReloadableToItem(weapon);
end

--************************************************************************--
--** ORGMWeaponManualMF:canReload
--**
--** Whether the character attempting to reload has the necessary
--** prerequisites to perform the reload action. Called prior to
--** the timed action and not to be confused with isReloadValid
--**
--************************************************************************--
function ORGMWeaponManualMF:canReload(chr)
	if(difficulty == 1) then
		if(chr:getInventory():FindAndReturn(ReloadUtil:getClipData(self.ammoType).ammoType)) then
			return true;
		end
	elseif(self.containsClip == 1 or chr:getInventory():FindAndReturn(self.ammoType) ~= nil) then
		return true;
	end
	return false;
end

function ORGMWeaponManualMF:canUnload(chr)
	if(self.roundChambered > 0 or self.currentCapacity > 0) then
		return true;
	end
	return false;
end

--************************************************************************--
--** ORGMWeaponManualMF:isReloadValid
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
function ORGMWeaponManualMF:isReloadValid(char, square, difficulty)
	if(difficulty == 3) then
		return self:isReloadValidHard(char, square);
	elseif(difficulty == 1) then
		return self:isReloadValidEasy(char, square);
	else
		return self:isReloadValidNormal(char, square);
	end
end

function ORGMWeaponManualMF:isReloadValidEasy(char, square)
	if self.maxCapacity == self.currentCapacity then
		return false
	end
	if(char:getInventory():FindAndReturn(ReloadUtil:getClipData(self.ammoType).ammoType)) then
		return true;
	end
	return false;
end

function ORGMWeaponManualMF:isReloadValidNormal(char, square)
		-- TODO make sure the player still has the weapon on their person
	if(self.containsClip == 1
	or char:getInventory():FindAndReturn(self.ammoType) ~= nil) then
		return true;
	end
	self.reloadInProgress = false;
	return false;
end

function ORGMWeaponManualMF:isReloadValidHard(char, square)
	return true;
end

function ORGMWeaponManualMF:isUnloadValid(char, square, difficulty)
	if(self.roundChambered > 0 or self.currentCapacity > 0) then
		return true;
	end
	self.unloadInProgress = false;
	return false;
end

--************************************************************************--
--** ORGMWeaponManualMF:reloadStart
--**
--** Function that should be performed upon the start of the timed action
--**
--** @param char - the character performing the action. Must not be nil
--** @param square - not used
--**
--************************************************************************--
function ORGMWeaponManualMF:reloadStart(char, square, difficulty)
	if(difficulty == 1) then
		self:reloadStartEasy(char, square);
	else
		self:reloadStartNormal(char, square);
	end
end


function ORGMWeaponManualMF:reloadStartEasy(char, square)
	self.reloadInProgress = true;
	getSoundManager():PlayWorldSound(self.ejectSound, char:getSquare(), 0, 10, 1.0, false);
end

function ORGMWeaponManualMF:reloadStartNormal(char, square)
	self.reloadInProgress = true;
	if(self.containsClip == 1) then
		getSoundManager():PlayWorldSound(self.ejectSound, char:getSquare(), 0, 10, 1.0, false);
	else
		getSoundManager():PlayWorldSound(self.insertSound, char:getSquare(), 0, 10, 1.0, false);
	end
end

function ORGMWeaponManualMF:unloadStart(char, square, difficulty)
	self.unloadInProgress = true;
end

--************************************************************************--
--** ORGMWeaponManualMF:reloadPerform
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
function ORGMWeaponManualMF:reloadPerform(char, square, difficulty, weapon)
	if(difficulty == 1) then
		self:reloadPerformEasy(char, square, weapon)
	else
		self:reloadPerformNormal(char, square, weapon)
	end
end

function ORGMWeaponManualMF:reloadPerformEasy(char, square, weapon)
	-- Does find and return give an abilty to determine size of stack?
	local amountToRemove = self.maxCapacity - self.currentCapacity;
	local inventoryAmmoCount = 0;
	local amountRemoved = 0;
	while((char:getInventory():FindAndReturn(ReloadUtil:getClipData(self.ammoType).ammoType) ~= nil)
	and amountRemoved < amountToRemove) do
		char:getInventory():RemoveOneOf(ReloadUtil:getClipData(self.ammoType).ammoType);
        ISInventoryPage.dirtyUI();
		amountRemoved = amountRemoved + 1;
	end
	self.currentCapacity = self.currentCapacity + amountRemoved;
	getSoundManager():PlayWorldSound(self.insertSound, char:getSquare(), 0, 10, 1.0, false);
	self:syncReloadableToItem(weapon);
	char:getXp():AddXP(Perks.Reloading, 1);
end

function ORGMWeaponManualMF:reloadPerformNormal(char, square, weapon)
	if(self.containsClip == 1) then
		-- we are ejecting the current clip
		local clip = self:createMagazine();
		self.currentCapacity = 0;
		char:getInventory():AddItem(clip);
        ISInventoryPage.dirtyUI();
		self.containsClip = 0;
		self.reloadInProgress = false;
	else
		-- we are inserting a new clip
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
			self.currentCapacity = clip:getModData().currentCapacity;
			char:getInventory():Remove(clip);
            ISInventoryPage.dirtyUI();
			self.reloadInProgress = false;
			self.containsClip = 1;
			char:getXp():AddXP(Perks.Reloading, 1);
		end
	end
	self:syncReloadableToItem(weapon);
	return false;
end

function ORGMWeaponManualMF:unloadPerform(char, square, difficulty, weapon)
	getSoundManager():PlayWorldSound(self.rackSound, char:getSquare(), 0, 10, 1.0, false);
	if(self.roundChambered == 1) then
		self.roundChambered = 0
	else
		self.currentCapacity = self.currentCapacity - 1;
	end
	char:getInventory():AddItem('ORGM.'..ReloadUtil:getClipData(self.ammoType).ammoType);
	self.unloadInProgress = false;
	self:syncReloadableToItem(weapon);
	char:getXp():AddXP(Perks.Reloading, 1);
	if(self.currentCapacity == 0 and self.roundChambered == 0) then
		return false;
	end
	return true;
end

--************************************************************************--
--** ORGMWeaponManualMF:rackingStart
--**
--** Function that should be performed upon the start of the timed action
--**
--** @param char - the character performing the action. Must not be nil
--** @param square - not used
--**
--************************************************************************--
function ORGMWeaponManualMF:rackingStart(char, square, weapon)
    getSoundManager():PlayWorldSound(self.rackSound, char:getSquare(), 0, 10, 1.0, false);
	if self.emptyShellChambered == 1 and weapon:getShellFallSound() and weapon:getShellFallSound() ~= '' then
		getSoundManager():PlayWorldSound(weapon:getShellFallSound(), char:getSquare(), 0, 7, 1.0, false);
	end
end

--************************************************************************--
--** ORGMWeaponManualMF:rackingPerform
--**
--** Function that should be performed upon successful completion of the
--** timed action
--**
--** @param char - the character performing the action. Must not be nil
--** @param square - not used
--** @param weapon - the item being reloaded
--**
--************************************************************************--
function ORGMWeaponManualMF:rackingPerform(char, square, weapon)
	if self.roundChambered == 1 and char:getCurrentSquare() then
		local clipData = ReloadUtil:getClipData(self.ammoType)
		local round = InventoryItemFactory.CreateItem(clipData.moduleName .. '.' .. clipData.ammoType)
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

--************************************************************************--
--** ORGMWeaponManualMF:getRackTime
--**
--** Returns the time take to perform the reload action
--**
--************************************************************************--
function ORGMWeaponManualMF:getRackTime()
	return self.rackTime;
end

function ORGMWeaponAutoMF:isChainUnloading()
	return true;
end

--************************************************************************--
--** ORGMWeaponManualMF:createMagazine
--**
--** Creates a new magazine for this weapon type containing as many rounds
--** as there are in this weapon
--**
--************************************************************************--
function ORGMWeaponManualMF:createMagazine()
--	local magazine = InventoryItemFactory.CreateItem(self.moduleName, self.clipName, self.ammoType, self.clipIcon);
	local magazine = InventoryItemFactory.CreateItem(self.moduleName .. '.' .. self.ammoType);
	self:setupMagazine(magazine);
	magazine:getModData().currentCapacity = self.currentCapacity;
	return magazine;
end

--************************************************************************--
--** ORGMWeaponManualMF:setupMagazine
--**
--** Sets up the ISReloadableMagazine on the InventoryItem
--**
--** @param magazine the InventoryItem to add the ISReloadableMagazine to
--**
--************************************************************************--
function ORGMWeaponManualMF:setupMagazine(magazine)
	local magazineData = ReloadUtil:getClipData(self.ammoType)
	ReloadUtil:setupMagazine(magazine, magazineData, self.playerObj);
end

--************************************************************************--
--** ORGMWeaponManualMF:getReloadText
--**
--** Returns the string that should be displayed in the UI reload option
--**
--** @return - the string that should be displayed
--**
--************************************************************************--
function ORGMWeaponManualMF:getReloadText()
	if(ReloadManager[1]:getDifficulty() == 1) then
		return self.reloadText;
	end
	if(self.containsClip == 1) then
		return self.removeClipText;
	else
		return self.insertClipText;
	end;
end

--************************************************************************--
--** ORGMWeaponManualMF:isChainReloading
--**
--** Returns true if a reload action should be performed immediately after
--** this one. Does not take into account ammunition availability
--**
--************************************************************************--
function ORGMWeaponManualMF:isChainReloading()
	return false;
end

--************************************************************************--
--** ORGMWeaponManualMF:getReloadTime
--**
--** Returns the time take to perform a single reload action
--**
--************************************************************************--
function ORGMWeaponManualMF:getReloadTime()
	if(ReloadManager[1]:getDifficulty() == 1) then
		return self.reloadTime*2;
	end
	return self.reloadTime;
end

--************************************************************************--
--** ORGMWeaponManualMF:syncItemToReloadable
--**
--** Function that copies details from an Item's modData to the instance
--** of this ORGMWeaponManualMF
--**
--** @param weapon - the weapon from which the reloadable information
--** should be retrieved
--**
--************************************************************************--
function ORGMWeaponManualMF:syncItemToReloadable(weapon)
	local modData = weapon:getModData();
	 -- handle switching difficulty
	if ReloadManager[1]:getDifficulty() == 1 then
		modData.containsClip = 1
	end
	ISReloadableWeapon.syncItemToReloadable(self, weapon);
	self.roundChambered = modData.roundChambered;
	self.emptyShellChambered = modData.emptyShellChambered or 0
	self.containsClip = modData.containsClip;
	self.clipName = modData.clipName;
	self.clipIcon = modData.clipIcon;
end

--************************************************************************--
--** ORGMWeaponManualMF:syncReloadableToItem
--**
--** Function that copies details from the instance of this
--** ORGMWeaponManualMF to an Item's modData
--**
--** @param weapon - the weapon to which the reloadable information
--** should be copied
--**
--************************************************************************--
function ORGMWeaponManualMF:syncReloadableToItem(weapon)
	if ReloadManager[1]:getDifficulty() == 1 then
		self.containsClip = 1
	end
	ISReloadableWeapon.syncReloadableToItem(self, weapon);
	local modData = weapon:getModData();
	modData.roundChambered = self.roundChambered;
	modData.emptyShellChambered = self.emptyShellChambered
	modData.containsClip = self.containsClip;
end

--************************************************************************--
--** ORGMWeaponManualMF:setupReloadable
--**
--** Function that initialises all the required modData on an item.
--**
--** @param weapon - the weapon to setup
--** @param v - the lua table containing the key value pairs to attach
--** to the modData
--************************************************************************--
function ORGMWeaponManualMF:setupReloadable(weapon, v)
	ISReloadableWeapon.setupReloadable(self, weapon, v);
	local modData = weapon:getModData();
	modData.roundChambered = 0;
	modData.containsClip = 1;
	modData.clipName = v.clipName;
	modData.clipIcon = v.clipIcon;
end


function ORGMWeaponManualMF:printWeaponDetails(item)
    self:printItemDetails(item);
    local modData = item:getModData();
    local outString  = '';
    if(modData.roundChambered ~= nil) then
        outString = outString..', roundChambered: '..modData.roundChambered;
    else
        outString = outString..', roundChambered == nil';
    end
    if(modData.containsClip ~= nil) then
        outString = outString..', containsClip: '..modData.containsClip;
    else
        outString = outString..', containsClip == nil';
    end
    if(modData.clipName ~= nil) then
        outString = outString..', clipName: '..modData.clipName;
    else
        outString = outString..', clipName == nil';
    end
    if(modData.clipIcon ~= nil) then
        outString = outString..', clipIcon: '..modData.clipIcon;
    else
        outString = outString..', clipIcon == nil';
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


function ORGMWeaponManualMF:printReloadableWeaponDetails()
    self:printReloadableDetails();
    local outString  = '';
    if(self.roundChambered ~= nil) then
        outString = outString..', roundChambered: '..self.roundChambered;
    else
        outString = outString..', roundChambered == nil';
    end
    if(self.containsClip ~= nil) then
        outString = outString..', containsClip: '..self.containsClip;
    else
        outString = outString..', containsClip == nil';
    end
    if(self.clipName ~= nil) then
        outString = outString..', clipName: '..self.clipName;
    else
        outString = outString..', clipName == nil';
    end
    if(self.clipIcon ~= nil) then
        outString = outString..', clipIcon: '..self.clipIcon;
    else
        outString = outString..', clipIcon == nil';
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
