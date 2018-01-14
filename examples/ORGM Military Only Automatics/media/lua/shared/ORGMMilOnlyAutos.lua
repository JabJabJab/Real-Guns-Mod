
local FirearmTable = ORGM.FirearmTable

for name, definition in pairs(FirearmTable) do
    if definition.selectFire ~= nil then
        definition.isCivilian = nil
        definition.isPolice = nil
        definition.isMilitary = "Rare"
    end
end
