--[[- Various Client Fuctions

    @module ORGM.Client
    @release v3.09
    @author Fenris_Wolf
    @copyright 2018 **File:** client/1LoadOrder/ORGMClient.lua

]]

local ORGM = ORGM
local Client = ORGM.Client
local Firearm = ORGM.Firearm

--[[- Loads a 3d model. Trigged by OnGameBoot event in `ORGMClientEvents.lua`
]]
Client.addModel = function(name, model, texture)
    if not model then model = name end
    if not texture then texture = name end

    local dir = getDir("ORGM")
    local modelPrefix = dir .. "/media/models/weapons_"
    local texturePrefix = dir .. "/media/textures/Objects_"
    loadStaticZomboidModel("weapons_".. name, modelPrefix .. model .. ".txt", texturePrefix .. texture .. ".png")
end

--[[-Loads all 3d models. Trigged by OnGameBoot Event in client/ORGMClientEventHooks.lua
]]
Client.loadModels = function()

    Client.addModel('shotgun', 'shotgun', 'Shotgun')
    Client.addModel('shotgunsawn', 'shotgunsawn', 'ShotgunSawn')
    Client.addModel('shotgunblack', 'shotgunblack', 'Shotgun_Black')
    Client.addModel('shotgunsawnblack', 'shotgunsawnblack', 'ShotgunSawn_Black')

    Client.addModel('anaconda') -- new
    Client.addModel('python') -- new
    Client.addModel('model19bwg')
    Client.addModel('model19cwg')
    Client.addModel('model19cbg')
    Client.addModel('revolverlarge')

    Client.addModel('beretta92') -- new
    Client.addModel('coltcommander') -- new
    Client.addModel('deltaelite') -- new
    Client.addModel('deagle44') -- new
    Client.addModel('deaglexix') -- new
    Client.addModel('fn57') -- new
    Client.addModel('glock') -- new, replaces all glocks
    Client.addModel('m1911') -- new
    Client.addModel('sfield19119') -- new
    Client.addModel('ppk') -- new
    Client.addModel('sfieldxd') -- new
    Client.addModel('rugermkii')


    Client.addModel('henry')
    Client.addModel('fnfal')
    Client.addModel('hk91') -- new, replaces g3
    Client.addModel('sl8') -- new
    Client.addModel('m249') -- new
    Client.addModel('m14') -- updated
    Client.addModel('mini14')
    Client.addModel('mosin') -- new
    Client.addModel('sks') -- updated
    Client.addModel('r700') -- new
    Client.addModel('sa80') -- updated
    Client.addModel('sig551') -- new


    Client.addModel('l96') -- new
    Client.addModel('m16') -- updated, replaces M16, M4, AR10, AR15, SR25
    Client.addModel('kalash') -- updated
    Client.addModel('garand') -- new
    Client.addModel('svd') -- updated


    Client.addModel('m1216') -- new
    Client.addModel('super90') -- new
    Client.addModel('r870') -- new
    Client.addModel('silver') -- new
    Client.addModel('striker') -- new
    Client.addModel('stevens') -- new
    Client.addModel('spas12')


    Client.addModel('kriss')
    Client.addModel('krissciv')
    Client.addModel('mp5') -- updated
    Client.addModel('mac10') -- new
    Client.addModel('mac11') -- new
    Client.addModel('p90')
    Client.addModel('skorpion') -- new
    Client.addModel('ump') -- updated
    Client.addModel('uzi') -- updated

    ORGM.log(ORGM.INFO, "All 3d models loaded.")
end

--[[-

Called from OnEquipPrimary and OnGameStart in `ORGMClientEvents.lua`

]]
Client.getFirearmNeedsUpdate = function(player, item)
    if item == nil or player == nil then return end
    if not player:isLocalPlayer() then return end
    if not Firearm.isFirearm(item) then return end

    ORGM.log(ORGM.DEBUG, "Checking BUILD_ID for ".. item:getType())

    Firearm.Stats.set(item)
    if Firearm.needsUpdate(item) then
        player:Say("Resetting this weapon to defaults due to ORGM changes. Ammo returned to inventory.")
        Client.unequipItemNow(player, item)
        local newItem = Firearm.replace(item, player:getInventory())
        player:setPrimaryHandItem(newItem)
        if newItem:isRequiresEquippedBothHands() then
            player:setSecondaryHandItem(newItem)
        end
        ISInventoryPage.dirtyUI()
    end
end


--[[- Instantly unequip the item if it's in the player's primary hand, skipping timed actions.

Used by Client.getFirearmNeedsUpdate() above when upgrading weapons to new ORGM versions.

]]
Client.unequipItemNow = function(player, item)
    item:getContainer():setDrawDirty(true)
    local primary = player:getPrimaryHandItem()
    local secondary = player:getSecondaryHandItem()
    if item == primary then
        player:setPrimaryHandItem(nil)
    end
    if item == secondary then
        player:setSecondaryHandItem(nil)
    end
    getPlayerData(player:getPlayerNum()).playerInventory:refreshBackpacks()
end
