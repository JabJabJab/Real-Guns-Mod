require "TimedActions/ISBaseTimedAction"

ORGMConvertAction = ISBaseTimedAction:derive("ORGMConvertAction")

function ORGMConvertAction:perform()
	convertitem = ORGMConversions.convertitem
	convertData = convertitem:getModData()
	resultitem = ORGMConversions.resultitem
	if convertData.currentCapacity ~= nil then
		curcap = convertData.currentCapacity
	else
		curcap = 0
	end
	if convertData.roundChambered ~= nil then
		roucha = convertData.roundChambered
	else
		roucha = 0
	end
	testcap = curcap + roucha
	if testcap ~=0 then
		if ReloadUtil:getClipData(convertData.ammoType) ~= nil then
		UnlRound = ReloadUtil:getClipData(convertData.ammoType).ammoType
		else
		UnlRound = convertData.ammoType
		end
		if roucha ~= 0 then
			convertData.roundChambered = 0
		else
			convertData.currentCapacity = convertData.currentCapacity - 1
		end
		getPlayer():getInventory():AddItem('ORGM.'..UnlRound);
		getPlayer():getXp():AddXP(Perks.Reloading, 1);
		ISBaseTimedAction.perform(self)
	else
		convertcondition = convertitem:getCondition()
		getPlayer():getInventory():Remove(convertitem);
		AddedItem = getPlayer():getInventory():AddItems('ORGM.'..resultitem, 1);
		if AddedItem then
			for i=0, AddedItem:size()-1 do 
				local newItem = AddedItem:get(i);
				ReloadUtil:syncItemToReloadable(newItem, getPlayer())
				itemData = newItem:getModData()
				if roucha == 0 then
					itemData.roundChambered = 0
				end
				itemData.containsClip = convertData.containsClip;
				if instanceof(newItem, "HandWeapon") then
					newItem:setCondition(convertcondition);
					newItem:attachWeaponPart(convertitem:getScope())
					newItem:attachWeaponPart(convertitem:getClip())
					newItem:attachWeaponPart(convertitem:getSling())
					newItem:attachWeaponPart(convertitem:getCanon())
					newItem:attachWeaponPart(convertitem:getStock())
					newItem:attachWeaponPart(convertitem:getRecoilpad())
				end
				local playobj = getPlayer()
				if playobj:getPrimaryHandItem() and playobj:getPrimaryHandItem() == convertitem then
					local twohand = false
					if(playobj:getPrimaryHandItem():isTwoHandWeapon() or playobj:getPrimaryHandItem():isRequiresEquippedBothHands()) then
						twohand = true
					else
						twohand = false
					end
					ISTimedActionQueue.add(ISEquipWeaponAction:new(playobj, newItem, 0, true, twohand))
				elseif playobj:getSecondaryHandItem() and playobj:getSecondaryHandItem() == convertitem then
					ISTimedActionQueue.add(ISEquipWeaponAction:new(playobj, newItem, 0, false, false))
				end
				ISBaseTimedAction.perform(self)
			end
		end
	end
end

function ORGMConvertAction:start()

end

function ORGMConvertAction:isValid()
	return true
end

function ORGMConvertAction:new(convertManager, char, time)
	local o = {}
	setmetatable(o, self)
    self.__index = self
	o.character = char
	o.stopOnWalk = false
	o.stopOnRun = true
	o.maxTime = time
	o.mgr = convertManager
    return o;
end