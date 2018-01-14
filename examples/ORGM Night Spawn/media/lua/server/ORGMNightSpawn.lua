
-- first copy the original spawning function. The original function is in
-- server/1LoadOrder/ORGMDistribution.lua
local oldSpawnFunction = ORGM.Server.addToCorpse

-- create a new function to be called in place of the old one.
ORGM.Server.addToCorpse = function(container)
    -- get the current hour
    local hour = GameTime:getInstance():getHour()
    if hour >= 0 and hour < 6 then
        -- its been 12 to 6 AM, call the original spawn function.
        oldSpawnFunction(container)
    end
end
