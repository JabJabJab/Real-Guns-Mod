--[[- Various Client Fuctions

    @module ORGM.Client
    @release v3.09
    @author Fenris_Wolf
    @copyright 2018 **File:** client/1LoadOrder/ORGMClient.lua

]]

local ORGM = ORGM
local Client = ORGM.Client
local Firearm = ORGM.Firearm
local loadStaticZomboidModel = loadStaticZomboidModel

--[[- Loads a 3d model. Trigged by OnGameBoot event in `ORGMClientEvents.lua`

@tparam string name the name alias for the model
@tparam[opt] string model the file name. defaults to the name argument if nil.
@tparam[opt] string texture the texture file name. defaults to the name argument if nil.
]]
Client.addModel = function(name, model, texture)
    if not model then model = name end
    if not texture then texture = name end

    local dir = getDir("ORGM")
    local modelPrefix = dir .. "/media/models/weapons_"
    loadStaticZomboidModel("weapons_".. name, modelPrefix .. model .. ".txt", "Objects_".. texture)
end

--[[-Loads all 3d models. Trigged by OnGameBoot Event in client/ORGMClientEventHooks.lua
]]
Client.loadModels = function()

    -- revolvers
    Client.addModel("coltanaconda", "coltanaconda", "coltpython") -- 3.09, credits to Filibuster Rhymes
    Client.addModel('coltpython') -- 3.09, credits to Filibuster Rhymes
    Client.addModel('coltsaa') -- 3.09, credits to Filibuster Rhymes
    Client.addModel('rugalaskan') -- 3.09, credits to Filibuster Rhymes
    Client.addModel('rugblackhawk') -- 3.09, credits to Filibuster Rhymes
    Client.addModel('ruggp100') -- 3.09, credits to Filibuster Rhymes
    Client.addModel('rugredhawk') -- 3.09, credits to Filibuster Rhymes
    Client.addModel('rugsecsix', 'rugsecsix', 'swm10') -- 3.09, credits to Filibuster Rhymes
    Client.addModel('rugblackhawk') -- 3.09, credits to Filibuster Rhymes
    Client.addModel('swm10') -- 3.09, credits to Filibuster Rhymes
    Client.addModel('swm19') -- 3.09, credits to Filibuster Rhymes
    Client.addModel('swm252', 'swm29', 'swm19') -- 3.09, credits to Filibuster Rhymes
    Client.addModel('swm29', 'swm29', 'swm19') -- 3.09, credits to Filibuster Rhymes
    Client.addModel('swm36', 'swm36', 'swm10c') -- 3.09, credits to Filibuster Rhymes
    Client.addModel('swm610', 'swm610', 'swm19c') -- 3.09, credits to Filibuster Rhymes
    Client.addModel('taurusraging') -- 3.09, credits to Filibuster Rhymes

    -- pistols
    Client.addModel("automagv") -- 3.09.2, credits to Filibuster Rhymes
    Client.addModel('bbpistol') -- 3.09.2, credits to Filibuster Rhymes
    Client.addModel('beretta92') -- 3.09, credits to Filibuster Rhymes
    Client.addModel('brenten') -- 3.09.2, credits to Filibuster Rhymes
    Client.addModel('browninghp') -- 3.09, credits to Filibuster Rhymes
    Client.addModel("colt38s", "colt38s", "m1911") -- 3.09.2, credits to Filibuster Rhymes
    Client.addModel("coltdelta") -- 3.09.2, credits to Filibuster Rhymes
    Client.addModel("cz75") -- 3.09.2, credits to Filibuster Rhymes
    Client.addModel("deagle") -- 3.09.2, credits to Filibuster Rhymes
    Client.addModel("deaglexix") -- 3.09.2, credits to Filibuster Rhymes
    Client.addModel('fn57') -- 3.09.2, credits to Filibuster Rhymes
    Client.addModel('glock17') -- 3.09, credits to Filibuster Rhymes
    Client.addModel('glock20', 'glock20', 'glock17') -- 3.09, credits to Filibuster Rhymes
    Client.addModel('glock21', 'glock21', 'glock17') -- 3.09, credits to Filibuster Rhymes
    Client.addModel('glock22', 'glock17', 'glock17') -- 3.09, credits to Filibuster Rhymes
    Client.addModel("hkmk23") -- 3.09.2, credits to Filibuster Rhymes
    Client.addModel("kahrct40") -- 3.09, credits to Filibuster Rhymes
    Client.addModel("kahrp380", "kahrp380", "kahrct40") -- 3.09, credits to Filibuster Rhymes
    Client.addModel('ktp32') -- 3.09.2, credits to Filibuster Rhymes
    Client.addModel('m1911') -- 3.09.2, credits to Filibuster Rhymes
    Client.addModel('rugermkii') -- 3.09.2, credits to Filibuster Rhymes
    Client.addModel('rugersr9', 'rugersr9', "kahrct40") -- 3.09.2, credits to Filibuster Rhymes
    Client.addModel('sigp226') -- 3.09.2, credits to Filibuster Rhymes
    Client.addModel("spr19119", "coltdelta", "m1911") -- 3.09.2, credits to Filibuster Rhymes
    Client.addModel('taurus38', 'sigp226', 'taurus38') -- 3.09.2, credits to Filibuster Rhymes
    Client.addModel("taurusp132", "taurusp132", "kahrct40") -- 3.09.2, credits to Filibuster Rhymes
    Client.addModel('waltherp22') -- 3.09.2, credits to Filibuster Rhymes
    Client.addModel('waltherppk') -- 3.09.2, credits to Filibuster Rhymes
    Client.addModel('xd40', 'glock17', 'xd40') -- 3.09.2, credits to Filibuster Rhymes


    -- smgs
    Client.addModel('am180') -- 3.09.2, credits to Filibuster Rhymes
    Client.addModel('beretta93r') -- 3.09, credits to Filibuster Rhymes
    Client.addModel("fnp90") -- 3.09.2, credits to Filibuster Rhymes
    Client.addModel('glock18c', 'glock17', 'glock18c') -- 3.09, credits to Filibuster Rhymes
    Client.addModel("hkmp5") -- 3.09.2, credits to Filibuster Rhymes
    Client.addModel("hkump") -- 3.09.2, credits to Filibuster Rhymes
    Client.addModel("ktplr", "ktplr", "m16") -- 3.09.2, credits to Filibuster Rhymes
    Client.addModel("kriss") -- 3.09.2, credits to Filibuster Rhymes
    Client.addModel("krissciv", "krissciv", 'kriss') -- 3.09.2, credits to Filibuster Rhymes
    Client.addModel("m1a1") -- 3.09.2, credits to Filibuster Rhymes
    --Client.addModel("m1a1_gold", "m1a1", "m1a1_gold") -- 3.09.2, credits to Filibuster Rhymes
    Client.addModel("mac10") -- 3.09.2, credits to Filibuster Rhymes
    Client.addModel("mac11", "mac11", "mac10") -- 3.09.2, credits to Filibuster Rhymes
    Client.addModel('skorpion') -- 3.09.2, credits to Filibuster Rhymes
    Client.addModel("uzi") -- 3.09.2, credits to Filibuster Rhymes

    -- rifles
    Client.addModel("aiaw308", 'l96', "aiaw308") -- 3.09.2, credits to Filibuster Rhymes
    Client.addModel('akm') -- 3.09, credits to Filibuster Rhymes
    Client.addModel('akmn') -- 3.09, credits to Filibuster Rhymes
    Client.addModel('ar10') -- 3.09, credits to Filibuster Rhymes
    Client.addModel('ar15', 'ar15', 'm16') -- 3.09, credits to Filibuster Rhymes
    Client.addModel("bbgun") -- 3.09.2, credits to Filibuster Rhymes
    Client.addModel("blr") -- 3.09.2, credits to Filibuster Rhymes
    Client.addModel('enfield') -- 3.09, credits to Filibuster Rhymes
    Client.addModel('fnfal') -- 3.09, credits to Filibuster Rhymes
    Client.addModel("garand") -- 3.09.2, credits to Filibuster Rhymes
    Client.addModel("henrybb") -- 3.09.2, credits to Filibuster Rhymes
    Client.addModel("hk91", "hk91") -- 3.09.2, credits to Filibuster Rhymes
    Client.addModel("hkg3") -- 3.09.2, credits to Filibuster Rhymes
    Client.addModel("hksl8") -- 3.09.2, credits to Filibuster Rhymes
    Client.addModel('lsr') -- 3.09, credits to Filibuster Rhymes
    Client.addModel("l96") -- 3.09.2, credits to Filibuster Rhymes
    Client.addModel('m16') -- 3.09, credits to Filibuster Rhymes
    Client.addModel('m1903') -- 3.09, credits to Filibuster Rhymes
    Client.addModel("m21") -- 3.09.2, credits to Filibuster Rhymes
    Client.addModel("m249") -- 3.09.2, credits to Filibuster Rhymes
    Client.addModel('m4c') -- 3.09, credits to Filibuster Rhymes
    Client.addModel("marlin60") -- 3.09.2, credits to Filibuster Rhymes
    Client.addModel('mini14') -- 3.09, credits to Filibuster Rhymes
    Client.addModel('mosin') -- 3.09.2, credits to Filibuster Rhymes
    Client.addModel('r25') -- 3.09, credits to Filibuster Rhymes
    Client.addModel("rem700") -- 3.09.2, credits to Filibuster Rhymes
    Client.addModel("rem788", "rem700", "rem788") -- 3.09.2, credits to Filibuster Rhymes
    Client.addModel("rug1022") -- 3.09.2, credits to Filibuster Rhymes
    Client.addModel("sa80") -- 3.09.2, credits to Filibuster Rhymes
    Client.addModel("sig550") -- 3.09.2, credits to Filibuster Rhymes
    Client.addModel("sig551", "sig551", "sig550") -- 3.09.2, credits to Filibuster Rhymes
    Client.addModel('sks') -- 3.09.2, credits to Filibuster Rhymes
    Client.addModel('sr25') -- 3.09, credits to Filibuster Rhymes
    Client.addModel("svd") -- 3.09.2, credits to Filibuster Rhymes
    Client.addModel("winm70", "rem700", "winm70") -- 3.09.2, credits to Filibuster Rhymes
    Client.addModel("winm94") -- 3.09.2, credits to Filibuster Rhymes

    -- shotguns
    Client.addModel('benellim3') -- 3.09, credits to Filibuster Rhymes
    Client.addModel('benellim3so', 'benellim3so', 'benellim3') -- 3.09, credits to Filibuster Rhymes
    Client.addModel('benellixm1014', 'benellixm1014', 'benellim3') -- 3.09, credits to Filibuster Rhymes
    Client.addModel('hawk982') -- 3.09.2, credits to Filibuster Rhymes
    Client.addModel('ithaca37') -- 3.09, credits to Filibuster Rhymes
    Client.addModel('ithaca37so', 'ithaca37so', 'ithaca37') -- 3.09, credits to Filibuster Rhymes
    Client.addModel('m1216') -- 3.09.2, credits to Filibuster Rhymes
    Client.addModel('moss590') -- 3.09, credits to Filibuster Rhymes
    Client.addModel('moss590a1', 'moss590a1', 'moss590') -- 3.09, credits to Filibuster Rhymes
    Client.addModel('rem870') -- 3.09, credits to Filibuster Rhymes
    Client.addModel('rem870so', 'rem870so', 'rem870') -- 3.09, credits to Filibuster Rhymes
    Client.addModel('silverhawk') -- 3.09.2, credits to Filibuster Rhymes
    Client.addModel('silverhawkso', 'silverhawkso', 'silverhawk') -- 3.09.2, credits to Filibuster Rhymes
    Client.addModel('win1887') -- 3.09.2, credits to Filibuster Rhymes
    Client.addModel('win1887so', 'win1887so', 'win1887') -- 3.09.2, credits to Filibuster Rhymes
    Client.addModel('striker') -- 3.09.2, credits to Filibuster Rhymes
    Client.addModel('spas12') -- 3.09.2, credits to Filibuster Rhymes
    Client.addModel('stevens320', 'stevens320', 'hawk982') -- 3.09.2, credits to Filibuster Rhymes
    Client.addModel('vepr12') -- 3.09.2, credits to Filibuster Rhymes


    ORGM.log(ORGM.INFO, "All 3d models loaded.")
end

--[[-

Called from OnEquipPrimary and OnGameStart in `ORGMClientEvents.lua`

@tparam IsoPlayer player
@tparam HandWeapon item

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

@tparam IsoPlayer player
@tparam HandWeapon item

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
