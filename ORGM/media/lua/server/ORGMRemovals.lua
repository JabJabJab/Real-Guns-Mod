--[[
    This file handles removing of all Base guns and ammo from the SuburbsDistributions table.
    TODO: this should fire after all mods have been loaded, to ensure no other mods add Base guns or ammo to additional containers
]]
require 'Items/SuburbsDistributions'
require 'Items/Distributions'
--Events.OnInitWorld.add
for roomName, room in pairs(SuburbsDistributions) do
    if room.items ~= nil then
        local index=1;
        while index <= #room.items do
            local thisItem = room.items[index]
            if thisItem == "Pistol" or thisItem == "Base.Pistol" then 
                table.remove(room.items, index);
                table.remove(room.items, index);
            elseif thisItem == "Shotgun" or thisItem == "Base.Shotgun" then
                table.remove(room.items, index);
                table.remove(room.items, index);
            elseif thisItem == "Sawnoff" or thisItem == "Base.Sawnoff" then
                table.remove(room.items, index);
                table.remove(room.items, index);
            elseif thisItem == "VarmintRifle" or thisItem == "Base.VarmintRifle" then
                table.remove(room.items, index);
                table.remove(room.items, index);
            elseif thisItem == "HuntingRifle" or thisItem == "Base.HuntingRifle" then
                table.remove(room.items, index);
                table.remove(room.items, index);
            elseif thisItem == "Bullets9mm" or thisItem == "Base.Bullets9mm" then
                table.remove(room.items, index);
                table.remove(room.items, index);
            elseif thisItem == "ShotgunShells" or thisItem == "Base.ShotgunShells" then
                table.remove(room.items, index);
                table.remove(room.items, index);
            elseif thisItem == "223Bullets" or thisItem == "Base.223Bullets" then
                table.remove(room.items, index);
                table.remove(room.items, index);
            elseif thisItem == "308Bullets" or thisItem == "Base.308Bullets" then
                table.remove(room.items, index);
                table.remove(room.items, index);
            elseif thisItem == "BulletsBox" or thisItem == "Base.BulletsBox" then
                table.remove(room.items, index);
                table.remove(room.items, index);
            elseif thisItem == "ShotgunShellsBox" or thisItem == "Base.ShotgunShellsBox" then
                table.remove(room.items, index);
                table.remove(room.items, index);
            elseif thisItem == "223Box" or thisItem == "Base.223Box" then
                table.remove(room.items, index);
                table.remove(room.items, index);
            elseif thisItem == "308Box" or thisItem == "Base.308Box" then
                table.remove(room.items, index);
                table.remove(room.items, index);
            elseif thisItem == "HuntingRifleExtraClip" or thisItem == "Base.HuntingRifleExtraClip" then
                table.remove(room.items, index);
                table.remove(room.items, index);
            elseif thisItem == "IronSight" or thisItem == "Base.IronSight" then
                table.remove(room.items, index);
                table.remove(room.items, index);
            elseif thisItem == "x2Scope" or thisItem == "Base.x2Scope" then
                table.remove(room.items, index);
                table.remove(room.items, index);
            elseif thisItem == "x4Scope" or thisItem == "Base.x4Scope" then
                table.remove(room.items, index);
                table.remove(room.items, index);
            elseif thisItem == "x8Scope" or thisItem == "Base.x8Scope" then
                table.remove(room.items, index);
                table.remove(room.items, index);
            elseif thisItem == "AmmoStraps" or thisItem == "Base.AmmoStraps" then
                table.remove(room.items, index);
                table.remove(room.items, index);
            elseif thisItem == "Sling" or thisItem == "Base.Sling" then
                table.remove(room.items, index);
                table.remove(room.items, index);
            elseif thisItem == "FiberglassStock" or thisItem == "Base.FiberglassStock" then
                table.remove(room.items, index);
                table.remove(room.items, index);
            elseif thisItem == "RecoilPad" or thisItem == "Base.RecoilPad" then
                table.remove(room.items, index);
                table.remove(room.items, index);
            elseif thisItem == "Laser" or thisItem == "Base.Laser" then
                table.remove(room.items, index);
                table.remove(room.items, index);
            elseif thisItem == "RedDot" or thisItem == "Base.RedDot" then
                table.remove(room.items, index);
                table.remove(room.items, index);
            elseif thisItem == "ChokeTubeFull" or thisItem == "Base.ChokeTubeFull" then
                table.remove(room.items, index);
                table.remove(room.items, index);
            elseif thisItem == "ChokeTubeImproved" or thisItem == "Base.ChokeTubeImproved" then
                table.remove(room.items, index);
                table.remove(room.items, index);
            else
                index = index + 1;
            end
        end
    else
        for containerName, container in pairs(room) do
            if container.items ~= nil then
                local index=1;
                while index <= #container.items do
                    local thisItem = container.items[index]
                    if thisItem == "Pistol" or thisItem == "Base.Pistol" then 
                        table.remove(container.items, index);
                        table.remove(container.items, index);
                    elseif thisItem == "Shotgun" or thisItem == "Base.Shotgun" then
                        table.remove(container.items, index);
                        table.remove(container.items, index);
                    elseif thisItem == "Sawnoff" or thisItem == "Base.Sawnoff" then
                        table.remove(container.items, index);
                        table.remove(container.items, index);
                    elseif thisItem == "VarmintRifle" or thisItem == "Base.VarmintRifle" then
                        table.remove(container.items, index);
                        table.remove(container.items, index);
                    elseif thisItem == "HuntingRifle" or thisItem == "Base.HuntingRifle" then
                        table.remove(container.items, index);
                        table.remove(container.items, index);
                    elseif thisItem == "Bullets9mm" or thisItem == "Base.Bullets9mm" then
                        table.remove(container.items, index);
                        table.remove(container.items, index);
                    elseif thisItem == "ShotgunShells" or thisItem == "Base.ShotgunShells" then
                        table.remove(container.items, index);
                        table.remove(container.items, index);
                    elseif thisItem == "223Bullets" or thisItem == "Base.223Bullets" then
                        table.remove(container.items, index);
                        table.remove(container.items, index);
                    elseif thisItem == "308Bullets" or thisItem == "Base.308Bullets" then
                        table.remove(container.items, index);
                        table.remove(container.items, index);
                    elseif thisItem == "BulletsBox" or thisItem == "Base.BulletsBox" then
                        table.remove(container.items, index);
                        table.remove(container.items, index);
                    elseif thisItem == "ShotgunShellsBox" or thisItem == "Base.ShotgunShellsBox" then
                        table.remove(container.items, index);
                        table.remove(container.items, index);
                    elseif thisItem == "223Box" or thisItem == "Base.223Box" then
                        table.remove(container.items, index);
                        table.remove(container.items, index);
                    elseif thisItem == "308Box" or thisItem == "Base.308Box" then
                        table.remove(container.items, index);
                        table.remove(container.items, index);
                    elseif thisItem == "HuntingRifleExtraClip" or thisItem == "Base.HuntingRifleExtraClip" then
                        table.remove(container.items, index);
                        table.remove(container.items, index);
                    elseif thisItem == "IronSight" or thisItem == "Base.IronSight" then
                        table.remove(container.items, index);
                        table.remove(container.items, index);
                    elseif thisItem == "x2Scope" or thisItem == "Base.x2Scope" then
                        table.remove(container.items, index);
                        table.remove(container.items, index);
                    elseif thisItem == "x4Scope" or thisItem == "Base.x4Scope" then
                        table.remove(container.items, index);
                        table.remove(container.items, index);
                    elseif thisItem == "x8Scope" or thisItem == "Base.x8Scope" then
                        table.remove(container.items, index);
                        table.remove(container.items, index);
                    elseif thisItem == "AmmoStraps" or thisItem == "Base.AmmoStraps" then
                        table.remove(container.items, index);
                        table.remove(container.items, index);
                    elseif thisItem == "Sling" or thisItem == "Base.Sling" then
                        table.remove(container.items, index);
                        table.remove(container.items, index);
                    elseif thisItem == "FiberglassStock" or thisItem == "Base.FiberglassStock" then
                        table.remove(container.items, index);
                        table.remove(container.items, index);
                    elseif thisItem == "RecoilPad" or thisItem == "Base.RecoilPad" then
                        table.remove(container.items, index);
                        table.remove(container.items, index);
                    elseif thisItem == "Laser" or thisItem == "Base.Laser" then
                        table.remove(container.items, index);
                        table.remove(container.items, index);
                    elseif thisItem == "RedDot" or thisItem == "Base.RedDot" then
                        table.remove(container.items, index);
                        table.remove(container.items, index);
                    elseif thisItem == "ChokeTubeFull" or thisItem == "Base.ChokeTubeFull" then
                        table.remove(container.items, index);
                        table.remove(container.items, index);
                    elseif thisItem == "ChokeTubeImproved" or thisItem == "Base.ChokeTubeImproved" then
                        table.remove(container.items, index);
                        table.remove(container.items, index);
                    else
                        index = index + 1;
                    end
                end
            end
        end
    end
end

--[[
for roomName, room in pairs(SuburbsDistributions) do
    if room.items ~= nil then
        local index=1;
        while index <= #room.items do
            print(roomName .. " : " .. room.items[index] .. "=".. room.items[index+1])
            index = index + 2;
        end
    else
        for containerName, container in pairs(room) do
            if container.items ~= nil then
                local index=1;
                while index <= #container.items do
                    print(roomName .. " / " .. containerName .. " : " .. container.items[index] .. "=" .. container.items[index+1])
                    index = index + 2;
                end
            end
        end
    end
end
]]