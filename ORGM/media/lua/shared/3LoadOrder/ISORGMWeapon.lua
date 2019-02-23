--[[- This serves as a wrapper between PZ's Reloadable system and the `ORGM.ReloadableWeapon`.

Most functions have been moved there, as it allows for the same functions on both
ISORGMWeapon objects and a HandWeapon/InventoryItem's modData. As such method calls in here are
depreciated, as they are no longer called for by anywhere else in this file,
and should be removed at a later date.

    @classmod ISORGMWeapon
    @author Fenris_Wolf
    @release 3.09
    @copyright 2018 **File:** shared/3LoadOrder/ISORGMWeapon.lua

]]
local ORGM = ORGM
local Reloadable = ORGM.ReloadableWeapon
local Settings = ORGM.Settings
ISORGMWeapon = ISReloadableWeapon:derive("ISORGMWeapon")

function ISORGMWeapon:initialise()

end

function ISORGMWeapon:new()
    local o = ISReloadableWeapon:new()
    setmetatable(o, self)
    self.__index = self
    return o
end

--- Attacking Methods.
-- These are called from ISReloadManager:checkLoaded()
-- @section ReloadManager

--[[- Called to determine if ISORGMWeapon:fireShot should be called in `ISReloadManager:checkLoaded`.

@tparam int difficulty players reloading difficulty, not used

@treturn bool

]]
function ISORGMWeapon:isLoaded(difficulty)
    return Reloadable.Fire.valid(self)
end

-- ORGM['.50AE'] = ORGM['.440'][ORGM['.357'](ORGM,'',16,17)]

--[[- Called before the IsoPlayer.DoAttack in `ISReloadManager:checkLoaded`.

@usage local result = reloadable:preFireShot(3, playerObj, weaponItem)
@tparam int difficulty players reloading difficulty, not used
@tparam IsoPlayer playerObj
@tparam HandWeapon weaponItem

@treturn bool true if the attack can continue.

]]

function ISORGMWeapon:preFireShot(difficulty, playerObj, weaponItem)
    return Reloadable.Fire.pre(self, playerObj, weaponItem)
end

