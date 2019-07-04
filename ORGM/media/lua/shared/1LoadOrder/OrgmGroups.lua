--[[ This file contains the Group and ItemType classes.

These 2 classes are the heart of many of ORGM's features, including the spawn system,
multi-capacity magazines, multiple ammo types per gun, and the creation of ScriptItems.

Data for various item types (firearms, magazines, attachments, ammo) is organized using Group class
object, while the actual data is contained within a ItemType class objects.

Below is simplified example of how its used with magazines, creating everything the mod needs for
mag data, spawn types and rates, and including creating the ScriptItem
(scripts/*txt files not needed!)

```
-- these 2 store our items and groups
local MagazineTable = { }
local MagazineGroupTable = { }

-- these 2 will be our sub-classes
local MagazineGroup = {}
local MagazineType = {}

-- set the MagazineGroup and MagazineType metatables
setmetatable(MagazineGroup, { __index = ORGM.Group })
setmetatable(MagazineType, { __index = ORGM.ItemType })

-- set some pointers to our storage tables
MagazineGroup._GroupTable = MagazineGroupTable
MagazineGroup._ItemTable = MagazineTable
MagazineType._GroupTable = MagazineGroupTable
MagazineType._ItemTable = MagazineTable

-- set the PropertiesTable, used for setting ItemType default values and error checking
MagazineType._PropertiesTable = {
    features = {type='integer', min=0, default=0, required=true},
    Icon = {type='string', default=""},
    ammoType = {type='string', default="", required=true},
    maxCapacity = {type='integer', min=1, default=10, required=true},
    Weight = {type='float', min=0, max=100, default=0.2},

    reloadClass = {type='string', default="ISORGMMagazine"},
    reloadTime = {type='integer', min=0, default=10},
    ejectSound = {type='string', default="ORGMMagLoad"},
    insertSound = {type='string', default="ORGMMagLoad"},
    rackSound = {type='string', default="ORGMMagLoad"},
    shootSound = {type='string', default="none"},
    clickSound = {type='string', default="none"},
}
-- create a group for all pistol mags
MagazineGroup:new("MagGroup_Pistols")

-- Create a new group for beretta mags
MagazineGroup:new("MagGroup_Beretta_92", { Groups = { MagGroup_Pistols = 1 } })

-- create 2 beretta mags, one 15 round (80% spawn weight), and one 32 round (20% spawn weight)
MagazineType:newCollection("Mag_Beretta_92", {
        ammoType = 'AmmoGroup_9x19mm',
        Icon = "Mag_Beretta_92",
        features = Flags.BOX,
    },{
        x15 = {
            maxCapacity = 15,
            Weight = 0.2,
            Groups = { MagGroup_Beretta_92 = 4 },
        },
        x32 = {
            maxCapacity = 32,
            Weight = 0.3,
            Groups = { MagGroup_Beretta_92 = 1 },
        },
    }
)

-- add more MagazineGroup, and MagazineType calls here
```



    @author Fenris_Wolf
    @release 4.00
    @copyright 2018 **File:** shared/1LoadOrder/ORGMGroups.lua

]]
local Group = ORGM.Group
local ItemType = ORGM.ItemType
local Settings = ORGM.Settings
-- setup empty tables for sanity. The sub-classes should override these.
Group._GroupTable = {}
Group._ItemTable = {}
ItemType._PropertiesTable = {}
ItemType._GroupTable = {}
ItemType._ItemTable = {}


--[[- The ORGM.Group class is a super-class for organizing items and sub-groups.

It is not intended be used directly, but provides a common code base for various subclasses
such as `ORGM.Firearm.FirearmGroup`, `ORGM.Magazine.MagazineGroup`, `ORGM.Ammo.AmmoGroup`, etc.

This class is the secret sauce for ORGM's spawn system, multi-capacity magazines, multiple ammo
types per gun. To be used in conjunction with the `ItemType` class

    @classmod Group
    @author Fenris_Wolf
    @release 4.00
    @copyright 2018 **File:** shared/1LoadOrder/ORGMGroups.lua

]]

--[[- Creates a new group.

@tparam string groupName the name of the new group
@tparam table groupData a table containing additional information for this group.

@treturn table a new Group object

]]
function Group:new(groupName, groupData)
    local o = { }
    o._size = 0 -- track member count, faster then using #self.members

    -- copy all keys from our groupData table
    for key, value in pairs(groupData or {}) do o[key] = value end
    setmetatable(o, { __index = self })
    o.type = groupName

    if not o.noScript then
        -- make script item, probably redundant, but helpful for ammo
        local script = {
            "module ORGM {",
            "\titem " .. groupName,
            "\t{",
            "\t\tCount = 1,",
            "\t\tType = Normal,",
            "\t\tDisplayName = ".. groupName .. ",",
            "\t}",
            "}",
        }
        getScriptManager():ParseScript(table.concat(script, "\r\n"))
        o.instance = InventoryItemFactory.CreateItem("ORGM." .. groupName)
        if not o.instance then
            ORGM.log(ORGM.ERROR, "Group: Could not create instance of " .. groupName .. " (Registration Failed)")
        end
    end

    -- add as a subgroup of specified groups
    for gname, weight in pairs(o.Groups or { }) do
        group = o._GroupTable[gname]
        if group then
            group:add(groupName, weight)
        else
            ORGM.log(ORGM.WARN,"Group: " .. groupName .. " requested to join invalid group "..gname)
        end
    end
    o._GroupTable[groupName] = o

    o.members = { }
    ORGM.log(ORGM.VERBOSE, "Group: Registered " .. groupName .. " --- ".. (o.instance and o.instance:getDisplayName() or ""))
    return o
end


function Group:len()
    return self._size
end

function Group:count(recurse, ignore, depth)
    local result = 0
    depth = depth or 0
    if depth > 20 then return nil end
    depth = 1 + depth

    for name, weight in pairs(self.members) do repeat
        if ignore and weight == 0 then break end

        -- check if our result is another Group object, and call recursively
        local group = self._GroupTable[name]
        if not group then
            result = 1 + result
        elseif recurse then
            result = result + group:count(recurse, ignore, depth)
        end

    until true end
    return result
end

--[[- Normalizes the weights of items in the group.

This is generally called during `Group.random` and returns a new table instead of
modifying the existing table which remains in a non-normalized state.

If defined, the filter function should take 3 arguments (self, itemName, weight) and return a float.
Be aware the filter will be called twice, once during the sum checking phase, and again during
normalization of the resulting table

@tparam[opt] table typeModifiers a table containing Group or ItemType names and multipliers
@tparam[opt] function filter a function that adds or subtracts to the multiplier

@treturn table a table of normalized values

]]
function Group:normalize(typeModifiers, filter)
    local sum = 0
    typeModifiers = typeModifiers or {}

    -- need to loop through our members twice. once to calculate the sum of all values
    for itemName, weight in pairs(self.members) do
        local mod = (typeModifiers[itemName] or 1) + (filter and filter(self, itemName, weight) or 0)
        local year = (self._ItemTable[itemName] and self._ItemTable[itemName].year) or (self._GroupTable[itemName] and self._GroupTable[itemName].year)
        if Settings.LimitYear and Settings.LimitYear ~= 0 and year and year > Settings.LimitYear then mod = 0 end
        sum = sum + weight * mod
    end
    -- second time we can actually set the new values.
    local members = {}
    for itemName, weight in pairs(self.members) do
        local mod = ((typeModifiers[itemName] or 1) + (filter and filter(self, itemName, weight) or 0))
        local year = (self._ItemTable[itemName] and self._ItemTable[itemName].year) or (self._GroupTable[itemName] and self._GroupTable[itemName].year)
        if Settings.LimitYear and  Settings.LimitYear ~= 0 and year and year > Settings.LimitYear then mod = 0 end
        members[itemName] = weight * mod  / sum
    end
    return members
end


--[[- Adds a item to a group, or adjusts its weight.

This is generally called during `ItemType.new` when creating new items, but can be called
at any point. The weight value is the priority given to that item when `Group.random` is
called.

The effects on spawn tables after calling this function are immediate.

@tparam itemName string the name of the item or sub-group
@tparam integer the weight of this item in the group

]]
function Group:add(itemName, weight)
    if not self.members[itemName] then self._size = 1 + self._size end
    self.members[itemName] = weight or 1
end


--[[- Removes a item from a group.

The effects on spawn tables after calling this function are immediate.

@tparam itemName string the name of the item or sub-group

]]
function Group:remove(itemName)
    if self.members[itemName] then self._size = self._size - 1 end
    self.members[itemName] = nil
end


--[[- Randomly, and Recursively selects a ItemType from the groups members.

This is generally called during `Group.random` and returns a new table instead of
modifying the existing table which remains in a non-normalized state.

If defined, the filter function should take 3 arguments (self, itemName, weight) and return a float

@tparam[opt] table typeModifiers a table passed to `Group.normalize`
@tparam[opt] function filter a function passed to `Group.normalize`
@tparam[opt] integer depth should not be set manually. Used internally by this function during recursion


@treturn nil|table a ItemType class object

]]
function Group:random(typeModifiers, filter, depth)
    -- check recursion limit
    if depth == nil then depth = 0 end
    if depth > 20 then return nil end
    depth = 1 + depth

    -- get normalized and filtered group members table
    local members = self.members
    members = self:normalize(typeModifiers, filter)
    -- fetch a random result
    local sum = 0
    local roll = ZombRandFloat(0,1)
    local result = nil
    for itemName, weight in pairs(members) do
        sum = sum + weight
        if roll <= sum then
            result = itemName
            break
        end
    end

    -- check if our result is another Group object, and call recursively
    local group = self._GroupTable[result]
    if group then
        ORGM.log(ORGM.VERBOSE, "Group: random for '".. self.type .. "' picked '"..group.type .."'")
        return group:random(typeModifiers, filter, depth)
    end

    -- not a Group, return a ItemType
    local result = self._ItemTable[result]

    ORGM.log(ORGM.VERBOSE, "Group: random for '".. self.type .. "' picked '" ..(result and result.type or "nil").. "'")
    return result --dataTable[result]
end


--[[- Tests (non-recursively) if a Group contains a specified subgroup or itemtype

@tparam itemName string the name of the item or sub-group

@treturn bool

]]
function Group:contains(itemName)
    itemName = type(itemName) == 'table' and itemName.type or itemName
    return self.members[itemName] ~= nil
end



--[[- The ORGM.ItemType class is a super-class for tracking item data.

It is not intended be used directly, but provides a common code base for various subclasses
such as `ORGM.Firearm.FirearmType`, `ORGM.Magazine.MagazineType`, `ORGM.Ammo.AmmoType`, etc.

This class is responsable for registering items with the ORGM core, providing methods for
accessing to item's data and creating any ScriptItems (replacing scripts/*txt files).

    @classmod ItemType
    @author Fenris_Wolf
    @release 4.00
    @copyright 2018 **File:** shared/1LoadOrder/ORGMGroups.lua

]]



--[[ copies key/value pairs from a source table to a destination table, with validation.

The properties argument contains the rules used for validation, as well as knowing which
key/values to copy, and any default values for missing keys.

A example properties table used by the AmmoType subclass:
```
local PropertiesTable = {
    MinDamage = {type='float', min=0, max=100, default=0.2},
    MaxDamage = {type='float', min=0, max=100, default=1},
    Range = {type='integer', min=0, max=100, default=20},
    Weight = {type='float', min=0, max=100, default=0.01},
    Recoil = {type='float', min=0, max=100, default=20},
    Penetration = {type='integer', min=0, max=100, default=0},
    MaxHitCount = {type='integer', min=1, max=100, default=1},
    BoxCount = {type='integer', min=0, default=20},
    CanCount = {type='integer', min=0, default=200},
    Icon = {type='string', default=nil},
    category = {type='integer', min=Flags.PISTOL, max=Flags.SHOTGUN, default=Flags.PISTOL, required=true},
    features = {type='integer', min=0, default=0, required=true},
}
```

@tparam string logPrefix a string to prefix on log messages, usually containing the item's name
@tparam table properties a table of validation rules and default values
@tparam table source
@tparam table destination

@treturn bool true if the validation passes, false on failure.

Note on failure not all properties maybe copied (early return)

]]
local copyPropertiesTable = function(logPrefix, properties, source, destination)
    for propName, options in pairs(properties) do
        local validType = options.type
        local value = destination[propName] or source[propName]
        destination[propName] = value
        if validType == 'integer' or validType == 'float' then validType = 'number' end
        local wasNil = value == nil
        if type(value) ~= validType then -- wrong type
            if wasNil and options.required then
                ORGM.log(ORGM.ERROR, logPrefix .. " property " .. propName .. " is invalid type (value "..tostring(value).." should be type "..options.type.."). Setting to default "..tostring(options.default))
                if options.default == nil then return false end
            end

            value = options.default
        end

        if options.type == 'integer' and value ~= math.floor(value) then
            if wasNil and options.required then
                ORGM.log(ORGM.ERROR, logPrefix .. " property " .. propName .. " is invalid type (value "..tostring(value).." should be integer not float). Setting to default "..tostring(math.floor(value)))
            end
            value = math.floor(value)
        end

        if validType == 'number' then
            if (options.min and value < options.min) or (options.max and value > options.max) then
                if wasNil and options.required then
                    ORGM.log(ORGM.ERROR, logPrefix .. " property " .. propName .. " is invalid range (value "..tostring(value).." should be between min:"..(options.min or '')..", max:" ..(options.max or '').."). Setting to default "..tostring(options.default))
                end
                value = options.default
            end
        end
        destination[propName] = value
    end
    return true
end


--[[- Creates a new ItemType.

@tparam string itemName the name of the new Item
@tparam table itemData a table containing aditional information for this group.
@tparam[opt] table template a table containing key/values to be copied to the new
item should they not exist in itemData.

@treturn table a new ItemType object

]]

function ItemType:new(itemName, itemData, template)
    local o = { }
    template = template or {}
    for key, value in pairs(itemData) do o[key] = value end
    setmetatable(o, { __index = self })
    ORGM.log(ORGM.VERBOSE, "ItemType: Initializing ".. itemName)
    o.type = itemName
    o.moduleName = 'ORGM'
    -- setup specific properties and error checks
    if not copyPropertiesTable("ItemType: ".. itemName, o._PropertiesTable, template, o) then
        return nil
    end
    if not o.Icon then o.Icon = itemName end

    if not o:validate() then
        ORGM.log(ORGM.ERROR, "ItemType: Validation checks failed for " .. itemName .. " (Registration Failed)")
        return false
    end

    local scriptItems = o:createScriptItems()
    if scriptItems then -- if its nil, we dont want a o.instance

        -- create our table to concat into a string
        local script = {"module " .. o.moduleName .. " {"}
        for _, item in ipairs(scriptItems) do
            -- every item is another table we need to concat
            table.insert(script, table.concat(item,"\r\n").."\r\n")
        end
        table.insert(script, '}\r\n')
        getScriptManager():ParseScript(table.concat(script, "\r\n"))

        o.instance = InventoryItemFactory.CreateItem(o.moduleName .. "." .. itemName)

        if not o.instance then
            ORGM.log(ORGM.ERROR, "ItemType: Could not create instance of " .. itemName .. " (Registration Failed)")
            return nil
        end
    end

    o._ItemTable[itemName] = o

    for gname, weight in pairs(o.Groups or template.Groups) do
        local group = o._GroupTable[gname]
        if group then
            group:add(itemName, weight)
        else
            ORGM.log(ORGM.WARN,"ItemType: " .. itemName .. " requested to join invalid group "..gname)
        end
    end
    for gname, weight in pairs(o.addGroups or {}) do
        group = o._GroupTable[gname]
        if group then
            group:add(itemName, weight)
        else
            ORGM.log(ORGM.WARN,"ItemType: " .. itemName .. " requested to join invalid group "..gname)
        end
    end

    ORGM.log(ORGM.DEBUG, "ItemType: Registered " .. itemName .. " --- ".. (o.instance and o.instance:getDisplayName() or ""))
    return o
end

--[[- Dummy function to be overwritten by sub-classes.

@treturn nil|table

]]
function ItemType:createScriptItems()
    return nil
end


--[[- Dummy function to be overwritten by sub-classes.

@treturn bool

]]
function ItemType:validate()
    return true
end

--[[- Finds all Groups this item is a direct member of.

@treturn table a table of group names (keys) and Group objects (values)

]]
function ItemType:getGroups()
    local results = {}
    for name, obj in pairs(self._GroupTable) do
        if obj:contains(self.type) then
            results[name] = obj
        end
    end
    return results
end


--[[- Tests if this item is a member of the specified Group

@tparam string|table groupType the string name of the group, or a Group object

@treturn table a table of group names (keys) and Group objects (values)

]]
function ItemType:isGroupMember(groupType)
    groupType = type(groupType) == 'table' and groupType or self._GroupTable[groupType]
    if groupType then return groupType:contains(self.type) end
end



--[[- Creates a new collection of ItemTypes

This method provides a way of calling `ItemType.new` multiple times, while passing the
same tempate. Its primarly used to create multiple variants of the same item.

@tparam string namePrefix a string to be prefixed on the name of every variant
@tparam table template the template table to be passed to `ItemType.new`
@tparam table variants a table containing sub-tables of itemData to be passed to `ItemType.new`

@treturn table a table of group names (keys) and Group objects (values)

]]
function ItemType:newCollection(namePrefix, template, variants)
    ORGM.log(ORGM.VERBOSE, "ItemType: Starting Collection ".. namePrefix)
    for variant, variantData in pairs(variants) do
        ItemType:new(namePrefix .. "_" .. variant, variantData, template)
    end
end
