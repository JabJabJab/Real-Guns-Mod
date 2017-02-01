require "Reloading/ISReloadableWeapon"

ORGMLoadClass = ISReloadableWeapon:derive("ORGMLoadClass");

function ORGMLoadClass:initialise() --initializing the script, nothing to see here

end

function ORGMLoadClass:new() --initializing the script, nothing to see here
	local o = {}
	o = ISReloadable:new();
	setmetatable(o, self);
	self.__index = self;
	return o;
end

function ORGMLoadClass:isLoaded(difficulty)	--checks if the gun is loaded with a live round
	if self.actionType == nil then -- if the item doesn't have an item type it will return false
		return false
	else
		if self.isOpen == 1 then
			return false
		else
			if self.chambering == 1 then -- if the gun is a chambering one, it checks if there is a round in the chamber
				return self.roundChambered == 1;
			elseif self.loadStyle == 'revolver' then -- if the gun is a revolver it checks to see if the cylinder is loaded
				return self.cylLoaded == 1;
			else -- otherwise if it is anything else, it sees if there is any ammo loaded
				return self.currentCapacity > 0;
			end
		end
	end
end

function ORGMLoadClass:fireShot() -- the script for handling effects after a gunshot
	if self.chambering == 1 then
	 --don't eject shell if BBs
	end
end

function ORGMLoadClass:loadStart(char, square, difficulty, loadType) --Initiates the reload/unload action
	if loadType == "unload" then
		char:playSound(self.rackSound, false);
	else
		if(difficulty == 1) then
			self.loadInProgress = true;
			char:playSound(self.insertSound, false);
		else
			self.loadInProgress = true;
			if(self.containsMag == 1 and self.containsMag ~= nil) then
				char:playSound(self.ejectSound, false);
			else
				char:playSound(self.insertSound, false);
			end
		end
	end
end

function ORGMLoadClass:csOpenCloseStart(char, square, difficulty, loadType) --Initiation of the half-rack action
	if loadType == "openSlide" or loadType == "openBolt" then
		char:playSound(self.openSound, false);
	else
		char:playSound(self.closeSound, false);
	end
end

