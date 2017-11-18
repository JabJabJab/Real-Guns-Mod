--[[
    TODO: document this file
]]

require "ISBaseObject"

ISORGMMagazine = ISBaseObject:derive("ISORGMMagazine")

function ISORGMMagazine:initialise()

end

function ISORGMMagazine:new()
    local o = {}
    setmetatable(o, self);
    self.__index = self;
    return o;
end

function ISORGMMagazine:isLoaded()
    return false
end

function ISORGMMagazine:fireShot()
    -- do nothing
end

---------------------------------------------------------------------------
---------------------------------------------------------------------------
---------------------------------------------------------------------------
--      Reloading functions

function ISORGMMagazine:canReload(char)
    if (self.currentCapacity < self.maxCapacity and self:findBestAmmo(char) ~= nil) then return true end
    return false
end


function ISORGMMagazine:isReloadValid(char, square, difficulty)
    if (self.currentCapacity < self.maxCapacity and self:findBestAmmo(char) ~= nil) then
        return true
    end
    self.reloadInProgress = false
    return false
end

function ISORGMMagazine:reloadStart(char, square, difficulty)
    self.reloadInProgress = true
end

function ISORGMMagazine:reloadPerform(char, square, difficulty, magazine)
    getSoundManager():PlayWorldSound(self.insertSound, char:getSquare(), 0, 10, 1.0, false)
    local round = self:findBestAmmo(char):getType()
    
    self.currentCapacity = self.currentCapacity + 1
    self.magazineData[self.currentCapacity] = round
    -- check if this round matches other rounds player loaded
    if self.loadedAmmo == nil then
        self.loadedAmmo = round
        --magazine:setAmmoType(round)
    elseif self.loadedAmmo ~= round then
        self.loadedAmmo = 'mixed'
        --magazine:setAmmoType(magazine:getModData().defaultAmmo)
    end
    -- remove the necessary ammo
    char:getInventory():RemoveOneOf(round)
    self.reloadInProgress = false
    self:syncReloadableToItem(magazine)
    char:getXp():AddXP(Perks.Reloading, 1)
    if(self.currentCapacity == self.maxCapacity) then
        return false
    end
    return true
end

function ISORGMMagazine:isChainReloading()
    return true
end

function ISORGMMagazine:getReloadText()
    return "Reload"
end

function ISORGMMagazine:getReloadTime()
    return self.reloadTime
end



---------------------------------------------------------------------------
---------------------------------------------------------------------------
---------------------------------------------------------------------------
--      Unloading functions

function ISORGMMagazine:canUnload(chr)
    if self.currentCapacity > 0 then
        return true
    end
    return false
end

function ISORGMMagazine:isUnloadValid(char, square, difficulty)
    if self.currentCapacity > 0 then
        return true
    end
    self.unloadInProgress = false
    return false
end

function ISORGMMagazine:unloadStart(char, square, difficulty)
    self.unloadInProgress = true
end

