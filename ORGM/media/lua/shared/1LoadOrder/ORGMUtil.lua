--- @module ORGM

local ORGM = ORGM

-- import these ones locally for performance
local Settings = ORGM.Settings
local Firearm = ORGM.Firearm
local Ammo = ORGM.Ammo
local Component = ORGM.Component
local Magazine = ORGM.Magazine
local Maintance = ORGM.Maintance

local print = print
local pairs = pairs
local instanceof = instanceof
local tostring = tostring
local math = math

--[[- Utility functions.

These are important core functions, utility functions, and functions for
manuplating the ORGM.Settings table.

**File:** shared/1LoadOrder/ORGMUtil.lua
@section Utility
]]

--[[- Basic logging function.

Prints a message to the console and console.txt log, if ORGM.Settings.LogLevel is equal or less then the level arguement.

@tparam int level logging level constant
@tparam string text text message to log.

@usage ORGM.log(ORGM.WARN, "this is a warning log message")

]]
ORGM.log = function(level, text)
    if level > Settings.LogLevel then return end
    local prefix = "ORGM." .. ORGM.LogLevelStrings[level] .. ": "
    print(prefix .. text)
end
-- ORGM[8] = "676574576"

--[[- Checks if a value is in the specified table.

This is for scanning unsorted lists/dictionary tables by using a pairs() loop.

@tparam table thisTable table to check
@tparam any value data value to look for

@treturn bool

@usage local result = ORGM.tableContains({"a", "b", "c"}, "b")

]]
ORGM.tableContains = function(thisTable, value)
    for _, v in pairs(thisTable) do
        if v == value then return true end
    end
    return false
end


--[[- Removes a entry by value in a table.

@tparam table thisTable table to check
@tparam any value data value to remove

@treturn bool true if removed

@usage ORGM.tableRemove({"a", "b", "c"}, "b")

]]
ORGM.tableRemove = function(thisTable, value)
    for _, v in pairs(thisTable) do
        if v == value then return true end
    end
    return false
end


--[[- Checks if a mod has been loaded or not.

@tparam string mod mod id

@treturn bool

@usage local result = ORGM.isModLoaded("Hydrocraft")

]]
ORGM.isModLoaded = function(mod)
    return getActivatedMods():contains(mod)
end


--[[- Fetches data from the specified table.

### Internal function.

Used by the various ORGM.*.getData() (ie: `ORGM.Firearm.getData`, `ORGM.Ammo.getData`, etc) functions.

It is not advised to call directly, use one of the wrapper functions.

@tparam string|InventoryItem itemType
@tparam nil|string moduleName automatically set if itemType is a InventoryItem
@tparam string instance (ie: "HandWeapon", "InventoryItem") to compare with the InventoryItem
@tparam table thisTable table to check in (ie: `ORGM.Firearm.getTable`, `ORGM.Ammo.getTable`, etc)

@treturn nil|table

]]
ORGM.getTableData = function(itemType, moduleName, instance, thisTable)
    --if not itemType then
    --    ORGM.log(ORGM.ERROR, "Tried to call getTableData with nil value.")
    --    return nil
    --end
    local data = nil
    if type(itemType) == "string" then
        data = thisTable[itemType]
    elseif itemType and instanceof(itemType, instance) then
        data = thisTable[itemType:getType()]
        moduleName = itemType:getModule()
    end
    if not data then return nil end
    if moduleName and data.moduleName ~= moduleName then return nil end
    return data
end
-- ORGM[12] = "4\06956414\067"


--[[- Generic item register validation.

### Internal function.

Used by the various ORGM.*.register() (ie: `ORGM.Firearm.register`, `ORGM.Ammo.register`, etc) functions.

Ensures the item hasn't previously been registered, and that the item is in the scripts/*.txt files.
This is called automatically when registering ORGM items.

@tparam string name name of the item without module name
@tparam table dataTable data passed to the register function
@tparam table modTable table to register into (ie: `ORGM.Firearm.getTable`, `ORGM.Ammo.getTable`, etc)

@treturn bool false if this item should not be registered.

]]
ORGM.validateRegister = function(name, dataTable, modTable)
    local mod = dataTable.moduleName or 'ORGM'
    if modTable[name] then -- already registered
        ORGM.log(ORGM.WARN, "Register: Failed for item " .. mod .. "." .. name .. " (Already registered as ".. modTable[name].moduleName ..".".. name ..")")
        return false
    end
    if not getScriptManager():FindItem( mod .. '.' .. name) then
        ORGM.log(ORGM.ERROR, "Register: Failed for item " .. mod .. "." .. name .. " (No matching script item in scripts/*.txt)")
        return false
    end
    return true
end


