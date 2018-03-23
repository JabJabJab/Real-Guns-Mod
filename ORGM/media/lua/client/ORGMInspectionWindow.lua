--[[ This file is still very much a work in progress. expect it to be rewritten to
    conform to ORGM's new standards

]]
-------------------------------------------------------------------------------------------

local InfoPanel = ISPanelJoypad:derive("InfoPanel")

function InfoPanel:new(x, y, width, height)
    local o = ISPanelJoypad:new(x, y, width, height)
    o:noBackground()
    setmetatable(o, self)
    self.__index = self
    return o
end

function InfoPanel:createChildren()
    self.textPanel = ISRichTextPanel:new(8, 16, self.width-8, self.height-8)
    self.textPanel:initialise()
    self.textPanel.autosetheight = false
    self.textPanel:ignoreHeightChange()
    self:addChild(self.textPanel)
end


-------------------------------------------------------------------------------------------
local DetailsPanel = ISPanelJoypad:derive("DetailsPanel")

function DetailsPanel:new(x, y, width, height)
    local o = ISPanelJoypad:new(x, y, width, height)
    setmetatable(o, self)
    self:noBackground()
    self.__index = self
    self.resizable = false
    return o
end

function DetailsPanel:createChildren()
    self.textPanel = ISRichTextPanel:new(8, 16, self.width-8, self.height-8)
    self.textPanel:initialise()
    self.textPanel.autosetheight = false
    self.textPanel:ignoreHeightChange()
    self:addChild(self.textPanel)
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



function ORGMFirearmWindow:setFirearm(item)
    local itemType = item:getType()
    local def = ORGM.getFirearmData(itemType)
    local scriptItem = item:getScriptItem() -- getScriptManager():FindItem(def.moduleName ..'.' .. itemType)
    local data = item:getModData()
    
    
    local text = scriptItem:getDisplayName() .. "\n"
    text = text .. getText("IGUI_Firearm_InfoPanel", getText(def.classification), (def.year or getText("IGUI_Firearm_YearUnknown")), getText(def.country), getText(def.manufacturer))

    text = text .. getText(def.description)
    self.infoPanel.textPanel.text = text
    self.infoPanel.textPanel:paginate()
    
    text = scriptItem:getDisplayName() .. "\n"
    
    if data.selectFire ~= 0 then
        local mode = "IGUI_Firearm_DetailSemi"
        if data.selectFire == 1 then mode = "IGUI_Firearm_DetailFull" end
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
    
    self.detailsPanel.textPanel.text = text
    self.detailsPanel.textPanel:paginate()

end


function ORGMFirearmWindow:createChildren()
    ISCollapsableWindow.createChildren(self)
    local th = self:titleBarHeight()
    local rh = self:resizeWidgetHeight()
    self.panel = ISTabPanel:new(0, th, self.width, self.height-th-rh)
    self.panel:initialise()
    self.panel.allowDraggingTab = false
    self:addChild(self.panel)

    self.infoPanel = InfoPanel:new(0, 8, self.width, self.height-8)
    self.infoPanel:initialise()
    self.panel:addView(getText("IGUI_Firearm_InfoTitle"), self.infoPanel)
    
    self.detailsPanel = DetailsPanel:new(0, 8, self.width, self.height-8)
    self.detailsPanel:initialise()
    self.panel:addView(getText("IGUI_Firearm_DetailTitle"), self.detailsPanel)
    
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