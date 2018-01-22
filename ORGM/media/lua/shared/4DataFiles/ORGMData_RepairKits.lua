--[[
    This file contains all default repair kit data.
]]

--[[  ORGM.registerRepairKit(name, definition)
    
    Registers a repair kit type with ORGM.
    
    name = string name of the repair kit (without module prefix)
    definition = a table. Valid table keys/value pairs are:
        moduleName = nil, or string module name this item is from. If nil, ORGM is used

]]
local register = ORGM.registerRepairKit

register('WD40', {} )
register('Brushkit', {} )
register('Maintkit', {} )

ORGM.log(ORGM.INFO, "All default Repairkits registered.")