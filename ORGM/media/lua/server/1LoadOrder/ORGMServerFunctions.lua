
--[[ ORGM.itemBindingHandler(key)
    Triggerd by Events.OnKeyPressed, this overrides PZ's ItemBindingHandler.onKeyPressed function.
    It handles the new pistol/rifle/shotgun hotkeys, and bypasses equipping a light source if a equipped 
    gun has a tactical light.
    
]]
ORGM.itemBindingHandler = function(key)
	local weapon = nil;
	local playerObj = getSpecificPlayer(0)
    local remove = false;
    if playerObj and not playerObj:IsAiming() then
	-- looking for the better handweapon
		if key == getCore():getKey("Equip/Unequip Handweapon") then
            ORGM.equipBestMeleeWeapon(playerObj, "Swinging")
		elseif key == getCore():getKey("Equip/Unequip Firearm") then -- looking for the better firearm
            ORGM.equipBestFirearm(playerObj, nil)
            --ORGM.equipBestMeleeWeapon(playerObj, "Firearm")
		elseif key == getCore():getKey("Equip/Unequip Stab weapon") then 	-- looking for the better stab weapon
            ORGM.equipBestMeleeWeapon(playerObj, "Stab")

        elseif key == getCore():getKey("Equip/Unequip Pistol") then
            ORGM.equipBestFirearm(playerObj, "Pistol")
        elseif key == getCore():getKey("Equip/Unequip Rifle") then
            ORGM.equipBestFirearm(playerObj, "Rifle")
        elseif key == getCore():getKey("Equip/Unequip Shotgun") then
            ORGM.equipBestFirearm(playerObj, "Shotgun")

            
        elseif key == getCore():getKey("Equip/Turn On/Off Light Source") then
            if ORGM.toggleTacticalLight(playerObj) then return end -- handled by orgm
            
            local primary = playerObj:getPrimaryHandItem()
            local secondary = playerObj:getSecondaryHandItem()
			if primary ~= nil and primary:getLightStrength() > 0 then
				primary:setActivated(not primary:isActivated())
			elseif secondary ~= nil and secondary:getLightStrength() > 0 then
				secondary:setActivated(not secondary:isActivated())
			else
				local lightStrength = 0;
				local lightSource = nil;
				local it = playerObj:getInventory():getItems()
				for i=0, it:size() - 1 do
					local item = it:get(i);
					if item:getLightStrength() > lightStrength then
						lightSource = item;
						lightStrength = item:getLightStrength()
					end
				end
				if lightSource ~= nil then
					ISTimedActionQueue.add(ISEquipWeaponAction:new(playerObj, lightSource, 50, false));
					lightSource:setActivated(true);
				end
			end
		end
	end
end

