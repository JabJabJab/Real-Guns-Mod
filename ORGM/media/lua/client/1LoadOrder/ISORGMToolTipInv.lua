--[[- Override for ISToolTipInv.

    Some modifications need to be done to the tooltip rendering process to handle our custom
    tooltips. Weapon tooltips have their size and position coded in LUA ISToolTipInv:render(), but
    the data contained is hardcoded in java, and drawn with the item:DoTooltip() method.

    ORGM overwrites ISToolTipInv:render() and bypasses the call to item:DoTooltip() allowing for
    completely moddable tooltips. Our new

    File: client/1LoadOrder/ISORGMToolTipInv.lua
    @classmod ISToolTipInv
    @author Fenris_Wolf
    @release 3.09

]]

require 'ISUI/ISToolTipInv'

local ORGM = ORGM
local Firearm = ORGM.Firearm
local Component = ORGM.Component
local Ammo = ORGM.Ammo
local Magazine = ORGM.Magazine
local Settings = ORGM.Settings

local getMouseX = getMouseX
local getMouseY = getMouseY
local getText = getText
local tostring = tostring
local pairs = pairs
local string = string

-- store our original function in a local variable that we'll call later
local render = ISToolTipInv.render

local TipHandler = { }

local function colorScale(value, default)
    --if value < 0 then value = 0 end
    --if value > 1 then value = 1 end
    local c = {["r"] = 1.0, ["g"] = 1.0, ["b"] = 8.0}
    if default then return c end

    c.r = 1-value
    c.g = value
    c.b = 0
    return c
end

local function round(value, places)
    return string.format("%." .. (places or 0) .. "f", value)
end

local function setLayoutItem(layout, label, value, color, asProgress)
    if not color then color = {["r"] = 1.0, ["g"] = 1.0, ["b"] = 1.0} end
    layoutItem = layout:addItem()
    layoutItem:setLabel(label, 1.0, 1.0, 0.8, 1.0)
    if asProgress then
        layoutItem:setProgress(value, color.r, color.g, color.b, 1)
    else
        layoutItem:setValue(value, color.r, color.g, color.b, 1.0)
        --layoutItem:setValue(round(damage, roundPrecision), color.r, color.g, color.b, 1)
    end
end

local function initializeStyle(toolTipStyle, aimingPerk)
    local noColor = (aimingPerk <= 3 and toolTipStyle ~= ORGM.TIPFULL)
    local isNumeric = (aimingPerk > 7 and toolTipStyle == ORGM.TIPDYNAMIC) or toolTipStyle == ORGM.TIPNUMERIC
    local roundPrecision = (toolTipStyle == ORGM.TIPDYNAMIC and 6-(10-aimingPerk)*2 or 6)
    return noColor, isNumeric, roundPrecision
end

local function initializeTip(self)
    -- translated from the java when executing self.item:DoTooltip(self.tooltip)
    self.tooltip:render()
    local i = self.tooltip:getLineSpacing()
    local y = 5
    self.tooltip:DrawText(self.tooltip:getFont(), self.item:getName(), 5, y, 1, 1, 0.8, 1)
    self.tooltip:adjustWidth(5, self.item:getName())
    y = y + i + 5
    local layout = self.tooltip:beginLayout()
    layout:setMinLabelWidth(80)
    return layout, y, i
end

local function finalizeTip(self, layout, y, i)
    ----------------------------------------------------------
    y = layout:render(5, y, self.tooltip)
    self.tooltip:endLayout(layout)
    if self.item:getTooltip() then
        y = y + i + 5
        local text = getText(self.item:getTooltip())
        self.tooltip:DrawText(self.tooltip:getFont(), text, 5, y, 1, 1, 0.8, 1)
        self.tooltip:adjustWidth(5, text)
    end

    y = y+ i-- j = j+ self.tooltip.padBottom; -- ??
    self.tooltip:setHeight(y)
    if self.tooltip:getWidth() < 150 then
        self.tooltip:setWidth(150)
    end

end

