--[[-
    This file handles all ORGM item context menus.

    @module ORGM.Client.Menu
    @release v3.09
    @author Fenris_Wolf
    @copyright 2018 **File:** client/1LoadOrder/ORGMClientMenus.lua
]]

local ORGM = ORGM
local Client = ORGM.Client
local Menu = ORGM.Client.Menu
local Settings = ORGM.Settings

local Firearm = ORGM.Firearm
local Ammo = ORGM.Ammo
local Magazine = ORGM.Magazine
local Reloadable = ORGM.ReloadableWeapon

local getSpecificPlayer = getSpecificPlayer
local isAdmin = isAdmin
local getText = getText
local instanceof = instanceof

local playerID = nil
local playerObj = nil
local thisContext = nil
local allStacks = nil
local thisStack = nil
local thisItem = nil


--[[- Builds the initial right click context menu for inventory items.

This is called by `ORGM.Client.Callbacks.inventoryMenu` in response to a
OnFillInventoryObjectContextMenu event.

@tparam int player
@tparam table context
@tparam ItemStack items

]]
Menu.inventory = function(player, context, items)
    thisContext = context
    playerID = player
    playerObj = getSpecificPlayer(player)
    allStacks = items
    thisStack = items
    thisItem = allStacks[1]
    if not instanceof(thisItem, "InventoryItem") then
        thisStack = allStacks[1].items
        thisItem = thisStack[1]
    end

    if playerObj:getInventory():contains(thisItem) == false then return end
    local modData = thisItem:getModData()

    -- build menus
    if Firearm.isFirearm(thisItem) then
        Menu.firearm()
    elseif Magazine.isMagazine(thisItem) then
        Menu.magazine()
    else
        return
    end


    -- Check for alternate ammo types so player can set gun to use a specific type
    local groupTable = Ammo.itemGroup(thisItem, true)
    --local reloadable = ReloadUtil:getReloadableWeapon(thisItem, player)
    if #groupTable > 1 then -- this ammo has alternatives
        -- create the submenu
        local preferredAmmoMenu = context:addOption(getText("ContextMenu_ORGM_UseOnly"), thisItem, nil)
        local subMenuAmmo = context:getNew(context)
        context:addSubMenu(preferredAmmoMenu, subMenuAmmo)
        subMenuAmmo:addOption(getText("ContextMenu_ORGM_Any"), thisItem, Menu.onSetPreferredAmmo, player, modData, "any")
        -- add menu for the default ammo type
        subMenuAmmo:addOption(getText("ContextMenu_ORGM_Mixed"), thisItem, Menu.onSetPreferredAmmo, player, modData, "mixed")
        -- find all ammo types:
        for _, value in ipairs(groupTable) do
            local ammoData = Ammo.getData(value)
            local name = ammoData.instance:getDisplayName()
            subMenuAmmo:addOption(name, thisItem, Menu.onSetPreferredAmmo, player, modData, value)
        end
    end
end


