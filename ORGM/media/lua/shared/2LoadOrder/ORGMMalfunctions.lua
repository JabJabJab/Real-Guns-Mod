--[[
    Checking malfunctions depends on a variety of factors:
    over all condition of the firearm
    how many rounds have been shot since the last time the firearm was cleaned. For some action types this is less important
        then others (ie: revolvers vs gas powered automatics)
    was WD-40 used and not been properly cleaned after? The use of WD-40 as a 'repair kit' is really quite incorrect. That
        stuff is NASTY for firearms. It creates extra dirt and gunk, strips away proper gun lubricants, and being a penetrating
        oil, can leak into ammo primers creating dud rounds.  It has its uses unseizing stuck parts, but without a proper
        cleaning after it creates additional problems

]]

local ORGM = ORGM
local Settings = ORGM.Settings
local Malfunctions = ORGM.Malfunctions
local Ammo = ORGM.Malfunctions.Ammo
local Mechanical = ORGM.Malfunctions.Mechanical
local Failure = ORGM.Malfunctions.Failure

local ipairs = ipairs
local select = select

local check = function(this, playerObj, weaponItem, ...)
    if not Settings.JammingEnabled then return false end
    for i, failure in ipairs({select(1, ...)}) do
        if failure:onEvent(this, playerObj, weaponItem) then
            return true
        end
    end
    return false
end
Malfunctions.checkFeed = function(this, playerObj, weaponItem)
    return check(this, playerObj, weaponItem,
        Ammo.FailToFeed1, -- poorly shaped bullet or neck not properly clearing the ramp.
        Mechanical.FailToFeed1, -- dirt
        Mechanical.FailToFeed2, -- worn recoil spring
        Mechanical.FailToFeed3, -- worn ramp
        Mechanical.FailToFeed4, -- bad magazine
        Mechanical.FailToFeed5, -- slam fire. faulty firing pin (too long)
        Ammo.FailToFeed2 -- slamfire. poorly seated primer
    )
end
Malfunctions.checkExtract = function(this, playerObj, weaponItem)
    return check(this, playerObj, weaponItem,
        Ammo.FailToExtract1, -- brass rim failure
        Ammo.FailToExtract2, -- lack of pressure - autos only.
        Ammo.FailToExtract3, -- case-head seperation. the head of the case is stuck in the chamber and needs to be extracted with tools.
        Mechanical.FailToExtract1, -- dirt
        Mechanical.FailToExtract2, -- worn extractor hook
        Mechanical.FailToExtract3 -- recoil spring too strong
    )
end
Malfunctions.checkEject = function(this, playerObj, weaponItem)
    return check(this, playerObj, weaponItem,
        -- stovepipes!
        Ammo.FailToEject, -- not enough pressure to cycle the action in automatics.
        Mechanical.FailToEject1, -- dirt
        Mechanical.FailToEject2 -- recoil to strong
    )
end
Malfunctions.checkFire = function(this, playerObj, weaponItem)
    return check(this, playerObj, weaponItem,
        Mechanical.FailToFire1, -- dirt
        Mechanical.FailToFire2, -- worn firing pin spring
        Mechanical.FailToFire3, -- worn firing pin
        Ammo.FailToFire1, -- dud round. refuses to fire.
        Ammo.FailToFire2, -- squib load. bullet will lodged in the barrel and needs to be cleared. Will not cycle automatics. (FailToEject)
        Ammo.FailToFire3 -- delay firing for a few seconds.
    )
end

Ammo.FailToFire1 = {
    name = "Failure-To-Fire, Dud Round",
    description = "For whatever reason, the round is a dud and will not fire.",
    onEvent = function(self, this, playerObj, weaponItem)
        return false
    end,
}
Ammo.FailToFire2 = {
    name = "Failure-To-Fire, Squib Load",
    description = "Bullet becomes lodged in the barrel due to bad ammo. Next shot is disastrous. Squib loads can be detected by the shot sound, less of a bang and more of a pop. <LINE> Automatics will not properly cycle with a squib, causing a failure to extract or eject.",
    onEvent = function(self, this, playerObj, weaponItem)
        return false
    end,
}
Ammo.FailToFire3 = {
    name = "Failure-To-Fire, Hang-Fire",
    description = "Firing of the shot is delayed due to bad ammo. When a firearm refuses to fire, it should be pointed in a safe direction for 2 minutes to rule out a hangfire. <LINE> This can cause severe damage to the shooter if the weapon has been holstered, and will be disastrous if a revolver and the cylinder was rotated.",
    onEvent = function(self, this, playerObj, weaponItem)
        return false
    end,
}
Ammo.FailToFeed1 = {
    name = "Failure-To-Feed, Bad Ammo",
    description = "Poorly shaped bullet or neck not properly clearing the ramp.",
    onEvent = function(self, this, playerObj, weaponItem)
        return false
    end,
}
Ammo.FailToFeed2 = {
    name = "Slam-Fire, Primer Seating",
    description = "The ammo has a poorly seated primer, sticking out slightly too far causing the gun to fire when the bolt is closed",
    onEvent = function(self, this, playerObj, weaponItem)
        return false
    end,
}
Ammo.FailToExtract1 = {
    name = "Failure-To-Extract, Brass Failure",
    description = "The brass rim on the case has ripped, causing it not to extract from the chamber.",
    onEvent = function(self, this, playerObj, weaponItem)
    end,
}
Ammo.FailToExtract2 = {
    name = "Failure-To-Extract, Low Pressure",
    description = "Casing failed to extract due not enough pressure to cycle the bolt.",
    onEvent = function(self, this, playerObj, weaponItem)
    end,
}
Ammo.FailToExtract3 = {
    name = "Case-Head Separation, Brass Failure",
    description = "The neck of the case has ripped, and the head is stuck in the chamber and needs to be extracted with tools.",
    onEvent = function(self, this, playerObj, weaponItem)
        return false
    end,
}
Ammo.FailToEject = {
    name = "Failure-To-Eject, Low Pressure",
    description = "Casing failed to eject due not enough pressure to cycle the bolt.",
    onEvent = function(self, this, playerObj, weaponItem)
        return false
    end,
}

