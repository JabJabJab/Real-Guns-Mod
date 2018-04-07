--[[
    
    This file modifies firearm and magazine tooltips to show what the item is currently loaded with.
    
]]
require 'ISUI/ISToolTipInv'

-- store our original function in a local variable that we'll call later
local render = ISToolTipInv.render

function ISToolTipInv:render()
    -- TODO: this should actually check the ORGM tables to see
    if self.item:getModule() ~= "ORGM" then
        render(self)
        return
    end

    local modData = self.item:getModData() -- gets the item's mod data
    
    local text = "Tooltip_loaded"
    -- set the text to show what the item is currently loaded with
    if modData.loadedAmmo ~= nil then
        text = text .. "_"..modData.loadedAmmo
    end
    
    -- set the text to show the current fire mode
    if modData.selectFire ~= nil then
        if modData.selectFire == 1 then 
            text = text .. "_FA"
        else
            text = text .. "_SA"
        end
    end
    -- this old tooltip screws the translations..
    local old = self.item:getTooltip()
    if text ~= "Tooltip_loaded" then
        self.item:setTooltip(text)
    end
    -- call the original function
    render(self)
    self.item:setTooltip(old)
end



function ISRemoveWeaponUpgrade:perform()
    --ORGM.log(ORGM.DEBUG, "Removing "..self.part:getType())
    ORGM.log(ORGM.DEBUG, "Removing "..self.part:getType() .. ", weight="..tostring(self.part:getWeight())..'/'..tostring(self.part:getActualWeight())..'/'..tostring(self.part:getWeightModifier()))
    
    ORGM.log(ORGM.DEBUG, "Weapon weight before "..tostring(self.weapon:getWeight()) .."/" .. tostring(self.weapon:getActualWeight()))
    self.weapon:detachWeaponPart(self.part)
    ORGM.log(ORGM.DEBUG, "Weapon weight after "..tostring(self.weapon:getWeight()) .."/" .. tostring(self.weapon:getActualWeight()))

    -- delete the original part, give a fresh copy
    local new = ORGM.copyFirearmComponent(self.part)
    self.character:getInventory():AddItem(new)
    -- needed to remove from queue / start next.
    ISBaseTimedAction.perform(self)
end

function ISUpgradeWeapon:perform()
    local def = ORGM.getComponentData(self.part)
    local data = self.part:getModData()
    if def and def.lastChanged and (data.BUILD_ID == nil or data.BUILD_ID < def.lastChanged) then
        -- handle orgm component update...
        ORGM.log(ORGM.INFO, "Obsolete component detected (" .. self.part:getType() .."). Running update function.")
        --self.character:Say("Weapon Modification changed due to ORGM updates, resetting to default. Try attaching again.")
        local new = ORGM.copyFirearmComponent(self.part)
        self.character:getInventory():Remove(self.part)
        self.character:getInventory():AddItem(new)
        self.part = new
        --ISBaseTimedAction.perform(self)
        --return
    end
    
    
    self.weapon:setJobDelta(0.0)
    self.part:setJobDelta(0.0)

    ORGM.log(ORGM.DEBUG, "Installing "..self.part:getType() .. ", weight="..tostring(self.part:getWeight())..'/'..tostring(self.part:getActualWeight())..'/'..tostring(self.part:getWeightModifier()))
    
    ORGM.log(ORGM.DEBUG, "Weapon weight before "..tostring(self.weapon:getWeight()) .."/" .. tostring(self.weapon:getActualWeight()))
    
    self.weapon:attachWeaponPart(self.part)
    ORGM.log(ORGM.DEBUG, "Weapon weight after "..tostring(self.weapon:getWeight()) .."/" .. tostring(self.weapon:getActualWeight()))
    self.character:getInventory():Remove(self.part)
    self.character:setSecondaryHandItem(nil)
    -- needed to remove from queue / start next.
    ISBaseTimedAction.perform(self)
end
