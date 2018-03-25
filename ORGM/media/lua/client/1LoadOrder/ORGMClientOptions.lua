-- We need to use the global keyBinding table, this stores all our binding values
local index = nil -- index will be the position we want to insert into the table
for i,b in ipairs(keyBinding) do
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
    table.insert(keyBinding, index+4, {value = "Reload Any Magazine", key = Keyboard.KEY_Y })
    table.insert(keyBinding, index+5, {value = "Select Fire Toggle", key = Keyboard.KEY_Z })
    table.insert(keyBinding, index+6, {value = "Firearm Inspection Window", key = Keyboard.KEY_U })
    
end
