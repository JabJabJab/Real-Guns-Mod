--[[
    This file handles all ORGM item context menus.
    
]]
local MenuCallbacks = { }
ORGM.Client.MenuCallbacks = MenuCallbacks


---------------------------------------------------------------------------
---------------------------------------------------------------------------
---------------------------------------------------------------------------
--   Context menu callbacks (these can use up to 6 parameters, 7 if you include the target items)

MenuCallbacks.onHammerToggle = function(item, player, data, reloadable)
    if reloadable.hammerCocked == 1 then
        reloadable:releaseHammer(player, true)
    else
        reloadable:cockHammer(player, true, item)
    end
    reloadable:syncReloadableToItem(item)
end

MenuCallbacks.onBoltToggle = function(item, player, data, reloadable)
    if reloadable.isOpen == 1 then
        reloadable:closeSlide(player, true, item)
    else
        reloadable:openSlide(player, true, item)
    end
    reloadable:syncReloadableToItem(item)
end

MenuCallbacks.onCylinderToggle = function(item, player, data, reloadable)
    if reloadable.isOpen == 1 then
        reloadable:closeCylinder(player, true, item)
    else
        reloadable:openCylinder(player, true, item)
    end
    reloadable:syncReloadableToItem(item)
end

MenuCallbacks.onBarrelToggle = function(item, player, data, reloadable)
    if reloadable.isOpen == 1 then
        reloadable:openBreak(player, true, item)
    else
        reloadable:closeBreak(player, true, item)
    end
    reloadable:syncReloadableToItem(item)
end

MenuCallbacks.onActionTypeToggle = function(item, player, data, reloadable, newtype)
    reloadable.actionType = newtype
    reloadable:syncReloadableToItem(item)
end

MenuCallbacks.onFireModeToggle = function(item, player, data, reloadable, newmode)
    local itemType = item:getFullType()
    local scriptItem = getScriptManager():FindItem(itemType)
    if not scriptItem then
        return
    end
    if newmode == 0 then
        item:setSwingTime(0.7)
        item:setRecoilDelay(12)
    elseif newmode == 1 then
        item:setSwingTime(scriptItem:getSwingTime())
        item:setRecoilDelay(1)
    end
    reloadable.selectFire = newmode
    reloadable:syncReloadableToItem(item)
end

MenuCallbacks.onSpinCylinder = function(item, player, data, reloadable)
    reloadable:rotateCylinder(0, player, false, item)
    reloadable:syncReloadableToItem(item)
end

MenuCallbacks.onUnload = function(item, player)
    -- TODO: Clear player action queue
    --if player:getPrimaryHandItem() ~= item then
    --    ISTimedActionQueue.add(ISEquipWeaponAction:new(player, item, 0, true, false))
    --end
    --ISTimedActionQueue.add()
    ReloadManager[player:getPlayerNum()+1]:startUnloadFromUi(item)
end

MenuCallbacks.onShootSelfConfirm = function(this, button, player, item)
    local reloadable = ReloadUtil:getReloadableWeapon(item, player)
    if button.internal ~= "YES" then
        return
    end
    if reloadable:isLoaded(3) then
        reloadable:fireShot(item, 3)
        player:splatBlood(5, 0.5) -- this one vanishes after a while...
        player:splatBloodFloorBig(0.5)
        
        player:playSound(item:getSwingSound(), false)
        player:getBodyDamage():RestoreToFullHealth() -- cheap trick so the corpse doesn't rise
        player:setHealth(0)
    else
        if reloadable.actionType == "SingleAction" and reloadable.hammerCocked == 0 then
            return
        end
        reloadable:fireEmpty(player, item)
        player:playSound(reloadable.clickSound, false)
        if reloadable.actionType == "Rotary" and reloadable.currentCapacity > 0 then
            if player:HasTrait("Desensitized") ~= true then player:getStats():setPanic(95) end
            local boredom = player:getBodyDamage():getBoredomLevel()
            boredom = boredom - 20
            if boredom < 0 then boredom = 0 end
            player:getBodyDamage():setBoredomLevel(boredom)
            player:getStats():setIdleboredom(0)
        end
    end
end

MenuCallbacks.onShootSelf = function(item, player, data, reloadable)
    local modal = ISModalDialog:new(0,0, 250, 150, "End your own life?", true, nil, MenuCallbacks.onShootSelfConfirm, player:getPlayerNum(), player, item);
    modal:initialise()
    modal:addToUIManager()
    if JoypadState.players[player:getPlayerNum()+1] then
        setJoypadFocus(player:getPlayerNum(), modal)
    end
