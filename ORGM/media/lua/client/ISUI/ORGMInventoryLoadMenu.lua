ORGMInventoryLoadMenu = {} --initializing the script, nothing to see here

ORGMInventoryLoadMenu.createMenu = function(player, context, items) --creating the menu items
	
    local playerObj = getSpecificPlayer(player);
	local difficulty = ORGMLoadManager:getDifficulty();
	local isReloadable = false;
	local isReloadableMag = false;
	local isUnloadable = false;
	local isLoading = false;
	local isRacking = false;
	local isAction = false;
	local isSlideOpenable = false;
	local isSlideOpen = false;
	local isBoltOpenable = false;
	local isBoltOpen = false;

	for i,v in ipairs(items) do --runs through all items in inventory and adds context menu options
        local testItem = v;
        if not instanceof(v, "InventoryItem") then
            testItem = v.items[1];
        end
		testData = testItem:getModData()
		if testData.reloadClass == nil then
			ORGMLoadUtil:setUpLoadable(testItem, playerObj)
			testData = testItem:getModData()
		end
		if testData.reloadClass == 'ORGMLoadClass' then --a check to see if the item is an ORGM gun
			local unloadTest = testData.currentCapacity;
			if testData.roundChambered ~= nil and testData.roundChambered == 1 then
				unloadTest = unloadTest + 1
			end
			if testData.containsMag ~= nil and testData.containsMag == 1 and difficulty ~= 1 then
				--test to add eject mag option
				isReloadableMag = true;
			elseif testData.containsMag ~= nil and testData.containsMag ~= 1 and difficulty ~= 1 then
				isReloadable = true;
			elseif (difficulty == 1 or testData.loadStyle ~= 'magfed') and testData.currentCapacity < testData.maxCapacity then --test to add normal reload 
				isReloadable = true;
			end
			if unloadTest > 0 then --test to add unload option
				isUnloadable = true;
			end
			isLoading = ORGMLoadManager:loadStarted() --test to see if loading
			isRacking = ORGMLoadManager:rackingStarted() --test to see if racking
			isAction = isLoading or isRacking --combines the two
			isSlideOpenable = testData.slideOpen == 1; --checks to see if you can lock open the slide, for faster future reload action
			isSlideOpen = testData.slideOpened == 1; --checks to see if the slide is locked open so you can close it
			isBoltOpenable = testData.boltOpen == 1; --checks to see if you can open the bolt and leave it open
			isBoltOpen = testData.boltOpened == 1; --checks to see if the bolt is currently open to give you the option to close it.
			isOpen = testData.isOpen == 1; --checks if the gun is open currently
			isOpenable = testData.openClose == 1; --checks if the gun can open
			isRackable = testData.canRack == 1; --checks if the item is able to be racked
		end
		
		--Iterating an ammo search		
		testData = testItem:getModData()
		tablename = testData.ammoType
		tablenamemag = testData.magType
		ammoTable = _G[tablename] --awesome function to get a table name from a string
		magTable = _G[tablenamemag]
		if magTable ~= nil and difficulty ~= 1 then
			for index,testMag in ipairs(magTable) do --iterates adding an option to load for any mag type present
				if playerObj:getInventory():FindAndReturn(testMag) ~= nil then
					--looks to see if the mag is in your inventory
					local reloadtextindex = ORGMLoadManager:ORGMindexfinder(testMag, Magindexlist);
					local reloadtexttoadd = Magloadtext[reloadtextindex]
					local indexForAction = ORGMLoadManager:ORGMindexfinder(testMag, magTable)
					--finds the index and gets the reload text
					if isReloadable and not isAction then --if the gun is reloadable and you are not performing an action, gives the option to reload
						if indexForAction == 1 then
							local reloadOption = context:addOption(reloadtexttoadd, items, ORGMInventoryLoadMenu.OnReloadm1, playerObj);
						elseif indexForAction == 2 then
							local reloadOption = context:addOption(reloadtexttoadd, items, ORGMInventoryLoadMenu.OnReloadm2, playerObj);
						elseif indexForAction == 3 then
							local reloadOption = context:addOption(reloadtexttoadd, items, ORGMInventoryLoadMenu.OnReloadm3, playerObj);
						elseif indexForAction == 4 then
							local reloadOption = context:addOption(reloadtexttoadd, items, ORGMInventoryLoadMenu.OnReloadm4, playerObj);
						elseif indexForAction == 5 then
							local reloadOption = context:addOption(reloadtexttoadd, items, ORGMInventoryLoadMenu.OnReloadm5, playerObj);
						elseif indexForAction == 6 then
							local reloadOption = context:addOption(reloadtexttoadd, items, ORGMInventoryLoadMenu.OnReloadm6, playerObj);
						elseif indexForAction == 7 then
							local reloadOption = context:addOption(reloadtexttoadd, items, ORGMInventoryLoadMenu.OnReloadm7, playerObj);
						elseif indexForAction == 8 then
							local reloadOption = context:addOption(reloadtexttoadd, items, ORGMInventoryLoadMenu.OnReloadm8, playerObj);
						elseif indexForAction == 9 then
							local reloadOption = context:addOption(reloadtexttoadd, items, ORGMInventoryLoadMenu.OnReloadm9, playerObj);
						else
							local reloadOption = context:addOption(reloadtexttoadd, items, ORGMInventoryLoadMenu.OnReloadm10, playerObj);
						end	
					end
				end
			end
		end		
		if ammoTable ~= nil then
			if difficulty == 1 or testData.loadStyle ~= 'magfed' then
				for i,v in ipairs(ammoTable) do --iterates adding an option to load for any ammo type present
					local testCal = v;
					if playerObj:getInventory():FindAndReturn(testCal) ~= nil then
						--looks to see if the ammo is in your inventory
						local reloadtextindex = ORGMConversions:ORGMindexfinder(testCal, Ammoindexlist);
						local reloadtexttoadd = Ammoloadtext[reloadtextindex]
						--finds the index and gets the reload text
						local indexForAction = ORGMLoadManager:ORGMindexfinder(testCal, ammoTable)
						if isReloadable and not isAction then --if the gun is reloadable and you are not performing an action, gives the option to reload
							if indexForAction == 1 then
								local reloadOption = context:addOption(reloadtexttoadd, items, ORGMInventoryLoadMenu.OnReload1, playerObj);
							elseif indexForAction == 2 then
								local reloadOption = context:addOption(reloadtexttoadd, items, ORGMInventoryLoadMenu.OnReload2, playerObj);
							elseif indexForAction == 3 then
								local reloadOption = context:addOption(reloadtexttoadd, items, ORGMInventoryLoadMenu.OnReload3, playerObj);
							elseif indexForAction == 4 then
								local reloadOption = context:addOption(reloadtexttoadd, items, ORGMInventoryLoadMenu.OnReload4, playerObj);
							elseif indexForAction == 5 then
								local reloadOption = context:addOption(reloadtexttoadd, items, ORGMInventoryLoadMenu.OnReload5, playerObj);
							elseif indexForAction == 6 then
								local reloadOption = context:addOption(reloadtexttoadd, items, ORGMInventoryLoadMenu.OnReload6, playerObj);
							elseif indexForAction == 7 then
								local reloadOption = context:addOption(reloadtexttoadd, items, ORGMInventoryLoadMenu.OnReload7, playerObj);
							elseif indexForAction == 8 then
								local reloadOption = context:addOption(reloadtexttoadd, items, ORGMInventoryLoadMenu.OnReload8, playerObj);
							elseif indexForAction == 9 then
								local reloadOption = context:addOption(reloadtexttoadd, items, ORGMInventoryLoadMenu.OnReload9, playerObj);
							else
								local reloadOption = context:addOption(reloadtexttoadd, items, ORGMInventoryLoadMenu.OnReload10, playerObj);
							end	
						end
					end
				end
			end
		end
		if isReloadableMag and not isAction then --if the gun is reloadable and you are not performing an action, gives the option to eject the mag in the gun
			local reloadOption = context:addOption("Eject Mag.", items, ORGMInventoryLoadMenu.OnEject, playerObj);
		end
		if isUnloadable and not isAction then --if the gun is unloadable and you are not performing an action, gives the option to unload
			local unloadOption = context:addOption("Unload Rounds", items, ORGMInventoryLoadMenu.OnUnload, playerObj)
		end
		if isLoading then --gives the option to stop a reloading action if it is active
			local stopOption = context.addOption("Stop Reloading/Unloading", items, ORGMInventoryLoadMenu.OnStopAction, playerObj)
		end
		if isRacking then --gives you the option to stop a racking action if it is active (and you are fast enough :) )
			local stopOption = context.addOption("Stop Racking", items, ORGMInventoryLoadMenu.OnStopAction, playerObj)
		end
		if isSlideOpenable and not isSlideOpen and not isAction then --allows you to lock the slide open for a faster reload operation later
			local openOption = context.addOption("Lock the Slide Open", items, ORGMLoadManager:openSlideFromUi(testItem), playerObj)
		end
		if isSlideOpen and not isSlideOpenable and not isAction  then --lets you manually close the slide if it is open
			local closeOption = context.addOption("Close the Slide", items, ORGMLoadManager:closeSlideFromUi(testItem), playerObj)
		end
		if isBoltOpenable and not isBoltOpen and not isAction  then --allows you to open the bolt for a faster reload operation later
			local openOption = context.addOption("Open the Bolt", items, ORGMLoadManager:openBoltFromUi(testItem), playerObj)
		end
		if isBoltOpen and not isBoltOpenable and not isAction  then --lets you manually close the bolt if it is open
			local closeOption = context.addOption("Close the Bolt", items, ORGMLoadManager:closeBoltFromUi(testItem), playerObj)
		end
		if isOpen and isOpenable and not isAction  then --lets you manually open the gun for reloading
			local closeOption = context.addOption("Open for Reloading", items, ORGMLoadManager:openFromUi(testItem), playerObj)
		end
		if not isOpen and isOpenable and not isAction  then --lets you manually close the gun for reloading
			local closeOption = context.addOption("Close, Done Reloading", items, ORGMLoadManager:closeFromUi(testItem), playerObj)
		end
		if isRackable and not isAction then --lets you manually rack via ui... inefficient but might as well give the option...
			local rackOption = context.addOption("Rack/Pull Hammer", items, ORGMLoadManager:rackFromUi(testItem), playerObj)
		end
    end
