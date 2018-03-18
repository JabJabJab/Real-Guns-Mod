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
    end

    local modData = self.item:getModData() -- gets the item's mod data
    
    local text = nil
    -- set the text to show what the item is currently loaded with
    if modData.loadedAmmo == nil then
        -- pass
    elseif modData.loadedAmmo == 'mixed' then
        text = "Loaded Ammo:  Mixed Load"
    else
        local ammoData = ORGM.AmmoTable[modData.loadedAmmo]
        local ammoName = getScriptManager():FindItem(ammoData.moduleName ..'.'.. modData.loadedAmmo):getDisplayName()
        text = "Loaded Ammo:  " .. ammoName
    end
    
    -- set the text to show the current fire mode
    if modData.selectFire ~= nil then
        local fireMode = "Fire Mode:   "
        if modData.selectFire == 1 then 
            fireMode = fireMode .. "Full-Auto" 
        else
            fireMode = fireMode .. "Semi-Auto" 
        end
        if text then
            text = text .. "\n" .. fireMode
        else
            text = fireMode
        end
    end
    local old = self.item:getTooltip()
    if text ~= nil then
        self.item:setTooltip(text .. "\n"..(old or ""))
    end
    -- call the original function
    render(self)
    self.item:setTooltip(old)
end



function ISRemoveWeaponUpgrade:perform()
    self.weapon:detachWeaponPart(self.part)
    -- delete the original part, give a fresh copy
    local new = InventoryItemFactory.CreateItem(self.part:getFullType())
    local ndata = new:getModData()
    for k,v in pairs(self.part:getModData()) do ndata[k] = v end -- copy any mod data
    ndata.BUILD_ID = ORGM.BUILD_ID
    new:setCondition(self.part:getCondition())

    --self.character:getInventory():AddItem(self.part)
    self.character:getInventory():AddItem(new)
    -- needed to remove from queue / start next.
    ISBaseTimedAction.perform(self)
end

function ISUpgradeWeapon:perform()
    local def = ORGM.ComponentTable[self.part:getType()]
    local data = self.part:getModData()
    if def and def.lastChanged and (data.BUILD_ID == nil or data.BUILD_ID < def.lastChanged) then
        -- handle orgm component update...
        ORGM.log(ORGM.INFO, "Obsolete component detected (" .. self.part:getType() .."). Running update function.")
        self.character:Say("Weapon Modification changed due to ORGM updates, resetting to default. Try attaching again.")
        local new = InventoryItemFactory.CreateItem(self.part:getFullType())
        local ndata = new:getModData()
        for k,v in pairs(self.part:getModData()) do ndata[k] = v end -- copy any mod data
        ndata.BUILD_ID = ORGM.BUILD_ID
        new:setCondition(self.part:getCondition())

        self.character:getInventory():AddItem(new)    
        self.character:getInventory():Remove(self.part)
        ISBaseTimedAction.perform(self)
        return
    end
    
    
    self.weapon:setJobDelta(0.0)
    self.part:setJobDelta(0.0)

    self.weapon:attachWeaponPart(self.part)
    self.character:getInventory():Remove(self.part)
    self.character:setSecondaryHandItem(nil)
    -- needed to remove from queue / start next.
    ISBaseTimedAction.perform(self)
end
