require "ISBaseObject"

ORGMMagazine = ISBaseObject:derive("ORGMMagazine");

function ORGMMagazine:initialise()

end

function ORGMMagazine:new()
	local o = {}
	setmetatable(o, self);
	self.__index = self;
	return o;
end

function ORGMMagazine:isLoaded()
	return false;
end

function ORGMMagazine:fireShot()
	-- do nothing
end

function ORGMMagazine:canReload(chr)
	if(self.currentCapacity < self.maxCapacity
	and chr:getInventory():FindAndReturn(self.ammoType) ~= nil) then
		return true;
	end
	return false;
end


function ORGMMagazine:canUnload(chr)
	if self.currentCapacity > 0 then
		return true;
	end
	return false;
end

function ORGMMagazine:isReloadValid(char, square, difficulty)
	if(self.currentCapacity < self.maxCapacity
		and char:getInventory():FindAndReturn(self.ammoType) ~= nil) then
			return true;
	end
	self.reloadInProgress = false;
	return false;
end

function ORGMMagazine:isUnloadValid(char, square, difficulty)
	if self.currentCapacity > 0 then
		return true;
	end
	self.unloadInProgress = false;
	return false;
end

function ORGMMagazine:reloadStart(char, square, difficulty)
	self.reloadInProgress = true;
end

function ORGMMagazine:unloadStart(char, square, difficulty)
	self.unloadInProgress = true;
end

function ORGMMagazine:reloadPerform(char, square, difficulty, magazine)
	getSoundManager():PlayWorldSound(self.insertSound, char:getSquare(), 0, 10, 1.0, false);
	self.currentCapacity = self.currentCapacity + 1;
	-- remove the necessary ammo
	char:getInventory():RemoveOneOf(self.ammoType);
	self.reloadInProgress = false;
	self:syncReloadableToItem(magazine);
	char:getXp():AddXP(Perks.Reloading, 1);
	if(self.currentCapacity == self.maxCapacity) then
		return false;
	end
	return true;
end

function ORGMMagazine:unloadPerform(char, square, difficulty, magazine)
	getSoundManager():PlayWorldSound(self.insertSound, char:getSquare(), 0, 10, 1.0, false);
	self.currentCapacity = self.currentCapacity - 1;
	char:getInventory():AddItem('ORGM.'..self.ammoType);
	self.unloadInProgress = false;
	self:syncReloadableToItem(magazine);
	char:getXp():AddXP(Perks.Reloading, 1);
	if(self.currentCapacity == 0) then
		return false;
	end
	return true;
end

function ORGMMagazine:getReloadText()
	return "Reload";
end

function ORGMMagazine:isChainReloading()
	return true;
end

function ORGMMagazine:isChainUnloading()
	return true;
end

function ORGMMagazine:getReloadTime()
	return self.reloadTime;
end

function ORGMMagazine:canRack(chr)
	return false;
end

function ORGMMagazine:rackingStart(char, square, weapon)
    getSoundManager():PlayWorldSound(self.rackSound, char:getSquare(), 0, 10, 1.0, false);
end

function ORGMMagazine:rackingPerform(char, square, weapon)
    if(self.currentCapacity > 0) then
        self.currentCapacity = self.currentCapacity - 1;
        char:getInventory():AddItem('ORGM.'..self.ammoType);
        ISInventoryPage.dirtyUI();
	    self:syncReloadableToItem(weapon);
	end
end

function ORGMMagazine:getRackTime()
	return self.rackTime;
end

function ORGMMagazine:syncItemToReloadable(item)
	local modData = item:getModData();
	if(modData.reloadClass ~= nil) then
		self.type = modData.type or item:getType();
		self.moduleName = modData.moduleName
		if(self.moduleName == nil) then
			self.moduleName = 'Base'
		end
		self.reloadClass = modData.reloadClass;
		self.ammoType = modData.ammoType;
		self.loadStyle = modData.reloadStyle;
		self.ejectSound = modData.ejectSound;
		self.clickSound = modData.clickSound;
		self.insertSound = modData.insertSound;
		self.rackSound = modData.rackSound;
		self.maxCapacity = modData.maxCapacity or item:getClipSize();
		self.reloadTime = modData.reloadTime or item:getReloadTime();
		self.rackTime = modData.rackTime;
		self.currentCapacity = modData.currentCapacity;
		self.clipType = modData.clipType;
--		self.reloadText = modData.reloadText;
	end
end

function ORGMMagazine:syncReloadableToItem(item)
	local modData = item:getModData();
	modData.type = self.type;
	modData.currentCapacity = self.currentCapacity;
end

function ORGMMagazine:setupReloadable(item, v)
	local modData = item:getModData();
	modData.type = v.type;
	modData.moduleName = v.moduleName;
	modData.reloadClass = v.reloadClass;
	modData.ammoType = v.ammoType;
	modData.loadStyle = v.reloadStyle;
	modData.ejectSound = v.ejectSound;
	modData.clickSound = v.clickSound;
	modData.insertSound = v.insertSound;
	modData.rackSound = v.rackSound;
	modData.maxCapacity = v.maxCapacity or item:getClipSize();
	modData.reloadTime = v.reloadTime or item:getReloadTime();
	modData.rackTime = v.rackTime;
	modData.currentCapacity = 0;
	modData.clipType = v.clipType;