--[[ ORGM.equipBestFirearm(playerObj, subCategory)
    equips the best firearm overriding the default PZ system that always finds the weapon with highest damage.
    This bases is choice on a number of factors: 
    1) is it currently loaded
    2) does the player have ammo (loaded magazines only if the gun uses magazines)
    3) damage
    
    playerObj = a IsoPlayer object
    subCategory = nil|"Pistol"|"Rifle"|"Shotgun"

]]
ORGM.equipBestFirearm = function(playerObj, subCategory)
	if not playerObj or playerObj:isDead() or playerObj:IsAiming() then return end
    local primary = playerObj:getPrimaryHandItem()

    local choices = {}
    local best = { }
	local it = playerObj:getInventory():getItems()
	for i=0,it:size()-1 do repeat
		local item = it:get(i)
		if not instanceof(item, "HandWeapon") or item:getSubCategory() ~= "Firearm" then break end
        if item:getCondition() == 0 then break end
        if not subCategory then
            table.insert(choices, item)
            break
        end
        local def = ORGM.FirearmTable[item:getType()]
        if not def then break end -- not a orgm gun
        local category = def.category
        if subCategory == "Pistol" then 
            if category == ORGM.REVOLVER or category == ORGM.PISTOL then
                print("adding "..item:getType())
                table.insert(choices, item)
            elseif category == ORGM.SUBMACHINEGUN and not item:isTwoHandWeapon() then
                print("adding "..item:getType())
                table.insert(choices, item)
            end
        elseif subCategory == "Shotgun" and category == ORGM.SHOTGUN then 
            table.insert(choices, item)
        elseif subCategory == "Rifle" then -- anything else is a rifle, smg, or unknown. bind these to the rifle key
            table.insert(choices, item)
        end
	until true end
    
    ------------------------------------------------------------------------------------------------
    for _, item in pairs(choices) do
        -- TODO: this needs proper handling for non-orgm guns too!
        local def = ORGM.FirearmTable[item:getType()]
        local modData = item:getModData()
        if def and modData.currentCapacity == nil then
            -- necroforge spawned gun? detect if its orgm, and call ORGM.setupGun
            ORGM.setupGun(ORGM.FirearmTable[item:getType()], item)
        end
        
        local current = {
            item = item,
            dmg = (item:getMaxDamage() + item:getMinDamage()) / 2,
            ammo = false,
            loaded = ((modData.currentCapacity or 0) + (modData.roundChambered or 0) > 0)
        }
        
        if def then -- skip these checks if its not a orgm gun
            if modData.containsClip then -- TODO: speedloader check
                local mag = ORGM.findBestMagazineInContainer(modData.ammoType, 'any', playerObj:getInventory())
                if mag and mag:getModData().currentCapacity > 0 then
                    current.ammo = true
                end 
            else
                local round = ORGM.findAmmoInContainer(modData.ammoType, 'any', playerObj:getInventory())
                if round then current.ammo = true end
            end
        end
        best = ORGM.compareFirearms(best, current)
    end

	if best.item then
        if best.item == primary then
            ISTimedActionQueue.add(ISUnequipAction:new(playerObj, primary, 50))
        else
            ISTimedActionQueue.add(ISEquipWeaponAction:new(playerObj, best.item, 50, true, best.item:isTwoHandWeapon()))
        end
    end
end

--[[ ORGM.compareFirearms(player, item1, item2)
    Compares 2 firearms and returns the better choice.
    
    item1 and item2 are tables {item=HandWeapon, loaded=boolean, ammo=boolean, dmg=float}
    
    returns either item1 or item2
]]
ORGM.compareFirearms = function(item1, item2)
    if not item1.item then return item2 end
    if item1.loaded == false and item2.loaded == true then return item2 end
    if item2.loaded == false and item1.loaded == true then return item1 end
    if item1.ammo == false and item2.ammo == true then return item2 end
    if item2.ammo == false and item1.ammo == true then return item1 end
    if item1.dmg < item2.dmg then return item2 end
    
    return item1
end

--[[  ORGM.equipBestMeleeWeapon(playerObj, subCategory)
    This is basically PZ's default weapon selection code. We use this for selecting melee weapons

]]
ORGM.equipBestMeleeWeapon = function(playerObj, subCategory)
	if not (playerObj and not playerObj:isDead() and not playerObj:IsAiming()) then return end

    local primary = playerObj:getPrimaryHandItem()
	if primary and instanceof(primary, "HandWeapon") and primary:getSubCategory() == subCategory then
        -- remove the old item
		ISTimedActionQueue.add(ISUnequipAction:new(playerObj, primary, 50))
		return
	end
	local weapon = nil
	local weaponDmg = 0
	local it = playerObj:getInventory():getItems()
	for i=1,it:size() do
		local item = it:get(i-1)
		if instanceof(item, "HandWeapon") and item:getSubCategory() == subCategory and
				weaponDmg < ((item:getMaxDamage() + item:getMinDamage()) / 2) and item:getCondition() > 0 then
			weapon = item
			weaponDmg = ((item:getMaxDamage() + item:getMinDamage()) / 2)
		end
	end

	if weapon and weapon ~= primary then
		ISTimedActionQueue.add(ISEquipWeaponAction:new(playerObj, weapon, 50, true, weapon:isTwoHandWeapon()))
	end
end

