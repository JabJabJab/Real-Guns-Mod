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

register('2xScope', {} )
register('4xScope', {} )
register('8xScope', {} )
register('FibSig', {} )
register('Foregrip', {} )
register('FullCh', {} )
register('HalfCh', {} )
register('PistolLas', {} )
register('PistolTL', {} )
register('RDS', {} )
register('Recoil', {} )
register('Reflex', {} )
register('RifleLas', {} )
register('RifleTL', {} )
register('Rifsling', {} )
register('SkeletalStock', {} )
register('CollapsingStock', {} )

ORGM.log(ORGM.INFO, "All default components/upgrades registered.")