function ORGMLoadClass:loadPerform(char, square, difficulty, loadable, ammotoload, loadType, loadStyle)
--this is the actual action/result of reloading
	if loadType == "reload" then
		if self.ammoLoaded == nil then
			self.ammoLoaded = {}
		end
		local loadableWeight = loadable:getActualWeight()
		local reloadAmmo = char:getInventory():FindAndReturn(ammotoload)
		local weightToAdd = 0
		if difficulty == 1 then --if it is on easy, it does the easy reload
			local amountToRemove = self.maxCapacity - self.currentCapacity;
			local inventoryAmmoCount = 0;
			local amountRemoved = 0;
			local ammoWeight = reloadAmmo:getActualWeight()
			--It fully reloads the gun
			while((char:getInventory():FindAndReturn(ammotoload) ~= nil) and amountRemoved < amountToRemove) do
				char:getInventory():RemoveOneOf(ammotoload);
				ISInventoryPage.dirtyUI();
				amountRemoved = amountRemoved + 1;
			end
			self.currentCapacity = self.currentCapacity + amountRemoved;
			while (amountRemoved ~= 0) do
				table.insert(self.ammoLoaded, 1, ammotoload)
				amountRemoved = amountRemoved - 1
				weightToAdd = weightToAdd + ammoWeight
			end
			loadableWeight = loadableWeight + weightToAdd
			loadable:setActualWeight(loadableWeight)
			loadable:setWeight(loadableWeight)
			loadable:setCustomWeight(true)
			char:playSound(self.insertSound, false);
			self:syncReloadableToItem(loadable);
			char:getXp():AddXP(Perks.Reloading, 1);
		else
			if loadStyle == 'magfed' then --if the gun is magfed it ejects or inserts the mag
				if self.containsMag == 1 then
					char:playSound(self.ejectSound, false);
					local mag = InventoryItemFactory.CreateItem(self.magInserted);
					ORGMLoadUtil:setUpLoadable(mag,self.playerObj)
					mag:getModData().currentCapacity = self.currentCapacity
					mag:getModData().ammoLoaded = self.ammoLoaded
					local magWt = mag:getActualWeight()
					for index,round in pairs(mag:getModData().ammoLoaded) do
						magWt = magWt + InventoryItemFactory.CreateItem("ORGM."..round):getActualWeight()
					end
					mag:setActualWeight(magWt)
					self.currentCapacity = 0;
					char:getInventory():AddItem(mag);
					ISInventoryPage.dirtyUI();
					self.ammoLoaded = {};
					loadable:setActualWeight(loadableWeight - magWt) --decreases the weight of the gun with the ammo
					loadable:setWeight(loadableWeight - magWt)
					loadable:setCustomWeight(true)
					self.containsMag = 0
					self:syncLoadabletoItem(loadable);
					char:getXp():AddXP(Perks.Reloading, 1);
					self.reloadInProgress = false;
				elseif self.containsMag == 0 then
					local ammoWeight = reloadAmmo:getActualWeight()
					local reloadData = reloadAmmo:getModData()
					char:playSound(self.insertSound, false);
					self.currentCapacity = reloadData.currentCapacity;
					self.maxCapacity = reloadData.maxCapacity;
					self.ammoLoaded = reloadData.ammoLoaded;
					loadable:setActualWeight(loadableWeight + ammoWeight)
					loadable:setWeight(loadableWeight + ammoWeight)
					loadable:setCustomWeight(true)
					self.magInserted = reloadAmmo:getFullType();
					char:getInventory():Remove(reloadAmmo);
					ISInventoryPage.dirtyUI();
					self.reloadInProgress = false;
					self.containsMag = 1;
					char:getXp():AddXP(Perks.Reloading, 1);
					self:syncLoadabletoItem(loadable);
				end
			elseif self.speedLoader == 1 and ORGMLoadManager.ORGMindexfinder(ammotoload, Magindexlist) ~= nil then
				char:playSound(self.insertSound, false);
				local amountToRemove = self.maxCapacity - self.currentCapacity; --to check how many rounds need to be loaded
				if self.loadStyle == 'revolver' then
					local chambersToCheck = self.maxCapacity --to make sure all the chambers are checked
					while chambersToCheck > 0 do						
						local itemInSpeedLoader = ammotoload.ammoLoaded[1]
						local itemsInTable = self.tableCount(self.ammoLoaded)
						local itemChambered = nil
						if itemsInTable < self.maxCapacity then
							
						else	
							itemChambered = self.ammoLoaded[1]
							table.remove(self.ammoLoaded,1)
							local chamberedWeight = 0
							if itemChambered ~= nil then
								chamberedWeight = itemChambered.Weight
							end
							self.Weight = self.Weight - chamberedWeight --increases the weight of the gun with the ammo
							self.WeaponWeight = self.WeaponWeight - chamberedWeight
							self.ammoWeight = self.ammoWeight - chamberedWeight --To keep track of loaded ammo weight
						end	
						if itemInSpeedLoader ~= nil then
							if ORGMLoadManager.ORGMindexfinder(itemChambered, Ammoindexlist) ~= nil then
								--if the item is a live applicable round, move it to the bottom
								table.insert(self.ammoLoaded, itemChambered)
								self.Weight = self.Weight + chamberedWeight --increases the weight of the gun with the ammo
								self.WeaponWeight = self.WeaponWeight + chamberedWeight
								self.ammoWeight = self.ammoWeight + chamberedWeight --To keep track of loaded ammo weight
							elseif itemChambered ~= nil then --if the item isn't an empty nil, it will give you the empty shell before loading a new round
								table.remove(ammotoload.ammoLoaded[1])
								ammotoload.Weight = ammotoload.Weight - itemInSpeedLoader.Weight --decreases the weight of the gun with the ammo
								ammotoload.WeaponWeight = ammotoload.WeaponWeight - itemInSpeedLoader.Weight
								ammotoload.ammoWeight = ammotoload.ammoWeight - itemInSpeedLoader.Weight --To keep track of loaded ammo weight
								self.Weight = self.Weight + itemInSpeedLoader.Weight --increases the weight of the gun with the ammo
								self.WeaponWeight = self.WeaponWeight + itemInSpeedLoader.Weight
								self.ammoWeight = self.ammoWeight + itemInSpeedLoader.Weight --To keep track of loaded ammo weight
								char:getCurrentSquare():AddWorldInventoryItem(itemChambered, 0, 0, 0)
								char:playSound(self.shellDropSound, false);
								table.insert(self.ammoLoaded, itemInSpeedLoader)
								self.currentCapacity = self.currentCapacity + 1
								ammotoload.currentCapacity = ammotoload.currentCapacity - 1
							else
								table.insert(self.ammoLoaded, itemInSpeedLoader)
								self.currentCapacity = self.currentCapacity + 1
								ammotoload.currentCapacity = ammotoload.currentCapacity - 1
								ammotoload.Weight = ammotoload.Weight - itemInSpeedLoader.Weight --increases the weight of the gun with the ammo
								ammotoload.WeaponWeight = ammotoload.WeaponWeight - itemInSpeedLoader.Weight
								ammotoload.ammoWeight = ammotoload.ammoWeight - itemInSpeedLoader.Weight --To keep track of loaded ammo weight
								self.Weight = self.Weight + itemInSpeedLoader.Weight --increases the weight of the gun with the ammo
								self.WeaponWeight = self.WeaponWeight + itemInSpeedLoader.Weight
								self.ammoWeight = self.ammoWeight + itemInSpeedLoader.Weight --To keep track of loaded ammo weight
							end
						else
							table.insert(self.ammoLoaded, itemChambered)
							self.Weight = self.Weight + chamberedWeight --increases the weight of the gun with the ammo
							self.WeaponWeight = self.WeaponWeight + chamberedWeight
							self.ammoWeight = self.ammoWeight + chamberedWeight --To keep track of loaded ammo weight						
						end
						chambersToCheck = chambersToCheck - 1
					end
					self.reloadInProgress = false;
					self:syncReloadableToItem(loadable);
					char:getXp():AddXP(Perks.Reloading, 1);
				else
					local roundsToAdd = math.min(amountToRemove, ammotoload.currentCapacity)
					while roundsToAdd > 0 do
						local lastRound = ammotoload.currentCapacity --because normal speedloaders load from the bottom of the speedloader
						local ammoMoved = ammotoload[lastRound]
						local lastWeight = lastRound.Weight
						table.remove(ammotoload)
						table.insert(self.ammoLoaded, 1, ammoMoved)
						ammotoload.Weight = ammotoload.Weight - lastWeight --increases the weight of the gun with the ammo
						ammotoload.WeaponWeight = ammotoload.WeaponWeight - lastWeight
						ammotoload.ammoWeight = ammotoload.ammoWeight - lastWeight --To keep track of loaded ammo weight
						self.Weight = self.Weight + lastWeight --increases the weight of the gun with the ammo
						self.WeaponWeight = self.WeaponWeight + lastWeight
						self.ammoWeight = self.ammoWeight + lastWeight --To keep track of loaded ammo weight
						roundsToAdd = roundsToAdd - 1
						self.currentCapacity = self.currentCapacity + 1
						ammotoload.currentCapacity = ammotoload.currentCapacity - 1
					end
					self.reloadInProgress = false;
					self:syncReloadableToItem(loadable);
					char:getXp():AddXP(Perks.Reloading, 1);
				end
			elseif self.loadStyle == 'revolver' then
				local chambersToCheck = self.maxCapacity--to make sure all the chambers are checked
				local itemsInTable = self.tableCount(self.ammoLoaded)
				local doneAmmoLoad = 0 --test if the ammo needing to be inserted was inserted already
				while chambersToCheck > 0 do
					itemChambered = nil
					if itemsInTable < self.maxCapacity and doneAmmoLoad ~= 1 then
						
					else	
						itemChambered = self.ammoLoaded[1]
						table.remove(self.ammoLoaded,1) -- temporarily removes item from the top to test it
						local chamberedWeight = 0
						if itemChambered ~= nil then
							chamberedWeight = itemChambered:getActualWeight() -- removes the weight just in case
							loadable:setActualWeight(loadableWeight - chamberedWeight)
							loadable:setWeight(loadableWeight - chamberedWeight)
							loadable:setCustomWeight(true)
						end
					end
					if doneAmmoLoad ~= 1 then --only adding one round to an empty cyl for this
						if ORGMLoadManager.ORGMindexfinder(itemChambered, Ammoindexlist) ~= nil then
							--if the item is a live applicable round, move it to the bottom
							table.insert(self.ammoLoaded, itemChambered)
							loadable:setActualWeight(loadableWeight + chamberedWeight)
							loadable:setWeight(loadableWeight + chamberedWeight)
							loadable:setCustomWeight(true)
						elseif itemChambered ~= nil then --if the item isn't an empty nil, it will give you the empty shell before loading a new round
							char:getCurrentSquare():AddWorldInventoryItem(itemChambered, 0, 0, 0) -- drops the empty shell on the ground for coolness effect
							char:playSound(self.shellDropSound, false);
							table.insert(self.ammoLoaded, nil)
							--This should cycle through the list and drop all the empty shells before loading
						else --if the chamber is empty (or nil), add a round
							table.insert(self.ammoLoaded, ammotoload)
							char:getInventory():RemoveOneOf(ammotoload);
							loadable:setActualWeight(loadableWeight + chamberedWeight)
							loadable:setWeight(loadableWeight + chamberedWeight)
							loadable:setCustomWeight(true)
							self.currentCapacity = self.currentCapacity + 1
							doneAmmoLoad = 1
							char:playSound(self.insertSound, false);
						end
					else --otherwise, cycle to the bottom
						table.insert(self.ammoLoaded, itemChambered)
						self.Weight = self.Weight + chamberedWeight --increases the weight of the gun with the ammo
						self.WeaponWeight = self.WeaponWeight + chamberedWeight
						self.ammoWeight = self.ammoWeight + chamberedWeight --To keep track of loaded ammo weight									
					end
					chambersToCheck = chambersToCheck - 1
				end
				char:getXp():AddXP(Perks.Reloading, 1);
				self.reloadInProgress = false;
				self:syncReloadableToItem(loadable);
			elseif self.loadStyle == 'revolver2' then
				
			else
				local ammoWeight = reloadAmmo:getActualWeight()
				self.currentCapacity = self.currentCapacity + 1;
				table.insert(self.ammoLoaded, 1, ammotoload)
				loadable:setActualWeight(loadableWeight + ammoWeight)
				loadable:setWeight(loadableWeight + ammoWeight)
				loadable:setCustomWeight(true)
				char:getInventory():RemoveOneOf(ammotoload);
				self.reloadInProgress = false;
				self:syncLoadabletoItem(loadable);
				char:getXp():AddXP(Perks.Reloading, 1);
				char:playSound(self.insertSound, false)
			end
			if(self.currentCapacity == self.maxCapacity) then
				return false;
			end
			return true;
		end
	else
		local loadableWeight = loadable:getActualWeight()
		local weightToRemove = 0
		if difficulty == 1 then
			char:playSound(self.rackSound, false)
			while self.currentCapacity ~= 0 do
				self.currentCapacity = self.currentCapacity - 1;
				local ammoRemoved = self.ammoLoaded[1]
				char:getInventory():AddItem("ORGM." .. ammoRemoved);
				local weightRemoved = weightRemoved + char:getInventory():FindAndReturn(ammoRemoved):getActualWeight()
				table.remove(self.ammoLoaded,1)
			end
			loadableWeight = loadableWeight - weightRemoved
			loadable:setActualWeight(loadableWeight)
			loadable:setWeight(loadableWeight - weightRemoved)
			loadable:setCustomWeight(true)
			self.unloadInProgress = false;
			self:syncReloadableToItem(loadable);
			char:getXp():AddXP(Perks.Reloading, 1);
			return false;
		else
			char:playSound(self.rackSound, false)
			self.currentCapacity = self.currentCapacity - 1;
			local ammoRemoved = self.ammoLoaded[1]
			char:getInventory():AddItem("ORGM." .. ammoRemoved);
			table.remove(self.ammoLoaded,1)
			local weightRemoved = char:getInventory():FindAndReturn(ammoRemoved):getActualWeight()
			loadable:setActualWeight(loadableWeight - weightRemoved)
			loadable:setWeight(loadableWeight - weightRemoved)
			loadable:setCustomWeight(true)
			self.unloadInProgress = false;
			self:syncLoadabletoItem(loadable);
			char:getXp():AddXP(Perks.Reloading, 1);
			if(self.currentCapacity == 0) then
				return false;
			end
			return true;
		end
	end
