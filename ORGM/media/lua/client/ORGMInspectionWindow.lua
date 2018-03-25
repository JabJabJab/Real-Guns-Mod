--[[ This file is still very much a work in progress. expect it to be rewritten to
    conform to ORGM's new standards

]]
-------------------------------------------------------------------------------------------

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
    local def = ORGM.getFirearmData(item)
    if not def then 
        self.textPanel.text = ""
        self.textPanel:paginate()
        return
    end
    local data = item:getModData()
    
    local text = " <RED> <CENTER> ".. item:getDisplayName() .. " <LINE> <LEFT> <TEXT> <LINE> "
    text = text .. getText("IGUI_Firearm_InfoPanel", getText(def.classification), (def.year or getText("IGUI_Firearm_YearUnknown")), getText(def.country), getText(def.manufacturer))

    text = text .. getText("IGUI_Firearm_InfoBackGround")
    text = text .. getText(def.description) .. " <LINE> <LINE> "
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
    local def = ORGM.getFirearmData(item)
    if not def then 
        self.textPanel.text = ""
        self.textPanel:paginate()
        return
    end
    local data = item:getModData()    
    local text = " <RED> <CENTER> ".. item:getDisplayName() .. " <LINE> <LEFT> <TEXT> <LINE> "
    
    if data.selectFire then
        local mode = "IGUI_Firearm_DetailSemi"
        if data.selectFire == ORGM.FULLAUTOMODE then mode = "IGUI_Firearm_DetailFull" end
        text = text .. getText("IGUI_Firearm_DetailMode", getText(mode))
    end
    
    local feed = "slide"
    if data.actionType == ORGM.ROTARY then feed = "cylinder" end
    if data.actionType == ORGM.BOLT then feed = "bolt" end
    if data.actionType == ORGM.BREAK then feed = "breech" end
    if data.isOpen == 1 then
        text = text .. getText("IGUI_Firearm_DetailOpen", getText("IGUI_Firearm_"..feed))
    else
        text = text .. getText("IGUI_Firearm_DetailClosed", getText("IGUI_Firearm_"..feed))
    end
    
    if data.containsClip == 1 then
        text = text .. getText("IGUI_Firearm_DetailInserted")
    elseif data.containsClip == 0 then
        text = text .. getText("IGUI_Firearm_DetailEjected")
    end
    if data.actionType ~= ORGM.DOUBLEACTIONONLY then
        if data.hammerCocked then
            text = text .. getText("IGUI_Firearm_DetailCocked")
        else
            text = text .. getText("IGUI_Firearm_DetailRest")
        end
    end
    
    local loaded = "IGUI_Firearm_DetailEmpty"
    if data.actionType == ORGM.ROTARY then
        if data.currentCapacity > 0 then
            loaded = "IGUI_Firearm_DetailLoadedCylinder"
        end
    elseif data.actionType == ORGM.BREAK then
        if data.currentCapacity > 1 then
            loaded = "IGUI_Firearm_DetailLoaded2"
        elseif data.currentCapacity == 1 then
            loaded = "IGUI_Firearm_DetailLoaded1"
        end    
    else
        if data.roundChambered > 0 then
            loaded = "IGUI_Firearm_DetailRoundChambered"
        elseif data.emptyShellChambered > 0 then
            loaded = "IGUI_Firearm_DetailShellChambered"
        else
            loaded = "IGUI_Firearm_DetailEmptyChamber"
        end
    end
    text = text .. getText(loaded)
    
    
    if data.isJammed then
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
    if data.serialnumber == nil then
        text = text.. getText("IGUI_Firearm_DetailNoSerial")
    else
        text = text.. getText("IGUI_Firearm_DetailSerial", data.serialnumber)
    end
    
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
    local def = ORGM.getFirearmData(item)
    if not def then --or not ORGM.Settings.Debug then 
        self.textPanel.text = ""
        self.textPanel:paginate()
        return
    end
--    local scriptItem = item:getScriptItem() -- getScriptManager():FindItem(def.moduleName ..'.' .. itemType)
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
    text = text .. getText("IGUI_Firearm_DebugAccuracy2", tostring(item:getCriticalChance()))
    text = text .. getText("IGUI_Firearm_DebugRange", tostring(item:getMinRange()), tostring(item:getMaxRange()))
    text = text .. getText("IGUI_Firearm_DebugDamage", tostring(item:getMinDamage()), tostring(item:getMaxDamage()), tostring(item:getTreeDamage()), tostring(item:getDoorDamage()))
    text = text .. getText("IGUI_Firearm_DebugSpeed", tostring(item:getSwingTime()), tostring(item:getRecoilDelay()))
    text = text .. getText("IGUI_Firearm_DebugSpeed2", tostring(item:getAimingTime()), tostring(beenMoving))
    text = text .. getText("IGUI_Firearm_DebugMagazine")
    text = text .. getText("IGUI_Firearm_DebugCylinder", tostring(data.cylinderPosition))
    for i=1, data.currentCapacity do
        text = text .. "#" .. i .. ": "..tostring(data.magazineData[i]) .. " <LINE> "
    end
    --getDamageMod(IsoGameCharacter chr) 
    self.textPanel.text = text
    self.textPanel:paginate()
end
-------------------------------------------------------------------------------------------

ORGMFirearmWindow = ISCollapsableWindow:derive("ORGMFirearmWindow")
ORGMFirearmWindow.view = {}


function ORGMFirearmWindow:initialise()
    ISCollapsableWindow.initialise(self)
end

function ORGMFirearmWindow:new(x, y, width, height)
    local o = ISCollapsableWindow:new(x, y, width, height);
    setmetatable(o, self)
    self.__index = self;
    o.title = getText("IGUI_Firearm_InspectTitle")
    o.pin = false
    o:noBackground()
    self.resizable = false
    return o
end

function ORGMFirearmWindow:createChildren()
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
    
    --if ORGM.Settings.Debug then
        self.debugPanel = DebugPanel:new(0, 8, self.width, self.height-16)
        self.debugPanel:initialise()
        self.panel:addView(getText("IGUI_Firearm_DebugTitle"), self.debugPanel)
    --end
end



function ORGMFirearmWindow:setFirearm(item)
    if not self:isVisible() then return end
    local view = self.panel:getActiveView()
    if view then view:updateFirearm(item) end
end

function ORGMFirearmWindow:isActive(viewName)
    -- first test, is the view still inside our tab panel ?
    for ind,value in ipairs(self.panel.viewList) do
        -- we get the view we want to display
        if value.name == viewName then
            return value.view:getIsVisible() and self:getIsVisible()
        end
    end
    return false
end



-------------------------------------------------------------------------------------------

Events.OnGameStart.Add(function()
    ORGMFirearmWindow = ORGMFirearmWindow:new(35, 250, 375, 455)
    ORGMFirearmWindow:addToUIManager()
    ORGMFirearmWindow:setVisible(false)
    ORGMFirearmWindow.pin = true
    ORGMFirearmWindow.resizable = false
end)