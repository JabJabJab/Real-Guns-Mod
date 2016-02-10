function ORGMDistr(_roomName, _containerType, _containerFilled)
	local diff = ReloadManager[1]:getDifficulty();
	local quantity = 0
	local quantity1 = 0
	if _roomName == "all" and _containerType == "inventorymale" then
		if rnd(100) >= 98 then
			if rnd(10) < 8 then
				if rnd (10) < 8 then
					GunIndex = rnd(#CivWepTableCom);
					local item = CivWepTableCom[GunIndex]
					ORGMItemGen:GenerateItem(_containerFilled, item, "Civilian", "Body")
					quantity = rnd(15)
					if rnd(10) >= 9 then
						while quantity ~=0 do
							_containerFilled:AddItem(CWCAmmoTable2[GunIndex]);
							quantity = quantity-1
						end
					else
						while quantity ~=0 do
							_containerFilled:AddItem(CWCAmmoTable[GunIndex]);
							quantity = quantity-1
						end
					end
					if rnd(10) >= 9 then
						if rnd(10) >= 9 then
							_containerFilled:AddItem(CWCBoxTable2[GunIndex]);
						else
							_containerFilled:AddItem(CWCBoxTable[GunIndex]);
						end
					end
					if diff >= 2 then
						if rnd(10) >= 7 then
							quantity = rnd(2)
							if CWCMagTable[GunIndex] ~= "" then
								while quantity ~=0 do
									local item = CWCMagTable[GunIndex]
									ORGMItemGen:GenerateItem(_containerFilled, item, "Civilian", "Body")
									quantity = quantity-1
								end
							end
						end
					end
				elseif rnd (10) < 8 then 
					GunIndex = rnd(#CivWepTableRare);
					local item = CivWepTableRare[GunIndex]
					ORGMItemGen:GenerateItem(_containerFilled, item, "Civilian", "Body")
					quantity = rnd(15)
					if rnd(10) >= 9 then
						while quantity ~=0 do
							_containerFilled:AddItem(CWRAmmoTable2[GunIndex]);
							quantity = quantity-1
						end
					else
						while quantity ~=0 do
							_containerFilled:AddItem(CWRAmmoTable[GunIndex]);
							quantity = quantity-1
						end
					end
					if rnd(10) >= 9 then
						if rnd(10) >= 9 then
							_containerFilled:AddItem(CWRBoxTable2[GunIndex]);
						else
							_containerFilled:AddItem(CWRBoxTable[GunIndex]);
						end
					end
					if diff >= 2 then
						if rnd(10) >= 7 then
							quantity = rnd(2)
							if CWRMagTable[GunIndex] ~= "" then
								while quantity ~=0 do
									local item = CWRMagTable[GunIndex]
									ORGMItemGen:GenerateItem(_containerFilled, item, "Civilian", "Body")
									quantity = quantity-1
								end
							end
						end
					end
				else
					GunIndex = rnd(#CivWepTableSuperRare);
					local item = CivWepTableSuperRare[GunIndex]
					ORGMItemGen:GenerateItem(_containerFilled, item, "Civilian", "Body")
					quantity = rnd(15)
					if rnd(10) >= 9 then
						while quantity ~=0 do
							_containerFilled:AddItem(CWSRAmmoTable2[GunIndex]);
							quantity = quantity-1
						end
					else
						while quantity ~=0 do
							_containerFilled:AddItem(CWSRAmmoTable[GunIndex]);
							quantity = quantity-1
						end
					end
					if rnd(10) >= 9 then
						if rnd(10) >= 9 then
							_containerFilled:AddItem(CWSRBoxTable2[GunIndex]);
						else
							_containerFilled:AddItem(CWSRBoxTable[GunIndex]);
						end
					end
					if diff >= 2 then
						if rnd(10) >= 7 then
							quantity = rnd(2)
							if CWSRMagTable[GunIndex] ~= "" then
								while quantity ~=0 do
									local item = CWSRMagTable[GunIndex]
									ORGMItemGen:GenerateItem(_containerFilled, item, "Civilian", "Body")
									quantity = quantity-1
								end
							end
						end
					end		
				end
			else
				if rnd (10) < 7 then
					if rnd (10) < 8 then
						GunIndex = rnd(#PolWepTableCom);
						local item = PolWepTableCom[GunIndex]
						ORGMItemGen:GenerateItem(_containerFilled, item, "Police", "Body")
						quantity = rnd(15)
						if rnd(10) >= 9 then
							while quantity ~=0 do
								_containerFilled:AddItem(PWCAmmoTable2[GunIndex]);
								quantity = quantity-1
							end
						else
							while quantity ~=0 do
								_containerFilled:AddItem(PWCAmmoTable[GunIndex]);
								quantity = quantity-1
							end
						end
						if rnd(10) >= 9 then
							if rnd(10) >= 9 then
								_containerFilled:AddItem(PWCBoxTable2[GunIndex]);
							else
								_containerFilled:AddItem(PWCBoxTable[GunIndex]);
							end
						end
						if diff >= 2 then
							if rnd(10) >= 7 then
								quantity = rnd(2)
								if PWCMagTable[GunIndex] ~= "" then
									while quantity ~=0 do
										local item = PWCMagTable[GunIndex]
										ORGMItemGen:GenerateItem(_containerFilled, item, "Police", "Body")
										quantity = quantity-1
									end
								end
							end
						end
					else
						GunIndex = rnd(#PolWepTableRare);
						local item = PolWepTableRare[GunIndex]
						ORGMItemGen:GenerateItem(_containerFilled, item, "Police", "Body")
						quantity = rnd(15)
						if rnd(10) >= 9 then
							while quantity ~=0 do
								_containerFilled:AddItem(PWRAmmoTable2[GunIndex]);
								quantity = quantity-1
							end
						else
							while quantity ~=0 do
								_containerFilled:AddItem(PWRAmmoTable[GunIndex]);
								quantity = quantity-1
							end
						end
						if rnd(10) >= 9 then
							if rnd(10) >= 9 then
								_containerFilled:AddItem(PWRBoxTable2[GunIndex]);
							else
								_containerFilled:AddItem(PWRBoxTable[GunIndex]);
							end
						end
						if diff >= 2 then
							if rnd(10) >= 7 then
								quantity = rnd(2)
								if PWRMagTable[GunIndex] ~= "" then
									while quantity ~=0 do
										local item = PWRMagTable[GunIndex]
										ORGMItemGen:GenerateItem(_containerFilled, item, "Police", "Body")
										quantity = quantity-1
									end
								end
							end
						end
					end
				else
					if rnd (10) < 8 then
						GunIndex = rnd(#MilWepTableCom);
						local item = MilWepTableCom[GunIndex]
						ORGMItemGen:GenerateItem(_containerFilled, item, "Military", "Body")
						quantity = rnd(15)
						if rnd(10) >= 9 then
							while quantity ~=0 do
								_containerFilled:AddItem(MWCAmmoTable2[GunIndex]);
								quantity = quantity-1
							end
						else
							while quantity ~=0 do
								_containerFilled:AddItem(MWCAmmoTable[GunIndex]);
								quantity = quantity-1
							end
						end
						if rnd(10) >= 9 then
							if rnd(10) >= 9 then
								_containerFilled:AddItem(MWCBoxTable2[GunIndex]);
							else
								_containerFilled:AddItem(MWCBoxTable[GunIndex]);
							end
						end
						if diff >= 2 then
							if rnd(10) >= 7 then
								quantity = rnd(2)
								if MWCMagTable[GunIndex] ~= "" then
									while quantity ~=0 do
										local item = MWCMagTable[GunIndex]
										ORGMItemGen:GenerateItem(_containerFilled, item, "Military", "Body")
										quantity = quantity-1
									end
								end
							end
						end
					else
						GunIndex = rnd(#MilWepTableRare);
						local item = MilWepTableRare[GunIndex]
						ORGMItemGen:GenerateItem(_containerFilled, item, "Military", "Body")
						quantity = rnd(15)
						if rnd(10) >= 9 then
							while quantity ~=0 do
								_containerFilled:AddItem(MWRAmmoTable2[GunIndex]);
								quantity = quantity-1
							end
						else
							while quantity ~=0 do
								_containerFilled:AddItem(MWRAmmoTable[GunIndex]);
								quantity = quantity-1
							end
						end
						if rnd(10) >= 9 then
							if rnd(10) >= 9 then
								_containerFilled:AddItem(MWRBoxTable2[GunIndex]);
							else
								_containerFilled:AddItem(MWRBoxTable[GunIndex]);
							end
						end
						if diff >= 2 then
							if rnd(10) >= 7 then
								quantity = rnd(2)
								if MWRMagTable[GunIndex] ~= "" then
									while quantity ~=0 do
										local item = MWRMagTable[GunIndex]
										ORGMItemGen:GenerateItem(_containerFilled, item, "Military", "Body")
										quantity = quantity-1
									end
								end
							end
						end
					end
				end
			end
		end
	elseif _roomName == "all" and _containerType == "inventoryfemale" then
		if rnd(100) >= 98 then
			if rnd(10) < 8 then
				if rnd (10) < 8 then
					GunIndex = rnd(#CivWepTableCom);
					local item = CivWepTableCom[GunIndex]
					ORGMItemGen:GenerateItem(_containerFilled, item, "Civilian", "Body")
					quantity = rnd(15)
					if rnd(10) >= 9 then
						while quantity ~=0 do
							_containerFilled:AddItem(CWCAmmoTable2[GunIndex]);
							quantity = quantity-1
						end
					else
						while quantity ~=0 do
							_containerFilled:AddItem(CWCAmmoTable[GunIndex]);
							quantity = quantity-1
						end
					end
					if rnd(10) >= 9 then
						if rnd(10) >= 9 then
							_containerFilled:AddItem(CWCBoxTable2[GunIndex]);
						else
							_containerFilled:AddItem(CWCBoxTable[GunIndex]);
						end
					end
					if diff >= 2 then
						if rnd(10) >= 7 then
							quantity = rnd(2)
							if CWCMagTable[GunIndex] ~= "" then
								while quantity ~=0 do
									local item = CWCMagTable[GunIndex]
									ORGMItemGen:GenerateItem(_containerFilled, item, "Civilian", "Body")
									quantity = quantity-1
								end
							end
						end
					end
				elseif rnd (10) < 8 then 
					GunIndex = rnd(#CivWepTableRare);
					local item = CivWepTableRare[GunIndex]
					ORGMItemGen:GenerateItem(_containerFilled, item, "Civilian", "Body")
					quantity = rnd(15)
					if rnd(10) >= 9 then
						while quantity ~=0 do
							_containerFilled:AddItem(CWRAmmoTable2[GunIndex]);
							quantity = quantity-1
						end
					else
						while quantity ~=0 do
							_containerFilled:AddItem(CWRAmmoTable[GunIndex]);
							quantity = quantity-1
						end
					end
					if rnd(10) >= 9 then
						if rnd(10) >= 9 then
							_containerFilled:AddItem(CWRBoxTable2[GunIndex]);
						else
							_containerFilled:AddItem(CWRBoxTable[GunIndex]);
						end
					end
					if diff >= 2 then
						if rnd(10) >= 7 then
							quantity = rnd(2)
							if CWRMagTable[GunIndex] ~= "" then
								while quantity ~=0 do
									local item = CWRMagTable[GunIndex]
									ORGMItemGen:GenerateItem(_containerFilled, item, "Civilian", "Body")
									quantity = quantity-1
								end
							end
						end
					end
				else
					GunIndex = rnd(#CivWepTableSuperRare);
					local item = CivWepTableSuperRare[GunIndex]
					ORGMItemGen:GenerateItem(_containerFilled, item, "Civilian", "Body")
					quantity = rnd(15)
					if rnd(10) >= 9 then
						while quantity ~=0 do
							_containerFilled:AddItem(CWSRAmmoTable2[GunIndex]);
							quantity = quantity-1
						end
					else
						while quantity ~=0 do
							_containerFilled:AddItem(CWSRAmmoTable[GunIndex]);
							quantity = quantity-1
						end
					end
					if rnd(10) >= 9 then
						if rnd(10) >= 9 then
							_containerFilled:AddItem(CWSRBoxTable2[GunIndex]);
						else
							_containerFilled:AddItem(CWSRBoxTable[GunIndex]);
						end
					end
					if diff >= 2 then
						if rnd(10) >= 7 then
							quantity = rnd(2)
							if CWSRMagTable[GunIndex] ~= "" then
								while quantity ~=0 do
									local item = CWSRMagTable[GunIndex]
									ORGMItemGen:GenerateItem(_containerFilled, item, "Civilian", "Body")
									quantity = quantity-1
								end
							end
						end
					end		
				end
			else
				if rnd (10) < 7 then
					if rnd (10) < 8 then
						GunIndex = rnd(#PolWepTableCom);
						local item = PolWepTableCom[GunIndex]
						ORGMItemGen:GenerateItem(_containerFilled, item, "Police", "Body")
						quantity = rnd(15)
						if rnd(10) >= 9 then
							while quantity ~=0 do
								_containerFilled:AddItem(PWCAmmoTable2[GunIndex]);
								quantity = quantity-1
							end
						else
							while quantity ~=0 do
								_containerFilled:AddItem(PWCAmmoTable[GunIndex]);
								quantity = quantity-1
							end
						end
						if rnd(10) >= 9 then
							if rnd(10) >= 9 then
								_containerFilled:AddItem(PWCBoxTable2[GunIndex]);
							else
								_containerFilled:AddItem(PWCBoxTable[GunIndex]);
							end
						end
						if diff >= 2 then
							if rnd(10) >= 7 then
								quantity = rnd(2)
								if PWCMagTable[GunIndex] ~= "" then
									while quantity ~=0 do
										local item = PWCMagTable[GunIndex]
										ORGMItemGen:GenerateItem(_containerFilled, item, "Police", "Body")
										quantity = quantity-1
									end
								end
							end
						end
					else
						GunIndex = rnd(#PolWepTableRare);
						local item = PolWepTableRare[GunIndex]
						ORGMItemGen:GenerateItem(_containerFilled, item, "Police", "Body")
						quantity = rnd(15)
						if rnd(10) >= 9 then
							while quantity ~=0 do
								_containerFilled:AddItem(PWRAmmoTable2[GunIndex]);
								quantity = quantity-1
							end
						else
							while quantity ~=0 do
								_containerFilled:AddItem(PWRAmmoTable[GunIndex]);
								quantity = quantity-1
							end
						end
						if rnd(10) >= 9 then
							if rnd(10) >= 9 then
								_containerFilled:AddItem(PWRBoxTable2[GunIndex]);
							else
								_containerFilled:AddItem(PWRBoxTable[GunIndex]);
							end
						end
						if diff >= 2 then
							if rnd(10) >= 7 then
								quantity = rnd(2)
								if PWRMagTable[GunIndex] ~= "" then
									while quantity ~=0 do
										local item = PWRMagTable[GunIndex]
										ORGMItemGen:GenerateItem(_containerFilled, item, "Police", "Body")
										quantity = quantity-1
									end
								end
							end
						end
					end
				else
					if rnd (10) < 8 then
						GunIndex = rnd(#MilWepTableCom);
						local item = MilWepTableCom[GunIndex]
						ORGMItemGen:GenerateItem(_containerFilled, item, "Military", "Body")
						quantity = rnd(15)
						if rnd(10) >= 9 then
							while quantity ~=0 do
								_containerFilled:AddItem(MWCAmmoTable2[GunIndex]);
								quantity = quantity-1
							end
						else
							while quantity ~=0 do
								_containerFilled:AddItem(MWCAmmoTable[GunIndex]);
								quantity = quantity-1
							end
						end
						if rnd(10) >= 9 then
							if rnd(10) >= 9 then
								_containerFilled:AddItem(MWCBoxTable2[GunIndex]);
							else
								_containerFilled:AddItem(MWCBoxTable[GunIndex]);
							end
						end
						if diff >= 2 then
							if rnd(10) >= 7 then
								quantity = rnd(2)
								if MWCMagTable[GunIndex] ~= "" then
									while quantity ~=0 do
										local item = MWCMagTable[GunIndex]
										ORGMItemGen:GenerateItem(_containerFilled, item, "Military", "Body")
										quantity = quantity-1
									end
								end
							end
						end
					else
						GunIndex = rnd(#MilWepTableRare);
						local item = MilWepTableRare[GunIndex]
						ORGMItemGen:GenerateItem(_containerFilled, item, "Military", "Body")
						quantity = rnd(15)
						if rnd(10) >= 9 then
							while quantity ~=0 do
								_containerFilled:AddItem(MWRAmmoTable2[GunIndex]);
								quantity = quantity-1
							end
						else
							while quantity ~=0 do
								_containerFilled:AddItem(MWRAmmoTable[GunIndex]);
								quantity = quantity-1
							end
						end
						if rnd(10) >= 9 then
							if rnd(10) >= 9 then
								_containerFilled:AddItem(MWRBoxTable2[GunIndex]);
							else
								_containerFilled:AddItem(MWRBoxTable[GunIndex]);
							end
						end
						if diff >= 2 then
							if rnd(10) >= 7 then
								quantity = rnd(2)
								if MWRMagTable[GunIndex] ~= "" then
									while quantity ~=0 do
										local item = MWRMagTable[GunIndex]
										ORGMItemGen:GenerateItem(_containerFilled, item, "Military", "Body")
										quantity = quantity-1
									end
								end
							end
						end
					end
				end
			end
		end
	elseif _roomName == "bedroom" and _containerType == "wardrobe" then
		if rnd (100) > 70 then
			if rnd (100) < 80 then
				GunIndex = rnd(#CivWepTableCom);
				if rnd(10) >= 9 then
					local item = CivWepTableCom[GunIndex]
					ORGMItemGen:GenerateItem(_containerFilled, item, "Civilian", "House")
					quantity = rnd(6)
					if rnd(10) >= 8 then
						while quantity ~=0 do
							_containerFilled:AddItem(CWCAmmoTable2[GunIndex]);
							quantity = quantity-1
						end
					else
						while quantity ~=0 do
							_containerFilled:AddItem(CWCAmmoTable[GunIndex]);
							quantity = quantity-1
						end
					end
				end
				if rnd(10) >= 9 then
					quantity = rnd(22)
					if rnd(10) >= 8 then
						while quantity ~=0 do
							_containerFilled:AddItem(CWCAmmoTable2[GunIndex]);
							quantity = quantity-1
						end
					else
						while quantity ~=0 do
							_containerFilled:AddItem(CWCAmmoTable[GunIndex]);
							quantity = quantity-1
						end
					end
				end
				if diff >= 2 then
					if rnd(10) >= 9 then
						if rnd (10) >= 9 then
							quantity = 2
						else
							quantity = 1
						end
						while quantity ~= 0 do
							local item = CWCMagTable[GunIndex]
							ORGMItemGen:GenerateItem(_containerFilled, item, "Civilian", "House")
							quantity = quantity-1
						end
					end
				end
				if rnd(10) >= 9 then
					if rnd (10) >= 9 then
						quantity = 2
					else
						quantity = 1
					end
					if rnd(10) >= 8 then
						while quantity ~=0 do
							_containerFilled:AddItem(CWCBoxTable2[GunIndex]);
							quantity = quantity-1
						end
					else
						while quantity ~=0 do
							_containerFilled:AddItem(CWCBoxTable[GunIndex]);
							quantity = quantity-1
						end
					end
				end
				if rnd(100) >= 95 then
					ModIndex = rnd(#CivModTable);
					_containerFilled:AddItem(CivModTable[ModIndex]);
				end
				if rnd(100) >= 95 then
					RepairIndex = rnd(#RepairTable);
					_containerFilled:AddItem(RepairTable[RepairIndex]);
				end
			elseif rnd (10) >= 8 then
				GunIndex = rnd(#CivWepTableRare);
				if rnd(10) >= 9 then
					local item = CivWepTableRare[GunIndex]
					ORGMItemGen:GenerateItem(_containerFilled, item, "Civilian", "House")
					quantity = rnd(6)
					if rnd(10) >= 8 then
						while quantity ~=0 do
							_containerFilled:AddItem(CWRAmmoTable2[GunIndex]);
							quantity = quantity-1
						end
					else
						while quantity ~=0 do
							_containerFilled:AddItem(CWRAmmoTable[GunIndex]);
							quantity = quantity-1
						end
					end
				end
				if rnd(10) >= 9 then
					quantity = rnd(22)
					if rnd(10) >= 8 then
						while quantity ~=0 do
							_containerFilled:AddItem(CWRAmmoTable2[GunIndex]);
							quantity = quantity-1
						end
					else
						while quantity ~=0 do
							_containerFilled:AddItem(CWRAmmoTable[GunIndex]);
							quantity = quantity-1
						end
					end
				end
				if diff >= 2 then
					if rnd(10) >= 9 then
						if rnd (10) >= 9 then
							quantity = 2
						else
							quantity = 1
						end
						while quantity ~= 0 do
							local item = CWRMagTable[GunIndex]
							ORGMItemGen:GenerateItem(_containerFilled, item, "Civilian", "House")
							quantity = quantity-1
						end
					end
				end
				if rnd(10) >= 9 then
					if rnd (10) >= 9 then
						quantity = 2
					else
						quantity = 1
					end
					if rnd(10) >= 8 then
						while quantity ~=0 do
							_containerFilled:AddItem(CWRBoxTable2[GunIndex]);
							quantity = quantity-1
						end
					else
						while quantity ~=0 do
							_containerFilled:AddItem(CWRBoxTable[GunIndex]);
							quantity = quantity-1
						end
					end
				end
				if rnd(100) >= 95 then
					ModIndex = rnd(#CivModTable);
					_containerFilled:AddItem(CivModTable[ModIndex]);
				end
				if rnd(100) >= 95 then
					RepairIndex = rnd(#RepairTable);
					_containerFilled:AddItem(RepairTable[RepairIndex]);
				end
			else
				GunIndex = rnd(#CivWepTableSuperRare);
				if rnd(10) >= 9 then
					local item = CivWepTableSperRare[GunIndex]
					ORGMItemGen:GenerateItem(_containerFilled, item, "Civilian", "House")
					quantity = rnd(6)
					if rnd(10) >= 8 then
						while quantity ~=0 do
							_containerFilled:AddItem(CWSRAmmoTable2[GunIndex]);
							quantity = quantity-1
						end
					else
						while quantity ~=0 do
							_containerFilled:AddItem(CWSRAmmoTable[GunIndex]);
							quantity = quantity-1
						end
					end
				end
				if rnd(10) >= 9 then
					quantity = rnd(22)
					if rnd(10) >= 8 then
						while quantity ~=0 do
							_containerFilled:AddItem(CWSRAmmoTable2[GunIndex]);
							quantity = quantity-1
						end
					else
						while quantity ~=0 do
							_containerFilled:AddItem(CWSRAmmoTable[GunIndex]);
							quantity = quantity-1
						end
					end
				end
				if diff >= 2 then
					if rnd(10) >= 9 then
						if rnd (10) >= 9 then
							quantity = 2
						else
							quantity = 1
						end
						while quantity ~= 0 do
							local item = CWSRMagTable[GunIndex]
							ORGMItemGen:GenerateItem(_containerFilled, item, "Civilian", "House")
							quantity = quantity-1
						end
					end
				end
				if rnd(10) >= 9 then
					if rnd (10) >= 9 then
						quantity = 2
					else
						quantity = 1
					end
					if rnd(10) >= 8 then
						while quantity ~=0 do
							_containerFilled:AddItem(CWSRBoxTable2[GunIndex]);
							quantity = quantity-1
						end
					else
						while quantity ~=0 do
							_containerFilled:AddItem(CWSRBoxTable[GunIndex]);
							quantity = quantity-1
						end
					end
				end
				if rnd(100) >= 95 then
					ModIndex = rnd(#CivModTable);
					_containerFilled:AddItem(CivModTable[ModIndex]);
				end
				if rnd(100) >= 95 then
					RepairIndex = rnd(#RepairTable);
					_containerFilled:AddItem(RepairTable[RepairIndex]);
				end
			end
		end
	elseif _roomName == "zippeestore" and _containerType == "counter" then
		if rnd(100) >=90 then
			GunIndex = rnd(#CivSGTable);
			if rnd(10) >= 8 then
				local item = CivSGTable[GunIndex]
				ORGMItemGen:GenerateItem(_containerFilled, item, "Civilian", "Gas")
				if rnd (10) >= 6 then
					quantity = rnd (4)
				else
					quantity = 1
				end
				while quantity ~= 0 do
					_containerFilled:AddItem("ORGM.12gRounds");
					quantity = quantity-1
				end
				if rnd(10) >= 8 then
					_containerFilled:AddItem("ORGM.12gBox");
				end
			end
		end
	elseif _roomName == "fossoil" and _containerType == "counter" then
		if rnd(100) >=90 then
			GunIndex = rnd(#CivSGTable);
			if rnd(10) >= 8 then
				local item = CivSGTable[GunIndex]
				ORGMItemGen:GenerateItem(_containerFilled, item, "Civilian", "Gas")
				if rnd (10) >= 6 then
					quantity = rnd (4)
				else
					quantity = 1
				end
				while quantity ~= 0 do
					_containerFilled:AddItem("ORGM.12gRounds");
					quantity = quantity-1
				end
				if rnd(10) >= 8 then
					_containerFilled:AddItem("ORGM.12gBox");
				end
			end
		end
	elseif _roomName == "gasstore" and _containerType == "counter" then
		if rnd(100) >=90 then
			GunIndex = rnd(#CivSGTable);
			if rnd(10) >= 8 then
				local item = CivSGTable[GunIndex]
				ORGMItemGen:GenerateItem(_containerFilled, item, "Civilian", "Gas")
				if rnd (10) >= 6 then
					quantity = rnd (4)
				else
					quantity = 1
				end
				while quantity ~= 0 do
					_containerFilled:AddItem("ORGM.12gRounds");
					quantity = quantity-1
				end
				if rnd(10) >= 8 then
					_containerFilled:AddItem("ORGM.12gBox");
				end
			end
		end
	elseif _roomName == "bar" and _containerType == "counter" then
		if rnd(100) >=85 then
			GunIndex = rnd(#CivSGTable);
			if rnd(10) >= 8 then
				local item = CivSGTable[GunIndex]
				ORGMItemGen:GenerateItem(_containerFilled, item, "Civilian", "Gas")
				if rnd (10) >= 6 then
					quantity = rnd (4)
				else
					quantity = 1
				end
				while quantity ~= 0 do
					_containerFilled:AddItem("ORGM.12gRounds");
					quantity = quantity-1
				end
				if rnd(10) >= 8 then
					_containerFilled:AddItem("ORGM.12gBox");
				end
			end
		end
	elseif _roomName == "policestorage" then
		quantity = rnd(3)
		while quantity ~= 0 do
			if rnd (10) < 7 then
				if rnd (10) < 8 then
					GunIndex = rnd(#PolWepTableCom);
					if rnd(10) >= 4 then
					local item = PolWepTableCom[GunIndex]
					ORGMItemGen:GenerateItem(_containerFilled, item, "Police", "Police")
					end
					if rnd (10) < 8 then
						quantity1 = 1
						if rnd(10) >=4 then
							quantity1 = quantity1 + rnd(2)
						end
						if rnd(10) >=8 then
							quantity1 = quantity1 + rnd(2)
						end
						while quantity1 ~= 0 do
							_containerFilled:AddItem(PWCBoxTable[GunIndex]);
							quantity1 = quantity1 - 1
						end
					else
						_containerFilled:AddItem(PWCCanTable[GunIndex]);					
					end
					if diff >= 2 then
						if rnd(10) >= 4 then
							quantity1 = 1
							if rnd(10) >= 6 then
								quantity1 = quantity1 + rnd(2)
							end
							while quantity1 ~= 0 do
								local item = PWCMagTable[GunIndex]
								ORGMItemGen:GenerateItem(_containerFilled, item, "Police", "Police")
								quantity1 = quantity1 - 1
							end
						end
					end
					if rnd(10) >= 7 then
						ModIndex = rnd(#NonCivModTable);
						_containerFilled:AddItem(NonCivModTable[ModIndex]);
					end
					if rnd(10) >= 6 then
						RepairIndex = rnd(#RepairTable);
						_containerFilled:AddItem(RepairTable[RepairIndex]);
					end
				else
					GunIndex = rnd(#PolWepTableRare);
					if rnd(10) >= 4 then
					local item = PolWepTableRare[GunIndex]
					ORGMItemGen:GenerateItem(_containerFilled, item, "Police", "Police")
					end
					if rnd (10) < 8 then
						quantity1 = 1
						if rnd(10) >=4 then
							quantity1 = quantity1 + rnd(2)
						end
						if rnd(10) >=8 then
							quantity1 = quantity1 + rnd(2)
						end
						while quantity1 ~= 0 do
							_containerFilled:AddItem(PWRBoxTable[GunIndex]);
							quantity1 = quantity1 - 1
						end
					else
						_containerFilled:AddItem(PWRCanTable[GunIndex]);					
					end
					if diff >= 2 then
						if rnd(10) >= 4 then
							quantity1 = 1
							if rnd(10) >= 6 then
								quantity1 = quantity1 + rnd(2)
							end
							while quantity1 ~= 0 do
								local item = PWRMagTable[GunIndex]
								ORGMItemGen:GenerateItem(_containerFilled, item, "Police", "Police")
								quantity1 = quantity1 - 1
							end
						end
					end
					if rnd(10) >= 7 then
						ModIndex = rnd(#NonCivModTable);
						_containerFilled:AddItem(NonCivModTable[ModIndex]);
					end
					if rnd(10) >= 6 then
						RepairIndex = rnd(#RepairTable);
						_containerFilled:AddItem(RepairTable[RepairIndex]);
					end
				end
			else
				if rnd (10) < 8 then
					GunIndex = rnd(#MilWepTableCom);
					if rnd(10) >= 4 then
					local item = MilWepTableCom[GunIndex]
					ORGMItemGen:GenerateItem(_containerFilled, item, "Military", "Police")
					end
					if rnd (10) < 8 then
						quantity1 = 1
						if rnd(10) >=4 then
							quantity1 = quantity1 + rnd(2)
						end
						if rnd(10) >=8 then
							quantity1 = quantity1 + rnd(2)
						end
						while quantity1 ~= 0 do
							_containerFilled:AddItem(MWCBoxTable[GunIndex]);
							quantity1 = quantity1 - 1
						end
					else
						_containerFilled:AddItem(MWCCanTable[GunIndex]);					
					end
					if diff >= 2 then
						if rnd(10) >= 4 then
							quantity1 = 1
							if rnd(10) >= 6 then
								quantity1 = quantity1 + rnd(2)
							end
							while quantity1 ~= 0 do
								local item = MWCMagTable[GunIndex]
								ORGMItemGen:GenerateItem(_containerFilled, item, "Military", "Police")
								quantity1 = quantity1 - 1
							end
						end
					end
					if rnd(10) >= 7 then
						ModIndex = rnd(#NonCivModTable);
						_containerFilled:AddItem(NonCivModTable[ModIndex]);
					end
					if rnd(10) >= 6 then
						RepairIndex = rnd(#RepairTable);
						_containerFilled:AddItem(RepairTable[RepairIndex]);
					end
				else
					GunIndex = rnd(#MilWepTableRare);
					if rnd(10) >= 4 then
					local item = MilWepTableRare[GunIndex]
					ORGMItemGen:GenerateItem(_containerFilled, item, "Military", "Police")
					end
					if rnd (10) < 8 then
						quantity1 = 1
						if rnd(10) >=4 then
							quantity1 = quantity1 + rnd(2)
						end
						if rnd(10) >=8 then
							quantity1 = quantity1 + rnd(2)
						end
						while quantity1 ~= 0 do
							_containerFilled:AddItem(MWRBoxTable[GunIndex]);
							quantity1 = quantity1 - 1
						end
					else
						_containerFilled:AddItem(MWRCanTable[GunIndex]);					
					end
					if diff >= 2 then
						if rnd(10) >= 4 then
							quantity1 = 1
							if rnd(10) >= 6 then
								quantity1 = quantity1 + rnd(2)
							end
							while quantity1 ~= 0 do
								local item = MWRMagTable[GunIndex]
								ORGMItemGen:GenerateItem(_containerFilled, item, "Military", "Police")
								quantity1 = quantity1 - 1
							end
						end
					end
					if rnd(10) >= 7 then
						ModIndex = rnd(#NonCivModTable);
						_containerFilled:AddItem(NonCivModTable[ModIndex]);
					end
					if rnd(10) >= 6 then
						RepairIndex = rnd(#RepairTable);
						_containerFilled:AddItem(RepairTable[RepairIndex]);
					end
				end
				quantity = quantity -1
			end
		end
	elseif _roomName == "gunstore" and _containerType == "locker" then
		if rnd(20) >= 1 then
			ammoindex = rnd(#AllBoxTable);
			_containerFilled:AddItem(AllBoxTable[ammoindex]);
		end
		if rnd(20) >= 2 then
			ammoindex = rnd(#AllBoxTable);
			_containerFilled:AddItem(AllBoxTable[ammoindex]);
		end
		if rnd(20) >= 3 then
			ammoindex = rnd(#AllBoxTable);
			_containerFilled:AddItem(AllBoxTable[ammoindex]);
		end
		if rnd(20) >= 4 then
			ammoindex = rnd(#AllBoxTable);
			_containerFilled:AddItem(AllBoxTable[ammoindex]);
		end
		if rnd(20) >= 5 then
			ammoindex = rnd(#AllBoxTable);
			_containerFilled:AddItem(AllBoxTable[ammoindex]);
		end
		if rnd(20) >= 6 then
			ammoindex = rnd(#AllBoxTable);
			_containerFilled:AddItem(AllBoxTable[ammoindex]);
		end
		if rnd(20) >= 7 then
			ammoindex = rnd(#AllBoxTable);
			_containerFilled:AddItem(AllBoxTable[ammoindex]);
		end
		if rnd(20) >= 9 then
			ammoindex = rnd(#AllBoxTable);
			_containerFilled:AddItem(AllBoxTable[ammoindex]);
		end
		if rnd(20) >= 11 then
			ammoindex = rnd(#AllBoxTable);
			_containerFilled:AddItem(AllBoxTable[ammoindex]);
		end
		if rnd(20) >= 13 then
			ammoindex = rnd(#AllBoxTable);
			_containerFilled:AddItem(AllBoxTable[ammoindex]);
		end
		if rnd(20) >= 15 then
			ammoindex = rnd(#AllBoxTable);
			_containerFilled:AddItem(AllBoxTable[ammoindex]);
		end
		if rnd(20) >= 17 then
			ammoindex = rnd(#AllCanTable);
			_containerFilled:AddItem(AllCanTable[ammoindex]);
		end
		if rnd(20) >= 19 then
			ammoindex = rnd(#AllCanTable);
			_containerFilled:AddItem(AllCanTable[ammoindex]);
		end
		if rnd(4) >= 1 then
			RepairIndex = rnd(#RepairTable);
			local item = _containerFilled:AddItem(RepairTable[RepairIndex]);
		end
	elseif _roomName == "gunstore" and _containerType == "counter" then
		if rnd(20) >= 2 then
			ammoindex = rnd(#AllBoxTable);
			_containerFilled:AddItem(AllBoxTable[ammoindex]);
		end
		if rnd(20) >= 4 then
			ammoindex = rnd(#AllBoxTable);
			_containerFilled:AddItem(AllBoxTable[ammoindex]);
		end
		if rnd(20) >= 6 then
			ammoindex = rnd(#AllBoxTable);
			_containerFilled:AddItem(AllBoxTable[ammoindex]);
		end
		if rnd(20) >= 8 then
			ammoindex = rnd(#AllBoxTable);
			_containerFilled:AddItem(AllBoxTable[ammoindex]);
		end
		if rnd(20) >= 10 then
			ammoindex = rnd(#AllBoxTable);
			_containerFilled:AddItem(AllBoxTable[ammoindex]);
		end
		if rnd(20) >= 12 then
			ammoindex = rnd(#AllBoxTable);
			_containerFilled:AddItem(AllBoxTable[ammoindex]);
		end
		if rnd(20) >= 14 then
			ammoindex = rnd(#AllBoxTable);
			_containerFilled:AddItem(AllBoxTable[ammoindex]);
		end
		if rnd(20) >= 16 then
			ammoindex = rnd(#AllBoxTable);
			_containerFilled:AddItem(AllBoxTable[ammoindex]);
		end
		if rnd(20) >= 18 then
			ammoindex = rnd(#AllCanTable);
			_containerFilled:AddItem(AllCanTable[ammoindex]);
		end
		if rnd(20) >= 20 then
			ammoindex = rnd(#AllCanTable);
			_containerFilled:AddItem(AllCanTable[ammoindex]);
		end
		if rnd(5) >= 2 then
			RepairIndex = rnd(#RepairTable);
			_containerFilled:AddItem(RepairTable[RepairIndex]);
		end
	elseif _roomName == "gunstore" and _containerType == "displaycase" then
		if rnd(100) >= 5 then
			if rnd(100) < 85 then
				if rnd (10) < 8 then
					GunIndex = rnd(#CivWepTableCom);
					local item = CivWepTableCom[GunIndex]
					ORGMItemGen:GenerateItem(_containerFilled, item, "Civilian", "Store")
						if diff >= 2 then
							if rnd(10) >= 3 then
								local item = CWCMagTable[GunIndex]
								ORGMItemGen:GenerateItem(_containerFilled, item, "Civilian", "Store")
							end
							if rnd(10) >= 7 then
								local item = CWCMagTable[GunIndex]
								ORGMItemGen:GenerateItem(_containerFilled, item, "Civilian", "Store")
							end
						end
				elseif rnd (10) < 8 then
					GunIndex = rnd(#CivWepTableRare);
					local item = CivWepTableRare[GunIndex]
					ORGMItemGen:GenerateItem(_containerFilled, item, "Civilian", "Store")
						if diff >= 2 then
							if rnd(10) >= 3 then
								local item = CWRMagTable[GunIndex]
								ORGMItemGen:GenerateItem(_containerFilled, item, "Civilian", "Store")
							end
							if rnd(10) >= 7 then
								local item = CWRMagTable[GunIndex]
								ORGMItemGen:GenerateItem(_containerFilled, item, "Civilian", "Store")
							end
						end
				else
					GunIndex = rnd(#CivWepTableSuperRare);
					local item = CivWepTableSuperRare[GunIndex]
					ORGMItemGen:GenerateItem(_containerFilled, item, "Civilian", "Store")
						if diff >= 2 then
							if rnd(10) >= 3 then
								local item = CWSRMagTable[GunIndex]
								ORGMItemGen:GenerateItem(_containerFilled, item, "Civilian", "Store")
							end
							if rnd(10) >= 7 then
								local item = CWSRMagTable[GunIndex]
								ORGMItemGen:GenerateItem(_containerFilled, item, "Civilian", "Store")
							end
						end	
				end
			else		
				if rnd (10) < 7 then
					if rnd (10) < 8 then
						GunIndex = rnd(#PolWepTableCom);
						local item = PolWepTableCom[GunIndex]
						ORGMItemGen:GenerateItem(_containerFilled, item, "Police", "Store")
							if diff >= 2 then
								if rnd(10) >= 3 then
									local item = PWCMagTable[GunIndex]
									ORGMItemGen:GenerateItem(_containerFilled, item, "Police", "Store")
								end
								if rnd(10) >= 7 then
									local item = PWCMagTable[GunIndex]
									ORGMItemGen:GenerateItem(_containerFilled, item, "Police", "Store")
								end
							end
					else
						GunIndex = rnd(#PolWepTableRare);
						local item = PolWepTableRare[GunIndex]
						ORGMItemGen:GenerateItem(_containerFilled, item, "Police", "Store")
							if diff >= 2 then
								if rnd(10) >= 3 then
									local item = PWRMagTable[GunIndex]
									ORGMItemGen:GenerateItem(_containerFilled, item, "Police", "Store")
								end
								if rnd(10) >= 7 then
									local item = PWRMagTable[GunIndex]
									ORGMItemGen:GenerateItem(_containerFilled, item, "Police", "Store")
								end
							end
					end
				else
					if rnd (10) < 8 then
						GunIndex = rnd(#MilWepTableCom);
						local item = MilWepTableCom[GunIndex]
						ORGMItemGen:GenerateItem(_containerFilled, item, "Military", "Store")
							if diff >= 2 then
								if rnd(10) >= 3 then
									local item = MWCMagTable[GunIndex]
									ORGMItemGen:GenerateItem(_containerFilled, item, "Police", "Store")
								end
								if rnd(10) >= 7 then
									local item = MWCMagTable[GunIndex]
									ORGMItemGen:GenerateItem(_containerFilled, item, "Police", "Store")
								end
							end
					else
						GunIndex = rnd(#MilWepTableRare);
						local item = MilWepTableRare[GunIndex]
						ORGMItemGen:GenerateItem(_containerFilled, item, "Military", "Store")
							if diff >= 2 then
								if rnd(10) >= 3 then
									local item = MWRMagTable[GunIndex]
									ORGMItemGen:GenerateItem(_containerFilled, item, "Police", "Store")
								end
								if rnd(10) >= 7 then
									local item = MWRMagTable[GunIndex]
									ORGMItemGen:GenerateItem(_containerFilled, item, "Police", "Store")
								end
							end
					end
				end
			end
		end
		if rnd(100) >= 25 then
			if rnd(100) < 85 then
				if rnd (10) < 8 then
					GunIndex = rnd(#CivWepTableCom);
					local item = CivWepTableCom[GunIndex]
					ORGMItemGen:GenerateItem(_containerFilled, item, "Civilian", "Store")
						if diff >= 2 then
							if rnd(10) >= 3 then
								local item = CWCMagTable[GunIndex]
								ORGMItemGen:GenerateItem(_containerFilled, item, "Civilian", "Store")
							end
							if rnd(10) >= 7 then
								local item = CWCMagTable[GunIndex]
								ORGMItemGen:GenerateItem(_containerFilled, item, "Civilian", "Store")
							end
						end
				elseif rnd (10) < 8 then
					GunIndex = rnd(#CivWepTableRare);
					local item = CivWepTableRare[GunIndex]
					ORGMItemGen:GenerateItem(_containerFilled, item, "Civilian", "Store")
						if diff >= 2 then
							if rnd(10) >= 3 then
								local item = CWRMagTable[GunIndex]
								ORGMItemGen:GenerateItem(_containerFilled, item, "Civilian", "Store")
							end
							if rnd(10) >= 7 then
								local item = CWRMagTable[GunIndex]
								ORGMItemGen:GenerateItem(_containerFilled, item, "Civilian", "Store")
							end
						end
				else
					GunIndex = rnd(#CivWepTableSuperRare);
					local item = CivWepTableSuperRare[GunIndex]
					ORGMItemGen:GenerateItem(_containerFilled, item, "Civilian", "Store")
						if diff >= 2 then
							if rnd(10) >= 3 then
								local item = CWSRMagTable[GunIndex]
								ORGMItemGen:GenerateItem(_containerFilled, item, "Civilian", "Store")
							end
							if rnd(10) >= 7 then
								local item = CWSRMagTable[GunIndex]
								ORGMItemGen:GenerateItem(_containerFilled, item, "Civilian", "Store")
							end
						end	
				end
			else		
				if rnd (10) < 7 then
					if rnd (10) < 8 then
						GunIndex = rnd(#PolWepTableCom);
						local item = PolWepTableCom[GunIndex]
						ORGMItemGen:GenerateItem(_containerFilled, item, "Police", "Store")
							if diff >= 2 then
								if rnd(10) >= 3 then
									local item = PWCMagTable[GunIndex]
									ORGMItemGen:GenerateItem(_containerFilled, item, "Police", "Store")
								end
								if rnd(10) >= 7 then
									local item = PWCMagTable[GunIndex]
									ORGMItemGen:GenerateItem(_containerFilled, item, "Police", "Store")
								end
							end
					else
						GunIndex = rnd(#PolWepTableRare);
						local item = PolWepTableRare[GunIndex]
						ORGMItemGen:GenerateItem(_containerFilled, item, "Police", "Store")
							if diff >= 2 then
								if rnd(10) >= 3 then
									local item = PWRMagTable[GunIndex]
									ORGMItemGen:GenerateItem(_containerFilled, item, "Police", "Store")
								end
								if rnd(10) >= 7 then
									local item = PWRMagTable[GunIndex]
									ORGMItemGen:GenerateItem(_containerFilled, item, "Police", "Store")
								end
							end
					end
				else
					if rnd (10) < 8 then
						GunIndex = rnd(#MilWepTableCom);
						local item = MilWepTableCom[GunIndex]
						ORGMItemGen:GenerateItem(_containerFilled, item, "Military", "Store")
							if diff >= 2 then
								if rnd(10) >= 3 then
									local item = MWCMagTable[GunIndex]
									ORGMItemGen:GenerateItem(_containerFilled, item, "Police", "Store")
								end
								if rnd(10) >= 7 then
									local item = MWCMagTable[GunIndex]
									ORGMItemGen:GenerateItem(_containerFilled, item, "Police", "Store")
								end
							end
					else
						GunIndex = rnd(#MilWepTableRare);
						local item = MilWepTableRare[GunIndex]
						ORGMItemGen:GenerateItem(_containerFilled, item, "Military", "Store")
							if diff >= 2 then
								if rnd(10) >= 3 then
									local item = MWRMagTable[GunIndex]
									ORGMItemGen:GenerateItem(_containerFilled, item, "Police", "Store")
								end
								if rnd(10) >= 7 then
									local item = MWRMagTable[GunIndex]
									ORGMItemGen:GenerateItem(_containerFilled, item, "Police", "Store")
								end
							end
					end
				end
			end
		end
		if rnd(5) >= 2 then
			if rnd(10) < 9 then
				ModIndex = rnd(#CivModTable);
				_containerFilled:AddItem(CivModTable[ModIndex]);
			else
				ModIndex = rnd(#NonCivModTable);
				_containerFilled:AddItem(NonCivModTable[ModIndex]);
			end
		end
	elseif _roomName == "gunstorestorage" and _containerType == "metal_shelves" then
		if rnd(100) >= 5 then
			if rnd(100) < 85 then
				if rnd (10) < 8 then
					GunIndex = rnd(#CivWepTableCom);
					local item = CivWepTableCom[GunIndex]
					ORGMItemGen:GenerateItem(_containerFilled, item, "Civilian", "Store")
						if diff >= 2 then
							if rnd(10) >= 3 then
								local item = CWCMagTable[GunIndex]
								ORGMItemGen:GenerateItem(_containerFilled, item, "Civilian", "Store")
							end
							if rnd(10) >= 7 then
								local item = CWCMagTable[GunIndex]
								ORGMItemGen:GenerateItem(_containerFilled, item, "Civilian", "Store")
							end
						end
				elseif rnd (10) < 8 then
					GunIndex = rnd(#CivWepTableRare);
					local item = CivWepTableRare[GunIndex]
					ORGMItemGen:GenerateItem(_containerFilled, item, "Civilian", "Store")
						if diff >= 2 then
							if rnd(10) >= 3 then
								local item = CWRMagTable[GunIndex]
								ORGMItemGen:GenerateItem(_containerFilled, item, "Civilian", "Store")
							end
							if rnd(10) >= 7 then
								local item = CWRMagTable[GunIndex]
								ORGMItemGen:GenerateItem(_containerFilled, item, "Civilian", "Store")
							end
						end
				else
					GunIndex = rnd(#CivWepTableSuperRare);
					local item = CivWepTableSuperRare[GunIndex]
					ORGMItemGen:GenerateItem(_containerFilled, item, "Civilian", "Store")
						if diff >= 2 then
							if rnd(10) >= 3 then
								local item = CWSRMagTable[GunIndex]
								ORGMItemGen:GenerateItem(_containerFilled, item, "Civilian", "Store")
							end
							if rnd(10) >= 7 then
								local item = CWSRMagTable[GunIndex]
								ORGMItemGen:GenerateItem(_containerFilled, item, "Civilian", "Store")
							end
						end	
				end
			else		
				if rnd (10) < 7 then
					if rnd (10) < 8 then
						GunIndex = rnd(#PolWepTableCom);
						local item = PolWepTableCom[GunIndex]
						ORGMItemGen:GenerateItem(_containerFilled, item, "Police", "Store")
							if diff >= 2 then
								if rnd(10) >= 3 then
									local item = PWCMagTable[GunIndex]
									ORGMItemGen:GenerateItem(_containerFilled, item, "Police", "Store")
								end
								if rnd(10) >= 7 then
									local item = PWCMagTable[GunIndex]
									ORGMItemGen:GenerateItem(_containerFilled, item, "Police", "Store")
								end
							end
					else
						GunIndex = rnd(#PolWepTableRare);
						local item = PolWepTableRare[GunIndex]
						ORGMItemGen:GenerateItem(_containerFilled, item, "Police", "Store")
							if diff >= 2 then
								if rnd(10) >= 3 then
									local item = PWRMagTable[GunIndex]
									ORGMItemGen:GenerateItem(_containerFilled, item, "Police", "Store")
								end
								if rnd(10) >= 7 then
									local item = PWRMagTable[GunIndex]
									ORGMItemGen:GenerateItem(_containerFilled, item, "Police", "Store")
								end
							end
					end
				else
					if rnd (10) < 8 then
						GunIndex = rnd(#MilWepTableCom);
						local item = MilWepTableCom[GunIndex]
						ORGMItemGen:GenerateItem(_containerFilled, item, "Military", "Store")
							if diff >= 2 then
								if rnd(10) >= 3 then
									local item = MWCMagTable[GunIndex]
									ORGMItemGen:GenerateItem(_containerFilled, item, "Police", "Store")
								end
								if rnd(10) >= 7 then
									local item = MWCMagTable[GunIndex]
									ORGMItemGen:GenerateItem(_containerFilled, item, "Police", "Store")
								end
							end
					else
						GunIndex = rnd(#MilWepTableRare);
						local item = MilWepTableRare[GunIndex]
						ORGMItemGen:GenerateItem(_containerFilled, item, "Military", "Store")
							if diff >= 2 then
								if rnd(10) >= 3 then
									local item = MWRMagTable[GunIndex]
									ORGMItemGen:GenerateItem(_containerFilled, item, "Police", "Store")
								end
								if rnd(10) >= 7 then
									local item = MWRMagTable[GunIndex]
									ORGMItemGen:GenerateItem(_containerFilled, item, "Police", "Store")
								end
							end
					end
				end
			end
		end
		if rnd(100) >= 25 then
			if rnd(100) < 85 then
				if rnd (10) < 8 then
					GunIndex = rnd(#CivWepTableCom);
					local item = CivWepTableCom[GunIndex]
					ORGMItemGen:GenerateItem(_containerFilled, item, "Civilian", "Store")
						if diff >= 2 then
							if rnd(10) >= 3 then
								local item = CWCMagTable[GunIndex]
								ORGMItemGen:GenerateItem(_containerFilled, item, "Civilian", "Store")
							end
							if rnd(10) >= 7 then
								local item = CWCMagTable[GunIndex]
								ORGMItemGen:GenerateItem(_containerFilled, item, "Civilian", "Store")
							end
						end
				elseif rnd (10) < 8 then
					GunIndex = rnd(#CivWepTableRare);
					local item = CivWepTableRare[GunIndex]
					ORGMItemGen:GenerateItem(_containerFilled, item, "Civilian", "Store")
						if diff >= 2 then
							if rnd(10) >= 3 then
								local item = CWRMagTable[GunIndex]
								ORGMItemGen:GenerateItem(_containerFilled, item, "Civilian", "Store")
							end
							if rnd(10) >= 7 then
								local item = CWRMagTable[GunIndex]
								ORGMItemGen:GenerateItem(_containerFilled, item, "Civilian", "Store")
							end
						end
				else
					GunIndex = rnd(#CivWepTableSuperRare);
					local item = CivWepTableSuperRare[GunIndex]
					ORGMItemGen:GenerateItem(_containerFilled, item, "Civilian", "Store")
						if diff >= 2 then
							if rnd(10) >= 3 then
								local item = CWSRMagTable[GunIndex]
								ORGMItemGen:GenerateItem(_containerFilled, item, "Civilian", "Store")
							end
							if rnd(10) >= 7 then
								local item = CWSRMagTable[GunIndex]
								ORGMItemGen:GenerateItem(_containerFilled, item, "Civilian", "Store")
							end
						end	
				end
			else		
				if rnd (10) < 7 then
					if rnd (10) < 8 then
						GunIndex = rnd(#PolWepTableCom);
						local item = PolWepTableCom[GunIndex]
						ORGMItemGen:GenerateItem(_containerFilled, item, "Police", "Store")
							if diff >= 2 then
								if rnd(10) >= 3 then
									local item = PWCMagTable[GunIndex]
									ORGMItemGen:GenerateItem(_containerFilled, item, "Police", "Store")
								end
								if rnd(10) >= 7 then
									local item = PWCMagTable[GunIndex]
									ORGMItemGen:GenerateItem(_containerFilled, item, "Police", "Store")
								end
							end
					else
						GunIndex = rnd(#PolWepTableRare);
						local item = PolWepTableRare[GunIndex]
						ORGMItemGen:GenerateItem(_containerFilled, item, "Police", "Store")
							if diff >= 2 then
								if rnd(10) >= 3 then
									local item = PWRMagTable[GunIndex]
									ORGMItemGen:GenerateItem(_containerFilled, item, "Police", "Store")
								end
								if rnd(10) >= 7 then
									local item = PWRMagTable[GunIndex]
									ORGMItemGen:GenerateItem(_containerFilled, item, "Police", "Store")
								end
							end
					end
				else
					if rnd (10) < 8 then
						GunIndex = rnd(#MilWepTableCom);
						local item = MilWepTableCom[GunIndex]
						ORGMItemGen:GenerateItem(_containerFilled, item, "Military", "Store")
							if diff >= 2 then
								if rnd(10) >= 3 then
									local item = MWCMagTable[GunIndex]
									ORGMItemGen:GenerateItem(_containerFilled, item, "Police", "Store")
								end
								if rnd(10) >= 7 then
									local item = MWCMagTable[GunIndex]
									ORGMItemGen:GenerateItem(_containerFilled, item, "Police", "Store")
								end
							end
					else
						GunIndex = rnd(#MilWepTableRare);
						local item = MilWepTableRare[GunIndex]
						ORGMItemGen:GenerateItem(_containerFilled, item, "Military", "Store")
							if diff >= 2 then
								if rnd(10) >= 3 then
									local item = MWRMagTable[GunIndex]
									ORGMItemGen:GenerateItem(_containerFilled, item, "Police", "Store")
								end
								if rnd(10) >= 7 then
									local item = MWRMagTable[GunIndex]
									ORGMItemGen:GenerateItem(_containerFilled, item, "Police", "Store")
								end
							end
					end
				end
			end
		end
		if rnd(5) >= 2 then
			if rnd(10) < 9 then
				ModIndex = rnd(#CivModTable);
				_containerFilled:AddItem(CivModTable[ModIndex]);
			else
				ModIndex = rnd(#NonCivModTable);
				_containerFilled:AddItem(NonCivModTable[ModIndex]);
			end
		end
		if rnd(5) >= 42 then
			if rnd(10) < 9 then
				ModIndex = rnd(#CivModTable);
				_containerFilled:AddItem(CivModTable[ModIndex]);
			else
				ModIndex = rnd(#NonCivModTable);
				_containerFilled:AddItem(NonCivModTable[ModIndex]);
			end
		end
		if rnd(20) >= 2 then
			ammoindex = rnd(#AllBoxTable);
			_containerFilled:AddItem(AllBoxTable[ammoindex]);
		end
		if rnd(20) >= 4 then
			ammoindex = rnd(#AllBoxTable);
			_containerFilled:AddItem(AllBoxTable[ammoindex]);
		end
		if rnd(20) >= 6 then
			ammoindex = rnd(#AllBoxTable);
			_containerFilled:AddItem(AllBoxTable[ammoindex]);
		end
		if rnd(20) >= 8 then
			ammoindex = rnd(#AllBoxTable);
			_containerFilled:AddItem(AllBoxTable[ammoindex]);
		end
		if rnd(20) >= 10 then
			ammoindex = rnd(#AllBoxTable);
			_containerFilled:AddItem(AllBoxTable[ammoindex]);
		end
		if rnd(20) >= 12 then
			ammoindex = rnd(#AllBoxTable);
			_containerFilled:AddItem(AllBoxTable[ammoindex]);
		end
		if rnd(20) >= 14 then
			ammoindex = rnd(#AllBoxTable);
			_containerFilled:AddItem(AllBoxTable[ammoindex]);
		end
		if rnd(20) >= 16 then
			ammoindex = rnd(#AllBoxTable);
			_containerFilled:AddItem(AllBoxTable[ammoindex]);
		end
		if rnd(20) >= 18 then
			ammoindex = rnd(#AllCanTable);
			_containerFilled:AddItem(AllCanTable[ammoindex]);
		end
		if rnd(20) >= 20 then
			ammoindex = rnd(#AllCanTable);
			_containerFilled:AddItem(AllCanTable[ammoindex]);
		end
		if rnd(5) >= 2 then
			RepairIndex = rnd(#RepairTable);
			local item = _containerFilled:AddItem(RepairTable[RepairIndex]);
		end
	elseif _roomName == "gunstorestorage" and _containerType == "crate" then
		if rnd(100) >= 1 then
			if rnd(100) < 85 then
				if rnd (10) < 8 then
					GunIndex = rnd(#CivWepTableCom);
					local item = CivWepTableCom[GunIndex]
					ORGMItemGen:GenerateItem(_containerFilled, item, "Civilian", "Store")
						if diff >= 2 then
							if rnd(10) >= 3 then
								local item = CWCMagTable[GunIndex]
								ORGMItemGen:GenerateItem(_containerFilled, item, "Civilian", "Store")
							end
							if rnd(10) >= 7 then
								local item = CWCMagTable[GunIndex]
								ORGMItemGen:GenerateItem(_containerFilled, item, "Civilian", "Store")
							end
						end
				elseif rnd (10) < 8 then
					GunIndex = rnd(#CivWepTableRare);
					local item = CivWepTableRare[GunIndex]
					ORGMItemGen:GenerateItem(_containerFilled, item, "Civilian", "Store")
						if diff >= 2 then
							if rnd(10) >= 3 then
								local item = CWRMagTable[GunIndex]
								ORGMItemGen:GenerateItem(_containerFilled, item, "Civilian", "Store")
							end
							if rnd(10) >= 7 then
								local item = CWRMagTable[GunIndex]
								ORGMItemGen:GenerateItem(_containerFilled, item, "Civilian", "Store")
							end
						end
				else
					GunIndex = rnd(#CivWepTableSuperRare);
					local item = CivWepTableSuperRare[GunIndex]
					ORGMItemGen:GenerateItem(_containerFilled, item, "Civilian", "Store")
						if diff >= 2 then
							if rnd(10) >= 3 then
								local item = CWSRMagTable[GunIndex]
								ORGMItemGen:GenerateItem(_containerFilled, item, "Civilian", "Store")
							end
							if rnd(10) >= 7 then
								local item = CWSRMagTable[GunIndex]
								ORGMItemGen:GenerateItem(_containerFilled, item, "Civilian", "Store")
							end
						end	
				end
			else		
				if rnd (10) < 7 then
					if rnd (10) < 8 then
						GunIndex = rnd(#PolWepTableCom);
						local item = PolWepTableCom[GunIndex]
						ORGMItemGen:GenerateItem(_containerFilled, item, "Police", "Store")
							if diff >= 2 then
								if rnd(10) >= 3 then
									local item = PWCMagTable[GunIndex]
									ORGMItemGen:GenerateItem(_containerFilled, item, "Police", "Store")
								end
								if rnd(10) >= 7 then
									local item = PWCMagTable[GunIndex]
									ORGMItemGen:GenerateItem(_containerFilled, item, "Police", "Store")
								end
							end
					else
						GunIndex = rnd(#PolWepTableRare);
						local item = PolWepTableRare[GunIndex]
						ORGMItemGen:GenerateItem(_containerFilled, item, "Police", "Store")
							if diff >= 2 then
								if rnd(10) >= 3 then
									local item = PWRMagTable[GunIndex]
									ORGMItemGen:GenerateItem(_containerFilled, item, "Police", "Store")
								end
								if rnd(10) >= 7 then
									local item = PWRMagTable[GunIndex]
									ORGMItemGen:GenerateItem(_containerFilled, item, "Police", "Store")
								end
							end
					end
				else
					if rnd (10) < 8 then
						GunIndex = rnd(#MilWepTableCom);
						local item = MilWepTableCom[GunIndex]
						ORGMItemGen:GenerateItem(_containerFilled, item, "Military", "Store")
							if diff >= 2 then
								if rnd(10) >= 3 then
									local item = MWCMagTable[GunIndex]
									ORGMItemGen:GenerateItem(_containerFilled, item, "Police", "Store")
								end
								if rnd(10) >= 7 then
									local item = MWCMagTable[GunIndex]
									ORGMItemGen:GenerateItem(_containerFilled, item, "Police", "Store")
								end
							end
					else
						GunIndex = rnd(#MilWepTableRare);
						local item = MilWepTableRare[GunIndex]
						ORGMItemGen:GenerateItem(_containerFilled, item, "Military", "Store")
							if diff >= 2 then
								if rnd(10) >= 3 then
									local item = MWRMagTable[GunIndex]
									ORGMItemGen:GenerateItem(_containerFilled, item, "Police", "Store")
								end
								if rnd(10) >= 7 then
									local item = MWRMagTable[GunIndex]
									ORGMItemGen:GenerateItem(_containerFilled, item, "Police", "Store")
								end
							end
					end
				end
			end
		end
		if rnd(100) >= 20 then
			if rnd(100) < 85 then
				if rnd (10) < 8 then
					GunIndex = rnd(#CivWepTableCom);
					local item = CivWepTableCom[GunIndex]
					ORGMItemGen:GenerateItem(_containerFilled, item, "Civilian", "Store")
						if diff >= 2 then
							if rnd(10) >= 3 then
								local item = CWCMagTable[GunIndex]
								ORGMItemGen:GenerateItem(_containerFilled, item, "Civilian", "Store")
							end
							if rnd(10) >= 7 then
								local item = CWCMagTable[GunIndex]
								ORGMItemGen:GenerateItem(_containerFilled, item, "Civilian", "Store")
							end
						end
				elseif rnd (10) < 8 then
					GunIndex = rnd(#CivWepTableRare);
					local item = CivWepTableRare[GunIndex]
					ORGMItemGen:GenerateItem(_containerFilled, item, "Civilian", "Store")
						if diff >= 2 then
							if rnd(10) >= 3 then
								local item = CWRMagTable[GunIndex]
								ORGMItemGen:GenerateItem(_containerFilled, item, "Civilian", "Store")
							end
							if rnd(10) >= 7 then
								local item = CWRMagTable[GunIndex]
								ORGMItemGen:GenerateItem(_containerFilled, item, "Civilian", "Store")
							end
						end
				else
					GunIndex = rnd(#CivWepTableSuperRare);
					local item = CivWepTableSuperRare[GunIndex]
					ORGMItemGen:GenerateItem(_containerFilled, item, "Civilian", "Store")
						if diff >= 2 then
							if rnd(10) >= 3 then
								local item = CWSRMagTable[GunIndex]
								ORGMItemGen:GenerateItem(_containerFilled, item, "Civilian", "Store")
							end
							if rnd(10) >= 7 then
								local item = CWSRMagTable[GunIndex]
								ORGMItemGen:GenerateItem(_containerFilled, item, "Civilian", "Store")
							end
						end	
				end
			else		
				if rnd (10) < 7 then
					if rnd (10) < 8 then
						GunIndex = rnd(#PolWepTableCom);
						local item = PolWepTableCom[GunIndex]
						ORGMItemGen:GenerateItem(_containerFilled, item, "Police", "Store")
							if diff >= 2 then
								if rnd(10) >= 3 then
									local item = PWCMagTable[GunIndex]
									ORGMItemGen:GenerateItem(_containerFilled, item, "Police", "Store")
								end
								if rnd(10) >= 7 then
									local item = PWCMagTable[GunIndex]
									ORGMItemGen:GenerateItem(_containerFilled, item, "Police", "Store")
								end
							end
					else
						GunIndex = rnd(#PolWepTableRare);
						local item = PolWepTableRare[GunIndex]
						ORGMItemGen:GenerateItem(_containerFilled, item, "Police", "Store")
							if diff >= 2 then
								if rnd(10) >= 3 then
									local item = PWRMagTable[GunIndex]
									ORGMItemGen:GenerateItem(_containerFilled, item, "Police", "Store")
								end
								if rnd(10) >= 7 then
									local item = PWRMagTable[GunIndex]
									ORGMItemGen:GenerateItem(_containerFilled, item, "Police", "Store")
								end
							end
					end
				else
					if rnd (10) < 8 then
						GunIndex = rnd(#MilWepTableCom);
						local item = MilWepTableCom[GunIndex]
						ORGMItemGen:GenerateItem(_containerFilled, item, "Military", "Store")
							if diff >= 2 then
								if rnd(10) >= 3 then
									local item = MWCMagTable[GunIndex]
									ORGMItemGen:GenerateItem(_containerFilled, item, "Police", "Store")
								end
								if rnd(10) >= 7 then
									local item = MWCMagTable[GunIndex]
									ORGMItemGen:GenerateItem(_containerFilled, item, "Police", "Store")
								end
							end
					else
						GunIndex = rnd(#MilWepTableRare);
						local item = MilWepTableRare[GunIndex]
						ORGMItemGen:GenerateItem(_containerFilled, item, "Military", "Store")
							if diff >= 2 then
								if rnd(10) >= 3 then
									local item = MWRMagTable[GunIndex]
									ORGMItemGen:GenerateItem(_containerFilled, item, "Police", "Store")
								end
								if rnd(10) >= 7 then
									local item = MWRMagTable[GunIndex]
									ORGMItemGen:GenerateItem(_containerFilled, item, "Police", "Store")
								end
							end
					end
				end
			end
		end
		if rnd(100) >= 60 then
			if rnd(100) < 85 then
				if rnd (10) < 8 then
					GunIndex = rnd(#CivWepTableCom);
					local item = CivWepTableCom[GunIndex]
					ORGMItemGen:GenerateItem(_containerFilled, item, "Civilian", "Store")
						if diff >= 2 then
							if rnd(10) >= 3 then
								local item = CWCMagTable[GunIndex]
								ORGMItemGen:GenerateItem(_containerFilled, item, "Civilian", "Store")
							end
							if rnd(10) >= 7 then
								local item = CWCMagTable[GunIndex]
								ORGMItemGen:GenerateItem(_containerFilled, item, "Civilian", "Store")
							end
						end
				elseif rnd (10) < 8 then
					GunIndex = rnd(#CivWepTableRare);
					local item = CivWepTableRare[GunIndex]
					ORGMItemGen:GenerateItem(_containerFilled, item, "Civilian", "Store")
						if diff >= 2 then
							if rnd(10) >= 3 then
								local item = CWRMagTable[GunIndex]
								ORGMItemGen:GenerateItem(_containerFilled, item, "Civilian", "Store")
							end
							if rnd(10) >= 7 then
								local item = CWRMagTable[GunIndex]
								ORGMItemGen:GenerateItem(_containerFilled, item, "Civilian", "Store")
							end
						end
				else
					GunIndex = rnd(#CivWepTableSuperRare);
					local item = CivWepTableSuperRare[GunIndex]
					ORGMItemGen:GenerateItem(_containerFilled, item, "Civilian", "Store")
						if diff >= 2 then
							if rnd(10) >= 3 then
								local item = CWSRMagTable[GunIndex]
								ORGMItemGen:GenerateItem(_containerFilled, item, "Civilian", "Store")
							end
							if rnd(10) >= 7 then
								local item = CWSRMagTable[GunIndex]
								ORGMItemGen:GenerateItem(_containerFilled, item, "Civilian", "Store")
							end
						end	
				end
			else		
				if rnd (10) < 7 then
					if rnd (10) < 8 then
						GunIndex = rnd(#PolWepTableCom);
						local item = PolWepTableCom[GunIndex]
						ORGMItemGen:GenerateItem(_containerFilled, item, "Police", "Store")
							if diff >= 2 then
								if rnd(10) >= 3 then
									local item = PWCMagTable[GunIndex]
									ORGMItemGen:GenerateItem(_containerFilled, item, "Police", "Store")
								end
								if rnd(10) >= 7 then
									local item = PWCMagTable[GunIndex]
									ORGMItemGen:GenerateItem(_containerFilled, item, "Police", "Store")
								end
							end
					else
						GunIndex = rnd(#PolWepTableRare);
						local item = PolWepTableRare[GunIndex]
						ORGMItemGen:GenerateItem(_containerFilled, item, "Police", "Store")
							if diff >= 2 then
								if rnd(10) >= 3 then
									local item = PWRMagTable[GunIndex]
									ORGMItemGen:GenerateItem(_containerFilled, item, "Police", "Store")
								end
								if rnd(10) >= 7 then
									local item = PWRMagTable[GunIndex]
									ORGMItemGen:GenerateItem(_containerFilled, item, "Police", "Store")
								end
							end
					end
				else
					if rnd (10) < 8 then
						GunIndex = rnd(#MilWepTableCom);
						local item = MilWepTableCom[GunIndex]
						ORGMItemGen:GenerateItem(_containerFilled, item, "Military", "Store")
							if diff >= 2 then
								if rnd(10) >= 3 then
									local item = MWCMagTable[GunIndex]
									ORGMItemGen:GenerateItem(_containerFilled, item, "Police", "Store")
								end
								if rnd(10) >= 7 then
									local item = MWCMagTable[GunIndex]
									ORGMItemGen:GenerateItem(_containerFilled, item, "Police", "Store")
								end
							end
					else
						GunIndex = rnd(#MilWepTableRare);
						local item = MilWepTableRare[GunIndex]
						ORGMItemGen:GenerateItem(_containerFilled, item, "Military", "Store")
							if diff >= 2 then
								if rnd(10) >= 3 then
									local item = MWRMagTable[GunIndex]
									ORGMItemGen:GenerateItem(_containerFilled, item, "Police", "Store")
								end
								if rnd(10) >= 7 then
									local item = MWRMagTable[GunIndex]
									ORGMItemGen:GenerateItem(_containerFilled, item, "Police", "Store")
								end
							end
					end
				end
			end
		end
		if rnd(5) >= 1 then
			if rnd(10) < 9 then
				ModIndex = rnd(#CivModTable);
				_containerFilled:AddItem(CivModTable[ModIndex]);
			else
				ModIndex = rnd(#NonCivModTable);
				_containerFilled:AddItem(NonCivModTable[ModIndex]);
			end
		end
		if rnd(5) >= 2 then
			if rnd(10) < 9 then
				ModIndex = rnd(#CivModTable);
				_containerFilled:AddItem(CivModTable[ModIndex]);
			else
				ModIndex = rnd(#NonCivModTable);
				_containerFilled:AddItem(NonCivModTable[ModIndex]);
			end
		end
		if rnd(20) >= 2 then
			ammoindex = rnd(#AllBoxTable);
			_containerFilled:AddItem(AllBoxTable[ammoindex]);
		end
		if rnd(20) >= 4 then
			ammoindex = rnd(#AllBoxTable);
			_containerFilled:AddItem(AllBoxTable[ammoindex]);
		end
		if rnd(20) >= 6 then
			ammoindex = rnd(#AllBoxTable);
			_containerFilled:AddItem(AllBoxTable[ammoindex]);
		end
		if rnd(20) >= 8 then
			ammoindex = rnd(#AllBoxTable);
			_containerFilled:AddItem(AllBoxTable[ammoindex]);
		end
		if rnd(20) >= 10 then
			ammoindex = rnd(#AllBoxTable);
			_containerFilled:AddItem(AllBoxTable[ammoindex]);
		end
		if rnd(20) >= 12 then
			ammoindex = rnd(#AllBoxTable);
			_containerFilled:AddItem(AllBoxTable[ammoindex]);
		end
		if rnd(20) >= 14 then
			ammoindex = rnd(#AllBoxTable);
			_containerFilled:AddItem(AllBoxTable[ammoindex]);
		end
		if rnd(20) >= 16 then
			ammoindex = rnd(#AllBoxTable);
			_containerFilled:AddItem(AllBoxTable[ammoindex]);
		end
		if rnd(20) >= 18 then
			ammoindex = rnd(#AllCanTable);
			_containerFilled:AddItem(AllCanTable[ammoindex]);
		end
		if rnd(20) >= 20 then
			ammoindex = rnd(#AllCanTable);
			_containerFilled:AddItem(AllCanTable[ammoindex]);
		end
		if rnd(5) >= 2 then
			RepairIndex = rnd(#RepairTable);
			_containerFilled:AddItem(RepairTable[RepairIndex]);
		end
		if rnd(20) >= 2 then
			ammoindex = rnd(#AllBoxTable);
			_containerFilled:AddItem(AllBoxTable[ammoindex]);
		end
		if rnd(20) >= 4 then
			ammoindex = rnd(#AllBoxTable);
			_containerFilled:AddItem(AllBoxTable[ammoindex]);
		end
		if rnd(20) >= 6 then
			ammoindex = rnd(#AllBoxTable);
			_containerFilled:AddItem(AllBoxTable[ammoindex]);
		end
		if rnd(20) >= 8 then
			ammoindex = rnd(#AllBoxTable);
			_containerFilled:AddItem(AllBoxTable[ammoindex]);
		end
		if rnd(20) >= 10 then
			ammoindex = rnd(#AllBoxTable);
			_containerFilled:AddItem(AllBoxTable[ammoindex]);
		end
		if rnd(20) >= 12 then
			ammoindex = rnd(#AllBoxTable);
			_containerFilled:AddItem(AllBoxTable[ammoindex]);
		end
		if rnd(20) >= 14 then
			ammoindex = rnd(#AllBoxTable);
			_containerFilled:AddItem(AllBoxTable[ammoindex]);
		end
		if rnd(20) >= 16 then
			ammoindex = rnd(#AllBoxTable);
			_containerFilled:AddItem(AllBoxTable[ammoindex]);
		end
		if rnd(20) >= 18 then
			ammoindex = rnd(#AllBoxTable);
			_containerFilled:AddItem(AllBoxTable[ammoindex]);
		end
		if rnd(20) >= 20 then
			ammoindex = rnd(#AllCanTable);
			_containerFilled:AddItem(AllCanTable[ammoindex]);
		end
		if rnd(5) >= 2 then
			RepairIndex = rnd(#RepairTable);
			_containerFilled:AddItem(RepairTable[RepairIndex]);
		end
	elseif _roomName == "storageunit" and _containerType == "crate" then
		if rnd(100) >= 85 then
			if rnd(100) >= 5 then
				if rnd(100) < 85 then
					if rnd (10) < 8 then
						GunIndex = rnd(#CivWepTableCom);
						local item = CivWepTableCom[GunIndex]
						ORGMItemGen:GenerateItem(_containerFilled, item, "Civilian", "Store")
							if diff >= 2 then
								if rnd(10) >= 3 then
									local item = CWCMagTable[GunIndex]
									ORGMItemGen:GenerateItem(_containerFilled, item, "Civilian", "Store")
								end
								if rnd(10) >= 7 then
									local item = CWCMagTable[GunIndex]
									ORGMItemGen:GenerateItem(_containerFilled, item, "Civilian", "Store")
								end
							end
					elseif rnd (10) < 8 then
						GunIndex = rnd(#CivWepTableRare);
						local item = CivWepTableRare[GunIndex]
						ORGMItemGen:GenerateItem(_containerFilled, item, "Civilian", "Store")
							if diff >= 2 then
								if rnd(10) >= 3 then
									local item = CWRMagTable[GunIndex]
									ORGMItemGen:GenerateItem(_containerFilled, item, "Civilian", "Store")
								end
								if rnd(10) >= 7 then
									local item = CWRMagTable[GunIndex]
									ORGMItemGen:GenerateItem(_containerFilled, item, "Civilian", "Store")
								end
							end
					else
						GunIndex = rnd(#CivWepTableSuperRare);
						local item = CivWepTableSuperRare[GunIndex]
						ORGMItemGen:GenerateItem(_containerFilled, item, "Civilian", "Store")
							if diff >= 2 then
								if rnd(10) >= 3 then
									local item = CWSRMagTable[GunIndex]
									ORGMItemGen:GenerateItem(_containerFilled, item, "Civilian", "Store")
								end
								if rnd(10) >= 7 then
									local item = CWSRMagTable[GunIndex]
									ORGMItemGen:GenerateItem(_containerFilled, item, "Civilian", "Store")
								end
							end
					end
				else		
					if rnd (10) < 7 then
						if rnd (10) < 8 then
							GunIndex = rnd(#PolWepTableCom);
							local item = PolWepTableCom[GunIndex]
							ORGMItemGen:GenerateItem(_containerFilled, item, "Police", "Store")
								if diff >= 2 then
									if rnd(10) >= 3 then
										local item = PWCMagTable[GunIndex]
										ORGMItemGen:GenerateItem(_containerFilled, item, "Police", "Store")
									end
									if rnd(10) >= 7 then
										local item = PWCMagTable[GunIndex]
										ORGMItemGen:GenerateItem(_containerFilled, item, "Police", "Store")
									end
								end
						else
							GunIndex = rnd(#PolWepTableRare);
							local item = PolWepTableRare[GunIndex]
							ORGMItemGen:GenerateItem(_containerFilled, item, "Police", "Store")
								if diff >= 2 then
									if rnd(10) >= 3 then
										local item = PWRMagTable[GunIndex]
										ORGMItemGen:GenerateItem(_containerFilled, item, "Police", "Store")
									end
									if rnd(10) >= 7 then
										local item = PWRMagTable[GunIndex]
										ORGMItemGen:GenerateItem(_containerFilled, item, "Police", "Store")
									end
								end
						end
					else
						if rnd (10) < 8 then
							GunIndex = rnd(#MilWepTableCom);
							local item = MilWepTableCom[GunIndex]
							ORGMItemGen:GenerateItem(_containerFilled, item, "Military", "Store")
								if diff >= 2 then
									if rnd(10) >= 3 then
										local item = MWCMagTable[GunIndex]
										ORGMItemGen:GenerateItem(_containerFilled, item, "Military", "Store")
									end
									if rnd(10) >= 7 then
										local item = MWCMagTable[GunIndex]
										ORGMItemGen:GenerateItem(_containerFilled, item, "Military", "Store")
									end
								end
						else
							GunIndex = rnd(#MilWepTableRare);
							local item = MilWepTableRare[GunIndex]
							ORGMItemGen:GenerateItem(_containerFilled, item, "Military", "Store")
								if diff >= 2 then
									if rnd(10) >= 3 then
										local item = MWRMagTable[GunIndex]
										ORGMItemGen:GenerateItem(_containerFilled, item, "Military", "Store")
									end
									if rnd(10) >= 7 then
										local item = MWRMagTable[GunIndex]
										ORGMItemGen:GenerateItem(_containerFilled, item, "Military", "Store")
									end
								end
						end
					end
				end
			end
			if rnd(100) >= 25 then
				if rnd(100) < 85 then
					if rnd (10) < 8 then
						GunIndex = rnd(#CivWepTableCom);
						local item = CivWepTableCom[GunIndex]
						ORGMItemGen:GenerateItem(_containerFilled, item, "Civilian", "Store")
							if diff >= 2 then
								if rnd(10) >= 3 then
									local item = CWCMagTable[GunIndex]
									ORGMItemGen:GenerateItem(_containerFilled, item, "Civilian", "Store")
								end
								if rnd(10) >= 7 then
									local item = CWCMagTable[GunIndex]
									ORGMItemGen:GenerateItem(_containerFilled, item, "Civilian", "Store")
								end
							end
					elseif rnd (10) < 8 then
						GunIndex = rnd(#CivWepTableRare);
						local item = CivWepTableRare[GunIndex]
						ORGMItemGen:GenerateItem(_containerFilled, item, "Civilian", "Store")
							if diff >= 2 then
								if rnd(10) >= 3 then
									local item = CWRMagTable[GunIndex]
									ORGMItemGen:GenerateItem(_containerFilled, item, "Civilian", "Store")
								end
								if rnd(10) >= 7 then
									local item = CWRMagTable[GunIndex]
									ORGMItemGen:GenerateItem(_containerFilled, item, "Civilian", "Store")
								end
							end
					else
						GunIndex = rnd(#CivWepTableSuperRare);
						local item = CivWepTableSuperRare[GunIndex]
						ORGMItemGen:GenerateItem(_containerFilled, item, "Civilian", "Store")
							if diff >= 2 then
								if rnd(10) >= 3 then
									local item = CWSRMagTable[GunIndex]
									ORGMItemGen:GenerateItem(_containerFilled, item, "Civilian", "Store")
								end
								if rnd(10) >= 7 then
									local item = CWSRMagTable[GunIndex]
									ORGMItemGen:GenerateItem(_containerFilled, item, "Civilian", "Store")
								end
							end
					end
				else		
					if rnd (10) < 7 then
						if rnd (10) < 8 then
							GunIndex = rnd(#PolWepTableCom);
							local item = PolWepTableCom[GunIndex]
							ORGMItemGen:GenerateItem(_containerFilled, item, "Police", "Store")
								if diff >= 2 then
									if rnd(10) >= 3 then
										local item = PWCMagTable[GunIndex]
										ORGMItemGen:GenerateItem(_containerFilled, item, "Police", "Store")
									end
									if rnd(10) >= 7 then
										local item = PWCMagTable[GunIndex]
										ORGMItemGen:GenerateItem(_containerFilled, item, "Police", "Store")
									end
								end
						else
							GunIndex = rnd(#PolWepTableRare);
							local item = PolWepTableRare[GunIndex]
							ORGMItemGen:GenerateItem(_containerFilled, item, "Police", "Store")
								if diff >= 2 then
									if rnd(10) >= 3 then
										local item = PWRMagTable[GunIndex]
										ORGMItemGen:GenerateItem(_containerFilled, item, "Police", "Store")
									end
									if rnd(10) >= 7 then
										local item = PWRMagTable[GunIndex]
										ORGMItemGen:GenerateItem(_containerFilled, item, "Police", "Store")
									end
								end
						end
					else
						if rnd (10) < 8 then
							GunIndex = rnd(#MilWepTableCom);
							local item = MilWepTableCom[GunIndex]
							ORGMItemGen:GenerateItem(_containerFilled, item, "Military", "Store")
								if diff >= 2 then
									if rnd(10) >= 3 then
										local item = MWCMagTable[GunIndex]
										ORGMItemGen:GenerateItem(_containerFilled, item, "Military", "Store")
									end
									if rnd(10) >= 7 then
										local item = MWCMagTable[GunIndex]
										ORGMItemGen:GenerateItem(_containerFilled, item, "Military", "Store")
									end
								end
						else
							GunIndex = rnd(#MilWepTableRare);
							local item = MilWepTableRare[GunIndex]
							ORGMItemGen:GenerateItem(_containerFilled, item, "Military", "Store")
								if diff >= 2 then
									if rnd(10) >= 3 then
										local item = MWRMagTable[GunIndex]
										ORGMItemGen:GenerateItem(_containerFilled, item, "Military", "Store")
									end
									if rnd(10) >= 7 then
										local item = MWRMagTable[GunIndex]
										ORGMItemGen:GenerateItem(_containerFilled, item, "Military", "Store")
									end
								end
						end
					end
				end
			end
			if rnd(5) >= 2 then
				if rnd(10) < 9 then
					ModIndex = rnd(#CivModTable);
					_containerFilled:AddItem(CivModTable[ModIndex]);
				else
					ModIndex = rnd(#NonCivModTable);
					_containerFilled:AddItem(NonCivModTable[ModIndex]);
				end
			end
			if rnd(5) >= 42 then
				if rnd(10) < 9 then
					ModIndex = rnd(#CivModTable);
					_containerFilled:AddItem(CivModTable[ModIndex]);
				else
					ModIndex = rnd(#NonCivModTable);
					_containerFilled:AddItem(NonCivModTable[ModIndex]);
				end
			end
			if rnd(20) >= 2 then
				ammoindex = rnd(#AllBoxTable);
				_containerFilled:AddItem(AllBoxTable[ammoindex]);
			end
			if rnd(20) >= 4 then
				ammoindex = rnd(#AllBoxTable);
				_containerFilled:AddItem(AllBoxTable[ammoindex]);
			end
			if rnd(20) >= 6 then
				ammoindex = rnd(#AllBoxTable);
				_containerFilled:AddItem(AllBoxTable[ammoindex]);
			end
			if rnd(20) >= 8 then
				ammoindex = rnd(#AllBoxTable);
				_containerFilled:AddItem(AllBoxTable[ammoindex]);
			end
			if rnd(20) >= 10 then
				ammoindex = rnd(#AllBoxTable);
				_containerFilled:AddItem(AllBoxTable[ammoindex]);
			end
			if rnd(20) >= 12 then
				ammoindex = rnd(#AllBoxTable);
				_containerFilled:AddItem(AllBoxTable[ammoindex]);
			end
			if rnd(20) >= 14 then
				ammoindex = rnd(#AllBoxTable);
				_containerFilled:AddItem(AllBoxTable[ammoindex]);
			end
			if rnd(20) >= 16 then
				ammoindex = rnd(#AllBoxTable);
				_containerFilled:AddItem(AllBoxTable[ammoindex]);
			end
			if rnd(20) >= 18 then
				ammoindex = rnd(#AllBoxTable);
				_containerFilled:AddItem(AllBoxTable[ammoindex]);
			end
			if rnd(20) >= 20 then
				ammoindex = rnd(#AllCanTable);
				_containerFilled:AddItem(AllCanTable[ammoindex]);
			end
			if rnd(5) >= 2 then
				RepairIndex = rnd(#RepairTable);
				local item = _containerFilled:AddItem(RepairTable[RepairIndex]);
			end
		end
	elseif _roomName == "garagestorage" and _containerType == "smallbox" then
		if rnd(100) >= 85 then
			if rnd(100) >= 5 then
				if rnd(100) < 85 then
					if rnd (10) < 8 then
						GunIndex = rnd(#CivWepTableCom);
						local item = CivWepTableCom[GunIndex]
						ORGMItemGen:GenerateItem(_containerFilled, item, "Civilian", "Store")
							if diff >= 2 then
								if rnd(10) >= 3 then
									local item = CWCMagTable[GunIndex]
									ORGMItemGen:GenerateItem(_containerFilled, item, "Civilian", "Store")
								end
								if rnd(10) >= 7 then
									local item = CWCMagTable[GunIndex]
									ORGMItemGen:GenerateItem(_containerFilled, item, "Civilian", "Store")
								end
							end
					elseif rnd (10) < 8 then
						GunIndex = rnd(#CivWepTableRare);
						local item = CivWepTableRare[GunIndex]
						ORGMItemGen:GenerateItem(_containerFilled, item, "Civilian", "Store")
							if diff >= 2 then
								if rnd(10) >= 3 then
									local item = CWRMagTable[GunIndex]
									ORGMItemGen:GenerateItem(_containerFilled, item, "Civilian", "Store")
								end
								if rnd(10) >= 7 then
									local item = CWRMagTable[GunIndex]
									ORGMItemGen:GenerateItem(_containerFilled, item, "Civilian", "Store")
								end
							end
					else
						GunIndex = rnd(#CivWepTableSuperRare);
						local item = CivWepTableSuperRare[GunIndex]
						ORGMItemGen:GenerateItem(_containerFilled, item, "Civilian", "Store")
							if diff >= 2 then
								if rnd(10) >= 3 then
									local item = CWSRMagTable[GunIndex]
									ORGMItemGen:GenerateItem(_containerFilled, item, "Civilian", "Store")
								end
								if rnd(10) >= 7 then
									local item = CWSRMagTable[GunIndex]
									ORGMItemGen:GenerateItem(_containerFilled, item, "Civilian", "Store")
								end
							end
					end
				else		
					if rnd (10) < 7 then
						if rnd (10) < 8 then
							GunIndex = rnd(#PolWepTableCom);
							local item = PolWepTableCom[GunIndex]
							ORGMItemGen:GenerateItem(_containerFilled, item, "Police", "Store")
								if diff >= 2 then
									if rnd(10) >= 3 then
										local item = PWCMagTable[GunIndex]
										ORGMItemGen:GenerateItem(_containerFilled, item, "Police", "Store")
									end
									if rnd(10) >= 7 then
										local item = PWCMagTable[GunIndex]
										ORGMItemGen:GenerateItem(_containerFilled, item, "Police", "Store")
									end
								end
						else
							GunIndex = rnd(#PolWepTableRare);
							local item = PolWepTableRare[GunIndex]
							ORGMItemGen:GenerateItem(_containerFilled, item, "Police", "Store")
								if diff >= 2 then
									if rnd(10) >= 3 then
										local item = PWRMagTable[GunIndex]
										ORGMItemGen:GenerateItem(_containerFilled, item, "Police", "Store")
									end
									if rnd(10) >= 7 then
										local item = PWRMagTable[GunIndex]
										ORGMItemGen:GenerateItem(_containerFilled, item, "Police", "Store")
									end
								end
						end
					else
						if rnd (10) < 8 then
							GunIndex = rnd(#MilWepTableCom);
							local item = MilWepTableCom[GunIndex]
							ORGMItemGen:GenerateItem(_containerFilled, item, "Military", "Store")
								if diff >= 2 then
									if rnd(10) >= 3 then
										local item = MWCMagTable[GunIndex]
										ORGMItemGen:GenerateItem(_containerFilled, item, "Military", "Store")
									end
									if rnd(10) >= 7 then
										local item = MWCMagTable[GunIndex]
										ORGMItemGen:GenerateItem(_containerFilled, item, "Military", "Store")
									end
								end
						else
							GunIndex = rnd(#MilWepTableRare);
							local item = MilWepTableRare[GunIndex]
							ORGMItemGen:GenerateItem(_containerFilled, item, "Military", "Store")
								if diff >= 2 then
									if rnd(10) >= 3 then
										local item = MWRMagTable[GunIndex]
										ORGMItemGen:GenerateItem(_containerFilled, item, "Military", "Store")
									end
									if rnd(10) >= 7 then
										local item = MWRMagTable[GunIndex]
										ORGMItemGen:GenerateItem(_containerFilled, item, "Military", "Store")
									end
								end
						end
					end
				end
			end
			if rnd(100) >= 25 then
				if rnd(100) < 85 then
					if rnd (10) < 8 then
						GunIndex = rnd(#CivWepTableCom);
						local item = CivWepTableCom[GunIndex]
						ORGMItemGen:GenerateItem(_containerFilled, item, "Civilian", "Store")
							if diff >= 2 then
								if rnd(10) >= 3 then
									local item = CWCMagTable[GunIndex]
									ORGMItemGen:GenerateItem(_containerFilled, item, "Civilian", "Store")
								end
								if rnd(10) >= 7 then
									local item = CWCMagTable[GunIndex]
									ORGMItemGen:GenerateItem(_containerFilled, item, "Civilian", "Store")
								end
							end
					elseif rnd (10) < 8 then
						GunIndex = rnd(#CivWepTableRare);
						local item = CivWepTableRare[GunIndex]
						ORGMItemGen:GenerateItem(_containerFilled, item, "Civilian", "Store")
							if diff >= 2 then
								if rnd(10) >= 3 then
									local item = CWRMagTable[GunIndex]
									ORGMItemGen:GenerateItem(_containerFilled, item, "Civilian", "Store")
								end
								if rnd(10) >= 7 then
									local item = CWRMagTable[GunIndex]
									ORGMItemGen:GenerateItem(_containerFilled, item, "Civilian", "Store")
								end
							end
					else
						GunIndex = rnd(#CivWepTableSuperRare);
						local item = CivWepTableSuperRare[GunIndex]
						ORGMItemGen:GenerateItem(_containerFilled, item, "Civilian", "Store")
							if diff >= 2 then
								if rnd(10) >= 3 then
									local item = CWSRMagTable[GunIndex]
									ORGMItemGen:GenerateItem(_containerFilled, item, "Civilian", "Store")
								end
								if rnd(10) >= 7 then
									local item = CWSRMagTable[GunIndex]
									ORGMItemGen:GenerateItem(_containerFilled, item, "Civilian", "Store")
								end
							end
					end
				else		
					if rnd (10) < 7 then
						if rnd (10) < 8 then
							GunIndex = rnd(#PolWepTableCom);
							local item = PolWepTableCom[GunIndex]
							ORGMItemGen:GenerateItem(_containerFilled, item, "Police", "Store")
								if diff >= 2 then
									if rnd(10) >= 3 then
										local item = PWCMagTable[GunIndex]
										ORGMItemGen:GenerateItem(_containerFilled, item, "Police", "Store")
									end
									if rnd(10) >= 7 then
										local item = PWCMagTable[GunIndex]
										ORGMItemGen:GenerateItem(_containerFilled, item, "Police", "Store")
									end
								end
						else
							GunIndex = rnd(#PolWepTableRare);
							local item = PolWepTableRare[GunIndex]
							ORGMItemGen:GenerateItem(_containerFilled, item, "Police", "Store")
								if diff >= 2 then
									if rnd(10) >= 3 then
										local item = PWRMagTable[GunIndex]
										ORGMItemGen:GenerateItem(_containerFilled, item, "Police", "Store")
									end
									if rnd(10) >= 7 then
										local item = PWRMagTable[GunIndex]
										ORGMItemGen:GenerateItem(_containerFilled, item, "Police", "Store")
									end
								end
						end
					else
						if rnd (10) < 8 then
							GunIndex = rnd(#MilWepTableCom);
							local item = MilWepTableCom[GunIndex]
							ORGMItemGen:GenerateItem(_containerFilled, item, "Military", "Store")
								if diff >= 2 then
									if rnd(10) >= 3 then
										local item = MWCMagTable[GunIndex]
										ORGMItemGen:GenerateItem(_containerFilled, item, "Military", "Store")
									end
									if rnd(10) >= 7 then
										local item = MWCMagTable[GunIndex]
										ORGMItemGen:GenerateItem(_containerFilled, item, "Military", "Store")
									end
								end
						else
							GunIndex = rnd(#MilWepTableRare);
							local item = MilWepTableRare[GunIndex]
							ORGMItemGen:GenerateItem(_containerFilled, item, "Military", "Store")
								if diff >= 2 then
									if rnd(10) >= 3 then
										local item = MWRMagTable[GunIndex]
										ORGMItemGen:GenerateItem(_containerFilled, item, "Military", "Store")
									end
									if rnd(10) >= 7 then
										local item = MWRMagTable[GunIndex]
										ORGMItemGen:GenerateItem(_containerFilled, item, "Military", "Store")
									end
								end
						end
					end
				end
			end
			if rnd(5) >= 2 then
				if rnd(10) < 9 then
					ModIndex = rnd(#CivModTable);
					_containerFilled:AddItem(CivModTable[ModIndex]);
				else
					ModIndex = rnd(#NonCivModTable);
					_containerFilled:AddItem(NonCivModTable[ModIndex]);
				end
			end
			if rnd(5) >= 42 then
				if rnd(10) < 9 then
					ModIndex = rnd(#CivModTable);
					_containerFilled:AddItem(CivModTable[ModIndex]);
				else
					ModIndex = rnd(#NonCivModTable);
					_containerFilled:AddItem(NonCivModTable[ModIndex]);
				end
			end
			if rnd(20) >= 2 then
				ammoindex = rnd(#AllBoxTable);
				_containerFilled:AddItem(AllBoxTable[ammoindex]);
			end
			if rnd(20) >= 4 then
				ammoindex = rnd(#AllBoxTable);
				_containerFilled:AddItem(AllBoxTable[ammoindex]);
			end
			if rnd(20) >= 6 then
				ammoindex = rnd(#AllBoxTable);
				_containerFilled:AddItem(AllBoxTable[ammoindex]);
			end
			if rnd(20) >= 8 then
				ammoindex = rnd(#AllBoxTable);
				_containerFilled:AddItem(AllBoxTable[ammoindex]);
			end
			if rnd(20) >= 10 then
				ammoindex = rnd(#AllBoxTable);
				_containerFilled:AddItem(AllBoxTable[ammoindex]);
			end
			if rnd(20) >= 12 then
				ammoindex = rnd(#AllBoxTable);
				_containerFilled:AddItem(AllBoxTable[ammoindex]);
			end
			if rnd(20) >= 14 then
				ammoindex = rnd(#AllBoxTable);
				_containerFilled:AddItem(AllBoxTable[ammoindex]);
			end
			if rnd(20) >= 16 then
				ammoindex = rnd(#AllBoxTable);
				_containerFilled:AddItem(AllBoxTable[ammoindex]);
			end
			if rnd(20) >= 18 then
				ammoindex = rnd(#AllBoxTable);
				_containerFilled:AddItem(AllBoxTable[ammoindex]);
			end
			if rnd(20) >= 20 then
				ammoindex = rnd(#AllCanTable);
				_containerFilled:AddItem(AllCanTable[ammoindex]);
			end
			if rnd(5) >= 2 then
				RepairIndex = rnd(#RepairTable);
				local item = _containerFilled:AddItem(RepairTable[RepairIndex]);
			end
		end
	elseif _roomName == "hunting" and _containerType == "metal_shelves" then
		if rnd(100) >= 35 then
			if rnd(10) < 8 then
				if rnd (10) < 8 then
					GunIndex = rnd(#CivWepTableCom);
					local item = CivWepTableCom[GunIndex]
					ORGMItemGen:GenerateItem(_containerFilled, item, "Civilian", "Store")
					quantity = rnd(20)
					if rnd(10) >= 9 then
						while quantity ~=0 do
							_containerFilled:AddItem(CWCAmmoTable2[GunIndex]);
							quantity = quantity-1
						end
					else
						while quantity ~=0 do
							_containerFilled:AddItem(CWCAmmoTable[GunIndex]);
							quantity = quantity-1
						end
					end
					if rnd(10) >= 6 then
						if rnd(10) >= 9 then
							_containerFilled:AddItem(CWCBoxTable2[GunIndex]);
						else
							_containerFilled:AddItem(CWCBoxTable[GunIndex]);
						end
					end
					if diff >= 2 then
						if rnd(10) >= 4 then
							local item = CWCMagTable[GunIndex]
							ORGMItemGen:GenerateItem(_containerFilled, item, "Civilian", "Store")
						end
						if rnd(10) >= 8 then
							local item = CWCMagTable[GunIndex]
							ORGMItemGen:GenerateItem(_containerFilled, item, "Civilian", "Store")
						end
					end
				elseif rnd (10) < 8 then
					GunIndex = rnd(#CivWepTableRare);
					local item = CivWepTableRare[GunIndex]
					ORGMItemGen:GenerateItem(_containerFilled, item, "Civilian", "Store")
					quantity = rnd(20)
					if rnd(10) >= 9 then
						while quantity ~=0 do
							_containerFilled:AddItem(CWRAmmoTable2[GunIndex]);
							quantity = quantity-1
						end
					else
						while quantity ~=0 do
							_containerFilled:AddItem(CWRAmmoTable[GunIndex]);
							quantity = quantity-1
						end
					end
					if rnd(10) >= 6 then
						if rnd(10) >= 9 then
							_containerFilled:AddItem(CWRBoxTable2[GunIndex]);
						else
							_containerFilled:AddItem(CWRBoxTable[GunIndex]);
						end
					end
					if diff >= 2 then
						if rnd(10) >= 4 then
							local item = CWRMagTable[GunIndex]
							ORGMItemGen:GenerateItem(_containerFilled, item, "Civilian", "Store")
						end
						if rnd(10) >= 8 then
							local item = CWRMagTable[GunIndex]
							ORGMItemGen:GenerateItem(_containerFilled, item, "Civilian", "Store")
						end
					end
				else
					GunIndex = rnd(#CivWepTableSuperRare);
					local item = CivWepTableSuperRare[GunIndex]
					ORGMItemGen:GenerateItem(_containerFilled, item, "Civilian", "Store")
					quantity = rnd(20)
					if rnd(10) >= 9 then
						while quantity ~=0 do
							_containerFilled:AddItem(CWSRAmmoTable2[GunIndex]);
							quantity = quantity-1
						end
					else
						while quantity ~=0 do
							_containerFilled:AddItem(CWSRAmmoTable[GunIndex]);
							quantity = quantity-1
						end
					end
					if rnd(10) >= 6 then
						if rnd(10) >= 9 then
							_containerFilled:AddItem(CWSRBoxTable2[GunIndex]);
						else
							_containerFilled:AddItem(CWSRBoxTable[GunIndex]);
						end
					end
					if diff >= 2 then
						if rnd(10) >= 4 then
							local item = CWSRMagTable[GunIndex]
							ORGMItemGen:GenerateItem(_containerFilled, item, "Civilian", "Store")
						end
						if rnd(10) >= 8 then
							local item = CWSRMagTable[GunIndex]
							ORGMItemGen:GenerateItem(_containerFilled, item, "Civilian", "Store")
						end
					end
				end
			else		
				if rnd (10) < 7 then
					if rnd (10) < 8 then
						GunIndex = rnd(#PolWepTableCom);
						local item = PolWepTableCom[GunIndex]
						ORGMItemGen:GenerateItem(_containerFilled, item, "Police", "Store")
					quantity = rnd(20)
					if rnd(10) >= 9 then
						while quantity ~=0 do
							_containerFilled:AddItem(PWCAmmoTable2[GunIndex]);
							quantity = quantity-1
						end
					else
						while quantity ~=0 do
							_containerFilled:AddItem(PWCAmmoTable[GunIndex]);
							quantity = quantity-1
						end
					end
					if rnd(10) >= 6 then
						if rnd(10) >= 9 then
							_containerFilled:AddItem(PWCBoxTable2[GunIndex]);
						else
							_containerFilled:AddItem(PWCBoxTable[GunIndex]);
						end
					end
						if diff >= 2 then
							if rnd(10) >= 4 then
								local item = PWCMagTable[GunIndex]
								ORGMItemGen:GenerateItem(_containerFilled, item, "Police", "Store")
							end
							if rnd(10) >= 8 then
								local item = PWCMagTable[GunIndex]
								ORGMItemGen:GenerateItem(_containerFilled, item, "Police", "Store")
							end
						end
					else
						GunIndex = rnd(#PolWepTableRare);
						local item = PolWepTableRare[GunIndex]
						ORGMItemGen:GenerateItem(_containerFilled, item, "Police", "Store")
					quantity = rnd(20)
					if rnd(10) >= 9 then
						while quantity ~=0 do
							_containerFilled:AddItem(PWRAmmoTable2[GunIndex]);
							quantity = quantity-1
						end
					else
						while quantity ~=0 do
							_containerFilled:AddItem(PWRAmmoTable[GunIndex]);
							quantity = quantity-1
						end
					end
					if rnd(10) >= 6 then
						if rnd(10) >= 9 then
							_containerFilled:AddItem(PWRBoxTable2[GunIndex]);
						else
							_containerFilled:AddItem(PWRBoxTable[GunIndex]);
						end
					end
						if diff >= 2 then
							if rnd(10) >= 4 then
								local item = PWRMagTable[GunIndex]
								ORGMItemGen:GenerateItem(_containerFilled, item, "Police", "Store")
							end
							if rnd(10) >= 8 then
								local item = PWRMagTable[GunIndex]
								ORGMItemGen:GenerateItem(_containerFilled, item, "Police", "Store")
							end
						end
					end
				else
					if rnd (10) < 8 then
						GunIndex = rnd(#MilWepTableCom);
						local item = MilWepTableCom[GunIndex]
						ORGMItemGen:GenerateItem(_containerFilled, item, "Military", "Store")
					quantity = rnd(20)
					if rnd(10) >= 9 then
						while quantity ~=0 do
							_containerFilled:AddItem(MWCAmmoTable2[GunIndex]);
							quantity = quantity-1
						end
					else
						while quantity ~=0 do
							_containerFilled:AddItem(MWCAmmoTable[GunIndex]);
							quantity = quantity-1
						end
					end
					if rnd(10) >= 6 then
						if rnd(10) >= 9 then
							_containerFilled:AddItem(MWCBoxTable2[GunIndex]);
						else
							_containerFilled:AddItem(MWCBoxTable[GunIndex]);
						end
					end
						if diff >= 2 then
							if rnd(10) >= 4 then
								local item = MWCMagTable[GunIndex]
								ORGMItemGen:GenerateItem(_containerFilled, item, "Military", "Store")
							end
							if rnd(10) >= 8 then
								local item = MWCMagTable[GunIndex]
								ORGMItemGen:GenerateItem(_containerFilled, item, "Military", "Store")
							end
						end
					else
						GunIndex = rnd(#MilWepTableRare);
						local item = MilWepTableRare[GunIndex]
						ORGMItemGen:GenerateItem(_containerFilled, item, "Military", "Store")
					quantity = rnd(20)
					if rnd(10) >= 9 then
						while quantity ~=0 do
							_containerFilled:AddItem(MWRAmmoTable2[GunIndex]);
							quantity = quantity-1
						end
					else
						while quantity ~=0 do
							_containerFilled:AddItem(MWRAmmoTable[GunIndex]);
							quantity = quantity-1
						end
					end
					if rnd(10) >= 6 then
						if rnd(10) >= 9 then
							_containerFilled:AddItem(MWRBoxTable2[GunIndex]);
						else
							_containerFilled:AddItem(MWRBoxTable[GunIndex]);
						end
					end
						if diff >= 2 then
							if rnd(10) >= 4 then
								local item = MWRMagTable[GunIndex]
								ORGMItemGen:GenerateItem(_containerFilled, item, "Military", "Store")
							end
							if rnd(10) >= 8 then
								local item = MWRMagTable[GunIndex]
								ORGMItemGen:GenerateItem(_containerFilled, item, "Military", "Store")
							end
						end
					end
				end
			end
		end
	end
end
	
	CivWepTableCom = {
		"ORGM.Ber92",
		"ORGM.BrownHP",
		"ORGM.BBPistol",
		"ORGM.Glock17",
		"ORGM.Glock22",
		"ORGM.Glock21",
		"ORGM.M1911",
		"ORGM.RugerMKII",
		"ORGM.SIGP226",
		"ORGM.WaltherP22",
		"ORGM.ColtAnac",
		"ORGM.ColtPyth",
		"ORGM.RugSec6",
		"ORGM.SWM36",
		"ORGM.Taurus454",
		"ORGM.Garand",
		"ORGM.BBGun",
		"ORGM.Rem700",
		"ORGM.Rug1022",
		"ORGM.Mini14",
		"ORGM.SKS",
		"ORGM.Ithaca37",
		"ORGM.Ithaca37SO",
		"ORGM.Moss590",
		"ORGM.Moss590SO",
		"ORGM.Rem870",
		"ORGM.Rem870SO",
		"ORGM.Silverhawk",
		"ORGM.SilverHawkSO",
		"ORGM.WaltherPPK",
		"ORGM.Mosin",
		"ORGM.BLR",
		"ORGM.Glock20",
		"ORGM.Stevens320",
		"ORGM.RugerSR9",
		"ORGM.XD40",
		"ORGM.KahrP380",
		"ORGM.KahrCT40",
		"ORGM.Hawk982",
		"ORGM.Marlin60",
		"ORGM.KTP32",
		"ORGM.TaurusP132",
		"ORGM.Spr19119",
		"ORGM.SWM10",
		"ORGM.AR15",
		};
		
	CWCAmmoTable = {
		"ORGM.9mmRounds",
		"ORGM.9mmRounds",
		"ORGM.BBs",
		"ORGM.9mmRounds",
		"ORGM.40Rounds",
		"ORGM.45Rounds",
		"ORGM.45Rounds",
		"ORGM.22Rounds",
		"ORGM.40Rounds",
		"ORGM.22Rounds",
		"ORGM.44Rounds",
		"ORGM.357Rounds",
		"ORGM.38Rounds",
		"ORGM.38Rounds",
		"ORGM.454Rounds",
		"ORGM.3006Rounds",
		"ORGM.BBs",
		"ORGM.3006Rounds",
		"ORGM.22Rounds",
		"ORGM.223Rounds",
		"ORGM.762Rounds",
		"ORGM.12gRounds",
		"ORGM.12gRounds",
		"ORGM.12gRounds",
		"ORGM.12gRounds",
		"ORGM.12gRounds",
		"ORGM.12gRounds",
		"ORGM.12gRounds",
		"ORGM.12gRounds",
		"ORGM.380Rounds",
		"ORGM.762x54Rounds",
		"ORGM.308Rounds",
		"ORGM.10mmRounds",
		"ORGM.12gRounds",
		"ORGM.9mmRounds",
		"ORGM.40Rounds",
		"ORGM.380Rounds",
		"ORGM.40Rounds",
		"ORGM.12gRounds",
		"ORGM.22Rounds",
		"ORGM.32Rounds",
		"ORGM.32Rounds",
		"ORGM.9mmRounds",
		"ORGM.38Rounds",
		"ORGM.223Rounds",
		};
		
	CWCAmmoTable2 = {
		"ORGM.9mmRounds",
		"ORGM.9mmRounds",
		"ORGM.BBs",
		"ORGM.9mmRounds",
		"ORGM.40Rounds",
		"ORGM.45Rounds",
		"ORGM.45Rounds",
		"ORGM.22Rounds",
		"ORGM.40Rounds",
		"ORGM.22Rounds",
		"ORGM.44Rounds",
		"ORGM.38Rounds",
		"ORGM.38Rounds",
		"ORGM.38Rounds",
		"ORGM.45ColtRounds",
		"ORGM.3006Rounds",
		"ORGM.BBs",
		"ORGM.3006Rounds",
		"ORGM.22Rounds",
		"ORGM.556Rounds",
		"ORGM.762Rounds",
		"ORGM.12gSlugRounds",
		"ORGM.12gSlugRounds",
		"ORGM.12gSlugRounds",
		"ORGM.12gSlugRounds",
		"ORGM.12gSlugRounds",
		"ORGM.12gSlugRounds",
		"ORGM.12gSlugRounds",
		"ORGM.12gSlugRounds",
		"ORGM.380Rounds",
		"ORGM.762x54Rounds",
		"ORGM.762x51Rounds",
		"ORGM.10mmRounds",
		"ORGM.12gSlugRounds",
		"ORGM.9mmRounds",
		"ORGM.40Rounds",
		"ORGM.380Rounds",
		"ORGM.40Rounds",
		"ORGM.12gSlugRounds",
		"ORGM.22Rounds",
		"ORGM.32Rounds",
		"ORGM.32Rounds",
		"ORGM.9mmRounds",
		"ORGM.38Rounds",
		"ORGM.556Rounds",
		};
	
	CWCBoxTable = {
		"ORGM.9mmBox",
		"ORGM.9mmBox",
		"ORGM.BBCan",
		"ORGM.9mmBox",
		"ORGM.40Box",
		"ORGM.45Box",
		"ORGM.45Box",
		"ORGM.22Box",
		"ORGM.40Box",
		"ORGM.22Box",
		"ORGM.44Box",
		"ORGM.357Box",
		"ORGM.38Box",
		"ORGM.38Box",
		"ORGM.454Box",
		"ORGM.3006Box",
		"ORGM.BBCan",
		"ORGM.3006Box",
		"ORGM.22Box",
		"ORGM.223RemBox",
		"ORGM.762Box",
		"ORGM.12gBox",
		"ORGM.12gBox",
		"ORGM.12gBox",
		"ORGM.12gBox",
		"ORGM.12gBox",
		"ORGM.12gBox",
		"ORGM.12gBox",
		"ORGM.12gBox",
		"ORGM.380Box",
		"ORGM.762x54Box",
		"ORGM.308wBox",
		"ORGM.10mmBox",
		"ORGM.12gBox",
		"ORGM.9mmBox",
		"ORGM.40Box",
		"ORGM.380Box",
		"ORGM.40Box",
		"ORGM.12gBox",
		"ORGM.22Box",
		"ORGM.32Box",
		"ORGM.32Box",
		"ORGM.9mmBox",
		"ORGM.38Box",
		"ORGM.223RemBox",
		};
		
	CWCBoxTable2 = {
		"ORGM.9mmBox",
		"ORGM.9mmBox",
		"ORGM.BBCan",
		"ORGM.9mmBox",
		"ORGM.40Box",
		"ORGM.45Box",
		"ORGM.45Box",
		"ORGM.22Box",
		"ORGM.40Box",
		"ORGM.22Box",
		"ORGM.44Box",
		"ORGM.38Box",
		"ORGM.38Box",
		"ORGM.38Box",
		"ORGM.45ColtBox",
		"ORGM.3006Box",
		"ORGM.BBCan",
		"ORGM.3006Box",
		"ORGM.22Box",
		"ORGM.556Box",
		"ORGM.762Box",
		"ORGM.12gSlugBox",
		"ORGM.12gSlugBox",
		"ORGM.12gSlugBox",
		"ORGM.12gSlugBox",
		"ORGM.12gSlugBox",
		"ORGM.12gSlugBox",
		"ORGM.12gSlugBox",
		"ORGM.12gSlugBox",
		"ORGM.380Box",
		"ORGM.762x54Box",
		"ORGM.762x51Box",
		"ORGM.10mmBox",
		"ORGM.12gSlugBox",
		"ORGM.9mmBox",
		"ORGM.40Box",
		"ORGM.380Box",
		"ORGM.40Box",
		"ORGM.12gSlugBox",
		"ORGM.22Box",
		"ORGM.32Box",
		"ORGM.32Box",
		"ORGM.9mmBox",
		"ORGM.38Box",
		"ORGM.556Box",
		};
		
	CWCCanTable = {
		"ORGM.9mmCan",
		"ORGM.9mmCan",
		"ORGM.BBCan",
		"ORGM.9mmCan",
		"ORGM.40Can",
		"ORGM.45Can",
		"ORGM.45Can",
		"ORGM.22Can",
		"ORGM.40Can",
		"ORGM.22Can",
		"ORGM.44Can",
		"ORGM.357Can",
		"ORGM.38Can",
		"ORGM.38Can",
		"ORGM.454Can",
		"ORGM.3006Can",
		"ORGM.BBCan",
		"ORGM.3006Can",
		"ORGM.22Can",
		"ORGM.223RemCan",
		"ORGM.762Can",
		"ORGM.12gCan",
		"ORGM.12gCan",
		"ORGM.12gCan",
		"ORGM.12gCan",
		"ORGM.12gCan",
		"ORGM.12gCan",
		"ORGM.12gCan",
		"ORGM.12gCan",
		"ORGM.380Can",
		"ORGM.762x54Can",
		"ORGM.308wCan",
		"ORGM.10mmCan",
		"ORGM.12gCan",
		"ORGM.9mmCan",
		"ORGM.40Can",
		"ORGM.380Can",
		"ORGM.40Can",
		"ORGM.12gCan",
		"ORGM.22Can",
		"ORGM.32Can",
		"ORGM.32Can",
		"ORGM.9mmCan",
		"ORGM.38Can",
		"ORGM.223RemCan",
		};
		
	CWCCanTable2 = {
		"ORGM.9mmCan",
		"ORGM.9mmCan",
		"ORGM.BBCan",
		"ORGM.9mmCan",
		"ORGM.40Can",
		"ORGM.45Can",
		"ORGM.45Can",
		"ORGM.22Can",
		"ORGM.40Can",
		"ORGM.22Can",
		"ORGM.44Can",
		"ORGM.38Can",
		"ORGM.38Can",
		"ORGM.38Can",
		"ORGM.45ColtCan",
		"ORGM.3006Can",
		"ORGM.BBCan",
		"ORGM.3006Can",
		"ORGM.22Can",
		"ORGM.556Can",
		"ORGM.762Can",
		"ORGM.12gSlugCan",
		"ORGM.12gSlugCan",
		"ORGM.12gSlugCan",
		"ORGM.12gSlugCan",
		"ORGM.12gSlugCan",
		"ORGM.12gSlugCan",
		"ORGM.12gSlugCan",
		"ORGM.12gSlugCan",
		"ORGM.380Can",
		"ORGM.762x54Can",
		"ORGM.762x51Can",
		"ORGM.10mmCan",
		"ORGM.12gSlugCan",
		"ORGM.9mmCan",
		"ORGM.40Can",
		"ORGM.380Can",
		"ORGM.40Can",
		"ORGM.12gSlugCan",
		"ORGM.22Can",
		"ORGM.32Can",
		"ORGM.32Can",
		"ORGM.9mmCan",
		"ORGM.38Can",
		"ORGM.556Can",
		};
		
	CWCMagTable = {
		"ORGM.Ber92Mag",
		"ORGM.BrownHPMag",
		"ORGM.BBPistolMag",
		"ORGM.Glock17Mag",
		"ORGM.Glock22Mag",
		"ORGM.Glock21Mag",
		"ORGM.M1911Mag",
		"ORGM.RugerMKIIMag",
		"ORGM.SIGP226Mag",
		"ORGM.WaltherP22Mag",
		"ORGM.SpeedLoader446",
		"ORGM.SpeedLoader3576",
		"ORGM.SpeedLoader386",
		"ORGM.SpeedLoader385",
		"ORGM.SpeedLoader4546",
		"ORGM.GarandClip",
		"",
		"",
		"ORGM.Rug1022Mag",
		"ORGM.Mini14Mag",
		"ORGM.SKSStripperClip",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"ORGM.WaltherPPKMag",
		"ORGM.MosinStripperClip",
		"",
		"ORGM.Glock20Mag",
		"",
		"ORGM.RugerSR9Mag",
		"ORGM.XD40Mag",
		"ORGM.KahrP380Mag",
		"ORGM.KahrCT40Mag",
		"",
		"",
		"ORGM.KTP32Mag",
		"ORGM.TaurusP132Mag",
		"ORGM.Spr19119Mag",
		"ORGM.SpeedLoader386",
		"ORGM.STANAG223Mag",
		};
	
	CivWepTableRare = {
		"ORGM.BrenTen",
		"ORGM.ColtDelta",
		"ORGM.FN57",
		"ORGM.Colt38S",
		"ORGM.Taurus38",
		"ORGM.RugAlas",
		"ORGM.RugGP100",
		"ORGM.RugRH",
		"ORGM.SWM19",
		"ORGM.SWM29",
		"ORGM.SWM610",
		"ORGM.AKM",
		"ORGM.R25",
		"ORGM.FNFAL",
		"ORGM.HK91",
		"ORGM.WinM70",
		"ORGM.AIAW308",
		"ORGM.Spas12",
		"ORGM.HKSL8",
		"ORGM.M1A1",
		"ORGM.DEagle",
		"ORGM.Kriss",
		"ORGM.KTPLR",
		"ORGM.Mac10",
		"ORGM.Mac11",
		"ORGM.Uzi",
		"ORGM.M1216",
		"ORGM.VEPR12",
		"ORGM.SVD",
		"ORGM.HenryBB",
		"ORGM.ColtSAA",
		"ORGM.DEagleXIX",
		"ORGM.AutomagV",
		"ORGM.Striker",
		"ORGM.WinM94",
		"ORGM.Rem788",
		"ORGM.CZ75",
		"ORGM.HKMK23",
		"ORGM.M1903",
		"ORGM.LENo4",
		"ORGM.RugBH",
		"ORGM.SWM252",
		};
	
	CWRAmmoTable = {
		"ORGM.10mmRounds",
		"ORGM.10mmRounds",
		"ORGM.57Rounds",
		"ORGM.38SRounds",
		"ORGM.38SRounds",
		"ORGM.454Rounds",
		"ORGM.357Rounds",
		"ORGM.44Rounds",
		"ORGM.357Rounds",
		"ORGM.44Rounds",
		"ORGM.10mmRounds",
		"ORGM.762Rounds",
		"ORGM.308Rounds",
		"ORGM.308Rounds",
		"ORGM.308Rounds",
		"ORGM.3006Rounds",
		"ORGM.308Rounds",
		"ORGM.12gRounds",
		"ORGM.223Rounds",
		"ORGM.45Rounds",
		"ORGM.44Rounds",
		"ORGM.45Rounds",
		"ORGM.223Rounds",
		"ORGM.45Rounds",
		"ORGM.380Rounds",
		"ORGM.9mmRounds",
		"ORGM.12gRounds",
		"ORGM.12gRounds",
		"ORGM.762x54Rounds",
		"ORGM.45ColtRounds",
		"ORGM.45ColtRounds",
		"ORGM.50AERounds",
		"ORGM.50AERounds",
		"ORGM.12gRounds",
		"ORGM.3030Rounds",
		"ORGM.3030Rounds",
		"ORGM.40Rounds",
		"ORGM.45Rounds",
		"ORGM.3006Rounds",
		"ORGM.762x51Rounds",
		"ORGM.357Rounds",
		"ORGM.45Rounds",
		};
		
	CWRAmmoTable2 = {
		"ORGM.10mmRounds",
		"ORGM.10mmRounds",
		"ORGM.57Rounds",
		"ORGM.38SRounds",
		"ORGM.38SRounds",
		"ORGM.45ColtRounds",
		"ORGM.38Rounds",
		"ORGM.44Rounds",
		"ORGM.38Rounds",
		"ORGM.44Rounds",
		"ORGM.10mmRounds",
		"ORGM.762Rounds",
		"ORGM.762x51Rounds",
		"ORGM.762x51Rounds",
		"ORGM.762x51Rounds",
		"ORGM.3006Rounds",
		"ORGM.762x51Rounds",
		"ORGM.12gSlugRounds",
		"ORGM.556Rounds",
		"ORGM.45Rounds",
		"ORGM.44Rounds",
		"ORGM.45Rounds",
		"ORGM.556Rounds",
		"ORGM.45Rounds",
		"ORGM.380Rounds",
		"ORGM.9mmRounds",
		"ORGM.12gSlugRounds",
		"ORGM.12gSlugRounds",
		"ORGM.762x54Rounds",
		"ORGM.45ColtRounds",
		"ORGM.45ColtRounds",
		"ORGM.50AERounds",
		"ORGM.50AERounds",
		"ORGM.12gSlugRounds",
		"ORGM.3030Rounds",
		"ORGM.3030Rounds",
		"ORGM.40Rounds",
		"ORGM.45Rounds",
		"ORGM.3006Rounds",
		"ORGM.308Rounds",
		"ORGM.38Rounds",
		"ORGM.45Rounds",
		};
	
	CWRBoxTable = {
		"ORGM.10mmBox",
		"ORGM.10mmBox",
		"ORGM.57Box",
		"ORGM.38SBox",
		"ORGM.38SBox",
		"ORGM.454Box",
		"ORGM.357Box",
		"ORGM.44Box",
		"ORGM.357Box",
		"ORGM.44Box",
		"ORGM.10mmBox",
		"ORGM.762Box",
		"ORGM.308wBox",
		"ORGM.308wBox",
		"ORGM.308wBox",
		"ORGM.3006Box",
		"ORGM.308wBox",
		"ORGM.12gBox",
		"ORGM.223RemBox",
		"ORGM.45Box",
		"ORGM.44Box",
		"ORGM.45Box",
		"ORGM.223RemBox",
		"ORGM.45Box",
		"ORGM.380Box",
		"ORGM.9mmBox",
		"ORGM.12gBox",
		"ORGM.12gBox",
		"ORGM.762x54Box",
		"ORGM.45ColtBox",
		"ORGM.45ColtBox",
		"ORGM.50AEBox",
		"ORGM.50AEBox",
		"ORGM.12gBox",
		"ORGM.3030Box",
		"ORGM.3030Box",
		"ORGM.40Box",
		"ORGM.45Box",
		"ORGM.3006Box",
		"ORGM.762x51Box",
		"ORGM.357Box",
		"ORGM.45Box",
		};
		
		CWRBoxTable2 = {
		"ORGM.10mmBox",
		"ORGM.10mmBox",
		"ORGM.57Box",
		"ORGM.38SBox",
		"ORGM.38SBox",
		"ORGM.45ColtBox",
		"ORGM.38Box",
		"ORGM.44Box",
		"ORGM.38Box",
		"ORGM.44Box",
		"ORGM.10mmBox",
		"ORGM.762Box",
		"ORGM.762x51Box",
		"ORGM.762x51Box",
		"ORGM.762x51Box",
		"ORGM.3006Box",
		"ORGM.762x51Box",
		"ORGM.12gSlugBox",
		"ORGM.556Box",
		"ORGM.45Box",
		"ORGM.44Box",
		"ORGM.45Box",
		"ORGM.556Box",
		"ORGM.45Box",
		"ORGM.380Box",
		"ORGM.9mmBox",
		"ORGM.12gSlugBox",
		"ORGM.12gSlugBox",
		"ORGM.762x54Box",
		"ORGM.45ColtBox",
		"ORGM.45ColtBox",
		"ORGM.50AEBox",
		"ORGM.50AEBox",
		"ORGM.12gSlugBox",
		"ORGM.3030Box",
		"ORGM.3030Box",
		"ORGM.40Box",
		"ORGM.45Box",
		"ORGM.3006Box",
		"ORGM.308wBox",
		"ORGM.38Box",
		"ORGM.45Box",
		};
		
	CWRCanTable = {
		"ORGM.10mmCan",
		"ORGM.10mmCan",
		"ORGM.57Can",
		"ORGM.38SCan",
		"ORGM.38SCan",
		"ORGM.454Can",
		"ORGM.357Can",
		"ORGM.44Can",
		"ORGM.357Can",
		"ORGM.44Can",
		"ORGM.10mmCan",
		"ORGM.762Can",
		"ORGM.308wCan",
		"ORGM.308wCan",
		"ORGM.308wCan",
		"ORGM.3006Can",
		"ORGM.308wCan",
		"ORGM.12gCan",
		"ORGM.223RemCan",
		"ORGM.45Can",
		"ORGM.44Can",
		"ORGM.45Can",
		"ORGM.223RemCan",
		"ORGM.45Can",
		"ORGM.380Can",
		"ORGM.9mmCan",
		"ORGM.12gCan",
		"ORGM.12gCan",
		"ORGM.762x54Can",
		"ORGM.45ColtCan",
		"ORGM.45ColtCan",
		"ORGM.50AECan",
		"ORGM.50AECan",
		"ORGM.12gCan",
		"ORGM.3030Can",
		"ORGM.3030Can",
		"ORGM.40Can",
		"ORGM.45Can",
		"ORGM.3006Can",
		"ORGM.762x51Can",
		"ORGM.357Can",
		"ORGM.45Can",
		};
		
	CWRCanTable2 = {
		"ORGM.10mmCan",
		"ORGM.10mmCan",
		"ORGM.57Can",
		"ORGM.38SCan",
		"ORGM.38SCan",
		"ORGM.45ColtCan",
		"ORGM.38Can",
		"ORGM.44Can",
		"ORGM.38Can",
		"ORGM.44Can",
		"ORGM.10mmCan",
		"ORGM.762Can",
		"ORGM.762x51Can",
		"ORGM.762x51Can",
		"ORGM.762x51Can",
		"ORGM.3006Can",
		"ORGM.762x51Can",
		"ORGM.12gSlugCan",
		"ORGM.556Can",
		"ORGM.45Can",
		"ORGM.44Can",
		"ORGM.45Can",
		"ORGM.556Can",
		"ORGM.45Can",
		"ORGM.380Can",
		"ORGM.9mmCan",
		"ORGM.12gSlugCan",
		"ORGM.12gSlugCan",
		"ORGM.762x54Can",
		"ORGM.45ColtCan",
		"ORGM.45ColtCan",
		"ORGM.50AECan",
		"ORGM.50AECan",
		"ORGM.12gSlugCan",
		"ORGM.3030Can",
		"ORGM.3030Can",
		"ORGM.40Can",
		"ORGM.45Can",
		"ORGM.3006Can",
		"ORGM.308wCan",
		"ORGM.38Can",
		"ORGM.45Can",
		};
		
	CWRMagTable = {
		"ORGM.BrenTenMag",
		"ORGM.ColtDeltaMag",
		"ORGM.FN57Mag",
		"ORGM.Colt38SMag",
		"ORGM.Taurus38Mag",
		"ORGM.SpeedLoader4546",
		"ORGM.SpeedLoader3576",
		"ORGM.SpeedLoader446",
		"ORGM.SpeedLoader3576",
		"ORGM.SpeedLoader446",
		"ORGM.SpeedLoader10mm6",
		"ORGM.AKMMag",
		"ORGM.R25Mag",
		"ORGM.FNFALMag",
		"ORGM.HK91Mag",
		"",
		"ORGM.AIAW308Mag",
		"",
		"ORGM.HKSL8Mag",
		"ORGM.M1A1Mag",
		"ORGM.DEagleMag",
		"ORGM.Glock21Mag",
		"ORGM.STANAG223Mag",
		"ORGM.Mac10Mag",
		"ORGM.Mac11Mag",
		"ORGM.UziMag",
		"ORGM.M1216Mag",
		"ORGM.VEPR12Mag",
		"ORGM.SVDMag",
		"",
		"",
		"ORGM.DEagleXIXMag",
		"ORGM.AutomagVMag",
		"",
		"",
		"ORGM.Rem788Mag",
		"ORGM.CZ75Mag",
		"ORGM.HKMK23Mag",
		"ORGM.M1903StripperClip",
		"ORGM.LENo4Mag",
		"",
		"ORGM.SpeedLoader456",
		};
		
	CivWepTableSuperRare = {
		"ORGM.AKMA",
		"ORGM.FNFALA",
		"ORGM.HKG3",
		"ORGM.KrissA",	
		"ORGM.SIG550",	
		"ORGM.SIG551",
		"ORGM.Skorpion",
		"ORGM.Glock18",
		"ORGM.Ber93R",
		"ORGM.Win1887",
		"ORGM.AM180",			
		};
		
	CWSRAmmoTable = {
		"ORGM.762Rounds",
		"ORGM.762x51Rounds",
		"ORGM.762x51Rounds",
		"ORGM.45Rounds",
		"ORGM.556Rounds",
		"ORGM.556Rounds",
		"ORGM.32Rounds",
		"ORGM.9mmRounds",
		"ORGM.9mmRounds",
		"ORGM.12gRounds",
		"ORGM.22Rounds",
		};
		
	CWSRAmmoTable2 = {
		"ORGM.762Rounds",
		"ORGM.308Rounds",
		"ORGM.308Rounds",
		"ORGM.45Rounds",
		"ORGM.223Rounds",
		"ORGM.223Rounds",
		"ORGM.32Rounds",
		"ORGM.9mmRounds",
		"ORGM.9mmRounds",
		"ORGM.12gSlugRounds",
		"ORGM.22Rounds",
		};
		
	CWSRBoxTable = {
		"ORGM.762Box",
		"ORGM.762x51Box",
		"ORGM.762x51Box",
		"ORGM.45Box",
		"ORGM.556Box",
		"ORGM.556Box",
		"ORGM.32Box",
		"ORGM.9mmBox",
		"ORGM.9mmBox",
		"ORGM.12gBox",
		"ORGM.22Box",
		};
		
	CWSRBoxTable2 = {
		"ORGM.762Box",
		"ORGM.308wBox",
		"ORGM.308wBox",
		"ORGM.45Box",
		"ORGM.223RemBox",
		"ORGM.223RemBox",
		"ORGM.32Box",
		"ORGM.9mmBox",
		"ORGM.9mmBox",
		"ORGM.12gSlugBox",
		"ORGM.22Box",
		};
		
	CWSRCanTable = {
		"ORGM.762Can",
		"ORGM.762x51Can",
		"ORGM.762x51Can",
		"ORGM.45Can",
		"ORGM.556Can",
		"ORGM.556Can",
		"ORGM.32Can",
		"ORGM.9mmCan",
		"ORGM.9mmCan",
		"ORGM.12gCan",
		"ORGM.22Can",
		};
	
	CWSRCanTable = {
		"ORGM.762Can",
		"ORGM.308wCan",
		"ORGM.308wCan",
		"ORGM.45Can",
		"ORGM.223RemCan",
		"ORGM.223RemCan",
		"ORGM.32Can",
		"ORGM.9mmCan",
		"ORGM.9mmCan",
		"ORGM.12gSlugCan",
		"ORGM.22Can",
		};
		
	CWSRMagTable = {
		"ORGM.AKMMag",
		"ORGM.FNFALAMag",
		"ORGM.HKG3Mag",
		"ORGM.Glock21Mag",
		"ORGM.SIG550Mag",
		"ORGM.SIG550Mag",
		"ORGM.SkorpionMag",
		"ORGM.Glock17Mag",
		"ORGM.Ber93RMag",
		"ORGM.AM180Mag",
		"",
		};

	CivSGTable = {
		"ORGM.Ithaca37",
		"ORGM.Ithaca37SO",
		"ORGM.Moss590",
		"ORGM.Moss590SO",
		"ORGM.Rem870",
		"ORGM.Rem870SO",
		"ORGM.Silverhawk",
		"ORGM.SilverHawkSO",
		"ORGM.Stevens320",
		"ORGM.Hawk982",
		};
	
	PolWepTableCom = {
		"ORGM.Ber92",
		"ORGM.BenelliM3",
		"ORGM.Rem870",
		};
	
	PWCAmmoTable = {
		"ORGM.9mmRounds",
		"ORGM.12gRounds",
		"ORGM.12gRounds",
		};
		
	PWCAmmoTable2 = {
		"ORGM.9mmRounds",
		"ORGM.12gSlugRounds",
		"ORGM.12gSlugRounds",
		};
		
	PWCBoxTable = {
		"ORGM.9mmBox",
		"ORGM.12gBox",
		"ORGM.12gBox",
		};
		
	PWCBoxTable2 = {
		"ORGM.9mmBox",
		"ORGM.12gSlugBox",
		"ORGM.12gSlugBox",
		};
		
	PWCCanTable = {
		"ORGM.9mmCan",
		"ORGM.12gCan",
		"ORGM.12gCan",
		};
		
	PWCCanTable2 = {
		"ORGM.9mmCan",
		"ORGM.12gSlugCan",
		"ORGM.12gSlugCan",
		};
		
	PWCMagTable = {
		"ORGM.Ber92Mag",
		"",
		"",
		};
		
	PolWepTableRare = {
		"ORGM.FN57",
		"ORGM.AR10",
		"ORGM.M16",
		"ORGM.M21",
		"ORGM.M4C",
		"ORGM.Rem700",
		"ORGM.Mini14",
		"ORGM.AIAW308",
		"ORGM.Spas12",
		"ORGM.HKMP5",
		"ORGM.HKUMP",
		"ORGM.FNP90",
		"ORGM.Striker",
		};
	
	PWRAmmoTable = {
		"ORGM.57Rounds",
		"ORGM.762x51Rounds",
		"ORGM.556Rounds",
		"ORGM.762x51Rounds",
		"ORGM.556Rounds",
		"ORGM.3006Rounds",
		"ORGM.223Rounds",
		"ORGM.308Rounds",
		"ORGM.12gRounds",
		"ORGM.9mmRounds",
		"ORGM.45Rounds",
		"ORGM.57Rounds",
		"ORGM.12gRounds",
		};
		
	PWRAmmoTable2 = {
		"ORGM.57Rounds",
		"ORGM.308Rounds",
		"ORGM.223Rounds",
		"ORGM.308Rounds",
		"ORGM.223Rounds",
		"ORGM.3006Rounds",
		"ORGM.556Rounds",
		"ORGM.762x51Rounds",
		"ORGM.12gSlugRounds",
		"ORGM.9mmRounds",
		"ORGM.45Rounds",
		"ORGM.57Rounds",
		"ORGM.12gSlugRounds",
		};
		
	PWRBoxTable = {
		"ORGM.57Box",
		"ORGM.762x51Box",
		"ORGM.556Box",
		"ORGM.762x51Box",
		"ORGM.556Box",
		"ORGM.3006Box",
		"ORGM.223RemBox",
		"ORGM.308wBox",
		"ORGM.12gBox",
		"ORGM.9mmBox",
		"ORGM.45Box",
		"ORGM.57Box",
		"ORGM.12gBox",
		};
		
	PWRBoxTable2 = {
		"ORGM.57Box",
		"ORGM.308wBox",
		"ORGM.223RemBox",
		"ORGM.308wBox",
		"ORGM.223RemBox",
		"ORGM.3006Box",
		"ORGM.556RemBox",
		"ORGM.762x51Box",
		"ORGM.12gSlugBox",
		"ORGM.9mmBox",
		"ORGM.45Box",
		"ORGM.57Box",
		"ORGM.12gSlugBox",
		};
		
	PWRCanTable = {
		"ORGM.57Can",
		"ORGM.762x51Can",
		"ORGM.556Can",
		"ORGM.762x51Can",
		"ORGM.556Can",
		"ORGM.3006Can",
		"ORGM.223RemCan",
		"ORGM.308wCan",
		"ORGM.12gCan",
		"ORGM.9mmCan",
		"ORGM.45Can",
		"ORGM.57Can",
		"ORGM.12gCan",
		};
		
	PWRCanTable2 = {
		"ORGM.57Can",
		"ORGM.308wCan",
		"ORGM.223RemCan",
		"ORGM.308wCan",
		"ORGM.223RemCan",
		"ORGM.3006Can",
		"ORGM.556Can",
		"ORGM.762x51Can",
		"ORGM.12gSlugCan",
		"ORGM.9mmCan",
		"ORGM.45Can",
		"ORGM.57Can",
		"ORGM.12gSlugCan",
		};
		
	PWRMagTable = {
		"ORGM.FN57Mag",
		"ORGM.AR10Mag",
		"ORGM.STANAGMag",
		"ORGM.M21Mag",
		"ORGM.STANAGMag",
		"",
		"ORGM.Mini14Mag",
		"ORGM.AIAW308Mag",
		"",
		"ORGM.HKMP5Mag",
		"ORGM.HKUMPMag",
		"ORGM.FNP90Mag",
		"",
		};
	
	MilWepTableCom = {
		"ORGM.Ber92",
		"ORGM.M1911",
		"ORGM.M16",
		"ORGM.M4C",
		"ORGM.BenelliXM1014",
		"ORGM.HKMP5",
		"ORGM.HKUMP",
		"ORGM.SR25",
		};
		
	MWCAmmoTable = {
		"ORGM.9mmRounds",
		"ORGM.45Rounds",
		"ORGM.556Rounds",
		"ORGM.556Rounds",
		"ORGM.12gRounds",
		"ORGM.9mmRounds",
		"ORGM.45Rounds",
		"ORGM.762x51Rounds",
		};
		
	MWCAmmoTable2 = {
		"ORGM.9mmRounds",
		"ORGM.45Rounds",
		"ORGM.223Rounds",
		"ORGM.223Rounds",
		"ORGM.12gSlugRounds",
		"ORGM.9mmRounds",
		"ORGM.45Rounds",
		"ORGM.308Rounds",
		};

	MWCBoxTable = {
		"ORGM.9mmBox",
		"ORGM.45Box",
		"ORGM.556Box",
		"ORGM.556Box",
		"ORGM.12gBox",
		"ORGM.9mmBox",
		"ORGM.45Box",
		"ORGM.762x51Box",
		};
		
	MWCBoxTable2 = {
		"ORGM.9mmBox",
		"ORGM.45Box",
		"ORGM.223RemBox",
		"ORGM.223RemBox",
		"ORGM.12gSlugBox",
		"ORGM.9mmBox",
		"ORGM.45Box",
		"ORGM.308wBox",
		};
		
	MWCCanTable = {
		"ORGM.9mmCan",
		"ORGM.45Can",
		"ORGM.556Can",
		"ORGM.556Can",
		"ORGM.12gCan",
		"ORGM.9mmCan",
		"ORGM.45Can",
		"ORGM.762x51Can",
		};
		
	MWCCanTable2 = {
		"ORGM.9mmCan",
		"ORGM.45Can",
		"ORGM.223RemCan",
		"ORGM.223RemCan",
		"ORGM.12gSlugCan",
		"ORGM.9mmCan",
		"ORGM.45Can",
		"ORGM.308wCan",
		};
		
	MWCMagTable = {
		"ORGM.Ber92Mag",
		"ORGM.M1911Mag",
		"ORGM.STANAGMag",
		"ORGM.STANAGMag",
		"",
		"ORGM.HKMP5Mag",
		"ORGM.HKUMPMag",
		"ORGM.SR25Mag",
		};
		
	MilWepTableRare = {
		"ORGM.FN57",
		"ORGM.SIGP226",
		"ORGM.M21",
		"ORGM.WinM70",
		"ORGM.AIAW308",
		"ORGM.Spas12",
		"ORGM.FNP90",
		"ORGM.SA80",
		"ORGM.M249",
		};
		
	MWRAmmoTable = {
		"ORGM.57Rounds",
		"ORGM.40Rounds",
		"ORGM.762x51Rounds",
		"ORGM.3006Rounds",
		"ORGM.308Rounds",
		"ORGM.12gRounds",
		"ORGM.57Rounds",
		"ORGM.556Rounds",
		"ORGM.556Rounds",
		};
		
	MWRAmmoTable2 = {
		"ORGM.57Rounds",
		"ORGM.40Rounds",
		"ORGM.308Rounds",
		"ORGM.3006Rounds",
		"ORGM.762x51Rounds",
		"ORGM.12gSlugRounds",
		"ORGM.57Rounds",
		"ORGM.223Rounds",
		"ORGM.223Rounds",
		};
		
	MWRBoxTable = {
		"ORGM.57Box",
		"ORGM.9mmBox",
		"ORGM.762x51Box",
		"ORGM.3006Box",
		"ORGM.308wBox",
		"ORGM.12gBox",
		"ORGM.57Box",
		"ORGM.556Box",
		"ORGM.556Box",
		};
		
	MWRBoxTable2 = {
		"ORGM.57Box",
		"ORGM.9mmBox",
		"ORGM.308wBox",
		"ORGM.3006Box",
		"ORGM.762x51Box",
		"ORGM.12gSlugBox",
		"ORGM.57Box",
		"ORGM.223RemBox",
		"ORGM.223RemBox",
		};
		
	MWRCanTable = {
		"ORGM.57Can",
		"ORGM.9mmCan",
		"ORGM.762x51Can",
		"ORGM.3006Can",
		"ORGM.308wCan",
		"ORGM.12gCan",
		"ORGM.57Can",
		"ORGM.556Can",
		"ORGM.556Can",
		};
		
	MWRCanTable = {
		"ORGM.57Can",
		"ORGM.9mmCan",
		"ORGM.308wCan",
		"ORGM.3006Can",
		"ORGM.762x51Can",
		"ORGM.12gSlugCan",
		"ORGM.57Can",
		"ORGM.223RemCan",
		"ORGM.223RemCan",
		};
		
	MWRMagTable = {
		"ORGM.FN57Mag",
		"ORGM.SIGP226Mag",
		"ORGM.M21Mag",
		"",
		"ORGM.AIAW308Mag",
		"",
		"ORGM.FNP90Mag",
		"ORGM.STANAGMag",
		"ORGM.M249Belt",
		};
		
	AllRoundsTable = {
		"ORGM.762Rounds",
		"ORGM.9mmRounds",
		"ORGM.12gRounds",
		"ORGM.12gSlugRounds",
		"ORGM.22Rounds",
		"ORGM.38Rounds",
		"ORGM.40Rounds",
		"ORGM.44Rounds",
		"ORGM.45Rounds",
		"ORGM.38SRounds",
		"ORGM.357Rounds",
		"ORGM.223Rounds",
		"ORGM.3006Rounds",
		"ORGM.3030Rounds",
		"ORGM.308Rounds",
		"ORGM.454Rounds",
		"ORGM.BBsRounds",
		"ORGM.57Rounds",
		"ORGM.10mmRounds",
		"ORGM.762x51Rounds",
		"ORGM.762x54Rounds",
		"ORGM.556Rounds",
		"ORGM.380Rounds",
		"ORGM.45ColtRounds",
		"ORGM.50AERounds",
		};
		
	AllBoxTable = {
		"ORGM.762Box",
		"ORGM.9mmBox",
		"ORGM.12gBox",
		"ORGM.12gSlugBox",
		"ORGM.22Box",
		"ORGM.38Box",
		"ORGM.40Box",
		"ORGM.44Box",
		"ORGM.45Box",
		"ORGM.38SBox",
		"ORGM.357Box",
		"ORGM.223RemBox",
		"ORGM.3006Box",
		"ORGM.3030Box",
		"ORGM.308wBox",
		"ORGM.454Box",
		"ORGM.BBCan",
		"ORGM.57Box",
		"ORGM.10mmBox",
		"ORGM.762x51Box",
		"ORGM.762x54Box",
		"ORGM.556Box",
		"ORGM.380Box",
		"ORGM.45ColtBox",
		"ORGM.50AEBox",
		};
		
	AllCanTable = {
		"ORGM.762Can",
		"ORGM.9mmCan",
		"ORGM.12gCan",
		"ORGM.12gSlugCan",
		"ORGM.22Can",
		"ORGM.38Can",
		"ORGM.40Can",
		"ORGM.44Can",
		"ORGM.45Can",
		"ORGM.38SCan",
		"ORGM.357Can",
		"ORGM.223RemCan",
		"ORGM.3006Can",
		"ORGM.3030Can",
		"ORGM.308wCan",
		"ORGM.454Can",
		"ORGM.57Can",
		"ORGM.10mmCan",
		"ORGM.762x51Can",
		"ORGM.762x54Can",
		"ORGM.556Can",
		"ORGM.380Can",
		"ORGM.45ColtCan",
		"ORGM.50AECan",
		};
		
	CivModTable = {
		"ORGM.2xScope",
		"ORGM.8xScope",
		"ORGM.FibSig",
		"ORGM.FullCh",
		"ORGM.HalfCh",
		"ORGM.PistolLas",
		"ORGM.PistolTL",
		"ORGM.RDS",
		"ORGM.Recoil",
		"ORGM.Rifsling",
		"ORGM.SkeletalStock",
		"ORGM.CollapsingStock",
		};
		
	NonCivModTable = {
		"ORGM.4xScope",
		"ORGM.8xScope",
		"ORGM.FibSig",
		"ORGM.Reflex",
		"ORGM.RifleLas",
		"ORGM.PistolLas",
		"ORGM.PistolTL",
		"ORGM.RDS",
		"ORGM.RifleTL",
		"ORGM.Rifsling",
		"ORGM.Foregrip",
		"ORGM.SkeletalStock",
		"ORGM.CollapsingStock",
		};
		
	RepairTable = {
		"ORGM.WD40",
		"ORGM.Brushkit",
		"ORGM.Maintkit",
		};
		
function rnd(_value)
	return ZombRand(_value) + 1;
end

Events.OnFillContainer.Add(ORGMDistr);

WeaponUpgrades = {

   	Ber92 = { 

		"ORGM.FibSig",

	};

   	BrenTen = { 

		"ORGM.FibSig",

	};

   	BrownHP = { 

		"ORGM.FibSig",

	};


   	ColtDelta = { 

		"ORGM.FibSig",

	};


   	Glock20 = { 

		"ORGM.FibSig",

	};


   	FN57 = { 

		"ORGM.FibSig",

	};

   	Glock17 = { 

		"ORGM.FibSig",

	};

   	WaltherPPK = { 

		"ORGM.FibSig",

	};

   	Glock22 = { 

		"ORGM.FibSig",

	};

   	Glock21 = { 

		"ORGM.FibSig",

	};

   	M1911 = { 

		"ORGM.FibSig",

	};

   	RugerMKII = { 

		"ORGM.FibSig",

	};

   	SIGP226 = { 

		"ORGM.FibSig",

	};

   	WaltherP22 = { 

		"ORGM.FibSig",

	};

   	Colt38S = { 

		"ORGM.FibSig",

	};

   	Taurus38 = { 

		"ORGM.FibSig",

	};

   	DEagle = { 

		"ORGM.FibSig",

	};

   	DEagleXIX = { 

		"ORGM.FibSig",

	};

   	AutomagV = { 

		"ORGM.FibSig",

	};

   	XD40 = { 

		"ORGM.FibSig",

	};
	
	Glock18 = { 

		"ORGM.FibSig",

	};
	
	Ber93R = { 

		"ORGM.FibSig",

	};
	
	CZ75 = { 

		"ORGM.FibSig",

	};
	
	KTP32 = { 

		"ORGM.FibSig",

	};
	
	TaurusP132 = { 

		"ORGM.FibSig",

	};
	
	SPR19119 = { 

		"ORGM.FibSig",

	};

   	RugerSR9 = { 

		"ORGM.FibSig",

	};

   	KahrCT40 = { 

		"ORGM.FibSig",

	};

   	KahrP380 = { 

		"ORGM.FibSig",

	};

   	ColtAnac = { 

		"ORGM.2xScope",

	};

   	RugRH = { 

		"ORGM.2xScope",

	};

   	SWM29 = { 

		"ORGM.2xScope",

	};

   	Taurus454 = { 

		"ORGM.2xScope",

	};

   	HKMP5 = { 

		"ORGM.Foregrip",

	};

   	HKUMP = { 

		"ORGM.Foregrip",

	};

   	Kriss = { 

		"ORGM.Foregrip",

	};
	
   	KrissA = { 

		"ORGM.Foregrip",

	};

   	AKM = { 

		"ORGM.Rifsling",

	};
	
   	AKMA = { 

		"ORGM.Rifsling",

	};


   	AR10= { 

		"ORGM.Rifsling",

	};


   	AR15 = { 

		"ORGM.Rifsling",

	};
	
	SIG550 = { 

		"ORGM.Rifsling",

	};
	
	SIG551 = { 

		"ORGM.Rifsling",

	};

	M249 = { 

		"ORGM.Rifsling",

	};

   	FNFAL = { 

		"ORGM.Rifsling",

	};
	
   	FNFALA = { 

		"ORGM.Rifsling",

	};

   	HK91 = { 

		"ORGM.Rifsling",

	};

   	HKG3 = { 

		"ORGM.Rifsling",

	};

   	Garand = { 

		"ORGM.Rifsling",

	};


   	M16 = { 

		"ORGM.Rifsling",

	};

   	Rug1022 = { 

		"ORGM.Rifsling",

	};
	
   	Marlin60 = { 

		"ORGM.Rifsling",

	};

   	Mini14 = { 

		"ORGM.Rifsling",

	};

   	SKS = { 

		"ORGM.Rifsling",

	};

   	M21 = { 

		"ORGM.Rifsling",
		"ORGM.8xScope",

	};

   	Rem700 = { 

		"ORGM.Rifsling",
		"ORGM.8xScope",

	};

   	BLR = { 

		"ORGM.Rifsling",

	};

   	HenryBB = { 

		"ORGM.Rifsling",

	};
	
   	WinM94 = { 

		"ORGM.Rifsling",

	};

   	Mosin = { 

		"ORGM.Rifsling",

	};

   	SA80 = { 

		"ORGM.Rifsling",

	};

   	HKSL8 = { 

		"ORGM.Rifsling",

	};
	
   	LENo4 = { 

		"ORGM.Rifsling",

	};

   	WinM70 = { 

		"ORGM.Rifsling",
		"ORGM.8xScope",

	};
	
	Rem788 = { 

		"ORGM.Rifsling",
		"ORGM.8xScope",

	};
	
	SR25 = { 

		"ORGM.Rifsling",
		"ORGM.8xScope",

	};

   	AIAW308 = { 

		"ORGM.Rifsling",
		"ORGM.8xScope",

	};

   	SVD = { 

		"ORGM.Rifsling",
		"ORGM.8xScope",

	};
	
   	M1903 = { 

		"ORGM.Rifsling",
		"ORGM.8xScope",

	};

   	M4C = { 

		"ORGM.Rifsling",

	};

   	BenelliM3 = { 

		"ORGM.Rifsling",
		"ORGM.FullCh",
		"ORGM.HalfCh",

	};

   	Ithaca37 = { 

		"ORGM.Rifsling",
		"ORGM.FullCh",
		"ORGM.HalfCh",

	};

   	Moss590 = { 

		"ORGM.Rifsling",
		"ORGM.FullCh",
		"ORGM.HalfCh",

	};

   	Rem870 = { 

		"ORGM.Rifsling",
		"ORGM.FullCh",
		"ORGM.HalfCh",

	};

   	Silverhawk = { 

		"ORGM.Rifsling",
		"ORGM.FullCh",
		"ORGM.HalfCh",

	};

   	Spas12 = { 

		"ORGM.Rifsling",
		"ORGM.FullCh",
		"ORGM.HalfCh",

	};

   	Stevens320 = { 

		"ORGM.Rifsling",
		"ORGM.FullCh",
		"ORGM.HalfCh",

	};

   	Vepr12 = { 

		"ORGM.Rifsling",
		"ORGM.FullCh",
		"ORGM.HalfCh",

	};

   	M1216 = { 

		"ORGM.Rifsling",
		"ORGM.FullCh",
		"ORGM.HalfCh",

	};
	
   	Hawk982 = { 

		"ORGM.Rifsling",
		"ORGM.FullCh",
		"ORGM.HalfCh",

	};
	
   	Win1887 = { 

		"ORGM.Rifsling",
		"ORGM.FullCh",
		"ORGM.HalfCh",

	};
	
   	Striker = { 

		"ORGM.FullCh",
		"ORGM.HalfCh",

	};

};