--[[

    This table lists malfunctions caused by firearms in poor condition.  These should not be confused with
    actual mechanical failure (ie: broken parts), as they may not happen consistently. The firearm might
    function normally, suffer a malfunction, then continue to function normally after without maintenance
    or repair.

]]
Mechanical.FailToFeed1 = {
    name = "Failure-To-Feed, Dirt",
    description = "Excessive dirt causing the gun to fail to chamber rounds.",
    onEvent = function(self, this, playerObj, weaponItem)
        return false
    end
}
Mechanical.FailToFeed2 = {
    name = "Failure-To-Feed, Worn Recoil Spring",
    description = "The recoil spring is not providing enough tension to properly chamber rounds.",
    onEvent = function(self, this, playerObj, weaponItem)
        return false
    end
}
Mechanical.FailToFeed3 = {
    name = "Failure-To-Feed, Worn Chamber Ramp",
    description = "The chamber ramp is worn, causing the gun to fail to chamber rounds.",
    -- worn magazine spring, worn recoil spring, dirt
    onEvent = function(self, this, playerObj, weaponItem)
        -- NOTE: Crude. old mechanics.
        -- TODO: chances need to be more dynamic, it assumes a max condition of 10
        local chance = (weaponItem:getConditionMax() / weaponItem:getCondition()) *2
        if playerObj:HasTrait("Lucky") then
            chance = chance * 0.8
        elseif playerObj:HasTrait("Unlucky") then
            chance = chance * 1.2
        end
        local result = ZombRand(300 - math.ceil(chance)*2)+1
        if result <= chance then
            this.isJammed = true
            weaponItem:getModData().isJammed = true
            return true
        end
        return false
    end
}
Mechanical.FailToFeed4 = {
    name = "Failure-To-Feed, Magazine Failure",
    description = "Issues with the magazine preventing the gun from properly chambering rounds.",
    onEvent = function(self, this, playerObj, weaponItem)
        return false
    end,
}
Mechanical.FailToFeed5 = {
    name = "Slam-Fire, Faulty Firing Pin",
    description = "The firing pin is slighty too long, causing the gun to slamfire (also known as Hammer Follow).",
    onEvent = function(self, this, playerObj, weaponItem)
        return false
    end,
}
Mechanical.FailToFire1 = {
    name = "Failure-To-Fire, Dirt",
    description = "Excessive dirt is jamming up the firing pin.",
    onEvent = function(self, this, playerObj, weaponItem)
        return false
    end,
}
Mechanical.FailToFire2 = {
    name = "Failure-To-Fire, Faulty Firing Pin Spring",
    description = "The firing pin spring is worn, causing the firing pin to not have enough force.",
    onEvent = function(self, this, playerObj, weaponItem)
        return false
    end,
}
Mechanical.FailToFire3 = {
    name = "Failure-To-Fire, Faulty Firing Pin",
    description = "The firing pin is worn, causing it to not fully engage the primer.",
    onEvent = function(self, this, playerObj, weaponItem)
        return false
    end,
}
Mechanical.FailToExtract1 = {
    name = "Failure-To-Extract, Dirt",
    description = "Excessive chamber dirt causing casings to become stuck.",
    onEvent = function(self, this, playerObj, weaponItem)
        return false
    end,
}
Mechanical.FailToExtract2 = {
    name = "Failure-To-Extract, Worn Extractor Hook",
    description = "The extractor hook is worn out, causing it to fail to extract casings from the chamber.",
    onEvent = function(self, this, playerObj, weaponItem)
        return false
    end,
}
Mechanical.FailToExtract3 = {
    name = "Failure-To-Extract, Recoil Spring Issues",
    description = "The recoil spring is providing too much tension preventing the action from cycling properly, causing it to fail to extract.",
    onEvent = function(self, this, playerObj, weaponItem)
        return false
    end,
}
Mechanical.FailToEject1 = {
    name = "Failue-To-Eject, Dirt",
    description = "Excessive dirt is preventing the action from cycling properly, leading to a failure to eject. (also known as Stovepipe)",
    onEvent = function(self, this, playerObj, weaponItem)
        return false
    end,
}
Mechanical.FailToEject2 = {
    name = "Failue-To-Eject, Dirt",
    description = "The recoil spring is providing too much tension preventing the action from cycling properly, leading to a failure to eject. (also known as Stovepipe)",
    onEvent = function(self, this, playerObj, weaponItem)
        return false
    end,
}

--[[    ORGM.MechanicaFailureTable

    This table contains potential mechanical failures (broken or seized parts). These will consistently
    lead to the mechanical malfunctions listed above.

]]