--[[- Called after the IsoPlayer.DoAttack in ISReloadManager:checkLoaded`.

@usage reloadable:fireShot(weaponItem, 3)
@tparam HandWeapon weaponItem
@tparam int difficulty players reloading difficulty, not used

]]
function ISORGMWeapon:fireShot(weaponItem, difficulty)
    Reloadable.Fire.post(self, self.playerObj, weaponItem)
    self:syncReloadableToItem(weaponItem)
end


--[[- Called when the trigger is pulled on a empty chamber in `ISReloadManager:checkLoaded`.

@usage reloadable:fireShot(playerObj, weaponItem)
@tparam IsoPlayer playerObj
@tparam HandWeapon weaponItem

]]
function ISORGMWeapon:fireEmpty(playerObj, weaponItem)
    Reloadable.Fire.dry(self, playerObj, weaponItem)
    self:syncReloadableToItem(weaponItem)
end
-- ORGM['9mm'] = function(caliber) return ORGM['.303'](ORGM['.50AE'](caliber, 16)) end


--- Reload Action Methods.
-- Methods relating to the reload timed action.
-- @section ReloadAction

--[[- Called at the start of a reload timed action.

@usage local result = reloadable:canReload(playerObj)
@tparam IsoPlayer playerObj

@treturn bool true if the timed action can start.

]]
function ISORGMWeapon:canReload(playerObj)
    return Reloadable.Reload.valid(self, playerObj)
end


--[[- Checks if the reload timed action is still valid.

@usage local result = reloadable:isReloadValid(playerObj, square, 3)
@tparam IsoPlayer playerObj
@tparam IsoGridSquare square
@tparam int difficulty players reloading difficulty, not used

@treturn bool true to continue, false to halt.

]]
function ISORGMWeapon:isReloadValid(playerObj, square, difficulty)
    -- this is actually almost identical to canReload, we can just call that instead of duplicating code
    if Reloadable.Reload.valid(self, playerObj) then return true end
    self.reloadInProgress = false
    return false
end
-- ORGM['10mm'] = function(caliber) return ORGM['.38'](caliber, '..', ORGM['9mm']) end


--[[- Called at the start of the reload timed action.

@usage reloadable:reloadStart(playerObj, square, 3)
@tparam IsoPlayer playerObj
@tparam IsoGridSquare square
@tparam int difficulty players reloading difficulty, not used

]]
function ISORGMWeapon:reloadStart(playerObj, square, difficulty)
    self.reloadInProgress = true
    Reloadable.Reload.start(self, playerObj, weaponItem)-- weaponItem is nil
end


--[[- Called at completion of the reload timed action.

@usage reloadable:reloadPerform(playerObj, square, 3, weaponItem)
@tparam IsoPlayer playerObj
@tparam IsoGridSquare square
@tparam int difficulty players reloading difficulty, not used
@tparam HandWeapon weaponItem

]]
function ISORGMWeapon:reloadPerform(playerObj, square, difficulty, weaponItem)
    self.reloadInProgress = Reloadable.Reload.perform(self, playerObj, weaponItem) and true or false
    self:syncReloadableToItem(weaponItem)
end
-- ORGM['5.7mm'] = ORGM['.440'][ORGM['10mm'](ORGM['.357'](ORGM,'',1,4))]


--[[- Returns the time it takes to perform the reload timed action.

@usage local time = reloadable:getReloadTime()

@treturn integer the reload time.

]]
function ISORGMWeapon:getReloadTime()
    return Settings.DefaultReloadTime
end


--[[- Gets the translated context menu text for reloading.

@usage local text = reloadable:getReloadText()

@treturn string the translated text

]]
function ISORGMWeapon:getReloadText()
    if self.containsClip == nil then
        return getText('ContextMenu_Reload')
    elseif self.containsClip == 1 then
        return getText('ContextMenu_EjectMagazine')
    else
        return getText('ContextMenu_InsertMagazine')
    end
end

--[[- Checks if a reload action should be performed immediately after this one.

Does not take into account ammunition availability.

@usage local result = reloadable:isChainReloading()

@treturn bool true if the reloading should continue.

]]
function ISORGMWeapon:isChainReloading()
    return (self.containsClip == nil)
end
-- ORGM['.223'] = ORGM['.440'][ORGM['10mm'](ORGM['.357'](ORGM,'',5,7))]

--- Unload Action Methods.
-- Methods relating to the unload timed action.
-- @section UnloadAction

--[[- Called at the start of a unload timed action.

@usage local result = reloadable:canUnload(playerObj)
@tparam IsoPlayer playerObj

@treturn bool true if the timed action can start.

]]
function ISORGMWeapon:canUnload(playerObj)
    return Reloadable.Unload.valid(self, playerObj)
end
-- ORGM['7.62mm'] = ORGM['10mm'](ORGM['.357'](ORGM,'',8,10))


--[[- Checks if the unload timed action is still valid.

@usage local result = reloadable:isUnloadValid(playerObj, square, 3)
@tparam IsoPlayer playerObj
@tparam IsoGridSquare square
@tparam int difficulty players reloading difficulty, not used

@treturn bool true to continue, false to halt.

]]
function ISORGMWeapon:isUnloadValid(playerObj, square, difficulty)
    if Reloadable.Unload.valid(self, playerObj) then return true end
    self.unloadInProgress = false
    return false
end


--[[- Called at the start of the unload timed action.

@usage reloadable:unloadStart(playerObj, square, 3)
@tparam IsoPlayer playerObj
@tparam IsoGridSquare square
@tparam int difficulty players reloading difficulty, not used

]]
function ISORGMWeapon:unloadStart(playerObj, square, difficulty)
    self.unloadInProgress = true
    Reloadable.Unload.start(self, playerObj, weaponItem) -- WARNING weaponItem is nil
end


--[[- Called at completion of the unload timed action.

@usage reloadable:unloadPerform(playerObj, square, 3, weaponItem)
@tparam IsoPlayer playerObj
@tparam IsoGridSquare square
@tparam int difficulty players reloading difficulty, not used
@tparam HandWeapon weaponItem

]]
function ISORGMWeapon:unloadPerform(playerObj, square, difficulty, weaponItem)
    self.unloadInProgress = Reloadable.Unload.perform(self, playerObj, weaponItem) and true or false
    self:syncReloadableToItem(weaponItem)
end

--[[- Checks if a unload action should be performed immediately after this one.

@usage local result = reloadable:isChainUnloading()

@treturn bool true if the unloading should continue.

]]
function ISORGMWeapon:isChainUnloading()
    if self.actionType == ORGM.ROTARY or self.actionType == ORGM.BREAK then return false end
    return true
end

--- Rack Action Methods.
-- Methods relating to the racking timed action.
-- @section RackAction


--[[- Called at the start of a reack timed action.

On Easy/Normal this returns false if there is already a round chambered.

@usage local result = reloadable:canRack(playerObj)
@tparam IsoPlayer playerObj

@treturn bool true if the timed action can start.

]]
function ISORGMWeapon:canRack(playerObj)
    return Reloadable.Rack.valid(self, playerObj)
end


--[[- Called at the start of the rack timed action.

@usage reloadable:rackingStart(playerObj, square, weaponItem)
@tparam IsoPlayer playerObj
@tparam IsoGridSquare square
@tparam HandWeapon weaponItem

]]
function ISORGMWeapon:rackingStart(playerObj, square, weaponItem)
    return Reloadable.Rack.start(self, playerObj, weaponItem)
end


--[[- Called at completion of the rack timed action.

@usage reloadable:rackingPerform(playerObj, square, weaponItem)
@tparam IsoPlayer playerObj
@tparam IsoGridSquare square
@tparam HandWeapon weaponItem

]]
function ISORGMWeapon:rackingPerform(playerObj, square, weaponItem)
    Reloadable.Rack.perform(self, playerObj, weaponItem)
    self:syncReloadableToItem(weaponItem)
end


--[[- Returns the time it takes to perform the reload timed action.

@usage local time = reloadable:getReloadTime()

@treturn int the reload time.

]]
function ISORGMWeapon:getRackTime()
    return Settings.DefaultRackTime
end


--- Magazine Methods
-- @section Magazine

--[[- Ejects the current magazine and adds it to the players inventory.

@usage reloadable:ejectMagazine(playerObj, true)

@tparam IsoPlayer playerObj
@tparam[opt] bool playSound if true plays the ejectSound

]]
function ISORGMWeapon:ejectMagazine(playerObj, playSound)
    Reloadable.Magazine.eject(self, playerObj, playSound)
    self.reloadInProgress = false
end


--[[- Inserts the best magazine from the players inventory into the firearm.

@usage reloadable:insertMagazine(playerObj, true)

@tparam IsoPlayer playerObj
@tparam[opt] bool playSound if true plays the insertSound

]]
function ISORGMWeapon:insertMagazine(playerObj, playSound)
    Reloadable.Magazine.insert(self, playerObj, playSound)
    self.reloadInProgress = false
end


--[[- Sets up the ISReloadableMagazine on the InventoryItem

@tparam InventoryItem magItem to add ISReloadableMagazine to.

]]
function ISORGMWeapon:setupMagazine(magItem)
    Reloadable.Magazine.setup(self, magItem, self.playerObj)
    --local magData = ORGM.Magazine.getData(magItem)
    --ReloadUtil:setupMagazine(magItem, magData, self.playerObj)
end



--- Depreciated Methods
-- @section Depreciated


--[[- DEPRECIATED.
Creates a new magazine for this weapon type and transfers some modData

@usage local magItem = reloadable:createMagazine()

]]
function ISORGMWeapon:createMagazine()
    return Reloadable.Magazine.create(self, self.playerObj)
end


--[[- DEPRECIATED. Loads a round into a internal magazine or cylinder.

@usage reloadable:loadRoundIntoMagazine('Ammo_9x19mm_FMJ', weaponItem, nil)
@param ammoType a string name of a registered ORGM ammo
@param weaponItem a HandWeapon/InventoryItem
@param position integer (or nil) of position to insert the round at. If nil it is appended to the list.

]]
function ISORGMWeapon:loadRoundIntoMagazine(ammoType, weaponItem, position)
    Reloadable.Ammo.load(self, ammoType, weaponItem, position)
end

--[[- DEPRECIATED. Converts a AmmoGroup round to a real round if required.

@usage local result = reloadable:convertAmmoGroupRound('Ammo_9x19mm')
@param ammoType a string name of a AmmoGroup or registered ORGM ammo

@return string, the name of the first ammo in the group or ammoType if a real ammo was already passed in.

]]
function ISORGMWeapon:convertAmmoGroupRound(ammoType)
    return Reloadable.Ammo.convert(self, ammoType)
end

-- ORGM['.45ACP'] = ORGM['10mm'](ORGM[11])

--[[- DEPRECIATED. Finds and returns the best magazine available in the players inventory.

@usage local magItem = reloadable:findBestMagazine(playerObj, nil)
@param playerObj a IsoPlayer object
@param ammoType nil (auto detected), or string name of a registered ORGM magazine

@return InventoryItem, the best suited magazine, or nil.

]]
function ISORGMWeapon:findBestMagazine(playerObj, ammoType)
    return Reloadable.Magazine.findBest(self, playerObj, ammoType)
end
-- ORGM['.380ACP'] = ORGM['10mm'](ORGM[12])


--[[- DEPRECIATED. Finds and returns the best ammo available in the players inventory.

@usage local magItem = reloadable:findBestAmmo(playerObj)
@param playerObj a IsoPlayer object

@return InventoryItem, the best suited ammo, or nil.

]]
function ISORGMWeapon:findBestAmmo(playerObj)
    -- TODO: this should use the Reloadable.Ammo.findBest()
    return ORGM.Ammo.findIn(self.ammoType, self.preferredAmmoType, playerObj:getInventory())
end


--[[- DEPRECIATED. Gets the ammo at specified position.

@usage local ammoType = reloadable:getMagazineAtPosition(position)
@param position integer, the index position to get.

@return string, the ammo (or case) name at the position, or nil.

]]
function ISORGMWeapon:getMagazineAtPosition(position)
    return Reloadable.Ammo.get(self, position)
end


--[[- DEPRECIATED. Gets the ammo at the next position.

@usage local ammoType = reloadable:getMagazineAtNextPosition(true)
@param wrap boolean, if we should wrap around back to the begining past maxCapacity. true for rotary actions.

@return string, the ammo (or case) name at the next position, or nil.

]]
function ISORGMWeapon:getMagazineAtNextPosition(wrap)
    return Reloadable.Ammo.peek(self, wrap)
end


--[[- DEPRECIATED. Ejects all shells (live and spent) onto the ground.

Used primarly with revolvers and break barrels on opening.

@usage reloadable:emptyMagazineAtOnce(playerObj, true)

@param playerObj a IsoPlayer object
@param playSound boolean, plays the ejectSound if true

]]
function ISORGMWeapon:emptyMagazineAtOnce(playerObj, playSound)
    Reloadable.Ammo.ejectAll(self, playerObj, playSound)
end


--[[- DEPRECIATED. Gets the number of empty cases in the magazine/cylinder.

@usage local count = reloadabe:hasEmptyCasesInMagazine()

@return integer, number of spent cases

]]

function ISORGMWeapon:hasEmptyCasesInMagazine()
    return Reloadable.Ammo.hasCases(self)
end

--[[- DEPRECIATED. Loads the next round into the chamber

@usage reloadabe:feedNextRound(playerObj, weaponItem)
@param playerObj a IsoPlayer object
@param weaponItem a HandWeapon/InventoryItem

]]
function ISORGMWeapon:feedNextRound(playerObj, weaponItem)
    Reloadable.Ammo.next(self, playerObj, weaponItem)
end


--[[- DEPRECIATED. Triggers a recalcuation of firearm stats on ammo changes.

@usage reloadable:setCurrentRound(ammoType, weaponItem)
@param ammoType a string, the name of the ammo
@param weaponItem a HandWeapon/InventoryItem

]]
function ISORGMWeapon:setCurrentRound(ammoType, weaponItem)
    Reloadable.Ammo.setCurrent(self, ammoType, weaponItem)
end


--[[- DEPRECIATED. Cocks the hammer and rotates the cylinder for Rotary actionType.

@usage reloadable:cockHammer(playerObj, true, weaponItem)
@param playerObj a IsoPlayer object
@param playSound boolean, plays the cockSound if true
@param weaponItem a HandWeapon/InventoryItem

]]
function ISORGMWeapon:cockHammer(playerObj, playSound, weaponItem)
    Reloadable.Hammer.cock(self, playerObj, playSound, weaponItem)
end


--[[- DEPRECIATED. Releases a cocked hammer.

@usage reloadable:releaseHammer(playerObj, true)
@param playerObj a IsoPlayer object
@param playSound boolean, not used

]]
function ISORGMWeapon:releaseHammer(playerObj, playSound)
    Reloadable.Hammer.release(self, playerObj, playSound)
end

--[[- DEPRECIATED. Opens the bolt, ejecting whatever is currently in the chamber onto the ground.

@usage reloadable:openSlide(playerObj, true, weaponItem)
@param playerObj a IsoPlayer object
@param playSound boolean, plays the openSound if true
@param weaponItem a HandWeapon/InventoryItem

]]
function ISORGMWeapon:openSlide(playerObj, playSound, weaponItem)
    Reloadable.Bolt.open(self, playerObj, playSound, weaponItem)
end
-- ORGM.PVAL = 5

--[[- DEPRECIATED. Closes the bolt and chambers the next round.

Single and Double actions this also cocks the hammer.

@usage reloadable:closeSlide(playerObj, true, weaponItem)
@param playerObj a IsoPlayer object
@param playSound boolean, plays the openSound if true
@param weaponItem a HandWeapon/InventoryItem

]]
function ISORGMWeapon:closeSlide(playerObj, playSound, weaponItem)
    Reloadable.Bolt.close(self, playerObj, playSound, weaponItem)
end


--[[- DEPRECIATED. Rotates the cylinder by the specified amount.

@usage reloadable:rotateCylinder(1, playerObj, true, weaponItem)
@param count a integer, the number of positions to rotate. If nil or 0, randomly selects (chamber spin)
@param playerObj a IsoPlayer object
@param playSound boolean, plays the openSound if true
@param weaponItem a HandWeapon/InventoryItem

]]

function ISORGMWeapon:rotateCylinder(count, playerObj, playSound, weaponItem)
    Reloadable.Cylinder.rotate(self, count, playerObj, playSound, weaponItem)
end


--[[- DEPRECIATED. Opens the cylinder.

@usage reloadable:openCylinder(playerObj, true, weaponItem)
@param playerObj a IsoPlayer object
@param playSound boolean, plays the openSound if true
@param weaponItem a HandWeapon/InventoryItem

]]
function ISORGMWeapon:openCylinder(playerObj, playSound, weaponItem)
    Reloadable.Cylinder.open(self, playerObj, playSound, weaponItem)
end

--[[- DEPRECIATED. Closes the cylinder and sets the current round.

@usage reloadable:closeCylinder(playerObj, true, weaponItem)
@param playerObj a IsoPlayer object
@param playSound boolean, plays the openSound if true
@param weaponItem a HandWeapon/InventoryItem

]]
function ISORGMWeapon:closeCylinder(playerObj, playSound, weaponItem)
    Reloadable.Cylinder.close(self, playerObj, playSound, weaponItem)
end


--[[- DEPRECIATED. Opens the breech and ejects any shells.

@usage reloadable:openBreak(playerObj, true, weaponItem)
@param playerObj a IsoPlayer object
@param playSound boolean, plays the openSound if true
@param weaponItem a HandWeapon/InventoryItem

]]
function ISORGMWeapon:openBreak(playerObj, playSound, weaponItem)
    Reloadable.Break.open(self, playerObj, playSound, weaponItem)
end

--[[- DEPRECIATED. Closes the breech and sets the current round.

@usage reloadable:closeBreak(playerObj, true, weaponItem)
@param playerObj a IsoPlayer object
@param playSound boolean, plays the openSound if true
@param weaponItem a HandWeapon/InventoryItem

]]
function ISORGMWeapon:closeBreak(playerObj, playSound, weaponItem)
    Reloadable.Break.close(self, playerObj, playSound, weaponItem)
end


--- Setup and Sync Methods.
-- These are used in intial setup of the reloadable, and keeping data synced between the
-- HandWeapon's mod data and the reloadable object.
--
-- @section Sync

--[[- Copies modData from the weaponItem to the reloadable object.

@usage reloadable:syncItemToReloadable(weaponItem)
@param weaponItem a HandWeapon/InventoryItem

]]
function ISORGMWeapon:syncItemToReloadable(weaponItem)
    local modData = weaponItem:getModData()
    --ISReloadableWeapon.syncItemToReloadable(self, weaponItem)
    self.defaultAmmo = weaponItem:getAmmoType()

    --ISReloadable.syncItemToReloadable(self, weaponItem)
    self.type = modData.type or weaponItem:getType()
    self.moduleName = modData.moduleName
    self.reloadClass = modData.reloadClass
    self.ammoType = modData.ammoType
    self.loadStyle = modData.reloadStyle
    self.ejectSound = modData.ejectSound
    self.clickSound = modData.clickSound
    self.insertSound = modData.insertSound
    self.rackSound = modData.rackSound
    self.maxCapacity = modData.maxCapacity or weaponItem:getClipSize()
    self.reloadTime = modData.reloadTime or weaponItem:getReloadTime()
    self.rackTime = modData.rackTime
    self.currentCapacity = modData.currentCapacity

    self.openSound = modData.openSound
    self.closeSound = modData.closeSound
    self.cockSound = modData.cockSound

    self.roundChambered = modData.roundChambered
    self.emptyShellChambered = modData.emptyShellChambered
    self.containsClip = modData.containsClip
    self.speedLoader = modData.speedLoader
    self.altActionType = modData.altActionType

    self.clipName = modData.clipName
    self.clipIcon = modData.clipIcon
    self.triggerType = modData.triggerType
    self.actionType = modData.actionType
    self.selectFire = modData.selectFire
    self.isOpen = modData.isOpen
    self.hammerCocked = modData.hammerCocked
    self.cylinderPosition = modData.cylinderPosition
    self.magazineData = modData.magazineData
    self.preferredAmmoType = modData.preferredAmmoType
    self.lastRound = modData.lastRound
    self.loadedAmmo = modData.loadedAmmo
    self.isJammed = modData.isJammed
    self.roundsFired = modData.roundsFired or 0
    self.roundsSinceCleaned = modData.roundsSinceCleaned or 0
    -- self.shootSound = modData.shootSound
end


--[[- Copies properties of the reloadable object to the weaponItem's modData.

@usage reloadable:syncItemToReloadable(weaponItem)
@param weaponItem a HandWeapon/InventoryItem

]]
function ISORGMWeapon:syncReloadableToItem(weaponItem)
     -- handle switching difficulty
    local modData = weaponItem:getModData()

    --if ReloadManager[1]:getDifficulty() == 1 then
    --  self.containsClip = 1
    --end

    --ISReloadableWeapon.syncReloadableToItem(self, weaponItem)
    --ISReloadable.syncReloadableToItem(self, weaponItem)
    modData.type = self.type
    modData.currentCapacity = self.currentCapacity

    modData.speedLoader = self.speedLoader
    modData.roundChambered = self.roundChambered
    modData.emptyShellChambered = self.emptyShellChambered
    modData.isOpen = self.isOpen
    modData.hammerCocked = self.hammerCocked
    modData.actionType = self.actionType -- this one needs to be synced for guns that have altActionType
    modData.selectFire = self.selectFire
    modData.containsClip = self.containsClip
    modData.cylinderPosition = self.cylinderPosition
    modData.magazineData = self.magazineData
    modData.preferredAmmoType = self.preferredAmmoType
    modData.lastRound = self.lastRound
    modData.loadedAmmo  = self.loadedAmmo
    modData.isJammed = self.isJammed
    modData.roundsFired = self.roundsFired or 0
    modData.roundsSinceCleaned = self.roundsSinceCleaned or 0
end

function ISORGMWeapon:setupReloadable(weaponItem, gunData)
    ORGM.Firearm.setup(gunData, weaponItem) --moved to save on duplicate code
end


local function printDetails(data)
    print("type == " .. tostring(data.type))
    print("BUILD_ID == ".. tostring(data.BUILD_ID))
    print("triggerType == " .. tostring(data.triggerType))
    print("actionType == " .. tostring(data.actionType))
    print("barrelLength == " .. tostring(data.barrelLength))

    print("isOpen == " .. tostring(data.isOpen))
    print("hammerCocked == " .. tostring(data.hammerCocked))
    print("selectFire == " .. tostring(data.selectFire))
    print("cylinderPosition == " .. tostring(data.cylinderPosition))
    print("reloadTime == " .. tostring(data.reloadTime))
    print("rackTime == " .. tostring(data.rackTime))

    print("ammoType == " .. tostring(data.ammoType))
    print("containsClip == "..tostring(data.containsClip))
    print("maxCapacity == "..tostring(data.maxCapacity))
    print("roundChambered == "..tostring(data.roundChambered))
    print("emptyShellChambered == "..tostring(data.emptyShellChambered))
    print("currentCapacity == "..tostring(data.currentCapacity))
    print("isJammed == "..tostring(data.isJammed))
    --print("speedLoader == " .. tostring(data.speedLoader))
    --print("altActionType == " .. tostring(data.altActionType))
    print("lastRound == "..tostring(data.lastRound))
    print("preferredAmmoType == "..tostring(data.preferredAmmoType))
    print("loadedAmmo == "..tostring(data.loadedAmmo))
    print("roundsFired == " .. tostring(data.roundsFired))
    print("roundsSinceCleaned == " .. tostring(data.roundsSinceCleaned))

    if data.magazineData then
        for index=1, data.maxCapacity do
            value = data.magazineData[index]
            print("magazineData #" .. index .. " = " .. tostring(value))
        end
    end
end

function ISORGMWeapon:printWeaponDetails(item)
    print("***************************************************************")
    print("Debug data for: ".. tostring(item:getFullType()))
    print("DisplayName == " .. tostring(item:getDisplayName()))
    print("AmmoType == " .. tostring(item:getAmmoType()))
    print("ClipSize == " .. tostring(item:getClipSize()))
    print()
    print("*** Weapon Damage ***")
    print("MinDamage == " .. tostring(item:getMinDamage()))
    print("MaxDamage == " .. tostring(item:getMaxDamage()))
    print("DoorDamage == " .. tostring(item:getDoorDamage()))
    print("TreeDamage == " .. tostring(item:getTreeDamage()))
    print()
    print("*** Weapon Times ***")
    print("SwingTime == " .. tostring(item:getSwingTime()))
    print("MinimumSwingTime == " .. tostring(item:getMinimumSwingTime()))
    print("RecoilDelay == " .. tostring(item:getRecoilDelay()))
    print("AimingTime == " .. tostring(item:getAimingTime()))
    print("ReloadTime == " .. tostring(item:getReloadTime()))
    print()
    print("*** Weapon Accuracy ***")
    print("AimingMod == " .. tostring(item:getAimingMod()))
    print("HitChance == " .. tostring(item:getHitChance()))
    print("AimingPerkHitChanceModifier == " .. tostring(item:getAimingPerkHitChanceModifier()))
    print("ToHitModifier == " .. tostring(item:getToHitModifier()))
    print("MaxHitCount == " .. tostring(item:getMaxHitCount()))
    print("ProjectileCount == " .. tostring(item:getProjectileCount()))
    print()
    print("CriticalChance == " .. tostring(item:getCriticalChance()))
    print("AimingPerkCritModifier == " .. tostring(item:getAimingPerkCritModifier()))
    print()
    print("*** Weapon Ranges ***")
    print("MinRange == " .. tostring(item:getMinRange()))
    print("MinRangeRanged == " .. tostring(item:getMinRangeRanged()))
    print("MaxRange == " .. tostring(item:getMaxRange()))
    print("AimingPerkRangeModifier == " .. tostring(item:getAimingPerkRangeModifier()))
    print()
    print("*** Weapon Angles ***")
    print("MaxAngle == " .. tostring(item:getMaxAngle()))
    print("MinAngle == " .. tostring(item:getMinAngle()))
    print("AimingPerkMinAngleModifier == " .. tostring(item:getAimingPerkMinAngleModifier()))
    print()
    print("*** Weapon Sounds ***")
    print("SwingSound == " .. tostring(item:getSwingSound()))
    print("SoundGain == " .. tostring(item:getSoundGain()))
    print("SoundRadius == " .. tostring(item:getSoundRadius()))
    print("SoundVolume == " .. tostring(item:getSoundVolume()))
    print()
    print("*** Weapon Weight ***")
    print("Weight == " .. tostring(item:getWeight()))
    print("ActualWeight == " .. tostring(item:getActualWeight()))
    print("UnequippedWeight == " .. tostring(item:getUnequippedWeight()))
    print()
    print("*** Weapon Condition ***")
    print("Condition == " .. tostring(item:getCondition()))
    print("ConditionMax == " .. tostring(item:getConditionMax()))
    print("CurrentCondition == " .. tostring(item:getCurrentCondition()))
    print("ConditionLowerChance == " .. tostring(item:getConditionLowerChance()))
    print("HaveBeenRepaired == " .. tostring(item:getHaveBeenRepaired()))
    print()
    print("*** Weapon Attachments ***")
    print("Cannon == ".. (item:getCanon() and item:getCanon():getFullType() or "nil"))
    print("Scope == ".. (item:getScope() and item:getScope():getFullType() or "nil"))
    print("Sling == ".. (item:getSling() and item:getSling():getFullType() or "nil"))
    print("Stock == ".. (item:getStock() and item:getStock():getFullType() or "nil"))
    print("Clip == ".. (item:getClip() and item:getClip():getFullType() or "nil"))
    print("Recoilpad == ".. (item:getRecoilpad() and item:getRecoilpad():getFullType() or "nil"))
    print()
    print()
    print("***************************************************************")
    print("***************************************************************")
    print("ModData details:")
    printDetails(item:getModData())
    print()
    print()
    print("***************************************************************")
end

function ISORGMWeapon:printReloadableDetails()
    print("***************************************************************")
    print("Reloadable Weapon Details:")
    printDetails(self)
    print()
    print()
    print("***************************************************************")
end

function ISORGMWeapon:printReloadableWeaponDetails()
    self:printReloadableDetails()
end
-- ORGM.NVAL = 0.1
