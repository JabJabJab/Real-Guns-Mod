
-- function in server/1LoadOrder/ORGMRemovals.lua
Events.OnPostDistributionMerge.Add(ORGM.Server.removeBaseFirearms)

-- functions in server/1LoadOrder/ORGMDistribution.lua
Events.OnPostDistributionMerge.Add(ORGM.Server.buildSpawnTables)
Events.OnPostDistributionMerge.Add(ORGM.Server.buildRarityTables)
Events.OnPostDistributionMerge.Add(ORGM.Server.buildUpgradeTables)
Events.OnFillContainer.Add(ORGM.Server.onFillContainer)

-- function in server/ORGMServerCompatibilityPatches.lua
Events.OnDistributionMerge.Add(ORGM.Server.loadCompatibilityPatches)

-- remove PZ's default itemBindingHandler
Events.OnKeyPressed.Remove(ItemBindingHandler.onKeyPressed)
-- function in server/1LoadOrder/ORGMServerFunctions.lua
Events.OnKeyPressed.Add(ORGM.itemBindingHandler)

-- function in server/1LoadOrder/ORGMServerFunctions.lua
Events.OnClientCommand.Add(ORGM.Server.onClientCommand)