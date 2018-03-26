--[[
    This file contains all component/upgrade data.
]]

--[[  ORGM.registerComponent(name, definition)
    
    Registers a component/upgrade type with ORGM.
    
    name = string name of the component/upgrade (without module prefix)
    definition = a table. Valid table keys/value pairs are:
        moduleName = nil, or string module name this item is from. If nil, ORGM is used
    
]]
local register = ORGM.registerComponent

register('2xScope', {lastChanged = 22,} )
register('4xScope', {lastChanged = 22,} )
register('8xScope', {lastChanged = 22,} )
register('FibSig', {lastChanged = 22,} )
register('Foregrip', {lastChanged = 22,} )
register('FullCh', {lastChanged = 22,} )
register('HalfCh', {lastChanged = 22,} )
register('PistolLas', {lastChanged = 22,} )
register('PistolTL', {lastChanged = 22,} )
register('RDS', {lastChanged = 22,} )
register('Recoil', {lastChanged = 22,} )
register('Reflex', {lastChanged = 22,} )
register('RifleLas', {lastChanged = 22,} )
register('RifleTL', {lastChanged = 22,} )
register('Rifsling', {lastChanged = 22,} )
register('SkeletalStock', {lastChanged = 22,} )
register('CollapsingStock', {lastChanged = 22,} )

ORGM.log(ORGM.INFO, "All default components/upgrades registered.")