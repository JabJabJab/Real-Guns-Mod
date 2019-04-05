--[[- Contains the code for adding options to the PZ options screen.
    ORGMClientOptions.lua

    @classmod MainOptions

]]

-- Setup hotkey bindings
-- We need to use the global keyBinding table, this stores all our binding values
local index = nil -- index will be the position we want to insert into the table
for i,b in ipairs(keyBinding) do
    if b.value == "Equip/Unequip Stab weapon" then
        index = i -- found the index, set it and break from the loop
        break
    end
end

if index then
    -- we got a index, first lets insert our new entries
    table.insert(keyBinding, index+1, {value = "Equip/Unequip Pistol", key = 5})
    table.insert(keyBinding, index+2, {value = "Equip/Unequip Rifle", key = 6})
    table.insert(keyBinding, index+3, {value = "Equip/Unequip Shotgun", key = 7})
    table.insert(keyBinding, index+4, {value = "Reload Any Magazine", key = Keyboard.KEY_G })
    table.insert(keyBinding, index+5, {value = "Select Fire Toggle", key = Keyboard.KEY_Z })
    table.insert(keyBinding, index+6, {value = "Firearm Inspection Window", key = Keyboard.KEY_U })

end


-- GameOption crap copied from MainOptions.lua, since it was defined local
local GameOption = ISBaseObject:derive("GameOption")

--- creates a new option.
function GameOption:new(name, control, arg1, arg2)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o.name = name
    o.control = control
    o.arg1 = arg1
    o.arg2 = arg2
    if control.isCombobox then
    control.onChange = self.onChangeComboBox
    control.target = o
    end
    if control.isTickBox then
    control.changeOptionMethod = self.onChangeTickBox
    control.changeOptionTarget = o
    end
    if control.isSlider then
    control.targetFunc = self.onChangeVolumeControl
    control.target = o
    end
    if control.isTextEntryBox then
    control.onTextChange = self.onChangeTextEntryBox
    control.target = o
    end
    return o
end

function GameOption:toUI()
    print('ERROR: option "'..self.name..'" missing toUI()')
end

function GameOption:apply()
    print('ERROR: option "'..self.name..'" missing apply()')
end

-- new function, to properly handle TextEntryBox controls
function GameOption:onChangeTextEntryBox(box)
    self.target.gameOptions:onChange(self)
    if self.target.onChange then
    self.target:onChange(box)
    end
end

function GameOption:onChangeComboBox(box)
    self.gameOptions:onChange(self)
    if self.onChange then
    self:onChange(box)
    end
end

function GameOption:onChangeTickBox(index, selected)
    self.gameOptions:onChange(self)
    if self.onChange then
    self:onChange(index, selected)
    end
end

function GameOption:onChangeVolumeControl(control, volume)
    self.gameOptions:onChange(self)
    if self.onChange then
    self:onChange(control, volume)
    end
end


----------------------------------------------------------------------------------------

--[[ addBoolOption(self, splitpoint, width, title, settingKey)

    local function to define a boolean yes/no combo box.

]]

local function addBoolOption(self, splitpoint, width, title, settingKey)
    local opt = self:addCombo(splitpoint, 5, width, 20, getText("UI_optionscreen_".. title), {getText("UI_Yes"), getText("UI_No")}, 1)
    opt:setToolTipMap({defaultTooltip = getText("UI_optionscreen_"..title.."_tooltip")})
    local gameOption = GameOption:new(title, opt)
    function gameOption.onChange(self, box)
        if isClient() then -- cant edit as client
            self.gameOptions.changed = false
            self:toUI()
        end
    end
    function gameOption.toUI(self)
    self.control.selected = ORGM.Settings[settingKey] and 1 or 2
    end
    function gameOption.apply(self)
        ORGM.Settings[settingKey] = self.control.selected == 1 and true or false
        ORGM.validateSettingKey(settingKey)
        ORGM.writeSettingsFile()
    end
    self.gameOptions:add(gameOption)
    return opt
end

