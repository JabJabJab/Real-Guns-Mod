require "ISBaseObject"
require "Reloading/ISReloadUtil"
require "Reloading/ORGMRackAction"
require "Reloading/ORGMLoadAction"

ORGMLoadManager = ISReloadManager:derive("ORGMLoadManager");

function ORGMLoadManager:initialise() --also initiates

end

function ORGMLoadManager:new(player) --initialization of script
	local o = {}
	setmetatable(o, self)
    self.__index = self
	o.loadWeapon = nil;
	o.loadType = nil;
	o.reloadAmmo = nil;
	o.reloadMag = nil;
	o.spaceIsPressed = false;
	o.rIsPressed = false;
	o.uIsPressed = false;
	o.loadAction = nil;
	o.rackingAction = nil;
	o.loadable = nil;
	o.playerid = player;
	o.lastClickTime = 0

    return o;
end

aaa = {}

function ORGMLoadManager:getDifficulty() --gets the difficulty
	return getCore():getOptionReloadDifficulty()
end

function ORGMLoadManager:ammoSearch(testData) --searches player inventory for usable ammo, returns the first usable ammo on the list
	local player = getPlayer()
	local tablename = testData.ammoType
	local ammoTable = _G[tablename]
	if ammoTable ~= nil then
		for index,testCal in ipairs(ammoTable) do
			if player:getInventory():FindAndReturn(testCal) ~= nil then
				return testCal
			end
		end
	end
end

function ORGMLoadManager:magSearch(testData) --searches player inventory for usable mags, returns the first usable mag on the list
	local player = getPlayer()
	local tablename = testData.magType
	local magTable = _G[tablename]
	if magTable ~= nil then
		for index,testMag in ipairs(magTable) do
			if player:getInventory():FindAndReturn(testMag) ~= nil then
				return testMag
			end
		end
	end
end

function ORGMLoadManager:mostLoadedClipSearch(testData) --returns the most loaded clip more than 0
	local mostAmmo = 0;
	local clip = nil
	local tablename = testData.magType
	local clipTable = _G[tablename]
	local player = getPlayer()
	local items = player:getInventory():getItems();
	if clipTable ~= nil then
		for i = 0, items:size()-1 do
			local currentItem = items:get(i);
			for index,testClip in ipairs(clipTable) do
				if testClip.type == currentItem.type then
					local currentCap = currentItem:getModData().currentCapacity
					if currentCap > mostAmmo then
						mostAmmo = currentCap
						clip = currentItem
					end
				end
			end
		end
		return clip
	end
end

function ORGMLoadManager:mostLoadedSearch(testData) --returns the most loaded mag or any mag if they are all empty
	local mostAmmo = -1;
	local mag = nil
	local tablename = testData.magType
	local magTable = _G[tablename]
	local player = getPlayer()
	local items = player:getInventory():getItems();
	if magTable ~= nil then
		for i = 0, items:size()-1 do
			local currentItem = items:get(i);
			for index,testMag in ipairs(magTable) do
				if testMag.type == currentItem.type then
					local currentCap = currentItem:getModData().currentCapacity
					if currentCap ~= nil then
						if currentCap > mostAmmo then
							mostAmmo = currentCap
							mag = currentItem
						end
					end
				end
			end
		end
		return mag
	end
end

function ORGMLoadManager:mostLoadedSearch2(magType) --searches for the most loaded iteration of the selected mag
	local mostAmmo = -1;
	local mag = nil
	local player = getPlayer()
	local items = player:getInventory():getItems();
	for i = 0, items:size()-1 do
		local currentItem = items:get(i);
		local requiredMagData = ORGMLoadUtil:getLoadableData(magType)
		local currentLoadable = ORGMLoadUtil:setupLoadable(currentItem, requiredMagData);
		if(currentLoadable ~= nil) then
			if(currentLoadable.type == requiredMagData.type) then
				if(currentLoadable.currentCapacity > mostAmmo) then
					mag = currentItem;
					mostAmmo = currentLoadable.currentCapacity;
				end
			end
		end
	end
	return mag
end