--	modData.reloadText = v.reloadText;
end

function ORGMMagazine:printItemDetails(item)
    print('***************************************************************');
    print('Weapon state:');
    print('***************************************************************');
    local modData = item:getModData();
    local outString  = '';
        if(modData.type ~= nil) then
            outString = outString..', type: '..modData.type;
        else
            outString = outString..', type == nil';
        end
        if(modData.reloadClass ~= nil) then
            outString = outString..', reloadClass: '..modData.reloadClass;
        else
            outString = outString..', reloadClass == nil';
        end
		if(modData.ammoType ~= nil) then
            outString = outString..', ammoType: '..modData.ammoType;
        else
            outString = outString..', ammoType == nil';
        end
        if(modData.loadStyle ~= nil) then
            outString = outString..', loadStyle: '..modData.loadStyle;
        else
            outString = outString..', loadStyle == nil';
        end
        if(modData.ejectSound ~= nil) then
            outString = outString..', ejectSound: '..modData.ejectSound;
        else
            outString = outString..', ejectSound == nil';
        end
		if(modData.clickSound ~= nil) then
            outString = outString..', clickSound: '..modData.clickSound;
        else
            outString = outString..', clickSound == nil';
        end
        if(modData.insertSound ~= nil) then
            outString = outString..', insertSound: '..modData.insertSound;
        else
            outString = outString..', insertSound == nil';
        end
        if(modData.rackSound ~= nil) then
            outString = outString..', rackSound: '..modData.rackSound;
        else
            outString = outString..', rackSound == nil';
        end
        if(modData.maxCapacity ~= nil) then
            outString = outString..', maxCapacity: '..modData.maxCapacity;
        else
            outString = outString..', maxCapacity == nil';
        end
        if(modData.reloadTime ~= nil) then
            outString = outString..', reloadTime: '..modData.reloadTime;
        else
            outString = outString..', reloadTime == nil';
        end
        if(modData.rackTime ~= nil) then
            outString = outString..', rackTime: '..modData.rackTime;
        else
            outString = outString..', rackTime == nil';
        end
        if(modData.currentCapacity ~= nil) then
            outString = outString..', currentCapacity: '..modData.currentCapacity;
        else
            outString = outString..', currentCapacity == nil';
        end
        if(modData.reloadText ~= nil) then
            outString = outString..', reloadText: '..modData.reloadText;
        else
            outString = outString..', reloadText == nil';
        end
        print(outString);
end

function ORGMMagazine:printReloadableDetails()
print('***************************************************************');
    print('Reloadable state');
    print('***************************************************************');
        local outString  = '';
        if(self.type ~= nil) then
            outString = outString..', type: '..self.type;
        else
            outString = outString..', type == nil';
        end
        if(self.reloadClass ~= nil) then
            outString = outString..', reloadClass: '..self.reloadClass;
        else
            outString = outString..', reloadClass == nil';
        end
		if(self.ammoType ~= nil) then
            outString = outString..', ammoType: '..self.ammoType;
        else
            outString = outString..', ammoType == nil';
        end
        if(self.loadStyle ~= nil) then
            outString = outString..', loadStyle: '..self.loadStyle;
        else
            outString = outString..', loadStyle == nil';
        end
        if(self.ejectSound ~= nil) then
            outString = outString..', ejectSound: '..self.ejectSound;
        else
            outString = outString..', ejectSound == nil';
        end
		if(self.clickSound ~= nil) then
            outString = outString..', clickSound: '..self.clickSound;
        else
            outString = outString..', clickSound == nil';
        end
        if(self.insertSound ~= nil) then
            outString = outString..', insertSound: '..self.insertSound;
        else
            outString = outString..', insertSound == nil';
        end
        if(self.rackSound ~= nil) then
            outString = outString..', rackSound: '..self.rackSound;
        else
            outString = outString..', rackSound == nil';
        end
        if(self.maxCapacity ~= nil) then
            outString = outString..', maxCapacity: '..self.maxCapacity;
        else
            outString = outString..', maxCapacity == nil';
        end
        if(self.reloadTime ~= nil) then
            outString = outString..', reloadTime: '..self.reloadTime;
        else
            outString = outString..', reloadTime == nil';
        end
        if(self.rackTime ~= nil) then
            outString = outString..', rackTime: '..self.rackTime;
        else
            outString = outString..', rackTime == nil';
        end
        if(self.currentCapacity ~= nil) then
            outString = outString..', currentCapacity: '..self.currentCapacity;
        else
            outString = outString..', currentCapacity == nil';
        end
        if(self.reloadText ~= nil) then
            outString = outString..', reloadText: '..self.reloadText;
        else
            outString = outString..', reloadText == nil';
        end
        print(outString);
end
