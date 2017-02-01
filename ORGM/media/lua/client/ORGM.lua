ORGM = {}
local MOD_ID = "ORGM";
local MOD_NAME = "ORMtnMan's Real Gun Mod";
local MOD_VERSION = "1.5";
local MOD_AUTHOR = "ORMtnMan";
local MOD_DESCRIPTION = "Adds in realistic weapons that might be found in the area.";


local function info()
    
	-- The directory of the mod folder. 
	dir = "ORGM";
	
	
	 print("Mod Loaded: " .. MOD_NAME .. " by " .. MOD_AUTHOR .. " (v" .. MOD_VERSION .. ") " .. dir);
	
end	

Events.OnGameBoot.Add(info);