function ORGMLoadManager:isWeaponReloadable(weapon)
	local weaponData = weapon:getModData();
	if weaponData.currentCapacity < weaponData.maxCapacity or weaponData.loadStyle == 'magfed' then --if the gun is fully loaded or if the gun is mag fed return false
		local ammoAvailable = false
		local difficulty = self.getDifficulty()
		if weaponData.loadStyle == 'magfed' then
			if difficulty == 1 then
				if self:ammoSearch(weaponData) ~=nil then
					return true
				end
			else
				if self:magSearch(weaponData) ~= nil or weaponData.containsMag == 1 then
					return true
				end
			end
		elseif weaponData.speedLoader ~= nil and weaponData.speedLoader == 1 then
			if difficulty == 1 then
				if self:ammoSearch(weaponData) ~=nil then
					return true
				end
			else
				if self:mostLoadedClipSearch(weaponData) ~= nil or self:ammoSearch(weaponData) ~= nil then
					return true
				end
			end
		else
			if self:ammoSearch(weaponData) ~=nil then
				return true
			end
		end
	end
	return false
end

function ORGMLoadManager:isWeaponUnloadable(weapon) --checks to see if there is ammo in the gun at all
	local weaponData = weapon.getModData();
	local chambered = 0
	local capacity = 0
	local tester = 0
	if weaponData.roundChambered ~=nil then
		chambered = weaponData.roundChambered
	else
		chambered = 0
	end
	if weaponData.currentCapacity ~= nil then
		capacity = weaponData.currentCapacity
	else
		capacity = 0
	end
	tester = chambered + capacity
	if tester > 0 then
		return true
	else
		return false
	end
end

function ORGMLoadManager:stopLoad(noSound) --ends the loading script
	self.loadAction.javaAction = nil;
	self.loadWeapon = nil;
	self.loadable = nil;
	self.rackingaction = nil;
end

function ORGMLoadManager:rackingNow()
	local playerObj = getSpecificPlayer(self.playerid)
	if playerObj:getCharacterActions():isEmpty() then return false end
	return ISTimedActionQueue.hasAction(self.rackingAction) and self.rackingAction.action == playerObj:getCharacterActions():get(0)
end

function ORGMLoadManager:autoRackNeeded()
	local playerObj = getSpecificPlayer(self.playerid)
	if self:getDifficulty() == 3 and playerObj:getJoypadBind() == -1 then return false end
	return self.reloadable:canRack(playerObj)
end

function ORGMLoadManager:loadStarted() --test to see if you are currently reloading
	if self.loadAction ~= nil then
		return ISTimedActionQueue.hasAction(self.loadAction)
	end
	return false
end

function ORGMLoadManager:rackingStarted() --test to see if you are currently racking
	if self.rackingAction ~= nil then
		return ISTimedActionQueue.hasAction(self.rackingAction)
	end
	return false
end

function ORGMLoadManager:startLoading() --starts the loading action
	local player = getPlayer()
	local moodles = player:getMoodles();
	local panicLevel = moodles:getMoodleLevel(MoodleType.Panic);
	local actionTime = 0
	self.loadable = ORGMLoadUtil:getLoadableWeapon(self.loadWeapon, player);
	self.loadableData = self.loadWeapon:getModData()
	if self.loadableData.openClose ~= 1 and self.loadableData.openClose == 1 and self.loadableData.isOpen ~= nil and self.loadableData.isOpen ~= 1 then
		actionTime = self.loadable.openCloseTime
	elseif self.loadStyle == 'revolver2' then
		local needsRotate = ORGMLoadUtil:needsCylRotate(self.loadableData)
		if needsRotate == true then
			actionTime = self.loadable.openCloseTime
		else
			actionTime = self.loadable.reloadTime
		end
	else
		actionTime = self.loadable.reloadTime
	end
	self.loadAction = ORGMLoadAction:new(self, player, self.loadType, player:getSquare(),
		(actionTime*player:getReloadingMod())+(panicLevel*30))
	ISTimedActionQueue.add(self.loadAction)
end

function ORGMLoadManager:startClosing() --starts the close action
	local player = getPlayer()
	local moodles = player:getMoodles();
	local panicLevel = moodles:getMoodleLevel(MoodleType.Panic);
	self.loadable = ORGMLoadUtil:getLoadableWeapon(self.loadWeapon, player);
	self.openAction = ORGMLoadAction:new(self, player, "close", player:getSquare(),
		(self.reloadable.openCloseTime*player:getReloadingMod())+(panicLevel*30))
	ISTimedActionQueue.add(self.openAction)
end

function ORGMLoadManager:startOpening() --starts the open action
	local player = getPlayer()
	local moodles = player:getMoodles();
	local panicLevel = moodles:getMoodleLevel(MoodleType.Panic);
	self.loadable = ORGMLoadUtil:getLoadableWeapon(self.loadWeapon, player);
	self.openAction = ORGMLoadAction:new(self, player, "open", player:getSquare(),
		(self.reloadable.openCloseTime*player:getReloadingMod())+(panicLevel*30))
	ISTimedActionQueue.add(self.openAction)