end

function ORGMLoadClass:openClosePerform(char, square, difficulty, loadable)
	if self.openClose == 1 and isOpen ~= nil and isOpen ~= 1 then
		char:playSound(self.openSound, false)
		self.isOpen = 1
	elseif self.openClose == 1 then
		char:playSound(self.closeSound, false)
		self.isOpen = 0
	end
end

function ORGMLoadClass:halfRackPerform(char, square, difficulty, loadable, loadType)
	--handles the half racking actions
	if loadType == "openslide" then --sets slide as opened
		loadable.slideOpened = 1;
		if self.roundChambered == 1 and char:getCurrentSquare() and char.ammoChambered ~= nil then --if something is already in the chamber, it is ejected to the ground
			char:getCurrentSquare():AddWorldInventoryItem(char.ammoChambered, 0, 0, 0)
			ISInventoryPage.dirtyUI()
		end
	elseif loadType == "closeslide" then --sets slide as closed
		loadable.slideOpened = 0;
	elseif loadType == "openbolt" then --sets bolt as opened
		loadable.boltOpened = 1;
		if self.roundChambered == 1 and char:getCurrentSquare() and char.ammoChambered ~= nil then --if something is already in the chamber, it is ejected to the ground
			char:getCurrentSquare():AddWorldInventoryItem(char.ammoChambered, 0, 0, 0)
			ISInventoryPage.dirtyUI()
		end
	else --otherwise sets bolt as closed
		loadable.boltOpened = 0;
	end
