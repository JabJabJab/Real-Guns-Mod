--[[
    This file handles all ORGM item context menus.
    
    TODO: remove debugging code
    TODO: ensure magazines are setup properly
]]

---------------------------------------------------------------------------
---------------------------------------------------------------------------
---------------------------------------------------------------------------
--   Context menu callbacks (these can use up to 6 parameters, 7 if you include the target items)

local OnHammerToggle = function(item, player, data, reloadable)
    if reloadable.hammerCocked == 1 then
        reloadable:releaseHammer(player, true)
    else
        reloadable:cockHammer(player, true, item)
    end
    reloadable:syncReloadableToItem(item)
end

local OnBoltToggle = function(item, player, data, reloadable)
    if reloadable.isOpen == 1 then
        reloadable:closeSlide(player, true, item)
    else
        reloadable:openSlide(player, true, item)
    end
    reloadable:syncReloadableToItem(item)
end

local OnCylinderToggle = function(item, player, data, reloadable)
    if reloadable.isOpen == 1 then
        reloadable:closeCylinder(player, true, item)
    else
        reloadable:openCylinder(player, true, item)
    end
    reloadable:syncReloadableToItem(item)
end

local OnBarrelToggle = function(item, player, data, reloadable)
    if reloadable.isOpen == 1 then
    else
    end
    reloadable:syncReloadableToItem(item)
end

local OnActionTypeToggle = function(item, player, data, reloadable, newtype)
    reloadable.actionType = newtype
    reloadable:syncReloadableToItem(item)
end

local OnFireModeToggle = function(item, player, data, reloadable, newmode)
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


local OnSpinCylinder = function(item, player, data, reloadable)
    reloadable:rotateCylinder(0, player, false, item)
    reloadable:syncReloadableToItem(item)
end


local OnUnload = function(item, player)
    ReloadManager[player:getPlayerNum()+1]:startUnloadFromUi(item)
end

local OnShootSelfConfirm = function(this, button, player, item)
    local reloadable = ReloadUtil:getReloadableWeapon(item, player)
    if button.internal ~= "YES" then
        return
    end
    if reloadable:isLoaded(3) then
        reloadable:fireShot(item, 3) -- TODO: play gunshot sound
        player:splatBlood(5, 0.5) -- this one vanishes after a while...
        player:splatBloodFloorBig(0.5)
        player:getBodyDamage():RestoreToFullHealth() -- cheap trick so the corpse doesn't rise
        player:setHealth(0)
    else
        reloadable:fireEmpty(player, item)
        if (reloadable.actionType == "Rotary" and reloadable.currentCapacity > 0) then
            local moodles = player:getMoodles()
            local boredom = moodles:getMoodleLevel(MoodleType.Bored)
            if boredom > 0 then
                boredom = boredom - 10
                if boredom < 0 then bored = 0 end
                player:getBodyDamage():setBoredomLevel(boredom) -- this is a absolute (not rel value)
            end
            player:getBodyDamage():setPanicIncreaseValue(25) --not working properly?
        end
    end
end

local OnShootSelf = function(item, player, data, reloadable)
    local modal = ISModalDialog:new(0,0, 250, 150, "End your own life?", true, nil, OnShootSelfConfirm, player:getPlayerNum(), player, item);
    modal:initialise()
    modal:addToUIManager()
    if JoypadState.players[player:getPlayerNum()+1] then
        setJoypadFocus(player:getPlayerNum(), modal)
    end
end

local OnSetPreferredAmmo = function(item, player, data, reloadable, value)
    reloadable.preferredAmmoType = value
    reloadable:syncReloadableToItem(item)
    
end

----------------------------------------------------
----------------------------------------------------
local OnDebugWeapon = function(item, player, data, reloadable)
    reloadable:printReloadableWeaponDetails() -- debug data
end

local OnTestFunction = function(item, player, data, reloadable)
end

local OnResetWeapon = function(item, player, data, reloadable)
    local gunData = ORGMMasterWeaponTable[item:getType()]
    reloadable:setupReloadable(item, gunData)
    reloadable:syncItemToReloadable(item)
    player:Say("weapon reset")
