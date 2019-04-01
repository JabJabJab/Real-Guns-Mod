--[[- Functions for dealing with ammo.


    @module ORGM.Ammo
    @copyright 2018 **File:** shared/2LoadOrder/ORGMAmmo.lua
    @author Fenris_Wolf
    @release 3.09
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

* UseWith = nil|table, the AmmoGroup names this ammo can be used for. if nil, the name parameter is used

* BoxCount = int, the number of rounds that come in a box.

* CanCount = int, the number of rounds that come in a canister.

* OptimalBarrel = int, the length of the barrel required to reach 'full powder burn'. This should generally be 30 for pistol calibers, 80 for rifle rounds, and 60 for shotguns.

* Recoil = int, the recoil factor applied to this round. Increased by shorter barrels.

* Range = int, the max effective range for this round, Reduced from shorter barrels.

@treturn bool true on success.

]]
Ammo.register = function(name, ammoData)
    ORGM.log(ORGM.DEBUG, "Ammo: Attempting to register ".. name)
    if ORGM.validateRegister(name, ammoData, AmmoTable) == false then
        return false
    end
    ammoData.moduleName = ammoData.moduleName or 'ORGM'
    local fullName = ammoData.moduleName .. "." .. name

    if type(ammoData.MinDamage) ~= 'number' then
        ORGM.log(ORGM.WARN, "Ammo: Invalid MinDamage for " .. fullName .. " is type ".. type(ammoData.MinDamage)..", setting to 0")
        ammoData.MinDamage = 0
    elseif ammoData.MinDamage < 0 then
        ORGM.log(ORGM.WARN, "Ammo: Invalid MinDamage for " .. fullName .. " is < 0, setting to 0")
        ammoData.MinDamage = 0
    end

    if type(ammoData.MaxDamage) ~= 'number' then
        ORGM.log(ORGM.WARN, "Ammo: Invalid MaxDamage for " .. fullName .. " is type ".. type(ammoData.MaxDamage)..", setting to MinDamage value ".. ammoData.MinDamage)
        ammoData.MaxDamage = ammoData.MinDamage
    elseif ammoData.MaxDamage < ammoData.MinDamage then
        ORGM.log(ORGM.WARN, "Ammo: Invalid MaxDamage for " .. fullName .. " is < MinDamage, setting to MinDamage value ".. ammoData.MinDamage)
        ammoData.MaxDamage = ammoData.MinDamage
    end

    if ammoData.Penetration == nil then
        ammoData.Penetration = false
    elseif type(ammoData.Penetration) == 'boolean' then
        -- do nothing
    elseif type(ammoData.Penetration) ~= 'number' then
        ORGM.log(ORGM.WARN, "Ammo: Invalid Penetration for " .. fullName .. " is type ".. type(ammoData.Penetration)..", expected boolean or integer, setting to false")
        ammoData.Penetration = false
    elseif ammoData.Penetration < 0 then
        ORGM.log(ORGM.WARN, "Ammo: Invalid Penetration for " .. fullName .. " is < 0, setting to false")
        ammoData.Penetration = false
    elseif ammoData.Penetration > 100 then
        ORGM.log(ORGM.WARN, "Ammo: Invalid Penetration for " .. fullName .. " is > 100, setting to true")
        ammoData.Penetration = true
    end


    if ammoData.PiercingBullets then -- NOTE: depreciated warning
        ORGM.log(ORGM.WARN, "Ammo: PiercingBullets for " .. fullName .. " is depreciated. Please use 'Penetration' instead.")
    end
    if ammoData.PiercingBullets == nil then
        ammoData.PiercingBullets = false
    elseif type(ammoData.PiercingBullets) == 'boolean' then
        -- do nothing
    elseif type(ammoData.PiercingBullets) ~= 'number' then
        ORGM.log(ORGM.WARN, "Ammo: Invalid PiercingBullets for " .. fullName .. " is type ".. type(ammoData.PiercingBullets)..", expected boolean or integer, setting to false")
        ammoData.PiercingBullets = false
    elseif ammoData.PiercingBullets < 0 then
        ORGM.log(ORGM.WARN, "Ammo: Invalid PiercingBullets for " .. fullName .. " is < 0, setting to false")
        ammoData.PiercingBullets = false
    elseif ammoData.PiercingBullets > 100 then
        ORGM.log(ORGM.WARN, "Ammo: Invalid PiercingBullets for " .. fullName .. " is > 100, setting to true")
        ammoData.PiercingBullets = true
    end

    if ammoData.MaxHitCount == nil then
        ammoData.MaxHitCount = 1
    elseif type(ammoData.MaxHitCount) ~= 'number' then
        ORGM.log(ORGM.WARN, "Ammo: Invalid MaxHitCount for " .. fullName .. " is type ".. type(ammoData.MaxHitCount)..", expected integer, setting to 1")
        ammoData.MaxHitCount = 1
    elseif ammoData.MaxHitCount ~= math.floor(ammoData.MaxHitCount) then
        ORGM.log(ORGM.WARN, "Ammo: Invalid MaxHitCount for " .. fullName .. " is float, expected integer, setting to "..math.floor(ammoData.MaxHitCount))
        ammoData.MaxHitCount = math.floor(ammoData.MaxHitCount)
    end
    if ammoData.MaxHitCount < 1 then
        ORGM.log(ORGM.WARN, "Ammo: Invalid MaxHitCount for " .. fullName .. " is < 1, setting to 1")
        ammoData.MaxHitCount = 1
    end

    if ammoData.UseWith == nil then
        ammoData.UseWith = { name }
    elseif type(ammoData.UseWith) == "string" then
        ammoData.UseWith = { ammoData.UseWith }
        ORGM.log(ORGM.WARN, "Ammo: UseWith for " .. fullName .. " is a string, converting to table")
    elseif type(ammoData.UseWith) ~= "table" then
        ORGM.log(ORGM.ERROR, "Ammo: Invalid UseWith for " .. fullName .. " is type: "..type(ammoData.UseWith) .." (expected string, table or nil)")
        return false
    end

    for _, ammo in ipairs(ammoData.UseWith) do
        if AmmoGroupTable[ammo] == nil then
            AmmoGroupTable[ammo] = { name }
        else
            table.insert(AmmoGroupTable[ammo], name)
        end
    end

    --[[
    -- autogeneration
    -- for some stupid reason, i can autogenerate the items, but not the matching recipes. Without the recipes working, this
    -- whole thing is damn near worthless....
    -- suppose this code could be used to auto build the script .txt files or something

    local rtype = ammoData.RoundType or "Round"
    local text = "module ORGM {\r\n"
    -- build ammo script item
    text = text .. "item "..name.."\r\n{\r\nCount = 1,\r\nType = Normal,\r\nDisplayCategory = Ammo,\r\nIcon = "..name..",\r\nDisplayName = "..ammoData.DisplayName.." "..rtype.. "s,\r\nWeight = "..ammoData.Weight.."\r\n}\r\n"
    -- build box script item
    text = text .. "item "..name.."_Box\r\n{\r\nCount = 1,\r\nType = Normal,\r\nDisplayCategory = Ammo,\r\nIcon = "..name.."_Box,\r\nDisplayName = "..ammoData.DisplayName.." - "..ammoData.BoxCount.. " " .. rtype.." Box,\r\nWeight = "..ammoData.Weight * ammoData.BoxCount.."\r\n}\r\n"
    -- build can scipt item
    text = text .. "item "..name.."_Can\r\n{\r\nCount = 1,\r\nType = Normal,\r\nDisplayCategory = Ammo,\r\nIcon = AmmoBox,\r\nDisplayName = "..ammoData.DisplayName.." - "..ammoData.CanCount.. " " .. rtype.." Can,\r\nWeight = "..ammoData.Weight * ammoData.CanCount.."\r\n}\r\n"
    -- box to rounds
    text = text.."\r\n}"
    getScriptManager():ParseScript(text)

    -- recipes dont seem to properly register using this method :\
    text = "module ORGM {\r\n"
    text = text .. "recipe Unbox "..ammoData.DisplayName.." "..rtype.."s\r\n{\r\n" .. name.."_Box,\r\n\r\nResult:"..name.."="..ammoData.BoxCount..",\r\nTime:5.0,\r\n}\r\n"
    -- rounds to box
    text = text .. "recipe Put in a box\r\n{\r\n" .. name.."="..ammoData.BoxCount .. ",\r\n\r\nResult:"..name.."_Box,\r\nTime:5.0,\r\n}\r\n"
    -- rounds to can
    text = text .. "recipe Put in a canister\r\n{\r\n" .. name.."="..ammoData.CanCount .. ",\r\n\r\nResult:"..name.."_Can,\r\nTime:10.0,\r\n}\r\n"
    -- boxes to can
    text = text .. "recipe Put in a canister\r\n{\r\n" .. name.."_Box="..ammoData.CanCount/ammoData.BoxCount .. ",\r\n\r\nResult:"..name.."_Can,\r\nTime:10.0,\r\n}\r\n"
    -- can to boxes
    text = text .. "recipe into boxes\r\n{\r\n" .. name.."_Can,\r\n\r\nResult:"..name.. "_Box="..ammoData.CanCount/ammoData.BoxCount..",\r\nTime:10.0,\r\n}\r\n"
    -- can to rounds
    text = text .. "recipe Empty out canister\r\n{\r\n" .. name.."_Can,\r\n\r\nResult:"..name.. "="..ammoData.CanCount..",\r\nTime:10.0,\r\n}\r\n"
    -- end the module
    text = text.."\r\n}"
    print(text)
    getScriptManager():ParseScript(text)
    ]]
    ammoData.instance = InventoryItemFactory.CreateItem(fullName)
    AmmoTable[name] = ammoData
    table.insert(AmmoKeyTable, name)
    ORGM.log(ORGM.DEBUG, "Ammo: Registered " .. fullName)
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
