FlashlightFix = {};
FlashlightFix.onKeyPressed = function(key)
    local Player = getSpecificPlayer(0);
    if key == getCore():getKey("Equip/Turn On/Off Light Source") then
        local Item = Player:getPrimaryHandItem();
        if (instanceof(Item, "HandWeapon") and Item:getCondition() > 0) and Item:getCanon() then
            if Item:getCanon():getName() == "Pistol Tactical Light" then
                if not Item:isActivated() then
                    Item:setTorchCone(true);
                    Item:setLightStrength(0.6);
                    Item:setLightDistance(15);
                    Item:setActivated(true);
                else
                    Item:setTorchCone(true);
                    Item:setLightStrength(0);
                    Item:setLightDistance(0);
                    Item:setActivated(false);
                end
            end
            if Item:getCanon():getName() == "Rifle Tactical Light" then
                if not Item:isActivated() then
                    Item:setTorchCone(true);
                    Item:setLightStrength(0.7);
                    Item:setLightDistance(18);
                    Item:setActivated(true);
                else
                    Item:setTorchCone(true);
                    Item:setLightStrength(0);
                    Item:setLightDistance(0);
                    Item:setActivated(false);
                end
            end
        end
    end
end
Events.OnKeyPressed.Add(FlashlightFix.onKeyPressed);