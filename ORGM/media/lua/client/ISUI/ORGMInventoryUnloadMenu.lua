local OnUnload = function(items, player)
	local weapon = items[1];
	if not instanceof(items[1], "InventoryItem") then
		weapon = items[1].items[1]
	end
	ORGMUnloadManager:startUnloadFromUi(weapon);
end

Events.OnFillInventoryObjectContextMenu.Add(function(player, context, items)

    local isUnloadable = false;
	
    local playerObj = getSpecificPlayer(player)
	
	for i,v in ipairs(items) do
        local testItem = v;
        if not instanceof(v, "InventoryItem") then
            testItem = v.items[1];
        end
        local capacity = 0
        local data = testItem:getModData()
		if data.currentCapacity ~= nil then
			capacity = data.currentCapacity
		end
		if data.roundChambered ~= nil then
			capacity = capacity + data.roundChambered
		end
		if(capacity > 0) then
			isUnloadable = true;
		end
    end
	
	if isUnloadable then
		local item = items[1];
		if not instanceof(items[1], "InventoryItem") then
			item = items[1].items[1];
		end
		context:addOption("Unload", items, OnUnload, playerObj);
	end
end
)
