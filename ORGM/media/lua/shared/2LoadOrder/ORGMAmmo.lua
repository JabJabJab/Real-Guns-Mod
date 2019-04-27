--[[- Functions for dealing with ammo.


    @module ORGM.Ammo
    @copyright 2018 **File:** shared/2LoadOrder/ORGMAmmo.lua
    @author Fenris_Wolf
    @release 4.0
]]
local ORGM = ORGM
local Ammo = ORGM.Ammo
local Flags = Ammo.Flags
local AmmoGroup = Ammo.AmmoGroup
local AmmoType = Ammo.AmmoType

local Bit = BitNumber.bit32
local Firearm = ORGM.Firearm
local Magazine = ORGM.Magazine
local getTableData = ORGM.getTableData
local table = table
local string = string
local ZombRand = ZombRand
local ipairs = ipairs
local instanceof = instanceof

local AmmoTable = { }
local AmmoGroupTable = { }

Flags.RIMFIRE = 1 -- rimfire cartridge
Flags.PISTOL = 2 -- 'pistol' calibers
Flags.RIFLE = 4 -- 'rifle' calibers
Flags.SHOTGUN = 8 -- shotgun shells
-- variant specific
Flags.HOLLOWPOINT = 16 -- hollow point
Flags.JACKETED = 32 -- jacketed, partial or full
Flags.SOFTPOINT = 64 -- lead tipped bullet
Flags.FLATPOINT = 128 -- flat tipped bullet
Flags.MATCHGRADE = 256 -- high quality
Flags.BULK = 512 -- cheap low quality
Flags.SURPLUS = 1024 -- military, domestic or foreign
Flags.SUBSONIC = 2048 -- subsonic ammo. cheap hack. this often depends on barrel length
Flags.STEELCORE = 4096 -- solid steelcore
Flags.BIRDSHOT = 8192 --
Flags.BUCKSHOT = 16384 --
Flags.SLUG = 32768 --

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
setmetatable(AmmoGroup, { __index = ORGM.Group })
setmetatable(AmmoType, { __index = ORGM.ItemType })

AmmoGroup._GroupTable = AmmoGroupTable
AmmoGroup._ItemTable = AmmoTable
AmmoType._PropertiesTable = PropertiesTable
AmmoType._GroupTable = AmmoGroupTable
AmmoType._ItemTable = AmmoTable

