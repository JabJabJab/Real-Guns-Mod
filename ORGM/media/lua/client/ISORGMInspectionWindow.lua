--[[-

@classmod ISORGMInspectionWindow
@author Fenris_Wolf
@release 3.09
@copyright 2018 **File:** client/ISORGMInspectionWindow.lua

]]
-------------------------------------------------------------------------------------------
local ORGM = ORGM
local Ammo = ORGM.Ammo
local Firearm = ORGM.Firearm
local Settings = ORGM.Settings

local getText = getText
local getPlayer = getPlayer
local string = string
local tostring = tostring
local Perks = Perks


local InfoPanel = ISPanelJoypad:derive("InfoPanel")

function InfoPanel:new(x, y, width, height)
    local o = ISPanelJoypad:new(x, y, width, height)
    setmetatable(o, self)
    o:noBackground()
    o.__index = self
    o.resizable = false
    return o
end

function InfoPanel:createChildren()
    self.textPanel = ISRichTextPanel:new(8, 16, self.width-16, self.height-24)
    self.textPanel:initialise()
    self.textPanel.autosetheight = false
    self.textPanel:ignoreHeightChange()
    self:addChild(self.textPanel)
end

function InfoPanel:updateFirearm(item)
    if not item then return end
    local gunData = Firearm.getData(item)
    if not gunData then
        self.textPanel.text = ""
        self.textPanel:paginate()
        return
    end

    local text = " <RED> <CENTER> ".. item:getDisplayName() .. " <LINE> <LEFT> <TEXT> <LINE> "
    text = text .. getText("IGUI_Firearm_InfoPanel", getText(gunData.classification), (gunData.year or getText("IGUI_Firearm_YearUnknown")), getText(gunData.country), getText(gunData.manufacturer))

    text = text .. getText("IGUI_Firearm_InfoBackGround")
    text = text .. getText(gunData.description) .. " <LINE> <LINE> "
    self.textPanel.text = text
    self.textPanel:paginate()
end

-------------------------------------------------------------------------------------------
local DetailsPanel = ISPanelJoypad:derive("DetailsPanel")

function DetailsPanel:new(x, y, width, height)
    local o = ISPanelJoypad:new(x, y, width, height)
    setmetatable(o, self)
    o:noBackground()
    o.__index = self
    o.resizable = false
    return o
end

function DetailsPanel:createChildren()
    self.textPanel = ISRichTextPanel:new(8, 16, self.width-16, self.height-24)
    self.textPanel:initialise()
    self.textPanel.autosetheight = false
    self.textPanel:ignoreHeightChange()
    self:addChild(self.textPanel)
end

