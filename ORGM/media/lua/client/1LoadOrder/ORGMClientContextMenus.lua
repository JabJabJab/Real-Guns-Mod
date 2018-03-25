--[[
    This file handles all ORGM item context menus.

    TODO: cleanup and document this file
    
]]
-- all callback functions from context menus go into this table.
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
    player:playSound("ORGMRndLoad", false)
    data.actionType = newtype
    ORGM.setWeaponStats(item, data.lastRound)
    --reloadable.actionType = newtype
    --reloadable:syncReloadableToItem(item)
end

MenuCallbacks.onFireModeToggle = function(item, player, data, reloadable, newmode)
    local itemType = item:getFullType()
    --local scriptItem = getScriptManager():FindItem(itemType)
    --[[
    local scriptItem = item:getScriptItem()
    if not scriptItem then
        return
    end
    if newmode == ORGM.SEMIAUTOMODE then
        item:setSwingTime(0.7)
        item:setRecoilDelay(12)
    elseif newmode == ORGM.FULLAUTOMODE then
        item:setSwingTime(scriptItem:getSwingTime())
        item:setRecoilDelay(1)
    end
    reloadable.selectFire = newmode
    reloadable:syncReloadableToItem(item)
    ]]
    
    player:playSound("ORGMRndLoad", false)
    data.selectFire = newmode
    ORGM.setWeaponStats(item, data.lastRound)
    
end

MenuCallbacks.onSpinCylinder = function(item, player, data, reloadable)
    reloadable:rotateCylinder(0, player, false, item)
    reloadable:syncReloadableToItem(item)
end

MenuCallbacks.onUnload = function(item, player)
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
        if reloadable.actionType == ORGM.SINGLEACTION and reloadable.hammerCocked == 0 then
            return -- cant shoot with a SA if its not cocked
        end
        reloadable:fireEmpty(player, item)
        player:playSound(reloadable.clickSound, false)
        if reloadable.actionType == ORGM.ROTARY and reloadable.currentCapacity > 0 then
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
    local modal = ISModalDialog:new(0,0, 250, 150, getText("IGUI_Firearm_SuicideConfirm"), true, nil, MenuCallbacks.onShootSelfConfirm, player:getPlayerNum(), player, item);
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

-- test for backwards  compatibility function: item update
MenuCallbacks.onBackwardsTestFunction = function(item, player, data, reloadable)
    data.BUILD_ID = 1
    
    if not ORGM.getFirearmData(item).lastChanged then
        player:Say('No listed changes for item, but setting BUILD_ID to 1 anyways.')
        return
    end
    player:Say('BUILD_ID set to 1, unequip and re-equip to test backwards compatibility function.')
end

-- test to validate magazine overflow checking works (mag has more ammo then it should)
MenuCallbacks.onMagOverflowTestFunction = function(item, player, data)
    local ammoType = data.ammoType
    if data.containsClip ~= nil then -- uses a clip, so get the ammoType from the clip
        ammoType = ReloadUtil:getClipData(ammoType).ammoType
    end
    ammoType = ORGM.getAmmoGroup(ammoType)[1]
    data.currentCapacity = data.maxCapacity + 10
    for i=1, data.currentCapacity do
        data.magazineData[i] = ammoType
    end
    data.loadedAmmo = ammoType
end

-- reset weapon to defaults
MenuCallbacks.onResetWeapon = function(item, player, data, reloadable)
    ORGM.setupGun(ORGM.getFirearmData(item), item)
    player:Say("weapon reset")
end

