--[[-
    This file handles all ORGM item context menus.

    @module ORGM.Client.Menu
    @release v3.10
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
local Fire = Reloadable.Fire

local Flags = Firearm.Flags
local Status = Reloadable.Status

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
    local itemData = thisItem:getModData()

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
        subMenuAmmo:addOption(getText("ContextMenu_ORGM_Any"), thisItem, Menu.onSetPreferredAmmo, player, itemData, "any")
        -- add menu for the default ammo type
        subMenuAmmo:addOption(getText("ContextMenu_ORGM_Mixed"), thisItem, Menu.onSetPreferredAmmo, player, itemData, "mixed")
        -- find all ammo types:
        for _, value in ipairs(groupTable) do
            local ammoData = Ammo.getData(value)
            local name = ammoData.instance:getDisplayName()
            subMenuAmmo:addOption(name, thisItem, Menu.onSetPreferredAmmo, player, itemData, value)
        end
    end
end


--[[ ORGM.Client.firearmContextMenu(player, context, item)

builds the context menu for firearms. Note this will return instantly
unless the item is in hand.

]]
Menu.firearm = function()
    if playerObj:getPrimaryHandItem() ~= thisItem then return end

    local thisData = thisItem:getModData()
    local gunData = Firearm.getData(thisItem)

    local reloadable = ReloadUtil:getReloadableWeapon(thisItem, playerID)
    reloadable.playerObj = player -- not sure where this is actually set in the code, but apparently sometimes its not...


    ----------------------------------------------------------------------------
    -- Controls Submenu
    do
        local controlMenu = thisContext:addOption("Controls", thisItem, nil)
        local subMenuControl = thisContext:getNew(thisContext)
        thisContext:addSubMenu(controlMenu, subMenuControl)

        -- hammer actions
        if not Firearm.Trigger.isDAO(thisItem) then -- cant cock/release DAO
            local text = "ContextMenu_ORGM_Cock"
            if Reloadable.Hammer.isCocked(thisItem) then
                text = "ContextMenu_ORGM_Release"
            end
            subMenuControl:addOption(getText(text), thisItem, Menu.onHammerToggle, playerObj, thisData)
        end

        -- add open/close bolt, cylinder etc
        local text = "ContextMenu_ORGM_PartSlide"
        local callback = Menu.onBoltToggle
        if Firearm.isRotary(thisItem, gunData) then
            text = "ContextMenu_ORGM_Cylinder"
            callback = Menu.onCylinderToggle
        elseif Firearm.isBreak(thisItem, gunData) then
            text = "ContextMenu_ORGM_PartBarrel"
            callback = Menu.onBarrelToggle
        elseif Firearm.isBolt(thisItem, gunData) then
            text = "ContextMenu_ORGM_PartBolt"
        end

        if Reloadable.Bolt.isOpen(thisData) then
            subMenuControl:addOption(getText("ContextMenu_ORGM_Close", getText(text)), thisItem, callback, playerObj, thisData)
        else
            subMenuControl:addOption(getText("ContextMenu_ORGM_Open", getText(text)), thisItem, callback, playerObj, thisData)
        end

        --[[
        -- TODO: use v3.10 bit flags
        -- add actionType switching if weapon allows for item (ie: Pump to Semi-Auto)
        if thisData.altActionType then
            for _, atype in ipairs(thisData.altActionType) do
                if atype ~= thisData.actionType then
                    local text = getText("ContextMenu_ORGM_Switch", getText("ContextMenu_ORGM_"..ORGM.ActionTypeStrings[atype]))
                    thisContext:addOption(text, thisItem, Menu.onActionTypeToggle, playerObj, thisData, atype)
                end
            end
        end
        ]]

        -- Select fire switch
        if Firearm.isSelectFire(thisItem) then
            if Firearm.isSemiAuto(thisItem) and not Fire.isSingle(thisData) then
                subMenuControl:addOption(getText("ContextMenu_ORGM_Switch", "ContextMenu_ORGM_Auto"), thisItem, Menu.onFireModeToggle, playerObj, thisData, Status.SINGLESHOT)
            end

            if Firearm.isFullAuto(thisItem) and not Fire.isFullAuto(thisData) then
                subMenuControl:addOption(getText("ContextMenu_ORGM_Switch", "ContextMenu_ORGM_FullAuto"), thisItem, Menu.onFireModeToggle, playerObj, thisData, Status.FULLAUTO)
            end

            if Firearm.is2ShotBurst(thisItem) and not Fire.is2ShotBurst(thisData) then
                subMenuControl:addOption(getText("ContextMenu_ORGM_Switch", "2 Shot Burst"), thisItem, Menu.onFireModeToggle, playerObj, thisData, Status.BURST2)
            end

            if Firearm.is3ShotBurst(thisItem) and not Fire.is3ShotBurst(thisData) then
                subMenuControl:addOption(getText("ContextMenu_ORGM_Switch", "3 Shot Burst"), thisItem, Menu.onFireModeToggle, playerObj, thisData, Status.BURST3)
            end
        end

        if Firearm.hasSafety(thisItem) then
            if Fire.isSafe(thisData) then
                subMenuControl:addOption("Disengage Safety", thisItem, Menu.onFireModeToggle, playerObj, thisData, false)
            else
                subMenuControl:addOption("Engage Safety", thisItem, Menu.onFireModeToggle, playerObj, thisData, true)
            end
        end

    end

    ----------------------------------------------------------------------------
    -- Actions Submenu
    do
        local actionMenu = thisContext:addOption("Actions", thisItem, nil)
        local subMenuAction = thisContext:getNew(thisContext)
        thisContext:addSubMenu(actionMenu, subMenuAction)

        thisContext:addOption(getText("ContextMenu_ORGM_Inspect"), thisItem, Menu.onInspect, playerObj)

        -- TODO: if open and has bullets insert round into chamber option

        if Reloadable.isRotary(thisData) then
            subMenuControl:addOption(getText("ContextMenu_ORGM_Spin"), thisItem, Menu.onSpinCylinder, playerObj, thisData)
        end
        thisContext:addOption(getText("ContextMenu_ORGM_Suicide"), thisItem, Menu.onShootSelf, playerObj, thisData)

    end

    ----------------------------------------------------------------------------
    -- Options Submenu
    do
        local optionMenu = thisContext:addOption("Options", thisItem, nil)
        local subMenuOption = thisContext:getNew(thisContext)
        thisContext:addSubMenu(optionMenu, subMenuOption)
    end


    if Firearm.isLoaded(thisItem) then
        thisContext:addOption(getText("ContextMenu_ORGM_Unload"), thisItem, Menu.onUnload, playerObj)
    end


    if isAdmin() or Settings.Debug then
        local groupTable = Ammo.itemGroup(thisItem, true)
        local debugMenu = thisContext:addOption(getText("ContextMenu_ORGM_Admin"), thisItem, nil)
        local subMenuDebug = thisContext:getNew(thisContext)
        thisContext:addSubMenu(debugMenu, subMenuDebug)
        subMenuDebug:addOption(getText("ContextMenu_ORGM_AdminLoad"), thisItem, Menu.onAdminFillAmmo, playerObj, thisData, groupTable[1])
        subMenuDebug:addOption(getText("ContextMenu_ORGM_AdminDebug"), thisItem, Menu.onDebugWeapon, playerObj, thisData, reloadable)
        subMenuDebug:addOption(getText("ContextMenu_ORGM_AdminReset"), thisItem, Menu.onResetWeapon, playerObj, thisData)

        -- barrel length editor
        local barrelMenu = subMenuDebug:addOption(getText("ContextMenu_ORGM_AdminBarrelLen"), thisItem, nil)
        local subMenuBarrel = subMenuDebug:getNew(subMenuDebug)
        local text = "ContextMenu_ORGM_AdminBarrelLenInches"
        thisContext:addSubMenu(barrelMenu, subMenuBarrel)
        subMenuBarrel:addOption(getText(text, 2), thisItem, Menu.onBarrelEdit, playerObj, thisData, 2)
        subMenuBarrel:addOption(getText(text, 4), thisItem, Menu.onBarrelEdit, playerObj, thisData, 4)
        subMenuBarrel:addOption(getText(text, 6), thisItem, Menu.onBarrelEdit, playerObj, thisData, 6)
        subMenuBarrel:addOption(getText(text, 8), thisItem, Menu.onBarrelEdit, playerObj, thisData, 8)
        subMenuBarrel:addOption(getText(text, 10), thisItem, Menu.onBarrelEdit, playerObj, thisData, 10)
        subMenuBarrel:addOption(getText(text, 12), thisItem, Menu.onBarrelEdit, playerObj, thisData, 12)
        subMenuBarrel:addOption(getText(text, 14), thisItem, Menu.onBarrelEdit, playerObj, thisData, 14)
        subMenuBarrel:addOption(getText(text, 16), thisItem, Menu.onBarrelEdit, playerObj, thisData, 16)
        subMenuBarrel:addOption(getText(text, 18), thisItem, Menu.onBarrelEdit, playerObj, thisData, 18)
        subMenuBarrel:addOption(getText(text, 20), thisItem, Menu.onBarrelEdit, playerObj, thisData, 20)
        subMenuBarrel:addOption(getText(text, 22), thisItem, Menu.onBarrelEdit, playerObj, thisData, 22)
        subMenuBarrel:addOption(getText(text, 24), thisItem, Menu.onBarrelEdit, playerObj, thisData, 24)
        subMenuBarrel:addOption(getText(text, 26), thisItem, Menu.onBarrelEdit, playerObj, thisData, 26)

        local bLengths = Firearm.getData(thisItem).barrelLengthOpt
        if bLengths then
            local barrelMenu = subMenuDebug:addOption(getText("ContextMenu_ORGM_AdminBarrelLen") .. " (factory)", thisItem, nil)
            local subMenuBarrel = subMenuDebug:getNew(subMenuDebug)
            thisContext:addSubMenu(barrelMenu, subMenuBarrel)
            for _, l in ipairs(bLengths) do
                subMenuBarrel:addOption(getText("ContextMenu_ORGM_AdminBarrelLenInches", l), thisItem, Menu.onBarrelEdit, playerObj, thisData, l)
            end
        end

        --[[

        -- skins support
        local skins = Firearm.getData(thisItem).skins
        if skins then
            local skinMenu = subMenuDebug:addOption("Skins", thisItem, nil)
            local subMenuSkins = subMenuDebug:getNew(subMenuDebug)
            thisContext:addSubMenu(skinMenu, subMenuSkins)
            subMenuSkins:addOption("Default", thisItem, Menu.onSkinEdit, playerObj, thisData, nil)
            for _, skin in ipairs(skins) do
                subMenuSkins:addOption(skin, thisItem, Menu.onSkinEdit, playerObj, thisData, skin)
            end
        end
        ]]

    end
    --[[
    -- add debug/development submenu.
    if Settings.Debug == true then
        local debugMenu = thisContext:addOption("DEBUG", thisItem, nil)
        local subMenuDebug = thisContext:getNew(thisContext)
        thisContext:addSubMenu(debugMenu, subMenuDebug)

        subMenuDebug:addOption("* Backwards Compatibility Test", thisItem, Menu.onBackwardsTestFunction, playerObj, thisData)
        subMenuDebug:addOption("* Magazine Overflow Test", thisItem, Menu.onMagOverflowTestFunction, playerObj, thisData)
    end
    ]]
end

--[[

menus specific to magazines

]]
Menu.magazine = function()
    local thisData = thisItem:getModData()
    if thisData.currentCapacity ~= nil and thisData.currentCapacity > 0 then
        thisContext:addOption(getText("ContextMenu_ORGM_Unload"), thisItem, Menu.onUnload, playerObj)
    end
    if isAdmin() or Settings.Debug then
        local groupTable = Ammo.itemGroup(thisItem, true)
        local debugMenu = thisContext:addOption(getText("ContextMenu_ORGM_Admin"), thisItem, nil)
        local subMenuDebug = thisContext:getNew(thisContext)
        thisContext:addSubMenu(debugMenu, subMenuDebug)
        subMenuDebug:addOption(getText("ContextMenu_ORGM_AdminLoad"), thisItem, Menu.onAdminFillAmmo, playerObj, thisData, groupTable[1])
    end
end


--   Context menu callbacks (these can use up to 6 parameters, 7 if you include the target items)
--[[

]]
Menu.onHammerToggle = function(item, playerObj, itemData)
    if Reloadable.Hammer.isCocked(itemData) then
        Reloadable.Hammer.release(itemData, playerObj, true)
    else
        Reloadable.Hammer.cock(itemData, playerObj, true, item)
    end
end

Menu.onBoltToggle = function(item, player, itemData)
    if Reloadable.Bolt.isOpen(itemData) then
        Reloadable.Bolt.close(itemData, player, true, item)
    else
        Reloadable.Bolt.open(itemData, player, true, item)
    end
end

Menu.onCylinderToggle = function(item, player, itemData)
    if Reloadable.Cylinder.isOpen(itemData) then
        Reloadable.Cylinder.close(itemData, player, true, item)
    else
        Reloadable.Cylinder.open(itemData, player, true, item)
    end
end

Menu.onBarrelToggle = function(item, player, itemData)
    if Reloadable.Break.isOpen(itemData) then
        Reloadable.Break.close(itemData, player, true, item)
    else
        Reloadable.Break.open(itemData, player, true, item)
    end
end

Menu.onActionTypeToggle = function(item, player, itemData, newtype)
    player:playSound("ORGMRndLoad", false)
    itemData.actionType = newtype
    Firearm.Stats.set(item)
end

Menu.onFireModeToggle = function(item, player, itemData, newmode)
    Firearm.setFireMode(item, newmode, player)
end

Menu.onSafetyToggle = function(item, player, itemData, newmode)
    Firearm.setSafety(item, newmode, player)
end


Menu.onSpinCylinder = function(item, player, itemData)
    Reloadable.Cylinder.rotate(itemData, 0, player, false, item)
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
        if Firearm.Trigger.isSAO(item) and Reloadable.Hammer.isCocked(reloadable) then
            return -- cant shoot with a SA if its not cocked
        end
        reloadable:fireEmpty(player, item)
        player:playSound(reloadable.clickSound, false)
        if Reloadable.isFeed(reloadable, Flags.ROTARY) and reloadable.currentCapacity > 0 then
            if player:HasTrait("Desensitized") ~= true then player:getStats():setPanic(95) end
            local boredom = player:getBodyDamage():getBoredomLevel()
            boredom = boredom - 20
            if boredom < 0 then boredom = 0 end
            player:getBodyDamage():setBoredomLevel(boredom)
            player:getStats():setIdleboredom(0)
        end
    end
end

Menu.onShootSelf = function(item, player, itemData)
    local modal = ISModalDialog:new(0,0, 250, 150, getText("IGUI_Firearm_SuicideConfirm"), true, nil, Menu.onShootSelfConfirm, player:getPlayerNum(), player, item);
    modal:initialise()
    modal:addToUIManager()
    if JoypadState.players[player:getPlayerNum()+1] then
        setJoypadFocus(player:getPlayerNum(), modal)
    end
end

Menu.onSetPreferredAmmo = function(item, player, itemData, value)
    itemData.preferredAmmoType = value
end

Menu.onInspect = function(item, playerObj)
    Client.InspectionWindow:setFirearm(item)
    Client.InspectionWindow:setVisible(true)
end


Menu.onDebugWeapon = function(item, player, itemData, reloadable)
    reloadable:printWeaponDetails(item)
    reloadable:printReloadableWeaponDetails() -- debug itemData
end

-- test for backwards  compatibility function: item update
Menu.onBackwardsTestFunction = function(item, player, itemData)
    itemData.BUILD_ID = 1

    if not Firearm.getData(item).lastChanged then
        player:Say('No listed changes for item, but setting BUILD_ID to 1 anyways.')
        return
    end
    player:Say('BUILD_ID set to 1, unequip and re-equip to test backwards compatibility function.')
end

-- test to validate magazine overflow checking works (mag has more ammo then it should)
Menu.onMagOverflowTestFunction = function(item, player, itemData)
    local ammoType = itemData.ammoType
    if itemData.containsClip ~= nil then -- uses a clip, so get the ammoType from the clip
        ammoType = ReloadUtil:getClipData(ammoType).ammoType
    end
    ammoType = Ammo.getGroup(ammoType)[1]
    itemData.currentCapacity = itemData.maxCapacity + 10
    for i=1, itemData.currentCapacity do
        itemData.magazineData[i] = ammoType
    end
    itemData.loadedAmmo = ammoType
end

-- reset weapon to defaults
Menu.onResetWeapon = function(item, player, itemData)
    Firearm.setup(Firearm.getData(item), item)
    player:Say("weapon reset")
end

-- fill the gun/magazine to max ammo
Menu.onAdminFillAmmo = function(item, player, itemData, ammoType)
    itemData.currentCapacity = itemData.maxCapacity
    for i=1, itemData.maxCapacity do
        itemData.magazineData[i] = ammoType
    end
    itemData.loadedAmmo = ammoType
end

Menu.onBarrelEdit = function(item, player, itemData, length)
    itemData.barrelLength = length
    Firearm.Stats.set(item)
end

Menu.onSkinEdit = function(item, player, itemData, skin)
    itemData.skin = skin
    Firearm.Stats.set(item)
end