function DetailsPanel:updateFirearm(item)
    local gunData = Firearm.getData(item)
    if not gunData then
        self.textPanel.text = ""
        self.textPanel:paginate()
        return
    end
    local modData = item:getModData()
    local text = " <RED> <CENTER> ".. item:getDisplayName() .. " <LINE> <LEFT> <TEXT> <LINE> "

    if modData.selectFire then
        local mode = "IGUI_Firearm_DetailSemi"
        if modData.selectFire == ORGM.FULLAUTOMODE then mode = "IGUI_Firearm_DetailFull" end
        text = text .. getText("IGUI_Firearm_DetailMode", getText(mode))
    end
    text = text .. getText("IGUI_Firearm_DetailBarrelLength", (modData.barrelLength or gunData.barrelLength))
    local feed = "slide"
    if modData.actionType == ORGM.ROTARY then feed = "cylinder" end
    if modData.actionType == ORGM.BOLT then feed = "bolt" end
    if modData.actionType == ORGM.BREAK then feed = "breech" end
    if modData.isOpen == 1 then
        text = text .. getText("IGUI_Firearm_DetailOpen", getText("IGUI_Firearm_"..feed))
    else
        text = text .. getText("IGUI_Firearm_DetailClosed", getText("IGUI_Firearm_"..feed))
    end

    if modData.containsClip == 1 then
        text = text .. getText("IGUI_Firearm_DetailInserted")
    elseif modData.containsClip == 0 then
        text = text .. getText("IGUI_Firearm_DetailEjected")
    end
    if modData.actionType ~= ORGM.DOUBLEACTIONONLY then
        if modData.hammerCocked == 1 then
            text = text .. getText("IGUI_Firearm_DetailCocked")
        else
            text = text .. getText("IGUI_Firearm_DetailRest")
        end
    end

    local loaded = "IGUI_Firearm_DetailEmpty"
    if modData.actionType == ORGM.ROTARY then
        if modData.currentCapacity > 0 then
            loaded = "IGUI_Firearm_DetailLoadedCylinder"
        end
    elseif modData.actionType == ORGM.BREAK then
        if modData.currentCapacity > 1 then
            loaded = "IGUI_Firearm_DetailLoaded2"
        elseif modData.currentCapacity == 1 then
            loaded = "IGUI_Firearm_DetailLoaded1"
        end
    else
        if modData.roundChambered > 0 then
            loaded = "IGUI_Firearm_DetailRoundChambered"
        elseif modData.emptyShellChambered > 0 then
            loaded = "IGUI_Firearm_DetailShellChambered"
        else
            loaded = "IGUI_Firearm_DetailEmptyChamber"
        end
    end
    text = text .. getText(loaded)


    if modData.isJammed then
        text = text .. getText("IGUI_Firearm_DetailJammed")
    end

    local condition = item:getCondition() / item:getConditionMax()
    if condition == 1 then
        condition = 10
    elseif condition >= 0.9 then
        condition = 9
    elseif condition >= 0.7 then
        condition = 7
    elseif condition >= 0.5 then
        condition = 5
    elseif condition >= 0.4 then
        condition = 4
    elseif condition >= 0.3 then
        condition = 3
    elseif condition >= 0.2 then
        condition = 2
    elseif condition < 0 then
        condition = 1
    elseif condition == 0 then
        condition = 0
    end
    text = text .. getText("IGUI_Firearm_DetailCondition"..condition)

    if modData.roundsFired then
        text = text .. getText("IGUI_Firearm_DetailRoundsFired", modData.roundsFired)
    end
    --if modData.roundsSinceCleaned then
    --    text = text .. getText("IGUI_Firearm_DetailRoundsSinceCleaned", modData.roundsSinceCleaned)
    --end

    if item:getCanon() then
        text = text.. getText("IGUI_Firearm_DetailAttach1", item:getCanon():getDisplayName())
    end
    if item:getClip() then
        text = text.. getText("IGUI_Firearm_DetailAttach2", item:getClip():getDisplayName())
    end
    if item:getScope() then
        text = text.. getText("IGUI_Firearm_DetailAttach3", item:getScope():getDisplayName())
    end
    if item:getStock() then
        text = text.. getText("IGUI_Firearm_DetailAttach4", item:getStock():getDisplayName())
    end
    if item:getSling() then
        text = text.. getText("IGUI_Firearm_DetailAttach3", item:getSling():getDisplayName())
    end
    if item:getRecoilpad() then
        text = text.. getText("IGUI_Firearm_DetailAttach4", item:getRecoilpad():getDisplayName())
    end
    if modData.serialnumber == nil then
        text = text.. getText("IGUI_Firearm_DetailNoSerial")
    else
        text = text.. getText("IGUI_Firearm_DetailSerial", modData.serialnumber)
    end

    self.textPanel.text = text
    self.textPanel:paginate()

end

-------------------------------------------------------------------------------------------
local StatPanel = ISPanelJoypad:derive("StatPanel")

function StatPanel:new(x, y, width, height)
    local o = ISPanelJoypad:new(x, y, width, height)
    setmetatable(o, self)
    o:noBackground()
    o.__index = self
    o.resizable = false
    return o
end

function StatPanel:createChildren()
    self.textPanel = ISRichTextPanel:new(8, 16, self.width-16, self.height-24)
    self.textPanel:initialise()
    self.textPanel.autosetheight = false
    self.textPanel:ignoreHeightChange()
    self:addChild(self.textPanel)