end

ORGMInventoryLoadMenu.OnReload1 = function(items, player)
	local weapon = items[1];
	if not instanceof(items[1], "InventoryItem") then
		weapon = items[1].items[1];
	end
	testData = weapon:getModData()
	tablename = testData.ammoType
	ammoTable = _G[tablename]
	testCal = ammoTable[1]
	ORGMLoadManager:startReloadFromUi(weapon, testCal);
end

ORGMInventoryLoadMenu.OnReload2 = function(items, player)
	local weapon = items[1];
	if not instanceof(items[1], "InventoryItem") then
		weapon = items[1].items[1];
	end
	testData = weapon:getModData()
	tablename = testData.ammoType
	ammoTable = _G[tablename]
	testCal = ammoTable[2]
	ORGMLoadManager:startReloadFromUi(weapon, testCal);
end

ORGMInventoryLoadMenu.OnReload3 = function(items, player)
	local weapon = items[1];
	if not instanceof(items[1], "InventoryItem") then
		weapon = items[1].items[1];
	end
	testData = weapon:getModData()
	tablename = testData.ammoType
	ammoTable = _G[tablename]
	testCal = ammoTable[3]
	ORGMLoadManager:startReloadFromUi(weapon, testCal);
end

ORGMInventoryLoadMenu.OnReload4 = function(items, player)
	local weapon = items[1];
	if not instanceof(items[1], "InventoryItem") then
		weapon = items[1].items[1];
	end
	testData = weapon:getModData()
	tablename = testData.ammoType
	ammoTable = _G[tablename]
	testCal = ammoTable[4]
	ORGMLoadManager:startReloadFromUi(weapon, testCal);
