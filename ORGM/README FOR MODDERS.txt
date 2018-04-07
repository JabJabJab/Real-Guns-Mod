This document explains what you need to know for creating mods that are compatible with ORGM,
and for customizing ORGM.

Every aspect of ORGM can be customized and modified without having to actually touch ORGM's code
through the use of 'patch mods': a 3rd party mod (ie: yours) that gets loaded just like any other
mod and overwrites parts of ORGM when it gets loaded. You can modify ORGM's settings and all of
the functions this way.

-------------------------------------------
It is HIGHLY advised you use these methods instead of directly modifying ORGM's files and re-uploading 
them to the workshop. By doing so you will miss out on bug fixes and new features, screwing not only 
yourself, but users of your mod. This includes not only uploading custom versions, but 'Server Packs'
as well (thats what 'Collections' are for).

Please read the 'Credits and Permissions.txt' file, before you decide to modify this mod.
-------------------------------------------


Examples of patch mods can be found at https://github.com/FWolfe/RealGunsMod/tree/master/examples
or in the 'Patch Mod Examples.zip' file.


---------------------------------------------------------------------------------------
The following vanilla functions are overwritten. If your mod replaces these files, or overwrites
these specific functions, then its probably not going to be fully compatible with ORGM:

ISUI/ISToolTipInv:render()
Reloading/ISReloadManager:checkLoaded()
Reloading/ISReloadManager:startReloadFromUi()

*Reloading/ISReloadManager has several new functions injected into it.


