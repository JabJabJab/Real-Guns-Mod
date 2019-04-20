--[[- Functions for dealing with ammo.


    @module ORGM.Ammo
    @copyright 2018 **File:** shared/2LoadOrder/ORGMAmmo.lua
    @author Fenris_Wolf
    @release 3.10
]]
local ORGM = ORGM
local Ammo = ORGM.Ammo
local Firearm = ORGM.Firearm
local Magazine = ORGM.Magazine
local getTableData = ORGM.getTableData

local table = table
local string = string
local ZombRand = ZombRand
local ipairs = ipairs
local instanceof = instanceof

local AmmoTable = { }
-- cache of names used for random selection
local AmmoKeyTable = { }

local AmmoGroupTable = { }

Ammo.Flags.RIMFIRE = 1 -- rimfire cartridge
Ammo.Flags.PISTOL = 2 -- 'pistol' calibers
Ammo.Flags.RIFLE = 4 -- 'rifle' calibers
Ammo.Flags.SHOTGUN = 8 -- shotgun shells
-- variant specific
Ammo.Flags.HOLLOWPOINT = 16 -- hollow point
Ammo.Flags.JACKETED = 32 -- jacketed, partial or full
Ammo.Flags.SOFTPOINT = 64 -- lead tipped bullet
Ammo.Flags.FLATPOINT = 128 -- flat tipped bullet
Ammo.Flags.MATCHGRADE = 256 -- high quality
Ammo.Flags.BULK = 512 -- cheap low quality
Ammo.Flags.SURPLUS = 1024 -- military, domestic or foreign
Ammo.Flags.SUBSONIC = 2048 -- subsonic ammo. cheap hack. this often depends on barrel length
Ammo.Flags.STEELCORE = 4096 -- solid steelcore

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
    Icon = {type='string', default=""},
    SpawnWeight = {type='float', min=0, default=1}
}

Ammo.registerGroup = function(name, groupData)
    -- autogeneration of script items
    local script = {
        "module ORGM {",
        "\titem " .. name,
        "\t{",
        "\t\tCount = 1,",
        "\t\tType = Normal,",
        "\t\tDisplayCategory = Ammo,",
        "\t\tDisplayName = ".. name .. ",",
        "\t}",
        "}",
    }
    getScriptManager():ParseScript(table.concat(script, "\r\n"))
    local instance = InventoryItemFactory.CreateItem("ORGM." .. name)
    if instance then
        AmmoGroupTable[name] = {}
        ORGM.log(ORGM.DEBUG, "AmmoGroup: Registered " .. name .. " (".. instance:getDisplayName()..")")
    else
        ORGM.log(ORGM.ERROR, "AmmoGroup: Could not create instance of " .. name .. " (Registration Failed)")
    end
end

Ammo.isGroup = function(groupName)
    return AmmoGroupTable[groupName] ~= nil
end