--[[- addNumericOption(self, splitpoint, width, title, settingKey, asFloat)

]]
local function addNumericOption(self, splitpoint, width, title, settingKey, asFloat)
    local label = ISLabel:new(splitpoint, 5 + self.addY, 20, getText("UI_optionscreen_".. title), 1, 1, 1, 1, UIFont.Small)
    label:initialise()
    self.mainPanel:addChild(label)

    local opt = ISTextEntryBox:new("", splitpoint+20, 5 + self.addY + 2, width, 20)
    opt.isTextEntryBox = true
    opt:initialise()
    opt:instantiate()

    self.mainPanel:addChild(opt)
    self.mainPanel:insertNewLineOfButtons(opt)
    self.addY = self.addY + 26

    opt:setTooltip(getText("UI_optionscreen_"..title.."_tooltip"))
    opt:setOnlyNumbers(true)
    local gameOption = GameOption:new(title, opt)
    function gameOption.onChange(self, box)
        if isClient() then -- cant edit as client
            self.gameOptions.changed = false
            self:toUI()
        end
    end
    function gameOption.toUI(self)
        if isClient() then -- cant edit as client
            opt:setEditable(false)
        else
            opt:setEditable(true)
        end
        if asFloat then
            self.control:setText(string.format("%f", ORGM.Settings[settingKey]))
        else
            self.control:setText(tostring(ORGM.Settings[settingKey]))
        end
    end
    function gameOption.apply(self)
        ORGM.Settings[settingKey] = tonumber(self.control:getText())
        ORGM.validateSettingKey(settingKey)
        ORGM.writeSettingsFile()
        gameOption:toUI()

    end
    self.gameOptions:add(gameOption)
    return opt
end

--[[- addNumericOption(self, splitpoint, width, title, settingKey, asFloat)

]]
local function addSectionLabel(self, splitpoint, width, title)
    local label = ISLabel:new(splitpoint + 20, 5 + self.addY, 20, getText("UI_optionscreen_".. title), 1, 1, 1, 1, UIFont.Small, true)
    label:initialise()
    self.mainPanel:addChild(label)
    self.addY = self.addY + 26
end