end

ORGMInventoryLoadMenu.OnReload5 = function(items, player)
	local weapon = items[1];
	if not instanceof(items[1], "InventoryItem") then
		weapon = items[1].items[1];
	end
	testData = weapon:getModData()
	tablename = testData.ammoType
	ammoTable = _G[tablename]
	testCal = ammoTable[5]
	ORGMLoadManager:startReloadFromUi(weapon, testCal);
end

ORGMInventoryLoadMenu.OnReload6 = function(items, player)
	local weapon = items[1];
	if not instanceof(items[1], "InventoryItem") then
		weapon = items[1].items[1];
	end
	testData = weapon:getModData()
	tablename = testData.ammoType
	ammoTable = _G[tablename]
	testCal = ammoTable[6]
	ORGMLoadManager:startReloadFromUi(weapon, testCal);
end

ORGMInventoryLoadMenu.OnReload7 = function(items, player)
	local weapon = items[1];
	if not instanceof(items[1], "InventoryItem") then
		weapon = items[1].items[1];
	end
	testData = weapon:getModData()
	tablename = testData.ammoType
	ammoTable = _G[tablename]
	testCal = ammoTable[7]
	ORGMLoadManager:startReloadFromUi(weapon, testCal);
end

ORGMInventoryLoadMenu.OnReload8 = function(items, player)
	local weapon = items[1];
	if not instanceof(items[1], "InventoryItem") then
		weapon = items[1].items[1];
	end
	testData = weapon:getModData()
	tablename = testData.ammoType
	ammoTable = _G[tablename]
	testCal = ammoTable[8]
	ORGMLoadManager:startReloadFromUi(weapon, testCal);
