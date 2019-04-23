--[[- Magazine Functions

This file contains functions for dealing with magazines and their data.


@module ORGM.Magazine
@author Fenris_Wolf
@release 4.0
@copyright 2018 **File:** shared/2LoadOrder/ORGMMagazines.lua
]]

local ORGM = ORGM
local Settings = ORGM.Settings
local Magazine = ORGM.Magazine
local MagazineGroup = Magazine.MagazineGroup
local MagazineType = Magazine.MagazineType
local Flags = Magazine.Flags
local Ammo = ORGM.Ammo
local getTableData = ORGM.getTableData

local ZombRand = ZombRand


local MagazineTable = { }
local MagazineKeyTable = { }
local MagazineGroupTable = { }

Flags.BOX = 1
Flags.TUBE = 2
Flags.DRUM = 4
Flags.CASKET = 8
Flags.STEEL = 16
Flags.POLYMER = 32
Flags.PEEKSTRIP = 64
Flags.BULK = 128
Flags.MATCHGRADE = 256

local PropertiesTable = {
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


function MagazineGroup:new(groupName, groupData)
    local o = { }
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
        ORGM.log(ORGM.ERROR, "MagazineGroup: Could not create instance of " .. groupName .. " (Registration Failed)")
    end
    MagazineGroupTable[groupName] = o
    o.instance = instance
    o.members = { }
    ORGM.log(ORGM.DEBUG, "MagazineGroup: Registered " .. groupName .. " (".. instance:getDisplayName()..")")
    return o
end

function MagazineGroup:normalize(typeModifiers, flagModifiers)
    local sum = 0
    typeModifiers = typeModifiers or {}
    for ammoType, weight in pairs(self.members) do
        sum = sum + weight * (typeModifiers[ammoType] or 1)
    end
    local members = {}
    for ammoType, weight in pairs(self.members) do
        members[ammoType] = self.members[ammoType] * (typeModifiers[ammoType] or 1) / sum
    end
    return members
end

function MagazineGroup:add(ammoType, weight)
    self.members[ammoType] = weight or 1
    --self:normalize()
end

function MagazineGroup:remove(ammoType)
    self.members[ammoType] = nil
    --self:normalize()
end

function MagazineGroup:random(typeModifiers, flagModifiers)
    local members = self.members
    members = self:normalize(typeModifers, flagModifiers)
    local sum = 0
    local roll = ZombRandFloat(0, 1)
    local result = nil
    for ammoType, weight in pairs(members) do
        sum = sum + weight
        if roll <= sum then
            result = ammoType
            break
        end
    end
    --ORGM.log(ORGM.VERBOSE, "MagazineGroup: random for ".. self.type .. " picked "..result)

    local group = MagazineGroupTable[result]
    if group then
        ORGM.log(ORGM.VERBOSE, "MagazineGroup: random for '".. self.instance:getDisplayName() .. "' picked '"..group.instance:getDisplayName() .."'")
        return group:random(typeModifiers, flagModifiers)
    end
    ORGM.log(ORGM.VERBOSE, "MagazineGroup: random for '".. self.instance:getDisplayName() .. "' picked '"..MagazineTable[result].instance:getDisplayName() .."'")
    return MagazineTable[result]
end

function MagazineGroup:spawn(typeModifiers, flagModifiers, container, loaded)
    local magazine = self:random(typeModifiers, flagModifiers)
    return magazine:spawn(container, loaded)
end

function MagazineGroup:contains(ammoType)
    ammoType = type(ammoType) == 'table' and ammoType.type or ammoType
    return self.members[ammoType] ~= nil
end


--[[- Finds the best matching magazine in a container.

Search is based on the given magazine name and preferred load
(can be specific round name, nil/any, or mixed), and the currentCapacity.

This is called when reloading some guns and all magazines.

Note magType and ammoType should NOT have the "ORGM." prefix.

@tparam string magType name of a magazine
@tparam nil|string ammoType 'any', 'mixed' or a specific ammo name
@tparam ItemContainer containerItem

@treturn nil|InventoryItem

]]
function MagazineGroup:find(ammoType, containerItem)

    if containerItem == nil then return nil end
    if ammoType == nil then ammoType = 'any' end
    local bestMagazine = nil
    local mostAmmo = -1
    -- TODO: this needs a extra loop here, for possible alternate magazines

    for magazineType, weight in pairs(self.members) do
        local items = containerItem:getItemsFromType(magazineType)
        for i = 0, items:size()-1 do repeat
            local currentItem = items:get(i)
            local modData = currentItem:getModData()
            if modData.currentCapacity == nil then -- magazine needs to be setup
                Magazine.setup(magData, currentItem)
            end
            if modData.currentCapacity <= mostAmmo then
                break
            end

            if ammoType ~= 'any' and ammoType ~= modData.loadedAmmoType then
                break
            end
            bestMagazine = currentItem
            mostAmmo = modData.currentCapacity
        until true end
    end
    return bestMagazine
end


Magazine.isGroup = function(groupName)
    return MagazineGroupTable[groupName] ~= nil
end

Magazine.getGroup = function(groupName)
    return MagazineGroupTable[groupName]
end


function MagazineType:new(magazineType, magazineData, template)
    local o = { }
    for key, value in pairs(magazineData) do o[key] = value end
    setmetatable(o, { __index = self })
    ORGM.log(ORGM.VERBOSE, "MagazineType: Initializing ".. magazineType)
    o.type = magazineType
    o.moduleName = 'ORGM'
    -- setup specific properties and error checks
    if not ORGM.copyPropertiesTable("MagazineType: ".. magazineType, PropertiesTable, template, o) then
        return nil
    end
    local scriptItems = { }
    table.insert(scriptItems,{
        "\titem " .. o.type,
        "\t{",
        "\t\tCanStack    =   FALSE,",
        "\t\tType = Normal,",
        "\t\tDisplayCategory = Ammo,",
        "\t\tDisplayName = "..o.type .. ",",
        "\t\tIcon = "..o.Icon .. ",",
        "\t\tWeight = "..o.Weight,
        "\t}",
    })
    ORGM.createScriptItems('ORGM', scriptItems)
    o.instance = InventoryItemFactory.CreateItem(o.moduleName .. "." .. magazineType)
    if not o.instance then
        ORGM.log(ORGM.ERROR, "MagazineType: Could not create instance of " .. magazineType .. " (Registration Failed)")
        return nil
    end

    MagazineTable[magazineType] = o
    ReloadUtil:addMagazineType(o)
    for group, weight in pairs(o.Groups or template.Groups) do
        group = MagazineGroupTable[group]
        if group then group:add(magazineType, weight) end
    end
    for group, weight in pairs(o.addGroups or {}) do
        group = MagazineGroupTable[group]
        if group then group:add(magazineType, weight) end
    end
    table.insert(MagazineKeyTable, magazineType)

    ORGM.log(ORGM.DEBUG, "MagazineType: Registered " .. magazineType .. " (".. o.instance:getDisplayName()..")")
    return o
end
function MagazineType:newCollection(magazineType, template, variants)
    ORGM.log(ORGM.VERBOSE, "MagazineType: Starting Collection ".. magazineType)
    for variant, variantData in pairs(variants) do
        MagazineType:new(magazineType .. "_" .. variant, variantData, template)
    end
end

function MagazineType:setup(item)
    --local magData = ReloadUtil:getClipData(magazineType)
    local modData = item:getModData()
    modData.type = self.type
    modData.moduleName = self.moduleName
    modData.reloadClass = self.reloadClass
    modData.ammoType = self.ammoType
    modData.loadStyle = self.reloadStyle
    modData.ejectSound = self.ejectSound
    modData.clickSound = self.clickSound
    modData.insertSound = self.insertSound
    modData.rackSound = self.rackSound
    modData.maxCapacity = self.maxCapacity
    modData.reloadTime = self.reloadTime
    modData.rackTime = self.rackTime
    modData.currentCapacity = 0
    modData.clipType = self.clipType
    modData.magazineData = { }
    modData.strictAmmoType = nil
    modData.loadedAmmoType = nil
    modData.BUILD_ID = ORGM.BUILD_ID
end

function MagazineType:spawn(container, loaded)
    local item = InventoryItemFactory.CreateItem("ORGM.".. self.type)
    self:setup(item)
    if loaded then
        local count = self.maxCapacity
        if ZombRand(100) < 50 then count = ZombRand(self.maxCapacity)+1 end
    end
    Magazine.refill(item, count)
    container:AddItem(item)
    return item
end


Magazine.refill = function(item, count, ammoType)
    local data = item:getModData()
    if ammoType then
        local ammoData = Ammo.getData(ammoType)
        if not ammoData:isGroupMember(data.ammoType) then return false end
    else
        local ammoGroup = Ammo.getGroup(data.ammoType)
        ammoType = ammoGroup:random().type
    end
    if not count then count = data.maxCapacity end
    for i=1, count do
        data.magazineData[i] = ammoType
    end
    data.currentCapacity = count
    data.loadedAmmoType = ammoType
end
--[[- Gets the table of registered magazines.

@treturn table all registered magazines setup by `ORGM.Magazine.register`

]]
Magazine.getTable = function()
    return MagazineTable
end


--[[- Gets the data of a registered magazine, supports module checking.

@tparam string|InventoryItem itemType
@tparam[opt] string moduleName module to compare

@treturn nil|table data of a registered magazine setup by `ORGM.Magazine.register`

]]
Magazine.getData = function(itemType, moduleName)
    return getTableData(itemType, moduleName, "InventoryItem", MagazineTable)
end


--[[- Checks if a item is a ORGM magazine.

@tparam string|InventoryItem itemType
@tparam[opt] string moduleName module to compare

@treturn bool true if it is a ORGM registered magazine

]]
Magazine.isMagazine = function(itemType, moduleName)
    if Magazine.getData(itemType, moduleName) then return true end
    return false
end


--[[- Sets up a magazine, applying key/values into the items modData.

This should be called whenever a magazine is spawned.

Basically the same as ReloadUtil:setupMagazine and ISORGMMagazine:setupReloadable
but called without needing a player or reloadable object.

@tparam table magData return value of `ORGM.Magazine.getData`
@tparam InventoryItem magItem

]]
Magazine.setup = function(magData, magItem)
    magData:setup(magItem)
end