--[[ ORGM.Client.firearmContextMenu(player, context, item)

builds the context menu for firearms. Note this will return instantly
unless the item is in hand.

]]
Menu.firearm = function()
    if playerObj:getPrimaryHandItem() ~= thisItem then return end

    local modData = thisItem:getModData()
    local reloadable = ReloadUtil:getReloadableWeapon(thisItem, playerID)
    reloadable.playerObj = player -- not sure where this is actually set in the code, but apparently sometimes its not...


    thisContext:addOption(getText("ContextMenu_ORGM_Inspect"), thisItem, Menu.onInspect, playerObj)

    -- hammer actions
    if not Firearm.Hammer.isDAO(thisItem) then -- cant cock/release DAO
        local text = "ContextMenu_ORGM_Cock"
        if Firearm.Hammer.isCocked(thisItem) then
            text = "ContextMenu_ORGM_Release"
        end
        thisContext:addOption(getText(text), thisItem, Menu.onHammerToggle, playerObj, modData, reloadable)
    end


    -- add open/close bolt, cylinder etc
    local text = "ContextMenu_ORGM_PartSlide"
    local callback = Menu.onBoltToggle
    if modData.actionType == ORGM.ROTARY then
        text = "ContextMenu_ORGM_Cylinder"
        callback = Menu.onCylinderToggle
    elseif modData.actionType == ORGM.BREAK then
        text = "ContextMenu_ORGM_PartBarrel"
        callback = Menu.onBarrelToggle
    elseif modData.actionType == ORGM.BOLT then
        text = "ContextMenu_ORGM_PartBolt"
    end
    if modData.isOpen == 1 then
        thisContext:addOption(getText("ContextMenu_ORGM_Close", getText(text)), thisItem, callback, playerObj, modData, reloadable)
    elseif modData.isOpen == 0 then
        thisContext:addOption(getText("ContextMenu_ORGM_Open", getText(text)), thisItem, callback, playerObj, modData, reloadable)
    end


    -- add actionType switching if weapon allows for item (ie: Pump to Semi-Auto)
    if modData.altActionType then
        for _, atype in ipairs(modData.altActionType) do
            if atype ~= modData.actionType then
                local text = getText("ContextMenu_ORGM_Switch", getText("ContextMenu_ORGM_"..ORGM.ActionTypeStrings[atype]))
                thisContext:addOption(text, thisItem, Menu.onActionTypeToggle, playerObj, modData, reloadable, atype)
            end
        end
    end

    -- switch fire mode option (semi to full auto)
    if Firearm.isSelectFire(thisItem) then
        local text = getText("ContextMenu_ORGM_FullAuto")
        local mode = 1
        if Firearm.isFullAuto(thisItem) then
            text = getText("ContextMenu_ORGM_Auto")
            mode = 0
        end
        thisContext:addOption(getText("ContextMenu_ORGM_Switch", text), thisItem, Menu.onFireModeToggle, playerObj, modData, reloadable, mode)
    end

    if modData.actionType == ORGM.ROTARY then
        thisContext:addOption(getText("ContextMenu_ORGM_Spin"), thisItem, Menu.onSpinCylinder, playerObj, modData, reloadable)
    end

    if Firearm.isLoaded(thisItem) then
        thisContext:addOption(getText("ContextMenu_ORGM_Unload"), thisItem, Menu.onUnload, playerObj)
    end

    thisContext:addOption(getText("ContextMenu_ORGM_Suicide"), thisItem, Menu.onShootSelf, playerObj, modData, reloadable)
    -- TODO: if open and has bullets insert round into chamber option

    if isAdmin() or Settings.Debug then
        local groupTable = Ammo.itemGroup(thisItem, true)
        local debugMenu = thisContext:addOption(getText("ContextMenu_ORGM_Admin"), thisItem, nil)
        local subMenuDebug = thisContext:getNew(thisContext)
        thisContext:addSubMenu(debugMenu, subMenuDebug)
        subMenuDebug:addOption(getText("ContextMenu_ORGM_AdminLoad"), thisItem, Menu.onAdminFillAmmo, playerObj, modData, groupTable[1])
        subMenuDebug:addOption(getText("ContextMenu_ORGM_AdminDebug"), thisItem, Menu.onDebugWeapon, playerObj, modData, reloadable)
        subMenuDebug:addOption(getText("ContextMenu_ORGM_AdminReset"), thisItem, Menu.onResetWeapon, playerObj, modData, reloadable)

        -- barrel length editor
        local barrelMenu = subMenuDebug:addOption(getText("ContextMenu_ORGM_AdminBarrelLen"), thisItem, nil)
        local subMenuBarrel = subMenuDebug:getNew(subMenuDebug)
        local text = "ContextMenu_ORGM_AdminBarrelLenInches"
        thisContext:addSubMenu(barrelMenu, subMenuBarrel)
        subMenuBarrel:addOption(getText(text, 2), thisItem, Menu.onBarrelEdit, playerObj, modData, 2)
        subMenuBarrel:addOption(getText(text, 4), thisItem, Menu.onBarrelEdit, playerObj, modData, 4)
        subMenuBarrel:addOption(getText(text, 6), thisItem, Menu.onBarrelEdit, playerObj, modData, 6)
        subMenuBarrel:addOption(getText(text, 8), thisItem, Menu.onBarrelEdit, playerObj, modData, 8)
        subMenuBarrel:addOption(getText(text, 10), thisItem, Menu.onBarrelEdit, playerObj, modData, 10)
        subMenuBarrel:addOption(getText(text, 12), thisItem, Menu.onBarrelEdit, playerObj, modData, 12)
        subMenuBarrel:addOption(getText(text, 14), thisItem, Menu.onBarrelEdit, playerObj, modData, 14)
        subMenuBarrel:addOption(getText(text, 16), thisItem, Menu.onBarrelEdit, playerObj, modData, 16)
        subMenuBarrel:addOption(getText(text, 18), thisItem, Menu.onBarrelEdit, playerObj, modData, 18)
        subMenuBarrel:addOption(getText(text, 20), thisItem, Menu.onBarrelEdit, playerObj, modData, 20)
        subMenuBarrel:addOption(getText(text, 22), thisItem, Menu.onBarrelEdit, playerObj, modData, 22)
        subMenuBarrel:addOption(getText(text, 24), thisItem, Menu.onBarrelEdit, playerObj, modData, 24)
        subMenuBarrel:addOption(getText(text, 26), thisItem, Menu.onBarrelEdit, playerObj, modData, 26)

        local bLengths = Firearm.getData(thisItem).barrelLengthOpt
        if bLengths then
            local barrelMenu = subMenuDebug:addOption(getText("ContextMenu_ORGM_AdminBarrelLen") .. " (factory)", thisItem, nil)
            local subMenuBarrel = subMenuDebug:getNew(subMenuDebug)
            thisContext:addSubMenu(barrelMenu, subMenuBarrel)
            for _, l in ipairs(bLengths) do
                subMenuBarrel:addOption(getText("ContextMenu_ORGM_AdminBarrelLenInches", l), thisItem, Menu.onBarrelEdit, playerObj, modData, l)
            end
        end

        --[[

        -- skins support
        local skins = Firearm.getData(thisItem).skins
        if skins then
            local skinMenu = subMenuDebug:addOption("Skins", thisItem, nil)
            local subMenuSkins = subMenuDebug:getNew(subMenuDebug)
            thisContext:addSubMenu(skinMenu, subMenuSkins)
            subMenuSkins:addOption("Default", thisItem, Menu.onSkinEdit, playerObj, modData, nil)
            for _, skin in ipairs(skins) do
                subMenuSkins:addOption(skin, thisItem, Menu.onSkinEdit, playerObj, modData, skin)
            end
        end
        ]]

    end
    -- add debug/development submenu.
    if Settings.Debug == true then
        local debugMenu = thisContext:addOption("DEBUG", thisItem, nil)
        local subMenuDebug = thisContext:getNew(thisContext)
        thisContext:addSubMenu(debugMenu, subMenuDebug)

        subMenuDebug:addOption("* Backwards Compatibility Test", thisItem, Menu.onBackwardsTestFunction, playerObj, modData, reloadable)
        subMenuDebug:addOption("* Magazine Overflow Test", thisItem, Menu.onMagOverflowTestFunction, playerObj, modData)
    end
