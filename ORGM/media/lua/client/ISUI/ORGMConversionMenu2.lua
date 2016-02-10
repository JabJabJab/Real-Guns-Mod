ORGMConversionMenu2 = {}

ORGMConversionMenu2.createMenu = function(player, context, items)

    local isConvertable = false;
	
    local playerObj = getSpecificPlayer(player)
	
	for i,v in ipairs(items) do
        local testItem = v;
        if not instanceof(v, "InventoryItem") then
            testItem = v.items[1];
			testType = testItem:getType()
			testIndex = ORGMConversions:ORGMindexfinder(testType, ConversionIndexTable2);
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
		ConvText = ConversionContextTable2[testIndex]
		context:addOption(ConvText, items, ORGMConversionMenu2.OnConvert, playerObj);
	end
end

ORGMConversionMenu2.OnConvert = function(items, player)
	local convItem = items[1];
	if not instanceof(items[1], "InventoryItem") then
		convItem = items[1].items[1];
	end
	ORGMConversions2:StartConvertfromUi(convItem);
end

Events.OnFillInventoryObjectContextMenu.Add(ORGMConversionMenu2.createMenu);

	ConversionIndexTable2 = {
			"BenelliM3",
			"BenelliM3PA",
			"BenelliM3SO",
			"BenelliM3SOPA",
			"BenelliM3Sl",
			"BenelliM3PASl",
			"BenelliM3SOSl",
			"BenelliM3PASOSl",
			"Spas12",
			"Spas12PA",
			"Spas12Sl",
			"Spas12PASl",
			};
			
	ConversionWeaponTable2 = {
			"BenelliM3PA",
			"BenelliM3",
			"BenelliM3SOPA",
			"BenelliM3SO",
			"BenelliM3PASl",
			"BenelliM3Sl",
			"BenelliM3PASOSl",
			"BenelliM3SOSl",
			"Spas12PA",
			"Spas12",
			"Spas12PASl",
			"Spas12Sl",
			};

	ConversionContextTable2 = {
			"Switch to Pump-Action",
			"Switch to Semi-Auto",
			"Switch to Pump-Action",
			"Switch to Semi-Auto",
			"Switch to Pump-Action",
			"Switch to Semi-Auto",
			"Switch to Pump-Action",
			"Switch to Semi-Auto",
			"Switch to Pump-Action",
			"Switch to Semi-Auto",
			"Switch to Pump-Action",
			"Switch to Semi-Auto",
			};
