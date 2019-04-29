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
    clickSound = 'Revolver_Click_1',
    insertSound = 'Revolver_Load_1',
    ejectSound = nil,
    rackSound = 'Revolver_Cock_1',
    openSound = 'Revolver_Open_1',
    closeSound = 'Revolver_Close_1',
    cockSound = 'Revolver_Cock_1'
}
Sounds.Profiles["Pistol"] = {
    clickSound = 'Pistol_Click_1',
    insertSound = 'Mag_Insert_1',
    ejectSound = 'Mag_Eject_1',
    rackSound = 'Pistol_Rack_1',
    openSound = nil,
    closeSound = 'Pistol_Close_1',
    cockSound = nil
}
Sounds.Profiles["Pistol-Large"] = {
    clickSound = 'Pistol_Click_1',
    insertSound = 'Mag_Insert_6',
    ejectSound = 'Mag_Eject_6',
    rackSound = 'Pistol_Rack_1',
    openSound = nil,
    closeSound = 'Pistol_Close_1',
    cockSound = nil
}
Sounds.Profiles["SMG"] = {
    clickSound = 'Pistol_Click_2',
    insertSound = 'Mag_Insert_4',
    ejectSound = 'Mag_Eject_4',
    rackSound = 'Rifle_Rack_3',
    openSound = nil,
    closeSound = nil,
    cockSound = nil
}
Sounds.Profiles["Rifle-AR"] = {
    clickSound = 'Rifle_Click_1',
    insertSound = 'Mag_Insert_5',
    ejectSound = 'Mag_Eject_5',
    rackSound = 'Rifle_Rack_1',
    openSound = nil,
    closeSound = 'Pistol_Close_1',
    cockSound = nil
}

Sounds.Profiles["Rifle-Auto"] = {
    clickSound = 'Rifle_Click_1',
    insertSound = 'Mag_Insert_3',
    ejectSound = 'Mag_Eject_3',
    rackSound = 'Rifle_Rack2',
    openSound = nil,
    closeSound = 'Pistol_Close_1',
    cockSound = nil
}
Sounds.Profiles["Rifle-Auto-IM"] = {
    clickSound = 'Rifle_Click_1',
    insertSound = 'Mag_Load',
    ejectSound = nil,
    rackSound = 'Rifle_Rack_2',
    openSound = nil,
    closeSound = nil,
    cockSound = nil
}
Sounds.Profiles["Rifle-Bolt"] = {
    clickSound = 'ORGMRifleEmpty',
    insertSound = 'Mag_Insert_3',
    ejectSound = 'Mag_Eject_3',
    rackSound = 'Rifle_Rack_3',
    openSound = nil,
    closeSound = 'Pistol_Close_1',
    cockSound = nil
    --bulletOutSound = "ORGMRifleBolt"
}
Sounds.Profiles["Rifle-Bolt-IM"] = {
    clickSound = 'Rifle_Click_1',
    insertSound = 'Mag_Load',
    ejectSound = nil,
    rackSound = 'Rifle_Rack_3',
    openSound = nil,
    closeSound = nil,
    cockSound = nil
    --bulletOutSound = "ORGMRifleBolt"
}
Sounds.Profiles["Rifle-Lever"] = {
    clickSound = 'Rifle_Click_1',
    insertSound = 'Mag_Load',
    ejectSound = nil,
    rackSound = 'Lever_Rack_1',
    openSound = nil,
    closeSound = nil,
    cockSound = nil
    --bulletOutSound = "ORGMRifleLever"
}
Sounds.Profiles["Shotgun"] = { -- Pump, auto, bolt
    clickSound = 'Shotgun_Click_1',
    insertSound = 'Shotgun_Load_1',
    ejectSound = nil,
    rackSound = 'Shotgun_Rack_1',
    openSound = nil,
    closeSound = nil,
    cockSound = nil
    --bulletOutSound = 'ORGMShotgunRack'
}
Sounds.Profiles["Shotgun-Lever"] = {
    clickSound = 'Shotgun_Click_1',
    insertSound = 'Shotgun_Load_1',
    ejectSound = nil,
    rackSound = 'Lever_Rack_1',
    openSound = nil,
    closeSound = nil,
    cockSound = nil
    --bulletOutSound = 'ORGMRifleLever'
}
Sounds.Profiles["Shotgun-Break"] = {
    rackSound = 'Break_Close_1',
    clickSound = 'Shotgun_Click_1',
    insertSound = 'Break_Load',
    ejectSound = nil,
    openSound = 'Break_Open_1',
    closeSound = 'Break_Close_1',
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
    ORGM.log(ORGM.VERBOSE, "Sounds: Adding ".. name .. " to QueueTable")
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