end

function ORGMLoadClass:canContinueLoad(player, loadWeapon, loadType, reloadAmmo, reloadMag)
	--checks if the gun is able to continue loading after the first reload action
	loadData = loadWeapon:getModData();
	if loadData.loadStyle == 'magfed' or reloadMag ~= nil or loadData.currentCapacity == loadData.maxCapacity and loadType ~= "Unload" then
	--we don't want it continuing if it mag fed, we used a speed loader or it's already full, so stops the process if so
		return false
	elseif loadType == "unload" then
		local chamberedRnd = 0
		local loadedRnds = 0
		if loadData.roundChambered ~= nil then
			chamberedRnd = loadData.roundChambered
		else
			chamberedRnd = 0
		end
		loadedRnds = loadData.currentCapacity
		if loadedRnds + chamberedRnd > 0 then
			return true
		else
			return false
		end
	else
		if player:getInventory():FindAndReturn(reloadAmmo) ~= nil then
		--can't reload without ammo, so if there is still ammo, it will continue, otherwise, it stops it
			return true
		else
			return false
		end
	end
end

function ORGMLoadClass:isReloadable(item, difficulty) -- check to see if the gun can reload
	if difficulty == 1 or item.loadStyle ~= 'magfed' then
		if item.currentCapacity < item.maxCapacity then
			return true
		else
			return false
		end
	elseif item.loadStyle == 'magfed' then
		return true
	else 
		return false
	end
