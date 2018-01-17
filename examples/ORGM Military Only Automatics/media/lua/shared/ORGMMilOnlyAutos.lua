
-- All weapon defintions are contained within the ORGM.FirearmTable
local FirearmTable = ORGM.FirearmTable

for name, definition in pairs(FirearmTable) do
    -- first find if the gun is a select fire automatic
    if definition.selectFire ~= nil then
        -- change the rarity value. Valid options are nil, "Common", "Rare" and "VeryRare"
        -- case matters: "rare" is not a valid value.
        definition.isCivilian = nil
        definition.isPolice = nil
        definition.isMilitary = definition.isMilitary or "Rare"
    end
end

-- note if changing values after the game has started (ie: on events) it is necessary to call
-- ORGM.Server.buildRarityTables()
-- in that case you should also check if the gun is manufactured past the year limit with:
-- if definition.year and definition.year <= ORGM.Settings.LimitYear then ... end
-- or you may start spawning firearms that shouldn't spawn
