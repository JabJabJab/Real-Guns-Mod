ORGM.Client.loadModels = function()
	local dir = getDir("ORGM")
	local locationModel = dir .. "/media/models/weapons_"
    local locationTexture = dir .. "/media/textures/Objects_"
    
	--                    (model name        , modelLocation, textureLocation )
	loadStaticZomboidModel("weapons_ar15", locationModel .. "ar15.txt", locationTexture .. "ar15.png")
	loadStaticZomboidModel("weapons_fnfal", locationModel .. "fnfal.txt", locationTexture .. "fnfal.png")
	loadStaticZomboidModel("weapons_g3", locationModel .. "g3.txt", locationTexture .. "g3.png")
	loadStaticZomboidModel("weapons_kalash", locationModel .. "kalash.txt", locationTexture .. "kalash.png")
	loadStaticZomboidModel("weapons_kriss", locationModel .. "kriss.txt", locationTexture .. "kriss.png")
	loadStaticZomboidModel("weapons_krissciv", locationModel .. "krissciv.txt", locationTexture .. "krissciv.png")
	loadStaticZomboidModel("weapons_m16", locationModel .. "m16.txt", locationTexture .. "m16.png")
	loadStaticZomboidModel("weapons_mp5", locationModel .. "mp5.txt", locationTexture .. "mp5.png")
	loadStaticZomboidModel("weapons_revolverlarge", locationModel .. "revolverlarge.txt", locationTexture .. "revolverlarge.png")
	loadStaticZomboidModel("weapons_ump", locationModel .. "ump.txt", locationTexture .. "ump.png")
	loadStaticZomboidModel("weapons_uzi", locationModel .. "uzi.txt", locationTexture .. "uzi.png")
	loadStaticZomboidModel("weapons_shotgunsawn", locationModel .. "shotgunsawn.txt", locationTexture .. "ShotgunSawn.png") 
	loadStaticZomboidModel("weapons_shotgunsawnblack", locationModel .. "shotgunsawnblack.txt", locationTexture .. "ShotgunSawn_Black.png") 
	loadStaticZomboidModel("weapons_shotgun", locationModel .. "shotgun.txt", locationTexture .. "Shotgun.png") 
	loadStaticZomboidModel("weapons_shotgunblack", locationModel .. "shotgunblack.txt", locationTexture .. "Shotgun_Black.png") 
	loadStaticZomboidModel("weapons_spas12", locationModel .. "spas12.txt", locationTexture .. "spas12.png") 
	loadStaticZomboidModel("weapons_glock22", locationModel .. "glock22.txt", locationTexture .. "glock22.png") 
	loadStaticZomboidModel("weapons_glock23", locationModel .. "glock23.txt", locationTexture .. "glock23.png") 
	loadStaticZomboidModel("weapons_model19bwg", locationModel .. "model19bwg.txt", locationTexture .. "model19_Black_WoodGrip.png") 
	loadStaticZomboidModel("weapons_model19cwg", locationModel .. "model19cwg.txt", locationTexture .. "model19_Chrome_WoodGrip.png") 
	loadStaticZomboidModel("weapons_model19cbg", locationModel .. "model19cbg.txt", locationTexture .. "model19_Chrome_BlackGrip.png") 
	loadStaticZomboidModel("weapons_rugermkii", locationModel .. "rugermkii.txt", locationTexture .. "rugermkii.png") 
	loadStaticZomboidModel("weapons_henry", locationModel .. "henry.txt", locationTexture .. "henry.png") 
	loadStaticZomboidModel("weapons_m14", locationModel .. "m14.txt", locationTexture .. "m14.png") 
	loadStaticZomboidModel("weapons_p90", locationModel .. "p90.txt", locationTexture .. "p90.png") 
	loadStaticZomboidModel("weapons_sa80", locationModel .. "sa80.txt", locationTexture .. "sa80.png") 
	loadStaticZomboidModel("weapons_sks", locationModel .. "sks.txt", locationTexture .. "sks.png") 
	loadStaticZomboidModel("weapons_svd", locationModel .. "svd.txt", locationTexture .. "svd.png") 
	loadStaticZomboidModel("weapons_mini14", locationModel .. "mini14.txt", locationTexture .. "mini14.png") 
	
    ORGM.log(ORGM.INFO, "All 3d models loaded.")
end	

--[[  ORGM.Client.checkFirearmBuildID(player, item)
    
    Note this function has the same name as the shared function ORGM.checkFirearmBuildID()
    but is client specific, and has slightly different arguments. It is meant to be called from
    Events.OnEquipPrimary listed in ORGMClientEventHooks.

]]
ORGM.Client.checkFirearmBuildID = function(player, item)
    if item == nil or player == nil then return end
    if ORGM.checkFirearmBuildID(item, player:getInventory()) then
        player:Say("Resetting this weapon to defaults due to ORGM changes. Unequipping.")
    end
end
