--[[ Compatibility for Nolan's ORGMSilencer Mod

]]
if ORGMUtil.isLoaded("ORGMSilencer") then
    --getTexture("Item_Silencer.png")
    
    -- instead of adding the silencers as random loot, since ORGM Rechambered's Distribution file
    -- isn't designed to handle non-ORGM items, we can add the silencers to the WeaponUpgrades
    -- table instead. This will allow guns to spawn with silencers attached.
    local silItem = InventoryItemFactory.CreateItem('Silencer.Silencer')
    for gunName, gunData in pairs(ORGMMasterWeaponTable) do
        local gunItem = getScriptManager():FindItem('ORGM.' .. gunName)
        
        if silItem:getMountOn():contains(gunItem:getDisplayName()) then
            table.insert(WeaponUpgrades[gunName], 'Silencer.Silencer')
        end
    end
end 