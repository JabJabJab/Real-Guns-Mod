local EquipWeapon = function(item, player)
    -- can probably skip 2 hand check, looks like its done automatically anyways
    if(item:isTwoHandWeapon() or item:isRequiresEquippedBothHands()) then 
        ISTimedActionQueue.add(ISEquipWeaponAction:new(player, item, 0, true, true))
    else
        ISTimedActionQueue.add(ISEquipWeaponAction:new(player, item, 0, true, false))
    end
end

function ORGMFireModeChange_OnCreate(items, result, player, selectedItem)
    local data = selectedItem:getModData()
    
    
    ReloadUtil:syncItemToReloadable(result, player)
    newdata = result:getModData()
    newdata.roundChambered = data.roundChambered
    newdata.containsClip = data.containsClip
    newdata.currentCapacity = data.currentCapacity

    if instanceof(result, "HandWeapon") then
        result:setCondition(selectedItem:getCondition())
        result:attachWeaponPart(selectedItem:getScope())
        result:attachWeaponPart(selectedItem:getClip())
        result:attachWeaponPart(selectedItem:getSling())
        result:attachWeaponPart(selectedItem:getCanon())
        result:attachWeaponPart(selectedItem:getStock())
        result:attachWeaponPart(selectedItem:getRecoilpad())
    end
    EquipWeapon(result, player)
    -- this part is not properly working, possibly due to recipe items going into inventory first?
    --[[
    if player:getPrimaryHandItem() and player:getPrimaryHandItem() == selectedItem then
        local twohand = false
        if(selectedItem:isTwoHandWeapon() or selectedItem:isRequiresEquippedBothHands()) then twohand = true end
        ISTimedActionQueue.add(ISEquipWeaponAction:new(player, result, 0, true, twohand))
    elseif player:getSecondaryHandItem() and player:getSecondaryHandItem() == selectedItem then
        ISTimedActionQueue.add(ISEquipWeaponAction:new(player, result, 0, false, false))
    end
    ]]
end

-- cheap wrapper to separate the functions for later code changes
ORGMActionModeChange_OnCreate = ORGMFireModeChange_OnCreate