TipHandler[ORGM.AMMO] = function(self)
    local item = self.item
    local ammoData = Ammo.getData(item)
    local player = getPlayer()
    local aimingPerk = player:getPerkLevel(Perks.Aiming)
    local toolTipStyle = Settings.ToolTipStyle
    local noColor, isNumeric, roundPrecision = initializeStyle(toolTipStyle, aimingPerk)
    local layout, y, i = initializeTip(self)

    ----------------------------------------------------------
    -- show weight
    local weight = item:getUnequippedWeight()
    if item:isEquipped() then weight = item:getEquippedWeight() end
    setLayoutItem(layout, getText("Tooltip_item_Weight").. ":", round(weight, 3))

    ----------------------------------------------------------
    -- Damage
    if (aimingPerk > 0 or toolTipStyle ~= ORGM.TIPDYNAMIC) then
        local damage = ammoData.MinDamage*Settings.DamageMultiplier or 0
        local color = colorScale(damage/(3.0*Settings.DamageMultiplier), noColor)
        setLayoutItem(layout, getText("Tooltip_Firearm_MinDamage"),
            isNumeric and round(damage, roundPrecision) or damage/(3.0*Settings.DamageMultiplier),
            color, not isNumeric)

        damage = ammoData.MaxDamage*Settings.DamageMultiplier or 0
        color = colorScale(damage/(3.0*Settings.DamageMultiplier), noColor)
        setLayoutItem(layout, getText("Tooltip_Firearm_MaxDamage"),
            isNumeric and round(damage, roundPrecision) or damage/(3.0*Settings.DamageMultiplier),
            color, not isNumeric)
    end

    ----------------------------------------------------------
    -- Range
    if (aimingPerk > 1 or toolTipStyle ~= ORGM.TIPDYNAMIC) then
        local range = ammoData.Range or 0
        local color = colorScale(range/50, noColor)
        setLayoutItem(layout, getText("Tooltip_Firearm_Range"),
            isNumeric and round(range, roundPrecision) or range/50,
            color, not isNumeric)
    end

    ----------------------------------------------------------
    -- Recoil
    if (aimingPerk > 0 or toolTipStyle ~= ORGM.TIPDYNAMIC) then
        local recoil = ammoData.Recoil or 0
        local color = colorScale(1-recoil/50, noColor)
        setLayoutItem(layout, getText("Tooltip_Firearm_Recoil"),
            isNumeric and tostring(recoil) or recoil/50,
            color, not isNumeric)
    end

    ----------------------------------------------------------
    -- TODO: add FMJ/HP text, suspicious looking ammo hints
    finalizeTip(self, layout, y, i)
end

TipHandler[ORGM.COMPONENT] = function(self)
    local item = self.item
    local compData = Component.getData(item)
    local modData = item:getModData()
    local player = getPlayer()
    local aimingPerk = player:getPerkLevel(Perks.Aiming)
    local toolTipStyle = Settings.ToolTipStyle
    local noColor, isNumeric, roundPrecision = initializeStyle(toolTipStyle, aimingPerk)
    local layout, y, i = initializeTip(self)

    ----------------------------------------------------------
    -- show weight
    local weight = item:getUnequippedWeight()
    if item:isEquipped() then weight = item:getEquippedWeight() end
    setLayoutItem(layout, getText("Tooltip_item_Weight").. ":", round(weight, 3))

    if compData.HitChance then
        local color = colorScale((compData.HitChance+30)/60, noColor)
        setLayoutItem(layout, getText("Tooltip_Firearm_HitChance"),
            isNumeric and tostring(compData.HitChance) or (compData.HitChance+30)/60,
            color, not isNumeric)
    end
    if compData.CriticalChance then
        local color = colorScale((compData.CriticalChance+40)/80, noColor)
        setLayoutItem(layout, getText("Tooltip_Firearm_Critical"),
            isNumeric and tostring(compData.CriticalChance) or (compData.CriticalChance+40)/80,
            color, not isNumeric)
    end

    if compData.MaxRange then
        local color = colorScale((compData.MaxRange+40)/80, noColor)
        setLayoutItem(layout, getText("Tooltip_Firearm_Range"),
            isNumeric and tostring(compData.MaxRange) or (compData.MaxRange+40)/80,
            color, not isNumeric)
    end

    if compData.AimingTime then
        local color = colorScale((compData.AimingTime+40)/80, noColor)
        setLayoutItem(layout, getText("Tooltip_Firearm_AimTime"),
            isNumeric and tostring(compData.AimingTime) or (compData.AimingTime+40)/80,
            color, not isNumeric)
    end

    if compData.SwingTime then
        local color = colorScale(1-((compData.SwingTime+1.5)/3), noColor)
        setLayoutItem(layout, getText("Tooltip_Firearm_SwingTime"),
            isNumeric and tostring(compData.SwingTime) or (compData.SwingTime+1.5)/3,
            color, not isNumeric)
    end

    if compData.RecoilDelay then
        local color = colorScale(1-((compData.RecoilDelay+15)/30), noColor)
        setLayoutItem(layout, getText("Tooltip_Firearm_Recoil"),
            isNumeric and tostring(compData.RecoilDelay) or (compData.RecoilDelay+15)/30,
            color, not isNumeric)
    end

    ----------------------------------------------------------
    finalizeTip(self, layout, y, i)