end

ORGMInventoryLoadMenu.OnReload9 = function(items, player)
	local weapon = items[1];
	if not instanceof(items[1], "InventoryItem") then
		weapon = items[1].items[1];
	end
	testData = weapon:getModData()
	tablename = testData.ammoType
	ammoTable = _G[tablename]
	testCal = ammoTable[9]
	ORGMLoadManager:startReloadFromUi(weapon, testCal);
end

ORGMInventoryLoadMenu.OnReload10 = function(items, player)
	local weapon = items[1];
	if not instanceof(items[1], "InventoryItem") then
		weapon = items[1].items[1];
	end
	testData = weapon:getModData()
	tablename = testData.ammoType
	ammoTable = _G[tablename]
	testCal = ammoTable[10]
	ORGMLoadManager:startReloadFromUi(weapon, testCal);
end

ORGMInventoryLoadMenu.OnReloadm1 = function(items, player)
	local weapon = items[1];
	if not instanceof(items[1], "InventoryItem") then
		weapon = items[1].items[1];
	end
	testData = weapon:getModData()
	tablename = testData.magType
	magTable = _G[tablename]
	testMag = magTable[1]
	ORGMLoadManager:startReloadFromUi(weapon, testMag);
end

ORGMInventoryLoadMenu.OnReloadm2 = function(items, player)
	local weapon = items[1];
	if not instanceof(items[1], "InventoryItem") then
		weapon = items[1].items[1];
	end
	testData = weapon:getModData()
	tablename = testData.magType
	magTable = _G[tablename]
	testMag = magTable[2]
	ORGMLoadManager:startReloadFromUi(weapon, testMag);
end

ORGMInventoryLoadMenu.OnReloadm3 = function(items, player)
	local weapon = items[1];
	if not instanceof(items[1], "InventoryItem") then
		weapon = items[1].items[1];
	end
	testData = weapon:getModData()
	tablename = testData.magType
	magTable = _G[tablename]
	testMag = magTable[3]
	ORGMLoadManager:startReloadFromUi(weapon, testMag);
end

ORGMInventoryLoadMenu.OnReloadm4 = function(items, player)
	local weapon = items[1];
	if not instanceof(items[1], "InventoryItem") then
		weapon = items[1].items[1];
	end
	testData = weapon:getModData()
	tablename = testData.magType
	magTable = _G[tablename]
	testMag = magTable[4]
	ORGMLoadManager:startReloadFromUi(weapon, testMag);
end

ORGMInventoryLoadMenu.OnReloadm5 = function(items, player)
	local weapon = items[1];
	if not instanceof(items[1], "InventoryItem") then
		weapon = items[1].items[1];
	end
	testData = weapon:getModData()
	tablename = testData.magType
	magTable = _G[tablename]
	testCal = magTable[5]
	ORGMLoadManager:startReloadFromUi(weapon, testMag);
end

ORGMInventoryLoadMenu.OnReloadm6 = function(items, player)
	local weapon = items[1];
	if not instanceof(items[1], "InventoryItem") then
		weapon = items[1].items[1];
	end
	testData = weapon:getModData()
	tablename = testData.magType
	magTable = _G[tablename]
	testMag = magTable[6]
	ORGMLoadManager:startReloadFromUi(weapon, testMag);
end

ORGMInventoryLoadMenu.OnReloadm7 = function(items, player)
	local weapon = items[1];
	if not instanceof(items[1], "InventoryItem") then
		weapon = items[1].items[1];
	end
	testData = weapon:getModData()
	tablename = testData.magType
	magTable = _G[tablename]
	testMag = magTable[7]
	ORGMLoadManager:startReloadFromUi(weapon, testMag);
end

ORGMInventoryLoadMenu.OnReloadm8 = function(items, player)
	local weapon = items[1];
	if not instanceof(items[1], "InventoryItem") then
		weapon = items[1].items[1];
	end
	testData = weapon:getModData()
	tablename = testData.magType
	magTable = _G[tablename]
	testMag = magTable[8]
	ORGMLoadManager:startReloadFromUi(weapon, testMag);
end

ORGMInventoryLoadMenu.OnReloadm9 = function(items, player)
	local weapon = items[1];
	if not instanceof(items[1], "InventoryItem") then
		weapon = items[1].items[1];
	end
	testData = weapon:getModData()
	tablename = testData.magType
	magTable = _G[tablename]
	testMag = magTable[9]
	ORGMLoadManager:startReloadFromUi(weapon, testMag);
