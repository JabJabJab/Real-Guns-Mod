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
    o.title = "Firearm Inspection"
    o.pin = false
    o:noBackground()
    self.resizable = false
    return o
end



function ORGMFirearmWindow:setFirearm(item)
    local itemType = item:getType()
    local def = ORGM.FirearmTable[itemType]
    local scriptItem = item:getScriptItem() -- getScriptManager():FindItem(def.moduleName ..'.' .. itemType)
    local data = item:getModData()
    
    
    local text = scriptItem:getDisplayName() .. "\n"
    text = text .. "Class: " .. def.classification .. "\n"
    text = text .. "Introduction Year: " .. (def.year or "Unknown") .. "\n"
    text = text .. "Country of Origin: " .. def.country .. "\n"
    text = text .. "Manufacturer: " .. def.manufacturer .. "\n\n"
    text = text .. def.description
    self.infoPanel.textPanel.text = text
    self.infoPanel.textPanel:paginate()
    
    text = scriptItem:getDisplayName() .. "\n"
    
    if data.selectFire == 0 then
        text = text .. "It is currently set to semi-auto mode.\n"
    elseif data.selectFire == 1 then
        text = text .. "It is currently set to full-auto mode.\n"
    end
    local feed = "slide"
    if data.actionType == ORGM.ROTARY then feed = "cylinder" end
    if data.actionType == ORGM.BOLT then feed = "bolt" end
    if data.actionType == ORGM.BREAK then feed = "breech" end
    if data.isOpen == 1 then
        text = text .. "The " .. feed .. " is currently open.\n"
    else
        text = text .. "The " .. feed .. " is currently closed.\n"
    end
    
    if data.containsClip == 1 then
        text = text .. "A magazine is inserted.\n"    
    elseif data.containsClip == 0 then
        text = text .. "The magazine is missing.\n"
    end
    if data.actionType ~= ORGM.DOUBLEACTIONONLY then
        if data.hammerCocked then
            text = text .. "The hammer is cocked.\n"
        else
            text = text .. "The hammer is at rest.\n"
        end
    end
    
    if data.actionType == ORGM.ROTARY then
        if data.currentCapacity > 0 then
            text = text .. "There are rounds in the cylinder.\n"
        else
            text = text .. "No rounds are loaded.\n"
        end
    else
        if data.roundChambered > 0 then
            text = text .. "There is a round in the chamber.\n"
        elseif data.emptyShellChambered > 0 then
            text = text .. "There is a empty shell in the chamber.\n"
        else
            text = text .. "The chamber is currently empty.\n"
        end
    end
    
    if data.isJammed then
        text = text .. "The gun is currently jammed.\n"
    end
    
    local condition = item:getCondition() / item:getConditionMax()
    if condition == 1 then
        text = text .. "It looks brand new.\n"
    elseif condition >= 0.9 then
        text = text .. "It looks to be in good condition.\n"
    elseif condition >= 0.7 then
        text = text .. "It looks to be in serviceable condition.\n"
    elseif condition >= 0.5 then
        text = text .. "It's seen some wear.\n"
    elseif condition >= 0.4 then
        text = text .. "It's seen better days.\n"
    elseif condition >= 0.3 then
        text = text .. "It looks unreliable.\n"
    elseif condition >= 0.2 then
        text = text .. "It looks like its ready to fall apart.\n"
    elseif condition > 0 then
        text = text .. "It might break at any moment.\n"
    elseif condition == 0 then
        text = text .. "It's broken.\n"
    end
    if item:getCanon() then
        text = text.. "A " .. item:getCanon():getDisplayName() .. " is attached to the barrel.\n"
    end
    if item:getScope() then
        text = text.. "It has a " .. item:getScope():getDisplayName() .. " attached.\n"
    end
    if item:getSling() then
        text = text.. "It has a " .. item:getSling():getDisplayName() .. ".\n"
    end
    if data.serialnumber == nil then
        text = text.. "The serial number appears to have been filed off.\n"
    else
        text = text.. "The serial number is " .. data.serialnumber .. ".\n"
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
    self.panel:addView("Information", self.infoPanel)
    
    self.detailsPanel = DetailsPanel:new(0, 8, self.width, self.height-8)
    self.detailsPanel:initialise()
    self.panel:addView("Details", self.detailsPanel)
    
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