end
---------------------------------------------------------------------------
---------------------------------------------------------------------------
---------------------------------------------------------------------------
Events.OnFillInventoryObjectContextMenu.Add(function(player, context, items)

    local isInInv = false
    local playerObj = getSpecificPlayer(player)

    local item = items[1];
    if not instanceof(item, "InventoryItem") then
        item = items[1].items[1]
    end
    
    if item:getModule() ~= "ORGM" then return end
    -- item must be in inventory
    if playerObj:getInventory():contains(item) == false then return end    

    local data = item:getModData()
    
    if (data.actionType ~= nil and playerObj:getPrimaryHandItem() == item) then -- has a actionType so must be a weapon
        local reloadable = ReloadUtil:getReloadableWeapon(item, player)
        reloadable.playerObj = player -- not sure where this is actually set in the code, but apparently sometimes its not...

        ---------------------
        -- hammer actions
        if (data.hammerCocked == 1 and data.triggerType ~= "DoubleActionOnly") then
            context:addOption("Release Hammer", item, OnHammerToggle, playerObj, data, reloadable);
        elseif (data.hammerCocked == 0 and data.triggerType ~= "DoubleActionOnly") then
            context:addOption("Cock Hammer", item, OnHammerToggle, playerObj, data, reloadable);
        end
        
        ---------------------
        -- add open/close bolt, cylinder etc
        local text = "Slide"
        local callback = OnBoltToggle
        if data.actionType == "Rotary" then
            text = "Cylinder"
            callback = OnCylinderToggle
        elseif data.actionType == "Break" then
            text = "Barrel"
            callback = OnBarrelToggle
        elseif data.actionType == "Bolt" then 
            text = "Bolt" 
        end
        if reloadable.isOpen == 1 then
            context:addOption("Close " .. text, item, callback, playerObj, data, reloadable)
        elseif reloadable.isOpen == 0 then
            context:addOption("Open " .. text, item, callback, playerObj, data, reloadable)
        end
        
        ---------------------
        -- add actionType switching if weapon allows for item (ie: Pump to Semi-Auto)
        if data.altActionType then
            for _, atype in ipairs(data.altActionType) do
                if atype ~= data.actionType then
                    context:addOption("Switch to " .. atype .. " Action", item, OnActionTypeToggle, playerObj, data, reloadable, atype)
                end
            end
        end
        ---------------------
        -- switch fire mode option (semi to full auto), use item:setSwingTime()
        if data.selectFire == 0 then -- switch to full auto
            context:addOption("Switch to Full-Auto", item, OnFireModeToggle, playerObj, data, reloadable, 1)
        elseif data.selectFire == 1 then -- switch to semi auto
            context:addOption("Switch to Semi-Auto", item, OnFireModeToggle, playerObj, data, reloadable, 0)
        end
        ---------------------
        if data.actionType == "Rotary" then
            context:addOption("Spin Cylinder", item, OnSpinCylinder, playerObj, data, reloadable)
        end
        ---------------------
        context:addOption("Shoot Yourself", item, OnShootSelf, playerObj, data, reloadable)
        -- TODO: if open and has bullets insert round into chamber option
        --context:addOption("* Debug Weapon", item, OnDebugWeapon, playerObj, data, reloadable)
        --context:addOption("* Test Function", item, OnTestFunction, playerObj, data, reloadable)
        --context:addOption("* Reset To Defaults", item, OnResetWeapon, playerObj, data, reloadable)
    end
    

    ---------------------
    if data.currentCapacity ~= nil then
        ---------------------
        -- Check for alternate ammo types so player can set gun to use a specific type
        local ammoType = data.ammoType
        if data.containsClip ~= nil then -- uses a clip, so get the ammoType from the clip
            ammoType = ReloadUtil:getClipData(ammoType).ammoType
        end
        local reloadable = ReloadUtil:getReloadableWeapon(item, player)
        local altTable = ORGMAlternateAmmoTable[ammoType]
        if #altTable > 1 then -- this ammo has alternatives
            -- create the submenu
            local preferredAmmoMenu = context:addOption("Use Only...", item, nil)
            local subMenuAmmo = context:getNew(context)
            context:addSubMenu(preferredAmmoMenu, subMenuAmmo)
            subMenuAmmo:addOption("Any", item, OnSetPreferredAmmo, player, data, reloadable, "any")
            -- add menu for the default ammo type
            subMenuAmmo:addOption("Mixed Load", item, OnSetPreferredAmmo, player, data, reloadable, "mixed")
            -- find all ammo types:
            for _, value in ipairs(altTable) do
                -- need to find the item description
                subMenuAmmo:addOption(getScriptManager():FindItem('ORGM.' .. value):getDisplayName(), item, OnSetPreferredAmmo, player, data, reloadable, value)
            end
        end
        
        ---------------------
        ---------------------
        -- add a 'unload' option
        local isUnloadable = false
        if data.roundChambered ~= nil and data.roundChambered > 0 then
            isUnloadable = true
        elseif data.currentCapacity > 0 then
            isUnloadable = true;
        end

        if isUnloadable then
            context:addOption("Unload", item, OnUnload, playerObj);
        end
    end

end)