end

ORGMInventoryLoadMenu.OnReloadm10 = function(items, player)
	local weapon = items[1];
	if not instanceof(items[1], "InventoryItem") then
		weapon = items[1].items[1];
	end
	testData = weapon:getModData()
	tablename = testData.magType
	magTable = _G[tablename]
	testMag = magTable[10]
	ORGMLoadManager:startReloadFromUi(weapon, testMag);
end

ORGMInventoryLoadMenu.OnEject = function(items, player)
	local weapon = items[1];
	if not instanceof(items[1], "InventoryItem") then
		weapon = items[1].items[1];
	end
	ORGMLoadManager:startReloadFromUi(weapon);
end

ORGMInventoryLoadMenu.OnUnload = function(items, player)
	local weapon = items[1];
	if not instanceof(items[1], "InventoryItem") then
		weapon = items[1].items[1];
	end
	ORGMLoadManager:startUnloadFromUi(weapon);
end

ORGMInventoryLoadMenu.OnStopAction = function(items, player)
	local weapon = items[1];
	if not instanceof(items[1], "InventoryItem") then
		weapon = items[1].items[1];
	end
	ORGMLoadAction:stop();
end

Events.OnFillInventoryObjectContextMenu.Add(ORGMInventoryLoadMenu.createMenu); --the add menu options hook