end

TipHandler[ORGM.MAGAZINE] = function(self)
    local item = self.item
    local magData = Magazine.getData(item)
    local modData = item:getModData()
    local player = getPlayer()
    local aimingPerk = player:getPerkLevel(Perks.Aiming)
    local toolTipStyle = Settings.ToolTipStyle
    local noColor, isNumeric, roundPrecision = initializeStyle(toolTipStyle, aimingPerk)
    local layout, y, i = initializeTip(self)
    ----------------------------------------------------------
    -- show weight
    local weight = item:getUnequippedWeight()
    if item:isEquipped() then weight = item:getEquippedWeight() end
    setLayoutItem(layout, getText("Tooltip_item_Weight").. ":", round(weight, 3))

    ----------------------------------------------------------

    local ammoType = Ammo.itemGroup(item) --item:getAmmoType()
    --local ammoType = modData.defaultAmmo
    local ammoItem = getScriptManager():FindItem(ammoType)
    if not ammoItem then
        ammoItem = getScriptManager():FindItem(item:getModule() .. ".".. ammoType)
    end
    setLayoutItem(layout, getText("Tooltip_weapon_Ammo").. ":", ammoItem:getDisplayName())

    ----------------------------------------------------------
    -- preferredAmmoType
    local preferredAmmoType = modData.preferredAmmoType
    if preferredAmmoType and preferredAmmoType ~= 'any' then
        if preferredAmmoType == 'mixed' then
            preferredAmmoType = getText("IGUI_Firearm_AmmoMixed")
        else
            local ammoData = Ammo.getData(preferredAmmoType)
            if ammoData then preferredAmmoType = (ammoData.instance:getDisplayName() or preferredAmmoType) end
        end
        setLayoutItem(layout, getText("Tooltip_Firearm_SetAmmo"), preferredAmmoType)
    end

    ----------------------------------------------------------
    -- loadedAmmo
    local loadedAmmo = modData.loadedAmmo
    if not loadedAmmo then
         loadedAmmo = getText("IGUI_Firearm_Empty")
    elseif loadedAmmo == 'mixed' then
        loadedAmmo = getText("IGUI_Firearm_AmmoMixed")
    else
        local ammoData = Ammo.getData(loadedAmmo)
        if ammoData then loadedAmmo = (ammoData.instance:getDisplayName() or loadedAmmo) end
    end
    setLayoutItem(layout, getText("Tooltip_Firearm_Loaded"), loadedAmmo)

    ----------------------------------------------------------
    -- Capacity
    if modData.currentCapacity then
        local rounds = modData.currentCapacity .. "/" .. modData.maxCapacity
        local color = colorScale(modData.currentCapacity / modData.maxCapacity, noColor)
        setLayoutItem(layout, getText("Tooltip_weapon_AmmoCount") .. ":", rounds, color)
    end

    ----------------------------------------------------------
    finalizeTip(self, layout, y, i)
