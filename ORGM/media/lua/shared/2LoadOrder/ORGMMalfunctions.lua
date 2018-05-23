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

--[[    ORGM.AmmoMalfunctionTable
    
    This table lists malfunctions that are caused by faulty ammunition.
    
]]
ORGM.AmmoMalfunctionTable = {
    CaseHeadSeparation = {
        -- the head of the case is stuck in the chamber and needs to be extracted with tools.
        -- the brass is now useless, this will only effect some bullets (ie: needs a neck)
        -- this should result in a constant failure to feed until fixed
        onCheck = function(char, weapon, reloadable) end, -- called when checking if this malfunction should happen
    },
    Dud = {
        -- round in chamber refuses to fire. This ammoType needs to be replaced with a dud.
        onCheck = function(char, weapon, reloadable) 
            -- triggered on reloadable:preFireShot()
        end,
    },
    HangFire = {
        -- delay firing for a few seconds. if the player is still aiming with the round in chamber, :DoAttack(), 
        -- if not aiming but round is in, possible self injury (if the gun is now in inventory, definite self injury). 
        -- If the hung round has been racked and cleared, this fires from the ground.
        -- If this is a revolver and the cylinder has been rotated, this can be disastrous
        onCheck = function(char, weapon, reloadable) 
            -- triggered on reloadable:preFireShot()
        end,
    },
    Squib = {
        -- bullet is lodged in the barrel and needs to be cleared. Next shot is disastrous. For automatics this should
        -- also not properly cycle the action, causing a FailToEject
        onCheck = function(char, weapon, reloadable) 
            -- triggered on reloadable:preFireShot(), this one actually occurs when the shot is fired but preFireShot()
            -- is used to stop the attack
        end,
    },
    FailToFeed = {
        -- poorly shaped bullet or neck not properly clearing the ramp. Not applicable to revolvers and break barrels.
        onCheck = function(char, weapon, reloadable) 
            -- triggered on reloadable:closeSlide()
        end,
    },
    SlamFire = {
        -- poorly seated primer
        onCheck = function(char, weapon, reloadable) 
            -- triggered on reloadable:closeSlide()
        end,
    },
    FailToExtract = {
        -- brass rim failure
        onCheck = function(char, weapon, reloadable) 
            -- triggered on reloadable:openSlide()
        end,
    },
    FailToEject = {
        -- not enough pressure to cycle the action in automatics.
        onCheck = function(char, weapon, reloadable) 
            -- triggered on reloadable:openSlide()
        end,
    }
}

--[[    ORGM.MechanicalMalfunctionTable

    This table lists malfunctions caused by firearms in poor condition.  These should not be confused with
    actual mechanical failure (ie: broken parts), as they may not happen consistently. The firearm might 
    function normally, suffer a malfunction, then continue to function normally after without maintenance
    or repair.
    
]]
ORGM.MechanicalMalfunctionTable = {
    FailToFeed = {
        -- worn ramp, worn magazine spring, dirt
    },
    SlamFire = { -- (or hammer follow)
        -- faulty firing pin (too long)
    },
    FailToFire = {
        -- faulty firing pin (too short/worn, or worn spring), dirt
    },
    FailToExtract = {
        -- broken/worn extractor hook, recoil spring problems, dirty chamber, leads to FailToFeed
    },
    FailToEject = { -- (or stovepipe)
        -- broken ejector, recoil spring problems, dirt, leads to FailToFeed
    },
}

--[[    ORGM.MechanicaFailureTable
    
    This table contains potential mechanical failures (broken or seized parts). These will consistently
    lead to the mechanical malfunctions listed above.
    
]]

ORGM.MechanicaFailureTable = {
    
}