end

function ORGMLoadClass:isUnloadable(item, difficulty) -- check to see if a gun has ammo to unload
	local unloadTest = item.currentCapacity;
	if item.roundChambered ~= nil and item.roundChambered == 1 then
		unloadTest = unloadTest + 1
	end
	if unloadTest > 0 then
		return true
	else
		return false
	end
end

function ORGMLoadClass:rackingStart(char, square, weapon)
	if (self.isRackOpen == 1 and self.isRackOpen ~= nil) then
		char:playSound(self.closeSound, false);
	else
		char:playSound(self.rackSound, false);
	end
end

function ORGMLoadClass:getRackTime()
	return self.rackTime;
end

function ORGMLoadClass:rackingPerform(char, square, weapon) --add closing of gun if open on rack
    if(self.currentCapacity > 0) then
		self.currentCapacity = self.currentCapacity - 1;
		local ammoRemoved = self.ammoloaded[1]
		char:getInventory():AddItem(ammoRemoved);
		table.remove(self.ammoloaded,1)
		ISInventoryPage.dirtyUI();
		self:syncReloadableToItem(weapon);
	end
end

function ORGMLoadClass:tableCount(tabletocheck) --Counts items currently in the table
	local count = 0
	for _ in pairs(tabletocheck) do
		count = count + 1
	end
	return count
