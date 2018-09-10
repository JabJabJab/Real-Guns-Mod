--[[- Override for ISUpgradeWeapon.

    File: client/1LoadOrder/ISORGMUpgradeWeapon.lua
    @classmod ISUpgradeWeapon
    @author Fenris_Wolf
    @release 3.09

]]
local ORGM = ORGM
local Firearm = ORGM.Firearm
local Component = ORGM.Component
--[[- Called when attaching components.

]]
function ISUpgradeWeapon:perform()
    local def = Component.getData(self.part)
    local data = self.part:getModData()
    if def and def.lastChanged and (data.BUILD_ID == nil or data.BUILD_ID < def.lastChanged) then
        -- handle orgm component update...
        ORGM.log(ORGM.INFO, "Obsolete component detected (" .. self.part:getType() .."). Running update function.")
        local new = Component.copy(self.part)
        self.character:getInventory():Remove(self.part)
        self.character:getInventory():AddItem(new)
        self.part = new
        --ISBaseTimedAction.perform(self)
        --return
    end


    self.weapon:setJobDelta(0.0)
    self.part:setJobDelta(0.0)

    ORGM.log(ORGM.DEBUG, "Installing "..self.part:getType() .. ", weight="..tostring(self.part:getWeight())..'/'..tostring(self.part:getActualWeight())..'/'..tostring(self.part:getWeightModifier()))

    ORGM.log(ORGM.VERBOSE, "Weapon weight before "..tostring(self.weapon:getWeight()) .."/" .. tostring(self.weapon:getActualWeight()))

    self.weapon:attachWeaponPart(self.part)
    ORGM.log(ORGM.VERBOSE, "Weapon weight after "..tostring(self.weapon:getWeight()) .."/" .. tostring(self.weapon:getActualWeight()))
    self.character:getInventory():Remove(self.part)
    self.character:setSecondaryHandItem(nil)
    if Firearm.isFirearm(self.weapon) then
        Firearm.Stats.set(self.weapon)
    end
    -- needed to remove from queue / start next.
    ISBaseTimedAction.perform(self)
end