end

--[[

menus specific to magazines

]]
Menu.magazine = function()
    local modData = thisItem:getModData()
    if modData.currentCapacity ~= nil and modData.currentCapacity > 0 then
        thisContext:addOption(getText("ContextMenu_ORGM_Unload"), thisItem, Menu.onUnload, playerObj)
    end
    if isAdmin() or Settings.Debug then
        local groupTable = Ammo.itemGroup(thisItem, true)
        local debugMenu = thisContext:addOption(getText("ContextMenu_ORGM_Admin"), thisItem, nil)
        local subMenuDebug = thisContext:getNew(thisContext)
        thisContext:addSubMenu(debugMenu, subMenuDebug)
        subMenuDebug:addOption(getText("ContextMenu_ORGM_AdminLoad"), thisItem, Menu.onAdminFillAmmo, playerObj, modData, groupTable[1])
    end
end


--   Context menu callbacks (these can use up to 6 parameters, 7 if you include the target items)
--[[

]]
Menu.onHammerToggle = function(item, playerObj, modData, reloadable)
    if modData.hammerCocked == 1 then
        Reloadable.Hammer.release(modData, playerObj, true)
        --reloadable:releaseHammer(player, true)
    else
        Reloadable.Hammer.cock(modData, playerObj, true, thisItem)
        --reloadable:cockHammer(player, true, item)
    end
    --reloadable:syncReloadableToItem(item)
end

Menu.onBoltToggle = function(item, player, modData, reloadable)
    if reloadable.isOpen == 1 then
        reloadable:closeSlide(player, true, item)
    else
        reloadable:openSlide(player, true, item)
    end
    reloadable:syncReloadableToItem(item)
