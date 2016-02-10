require "TimedActions/ISBaseTimedAction"

ORGMConvertAction2 = ISBaseTimedAction:derive("ORGMConvertAction2")

function ORGMConvertAction2:perform()
	convertitem = ORGMConversions2.convertitem
	convertData = convertitem:getModData()
	resultitem = ORGMConversions2.resultitem
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
			itemData.roundChambered = convertData.roundChambered;
			itemData.currentCapacity = convertData.currentCapacity;
			newItem:setCondition(convertcondition);
			newItem:attachWeaponPart(convertitem:getScope())
			newItem:attachWeaponPart(convertitem:getClip())
			newItem:attachWeaponPart(convertitem:getSling())
			newItem:attachWeaponPart(convertitem:getCanon())
			newItem:attachWeaponPart(convertitem:getStock())
			newItem:attachWeaponPart(convertitem:getRecoilpad())
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

function ORGMConvertAction2:start()

end

function ORGMConvertAction2:isValid()
	return true
end

function ORGMConvertAction2:new(convertManager, char, time)
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