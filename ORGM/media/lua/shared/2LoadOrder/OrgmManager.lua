local ORGM = ORGM
local Manager = ORGM.Manager
local Firearm = ORGM.Firearm
local Fire = ORGM.ReloadableWeapon.Fire

local ReloadManager = ReloadManager
local ISTimedActionQueue = ISTimedActionQueue

function Manager.attack(playerObj, chargeDelta)
    local weapon = playerObj:getPrimaryHandItem()
    -- check if its a orgm item, call the original function if not.
    local gunData = Firearm.getData(weapon)
    if not gunData then -- not a orgm gun. call original ReloadManager
        return ReloadManager[playerObj:getPlayerNum()+1]:checkLoaded(playerObj, chargeDelta)
    end
    local modData = weapon:getModData()

    -- NOTE: setup the gun if it isnt already...should be...
    -- ReloadUtil:setUpGun(weapon, playerObj)
    if playerObj:getCurrentState() ~= SwipeStatePlayer.instance() then -- player is in attack state
        if Fire.valid(modData) then
            ISTimedActionQueue.clear(playerObj)
            if (playerObj:getRecoilDelay() == 0 and Fire.pre(modData, playerObj, weapon)) then
                playerObj:DoAttack(chargeDelta or 0)
            end
        elseif self:rackingNow() then
            -- Don't interrupt the racking action
        elseif self:autoRackNeeded() then
            -- interrupt actions so racking can begin before firing
            ISTimedActionQueue.clear(playerObj)
        elseif playerObj:getRecoilDelay() == 0 then
            Fire.dry(modData, playerObj, weapon)
            playerObj:DoAttack(chargeDelta, true, gunData.clickSound);
        end
    end
end

function Manager.fire(playerObj, weapon)
    if not Firearm.isFirearm(weapon) then -- not a orgm gun. call original ReloadManager
        return ReloadManager[wielder:getPlayerNum()+1]:fireShot(wielder, weapon)
    end
    Fire.post(weapon:getModData(), playerObj, weapon)
end