--[[- Registers a ammo type with ORGM.

This must be called before any registerMagazine or registerFirearm that plans to use that ammo.

NOTE: this should only be called with real ammo (ie: Ammo_9x19mm_FMJ) and not AmmoGroup (ie: Ammo_9x19mm)

@tparam string name name without module prefix.
@tparam table ammoData

Valid table keys/value pairs for the ammoData are:

* moduleName = string, module name this item is from. If nil, ORGM is used

* MinDamage = float, (>= 0) the min damage of the bullet. This overrides the firearm item MinDamage

* MaxDamage = float, (>= MinDamage) the max damage of the bullet. This overrides the firearm item MaxDamage

* Penetration = bool|int, (% chance) This overrides the firearm item PiercingBullets

* PiercingBullets = bool|int, (% chance) This overrides the firearm item PiercingBullets (DEPRECIATED, use Penetration)

* MaxHitCount = nil|int, This overrides the firearm item MaxHitCount. Only valid for firearms with multiple projectiles (ie: shotguns)

* Case = nil|string, the empty case to eject

* Groups = nil|table, the AmmoGroup names this ammo can be used for. if nil, the name parameter is used

* BoxCount = int, the number of rounds that come in a box.

* CanCount = int, the number of rounds that come in a canister.

* OptimalBarrel = int, the length of the barrel required to reach 'full powder burn'. This should generally be 30 for pistol calibers, 80 for rifle rounds, and 60 for shotguns.

* Recoil = int, the recoil factor applied to this round. Increased by shorter barrels.

* Range = int, the max effective range for this round, Reduced from shorter barrels.

@treturn bool true on success.

]]
Ammo.register = function(ammoType, ammoData)
    ORGM.log(ORGM.VERBOSE, "Ammo: Starting register ".. ammoType)
    --if ORGM.validateRegister(ammoType, ammoData, AmmoTable) == false then
    --    return false
    --end

    ammoData.moduleName = ammoData.moduleName or 'ORGM'

    if type(ammoData.Groups) ~= "table" then
        ORGM.log(ORGM.ERROR, "Ammo: Invalid Groups for " .. ammoType .. " is type: "..type(ammoData.Groups) .." (expected table)")
        return
    end

    local scriptItems = { }

    for variant, variantData in pairs(ammoData.variants) do repeat
        ORGM.log(ORGM.VERBOSE, "Ammo: Starting variant register ".. ammoType)
        local variantName = ammoType .. "_" .. variant
        variantData.moduleName = ammoData.moduleName
        local fullName = ammoData.moduleName .. "." .. variantName
        variantData.category = ammoData.category

        -- setup specific properties and error checks
        if not ORGM.copyPropertiesTable("Ammo: ".. variantName, PropertiesTable, ammoData, variantData) then
            break
        end

        -- autogeneration of script items
        table.insert(scriptItems, {
            "\titem " .. variantName,
            "\t{",
            "\t\tCount = 1,",
            "\t\tType = Normal,",
            "\t\tDisplayCategory = Ammo,",
            "\t\tDisplayName = "..variantName .. ",",
            "\t\tIcon = "..variantData.Icon .. ",",
            "\t\tWeight = "..variantData.Weight,
            "\t}"
        })
        table.insert(scriptItems, {
            "\titem " .. variantName .. "_Box",
            "\t{",
            "\t\tCount = 1,",
            "\t\tType = Normal,",
            "\t\tDisplayCategory = Ammo,",
            "\t\tDisplayName = "..variantName.. "_Box,",
            "\t\tIcon = "..variantData.Icon .. "_Box,",
            "\t\tWeight = "..variantData.Weight * variantData.BoxCount,
            "\t}",
        })
        table.insert(scriptItems, {
            "\titem " .. variantName .. "_Can",
            "\t{",
            "\t\tCount = 1,",
            "\t\tType = Normal,",
            "\t\tDisplayCategory = Ammo,",
            "\t\tDisplayName = "..variantName.. "_Can,",
            "\t\tIcon = AmmoBox,",
            "\t\tWeight = "..variantData.Weight * variantData.CanCount,
            "\t}",

        })
    until true end

    ORGM.createScriptItems('ORGM', scriptItems)
    for variantName, variantData in pairs(ammoData.variants) do
        variantName = ammoType .. "_" .. variantName
        variantData.instance = InventoryItemFactory.CreateItem(variantData.moduleName .. "." .. variantName)
        if variantData.instance then
            AmmoTable[variantName] = variantData
            for _, group in ipairs(ammoData.Groups) do
                table.insert(AmmoGroupTable[group], variantName)
            end
            table.insert(AmmoKeyTable, variantName)
            ORGM.log(ORGM.DEBUG, "Ammo: Registered variant " .. variantName .. " (".. variantData.instance:getDisplayName()..")")
        else
            ORGM.log(ORGM.ERROR, "Ammo: Could not create instance of " .. variantName .. " (Registration Failed)")
        end
    end
    return true
end


--[[- Deregisters Ammo from ORGM.

WARNING: Incomplete code, do not use.

    @tparam string name name without module prefix

    @treturn bool true on success

]]
Ammo.deregister = function(name)
    if AmmoTable[name] == nil then
        ORGM.log(ORGM.WARN, "Ammo: Failed to deregister " .. name .. " (Item not previously registered)")
        return false
    end
    -- TODO: remove all instances from the AmmoGroupTable values
    AmmoTable[name] = nil
    ORGM.tableRemove(AmmoKeyTable, name)
    ORGM.log(ORGM.DEBUG, "Ammo: Deregistered " .. name)
    return true
end


--[[- Returns the name of a random ammo item.

@tparam[opt] table thisTable table to select from.

@treturn string the random ammo name.

]]
Ammo.random = function(thisTable)
    if not thisTable then thisTable = AmmoKeyTable end
    return thisTable[ZombRand(#thisTable) +1]
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
    if gun then mag = gun.clipData end -- check if it might be a mag
    if mag then
        return asTable and Ammo.getGroup(mag.ammoType) or mag.ammoType
    end
    if not gun then return nil end
    return asTable and Ammo.getGroup(gun.ammoType) or gun.ammoType
    --return item:getAmmoType()
end


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
    if ammoGroup == nil then return nil end
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

    -- this shouldn't actually be here, self.ammoType is just a AmmoGroup round
    local round = container:FindAndReturn(ammoGroup .. suffex)
    if round then return round end

    -- check if there are alternate ammo types we can use
    local groupTable = Ammo.getGroup(ammoGroup)
    -- there should always be a entry, unless we were given a bad ammoGroup
    if groupTable == nil then return nil end

    if ammoType == 'mixed' then
        local options = {}
        for _, value in ipairs(groupTable) do
            -- check what rounds the player has
            if container:FindAndReturn(value .. suffex) then table.insert(options, value .. suffex) end
        end
        -- randomly pick one
        return container:FindAndReturn(options[ZombRand(#options) + 1])

    else -- not a random picking, go through the list in order
        for _, value in ipairs(groupTable) do
            round = container:FindAndReturn(value .. suffex)
            if round then return round end
        end
    end
    if round then return round end
    return nil
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