--[[- Finds the best matching ammo (bullets only) in a container.

Finds loose bullets, boxes and canisters of ammo.
Search is based on the given ammoGroup name and preferred type.
(can be specific round name, nil/any, or mixed)

This is called when reloading some guns and all magazines.

Note ammoGroup and ammoType should NOT have the "ORGM." prefix.

@tparam string ammoGroup name of a AmmoGroup.
@tparam nil|string ammoType 'any', 'mixed' or a specific ammo name
@tparam ItemContainer container
@tparam[opt] nil|int mode 0 = rounds, 1 = box, 2 = can

@treturn nil|InventoryItem

]]
function AmmoGroup:find(ammoType, container, mode)

    if container == nil then return nil end
    if ammoType == nil then ammoType = 'any' end

    local suffex = ""
    if mode == 1 then
        suffex = "_Box"
    elseif mode == 2 then
        suffex = "_Can"
    end
    if ammoType ~= "any" and ammoType ~= 'mixed' then
        -- a preferred ammo is set, we only look for these bullets
        return container:FindAndReturn(ammoType .. suffex)
    end
    local round
    -- NOTE: There should be a check here to see if there our dummy AmmoGroup_ InventoryItem
    -- is in the container.
    --local round = container:FindAndReturn(self.type .. suffex)
    --if round then return round end
    if self.members == nil then
        return nil
    end

    if ammoType == 'mixed' then
        local options = {}
        for name, weight in ipairs(self.member) do
            -- check what rounds the player has
            if container:FindAndReturn(value .. suffex) then table.insert(options, value .. suffex) end
        end
        -- randomly pick one
        return container:FindAndReturn(options[ZombRand(#options) + 1])

    else -- not a random picking, go through the list in order
        for name, weight in pairs(self.members) do
            round = container:FindAndReturn(name .. suffex)
            if round then
                 return round
            end
        end
    end
    if round then
        return round
    end
    return nil
end



Ammo.randomFromGroup = function(group)
    group = AmmoGroupTable[group]
    if not group then return end
    return group:random()
end

Ammo.newGroup = function(groupName, groupData)
    AmmoGroup:new(groupName, groupData)
end

Ammo.isGroup = function(groupName)
    return AmmoGroupTable[groupName] ~= nil
end

--[[- Gets the table of ammo groups.

@treturn table keys are group names, values are table arrays of ammo names.

]]
Ammo.getGroupTable = function()
    return AmmoGroupTable
end


--[[- Returns the ammo group table for the specified groupName.

The table contains all the ammo types that can be used for this group.

@tparam string groupName name of a ammo group

@treturn nil|table list of real ammo names

]]
Ammo.getGroup = function(groupName)
    return AmmoGroupTable[groupName]
end


--[[-  Gets the ammoGroup string name or table of valid ammo for this item.

@tparam string|InventoryItem item
@tparam[opt] nil|bool asTable true if the results returned should be a table

@treturn string|table ammo group name, or a table list of strings

]]
Ammo.itemGroup = function(item, asTable)
    local gun = Firearm.getData(item)
    local mag = Magazine.getData(item)
    local ammoType = gun and gun.ammoType or nil
    if ammoType and Magazine.isGroup(ammoType) then
        -- gun uses mags
        ammoType = Magazine.getGroup(ammoType).ammoType
    elseif mag then
        ammoType = mag.ammoType
    end
    if ammoType then
        return asTable and Ammo.getGroup(ammoType) or ammoType
    end
end


function AmmoType:createScriptItems()
    local scriptItems = { }
    table.insert(scriptItems, {
        "\titem " .. self.type,
        "\t{",
        "\t\tCount = 1,",
        "\t\tType = Normal,",
        "\t\tDisplayCategory = Ammo,",
        "\t\tDisplayName = "..self.type .. ",",
        "\t\tIcon = "..self.Icon .. ",",
        "\t\tWeight = "..self.Weight,
        "\t}"
    })
    table.insert(scriptItems, {
        "\titem " .. self.type .. "_Box",
        "\t{",
        "\t\tCount = 1,",
        "\t\tType = Normal,",
        "\t\tDisplayCategory = Ammo,",
        "\t\tDisplayName = "..self.type.. "_Box,",
        "\t\tIcon = "..self.Icon .. "_Box,",
        "\t\tWeight = "..self.Weight * self.BoxCount,
        "\t}",
    })
    table.insert(scriptItems, {
        "\titem " .. self.type .. "_Can",
        "\t{",
        "\t\tCount = 1,",
        "\t\tType = Normal,",
        "\t\tDisplayCategory = Ammo,",
        "\t\tDisplayName = "..self.type.. "_Can,",
        "\t\tIcon = AmmoBox,",
        "\t\tWeight = "..self.Weight * self.CanCount,
        "\t}",
    })
    return scriptItems
end



function AmmoType:isRimfire()
    return Bit.band(self.category, Flags.RIMFIRE) ~= 0
end
function AmmoType:isPistol()
    return Bit.band(self.category, Flags.PISTOL) ~= 0
end
function AmmoType:isRifle()
    return Bit.band(self.category, Flags.RIFLE) ~= 0
end
function AmmoType:isPistol()
    return Bit.band(self.category, Flags.SHOTGUN) ~= 0
end

function AmmoType:isHollowPoint()
    return Bit.band(self.features, Flags.HOLLOWPOINT) ~= 0
end
function AmmoType:isJacketed()
    return Bit.band(self.features, Flags.JACKETED) ~= 0
end
function AmmoType:isSoftPoint()
    return Bit.band(self.features, Flags.SOFTPOINT) ~= 0
end
function AmmoType:isFlatPoint()
    return Bit.band(self.features, Flags.FLATPOINT) ~= 0
end
function AmmoType:isMatchGrade()
    return Bit.band(self.features, Flags.MATCHGRADE) ~= 0
end
function AmmoType:isBulk()
    return Bit.band(self.features, Flags.BULK) ~= 0
end
function AmmoType:isSurplus()
    return Bit.band(self.features, Flags.SURPLUS) ~= 0
end
function AmmoType:isSubsonic()
    return Bit.band(self.features, Flags.SUBSONIC) ~= 0
end
function AmmoType:isSteelCore()
    return Bit.band(self.features, Flags.STEELCORE) ~= 0
end


--[[- Gets the table of registered ammo.

@treturn table all registered ammo setup by `ORGM.Ammo.register`

]]
Ammo.getTable = function()
    return AmmoTable
end


--[[- Gets a value from the AmmoTable, supports module checking.

@tparam string|InventoryItem itemType
@tparam[opt] string moduleName module to compare

@treturn table data of a registered ammo setup by `ORGM.Ammo.register`

]]
Ammo.getData = function(itemType, moduleName)
    return getTableData(itemType, moduleName, "InventoryItem", AmmoTable)
end


--[[- Checks if a item is ORGM ammo.

@tparam string|InventoryItem itemType
@tparam[opt] string moduleName module to compare

@treturn bool true if registered ammo setup by `ORGM.Ammo.register`

]]
Ammo.isAmmo = function(itemType, moduleName)
    if Ammo.getData(itemType, moduleName) then return true end
    return false
end

--[[- Checks if a item is ORGM spent casing.

@tparam string|InventoryItem itemType

@treturn bool

]]
Ammo.isCase = function(itemType)
    -- TODO: this needs a far more robust system....
    if itemType:sub(1, 5) == "Case_" then return true end
    return false
end

-- TODO: mostly below here should be redundant, convert these to new OO format

--[[- Finds the best matching ammo (bullets only) in a container.

Finds loose bullets, boxes and canisters of ammo.
Search is based on the given ammoGroup name and preferred type.
(can be specific round name, nil/any, or mixed)

This is called when reloading some guns and all magazines.

Note ammoGroup and ammoType should NOT have the "ORGM." prefix.

@tparam string ammoGroup name of a AmmoGroup.
@tparam nil|string ammoType 'any', 'mixed' or a specific ammo name
@tparam ItemContainer container
@tparam[opt] nil|int mode 0 = rounds, 1 = box, 2 = can

@treturn nil|InventoryItem

]]
Ammo.findIn = function(ammoGroup, ammoType, container, mode)
    ammoGroup = AmmoGroupTable[ammoGroup]
    if ammoGroup == nil then return nil end
    return ammoGroup:find(ammoType, container, mode)
end


--[[- Finds and returns all ammo for the ammoGroup in the container,
including boxes and canisters.

@tparam string ammoGroup the name of a AmmoGroup
@tparam ItemContainer containerItem

@treturn table keys are 'rounds', 'boxes' and 'cans', values are java ArrayList objects of InventoryItem objects

]]
Ammo.findAllIn = function(ammoGroup, containerItem)
    if ammoGroup == nil then return nil end
    if containerItem == nil then return nil end

    -- check if there are alternate ammo types we can use
    local groupTable = Ammo.getGroup(ammoGroup)
    -- there should always be a entry, unless we were given a bad ammoGroup
    if groupTable == nil then
        if Ammo.isAmmo(ammoGroup) then
            groupTable = {ammoGroup}
        else
            return nil
        end
    end
    local results = {
        rounds = container:FindAll(table.concat(groupTable, "/")),
        boxes = container:FindAll(table.concat(groupTable, "_Box/").."_Box"),
        cans = container:FindAll(table.concat(groupTable, "_Can/").."_Can"),
    }
    return results
end


--[[- Converts all AmmoGroup rounds of the given name to real ammo.

The first entry in the AmmoGroupTable for this name will be used
Note groupName and preferredType should NOT have the "ORGM." prefix.

@tparam string groupName the name of a AmmoGroup
@tparam ItemContainer containerItem

@treturn nil|int number of rounds converted (nil on error)

]]
Ammo.convertAllIn = function(groupName, containerItem)
    if groupName == nil then return nil end
    if containerItem == nil then return nil end
    local groupTable = Ammo.getGroup(groupName)
    -- there should always be a entry, unless we were given a bad groupName
    if groupTable == nil then
        ORGM.log(ORGM.ERROR, "Ammo: Tried to convert invalid AmmoGroup round ".. groupName)
        return nil
    end
    local count = containerItem:getNumberOfItem(groupName)
    if count == nil or count == 0 then return 0 end
    containerItem:RemoveAll(groupName)

    containerItem:AddItems(groupTable[1].moduleName .. groupTable[1], count)
    return count
end


--[[- Returns the type of ammo opening a box (or can) will yeild.

This assumes a strict naming convention was used for the ammo and Unboxes.

ie: ORGM standard names: Ammo_9x19mm_FMJ and Ammo_9x19mm_FMJ_Box

@tparam string|InventoryItem item the box or canister.

@treturn nil|string name of ammo inside the container.

]]
Ammo.boxType = function(item)
    if instanceof(item, "InventoryItem") then
        item = item:getType()
    end
    item = string.sub(item, 1, -5)
    if Ammo.isAmmo(item) then return item end
    return nil
end


--[[- Unboxes a box (or canister), placing all rounds in the container.

@tparam InventoryItem item the item to be unboxed.

]]
Ammo.unbox = function(item)
    local container = item:getContainer()
    local ammoType = Ammo.boxType(item)
    if not ammoType or not container then return end
    local boxType = string.sub(item:getType(), -3)
    local ammoData = Ammo.getData(ammoType)
    if ammoData and boxType == "Box" then
        container:AddItems(ammoType, ammoData.BoxCount or 0)
    elseif ammoData and boxType == "Can" then
        container:AddItems(ammoType, ammoData.CanCount or 0)
    else
        return
    end
    container:Remove(item)
end
-- ORGM[13] = "4\07052474\068"
