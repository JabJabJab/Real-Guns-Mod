--[[- Override for ISToolTipInv.

    Some modifications need to be done to the tooltip rendering process to handle our custom
    tooltips.

    File: client/1LoadOrder/ISORGMToolTipInv.lua
    @classmod ISToolTipInv
    @author Fenris_Wolf
    @release 3.09

]]

require 'ISUI/ISToolTipInv'

-- store our original function in a local variable that we'll call later
local render = ISToolTipInv.render

--[[- This modifies firearm and magazine tooltips to show what the item is currently loaded with.

]]
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
