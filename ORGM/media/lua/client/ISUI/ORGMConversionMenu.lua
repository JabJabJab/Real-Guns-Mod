ORGMConversionMenu = {}

ORGMConversionMenu.createMenu = function(player, context, items)

    local isConvertable = false;
	local isInInv = false;
	
    local playerObj = getSpecificPlayer(player)
	
	for i,v in ipairs(items) do
        local testItem = v;
        if not instanceof(v, "InventoryItem") then
            testItem = v.items[1];
			testType = testItem:getType()
			testIndex = ORGMConversions:ORGMindexfinder(testType, ConversionIndexTable);
        end
		if(testIndex ~= -1) then
			isConvertable = true;
		end
		if(playerObj:getInventory():FindAndReturn(testType) ~= nil) then
			isInInv = true;
		end
    end
	
	if isConvertable and isInInv then
		local item = items[1];
		if not instanceof(items[1], "InventoryItem") then
			item = items[1].items[1];
		end
		ConvText = ConversionContextTable[testIndex]
		context:addOption(ConvText, items, ORGMConversionMenu.OnConvert, playerObj);
	end
end

ORGMConversionMenu.OnConvert = function(items, player)
	local convItem = items[1];
	if not instanceof(items[1], "InventoryItem") then
		convItem = items[1].items[1];
	end
	ORGMConversions:StartConvertfromUi(convItem);
end

Events.OnFillInventoryObjectContextMenu.Add(ORGMConversionMenu.createMenu);