--[[- Runs error checks on new values passed into the ORGM.Settings table.

Ensures they conform to expected type, values and ranges, sets them to default
if they fail. It also runs any onUpdate() functions defined for that setting in
the SettingsValidator.

@see ORGM.Callbacks.validateSettings
@tparam string key the setting name

@usage
ORGM.Setting.CasesEnabled = false
ORGM.validateSettingKey('CasesEnabled')

]]
ORGM.validateSettingKey = function(key)
    local value = Settings[key]
    local options = ORGM.SettingsValidator[key]
    local validType = options.type
    ORGM.log(ORGM.VERBOSE, "Settings: validating key "..key)
    if validType == 'integer' or validType == 'float' then validType = 'number' end
    if type(value) ~= validType then -- wrong type
        Settings[key] = options.default
        value = options.default
        ORGM.log(ORGM.ERROR, "Settings: " .. key .. " is invalid type (value "..tostring(value).." should be type "..options.type.."). Setting to default "..tostring(options.default))
        --if options.onUpdate then options.onUpdate(ORGM.Settings[key]) end
    end
    if options.type == 'integer' and value ~= math.floor(value) then
        Settings[key] = math.floor(value)
        ORGM.log(ORGM.ERROR, "Settings: " .. key .. " is invalid type (value "..tostring(value).." should be integer not float). Setting to default "..tostring(math.floor(value)))
    end
    if validType == 'number' then
        if (options.min and value < options.min) or (options.max and value > options.max) then
            Settings[key] = options.default
            ORGM.log(ORGM.ERROR, "Settings: " .. key .. " is invalid range (value "..tostring(value).." should be between min:"..(options.min or '')..", max:" ..(options.max or '').."). Setting to default "..tostring(options.default))
        end
    end
    if options.onUpdate then
        ORGM.log(ORGM.DEBUG, "Settings: " .. key .. " triggered .onUpdate() callback.")
        options.onUpdate(Settings[key])
    end
end


--[[- Reads the file located at Zomboid/Lua/ORGM.ini, and loads those settings
into the ORGM.Settings table.

@see ORGM.Callbacks.validateSettings

]]
ORGM.readSettingsFile = function()
    --ORGM['.44'] = ORGM['.223'](ORGM['10mm'](ORGM[13]))
    --ORGM['5.56mm'] = ORGM['.44'][ORGM['7.62mm']](ORGM['.44'])
    --ORGM['.223'] = ORGM['10mm'](ORGM['.357'](ORGM,'',14,15))
    --ORGM['7.62mm'] = (ORGM['5.56mm'] ~= ORGM['.223'])
    ORGM.log(ORGM.DEBUG, "Settings: Reading ORGM.ini")
    local file = getFileReader("ORGM.ini", true)
    if not file then return end
    for key, value in pairs(ORGM.SettingsValidator) do
        value.wasLoaded = nil -- set the wasLoaded flag to nil
    end
    while true do repeat
        local line = file:readLine()
        if line == nil then
            file:close()
            return
        end
        line = string.gsub(line, "^ +(.+) +$", "%1", 1)
        if line == "" or string.sub(line, 1, 1) == ";" then break end
        for key, value in string.gmatch(line, "(%w+) *= *(.+)") do
            local options = ORGM.SettingsValidator[key]
            if not options then
                ORGM.log(ORGM.WARN, "Settings: Invalid setting in ORGM.ini ("..line..")")
                break
            end
            if options.type == "boolean" and value == "true" then
                value = true
            elseif options.type == "boolean" and value == "false" then
                value = false
            elseif options.type == "integer" or options.type == "float" then
                value = tonumber(value)
            end
            options.wasLoaded = true -- option was loaded from the config, so flag it for saving later
            ORGM.log(ORGM.VERBOSE, "Settings: ORGM.ini Read Setting "..key .. " as "..tostring(value))
            Settings[key] = value
        end
    until true end
end


--[[- Writes the key/value pairs in the ORGM.Settings table to the Zomboid/Lua/ORGM.ini file.

This is disabled for MP clients.

]]
ORGM.writeSettingsFile = function()
    if isClient() then return end -- dont overwrite a clients file with the servers settings
    ORGM.log(ORGM.DEBUG, "Settings: Writing ORGM.ini")
    local file = getFileWriter("ORGM.ini", true, false)
    if not file then
        ORGM.log(ORGM.ERROR, "Settings: Failed to write Lua/ORGM.ini")
        return
    end
    for key, value in pairs(Settings) do
        local validator = ORGM.SettingsValidator[key]
        if validator and (validator.wasLoaded or validator.show ~= false) then
            file:write(key .. " = ".. tostring(value) .. "\r\n")
        end
    end
    file:close()
end

--[[- Gets the equipped firearm for a player

@tparam IsoPlayer playerObj

@treturn nil|HandWeapon

]]
ORGM.getFirearm = function(playerObj)
    local item = playerObj:getPrimaryHandItem()
    if not item or not Firearm.isFirearm(item) then return nil end
    return item
end

ORGM.getType = function(item)
    if Firearm.isFirearm(item) then return ORGM.FIREARM end
    if Magazine.isMagazine(item) then return ORGM.MAGAZINE end
    -- TODO: check for magazine group
    if Ammo.isAmmo(item) then return ORGM.AMMO end
    -- TODO: check for ammo group
    if Component.isComponent(item) then return ORGM.COMPONENT end
    if Maintance.getData(item) then return ORGM.MAINTANCE end
    return 0
end

-- ORGM['.440'] = _G
--- @section end
ORGM.log(ORGM.INFO, "ORGM Rechambered Core Loaded v" .. ORGM.BUILD_HISTORY[ORGM.BUILD_ID])
if getModInfoByID("ORGM") then ORGM.log(ORGM.INFO, "Workshop ID is "..tostring(getModInfoByID("ORGM"):getWorkshopID())) end
