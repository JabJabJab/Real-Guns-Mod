--[[ ORGM Rechambered NecroForge Compatibility
    
    This file removes all legacy ORGM items from necroforge, and adds rechambered items.
    It will only work if ORGM is loaded after necroforge.
    
]]

Events.OnGameStart.Add(function()
	if NecroList then -- necroforge is loaded.
        print("ORGM Rechambered - Injecting Necroforge Overwrites")
        for key, value in pairs(NecroList.Items) do
            -- remove legacy ORGM items
            if key:sub(1, 4) == "ORGM" then NecroList.Items[key] = nil end
        end
        -- add ORGM Rechambered items
        local addORGMItem = function(index, itemName)
            -- function to save much redundant typing of entries
            local scriptItem = getScriptManager():FindItem('ORGM.' .. itemName)
            NecroList.Items["ORGM"..index] = {"Mods", "ORGM", nil, "ORGM - " .. scriptItem:getDisplayName(), 'ORGM.' .. itemName, "media/textures/Item_" .. scriptItem:getIcon() .. ".png", nil, nil, nil} 
        end
        
        local index = 1
        -- add all rounds, boxes and cans
        for name, data in pairs(ORGMMasterAmmoTable) do
            addORGMItem(index, name) 
            addORGMItem(index+1, name .. "_Box")
            addORGMItem(index+2, name .. "_Can") 
            index = index+3
        end
        -- add all guns
        for name, data in pairs(ORGMMasterWeaponTable) do
            addORGMItem(index, name) 
            index = index+1
        end
        -- add all magazines
        for name, data in pairs(ORGMMasterMagTable) do
            addORGMItem(index, name) 
            index = index+1
        end
        
        -- add weapon mods
        for _, name in ipairs(ORGMWeaponModsTable) do
            addORGMItem(index, name)
            index = index+1
        end
        -- add repair stuff
        for _, name in ipairs(ORGMRepairKitsTable) do
            addORGMItem(index, name)
            index = index+1
        end
    end
end)