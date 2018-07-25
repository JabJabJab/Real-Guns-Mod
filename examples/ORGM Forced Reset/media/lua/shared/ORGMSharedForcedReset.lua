-- this file changes each weapons 'lastChanged' key to the current ORGM build number,
-- and overrides the ORGM.getFirearmNeedsUpdate to have a random number check as well.
-- if the random doesn't match whats in the item's moddata then we haven't reset the
-- item yet.

-- by having this random generation in shared, the server and client will actually end
-- up having different values, but since ORGM.getFirearmNeedsUpdate is only really called
-- by the client, the server's random number is never actually used.
local forcedResetID = ZombRand(1000000)

-- replace the original function
ORGM.getFirearmNeedsUpdate = function(item)
    if item == nil then return nil end
    local data = item:getModData()
    local def = ORGM.FirearmTable[item:getType()]
    if not def then return nil end
    ------------------------------------------
    -- this part is the change from original function
    if data.forcedResetID ~= forcedResetID then
        data.BUILD_ID = nil
        data.forcedResetID = forcedResetID
    end
    ------------------------------------------

    if def.lastChanged and (data.BUILD_ID == nil or data.BUILD_ID < ORGM.BUILD_ID) then
        ORGM.log(ORGM.INFO, "Obsolete firearm detected (" .. item:getType() .."). Running update function.")
        -- this gun has changed. reset it.
        return true
    end
    -- update the gun's build ID value.
    data.BUILD_ID = ORGM.BUILD_ID
    return false
end

-- set the lastChanged key on every firearm definition to current build id
Events.OnGameBoot.Add(function()
    for name, definition in pairs(ORGM.FirearmTable) do
        definition.lastChanged = ORGM.BUILD_ID
    end
end)
