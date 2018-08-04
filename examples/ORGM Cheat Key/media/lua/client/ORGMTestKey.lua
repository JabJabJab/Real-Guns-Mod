
Events.OnKeyPressed.Add(function(key)
    --print("Got Key " .. key)
    if key ~= 207 then return end
    print("Got Cheat Key")
    local inventory = getPlayer():getInventory()
    local square = getPlayer():getCurrentSquare()

    for name, def in pairs(ORGM.Firearm.getTable()) do
        print(name)
        --inventory:AddItem(def.moduleName ..'.'.. name)
        local item = InventoryItemFactory.CreateItem(def.moduleName ..'.'.. name)
        ORGM.Firearm.setup(def, item)
        ORGM.Firearm.Stats.set(item)
        square:AddWorldInventoryItem(item, 0, 0, 0)
    end
    for name, def in pairs(ORGM.Magazine.getTable()) do
        print(name)
        --inventory:AddItem(def.moduleName ..'.'.. name)
        for i=1, 10 do
            local item = InventoryItemFactory.CreateItem(def.moduleName ..'.'.. name)
            --ORGM.Magazine.setup(item)
            square:AddWorldInventoryItem(item, 0, 0, 0)
        end
    end
    for name, def in pairs(ORGM.Ammo.getTable()) do
        print(name)
        --inventory:AddItem(def.moduleName ..'.'.. name ..'_Can')
        for i=1, 5 do
            square:AddWorldInventoryItem(InventoryItemFactory.CreateItem(def.moduleName ..'.'.. name..'_Can'), 0, 0, 0)
        end
    end
    for name, def in pairs(ORGM.Component.getTable()) do
        print(name)
        --inventory:AddItem(def.moduleName ..'.'.. name)
        for i=1, 10 do
            square:AddWorldInventoryItem(InventoryItemFactory.CreateItem(def.moduleName ..'.'.. name), 0, 0, 0)
        end
    end
    for name, def in pairs(ORGM.Maintance.getTable()) do
        --inventory:AddItem(def.moduleName ..'.'.. name)
        for i=1, 5 do
            square:AddWorldInventoryItem(InventoryItemFactory.CreateItem(def.moduleName ..'.'.. name), 0, 0, 0)
        end
    end
end)