end

function ORGMLoadClass:canReload(difficulty) --try to kill the base reload script
	return false
end

function ORGMLoadClass:syncItemToLoadable(item) --Copies variables from the item to the reloadable script
	local modData = item:getModData();
	if(modData.reloadClass ~= nil) then
		self.type = modData.type or item:getType();
		self.moduleName = modData.moduleName
		if(self.moduleName == nil) then
			self.moduleName = 'Base'
		end
		self.ammoType = modData.ammoType;
		self.boltOpened = modData.boltOpened;
		self.magType = modData.magType;
		self.shellType = modData.shellType;
		self.maxCapacity = modData.maxCapacity;
		self.shootSound = modData.shootSound;
		self.reloadTime = modData.reloadTime;
		self.ammoChambered = modData.ammoChambered;
		self.ammoLoaded = modData.ammoLoaded;
		self.containsMag = modData.containsMag;
		self.currentCapacity = modData.currentCapacity;
		self.cylLoaded = modData.cylLoaded;
		self.magInserted = modData.magInserted;
		self.needRotate = modData.needRotate;
		self.roundChambered = modData.roundChambered;
		self.slideOpened = modData.slideOpened;
	end
end

function ORGMLoadClass:syncItemToReloadable(item)
end

function ORGMLoadClass:syncLoadabletoItem(item) --Copies variables from the reloadable script to the item
	local modData = item:getModData();
	if(modData.reloadClass ~= nil) then
		modData.ammoType = self.ammoType;
		modData.magType = self.magType;
		modData.shellType = self.shellType;
		modData.maxCapacity = self.maxCapacity;
		modData.shootSound = self.shootSound;
		modData.reloadTime = self.reloadTime;
		modData.ammoChambered = self.ammoChambered;
		modData.ammoLoaded = self.ammoLoaded;
		modData.boltOpened = self.boltOpened;
		modData.containsMag = self.containsMag;
		modData.currentCapacity = self.currentCapacity;
		modData.cylLoaded = self.cylLoaded;
		modData.magInserted = self.magInserted;
		modData.needRotate = self.needRotate;
		modData.roundChambered = self.roundChambered;
		modData.slideOpened = self.slideOpened;
	end
end

function ORGMLoadClass:setupLoadable(item, v) --initial setup only. Sets up all the variables affected by the reload script. Use when spawning the gun.
	local modData = item:getModData();
	modData.reloadClass = v.reloadClass;
	modData.ammoType = v.ammoType;
	modData.boltOpened = v.boltOpened;
	modData.magType = v.magType;
	modData.shellType = v.shellType;
	modData.maxCapacity = v.maxCapacity;
	modData.loadStyle = v.loadStyle;
	modData.shootsound = v.shootsound;
	modData.reloadTime = v.reloadTime;
	modData.ammoChambered = nil;
	modData.ammoLoaded = nil;
	modData.containsMag = 0;
	modData.currentCapacity = 0;
	modData.cylLoaded = v.cylLoaded;
	modData.magInserted = nil;
	modData.needRotate = v.needRotate;
	modData.roundChambered = nil;
	modData.slideOpened = self.slideOpened;
	modData.shootSound = v.shootSound
	modData.clickSound = v.clickSound
	modData.insertSound = v.insertSound
	modData.ejectSound = v.ejectSound
	modData.rackSound = v.rackSound
end