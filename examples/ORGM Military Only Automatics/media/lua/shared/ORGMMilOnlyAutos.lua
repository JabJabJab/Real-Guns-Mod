
-- All weapon defintions are contained within the ORGM.FirearmTable
local FirearmTable = ORGM.FirearmTable

for name, definition in pairs(FirearmTable) do
    -- first find if the gun is a select fire automatic
    if definition.selectFire ~= nil then
        -- change the rarity value. Valid options are nil, "Common", "Rare" and "VeryRare"
        -- case matters: "rare" is not a valid value.
        definition.isCivilian = nil
        definition.isPolice = nil
        definition.isMilitary = "Rare"
    end
end

-- note if changing values after the game has started (ie: on events) it is necessary to call
-- ORGM.Server.buildRarityTables()
