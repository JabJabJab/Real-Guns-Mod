--[[-

@module ORGM.Sounds
@author Fenris_Wolf.
@copyright 2018 **File:** shared/1LoadOrder/ORGMSounds.lua
@release 3.09

]]

local ORGM = ORGM
local Sounds = ORGM.Sounds

--[[- Profiles Table.

Sound profiles are used to save redundant work when settings up new firearms.
Many firearms use identical sounds for the actions, this profile can be used to
save on repetative data entry.

A profile is a table with the sound type as key, and the string filename as a value.
@tparam string clickSound
@tparam string insertSound
@tparam string ejectSound
@tparam string rackSound
@tparam string openSound
@tparam string closeSound
@tparam string cockSound

@table Profiles
]]
local Profiles = ORGM.Sounds.Profiles
local getFMODSoundBank = getFMODSoundBank

local QueueTable = { }



Sounds.Profiles["Revolver"] = {
    clickSound = 'ORGMRevolverEmpty',
    insertSound = 'ORGMMagLoad',
    ejectSound = nil,
    rackSound = 'ORGMRevolverCock',
    openSound = 'ORGMRevolverOpen',
    closeSound = 'ORGMRevolverClose',
    cockSound = 'ORGMRevolverCock'
}
Sounds.Profiles["Pistol-Small"] = {
    clickSound = 'ORGMSmallPistolEmpty',
    insertSound = 'ORGMSmallPistolIn',
    ejectSound = 'ORGMSmallPistolOut',
    rackSound = 'ORGMSmallPistolRack',
    openSound = nil,
    closeSound = 'ORGMPistolClose',
    cockSound = nil
}
Sounds.Profiles["Pistol-Large"] = {
    clickSound = 'ORGMPistolEmpty',
    insertSound = 'ORGMPistolIn',
    ejectSound = 'ORGMPistolOut',
    rackSound = 'ORGMPistolRack',
    openSound = nil,
    closeSound = 'ORGMPistolClose',
    cockSound = nil
}
Sounds.Profiles["SMG"] = {
    clickSound = 'ORGMSMGEmpty',
    insertSound = 'ORGMSMGIn',
    ejectSound = 'ORGMSMGOut',
    rackSound = 'ORGMSMGRack',
    openSound = nil,
    closeSound = nil,
    cockSound = nil
}
Sounds.Profiles["Rifle-Auto"] = {
    clickSound = 'ORGMRifleEmpty',
    insertSound = 'ORGMRifleIn',
    ejectSound = 'ORGMRifleOut',
    rackSound = 'ORGMRifleRack',
    openSound = nil,
    closeSound = nil,
    cockSound = nil
}
Sounds.Profiles["Rifle-Auto-IM"] = {
    clickSound = 'ORGMRifleEmpty',
    insertSound = 'ORGMMagLoad',
    ejectSound = 'ORGMRifleOut',
    rackSound = 'ORGMRifleRack',
    openSound = nil,
    closeSound = nil,
    cockSound = nil
}
Sounds.Profiles["Rifle-Bolt"] = {
    clickSound = 'ORGMRifleEmpty',
    insertSound = 'ORGMMagLoad',
    ejectSound = 'ORGMRifleOut',
    rackSound = 'ORGMRifleBolt',
    openSound = nil,
    closeSound = nil,
    cockSound = nil
    --bulletOutSound = "ORGMRifleBolt"
}
Sounds.Profiles["Rifle-Bolt-IM"] = {
    clickSound = 'ORGMRifleEmpty',
    insertSound = 'ORGMRifleIn',
    ejectSound = nil,
    rackSound = 'ORGMRifleBolt',
    openSound = nil,
    closeSound = nil,
    cockSound = nil
    --bulletOutSound = "ORGMRifleBolt"
}
Sounds.Profiles["Rifle-Lever"] = {
    clickSound = 'ORGMRifleEmpty',
    insertSound = 'ORGMMagLoad',
    ejectSound = nil,
    rackSound = 'ORGMRifleLever',
    openSound = nil,
    closeSound = nil,
    cockSound = nil
    --bulletOutSound = "ORGMRifleLever"
}
Sounds.Profiles["Rifle-AR"] = {
    clickSound = 'ORGMRifleEmpty',
    insertSound = 'ORGMARIn',
    ejectSound = 'ORGMAROut',
    rackSound = 'ORGMARRack',
    openSound = nil,
    closeSound = nil,
    cockSound = nil
}
Sounds.Profiles["Shotgun"] = { -- Pump, auto, bolt
    clickSound = 'ORGMShotgunEmpty',
    insertSound = 'ORGMShotgunRoundIn',
    ejectSound = nil,
    rackSound = 'ORGMShotgunRack',
    openSound = nil,
    closeSound = nil,
    cockSound = nil
    --bulletOutSound = 'ORGMShotgunRack'
}
Sounds.Profiles["Shotgun-Lever"] = {
    clickSound = 'ORGMShotgunEmpty',
    insertSound = 'ORGMShotgunRoundIn',
    ejectSound = nil,
    rackSound = 'ORGMRifleLever',
    openSound = nil,
    closeSound = nil,
    cockSound = nil
    --bulletOutSound = 'ORGMRifleLever'
}
Sounds.Profiles["Shotgun-Break"] = {
    rackSound = 'ORGMShotgunDBRack',
    clickSound = 'ORGMShotgunEmpty',
    insertSound = 'ORGMShotgunRoundIn',
    ejectSound = nil,
    openSound = 'ORGMShotgunOpen',
    closeSound = nil,
    cockSound = nil
    --bulletOutSound = 'ORGMShotgunOpen'
}

