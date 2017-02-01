require 'ISUI/ISToolTipInv'

ORGMTooltip = {} --initializing the script, nothing to see here

ORGMTooltip.ISToolTipInvRender = ISToolTipInv.render;

function ISToolTipInv:render()
	
	local mD = self.item:getModData() -- gets the item's mod data
	local sTest = mD.shootSound
	local nCC = mD.currentCapacity -- gets the gun's current capacity
	
	local text = nil; -- setup the text for the tooltip
	if sTest == "none" and nCC ~= nil then -- Weapon types already get the ammo count, so, if it isnt a weapon and has ammo, continue
		nMC = mD.maxCapacity -- gets the gun's max capacity
		nRC = mD.roundChambered -- checks to see if a round is chambered
		if nCC ~= nil and nMC ~= nil and nRC ~= nil then -- make sure the values are actually there
			text = "Ammo Count:   "..nCC.." + "..nRC.." / "..nMC -- sets the capacity tooltip text with round chambered text
		elseif nCC ~= nil and nMC ~= nil then -- make sure the values are actually there
			text = "Ammo Count:   "..nCC.." / "..nMC -- sets the capacity tooltip text
		end
	end
	
	if text ~= nil then -- if the text is there
		self.item:setTooltip(text); -- do it!
	end
	
	ORGMTooltip.ISToolTipInvRender(self);
end