end

function ORGMLoadManager:ocSlideBoltStart() --starts the half rack action
	local player = getPlayer()
	local moodles = player:getMoodles();
	local panicLevel = moodles:getMoodleLevel(MoodleType.Panic);
	self.loadable = ORGMLoadUtil:getLoadableWeapon(self.loadWeapon, player);
	self.openAction = ORGMLoadAction:new(self, player, self.loadType, player:getSquare(),
		(self.reloadable.rackTime/2*player:getReloadingMod())+(panicLevel*30))
	ISTimedActionQueue.add(self.openAction)
end

function ORGMLoadManager:startRacking() --starts the racking action
	local player = getSpecificPlayer(self.playerid)
	local moodles = player:getMoodles();
	local panicLevel = moodles:getMoodleLevel(MoodleType.Panic);
	self.loadable = ORGMLoadUtil:getLoadableWeapon(self.loadWeapon, player);
	self.rackAction = ORGMRackAction:new(self, player, player:getSquare(),
		(self.reloadable.rackTime*player:getReloadingMod())+(panicLevel*30))
	ISTimedActionQueue.add(self.rackAction)
end

function ORGMLoadManager:stopLoadSuccess() --either continues the loading script for loose rounds or, ends it and clears the queue
	local playerObj = getPlayer()
	if(self.loadWeapon ~= nil and self:loadStarted() == true) then
		if(self.loadable:canContinueLoad(playerObj, self.loadWeapon, self.loadType, self.reloadAmmo, self.reloadMag)) then --check to see if it can still load
			self:startLoading(); --continues
		elseif self.openClose ~= nil and self.openClose == 1 and isOpen ~= nil and isOpen ~= 0 then
			self:startClosing();
		else
			self:stopLoad() --stops
		end
	end
end

function ORGMLoadManager:startUnloadFromUi(item) --starts the unload process from ui
	if(self:loadStarted() == false) then
		self.loadWeapon = item;
		self.loadType = "unload"
		self:startLoading();
	end
end

function ORGMLoadManager:startReloadFromUi(item, ammo) --starts the reloading process
	if (self.loadAction == nil or self:loadStarted() == false) and (self.rackingAction == nil or self:rackingStarted() == false) then --makes sure there is no action going
		self.loadWeapon = item;
		self.reloadAmmo = ammo;
		if self.reloadAmmo ~= nil then
			if self.reloadAmmo.reloadClass ~= nil then --test to ignore this if it is not a magazine
				self.reloadMag = self:mostLoadedSearch2(ammo); --checks for the most loaded magazine if applicable
			else
				self.reloadMag = nil; --set to ignore if not a mag or clip
			end
		end
		self.loadType = "reload";
		self:startLoading();
	end
end

function ORGMLoadManager:openSlideFromUi(item) --opens the chamber from ui
	self.loadWeapon = item;
	self.loadType = "openslide";
	self:ocSlideBoltStart();
end

function ORGMLoadManager:closeSlideFromUi(item) --closes the slide from ui
	self.loadWeapon = item;
	self.loadType = "closeslide";
	self:ocSlideBoltStart();
end

function ORGMLoadManager:openBoltFromUi(item) --open the bolt from ui
	self.loadWeapon = item;
	self.loadType = "openbolt";
	self:ocSlideBoltStart();
end

function ORGMLoadManager:closeBoltFromUi(item) --close the bolt from ui
	self.loadWeapon = item;
	self.loadType = "closebolt";
	self:ocSlideBoltStart();
end

function ORGMLoadManager:closeFromUi(item) --close for reloading from ui
	self.loadWeapon = item;
	self:startClosing();
end

function ORGMLoadManager:openFromUi(item) --open for reloading from ui
	self.loadWeapon = item;
	self:startOpening();
end

function ORGMLoadManager:startRackFromUi(item)
	self.loadWeapon = item;
	self.startRacking()
end