end



function StatPanel:updateFirearm(item)
    local def = Firearm.getData(item)
    if not def then
        self.textPanel.text = ""
        self.textPanel:paginate()
        return
    end
    local data = item:getModData()
    local text = " <RED> <CENTER> ".. item:getDisplayName() .. " <LINE> <LEFT> <TEXT> <LINE> "
    local player = getPlayer()


    text = text .. getText("IGUI_Firearm_StatDetail", string.format("%.3f", item:getActualWeight()))

    if data.selectFire then
        local mode = "IGUI_Firearm_DetailSemi"
        if data.selectFire == ORGM.FULLAUTOMODE then mode = "IGUI_Firearm_DetailFull" end
        text = text .. getText("IGUI_Firearm_DebugMode", getText(mode))
    end
    text = text .. getText("IGUI_Firearm_StatDetail2", getText("IGUI_Firearm_ActionType" .. data.actionType), getText("IGUI_Firearm_TriggerType".. data.triggerType))
    text = text .." <LINE> "
    local capacity = ""
    if data.roundChambered ~= nil then
        if data.roundChambered == 0 and data.emptyShellChambered ~= 0 then
            capacity = "+x"
        else
            capacity = "+" .. data.roundChambered
        end
    end
    capacity = tostring(data.currentCapacity) .. capacity .. "/"..tostring(data.maxCapacity)

    local lastRound = data.lastRound
    if lastRound then
        local ammoData = Ammo.getData(lastRound)
        if ammoData then lastRound = (ammoData.instance:getDisplayName() or lastRound) end
        --if ammoData then lastRound = (ammoData.DisplayName or lastRound) .." " .. (ammoData.RoundType or "Round") end
    else
        lastRound = getText("IGUI_Firearm_None") --"None"
    end

    local loadedAmmo = data.loadedAmmo
    if not loadedAmmo then loadedAmmo =  getText("IGUI_Firearm_Empty") end
    if loadedAmmo == 'mixed' then
        loadedAmmo = getText("IGUI_Firearm_AmmoMixed")
    else
        local ammoData = Ammo.getData(loadedAmmo)
        if ammoData then loadedAmmo = (ammoData.instance:getDisplayName() or loadedAmmo) end
        --if ammoData then  loadedAmmo = (ammoData.DisplayName or loadedAmmo) .." " ..(ammoData.RoundType or "Round") .."s" end
    end

    local preferredAmmoType = data.preferredAmmoType
    if not preferredAmmoType or preferredAmmoType == 'any' then
       preferredAmmoType = getText("IGUI_Firearm_None")
    elseif preferredAmmoType == 'mixed' then
        preferredAmmoType = getText("IGUI_Firearm_AmmoMixed")
    else
        local ammoData = Ammo.getData(preferredAmmoType)
        if ammoData then preferredAmmoType = (ammoData.instance:getDisplayName() or preferredAmmoType) end -- .." " ..(ammoData.RoundType or "Round").."s" end
    end
    text = text ..getText("IGUI_Firearm_StatAmmo", capacity, lastRound, loadedAmmo, preferredAmmoType)
    text = text .." <LINE> "


    -- hit chance
    local beenMoving = player:getBeenMovingFor()
    local aimingPerk = player:getPerkLevel(Perks.Aiming)
    local hitChanceMod = item:getHitChance()
    hitChanceMod = hitChanceMod + item:getAimingPerkHitChanceModifier() * aimingPerk
    local hitChancePenalty = 0
    if player:IsAiming() and beenMoving > item:getAimingTime() + aimingPerk * 2 then
        hitChancePenalty = (beenMoving - (item:getAimingTime() + aimingPerk * 2)) * -1
    end
    hitChanceMod = hitChanceMod + hitChancePenalty
    if player:HasTrait("Marksman") then hitChanceMod = hitChanceMod + 20 end
    if hitChanceMod > 120 then hitChanceMod = "IGUI_Firearm_EffectGodlike"
    elseif hitChanceMod > 100 then hitChanceMod = "IGUI_Firearm_EffectBullseye"
    elseif hitChanceMod > 80 then hitChanceMod = "IGUI_Firearm_EffectVeryGood"
    elseif hitChanceMod > 60 then hitChanceMod = "IGUI_Firearm_EffectGood"
    elseif hitChanceMod > 40 then hitChanceMod = "IGUI_Firearm_EffectAverage"
    elseif hitChanceMod > 20 then hitChanceMod = "IGUI_Firearm_EffectBad"
    else
        hitChanceMod = "IGUI_Firearm_EffectVeryBad"
    end

    local critical = item:getCriticalChance() + item:getAimingPerkCritModifier() * (player:getPerkLevel(Perks.Aiming) / 2)
    if critical >= 100 then critical = "IGUI_Firearm_EffectSureThing"
    elseif critical > 80 then critical = "IGUI_Firearm_EffectVeryGood"
    elseif critical > 60 then critical = "IGUI_Firearm_EffectGood"
    elseif critical > 40 then critical = "IGUI_Firearm_EffectAverage"
    elseif critical > 20 then critical = "IGUI_Firearm_EffectBad"
    else
        critical = "IGUI_Firearm_EffectVeryBad"
    end

    local rof = item:getSwingTime()
    if rof > 2.5 then rof = "IGUI_Firearm_EffectVeryLow"
    elseif rof > 1.6 then rof = "IGUI_Firearm_EffectLow"
    elseif rof > 0.9 then rof = "IGUI_Firearm_EffectAverage"
    elseif rof > 0.4 then rof = "IGUI_Firearm_EffectHigh"
    else
        rof = "IGUI_Firearm_EffectVeryHigh"
    end
    local recoil = item:getRecoilDelay()
    if recoil > 30 then recoil = "IGUI_Firearm_EffectVeryHigh"
    elseif recoil > 23 then recoil = "IGUI_Firearm_EffectHigh"
    elseif recoil > 13 then recoil = "IGUI_Firearm_EffectAverage"
    elseif recoil > 8 then recoil = "IGUI_Firearm_EffectLow"
    elseif recoil > 3 then recoil = "IGUI_Firearm_EffectVeryLow"
    else
        recoil = "IGUI_Firearm_Negligible"
    end

    text = text..getText("IGUI_Firearm_StatMisc", getText(hitChanceMod), getText(critical), getText(rof), getText(recoil))

    local damage = item:getMaxDamage() -- item:getMinDamage()
    -- this is going to entirely be effected by the ammo damage nerf...
    local damageMultiplier = Settings.DamageMultiplier
    if damage > 2.5 * damageMultiplier then damage = "IGUI_Firearm_EffectVeryHigh"
    elseif damage > 2 * damageMultiplier then damage = "IGUI_Firearm_EffectHigh"
    elseif damage > 1.5 * damageMultiplier then damage = "IGUI_Firearm_EffectAverage"
    elseif damage > 1 * damageMultiplier then damage = "IGUI_Firearm_EffectLow"
    else
        damage = "IGUI_Firearm_EffectVeryLow"
    end

    text = text..getText("IGUI_Firearm_StatMisc2", getText(damage))


    self.textPanel.text = text
    self.textPanel:paginate()
