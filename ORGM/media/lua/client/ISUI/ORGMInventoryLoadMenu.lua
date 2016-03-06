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
		if testData.reloadClass ~= nil then
		
		else
			ORGMLoadUtil:setUpLoadable(testItem, playerObj)
		end
		testData = testItem:getModData()
		if testData.reloadClass == 'ORGMLoadClass' then --a check to see if the item is an ORGM gun
			local unloadTest = testData.currentCapacity;
			if testData.roundChambered ~= nil and testData.roundChambered == 1 then
				unloadTest = unloadTest + 1
			end
			if testData.magInserted ~= nil and testData.magInserted == 1 and difficulty ~= 1 then
				--test to add eject mag option
				isReloadableMag = true;
			elseif testData.magInserted ~= nil and testData.magInserted ~= 1 and difficulty ~= 1 then
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
			for i,v in ipairs(magTable) do --iterates adding an option to load for any mag type present
				local testMag = v;
				if playerObj:getInventory():FindAndReturn(testMag) ~= nil then
					--looks to see if the mag is in your inventory
					local reloadtextindex = ORGMLoadManager:ORGMindexfinder(testMag, Magindexlist);
					local reloadtexttoadd = Magloadtext[reloadtextindex]
					--finds the index and gets the reload text
					if isReloadable and not isAction then --if the gun is reloadable and you are not performing an action, gives the option to reload
						local reloadOption = context:addOption(reloadtexttoadd, items, ORGMLoadManager.startReloadFromUi(testItem, testMag), playerObj, testCal);
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
			local reloadOption = context:addOption("Eject Mag.", items, ORGMLoadManager:startReloadFromUi(testItem), playerObj);
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
			"Ber92Mag"
			};
			
	Magloadtext= {
			"Insert Standard Beretta Mag.",
			};