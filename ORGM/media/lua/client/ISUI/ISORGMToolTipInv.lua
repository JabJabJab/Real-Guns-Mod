--[[
    
    This file modifies firearm and magazine tooltips to show what the item is currently loaded with.
    
]]
require 'ISUI/ISToolTipInv'

-- store our original function in a local variable that we'll call later
local render = ISToolTipInv.render


function ISToolTipInv:render()
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
        local ammoName = getScriptManager():FindItem('ORGM.' .. modData.loadedAmmo):getDisplayName()
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
    
	if text ~= nil then
		self.item:setTooltip(text)
	end
	-- call the original function
	render(self)
end