end

MenuCallbacks.onSetPreferredAmmo = function(item, player, data, reloadable, value)
    reloadable.preferredAmmoType = value
    reloadable:syncReloadableToItem(item)
    
end

MenuCallbacks.onInspectFunction = function(item, player, data, reloadable)
    ORGMFirearmWindow:setFirearm(item)
    ORGMFirearmWindow:setVisible(true)
end

----------------------------------------------------
----------------------------------------------------
MenuCallbacks.onDebugWeapon = function(item, player, data, reloadable)
    reloadable:printReloadableWeaponDetails() -- debug data
end

MenuCallbacks.onBackwardsTestFunction = function(item, player, data, reloadable)
    data.BUILD_ID = 1
    
    if not ORGM.FirearmTable[item:getType()].lastChanged then
        player:Say('No listed changes for item, but setting BUILD_ID to 1 anyways.')
        return
    end
    player:Say('BUILD_ID set to 1, unequip and re-equip to test backwards compatibility function.')
end

MenuCallbacks.onMagOverflowTestFunction = function(item, player, data)
    local ammoType = data.ammoType
    if data.containsClip ~= nil then -- uses a clip, so get the ammoType from the clip
        ammoType = ReloadUtil:getClipData(ammoType).ammoType
    end
    ammoType = ORGM.AlternateAmmoTable[ammoType][1]
    data.currentCapacity = data.maxCapacity + 10
    for i=1, data.currentCapacity do
        data.magazineData[i] = ammoType
    end
    data.loadedAmmo = ammoType
end

MenuCallbacks.onResetWeapon = function(item, player, data, reloadable)
    --local gunData = ORGM.FirearmTable[item:getType()]
    ORGM.setupGun(ORGM.FirearmTable[item:getType()], item)
    --reloadable:setupReloadable(item, gunData)
    --reloadable:syncItemToReloadable(item)
    --player:Say("weapon reset")
end

MenuCallbacks.onAdminFillAmmo = function(item, player, data, ammoType)
    data.currentCapacity = data.maxCapacity
    for i=1, data.maxCapacity do
        data.magazineData[i] = ammoType
    end
    data.loadedAmmo = ammoType
end

---------------------------------------------------------------------------
---------------------------------------------------------------------------
---------------------------------------------------------------------------
ORGM.Client.firearmContextMenu = function(player, context, item)
    local playerObj = getSpecificPlayer(player)
    if playerObj:getPrimaryHandItem() ~= item then return end

    local data = item:getModData()
    local reloadable = ReloadUtil:getReloadableWeapon(item, player)
    reloadable.playerObj = player -- not sure where this is actually set in the code, but apparently sometimes its not...

    context:addOption("Inspect Weapon", item, MenuCallbacks.onInspectFunction, playerObj, data, reloadable)
    ---------------------
    -- hammer actions
    if (data.hammerCocked == 1 and data.triggerType ~= "DoubleActionOnly") then
        context:addOption("Release Hammer", item, MenuCallbacks.onHammerToggle, playerObj, data, reloadable);
    elseif (data.hammerCocked == 0 and data.triggerType ~= "DoubleActionOnly") then
        context:addOption("Cock Hammer", item, MenuCallbacks.onHammerToggle, playerObj, data, reloadable);
    end
    
    ---------------------
    -- add open/close bolt, cylinder etc
    local text = "Slide"
    local callback = MenuCallbacks.onBoltToggle
    if data.actionType == "Rotary" then
        text = "Cylinder"
        callback = MenuCallbacks.onCylinderToggle
    elseif data.actionType == "Break" then
        text = "Barrel"
        callback = MenuCallbacks.onBarrelToggle
    elseif data.actionType == "Bolt" then 
        text = "Bolt" 
    end
    if data.isOpen == 1 then
        context:addOption("Close " .. text, item, callback, playerObj, data, reloadable)
    elseif data.isOpen == 0 then
        context:addOption("Open " .. text, item, callback, playerObj, data, reloadable)
    end
    
    ---------------------
    -- add actionType switching if weapon allows for item (ie: Pump to Semi-Auto)
    if data.altActionType then
        for _, atype in ipairs(data.altActionType) do
            if atype ~= data.actionType then
                context:addOption("Switch to " .. atype .. " Action", item, MenuCallbacks.onActionTypeToggle, playerObj, data, reloadable, atype)
            end
        end
    end
    ---------------------
    -- switch fire mode option (semi to full auto), use item:setSwingTime()
    if data.selectFire == 0 then -- switch to full auto
        context:addOption("Switch to Full-Auto", item, MenuCallbacks.onFireModeToggle, playerObj, data, reloadable, 1)
    elseif data.selectFire == 1 then -- switch to semi auto
        context:addOption("Switch to Semi-Auto", item, MenuCallbacks.onFireModeToggle, playerObj, data, reloadable, 0)
    end
    ---------------------
    if data.actionType == "Rotary" then
        context:addOption("Spin Cylinder", item, MenuCallbacks.onSpinCylinder, playerObj, data, reloadable)
    end
    ---------------------
    if data.roundChambered ~= nil and data.roundChambered > 0 then
        context:addOption("Unload", item, MenuCallbacks.onUnload, playerObj)
    elseif data.currentCapacity > 0 then
        context:addOption("Unload", item, MenuCallbacks.onUnload, playerObj)
    end

    context:addOption("Shoot Yourself", item, MenuCallbacks.onShootSelf, playerObj, data, reloadable)
    -- TODO: if open and has bullets insert round into chamber option
    

    if ORGM.Settings.Debug == true then
        local debugMenu = context:addOption("DEBUG", item, nil)
        local subMenuDebug = context:getNew(context)
        context:addSubMenu(debugMenu, subMenuDebug)
        
        subMenuDebug:addOption("* Debug Weapon", item, MenuCallbacks.onDebugWeapon, playerObj, data, reloadable)
        subMenuDebug:addOption("* Backwards Compatibility Test", item, MenuCallbacks.onBackwardsTestFunction, playerObj, data, reloadable)
        subMenuDebug:addOption("* Magazine Overflow Test", item, MenuCallbacks.onMagOverflowTestFunction, playerObj, data)
        subMenuDebug:addOption("* Reset To Defaults", item, MenuCallbacks.onResetWeapon, playerObj, data, reloadable)
    end
