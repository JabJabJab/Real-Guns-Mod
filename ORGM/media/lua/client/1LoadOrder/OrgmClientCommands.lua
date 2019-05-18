--[[- Command Handler Functions.

These are triggered by `ORGM.Client.Callbacks.serverCommand` in response to a
OnServerCommand event.

It is unlikely that you will need to call any of these functions manually.

@module ORGM.Client.CommandHandler
@author Fenris_Wolf
@release v3.09
@copyright 2018 **File:** server/1LoadOrder/ORGMClientCommands.lua

]]



local ORGM = ORGM
local Settings = ORGM.Settings
local Client = ORGM.Client
local Callbacks = ORGM.Client.Callbacks
local CommandHandler = ORGM.Client.CommandHandler

local pairs = pairs
local tostring = tostring

--[[- Callback for the "updateSettings" server command.

@tparam variable args data to be passed onto the command call.

]]

CommandHandler.updateSettings = function(args)
    if not Client.PreviousSettings then
        Client.PreviousSettings = {}
        for key, value in pairs(Settings) do Client.PreviousSettings[key] = value end
    end

    for key, value in pairs(args) do
        ORGM.log(ORGM.DEBUG, "Server Setting "..tostring(key).."="..tostring(value))
        Settings[key] = value
    end

    Events.OnMainMenuEnter.Remove(Callbacks.restoreSettings)
    Events.OnMainMenuEnter.Add(Callbacks.restoreSettings)
end