--[[- Adds a sound to the QueueTable if its not already there.

This is called in `ORGM.Firearm.register`.

@tparam string name name of the sound (also the filename without .ogg extension)
@tparam nil|table data data to be passed to getFMODSoundBank():addSound(). Any missing Key/Value pairs are set to a default.

]]
Sounds.add = function(name, data)
    if QueueTable[name] then return end
    ORGM.log(ORGM.DEBUG, "Sounds: Adding ".. name .. " to QueueTable")
    if not data then data = {} end
    data.gain = data.gain or 1
    data.minrange = data.minrange or 0.001
    data.maxrange = data.maxrange or 25
    data.maxreverbrange = data.maxreverbrange or 25
    data.reverbfactor = data.reverbfactor or 1.0
    data.priority = data.priority or 5
    QueueTable[name] = data
end


--[[-  Adds any sounds in the QueueTable to the FMOD soundbanks.

This is triggered by `ORGM.Callbacks.loadSoundBanks`.

]]
Sounds.setup = function()
    ORGM.log(ORGM.DEBUG, "Sounds: Setting up soundbanks...")
    if getFMODSoundBank().addSound then -- check the function exists, so we dont throw a exception with PZ build 40
        for key, value in pairs(QueueTable) do
            ORGM.log(ORGM.VERBOSE, "Sounds: Adding ".. key .. " with getFMODSoundBank():addSound()")
            getFMODSoundBank():addSound(key, "media/sound/" .. key .. ".ogg", value.gain, value.minrange, value.maxrange, value.maxreverbrange, value.reverbfactor, value.priority, false)
        end
    else -- build 40, need a sounds.txt file
        local swingSounds = { }
        local insert = table.insert
        for name, details in pairs(ORGM.Firearm.getTable()) do repeat
            local sound = details.instance:getSwingSound()
            local range = details.instance:getSoundRadius()
            if not sound or not range then break end
            if swingSounds[sound] and swingSounds[sound] >= range then break end
            swingSounds[sound] = range
        until true end
        local script = {"module Base {"}
        for sound, range in pairs(swingSounds) do
            table.insert(script, "\tsound ".. sound)
            table.insert(script, "\t{")
            table.insert(script, "\t\tcategory = Item,")
            table.insert(script, "\t\tclip")
            table.insert(script, "\t\t{")
            table.insert(script, "\t\t\tevent = ".. sound ..",")
            table.insert(script, "\t\t\tdistanceMax = ".. range ..",")
            table.insert(script, "\t\t}")
            table.insert(script, "\t}")
        end
        table.insert(script, "}")
        --print(table.concat(script, "\r\n"))
        --getScriptManager():ParseScript(table.concat(script, "\r\n"))
    end
    QueueTable = {}
end