end

--[[  menuBuilderMagazine(playerObj, context, item)
    
    menus specific to magazines

]]
ORGM.Client.magazineContextMenu = function(player, context, item)
    local playerObj = getSpecificPlayer(player)
    local data = item:getModData()
    if data.currentCapacity ~= nil and data.currentCapacity > 0 then
        context:addOption("Unload", item, MenuCallbacks.onUnload, playerObj)
    end
end


ORGM.Client.inventoryContextMenu = function(player, context, items)

    local playerObj = getSpecificPlayer(player)

    local item = items[1]
    if not instanceof(item, "InventoryItem") then
        item = items[1].items[1]
    end
    --if item:getModule() ~= "ORGM" then return end
    -- item must be in inventory
    if playerObj:getInventory():contains(item) == false then return end    

    if ORGM.FirearmTable[item:getType()] then
        ORGM.Client.firearmContextMenu(player, context, item)
    elseif ORGM.MagazineTable[item:getType()] then
        ORGM.Client.magazineContextMenu(player, context, item)
    else
        return
    end
    
    
    local data = item:getModData()
    ---------------------
    -- Check for alternate ammo types so player can set gun to use a specific type
    local ammoType = data.ammoType
    if data.containsClip ~= nil then -- uses a clip, so get the ammoType from the clip
        ammoType = ReloadUtil:getClipData(ammoType).ammoType
    end
    local reloadable = ReloadUtil:getReloadableWeapon(item, player)
    local altTable = ORGM.AlternateAmmoTable[ammoType]
    if #altTable > 1 then -- this ammo has alternatives
        -- create the submenu
        local preferredAmmoMenu = context:addOption("Use Only...", item, nil)
        local subMenuAmmo = context:getNew(context)
        context:addSubMenu(preferredAmmoMenu, subMenuAmmo)
        subMenuAmmo:addOption("Any", item, MenuCallbacks.onSetPreferredAmmo, player, data, reloadable, "any")
        -- add menu for the default ammo type
        subMenuAmmo:addOption("Mixed Load", item, MenuCallbacks.onSetPreferredAmmo, player, data, reloadable, "mixed")
        -- find all ammo types:
        for _, value in ipairs(altTable) do
            local def = ORGM.AmmoTable[value]
            subMenuAmmo:addOption(getScriptManager():FindItem(def.moduleName ..'.' .. value):getDisplayName(), item, MenuCallbacks.onSetPreferredAmmo, player, data, reloadable, value)
        end
    end

    if isAdmin() then
        context:addOption("Admin - Full Ammo", item, MenuCallbacks.onAdminFillAmmo, playerObj, data, altTable[1])
    end
end

