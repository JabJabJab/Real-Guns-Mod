--[[- This file contains all default maintance kit data.

All calls made by this script are to `ORGM.Maintance.register`. See the documention there.

@script ORGMData_RepairKits.lua
@author Fenris_Wolf
@release 3.09
@copyright 2018 **File:** shared/4DataFiles/ORGMData_RepairKits.lua

]]

local register = ORGM.Maintance.register

register('WD40', {} )
register('Brushkit', {} )
register('Maintkit', {} )

ORGM.log(ORGM.INFO, "All default Repairkits registered.")