function ISORGMMagazine:unloadPerform(char, square, difficulty, magazine)
    getSoundManager():PlayWorldSound(self.insertSound, char:getSquare(), 0, 10, 1.0, false)
    local round = self.magazineData[self.currentCapacity]
    -- remove last entry from data table (Note: using #table to find the length is slow)
    self.magazineData[self.currentCapacity] = nil 
    self.currentCapacity = self.currentCapacity - 1
    char:getInventory():AddItem('ORGM.'.. round)
    ISInventoryPage.dirtyUI()
    self.unloadInProgress = false
    char:getXp():AddXP(Perks.Reloading, 1)
    if(self.currentCapacity == 0) then
        self.loadedAmmo = nil
        --magazine:setAmmoType(magazine:getModData().defaultAmmo)
        self:syncReloadableToItem(magazine)
        return false
    end
    self:syncReloadableToItem(magazine)
    return true
end

function ISORGMMagazine:isChainUnloading()
    return true
end

---------------------------------------------------------------------------
---------------------------------------------------------------------------
---------------------------------------------------------------------------
--      Racking functions

function ISORGMMagazine:canRack(chr)
    return false
end

function ISORGMMagazine:rackingStart(char, square, weapon)
    getSoundManager():PlayWorldSound(self.rackSound, char:getSquare(), 0, 10, 1.0, false)
end

function ISORGMMagazine:rackingPerform(char, square, weapon)
    -- do nothing
end

function ISORGMMagazine:getRackTime()
    return self.rackTime
end


---------------------------------------------------------------------------
---------------------------------------------------------------------------
---------------------------------------------------------------------------
--      Misc functions

function ISORGMMagazine:findBestAmmo(char)
    --print("findBestAmmo()")
    if self.preferredAmmoType ~= nil and self.preferredAmmoType ~= "any" and self.preferredAmmoType ~= 'mixed' then
        -- a preferred ammo is set, we only look for these bullets
        --print("looking for preferred ".. self.preferredAmmoType)
        return char:getInventory():FindAndReturn(self.preferredAmmoType)
    end
    local round = char:getInventory():FindAndReturn(self.ammoType) -- this shouldn't actually be here, self.ammoType is just a dummy round
    if round then return round end
    -- check if there are alternate ammo types we can use
    local roundTable = ORGMAlternateAmmoTable[self.ammoType]
    if roundTable == nil then
        --print("NO ROUND TABLE for " .. self.ammoType)
        return nil 
    end -- there should always be a entry
    if self.preferredAmmoType == 'mixed' then
        --print("mixed preference")
        local options = {}
        for _, value in ipairs(roundTable) do
            -- check what rounds the player has
            if char:getInventory():FindAndReturn(value) then table.insert(options, value) end
        end
        -- randomly pick one
        return char:getInventory():FindAndReturn(options[ZombRand(#options) + 1])
        
    else -- not a random picking, go through the list in order
        for _, value in ipairs(roundTable) do
            --print("checking for " .. value)
            round = char:getInventory():FindAndReturn(value)
            if round then return round end
        end
    end
    if round then return round end
    --print("NO AMMO!!!")
    return nil
end

function ISORGMMagazine:syncItemToReloadable(item)
    local modData = item:getModData()
    if(modData.reloadClass ~= nil) then
        self.type = modData.type or item:getType()
        self.moduleName = modData.moduleName
        if(self.moduleName == nil) then
            self.moduleName = 'Base'
        end
        self.reloadClass = modData.reloadClass
        self.ammoType = modData.ammoType
        self.loadStyle = modData.reloadStyle
        self.ejectSound = modData.ejectSound
        self.clickSound = modData.clickSound
        self.insertSound = modData.insertSound
        self.rackSound = modData.rackSound
        self.maxCapacity = modData.maxCapacity or item:getClipSize()
        self.reloadTime = modData.reloadTime or item:getReloadTime()
        self.rackTime = modData.rackTime
        self.currentCapacity = modData.currentCapacity
        self.clipType = modData.clipType
        self.magazineData = modData.magazineData
        self.preferredAmmoType = modData.preferredAmmoType
        self.loadedAmmo = modData.loadedAmmo
--      self.reloadText = modData.reloadText;
    end
end

function ISORGMMagazine:syncReloadableToItem(item)
    local modData = item:getModData()
    modData.type = self.type
    modData.currentCapacity = self.currentCapacity
    modData.magazineData = self.magazineData
    modData.preferredAmmoType = self.preferredAmmoType
    modData.loadedAmmo = self.loadedAmmo
end

function ISORGMMagazine:setupReloadable(item, v)
    local modData = item:getModData()
    --modData.defaultAmmo = item:getAmmoType()
    modData.type = v.type
    modData.moduleName = v.moduleName
    modData.reloadClass = v.reloadClass
    modData.ammoType = v.ammoType
    modData.loadStyle = v.reloadStyle
    modData.ejectSound = v.ejectSound
    modData.clickSound = v.clickSound
    modData.insertSound = v.insertSound
    modData.rackSound = v.rackSound;
    modData.maxCapacity = v.maxCapacity or item:getClipSize()
    modData.reloadTime = v.reloadTime or item:getReloadTime()
    modData.rackTime = v.rackTime
    modData.currentCapacity = 0
    modData.clipType = v.clipType
    modData.magazineData = { }
    modData.preferredAmmoType = 'any'
    modData.loadedAmmo = nil
--  modData.reloadText = v.reloadText;
end

function ISORGMMagazine:printItemDetails(item)
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

function ISORGMMagazine:printReloadableDetails()
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