end

local DebugPanel = ISPanelJoypad:derive("DebugPanel")

function DebugPanel:new(x, y, width, height)
    local o = ISPanelJoypad:new(x, y, width, height)
    setmetatable(o, self)
    o:noBackground()
    o.__index = self
    o.resizable = false
    return o
end

function DebugPanel:createChildren()
    self.textPanel = ISRichTextPanel:new(8, 16, self.width-16, self.height-24)
    self.textPanel:initialise()
    self.textPanel.autosetheight = false
    self.textPanel:ignoreHeightChange()
    self:addChild(self.textPanel)
end

function DebugPanel:updateFirearm(item)
    local def = Firearm.getData(item)
    if not def or not (Settings.Debug or isAdmin()) then
        self.textPanel.text = ""
        self.textPanel:paginate()
        return
    end
    local data = item:getModData()

    local text = " <RED> <CENTER> ".. item:getDisplayName() .. " <LINE> <LEFT> <TEXT> <LINE> "
    local player = getPlayer()
    text = text .. getText("IGUI_Firearm_DebugState1", data.actionType, data.triggerType)
    if data.selectFire then
        local mode = "IGUI_Firearm_DetailSemi"
        if data.selectFire == ORGM.FULLAUTOMODE then mode = "IGUI_Firearm_DetailFull" end
        text = text .. getText("IGUI_Firearm_DebugMode", getText(mode))
    end

    local player = getSpecificPlayer(0)
    local beenMoving = player:getBeenMovingFor()
    local aimingPerk = player:getPerkLevel(Perks.Aiming)
    local hitChanceMod = item:getHitChance()
    -- translated from the java
    hitChanceMod = hitChanceMod + item:getAimingPerkHitChanceModifier() * aimingPerk
    local hitChancePenalty = 0
    if player:IsAiming() and beenMoving > item:getAimingTime() + aimingPerk * 2 then
        hitChancePenalty = (beenMoving - (item:getAimingTime() + aimingPerk * 2)) * -1
    end
    hitChanceMod = hitChanceMod + hitChancePenalty

    if player:HasTrait("Marksman") then hitChanceMod = hitChanceMod + 20 end
    --if hitChanceMod < 10 then hitChanceMod = 10 end
    --if hitChanceMod > 100 then hitChanceMod = 100 end
    --[[
    local damageMax = item:getMaxDamage()
    local damageMin = item:getMinDamage()

    --dam /= armsPain / 10.0F;
    if player:HasTrait("Underweight") then
        damageMin = damageMin * 0.8
        damageMax = damageMax * 0.8
    elseif player.HasTrait("Very Underweight") then
        damageMin = damageMin * 0.6
        damageMax = damageMax * 0.6
    elseif player.HasTrait("Emaciated")) then
        damageMin = damageMin * 0.4
        damageMax = damageMax * 0.4
    end

    damageMin = damageMin / (1 / 2.0F)
    damageMax = damageMax / (1 / 2.0F)
    local endurance = player:getMoodles():getMoodleLevel(MoodleType.Endurance)
    if endurance == 1 then
        damageMin = damageMin * 0.5
        damageMax = damageMax * 0.5
    elseif endurance == 2 then
        damageMin = damageMin * 0.2
        damageMax = damageMax * 0.2
    elseif endurance == 4 then
        damageMin = damageMin * 0.1
        damageMax = damageMax * 0.1
    elseif endurance == 4 then
        damageMin = damageMin * 0.05
        damageMax = damageMax * 0.05
    end
    ]]

    text = text .. getText("IGUI_Firearm_DebugState2", tostring(data.hammerCocked == 1 or false), tostring(data.isOpen == 1 or false))
    text = text .. getText("IGUI_Firearm_DebugWeight", tostring(item:getWeight()), tostring(item:getActualWeight()))
    text = text .. getText("IGUI_Firearm_DebugCapacity", tostring(data.currentCapacity), tostring(data.maxCapacity), tostring(data.roundChambered), tostring(data.emptyShellChambered))
    text = text .. getText("IGUI_Firearm_DebugAmmo", tostring(data.lastRound), tostring(data.preferredAmmoType), tostring(data.loadedAmmo), tostring(data.isJammed))
    text = text .. getText("IGUI_Firearm_DebugAccuracy", tostring(item:getHitChance()), tostring(hitChanceMod), tostring(item:getAimingPerkHitChanceModifier() * aimingPerk), tostring(hitChancePenalty))
    text = text .. getText("IGUI_Firearm_DebugAccuracy2", tostring(item:getCriticalChance()), tostring(item:getCriticalChance() + item:getAimingPerkCritModifier() * (player:getPerkLevel(Perks.Aiming) / 2)))
    text = text .. getText("IGUI_Firearm_DebugRange", tostring(item:getMinRangeRanged()), tostring(item:getMaxRange()))
    text = text .. getText("IGUI_Firearm_DebugDamage", tostring(item:getMinDamage()), tostring(item:getMaxDamage()), tostring(item:getTreeDamage()), tostring(item:getDoorDamage()))
    text = text .. getText("IGUI_Firearm_DebugSpeed", tostring(item:getSwingTime()), tostring(item:getRecoilDelay()))
    text = text .. getText("IGUI_Firearm_DebugSpeed2", tostring(item:getAimingTime()), tostring(beenMoving))
    text = text .. getText("IGUI_Firearm_DebugMagazine")
    text = text .. getText("IGUI_Firearm_DebugCylinder", tostring(data.cylinderPosition))
    for i=1, data.maxCapacity do
        local ammoType = data.magazineData[i]
        if ammoType then
            text = text .. "#" .. i .. ": "..tostring(data.magazineData[i]) .. " <LINE> "
        end
    end
    --getDamageMod(IsoGameCharacter chr)
    self.textPanel.text = text
    self.textPanel:paginate()