---------------------------------------------------------------------------------------
Ammo: 
Ammo is handled very differently in ORGM. In the scripts/*.txt files, the AmmoType listed for guns
and magazines is NOT the name of the actual ammunition used. Instead it is a 'ammo group'. ORGM 
looks up the ammo group in a table to find the real names of the ammo used. A ammo group name is
Ammo_556x45mm, while the name of the real ammo in that group is Ammo_556x45mm_FMJ, Ammo_556x45mm_HP,
etc.  This allows ORGM to use multiple ammo types for the same firearm.

---------------------------------------------------------------------------------------
Firearm Stats:
A good number of the stats listed in the scripts/*.txt are actually irrelevant. The real stats (SwingTime,
RecoilDelay, Min/MaxDamage, etc) are set dynamically at key points: When a new component is attached 
or removed, when the firearm is equipped, when a new type of ammo is loaded into the chamber, etc. Thus
modifying these stats in the txt files will have no real effect.


---------------------------------------------------------------------------------------
File Structure:
The ORGM folder and file structure plays on the fact PZ loads file in alphabetical order. Thus folders 
are given names such as 1LoadOrder, 2LoadOrder, 3LoadOrder, etc. This ensures the important core parts
of ORGM are loaded before any patch mods.
The list of files and their purpose are listed below, in the order PZ loads them in.


---------------------------------
Shared files:

    shared/1LoadOrder/ORGMCore.lua
This file exports a single global table called ORGM.  All functions and important tables are part of this 
global table. THIS FILE MUST BE LOADED FIRST

    shared/2LoadOrder/ORGMFirearmStatHandler.lua
This file contains functions used to set the dynamic stats when equipping a firearm, or when a new type of
ammo is loaded into the chamber.  It sets things like damage, recoil delay, swingtime, aimtime etc based on
the ammo, weight of the firearm, and components that are attached.
    
    shared/2LoadOrder/ORGMRegisters.lua
This file adds item register functions into the ORGM table. These functions are used for (de)registering 
firearms, ammo, repair kits and firearm components (upgrades and parts) with the ORGM core. Error checking is 
done to ensure the item data conforms to expected values.

    shared/2LoadOrder/ORGMSharedFunctions.lua
Most functions shared by both client and servers are located in this file.

    shared/3LoadOrder/ISORGMMagazine.lua
The reloadable class used by magazines and speedloaders.

    shared/3LoadOrder/ISORGMReloadManager.lua
Overwrites some functions in the base game's Reloading/IsReloadManager.lua file, and injects new functions 
into it.

    shared/3LoadOrder/ISORGMUnloadAction.lua
The timed action class used to unload magazines and firearms.
    
    shared/3LoadOrder/ISORGMWeapon.lua
This is the file that does most of the magic, the reloadable class used by all ORGM firearms.
    
    shared/4DataFiles/ORGMData_Ammo.lua
This file contains all ammo data, and makes calls ORGM.registerAmmo.  If your looking for examples of adding 
ammo, this is the file to check.
    
    shared/4DataFiles/ORGMData_Components.lua
This file contains all firearm component/upgrades data, and makes calls ORGM.registerComponent.  If your looking 
for examples of adding components, this is the file to check.
    
    shared/4DataFiles/ORGMData_Magazine.lua
This file contains all magazine data, and makes calls ORGM.registerMagazine.  If your looking for examples of 
adding magazines, this is the file to check.
    
    shared/4DataFiles/ORGMData_RepairKits.lua
This file contains all repair kits data, and makes calls ORGM.registerRepairKit.  If your looking for examples 
of adding repair kits, this is the file to check.
    
    shared/4DataFiles/ORGMData_Weapons.lua
This file contains all firearm data, and makes calls ORGM.registerFirearm.  If your looking for examples of 
adding weapons, this is the file to check.
    
    shared/ORGMBackwardsCompatibility.lua
This file contains some global tables that were used by previous versions of ORGM but are now obsolete.
    
    shared/ORGMSharedCompatibilityPatches.lua
Contains stuff required for ORGM's built-in compatibility patches for 3rd party mods
    
    shared/ORGMSharedEventHooks.lua
This file calls all shared Events.*.Add() functions. These are kept separate from the actual callback functions 
for ease of seeing exactly which events are hooked. The files that contain the actual callback are listed in 
comments inside this file.


---------------------------------
Client files:

    client/1LoadOrder/ORGMClientContextMenus.lua
This file contains all right-click context menu functions. These functions are inserted into the ORGM.Client table.
    
    client/1LoadOrder/ORGMClientFunctions.lua
This file contains all client-side functions. These functions are inserted into the ORGM.Client table.

    client/1LoadOrder/ORGMClientOptions.lua    
Handles hotkey additions to the PZ options screen.
    
    client/1LoadOrder/ORGMClientOverrides.lua
All base game client functions that are overwritten have the new functions in this file.
    
    client/Compatibility/ORGMSurvivorsPatch_Client.lua
Compatibility for Nolan's Survivors and Super Survivors mods.
    
    client/ORGMClientCompatibilityPatches.lua
Contains stuff required for ORGM's built-in compatibility patches for 3rd party mods, except the Survivors mods which
use their own file to due the size.
    
    client/ORGMClientEventHooks.lua
This file calls all client-side Events.*.Add() functions. These are kept separate from the actual callback functions 
for ease of seeing exactly which events are hooked. The files that contain the actual callback are listed in comments 
inside this file.

    client/ORGMInspectionWindow.lua
Contains all the code for the 'Firearm Inspection Window' UI.


---------------------------------
Server files:

    server/1LoadOrder/ORGMDistribution.lua
This file adds spawning functions into the ORGM.Server table. It's responsible for handling all item spawning.

    server/1LoadOrder/ORGMRemovals.lua
This file handles removal of base firearms and ammo from the distribution tables.

    server/ORGMServerCompatibilityPatches.lua
Contains stuff required for ORGM's built-in compatibility patches for 3rd party mods.
    
    server/ORGMServerEventHooks.lua
This file calls all server-side Events.*.Add() functions. These are kept separate from the actual callback functions 
for ease of seeing exactly which events are hooked. The files that contain the actual callback are listed in comments 
inside this file.


---------------------------------------------------------------------------------------

