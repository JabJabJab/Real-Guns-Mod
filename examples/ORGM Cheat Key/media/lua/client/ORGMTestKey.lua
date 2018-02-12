
Events.OnKeyPressed.Add(function(key)
    if key ~= 207 then return end
    local inventory = getPlayer():getInventory()
    for name, def in pairs(ORGM.FirearmTable) do
        inventory:AddItem(def.moduleName ..'.'.. name)
    end
    for name, def in pairs(ORGM.MagazineTable) do
        inventory:AddItem(def.moduleName ..'.'.. name)
    end
    for name, def in pairs(ORGM.AmmoTable) do
        inventory:AddItem(def.moduleName ..'.'.. name ..'_Can')
    end
    for name, def in pairs(ORGM.ComponentTable) do
        inventory:AddItem(def.moduleName ..'.'.. name)
    end
    for name, def in pairs(ORGM.RepairKitTable) do
        inventory:AddItem(def.moduleName ..'.'.. name)
    end
end)