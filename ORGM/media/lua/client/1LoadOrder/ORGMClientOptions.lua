-- We need to use the global keyBinding table, this stores all our binding values
local index = nil -- index will be the position we want to insert into the table
for i,b in ipairs(keyBinding) do
    -- we need to find the index of the item we want to insert after
    -- in this case its "Equip/Unequip Stab weapon"
    if b.value == "Equip/Unequip Stab weapon" then
        index = i -- found the index, set it and break from the loop
        break
    end
end

if index then
    -- we got a index, first lets insert our new entries
    table.insert(keyBinding, index+1, {value = "Equip/Unequip Pistol", key = 5})
    table.insert(keyBinding, index+2, {value = "Equip/Unequip Rifle", key = 6})
    table.insert(keyBinding, index+3, {value = "Equip/Unequip Shotgun", key = 7})
    
    -- store the original MainOptions:create() method in a variable
    local oldCreate = MainOptions.create

    -- overwrite it
    function MainOptions:create()
        oldCreate(self)
        for _, keyTextElement in pairs(MainOptions.keyText) do repeat
            -- if keyTextElement is nil or doesn't have a ISLabel, break out of the 
            -- "repeat ... until true"  loop, and continue with the "for .. do ... end" 
            -- loop
            if not keyTextElement or not keyTextElement.txt then break end
            
            local label = keyTextElement.txt -- our ISLabel item is stored in keyTextElement.txt
            -- We need to do a few things here to prep the new entries.
            -- 1) We wont have a proper translation, and the translation will be set to
            --    "UI_optionscreen_binding_Equip/Unequip Pistol", which will look funny on the 
            --    options screen, so we need to fix
            -- 2) the new translation doesn't properly adjust the x position and width, so we need to 
            --    manually adjust these
            
            if label.name == "Equip/Unequip Pistol" then
                label:setTranslation("Equip/Unequip Pistol")
                label:setX(label.x)
                label:setWidth(label.width)
            elseif label.name == "Equip/Unequip Rifle" then 
                label:setTranslation("Equip/Unequip Rifle")
                label:setX(label.x)
                label:setWidth(label.width)
            elseif label.name == "Equip/Unequip Shotgun" then 
                label:setTranslation("Equip/Unequip Shotgun")
                label:setX(label.x)
                label:setWidth(label.width)
            end
        until true end
    end
end

-- now add the event hook function, for this example the player just says the name of the key
--[[
Events.OnKeyPressed.Add(function(key)
    local player = getSpecificPlayer(0)
    if key == getCore():getKey("Equip/Unequip Pistol") then
        player:Say("Key pressed: Equip/Unequip Pistol")
    elseif key == getCore():getKey("Equip/Unequip Rifle") then
        player:Say("Key pressed: Equip/Unequip Rifle")
    elseif key == getCore():getKey("Equip/Unequip Shotgun") then
        player:Say("Key pressed: Equip/Unequip Shotgun")
    end
end)
]]