end
-------------------------------------------------------------------------------------------

ISORGMFirearmWindow = ISCollapsableWindow:derive("ISORGMFirearmWindow")
ISORGMFirearmWindow.view = {}


function ISORGMFirearmWindow:initialise()
    ISCollapsableWindow.initialise(self)
end

--[[- Creates and returns a new InspectionWindow instance

@tparam int x
@tparam int y
@tparam int width
@tparam int height
@treturn ISORGMFirearmWindow instance
]]
function ISORGMFirearmWindow:new(x, y, width, height)
    local o = ISCollapsableWindow:new(x, y, width, height);
    setmetatable(o, self)
    self.__index = self;
    o.title = getText("IGUI_Firearm_InspectTitle")
    o.pin = false
    o:noBackground()
    self.resizable = false
    return o
end

--[[- Creates the child panels

]]
function ISORGMFirearmWindow:createChildren()
    ISCollapsableWindow.createChildren(self)
    local th = self:titleBarHeight()
    --local rh = self:resizeWidgetHeight()
    --self.panel = ISTabPanel:new(0, th, self.width, self.height-th-rh)
    self.panel = ISTabPanel:new(0, th, self.width, self.height-th)
    self.panel:initialise()
    self.panel.allowDraggingTab = false
    self:addChild(self.panel)

    self.infoPanel = InfoPanel:new(0, 8, self.width, self.height-16)
    self.infoPanel:initialise()
    self.panel:addView(getText("IGUI_Firearm_InfoTitle"), self.infoPanel)

    self.detailsPanel = DetailsPanel:new(0, 8, self.width, self.height-16)
    self.detailsPanel:initialise()
    self.panel:addView(getText("IGUI_Firearm_DetailTitle"), self.detailsPanel)

    self.statPanel = StatPanel:new(0, 8, self.width, self.height-16)
    self.statPanel:initialise()
    self.panel:addView(getText("IGUI_Firearm_StatTitle"), self.statPanel)


    if Settings.Debug then
        self.debugPanel = DebugPanel:new(0, 8, self.width, self.height-16)
        self.debugPanel:initialise()
        self.panel:addView(getText("IGUI_Firearm_DebugTitle"), self.debugPanel)
    end
end


--[[- Sets the current firearm to show data for.

@tparam HandWeapon item

]]
function ISORGMFirearmWindow:setFirearm(item)
    if not self:isVisible() then return end
    local view = self.panel:getActiveView()
    if view then view:updateFirearm(item) end
end

--[[
@tparam string viewName
@treturn bool
]]
function ISORGMFirearmWindow:isActive(viewName)
    -- first test, is the view still inside our tab panel ?
    for ind,value in ipairs(self.panel.viewList) do
        -- we get the view we want to display
        if value.name == viewName then
            return value.view:getIsVisible() and self:getIsVisible()
        end
    end
    return false
end
