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
            if room.items[index] == "Pistol" then 
                table.remove(room.items, index);
                table.remove(room.items, index);
            elseif room.items[index] == "Shotgun" then
                table.remove(room.items, index);
                table.remove(room.items, index);
            elseif room.items[index] == "Sawnoff" then
                table.remove(room.items, index);
                table.remove(room.items, index);
            elseif room.items[index] == "VarmintRifle" then
                table.remove(room.items, index);
                table.remove(room.items, index);
            elseif room.items[index] == "HuntingRifle" then
                table.remove(room.items, index);
                table.remove(room.items, index);
            elseif room.items[index] == "Bullets9mm" then
                table.remove(room.items, index);
                table.remove(room.items, index);
            elseif room.items[index] == "ShotgunShells" then
                table.remove(room.items, index);
                table.remove(room.items, index);
            elseif room.items[index] == "223Bullets" then
                table.remove(room.items, index);
                table.remove(room.items, index);
            elseif room.items[index] == "308Bullets" then
                table.remove(room.items, index);
                table.remove(room.items, index);
            elseif room.items[index] == "BulletsBox" then
                table.remove(room.items, index);
                table.remove(room.items, index);
            elseif room.items[index] == "ShotgunShellsBox" then
                table.remove(room.items, index);
                table.remove(room.items, index);
            elseif room.items[index] == "223Box" then
                table.remove(room.items, index);
                table.remove(room.items, index);
            elseif room.items[index] == "308Box" then
                table.remove(room.items, index);
                table.remove(room.items, index);
            elseif room.items[index] == "HuntingRifleExtraClip" then
                table.remove(room.items, index);
                table.remove(room.items, index);
            elseif room.items[index] == "IronSight" then
                table.remove(room.items, index);
                table.remove(room.items, index);
            elseif room.items[index] == "x2Scope" then
                table.remove(room.items, index);
                table.remove(room.items, index);
            elseif room.items[index] == "x4Scope" then
                table.remove(room.items, index);
                table.remove(room.items, index);
            elseif room.items[index] == "x8Scope" then
                table.remove(room.items, index);
                table.remove(room.items, index);
            elseif room.items[index] == "AmmoStraps" then
                table.remove(room.items, index);
                table.remove(room.items, index);
            elseif room.items[index] == "Sling" then
                table.remove(room.items, index);
                table.remove(room.items, index);
            elseif room.items[index] == "FiberglassStock" then
                table.remove(room.items, index);
                table.remove(room.items, index);
            elseif room.items[index] == "RecoilPad" then
                table.remove(room.items, index);
                table.remove(room.items, index);
            elseif room.items[index] == "Laser" then
                table.remove(room.items, index);
                table.remove(room.items, index);
            elseif room.items[index] == "RedDot" then
                table.remove(room.items, index);
                table.remove(room.items, index);
            elseif room.items[index] == "ChokeTubeFull" then
                table.remove(room.items, index);
                table.remove(room.items, index);
            elseif room.items[index] == "ChokeTubeImproved" then
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
                    if container.items[index] == "Pistol" then 
                        table.remove(container.items, index);
                        table.remove(container.items, index);
                    elseif container.items[index] == "Shotgun" then
                        table.remove(container.items, index);
                        table.remove(container.items, index);
                    elseif container.items[index] == "Sawnoff" then
                        table.remove(container.items, index);
                        table.remove(container.items, index);
                    elseif container.items[index] == "VarmintRifle" then
                        table.remove(container.items, index);
                        table.remove(container.items, index);
                    elseif container.items[index] == "HuntingRifle" then
                        table.remove(container.items, index);
                        table.remove(container.items, index);
                    elseif container.items[index] == "Bullets9mm" then
                        table.remove(container.items, index);
                        table.remove(container.items, index);
                    elseif container.items[index] == "ShotgunShells" then
                        table.remove(container.items, index);
                        table.remove(container.items, index);
                    elseif container.items[index] == "223Bullets" then
                        table.remove(container.items, index);
                        table.remove(container.items, index);
                    elseif container.items[index] == "308Bullets" then
                        table.remove(container.items, index);
                        table.remove(container.items, index);
                    elseif container.items[index] == "BulletsBox" then
                        table.remove(container.items, index);
                        table.remove(container.items, index);
                    elseif container.items[index] == "ShotgunShellsBox" then
                        table.remove(container.items, index);
                        table.remove(container.items, index);
                    elseif container.items[index] == "223Box" then
                        table.remove(container.items, index);
                        table.remove(container.items, index);
                    elseif container.items[index] == "308Box" then
                        table.remove(container.items, index);
                        table.remove(container.items, index);
                    elseif container.items[index] == "HuntingRifleExtraClip" then
                        table.remove(container.items, index);
                        table.remove(container.items, index);
                    elseif container.items[index] == "IronSight" then
                        table.remove(container.items, index);
                        table.remove(container.items, index);
                    elseif container.items[index] == "x2Scope" then
                        table.remove(container.items, index);
                        table.remove(container.items, index);
                    elseif container.items[index] == "x4Scope" then
                        table.remove(container.items, index);
                        table.remove(container.items, index);
                    elseif container.items[index] == "x8Scope" then
                        table.remove(container.items, index);
                        table.remove(container.items, index);
                    elseif container.items[index] == "AmmoStraps" then
                        table.remove(container.items, index);
                        table.remove(container.items, index);
                    elseif container.items[index] == "Sling" then
                        table.remove(container.items, index);
                        table.remove(container.items, index);
                    elseif container.items[index] == "FiberglassStock" then
                        table.remove(container.items, index);
                        table.remove(container.items, index);
                    elseif container.items[index] == "RecoilPad" then
                        table.remove(container.items, index);
                        table.remove(container.items, index);
                    elseif container.items[index] == "Laser" then
                        table.remove(container.items, index);
                        table.remove(container.items, index);
                    elseif container.items[index] == "RedDot" then
                        table.remove(container.items, index);
                        table.remove(container.items, index);
                    elseif container.items[index] == "ChokeTubeFull" then
                        table.remove(container.items, index);
                        table.remove(container.items, index);
                    elseif container.items[index] == "ChokeTubeImproved" then
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
