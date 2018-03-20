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
end
