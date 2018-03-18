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

register('2xScope', {lastChanged = 20,} )
register('4xScope', {lastChanged = 20,} )
register('8xScope', {lastChanged = 20,} )
register('FibSig', {lastChanged = 20,} )
register('Foregrip', {lastChanged = 20,} )
register('FullCh', {lastChanged = 20,} )
register('HalfCh', {lastChanged = 20,} )
register('PistolLas', {lastChanged = 20,} )
register('PistolTL', {lastChanged = 20,} )
register('RDS', {lastChanged = 20,} )
register('Recoil', {lastChanged = 20,} )
register('Reflex', {lastChanged = 20,} )
register('RifleLas', {lastChanged = 20,} )
register('RifleTL', {lastChanged = 20,} )
register('Rifsling', {lastChanged = 20,} )
register('SkeletalStock', {lastChanged = 20,} )
register('CollapsingStock', {lastChanged = 20,} )

ORGM.log(ORGM.INFO, "All default components/upgrades registered.")