end

TipHandler[ORGM.FIREARM] = function(self)
    local item = self.item
    local gunData = Firearm.getData(item)
    local modData = item:getModData()
    local player = getPlayer()
    local isSet = (modData.lastRound ~= nil)
    local aimingPerk = player:getPerkLevel(Perks.Aiming)
    local toolTipStyle = Settings.ToolTipStyle
    local noColor, isNumeric, roundPrecision = initializeStyle(toolTipStyle, aimingPerk)
    local layout, y, i = initializeTip(self)
    local fullauto = Firearm.isFullAuto(item, gunData)
    ----------------------------------------------------------

    -- show classification
    setLayoutItem(layout, getText("Tooltip_Firearm_Type"), getText(gunData.classification))

    --
    if Firearm.isSelectFire(item, gunData) then
        local mode = "IGUI_Firearm_DetailSemi"
        if fullauto then mode = "IGUI_Firearm_DetailFull" end
        setLayoutItem(layout, getText("Tooltip_Firearm_Mode"), getText(mode))
    end

    -- show weight
    local weight = item:getUnequippedWeight()
    if item:isEquipped() then weight = item:getEquippedWeight() end
    setLayoutItem(layout, getText("Tooltip_item_Weight").. ":", round(weight, 3))

    -- show barrel length
    setLayoutItem(layout, getText("Tooltip_Firearm_Barrel"), tostring(Firearm.Barrel.getLength(item, gunData)).." ".. getText("Tooltip_Firearm_Inches"))

    ----------------------------------------------------------

    local ammoType = item:getAmmoType()
    --local ammoType = modData.defaultAmmo
    local ammoItem = getScriptManager():FindItem(ammoType)
    if not ammoItem then
        ammoItem = getScriptManager():FindItem(item:getModule() .. ".".. ammoType)
    end
    setLayoutItem(layout, getText("Tooltip_weapon_Ammo").. ":", ammoItem:getDisplayName())

    ----------------------------------------------------------
    -- preferredAmmoType
    local preferredAmmoType = modData.preferredAmmoType
    if preferredAmmoType and preferredAmmoType ~= 'any' then
        if preferredAmmoType == 'mixed' then
            preferredAmmoType = getText("IGUI_Firearm_AmmoMixed")
        else
            local ammoData = Ammo.getData(preferredAmmoType)
            if ammoData then preferredAmmoType = (ammoData.instance:getDisplayName() or preferredAmmoType) end
        end
        setLayoutItem(layout, getText("Tooltip_Firearm_SetAmmo"), preferredAmmoType)
    end

    ----------------------------------------------------------
    -- loadedAmmo
    local loadedAmmo = modData.loadedAmmo
    if not loadedAmmo then
         loadedAmmo = getText("IGUI_Firearm_Empty")
    elseif loadedAmmo == 'mixed' then
        loadedAmmo = getText("IGUI_Firearm_AmmoMixed")
    else
        local ammoData = Ammo.getData(loadedAmmo)
        if ammoData then loadedAmmo = (ammoData.instance:getDisplayName() or loadedAmmo) end
    end
    setLayoutItem(layout, getText("Tooltip_Firearm_Loaded"), loadedAmmo)

    ----------------------------------------------------------
    -- Capacity
    if modData.currentCapacity then
        local rounds = modData.currentCapacity .. "/" .. modData.maxCapacity
        if modData.roundChambered and modData.emptyShellChambered == 0 then
            rounds = rounds .."+"..modData.roundChambered
        elseif modData.emptyShellChambered then
            rounds = rounds .. "+X"
        end
        local color = colorScale(modData.currentCapacity / modData.maxCapacity, noColor)
        setLayoutItem(layout, getText("Tooltip_weapon_AmmoCount") .. ":", rounds, color)
    end

    if isSet then -- Only show when a round has been set.
        ----------------------------------------------------------
        -- Damage
        if (aimingPerk > 0 or toolTipStyle ~= ORGM.TIPDYNAMIC) then
            local damage = self.item:getMinDamage()
            local color = colorScale(damage/(3.0*Settings.DamageMultiplier), noColor)
            setLayoutItem(layout, getText("Tooltip_Firearm_MinDamage"),
                isNumeric and round(damage, roundPrecision) or damage/(3.0*Settings.DamageMultiplier),
                color, not isNumeric)

            damage = self.item:getMaxDamage()
            color = colorScale(damage/(3.0*Settings.DamageMultiplier), noColor)
            setLayoutItem(layout, getText("Tooltip_Firearm_MaxDamage"),
                isNumeric and round(damage, roundPrecision) or damage/(3.0*Settings.DamageMultiplier),
                color, not isNumeric)
        end

        ----------------------------------------------------------
        -- Range
        if (aimingPerk > 1 or toolTipStyle ~= ORGM.TIPDYNAMIC) then
            local range = item:getMaxRange(player)
            local color = colorScale(range/50, noColor)
            setLayoutItem(layout, getText("Tooltip_Firearm_Range"),
                isNumeric and round(range, roundPrecision) or range/50,
                color, not isNumeric)
        end

        ----------------------------------------------------------
        -- accuracy
        if (aimingPerk > 2 or toolTipStyle ~= ORGM.TIPDYNAMIC) then
            local chance = item:getHitChance()
            local color = colorScale(chance/80, noColor)
            setLayoutItem(layout, getText("Tooltip_Firearm_HitChance"),
                isNumeric and tostring(chance) or chance/80,
                color, not isNumeric)
        end

        ----------------------------------------------------------
        -- Recoil
        if not fullauto and (aimingPerk > 0 or toolTipStyle ~= ORGM.TIPDYNAMIC) then
            local recoil = item:getRecoilDelay()
            local color = colorScale(1-recoil/50, noColor)
            setLayoutItem(layout, getText("Tooltip_Firearm_Recoil"),
                isNumeric and tostring(recoil) or recoil/50,
                color, not isNumeric)
        end
    end

    ----------------------------------------------------------
    -- Swingtime/Awkwardness, confusing for full autos.
    if not fullauto and (aimingPerk > 2 or toolTipStyle ~= ORGM.TIPDYNAMIC) then
        local swing = item:getSwingTime()
        local color = colorScale(1-swing/5, noColor)
        setLayoutItem(layout, getText("Tooltip_Firearm_SwingTime"),
            isNumeric and tostring(swing) or swing/5,
            color, not isNumeric)
    end

    ----------------------------------------------------------
    -- Noise
    if (aimingPerk > 1 or toolTipStyle ~= ORGM.TIPDYNAMIC) then
        local range = item:getSoundRadius()
        local color = colorScale(1-range/250, noColor)
        setLayoutItem(layout, getText("Tooltip_Firearm_Noise"),
            isNumeric and tostring(range) or range/250,
            color, not isNumeric)
    end

    ----------------------------------------------------------
    -- Condition
    local condition = item:getCondition() / item:getConditionMax()
    local color = colorScale(condition, noColor)
    -- TODO: translation
    setLayoutItem(layout, getText("Tooltip_weapon_Condition")..":",
        isNumeric and tostring(item:getCondition()).."/"..tostring(item:getConditionMax()) or condition,
        color, not isNumeric)

    ----------------------------------------------------------
    -- roundsSinceCleaned
    local roundsSinceCleaned = modData.roundsSinceCleaned
    if (aimingPerk > 3 or toolTipStyle ~= ORGM.TIPDYNAMIC) and roundsSinceCleaned then
        -- roundsSinceCleaned tracker
        if roundsSinceCleaned > 500 then roundsSinceCleaned = 500 end
        local color = colorScale(1-roundsSinceCleaned/500)

        setLayoutItem(layout, getText("Tooltip_Firearm_Dirt"),
            isNumeric and tostring(modData.roundsSinceCleaned) or roundsSinceCleaned/500,
            color, not isNumeric)

    end
    ----------------------------------------------------------
    -- Components

    local compTable = Component.getAttached(item)
    for pos, compItem in pairs(compTable) do
        if compItem then
            local layoutItem = layout:addItem()
            layoutItem:setLabel(compItem:getDisplayName(), 1, 1, 0.8, 1)
        end
    end

    ----------------------------------------------------------
    finalizeTip(self, layout, y, i)
