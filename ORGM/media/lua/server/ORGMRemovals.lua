require 'Items/SuburbsDistributions'

for i,v in pairs(SuburbsDistributions) do
	if v.items ~= nil then
		local k=1;
		while k <= #v.items do
			if v.items[k] == "Base.Pistol" then 
				table.remove(v.items, k);
				table.remove(v.items, k);
			elseif v.items[k] == "Base.Shotgun" then
				table.remove(v.items, k);
				table.remove(v.items, k);
			elseif v.items[k] == "Base.Sawnoff" then
				table.remove(v.items, k);
				table.remove(v.items, k);
			elseif v.items[k] == "Base.VarmintRifle" then
				table.remove(v.items, k);
				table.remove(v.items, k);
			elseif v.items[k] == "Base.HuntingRifle" then
				table.remove(v.items, k);
				table.remove(v.items, k);
			elseif v.items[k] == "Base.Bullets9mm" then
				table.remove(v.items, k);
				table.remove(v.items, k);
			elseif v.items[k] == "Base.ShotgunShells" then
				table.remove(v.items, k);
				table.remove(v.items, k);
			elseif v.items[k] == "Base.223Bullets" then
				table.remove(v.items, k);
				table.remove(v.items, k);
			elseif v.items[k] == "Base.308Bullets" then
				table.remove(v.items, k);
				table.remove(v.items, k);
			elseif v.items[k] == "Base.BulletsBox" then
				table.remove(v.items, k);
				table.remove(v.items, k);
			elseif v.items[k] == "Base.ShotgunShellsBox" then
				table.remove(v.items, k);
				table.remove(v.items, k);
			elseif v.items[k] == "Base.223Box" then
				table.remove(v.items, k);
				table.remove(v.items, k);
			elseif v.items[k] == "Base.308Box" then
				table.remove(v.items, k);
				table.remove(v.items, k);
			elseif v.items[k] == "Base.HuntingRifleExtraClip" then
				table.remove(v.items, k);
				table.remove(v.items, k);
			elseif v.items[k] == "Base.IronSight" then
				table.remove(v.items, k);
				table.remove(v.items, k);
			elseif v.items[k] == "Base.x2Scope" then
				table.remove(v.items, k);
				table.remove(v.items, k);
			elseif v.items[k] == "Base.x4Scope" then
				table.remove(v.items, k);
				table.remove(v.items, k);
			elseif v.items[k] == "Base.x8Scope" then
				table.remove(v.items, k);
				table.remove(v.items, k);
			elseif v.items[k] == "Base.AmmoStraps" then
				table.remove(v.items, k);
				table.remove(v.items, k);
			elseif v.items[k] == "Base.Sling" then
				table.remove(v.items, k);
				table.remove(v.items, k);
			elseif v.items[k] == "Base.FiberglassStock" then
				table.remove(v.items, k);
				table.remove(v.items, k);
			elseif v.items[k] == "Base.RecoilPad" then
				table.remove(v.items, k);
				table.remove(v.items, k);
			elseif v.items[k] == "Base.Laser" then
				table.remove(v.items, k);
				table.remove(v.items, k);
			elseif v.items[k] == "Base.RedDot" then
				table.remove(v.items, k);
				table.remove(v.items, k);
			elseif v.items[k] == "Base.ChokeTubeFull" then
				table.remove(v.items, k);
				table.remove(v.items, k);
			elseif v.items[k] == "Base.ChokeTubeImproved" then
				table.remove(v.items, k);
				table.remove(v.items, k);
			else
				k = k + 1;
			end
		end
	else
		for i2, v2 in pairs(v) do
			if v2.items ~= nil then
				local k=1;
				while k <= #v2.items do
					if v2.items[k] == "Base.Pistol" then 
						table.remove(v2.items, k);
						table.remove(v2.items, k);
					elseif v2.items[k] == "Base.Shotgun" then
						table.remove(v2.items, k);
						table.remove(v2.items, k);
					elseif v2.items[k] == "Base.Sawnoff" then
						table.remove(v2.items, k);
						table.remove(v2.items, k);
					elseif v2.items[k] == "Base.VarmintRifle" then
						table.remove(v2.items, k);
						table.remove(v2.items, k);
					elseif v2.items[k] == "Base.HuntingRifle" then
						table.remove(v2.items, k);
						table.remove(v2.items, k);
					elseif v2.items[k] == "Base.Bullets9mm" then
						table.remove(v2.items, k);
						table.remove(v2.items, k);
					elseif v2.items[k] == "Base.ShotgunShells" then
						table.remove(v2.items, k);
						table.remove(v2.items, k);
					elseif v2.items[k] == "Base.223Bullets" then
						table.remove(v2.items, k);
						table.remove(v2.items, k);
					elseif v2.items[k] == "Base.308Bullets" then
						table.remove(v2.items, k);
						table.remove(v2.items, k);
					elseif v2.items[k] == "Base.BulletsBox" then
						table.remove(v2.items, k);
						table.remove(v2.items, k);
					elseif v2.items[k] == "Base.ShotgunShellsBox" then
						table.remove(v2.items, k);
						table.remove(v2.items, k);
					elseif v2.items[k] == "Base.223Box" then
						table.remove(v2.items, k);
						table.remove(v2.items, k);
					elseif v2.items[k] == "Base.308Box" then
						table.remove(v2.items, k);
						table.remove(v2.items, k);
					elseif v2.items[k] == "Base.HuntingRifleExtraClip" then
						table.remove(v2.items, k);
						table.remove(v2.items, k);
					elseif v2.items[k] == "Base.IronSight" then
						table.remove(v2.items, k);
						table.remove(v2.items, k);
					elseif v2.items[k] == "Base.x2Scope" then
						table.remove(v2.items, k);
						table.remove(v2.items, k);
					elseif v2.items[k] == "Base.x4Scope" then
						table.remove(v2.items, k);
						table.remove(v2.items, k);
					elseif v2.items[k] == "Base.x8Scope" then
						table.remove(v2.items, k);
						table.remove(v2.items, k);
					elseif v2.items[k] == "Base.AmmoStraps" then
						table.remove(v2.items, k);
						table.remove(v2.items, k);
					elseif v2.items[k] == "Base.Sling" then
						table.remove(v2.items, k);
						table.remove(v2.items, k);
					elseif v2.items[k] == "Base.FiberglassStock" then
						table.remove(v2.items, k);
						table.remove(v2.items, k);
					elseif v2.items[k] == "Base.RecoilPad" then
						table.remove(v2.items, k);
						table.remove(v2.items, k);
					elseif v2.items[k] == "Base.Laser" then
						table.remove(v2.items, k);
						table.remove(v2.items, k);
					elseif v2.items[k] == "Base.RedDot" then
						table.remove(v2.items, k);
						table.remove(v2.items, k);
					elseif v2.items[k] == "Base.ChokeTubeFull" then
						table.remove(v2.items, k);
						table.remove(v2.items, k);
					elseif v2.items[k] == "Base.ChokeTubeImproved" then
						table.remove(v2.items, k);
						table.remove(v2.items, k);
					else
						k = k + 1;
					end
				end
			end
		end
	end
end
