--[[- Override for ISToolTipInv.

    Some modifications need to be done to the tooltip rendering process to handle our custom
    tooltips.

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
local Settings = ORGM.Settings

local getMouseX = getMouseX
local getMouseY = getMouseY
local getText = getText
local tostring = tostring
local pairs = pairs

-- store our original function in a local variable that we'll call later
local render = ISToolTipInv.render

local TipHandler = { }

local function colorScale(value, default)
    --if value < 0 then value = 0 end
    --if value > 1 then value = 1 end
    local c = {["r"] = 1.0, ["g"] = 1.0, ["b"] = 8.0}
    if default then return c end
    if value > 0.85 then
        c.r, c.g, c.b = 0.0, 1.0, 0.0
    elseif value > 0.70 then
        c.r, c.g, c.b = 0.0, 1.0, 0.0 --
    elseif value > 0.55 then
        c.r, c.g, c.b = 0.8, 1.0, 0.0 --
    elseif value > 0.45 then
        c.r, c.g, c.b = 1.0, 1.0, 0.8 --
    elseif value > 0.30 then
        c.r, c.g, c.b = 1.0, 0.8, 0.0
    elseif value > 0.15 then
        c.r, c.g, c.b = 1.0, 0.4, 0.0
    else
        c.r, c.g, c.b = 1.0, 0.0, 0.0
    end
    return c
end

TipHandler[ORGM.COMPONENT] = function(self)
    local item = self.item
    -- local gunData = Firearm.getData(item)
    local modData = item:getModData()
    local player = getPlayer()
    --local isSet = (modData.lastRound ~= nil)
    local aimingPerk = player:getPerkLevel(Perks.Aiming)
    local toolTipStyle = Settings.ToolTipStyle

    local noColor = (aimingPerk <= 3 and toolTipStyle ~= ORGM.TIPFULL)
    local showNumeric = (aimingPerk > 7 and toolTipStyle == ORGM.TIPDYNAMIC) or toolTipStyle == ORGM.TIPNUMERIC

    -- translated from the java when executing self.item:DoTooltip(self.tooltip)
    self.tooltip:render()
    local UIFont = self.tooltip:getFont()
    local i = self.tooltip:getLineSpacing()
    local y = 5
    self.tooltip:DrawText(UIFont, item:getName(), 5, y, 1, 1, 0.8, 1)
    self.tooltip:adjustWidth(5, item:getName())
    y = y + i + 5
    local layout = self.tooltip:beginLayout()
    layout:setMinLabelWidth(80)
    ----------------------------------------------------------

    ----------------------------------------------------------
    y = layout:render(5, y, self.tooltip)
    self.tooltip:endLayout(layout)

    y = y+ i-- j = j+ self.tooltip.padBottom; -- ??
    self.tooltip:setHeight(y)
    if self.tooltip:getWidth() < 150 then
        self.tooltip:setWidth(150)
    end

end
--
TipHandler[ORGM.FIREARM] = function(self)
    local item = self.item
    local gunData = Firearm.getData(item)
    local modData = item:getModData()
    local player = getPlayer()
    local isSet = (modData.lastRound ~= nil)
    local aimingPerk = player:getPerkLevel(Perks.Aiming)
    local toolTipStyle = Settings.ToolTipStyle

    local noColor = (aimingPerk <= 3 and toolTipStyle ~= ORGM.TIPFULL)
    local showNumeric = (aimingPerk > 7 and toolTipStyle == ORGM.TIPDYNAMIC) or toolTipStyle == ORGM.TIPNUMERIC

    -- translated from the java when executing self.item:DoTooltip(self.tooltip)
    self.tooltip:render()
    local UIFont = self.tooltip:getFont()
    local i = self.tooltip:getLineSpacing()
    local y = 5
    self.tooltip:DrawText(UIFont, item:getName(), 5, y, 1, 1, 0.8, 1)
    self.tooltip:adjustWidth(5, item:getName())
    y = y + i + 5
    local layout = self.tooltip:beginLayout()
    layout:setMinLabelWidth(80)
    ----------------------------------------------------------

    -- show classification
    local layoutItem = layout:addItem()
    layoutItem:setLabel("Type:", 1, 1, 0.8, 1) -- TODO: translation
    layoutItem:setValue(getText(gunData.classification), 1, 1, 0.8, 1)

    -- Firearm.isSelectFire(item, gunData)
    -- Firearm.isFullAuto(item, gunData)
    if modData.selectFire then
        layoutItem = layout:addItem()
        layoutItem:setLabel("Mode:", 1, 1, 0.8, 1) -- TODO: translation
        local mode = "IGUI_Firearm_DetailSemi"
        if modData.selectFire == ORGM.FULLAUTOMODE then mode = "IGUI_Firearm_DetailFull" end
        layoutItem:setValue(getText(mode), 1, 1, 0.8, 1)
    end

    -- show weight
    layoutItem = layout:addItem()
    layoutItem:setLabel(getText("Tooltip_item_Weight").. ":", 1, 1, 0.8, 1)
    local weight = item:getUnequippedWeight()
    if item:isEquipped() then weight = item:getEquippedWeight() end
    layoutItem:setValue(tostring(weight), 1, 1, 0.8, 1)


    -- show barrel length
    layoutItem = layout:addItem()
    layoutItem:setLabel("Barrel Length:", 1, 1, 0.8, 1) -- TODO: translation
    layoutItem:setValue(tostring(Firearm.Barrel.getLength(item, gunData)).." inches", 1, 1, 0.8, 1) -- TODO: translation


    ----------------------------------------------------------
    -- Ammo Type
    --layoutItem = layout:addItem()
    --layoutItem:setLabel("Ammo", 1.0, 1.0, 0.8, 1.0)

    local ammoType = item:getAmmoType()
    --local ammoType = modData.defaultAmmo
    local ammoItem = getScriptManager():FindItem(ammoType)
    if not ammoItem then
        ammoItem = getScriptManager():FindItem(item:getModule() .. ".".. ammoType)
    end
    layoutItem = layout:addItem()
    layoutItem:setLabel(getText("Tooltip_weapon_Ammo") .. ":", 1.0, 1.0, 0.8, 1.0)
    layoutItem:setValue(ammoItem:getDisplayName(), 1.0, 1.0, 1.0, 1.0)

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
        layoutItem = layout:addItem()
        layoutItem:setLabel("Set Ammo:", 1.0, 1.0, 0.8, 1.0) -- TODO: translation
        layoutItem:setValue(preferredAmmoType, 1.0, 1.0, 1.0, 1.0)
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
    layoutItem = layout:addItem()
    layoutItem:setLabel("Loaded:", 1.0, 1.0, 0.8, 1.0) -- TODO: translation
    layoutItem:setValue(loadedAmmo, 1.0, 1.0, 1.0, 1.0)

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
        layoutItem = layout:addItem()
        layoutItem:setLabel(getText("Tooltip_weapon_AmmoCount") .. ":", 1.0, 1.0, 0.8, 1.0)
        layoutItem:setValue(rounds, color.r, color.g, color.b, 1.0)
    end

    if isSet then -- Only show when a round has been set.
        ----------------------------------------------------------
        -- Damage
        layoutItem = layout:addItem()
        local damage = self.item:getMinDamage()
        local color = colorScale(damage/(3.0*Settings.DamageMultiplier), noColor)
        layoutItem:setLabel("Min Damage:", 1, 1, 0.8, 1) -- TODO: translation
        if showNumeric then
            layoutItem:setValue(tostring(damage), color.r, color.g, color.b, 1)
        else
            layoutItem:setProgress(damage/(3.0*Settings.DamageMultiplier), color.r, color.g, color.b, 1)
        end
        --layoutItem:setValueRightNoPlus(tonumber(self.item:getMinDamage()))

        layoutItem = layout:addItem()
        damage = self.item:getMaxDamage()
        color = colorScale(damage/(3.0*Settings.DamageMultiplier), noColor)
        layoutItem:setLabel("Max Damage:", 1, 1, 0.8, 1) -- TODO: translation
        if showNumeric then
            layoutItem:setValue(tostring(damage), color.r, color.g, color.b, 1)
        else
            layoutItem:setProgress(damage/(3.0*Settings.DamageMultiplier), color.r, color.g, color.b, 1)
        end

        ----------------------------------------------------------
        -- Range
        layoutItem = layout:addItem()
        local range = item:getMaxRange(player)
        color = colorScale(range/50, noColor)
        layoutItem:setLabel("Range:", 1, 1, 0.8, 1) -- TODO: translation

        if showNumeric then
            layoutItem:setValue(tostring(range), color.r, color.g, color.b, 1)
        else
            layoutItem:setProgress(range/50, color.r, color.g, color.b, 1)
        end

        ----------------------------------------------------------
        -- Recoil
        layoutItem = layout:addItem()
        local recoil = item:getRecoilDelay()
        color = colorScale(1-recoil/50, noColor)
        layoutItem:setLabel("Recoil:", 1, 1, 0.8, 1) -- TODO: translation

        if showNumeric then
            layoutItem:setValue(tostring(recoil), color.r, color.g, color.b, 1)
        else
            layoutItem:setProgress(recoil/50, color.r, color.g, color.b, 1)
        end
    end

    ----------------------------------------------------------
    -- Noise
    layoutItem = layout:addItem()
    local range = item:getSoundRadius()
    color = colorScale(1-range/250, noColor)
    layoutItem:setLabel("Noise:", 1, 1, 0.8, 1) -- TODO: translation

    if showNumeric then
        layoutItem:setValue(tostring(range), color.r, color.g, color.b, 1)
    else
        layoutItem:setProgress(range/250, color.r, color.g, color.b, 1)
    end

    ----------------------------------------------------------
    -- Condition
    layoutItem = layout:addItem()
    local condition = item:getCondition() / item:getConditionMax()
    color = colorScale(condition, noColor)
    layoutItem:setLabel("Condition:", 1, 1, 0.8, 1) -- TODO: translation

    if showNumeric then
        layoutItem:setValue(tostring(item:getCondition()).."/"..tostring(item:getConditionMax()), color.r, color.g, color.b, 1)
    else
        layoutItem:setProgress(condition, color.r, color.g, color.b, 1)
    end

    ----------------------------------------------------------
    -- roundsSinceCleaned
    local roundsSinceCleaned = modData.roundsSinceCleaned
    if (aimingPerk > 3 or toolTipStyle ~= ORGM.TIPDYNAMIC) and roundsSinceCleaned then
        -- roundsSinceCleaned tracker
        layoutItem = layout:addItem()
        if roundsSinceCleaned > 500 then roundsSinceCleaned = 500 end
        color = colorScale(1-roundsSinceCleaned/500)
        layoutItem:setLabel("Dirt:", 1, 1, 0.8, 1) -- TODO: translation
        if showNumeric then
            -- use untouched modData value for roundsSinceCleaned
            layoutItem:setValue(tostring(modData.roundsSinceCleaned), color.r, color.g, color.b, 1)
        else
            layoutItem:setProgress(roundsSinceCleaned/500, color.r, color.g, color.b, 1)
        end
    end
    ----------------------------------------------------------
    -- Components

    local compTable = Component.getAttached(item)
    for pos, compItem in pairs(compTable) do
        if compItem then
            layoutItem = layout:addItem()
            layoutItem:setLabel(compItem:getDisplayName(), 1, 1, 0.8, 1)
        end
    end

    ----------------------------------------------------------
    y = layout:render(5, y, self.tooltip)
    self.tooltip:endLayout(layout)

    y = y+ i-- j = j+ self.tooltip.padBottom; -- ??
    self.tooltip:setHeight(y)
    if self.tooltip:getWidth() < 150 then
        self.tooltip:setWidth(150)
    end
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
function ISToolTipInv:render()
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