end


--[[- This modifies firearm and magazine tooltips to show what the item is currently loaded with.
This renders the 'classic' ORGM tooltips (v3.09.1 and lower)

]]
function ISToolTipInv:renderClassic()
    -- TODO: this should actually check the ORGM tables to see
    if self.item:getModule() ~= "ORGM" then
        render(self)
        return
    end

    local modData = self.item:getModData() -- gets the item's mod data

    local text = "Tooltip_loaded"
    -- set the text to show what the item is currently loaded with
    if modData.loadedAmmo ~= nil then
        text = text .. "_"..modData.loadedAmmo
    end

    -- set the text to show the current fire mode
    if modData.selectFire ~= nil then
        if modData.selectFire == 1 then
            text = text .. "_FA"
        else
            text = text .. "_SA"
        end
    end
    -- this old tooltip screws the translations..
    local old = self.item:getTooltip()
    if text ~= "Tooltip_loaded" then
        self.item:setTooltip(text)
    end
    -- call the original function
    render(self)
    self.item:setTooltip(old)
end

--[[- Overwrites the base game's ISToolTipInv:render() method. This checks our TipHandler table looking
for a function to design the ORGM tooltips,

]]
function ISToolTipInv:renderORGM()
    if Settings.ToolTipStyle == ORGM.TIPCLASSIC then
        self:renderClassic()
        return
    end
    -- find our handler function
    local tipHandler = TipHandler[ORGM.getType(self.item)]
    if not tipHandler then
        -- call the original function and return.
        render(self)
        return
    end

    -- MOST of the code here is a copy of the base pz function, except replacing the item:DoTooltip() calls

    -- we render the tool tip for inventory item only if there's no context menu
    if ISContextMenu.instance and ISContextMenu.instance.visibleCheck then return end

    local mx = getMouseX() + 24;
    local my = getMouseY() + 24;
    if not self.followMouse then
        mx = self:getX()
        my = self:getY()
        if self.anchorBottomLeft then
            mx = self.anchorBottomLeft.x
            my = self.anchorBottomLeft.y
        end
    end

    self.tooltip:setX(mx+11);
    self.tooltip:setY(my);

    self.tooltip:setWidth(50)
    self.tooltip:setMeasureOnly(true)

    -- call our handler function
    tipHandler(self) -- self.item:DoTooltip(self.tooltip);
    self.tooltip:setMeasureOnly(false)

    -- clampy x, y

    local myCore = getCore();
    local maxX = myCore:getScreenWidth()
    local maxY = myCore:getScreenHeight()

    local tw = self.tooltip:getWidth()
    local th = self.tooltip:getHeight()

    self.tooltip:setX(math.max(0, math.min(mx + 11, maxX - tw - 1)))
    if not self.followMouse and self.anchorBottomLeft then
        self.tooltip:setY(math.max(0, math.min(my - th, maxY - th - 1)))
    else
        self.tooltip:setY(math.max(0, math.min(my, maxY - th - 1)))
    end

    self:setX(self.tooltip:getX() - 11)
    self:setY(self.tooltip:getY())
    self:setWidth(tw + 11)
    self:setHeight(th)

    if self.followMouse then
        self:adjustPositionToAvoidOverlap({ x = mx - 24 * 2, y = my - 24 * 2, width = 24 * 2, height = 24 * 2 })
    end

    self:drawRect(0, 0, self.width, self.height, self.backgroundColor.a, self.backgroundColor.r, self.backgroundColor.g, self.backgroundColor.b);
    self:drawRectBorder(0, 0, self.width, self.height, self.borderColor.a, self.borderColor.r, self.borderColor.g, self.borderColor.b);

    -- call our handler function
    tipHandler(self) -- self.item:DoTooltip(self.tooltip);
end
ISToolTipInv.render = ISToolTipInv.renderORGM
