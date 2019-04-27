local Group = ORGM.Group
local ItemType = ORGM.ItemType

function Group:new(groupName, groupData)
    -- need message prefix, table to insert into
    local o = { }
    o._size = 0
    for key, value in pairs(groupData or {}) do o[key] = value end
    setmetatable(o, { __index = self })
    o.type = groupName
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
    local instance = InventoryItemFactory.CreateItem("ORGM." .. groupName)
    if not instance then
        ORGM.log(ORGM.ERROR, "Group: Could not create instance of " .. groupName .. " (Registration Failed)")
    end

    for group, weight in pairs(o.Groups or { }) do
        group = o._GroupTable[group]
        if group then group:add(groupName, weight) end
    end
    o._GroupTable[groupName] = o

    o.instance = instance
    o.members = { }
    ORGM.log(ORGM.VERBOSE, "Group: Registered " .. groupName .. " (".. instance:getDisplayName()..")")
    return o
end


function Group:normalize(typeModifiers, filter)
    local sum = 0
    typeModifiers = typeModifiers or {}
    for itemType, weight in pairs(self.members) do
        local mod = (typeModifiers[itemType] or 1) + (filter and filter(self, itemType, weight) or 0)
        sum = sum + weight * mod
    end
    local members = {}
    for itemType, weight in pairs(self.members) do
        members[itemType] = self.members[itemType] * (typeModifiers[itemType] or 1) / sum
    end
    return members
end


function Group:add(itemType, weight)
    if not self.members[itemType] then self._size = 1 + self._size end
    self.members[itemType] = weight or 1
end

function Group:remove(itemType)
    if self.members[itemType] then self._size = self._size - 1 end
    self.members[itemType] = nil
end

function Group:random(typeModifiers, filter, depth)
    local members = self.members
    members = self:normalize(typeModifiers, filter)
    if depth == nil then depth = 0 end
    if depth > 20 then return nil end
    depth = 1+depth
    local sum = 0
    local roll = ZombRandFloat(0,1)
    local result = nil
    for itemType, weight in pairs(members) do
        sum = sum + weight
        if roll <= sum then
            result = itemType
            break
        end
    end
    --ORGM.log(ORGM.VERBOSE, "FirearmGroup: random for ".. self.type .. " picked "..result)

    local group = self._GroupTable[result]
    if group then
        ORGM.log(ORGM.VERBOSE, "Group: random for '".. self.instance:getDisplayName() .. "' picked '"..group.instance:getDisplayName() .."'")
        return group:random(typeModifiers, filter, depth)
    end
    local result = self._ItemTable[result]
    ORGM.log(ORGM.VERBOSE, "Group: random for '".. self.instance:getDisplayName() .. "' picked '"..(result and result.instance:getDisplayName() or "nil").."'")
    return result --dataTable[result]
end

function Group:contains(itemType)
    itemType = type(itemType) == 'table' and itemType.type or itemType
    return self.members[itemType] ~= nil
end


function ItemType:new(itemType, itemData, template)
    local o = { }
    template = template or {}
    for key, value in pairs(itemData) do o[key] = value end
    setmetatable(o, { __index = self })
    ORGM.log(ORGM.VERBOSE, "ItemType: Initializing ".. itemType)
    o.type = itemType
    o.moduleName = 'ORGM'
    -- setup specific properties and error checks
    if not ORGM.copyPropertiesTable("ItemType: ".. itemType, o._PropertiesTable, template, o) then
        return nil
    end
    if not o.Icon then o.Icon = itemType end

    if not o:validate() then
        ORGM.log(ORGM.ERROR, "ItemType: Validation checks failed for " .. itemType .. " (Registration Failed)")
        return false
    end

    local scriptItems = o:createScriptItems()
    ORGM.createScriptItems('ORGM', scriptItems)
    o.instance = InventoryItemFactory.CreateItem(o.moduleName .. "." .. itemType)

    if not o.instance then
        ORGM.log(ORGM.ERROR, "ItemType: Could not create instance of " .. itemType .. " (Registration Failed)")
        return nil
    end

    o._ItemTable[itemType] = o

    for group, weight in pairs(o.Groups or template.Groups) do
        group = o._GroupTable[group]
        if group then group:add(itemType, weight) end
    end
    for group, weight in pairs(o.addGroups or {}) do
        group = o._GroupTable[group]
        if group then group:add(itemType, weight) end
    end
    ORGM.log(ORGM.DEBUG, "ItemType: Registered " .. itemType .. " (".. o.instance:getDisplayName()..")")
    return o
end

function ItemType:createScriptItems()
    return { }
end

function ItemType:validate()
    return true
end

function ItemType:getGroups()
    local results = {}
    for name, obj in pairs(self._GroupTable) do
        if obj:contains(self.type) then
            results[name] = obj
        end
    end
    return results
end


function ItemType:isGroupMember(groupType)
    groupType = type(groupType) == 'table' and groupType or self._GroupTable[groupType]
    if groupType then return groupType:contains(self.type) end
end


function ItemType:newCollection(itemType, template, variants)
    ORGM.log(ORGM.VERBOSE, "ItemType: Starting Collection ".. itemType)
    for variant, variantData in pairs(variants) do
        self:new(itemType .. "_" .. variant, variantData, template)
    end
end