function ORGMLoadManager:checkLoadConditions() -- allows reloading/unloading using the keyboard
	if self:loadStarted() or self:rackingStarted() then return end --if there is already an action the keys do nothing
	local difficulty = self.getDifficulty()
	local playerObj = getSpecificPlayer(self.playerid)
	local keyboard = self.playerid == 0
	local reloadKey = keyboard and isKeyDown(Keyboard.KEY_R) --sets the reload key as R
	local reloadButton = playerObj:isLBPressed() and not getFocusForPlayer(self.playerid)
	local unloadKey = keyboard and isKeyDown(Keyboard.KEY_U) --sets the unload key as U
	if not (reloadKey or reloadButton or unloadKey) then return end
	self.loadWeapon = playerObj:getPrimaryHandItem(); --checks for a gun in the primary hand
	if self.loadWeapon == nil then --if there is nothing in the main hand it stops the script
		return;
	end
	if (reloadKey or reloadButton) then --actions if the reload key is pressed
		if self:isWeaponReloadable(self.loadWeapon) then --checks if the weapon is reloadable
			self.loadType = "reload" --sets the script to reload
			if self.loadWeapon:getModData().loadStyle == 'magfed' and difficulty ~= 1 then
				self.reloadAmmo = self:mostLoadedSearch(self.loadWeapon:getModData()).type --otherwise it looks for the most loaded magazine, or any magazine if all are empty
				self:startLoading();
			elseif self.loadWeapon:getModData().speedLoader ~= nil and self.loadWeapon:getModData().speedLoader ~= 1 and difficulty ~= 1 then
				self.reloadAmmo = self:mostLoadedClipSearch(self.loadWeapon:getModData()).type --returns the most loaded speedloader, will not return anything if they are empty
				self:startLoading();
			else
				self.reloadAmmo = self:ammoSearch(self.loadWeapon:getModData()) --returns first bit of ammo available from the list
				self:startLoading();
			end
		else
			self:stopLoad(); --kills the action otherwise
		end
	elseif (unloadKey) then --if the unload key is pressed
		if self:isWeaponUnloadable(self.loadWeapon) then --Checks if the gun has ammo to unload
			self.loadType = "unload" --sets the trigger to unloading
			self:startLoading(); --starts the unload action
		else
			self:stopLoad(); --kills the action otherwise
		end
	end
end

function ORGMLoadManager:checkRackConditions()
	if self:loadStarted() or self:rackingStarted() then return end --doesn't allow if there is an action in process
	local playerObj = getSpecificPlayer(self.playerid)
	local keyboard = self.playerid == 0
	if keyboard and isKeyDown(Keyboard.KEY_R) then return end --kills it if any other button is pressed doen
	if keyboard and isMouseButtonDown(0) then return end
	if keyboard and self:getDifficulty() == 3 and not (isKeyDown(getCore():getKey("Rack Firearm")) or playerObj:getJoypadBind() ~= -1) then return end
	self.loadWeapon = playerObj:getPrimaryHandItem(); --points to the gun in the main hand
	if self.loadWeapon == nil then --if there is nothing in the main hand it stops the script
		return;
	end
	self.loadable = ORGMLoadUtil:getLoadableWeapon(self.reloadWeapon, playerObj); --gets weapon info
	if self.loadable ~= nil and self.loadable:canRack(playerObj) then --checks to see if it is rackable
		self:startRacking(); --starts the racking script
	else
		self:stopLoad(); --kills the action otherwise
	end
end

function ORGMLoadManager:ORGMindexfinder(key, list) --A function to find the number location of a string in a table
	for i, obj in ipairs(list) do
		if obj == key then
			return i;
		end
	end
	return -1;
end

aaa.startLoadHook = function(pl) --the hook to allow key press loading
    if pl then
  	    return ORGMLoadManager:new(pl:getPlayerNum()):checkLoadConditions();
    else return ORGMLoadManager:new(0):checkLoadConditions(); end
end
Events.OnPlayerUpdate.Add(aaa.startLoadHook);

aaa.startRackingHook = function(pl) --the hook for racking
    if pl then
	    return ORGMLoadManager:new(pl:getPlayerNum()):checkRackConditions();
    else return ORGMLoadManager:new(0):checkRackConditions(); end
end
Events.OnPlayerUpdate.Add(aaa.startRackingHook);

aaa.fireShotHook = function(wielder, weapon) --the hook for firing scripts
	return ORGMLoadManager:new(pl:getPlayerNum()):fireShot(wielder, weapon);
end
Events.OnWeaponSwingHitPoint.Add(aaa.fireShotHook);

aaa.checkLoadedHook = function(character, chargeDelta) --the hook for checking load
	return ORGMLoadManager:new(pl:getPlayerNum()):checkLoaded(character, chargeDelta);
end
Hook.Attack.Add(aaa.checkLoadedHook);