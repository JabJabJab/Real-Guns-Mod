This document explains what you need to know for creating mods that are compatible with ORGM.

Examples of patch mods can be found at https://github.com/FWolfe/RealGunsMod/tree/master/examples
or in the 'Patch Mod Examples.zip' file.

The following vanilla functions are overwritten. If your mod replaces these files, or overwrites
these specific functions, then its probably not going to be fully compatible with ORGM:

ISUI/ISToolTipInv:render()
Reloading/ISReloadManager:checkLoaded()
Reloading/ISReloadManager:startReloadFromUi()

*Reloading/ISReloadManager has several new functions injected into it.


---------------------------------------------------------------------------------------


The ORGM folder and file structure plays on the fact PZ loads file in alphabetical order. Thus folders are given 
names such as 1LoadOrder, 2LoadOrder, 3LoadOrder, etc. The list of files and their purpose are listed below, in 
the order PZ loads them in.

---------------------------------
Shared files:

    shared/1LoadOrder/ORGMCore.lua
This file exports a single global table called ORGM.  All functions and important tables are part of this 
global table. THIS FILE MUST BE LOADED FIRST

    shared/2LoadOrder/ORGMRegisters.lua
This file adds item register functions into the ORGM table. These functions are used for (de)registering firearms, ammo,
repair kits and firearm components (upgrades and parts) with the ORGM core. Error checking is done to ensure the item 
data conforms to expected values.

    shared/2LoadOrder/ORGMSharedFunctions.lua
Most functions shared by both client and servers are located in this file.

    shared/3LoadOrder/ISORGMMagazine.lua

    shared/3LoadOrder/ISORGMReloadManager.lua

    shared/3LoadOrder/ISORGMUnloadAction.lua

    shared/3LoadOrder/ISORGMWeapon.lua
    
    shared/4DataFiles/ORGMData_Ammo.lua
This file contains all ammo data, and makes calls ORGM.registerAmmo.  If your looking for examples of adding ammo, 
this is the file to check.
    
    shared/4DataFiles/ORGMData_Components.lua
This file contains all firearm component/upgrades data, and makes calls ORGM.registerComponent.  If your looking for 
examples of adding components, this is the file to check.
    
    shared/4DataFiles/ORGMData_Magazine.lua
This file contains all magazine data, and makes calls ORGM.registerMagazine.  If your looking for examples of adding 
magazines, this is the file to check.
    
    shared/4DataFiles/ORGMData_RepairKits.lua
This file contains all repair kits data, and makes calls ORGM.registerRepairKit.  If your looking for examples of adding 
repair kits, this is the file to check.
    
    shared/4DataFiles/ORGMData_Weapons.lua
This file contains all firearm data, and makes calls ORGM.registerFirearm.  If your looking for examples of adding 
weapons, this is the file to check.
    
    shared/ORGMBackwardsCompatibility.lua
    
    shared/ORGMSharedCompatibilityPatches.lua
    
    shared/ORGMSharedEventHooks.lua
    
    
---------------------------------
Client files:

    client/1LoadOrder/ORGMClientContextMenus.lua
This file contains all right-click context menu functions. These functions are inserted into the ORGM.Client table.
    
    client/1LoadOrder/ORGMClientFunctions.lua
This file contains all client-side functions. These functions are inserted into the ORGM.Client table.
    
    client/1LoadOrder/ORGMClientOverrides.lua
    
    client/Compatibility/ORGMSurvivorsPatch_Client.lua
    
    client/ORGMClientCompatibilityPatches.lua
    
    client/ORGMClientEventHooks.lua
This file calls all client-side Events.*.Add() functions. These are kept separate from the actual callback functions for ease 
of seeing exactly which events are hooked. The files that contain the actual callback are listed in comments inside this file.


---------------------------------
Server files:

    server/1LoadOrder/ORGMDistribution.lua
This file adds spawning functions into the ORGM.Server table.


    server/1LoadOrder/ORGMRemovals.lua
This file handles removal of base firearms and ammo from the distribution tables.

    server/ORGMServerCompatibilityPatches.lua

    server/ORGMServerEventHooks.lua
This file calls all server-side Events.*.Add() functions. These are kept separate from the actual callback functions for ease 
of seeing exactly which events are hooked. The files that contain the actual callback are listed in comments inside this file.


---------------------------------------------------------------------------------------