local oldCreate = MainOptions.create
--[[- Override PZ's function for creating the Options screen.

    This needs to be done to add the 'ORGM' tab.
    The original MainOptions:create() is called at the start of our override,
    with the new code triggering after.

]]
function MainOptions:create()
    oldCreate(self)
    self:addPage("ORGM") -- TODO: use translation?
    local y = 5;
    self.addY = 0
    local splitpoint = self:getWidth() / 3;
    --local comboWidth = self:getWidth()-splitpoint - 100
    local comboWidth = 300

    addSectionLabel(self, splitpoint, comboWidth, "orgm_section_general")

    local opt = self:addCombo(splitpoint, y, comboWidth, 20, getText("UI_optionscreen_orgm_loglevel"), {
            getText("UI_optionscreen_orgm_loglevel_error"),
            getText("UI_optionscreen_orgm_loglevel_warn"),
            getText("UI_optionscreen_orgm_loglevel_info"),
            getText("UI_optionscreen_orgm_loglevel_debug"),
            getText("UI_optionscreen_orgm_loglevel_verbose")
        }, 2)
    opt:setToolTipMap({defaultTooltip = getText("UI_optionscreen_orgm_loglevel_tooltip")})
    local gameOption = GameOption:new('orgm_loglevel', opt)
    function gameOption.toUI(self)
    self.control.selected = ORGM.Settings.LogLevel +1
    end
    function gameOption.apply(self)
        ORGM.Settings.LogLevel = self.control.selected - 1
        ORGM.validateSettingKey('LogLevel')
        ORGM.writeSettingsFile()
    end
    self.gameOptions:add(gameOption)

    -- ToolTip Style
    local opt = self:addCombo(splitpoint, y, comboWidth, 20, getText("UI_optionscreen_orgm_tiplevel"), {
            getText("UI_optionscreen_orgm_tiplevel1"),
            getText("UI_optionscreen_orgm_tiplevel2"),
            getText("UI_optionscreen_orgm_tiplevel3"),
            getText("UI_optionscreen_orgm_tiplevel4")
        }, 2)
    opt:setToolTipMap({defaultTooltip = getText("UI_optionscreen_orgm_tiplevel_tooltip")})
    local gameOption = GameOption:new('orgm_tiplevel', opt)
    function gameOption.toUI(self)
    self.control.selected = ORGM.Settings.ToolTipStyle
    end
    function gameOption.apply(self)
        ORGM.Settings.ToolTipStyle = self.control.selected
        ORGM.validateSettingKey('ToolTipStyle')
        ORGM.writeSettingsFile()
    end
    self.gameOptions:add(gameOption)


    addBoolOption(self, splitpoint, comboWidth, "orgm_jamming", "JammingEnabled")
    addBoolOption(self, splitpoint, comboWidth, "orgm_usecases", "CasesEnabled")
    --addBoolOption(self, splitpoint, comboWidth, "orgm_usebarrellen", "UseBarrelLengthModifiers")
    addBoolOption(self, splitpoint, comboWidth, "orgm_removebase", "RemoveBaseFirearms")

    self.addY = self.addY + 10
    addSectionLabel(self, splitpoint, comboWidth, "orgm_section_balance")
    addBoolOption(self, splitpoint, comboWidth, "orgm_disablefullauto", "DisableFullAuto")
    addNumericOption(self, splitpoint, comboWidth, "orgm_hitfullauto", "FullAutoHitChanceAdjustment", false)
    addNumericOption(self, splitpoint, comboWidth, "orgm_damagemulti", "DamageMultiplier", true)
    addNumericOption(self, splitpoint, comboWidth, "orgm_hitpistol", "DefaultHitChancePistol", false)
    addNumericOption(self, splitpoint, comboWidth, "orgm_hitsmg", "DefaultHitChanceSMG", false)
    addNumericOption(self, splitpoint, comboWidth, "orgm_hitrifle", "DefaultHitChanceRifle", false)
    addNumericOption(self, splitpoint, comboWidth, "orgm_hitshotgun", "DefaultHitChanceShotgun", false)
    addNumericOption(self, splitpoint, comboWidth, "orgm_hitother", "DefaultHitChanceOther", false)
    addNumericOption(self, splitpoint, comboWidth, "orgm_aiminghitmod", "DefaultAimingHitMod", false)
    addNumericOption(self, splitpoint, comboWidth, "orgm_critical", "DefaultCriticalChance", false)
    addNumericOption(self, splitpoint, comboWidth, "orgm_aimingcritmod", "DefaultAimingCritMod", false)
    addNumericOption(self, splitpoint, comboWidth, "orgm_magreloadtime", "DefaultMagazineReoadTime", false)
    addNumericOption(self, splitpoint, comboWidth, "orgm_reloadtime", "DefaultReloadTime", false)
    addNumericOption(self, splitpoint, comboWidth, "orgm_racktime", "DefaultRackTime", false)

    self.addY = self.addY + 10
    addSectionLabel(self, splitpoint, comboWidth, "orgm_section_spawn")
    addNumericOption(self, splitpoint, comboWidth, "orgm_limityear", "LimitYear", false)
    addNumericOption(self, splitpoint, comboWidth, "orgm_firearmspawnmulti", "FirearmSpawnModifier", true)
    addNumericOption(self, splitpoint, comboWidth, "orgm_ammospawnmulti", "AmmoSpawnModifier", true)
    addNumericOption(self, splitpoint, comboWidth, "orgm_magspawnmulti", "MagazineSpawnModifier", true)
    addNumericOption(self, splitpoint, comboWidth, "orgm_repairspawnmulti", "RepairKitSpawnModifier", true)
    addNumericOption(self, splitpoint, comboWidth, "orgm_componentspawnmulti", "ComponentSpawnModifier", true)

    addNumericOption(self, splitpoint, comboWidth, "orgm_corpsespawnmulti", "CorpseSpawnModifier", true)
    addNumericOption(self, splitpoint, comboWidth, "orgm_civilianbuildingspawnmulti", "CivilianBuildingSpawnModifier", true)
    addNumericOption(self, splitpoint, comboWidth, "orgm_policestoragespawnmulti", "PoliceStorageSpawnModifier", true)
    addNumericOption(self, splitpoint, comboWidth, "orgm_gunstorespawnmulti", "GunStoreSpawnModifier", true)
    addNumericOption(self, splitpoint, comboWidth, "orgm_storageunitspawnmulti", "StorageUnitSpawnModifier", true)
    addNumericOption(self, splitpoint, comboWidth, "orgm_garagespawnmulti", "GarageSpawnModifier", true)
    addNumericOption(self, splitpoint, comboWidth, "orgm_huntingspawnmulti", "HuntingSpawnModifier", true)

    self.addY = self.addY + 10
    addSectionLabel(self, splitpoint, comboWidth, "orgm_section_compatibility")
    addBoolOption(self, splitpoint, comboWidth, "orgm_silencerspatch", "UseSilencersPatch")
    addNumericOption(self, splitpoint, comboWidth, "orgm_silencerspatcheffect", "SilencerPatchEffect", true)
    addBoolOption(self, splitpoint, comboWidth, "orgm_necroforgepatch", "UseNecroforgePatch")
    addBoolOption(self, splitpoint, comboWidth, "orgm_survivorspatch", "UseSurvivorsPatch")

    --self.addY = self.addY + 10
    --addSectionLabel(self, splitpoint, comboWidth, "orgm_section_advanced")

    self.mainPanel:setScrollHeight(self.addY + 40)
    self.addY = 0
end