-- fill the gun/magazine to max ammo
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
--[[ ORGM.Client.firearmContextMenu(player, context, item)

    builds the context menu for firearms. Note this will return instantly
    unless the item is in hand.

]]
ORGM.Client.firearmContextMenu = function(player, context, item)
    local playerObj = getSpecificPlayer(player)
    if playerObj:getPrimaryHandItem() ~= item then return end

    local data = item:getModData()
    local reloadable = ReloadUtil:getReloadableWeapon(item, player)
    reloadable.playerObj = player -- not sure where this is actually set in the code, but apparently sometimes its not...

    context:addOption(getText("ContextMenu_ORGM_Inspect"), item, MenuCallbacks.onInspectFunction, playerObj, data, reloadable)
    ---------------------
    -- hammer actions
    if (data.hammerCocked == 1 and data.triggerType ~= ORGM.DOUBLEACTIONONLY) then
        context:addOption(getText("ContextMenu_ORGM_Release"), item, MenuCallbacks.onHammerToggle, playerObj, data, reloadable);
    elseif (data.hammerCocked == 0 and data.triggerType ~= ORGM.DOUBLEACTIONONLY) then
        context:addOption(getText("ContextMenu_ORGM_Cock"), item, MenuCallbacks.onHammerToggle, playerObj, data, reloadable);
    end
    
    ---------------------
    -- add open/close bolt, cylinder etc
    local text = "ContextMenu_ORGM_PartSlide"
    local callback = MenuCallbacks.onBoltToggle
    if data.actionType == ORGM.ROTARY then
        text = "ContextMenu_ORGM_Cylinder"
        callback = MenuCallbacks.onCylinderToggle
    elseif data.actionType == ORGM.BREAK then
        text = "ContextMenu_ORGM_PartBarrel"
        callback = MenuCallbacks.onBarrelToggle
    elseif data.actionType == ORGM.BOLT then 
        text = "ContextMenu_ORGM_PartBolt" 
    end
    if data.isOpen == 1 then
        context:addOption(getText("ContextMenu_ORGM_Close", getText(text)), item, callback, playerObj, data, reloadable)
    elseif data.isOpen == 0 then
        context:addOption(getText("ContextMenu_ORGM_Open", getText(text)), item, callback, playerObj, data, reloadable)
    end
    
    ---------------------
    -- add actionType switching if weapon allows for item (ie: Pump to Semi-Auto)
    if data.altActionType then
        for _, atype in ipairs(data.altActionType) do
            if atype ~= data.actionType then
                context:addOption(getText("ContextMenu_ORGM_Switch", getText("ContextMenu_ORGM_"..ORGM.ActionTypeStrings[atype])), item, MenuCallbacks.onActionTypeToggle, playerObj, data, reloadable, atype)
            end
        end
    end
    ---------------------
    -- switch fire mode option (semi to full auto), use item:setSwingTime()
    if data.selectFire == 0 then -- switch to full auto
        context:addOption(getText("ContextMenu_ORGM_Switch", getText("ContextMenu_ORGM_FullAuto")), item, MenuCallbacks.onFireModeToggle, playerObj, data, reloadable, 1)
    elseif data.selectFire == 1 then -- switch to semi auto
        context:addOption(getText("ContextMenu_ORGM_Switch", getText("ContextMenu_ORGM_Auto")), item, MenuCallbacks.onFireModeToggle, playerObj, data, reloadable, 0)
    end
    ---------------------
    if data.actionType == ORGM.ROTARY then
        context:addOption(getText("ContextMenu_ORGM_Spin"), item, MenuCallbacks.onSpinCylinder, playerObj, data, reloadable)
    end
    ---------------------
    if data.roundChambered ~= nil and data.roundChambered > 0 then
        context:addOption(getText("ContextMenu_ORGM_Unload"), item, MenuCallbacks.onUnload, playerObj)
    elseif data.currentCapacity > 0 then
        context:addOption(getText("ContextMenu_ORGM_Unload"), item, MenuCallbacks.onUnload, playerObj)
    end

    context:addOption(getText("ContextMenu_ORGM_Suicide"), item, MenuCallbacks.onShootSelf, playerObj, data, reloadable)
    -- TODO: if open and has bullets insert round into chamber option
    
    -- add debug/development submenu.
    if ORGM.Settings.Debug == true then
        local debugMenu = context:addOption("DEBUG", item, nil)
        local subMenuDebug = context:getNew(context)
        context:addSubMenu(debugMenu, subMenuDebug)
        
        subMenuDebug:addOption("* Debug Weapon", item, MenuCallbacks.onDebugWeapon, playerObj, data, reloadable)
        subMenuDebug:addOption("* Backwards Compatibility Test", item, MenuCallbacks.onBackwardsTestFunction, playerObj, data, reloadable)
        subMenuDebug:addOption("* Magazine Overflow Test", item, MenuCallbacks.onMagOverflowTestFunction, playerObj, data)
        subMenuDebug:addOption("* Reset To Defaults", item, MenuCallbacks.onResetWeapon, playerObj, data, reloadable)
        --subMenuDebug:addOption("* Full ammo")
    end
end

--[[  menuBuilderMagazine(playerObj, context, item)
    
    menus specific to magazines

]]
ORGM.Client.magazineContextMenu = function(player, context, item)
    local playerObj = getSpecificPlayer(player)
    local data = item:getModData()
    if data.currentCapacity ~= nil and data.currentCapacity > 0 then
        context:addOption(getText("ContextMenu_ORGM_Unload"), item, MenuCallbacks.onUnload, playerObj)
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

    if ORGM.isFirearm(item) then
        ORGM.Client.firearmContextMenu(player, context, item)
    elseif ORGM.isMagazine(item) then
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
    local altTable = ORGM.getAmmoGroup(ammoType)
    if #altTable > 1 then -- this ammo has alternatives
        -- create the submenu
        local preferredAmmoMenu = context:addOption(getText("ContextMenu_ORGM_UseOnly"), item, nil)
        local subMenuAmmo = context:getNew(context)
        context:addSubMenu(preferredAmmoMenu, subMenuAmmo)
        subMenuAmmo:addOption(getText("ContextMenu_ORGM_Any"), item, MenuCallbacks.onSetPreferredAmmo, player, data, reloadable, "any")
        -- add menu for the default ammo type
        subMenuAmmo:addOption(getText("ContextMenu_ORGM_Mixed"), item, MenuCallbacks.onSetPreferredAmmo, player, data, reloadable, "mixed")
        -- find all ammo types:
        for _, value in ipairs(altTable) do
            local def = ORGM.getAmmoData(value)
            subMenuAmmo:addOption(getScriptManager():FindItem(def.moduleName ..'.' .. value):getDisplayName(), item, MenuCallbacks.onSetPreferredAmmo, player, data, reloadable, value)
        end
    end

    if isAdmin() then
        context:addOption(getText("ContextMenu_ORGM_AdminLoad"), item, MenuCallbacks.onAdminFillAmmo, playerObj, data, altTable[1])
    end
end

