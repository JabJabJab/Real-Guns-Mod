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

setmetatable(MagazineGroup, { __index = ORGM.Group })
setmetatable(MagazineType, { __index = ORGM.ItemType })

MagazineGroup._GroupTable = MagazineGroupTable
MagazineGroup._ItemTable = MagazineTable

MagazineType._PropertiesTable = PropertiesTable
MagazineType._GroupTable = MagazineGroupTable
MagazineType._ItemTable = MagazineTable


function MagazineGroup:spawn(typeModifiers, filter, container, loaded)
    local magazine = self:random(typeModifiers, filter)
    return magazine:spawn(container, loaded)
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
            local magData = Magazine.getData(currentItem:getType())
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
    local o = ORGM.ItemType.new(self, magazineType, magazineData, template)
    o.clipType = o.type -- required by ISReloadUtil:getClipData and :setUpMagazine
    ReloadUtil:addMagazineType(o)
    return o
end

function MagazineType:createScriptItems()
    local scriptItems = { }
    table.insert(scriptItems,{
        "\titem " .. self.type,
        "\t{",
        "\t\tCanStack    =   FALSE,",
        "\t\tType = Normal,",
        "\t\tDisplayCategory = Ammo,",
        "\t\tDisplayName = "..self.type .. ",",
        "\t\tIcon = "..self.Icon .. ",",
        "\t\tWeight = "..self.Weight,
        "\t}",
    })
    return scriptItems
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
Magazine.findIn = function(magType, ammoType, containerItem)
    local group = MagazineGroupTable[magType]
    if not group then return end
    return group:find(ammoType, container, mode)
end