end

Menu.onCylinderToggle = function(item, player, modData, reloadable)
    if reloadable.isOpen == 1 then
        reloadable:closeCylinder(player, true, item)
    else
        reloadable:openCylinder(player, true, item)
    end
    reloadable:syncReloadableToItem(item)
end

Menu.onBarrelToggle = function(item, player, modData, reloadable)
    if modData.isOpen == 1 then
        Reloadable.Break.open(modData, playerObj, true, item)
        --reloadable:openBreak(player, true, item)
    else
        Reloadable.Break.close(modData, playerObj, true, item)
        --reloadable:closeBreak(player, true, item)
    end
    --reloadable:syncReloadableToItem(item)
end

Menu.onActionTypeToggle = function(item, player, modData, reloadable, newtype)
    player:playSound("ORGMRndLoad", false)
    modData.actionType = newtype
    Firearm.Stats.set(item)
end

Menu.onFireModeToggle = function(item, player, modData, reloadable, newmode)
    Firearm.toggleFireMode(item, newmode, player)
end

Menu.onSpinCylinder = function(item, player, modData, reloadable)
    reloadable:rotateCylinder(0, player, false, item)
    reloadable:syncReloadableToItem(item)
end

Menu.onUnload = function(item, player)
    ReloadManager[player:getPlayerNum()+1]:startUnloadFromUi(item)
end

Menu.onShootSelfConfirm = function(this, button, player, item)
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

Menu.onShootSelf = function(item, player, modData, reloadable)
    local modal = ISModalDialog:new(0,0, 250, 150, getText("IGUI_Firearm_SuicideConfirm"), true, nil, Menu.onShootSelfConfirm, player:getPlayerNum(), player, item);
    modal:initialise()
    modal:addToUIManager()
    if JoypadState.players[player:getPlayerNum()+1] then
        setJoypadFocus(player:getPlayerNum(), modal)
    end
end

Menu.onSetPreferredAmmo = function(item, player, modData, value)
    modData.preferredAmmoType = value
    --reloadable.preferredAmmoType = value
    --reloadable:syncReloadableToItem(item)

end

Menu.onInspect = function(item, playerObj)
    Client.InspectionWindow:setFirearm(item)
    Client.InspectionWindow:setVisible(true)
end


Menu.onDebugWeapon = function(item, player, modData, reloadable)
    reloadable:printWeaponDetails(item)
    reloadable:printReloadableWeaponDetails() -- debug modData
end

-- test for backwards  compatibility function: item update
Menu.onBackwardsTestFunction = function(item, player, modData, reloadable)
    modData.BUILD_ID = 1

    if not Firearm.getData(item).lastChanged then
        player:Say('No listed changes for item, but setting BUILD_ID to 1 anyways.')
        return
    end
    player:Say('BUILD_ID set to 1, unequip and re-equip to test backwards compatibility function.')
end

-- test to validate magazine overflow checking works (mag has more ammo then it should)
Menu.onMagOverflowTestFunction = function(item, player, modData)
    local ammoType = modData.ammoType
    if modData.containsClip ~= nil then -- uses a clip, so get the ammoType from the clip
        ammoType = ReloadUtil:getClipData(ammoType).ammoType
    end
    ammoType = Ammo.getGroup(ammoType)[1]
    modData.currentCapacity = modData.maxCapacity + 10
    for i=1, modData.currentCapacity do
        modData.magazineData[i] = ammoType
    end
    modData.loadedAmmo = ammoType
end

-- reset weapon to defaults
Menu.onResetWeapon = function(item, player, modData, reloadable)
    Firearm.setup(Firearm.getData(item), item)
    player:Say("weapon reset")
end

-- fill the gun/magazine to max ammo
Menu.onAdminFillAmmo = function(item, player, modData, ammoType)
    modData.currentCapacity = modData.maxCapacity
    for i=1, modData.maxCapacity do
        modData.magazineData[i] = ammoType
    end
    modData.loadedAmmo = ammoType
end

Menu.onBarrelEdit = function(item, player, modData, length)
    modData.barrelLength = length
    Firearm.Stats.set(item)
end

Menu.onSkinEdit = function(item, player, modData, skin)
    modData.skin = skin
    Firearm.Stats.set(item)
end
