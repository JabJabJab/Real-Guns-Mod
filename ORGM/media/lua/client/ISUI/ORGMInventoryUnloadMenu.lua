ORGMInventoryUnloadMenu = {}

ORGMInventoryUnloadMenu.createMenu = function(player, context, items)

    local isUnloadable = false;
	
    local playerObj = getSpecificPlayer(player)
	
	for i,v in ipairs(items) do
        local testItem = v;
        if not instanceof(v, "InventoryItem") then
            testItem = v.items[1];
        end
		if testItem:getModData().currentCapacity ~= nil then
			capacity = testItem:getModData().currentCapacity
		else
			capacity = 0
		end
		if testItem:getModData().roundChambered ~= nil then
			chambered = testItem:getModData().roundChambered
		else
			chambered = 0
		end
			unloadtester = capacity + chambered
		if(unloadtester > 0) then
			isUnloadable = true;
		end
    end
	
	if isUnloadable then
		local item = items[1];
		if not instanceof(items[1], "InventoryItem") then
			item = items[1].items[1];
		end
		context:addOption("Unload", items, ORGMInventoryUnloadMenu.OnUnload, playerObj);
	end
end

ORGMInventoryUnloadMenu.OnUnload = function(items, player)
	local weapon = items[1];
	if not instanceof(items[1], "InventoryItem") then
		weapon = items[1].items[1];
	end
	ORGMUnloadManager:startUnloadFromUi(weapon);
end

Events.OnFillInventoryObjectContextMenu.Add(ORGMInventoryUnloadMenu.createMenu);