ORGM = {}
local MOD_ID = "ORGM";
local MOD_NAME = "ORMtnMan's Real Gun Mod";
local MOD_VERSION = "1.24";
local MOD_AUTHOR = "ORMtnMan";
local MOD_DESCRIPTION = "Adds in realistic weapons that might be found in the area.";


local function info()
    
	-- The directory of the mod folder. 
	dir = getDir("ORGM");
	
	-- quick extension strings.
	em = ".txt";
	et = ".png"; 
	
	name = "ar15";
	locationModel = dir .. "/media/models/" .. "weapons_" .. name .. em;
	locationTexture = dir .. "/media/textures/" .. "Objects_" .. name .. et; 
	--                    (model name        , modelLocation, textureLocation )
	loadStaticZomboidModel("weapons_" .. name, locationModel, locationTexture ) ;
	
	name = "fnfal";
	locationModel = dir .. "/media/models/" .. "weapons_" .. name .. em;
	locationTexture = dir .. "/media/textures/" .. "Objects_" .. name .. et; 
	loadStaticZomboidModel("weapons_" .. name, locationModel, locationTexture ) ;
	
	name = "g3";
	locationModel = dir .. "/media/models/" .. "weapons_" .. name .. em;
	locationTexture = dir .. "/media/textures/" .. "Objects_" .. name .. et; 
	loadStaticZomboidModel("weapons_" .. name, locationModel, locationTexture ) ;
	
	name = "kalash";
	locationModel = dir .. "/media/models/" .. "weapons_" .. name .. em;
	locationTexture = dir .. "/media/textures/" .. "Objects_" .. name .. et; 
	loadStaticZomboidModel("weapons_" .. name, locationModel, locationTexture ) ;
	
	name = "kriss";
	locationModel = dir .. "/media/models/" .. "weapons_" .. name .. em;
	locationTexture = dir .. "/media/textures/" .. "Objects_" .. name .. et; 
	loadStaticZomboidModel("weapons_" .. name, locationModel, locationTexture ) ;
	
	name = "krissciv";
	locationModel = dir .. "/media/models/" .. "weapons_" .. name .. em;
	locationTexture = dir .. "/media/textures/" .. "Objects_" .. name .. et; 
	loadStaticZomboidModel("weapons_" .. name, locationModel, locationTexture ) ;
	
	name = "m16";
	locationModel = dir .. "/media/models/" .. "weapons_" .. name .. em;
	locationTexture = dir .. "/media/textures/" .. "Objects_" .. name .. et; 
	loadStaticZomboidModel("weapons_" .. name, locationModel, locationTexture ) ;
	
	name = "mp5";
	locationModel = dir .. "/media/models/" .. "weapons_" .. name .. em;
	locationTexture = dir .. "/media/textures/" .. "Objects_" .. name .. et; 
	loadStaticZomboidModel("weapons_" .. name, locationModel, locationTexture ) ;
	
	name = "revolverlarge";
	locationModel = dir .. "/media/models/" .. "weapons_" .. name .. em;
	locationTexture = dir .. "/media/textures/" .. "Objects_" .. name .. et; 
	loadStaticZomboidModel("weapons_" .. name, locationModel, locationTexture ) ;
	
	name = "ump";
	locationModel = dir .. "/media/models/" .. "weapons_" .. name .. em;
	locationTexture = dir .. "/media/textures/" .. "Objects_" .. name .. et; 
	loadStaticZomboidModel("weapons_" .. name, locationModel, locationTexture ) ;
	
	name = "uzi";
	locationModel = dir .. "/media/models/" .. "weapons_" .. name .. em;
	locationTexture = dir .. "/media/textures/" .. "Objects_" .. name .. et; 
	loadStaticZomboidModel("weapons_" .. name, locationModel, locationTexture ) ;
	
	name = "shotgunsawn";
	locationModel = dir .. "/media/models/" .. "weapons_" .. name .. em;
	locationTexture = dir .. "/media/textures/" .. "Objects_" .. "ShotgunSawn" .. et; 
	loadStaticZomboidModel("weapons_" .. name, locationModel, locationTexture ) ;
	
	name = "shotgunsawnblack";
	locationModel = dir .. "/media/models/" .. "weapons_" .. name .. em;
	locationTexture = dir .. "/media/textures/" .. "Objects_" .. "ShotgunSawn_Black" .. et; 
	loadStaticZomboidModel("weapons_" .. name, locationModel, locationTexture ) ;
	
	name = "shotgun";
	locationModel = dir .. "/media/models/" .. "weapons_" .. name .. em;
	locationTexture = dir .. "/media/textures/" .. "Objects_" .. "Shotgun" .. et; 
	loadStaticZomboidModel("weapons_" .. name, locationModel, locationTexture ) ;
	
	name = "shotgunblack";
	locationModel = dir .. "/media/models/" .. "weapons_" .. name .. em;
	locationTexture = dir .. "/media/textures/" .. "Objects_" .. "Shotgun_Black" .. et; 
	loadStaticZomboidModel("weapons_" .. name, locationModel, locationTexture ) ;
	
	name = "spas12";
	locationModel = dir .. "/media/models/" .. "weapons_" .. name .. em;
	locationTexture = dir .. "/media/textures/" .. "Objects_" .. name .. et; 
	loadStaticZomboidModel("weapons_" .. name, locationModel, locationTexture ) ;
	
	name = "glock22";
	locationModel = dir .. "/media/models/" .. "weapons_" .. name .. em;
	locationTexture = dir .. "/media/textures/" .. "Objects_" .. name .. et; 
	loadStaticZomboidModel("weapons_" .. name, locationModel, locationTexture ) ;
	
	name = "glock23";
	locationModel = dir .. "/media/models/" .. "weapons_" .. name .. em;
	locationTexture = dir .. "/media/textures/" .. "Objects_" .. name .. et; 
	loadStaticZomboidModel("weapons_" .. name, locationModel, locationTexture ) ;
	
	name = "model19bwg";
	locationModel = dir .. "/media/models/" .. "weapons_" .. name .. em;
	locationTexture = dir .. "/media/textures/" .. "Objects_" .. "model19_Black_WoodGrip" .. et; 
	loadStaticZomboidModel("weapons_" .. name, locationModel, locationTexture ) ;
	
	name = "model19cwg";
	locationModel = dir .. "/media/models/" .. "weapons_" .. name .. em;
	locationTexture = dir .. "/media/textures/" .. "Objects_" .. "model19_Chrome_WoodGrip" .. et; 
	loadStaticZomboidModel("weapons_" .. name, locationModel, locationTexture ) ;
	
	name = "model19cbg";
	locationModel = dir .. "/media/models/" .. "weapons_" .. name .. em;
	locationTexture = dir .. "/media/textures/" .. "Objects_" .. "model19_Chrome_BlackGrip" .. et; 
	loadStaticZomboidModel("weapons_" .. name, locationModel, locationTexture ) ;
	
	name = "rugermkii";
	locationModel = dir .. "/media/models/" .. "weapons_" .. name .. em;
	locationTexture = dir .. "/media/textures/" .. "Objects_" .. "rugermkii" .. et; 
	loadStaticZomboidModel("weapons_" .. name, locationModel, locationTexture ) ;
	
	name = "henry";
	locationModel = dir .. "/media/models/" .. "weapons_" .. name .. em;
	locationTexture = dir .. "/media/textures/" .. "Objects_" .. "henry" .. et; 
	loadStaticZomboidModel("weapons_" .. name, locationModel, locationTexture ) ;
	
	name = "m14";
	locationModel = dir .. "/media/models/" .. "weapons_" .. name .. em;
	locationTexture = dir .. "/media/textures/" .. "Objects_" .. "m14" .. et; 
	loadStaticZomboidModel("weapons_" .. name, locationModel, locationTexture ) ;
	
	name = "p90";
	locationModel = dir .. "/media/models/" .. "weapons_" .. name .. em;
	locationTexture = dir .. "/media/textures/" .. "Objects_" .. "p90" .. et; 
	loadStaticZomboidModel("weapons_" .. name, locationModel, locationTexture ) ;
	
	name = "sa80";
	locationModel = dir .. "/media/models/" .. "weapons_" .. name .. em;
	locationTexture = dir .. "/media/textures/" .. "Objects_" .. "sa80" .. et; 
	loadStaticZomboidModel("weapons_" .. name, locationModel, locationTexture ) ;
	
	name = "sks";
	locationModel = dir .. "/media/models/" .. "weapons_" .. name .. em;
	locationTexture = dir .. "/media/textures/" .. "Objects_" .. "sks" .. et; 
	loadStaticZomboidModel("weapons_" .. name, locationModel, locationTexture ) ;
	
	name = "svd";
	locationModel = dir .. "/media/models/" .. "weapons_" .. name .. em;
	locationTexture = dir .. "/media/textures/" .. "Objects_" .. "svd" .. et; 
	loadStaticZomboidModel("weapons_" .. name, locationModel, locationTexture ) ;
	
	name = "mini14";
	locationModel = dir .. "/media/models/" .. "weapons_" .. name .. em;
	locationTexture = dir .. "/media/textures/" .. "Objects_" .. "svd" .. et; 
	loadStaticZomboidModel("weapons_" .. name, locationModel, locationTexture ) ;
	
	 print("Mod Loaded: " .. MOD_NAME .. " by " .. MOD_AUTHOR .. " (v" .. MOD_VERSION .. ") " .. dir);
	
end	

Events.OnGameBoot.Add(info);

