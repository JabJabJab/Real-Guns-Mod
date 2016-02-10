ORGMItemGen = {}

ORGMItemGen.GenerateItem = function(tbl, container, add, CPM, BHGSP)
	if add then
	item = container:AddItems(add,1);
		for i=0, item:size()-1 do
			local AddItem = item:get(i);
			ReloadUtil:syncItemToReloadable(AddItem, getPlayer())
			AddData = AddItem:getModData()
			local MaxAmmo = AddData.maxCapacity
			local Condit = AddItem.CurrentCapacity
			if AddData.roundChambered ~= nil then
				MaxAmmo = MaxAmmo + 1
			end
			if BHGSP == "Body" then
				if ZombRand(10) <3 then
					AmmoFill = 0
				else
					AmmoFill = ZombRand(MaxAmmo)
				end
				condmult = ZombRand(10) / 10
				if ZombRand(10) <= 1 then
					condmult = 0
				elseif ZombRand(10) <= 4 then
					condmult = condmult / 2
				end
			elseif BHGSP == "House" then
				if ZombRand(10) > 7 then
					AmmoFill = MaxAmmo
				else
					AmmoFill = 0
				end
				condmult = ZombRand(10) / 10
				if ZombRand(10) <= 1 then
					condmult = 0
				elseif ZombRand(10) <= 4 then
					condmult = condmult / 2
				end
			elseif BHGSP == "Gas" then
				AmmoFill = MaxAmmo
				condmult = ZombRand(10) / 10
				if ZombRand(10) <= 4 then
					condmult = condmult / 2
				end
			elseif BHGSP == "Store" then
				AmmoFill = 0
				if ZombRand(10) <=4 then
					condmod = ZombRand(3)-1
					condmod = condmod / 2
					condmult = 10 - condmod
				else 
					condmult = 1
				end
			elseif BHGSP == "Police" then
				AmmoFill = 0
				if ZombRand(10) <=4 then
					condmod = ZombRand(3)-1
					condmod = condmod / 2
					condmult = 10 - condmod
				else 
					condmult = 1
				end
			end
			if AmmoFill ~= 0 and AmmoFill ~= nil then
				if AddData.roundChambered ~= nil then
					AddData.roundChambered = 1
					AmmoFill = AmmoFill - 1				
				end
				AddData.currentCapacity = AmmoFill
			end
			if Condit ~= nil and condmult ~= nil then
				Condit = Condit * condmult
			end
			if WeaponUpgrades[AddItem:getType()] then
				ItemPicker.doWeaponUpgrade(AddItem);
			end			
		end
	end
end