--below are all the tables for the loading operations

	Ammolist357 = {
			"357Rounds",
			"357HPRounds",
			"38Rounds",
			"38HPRounds",
			"38SSRounds",
			};
	Ammolist3572 = {
			"357Rounds",
			"357HPRounds",
			};
	Ammolist38 = {
			"38Rounds",
			"38HPRounds",
			"38SSRounds",
			};
	Ammolist762 = {
			"762Rounds",
			"762HPRounds",
			};
	Ammolist9mm = {
			"9mmRounds",
			"9mmHPRounds",
			};
	Ammolist12g = {
			"12gRounds",
			"12gSlugRounds",
			"12gBSRounds",
			};
	Ammolist22 = {
			"22Rounds",
			"22HPRounds",
			};
	Ammolist40 = {
			"40Rounds",
			"40HPRounds",
			};
	Ammolist44 = {
			"44Rounds",
			"44HPRounds",
			"44SSRounds",
			"44SPCRounds",
			"44SPCHPRounds",
			};
	Ammolist442 = {
			"44Rounds",
			"44HPRounds",
			"44SSRounds",
			};
	Ammolist44SPC = {
			"44SPCRounds",
			"44SPCHPRounds",
			};
	Ammolist45 = {
			"45Rounds",
			"45HPRounds",
			};
	Ammolist38S = {
			"38SRounds",
			"38SHPRounds",
			};
	Ammolist223 = {
			"223Rounds",
			"223HPRounds",
			"556Rounds",
			"556HPRounds",
			};
	Ammolist556 = {
			"556Rounds",
			"556HPRounds",
			"223Rounds",
			"223HPRound",
			};
	Ammolist3006 = {
			"3006Rounds",
			"3006HPRounds",
			};
	Ammolist3030 = {
			"3030Rounds",
			"3030HPRounds",
			};
	Ammolist308 = {
			"308Rounds",
			"308HPRounds",
			"762x51Rounds",
			"762x51HPRounds",
			};
	Ammolist762x51 = {
			"762x51Rounds",
			"762x51Rounds",
			"308Rounds",
			"308HPRounds",
			};
	Ammolist762x54 = {
			"762x54Rounds",
			"762x54HPRounds",
			};
	Ammolist454 = {
			"454Rounds",
			"454HPRounds",
			"45ColtRounds",
			"45ColtHPRounds",
			"410Rounds",
			"410SlugRounds",
			"410BSRounds",
			};
	Ammolist50AE = {
			"50AERounds",
			"50AEHPRounds",
			};
	AmmolistBBs = {
			"BBs",
			};
	Ammolist57 = {
			"57Rounds",
			"57HPRounds",
			};
	Ammolist10mm = {
			"10mmRounds",
			"10mmHPRounds",
			};
	Ammolist10mm2 = {
			"10mmRounds",
			"10mmHPRounds",
			"40Rounds",
			"40HPRounds",
			};
	Ammolist45Colt = {
			"45ColtRounds",
			"45ColtHPRoounds",
			"410Rounds",
			"410SlugRounds",
			"410BSRounds",
			};
	Ammolist380 = {
			"380Rounds",
			"380HPRounds",
			};
	Ammolist32 = {
			"32Rounds",
			"32HPRounds",
			};
	Ammolist410 = {
			"410Rounds",
			"410SlugRounds",
			"410BSRounds",
			};
	Ammolist20g = {
			"20gRounds",
			"20gSlugRounds",
			"20gBSRounds",
			};
	Ammolist22250 = {
			"22250Rounds",
			"22250HPRounds",
			};
			
	Ammolist300 = {
			"300Rounds",
			"300HPRounds",
			};
			
	Ammolist30 = {
			"30Rounds",
			"30HPRounds",
			};
			
	Ammolist303 = {
			"303Rounds",
			"303HPRounds",
			};
	AmmolistSmP = {
			"9mmRounds",
			"9mmHPRounds",
			"32Rounds",
			"32HPRounds",
			"380Rounds",
			"380HPRounds",
			};
			
	Ammoindexlist = {
			"357Rounds",
			"357HPRounds",
			"38Rounds",
			"38HPRounds",
			"38SSRounds",
			"762Rounds",
			"762HPRounds",
			"9mmRounds",
			"9mmHPRounds",
			"12gRounds",
			"12gSlugRounds",
			"12gBSRounds",
			"22Rounds",
			"22HPRounds",
			"40Rounds",
			"40HPRounds",
			"44Rounds",
			"44HPRounds",
			"44SSRounds",
			"44SPCRounds",
			"44SPCHPRounds",
			"45Rounds",
			"45HPRounds",
			"38SRounds",
			"38SHPRounds",
			"223Rounds",
			"223HPRounds",
			"556Rounds",
			"556HPRounds",
			"3006Rounds",
			"3006HPRounds",
			"3030Rounds",
			"3030HPRounds",
			"762x51Rounds",
			"762x51Rounds",
			"308Rounds",
			"308HPRounds",
			"762x54Rounds",
			"762x54HPRounds",
			"454Rounds",
			"454HPRounds",
			"45ColtRounds",
			"45ColtHPRounds",
			"410Rounds",
			"410SlugRounds",
			"410BSRounds",
			"50AERounds",
			"50AEHPRounds",
			"BBs",
			"57Rounds",
			"57HPRounds",
			"10mmRounds",
			"10mmHPRounds",
			"380Rounds",
			"380HPRounds",
			"32Rounds",
			"32HPRounds",
			"20gRounds",
			"20gSlugRounds",
			"20gBSRounds",
			"22250Rounds",
			"22250HPRounds",
			"300Rounds",
			"300HPRounds",
			"30Rounds",
			"30HPRounds",
			"303Rounds",
			"303HPRounds",
			};
			
	Ammoloadtext= {
			"Load with .357 Mag. FMJ rounds",
			"Load with .357 Mag. HP rounds",
			"Load with .38 Spc. FMJ rounds",
			"Load with .38 Spc. HP rounds",
			"Load with .38 shot shells",
			"Load with 7.62x39mm FMJ rounds",
			"Load with 7.62x39mm HP rounds",
			"Load with 9x19mm FMJ rounds",
			"Load with 9x19mm HP rounds",
			"Load with 12 gauge 00 shells",
			"Load with 12 gauge slugs",
			"Load with 12 gauge birdshot shells",
			"Load with .22 LR FMJ rounds",
			"Load with .22 LR HP rounds",
			"Load with .40 S&W FMJ rounds",
			"Load with .40 S&W HP rounds",
			"Load with .44 Mag. FMJ rounds",
			"Load with .44 Mag. HP rounds",
			"Load with .44 shot shells",
			"Load with .44 Spc. FMJ rounds",
			"Load with .44 Spc. HP rounds",
			"Load with .45 ACP FMJ rounds",
			"Load with .45 ACP HP rounds",
			"Load with .38 Sup. FMJ rounds",
			"Load with .38 Sup. HP rounds",
			"Load with .223 Rem. FMJ rounds",
			"Load with .223 Rem. HP rounds",
			"Load with 5.56x45mm FMJ rounds",
			"Load with 5.56x45mm HP rounds",
			"Load with .30-06 Spr. FMJ rounds",
			"Load with .30-06 Spr. HP rounds",
			"Load with .30-30 Win. FMJ rounds",
			"Load with .30-30 Win HP rounds",
			"Load with 7.62x51mm FMJ rounds",
			"Load with 7.62x51mm HP rounds",
			"Load with .308 Win. FMJ rounds",
			"Load with .308 Win. HP rounds",
			"Load with 7.62x54mmR FMJ rounds",
			"Load with 7.62x54mmR HP rounds",
			"Load with .454 Casull FMJ rounds",
			"Load with .454 Casull HP rounds",
			"Load with .45 Colt FMJ rounds",
			"Load with .45 Colt HP rounds",
			"Load with .410 bore 00 rounds",
			"Load with .410 bore slugs",
			"Load with .410 bore birdshot rounds",
			"Load with .50 AE FMJ rounds",
			"Load with .50 AE HP rounds",
			"Load with .117 BBs",
			"Load with 5.7x28mm FMJ rounds",
			"Load with 5.7x28mm HP rounds",
			"Load with 10mm auto FMJ rounds",
			"Load with 10mm auto HP rounds",
			"Load with .380 ACP FMJ rounds",
			"Load with .380 ACP HP rounds",
			"Load with .32 ACP FMJ rounds",
			"Load with .32 ACP HP rounds",
			"Load with 20 gauge 00 rounds",
			"Load with 20 gauge slugs",
			"Load with 20 gauge birdshot rounds",
			"Load with .22-250 Rem. FMJ rounds",
			"Load with .22-250 Rem. HP rounds",
			"Load with .300 Win. Mag. FMJ rounds",
			"Load with .300 Win. Mag. HP rounds",
			"Load with .30 carbine FMJ rounds",
			"Load with .30 carbine HP rounds",
			"Load with .303 Brit. FMJ rounds",
			"Load with .303 Brit. HP rounds",
			};
			
	Ammoshelllist = {
			"357Shell",
			"357Shell",
			"38Shell",
			"38Shell",
			"38Shell",
			"762Shell",
			"762Shell",
			"9mmShell",
			"9mmShell",
			"12gShell",
			"12gShell",
			"12gShell",
			"22Shell",
			"22Shell",
			"40Shell",
			"40Shell",
			"44Shell",
			"44Shell",
			"44Shell",
			"44SPCShell",
			"44SPCShell",
			"45Shell",
			"45Shell",
			"38SShell",
			"38SShell",
			"223Shell",
			"223Shell",
			"556Shell",
			"556Shell",
			"3006Shell",
			"3006Shell",
			"3030Shell",
			"3030Shell",
			"762x51Shell",
			"762x51Shell",
			"308Shell",
			"308Shell",
			"762x54Shell",
			"762x54Shell",
			"454Shell",
			"454Shell",
			"45ColtShell",
			"45ColtShell",
			"410Shell",
			"410Shell",
			"410Shell",
			"50AEShell",
			"50AEShell",
			"BBs",
			"57Shell",
			"57Shell",
			"10mmShell",
			"10mmShell",
			"380Shell",
			"380Shell",
			"32Shell",
			"32Shell",
			"20gShell",
			"20gShell",
			"20gShell",
			"22250Shell",
			"22250Shell",
			"300Shell",
			"300Shell",
			"30Shell",
			"30Shell",
			"303Shell",
			"303Shell",
			};
			

	Magindexlist= {
			"BerMag10",
			"BerMag15",
			"BerMag17",
			"BerMag20",
			"BerMag30",
			"BerMag32",
			"BrownHPMag10",
			"BrownHPMag13",
			"BrownHPMag15",
			"Glock9mmMag6",
			"Glock9mmMag10comp",
			"Glock9mmMag10full",
			"Glock9mmMag10scomp",
			"Glock9mmMag12",
			"Glock9mmMag15",
			"Glock9mmMag17",
			"Glock9mmMag19",
			"Glock9mmMag31",
			"Glock9mmMag33",
			"Glock9mmMag50",
			"HKMP5Mag10",
			"HKMP5Mag15",
			"HKMP5Mag20",
			"HKMP5Mag30",
			"HKMP5Mag40",
			"HKMP5Mag50",
			"HKMP5Mag100",
			"HKP7Mag13",
			"KelTecP11Mag10",
			"M19119Mag8",
			"M19119Mag9off",
			"M19119Mag9std",
			"M19119Mag10",
			"RugerP9mmMag10",
			"RugerP9mmMag15",
			"RugerP9mmMag17",
			"RugerP9mmMag20",
			"RugerP9mmMag32",
			"RugerSR9Mag10",
			"RugerSR9Mag10comp",
			"RugerSR9Mag17",
			"S&W5906Mag10",
			"S&W5906Mag15",
			"S&W5906Mag17",
			"S&W5906Mag20",
			"S&WMP9Mag7shield",
			"S&WMP9Mag8shield",
			"S&WMP9Mag10",
			"S&WMP9Mag10comp",
			"S&WMP9Mag12comp",
			"S&WMP9Mag15",
			"S&WMP9Mag17",
			"TaurusPT111Mag10",
			"TaurusPT111Mag12",
			"Tec9Mag20",
			"Tec9Mag32",
			"Tec9Mag50",
			"UziMag20",
			"UziMag25",
			"UziMag32",
			"UziMag40",
			"UziMag50",
			};
			
	MaglistBeretta= {
			"BerMag10",
			"BerMag15",
			"BerMag17",
			"BerMag20",
			"BerMag30",
			"BerMag32",
			};
			
	Magloadtext= {
			"Insert Beretta 10 rnd Mag.",
			"Insert Beretta 15 rnd Mag.",
			"Insert Beretta 17 rnd Mag.",
			"Insert Beretta 20 rnd Mag.",
			"Insert Beretta 30 rnd Mag.",
			"Insert Beretta 32 rnd Mag.",
			"Insert Browning 10 rnd Mag.",
			"Insert Browning 15 rnd Mag.",
			"Insert Browning 17 rnd Mag.",
			"Insert Glock 9mm (holdout) 6 rnd Mag.",
			"Insert Glock 9mm (compact) 10 rnd Mag.",
			"Insert Glock 9mm (full) 10 rnd Mag.",
			"Insert Glock 9mm (sub-compact) 10 rnd Mag.",
			"Insert Glock 9mm (sub-compact) 12 rnd Mag.",
			"Insert Glock 9mm (compact) 15 rnd Mag.",
			"Insert Glock 9mm (full) 17 rnd Mag.",
			"Insert Glock 9mm (full) 19 rnd Mag.",
			"Insert Glock 9mm (full) 31 rnd Mag.",
			"Insert Glock 9mm (full) 33 rnd Mag.",
			"Insert Glock 9mm (full) 50 rnd Mag.",
			"Insert H&K MP5 10 rnd Mag.",
			"Insert H&K MP5 15 rnd Mag.",
			"Insert H&K MP5 20 rnd Mag.",
			"Insert H&K MP5 30 rnd Mag.",
			"Insert H&K MP5 40 rnd Mag.",
			"Insert H&K MP5 50 rnd Mag.",
			"Insert H&K MP5 100 rnd Mag.",
			"Insert H&K P7 13 rnd Mag.",
			"Insert Kel-Tec P11 10 rnd Mag.",
			"Insert M1911 9mm (officer) 8 rnd Mag.",
			"Insert M1911 9mm (officer) 9 rnd Mag.",
			"Insert M1911 9mm (standard) 9 rnd Mag.",
			"Insert M1911 9mm (standard) 10 rnd Mag.",
			"Insert Ruger P 10 rnd Mag.",
			"Insert Ruger P 15 rnd Mag.",
			"Insert Ruger P 17 rnd Mag.",
			"Insert Ruger P 20 rnd Mag.",
			"Insert Ruger P 32 rnd Mag.",
			"Insert Ruger SR9 10 rnd Mag.",
			"Insert Ruger SR9 (compact) 10 rnd Mag.",
			"Insert Ruger SR9 17 rnd Mag.",
			"Insert S&W 5906 10 rnd Mag.",
			"Insert S&W 5906 15 rnd Mag.",
			"Insert S&W 5906 17 rnd Mag.",
			"Insert S&W 5906 20 rnd Mag.",
			"Insert S&W M&P 9 (shield) 7 rnd Mag.",
			"Insert S&W M&P 9 (shield) 8 rnd Mag.",
			"Insert S&W M&P 9 10 rnd Mag.",
			"Insert S&W M&P 9 (compact) 10 rnd Mag.",
			"Insert S&W M&P 9 (compact) 12 rnd Mag.",
			"Insert S&W M&P 9 15 rnd Mag.",
			"Insert S&W M&P 9 17 rnd Mag.",
			"Insert Taurus PT111 10 rnd Mag.",
			"Insert Taurus PT111 12 rnd Mag.",
			"Insert Tec 9 20 rnd Mag.",
			"Insert Tec 9 32 rnd Mag.",
			"Insert Tec 9 50 rnd Mag.",
			"Insert Uzi 20 rnd Mag.",
			"Insert Uzi 25 rnd Mag.",
			"Insert Uzi 32 rnd Mag.",
			"Insert Uzi 40 rnd Mag.",
			"Insert Uzi 50 rnd Mag.",
			};