--************************************************************************--
--** ORGMReloadUtil
--**
--************************************************************************--
ORGMReloadUtil2 = ISReloadUtil:derive("ORGMReloadUtil2");

local SilverhawkSl = { type = "SilverhawkSl",
	moduleName = 'ORGM',
	reloadClass = 'ORGMWeaponManualIMNC',
	ammoType = '12gSlugRounds',
	rackSound = 'ORGMShotgunDBRack',
	shootSound = '12GShotgunFire',
	shootSoundPartial = '12GShotgunFire',
	clickSound = 'ORGMShotgunEmpty',
	insertSound = 'ORGMShotgunRoundIn',
	rackTime = 10,
  	bulletOutSound = 'ORGMShotgunOpen'};

local SilverHawkSOSl = { type = "SilverHawkSOSl",
	moduleName = 'ORGM',
	reloadClass = 'ORGMWeaponManualIMNC',
	ammoType = '12gSlugRounds',
	rackSound = 'ORGMShotgunDBRack',
	shootSound = '12GShotgunFire',
	shootSoundPartial = '12GShotgunFire',
	clickSound = 'ORGMShotgunEmpty',
	insertSound = 'ORGMShotgunRoundIn',
	rackTime = 10,
  	bulletOutSound = 'ORGMShotgunOpen'};

local Spas12Sl = { type = "Spas12Sl",
	moduleName = 'ORGM',
	reloadClass = 'ORGMWeaponAutoIM',
	ammoType = '12gSlugRounds',
	rackSound = 'ORGMShotgunRack',
	shootSound = '12GShotgunFire',
	shootSoundPartial = '12GShotgunFire',
	clickSound = 'ORGMShotgunEmpty',
	insertSound = 'ORGMShotgunRoundIn',
	rackTime = 10,
  	bulletOutSound = 'ORGMShotgunRack'};
	
local Spas12PASl = { type = "Spas12PASl",
	moduleName = 'ORGM',
	reloadClass = 'ORGMWeaponManualIM',
	ammoType = '12gSlugRounds',
	rackSound = 'ORGMShotgunRack',
	shootSound = '12GShotgunFire',
	shootSoundPartial = '12GShotgunFire',
	clickSound = 'ORGMShotgunEmpty',
	insertSound = 'ORGMShotgunRoundIn',
	rackTime = 10,
  	bulletOutSound = 'ORGMShotgunRack'};

local Stevens320Sl = { type = "Stevens320Sl",
	moduleName = 'ORGM',
	reloadClass = 'ORGMWeaponManualIM',
	ammoType = '12gSlugRounds',
	rackSound = 'ORGMShotgunRack',
	shootSound = '12GShotgunFire',
	shootSoundPartial = '12GShotgunFire',
	clickSound = 'ORGMShotgunEmpty',
	insertSound = 'ORGMShotgunRoundIn',
	rackTime = 10,
  	bulletOutSound = 'ORGMShotgunRack'};

local Glock18SA = { type = "Glock18SA",
	moduleName = 'ORGM',
	reloadClass = 'ORGMWeaponAutoMF',
	ammoType = 'Glock17Mag',
	clipName = 'Glock 17 Magazine (9mm)',
	clipIcon = 'Glock17Mag',
	shootSound = '9mmFire',
	clickSound = 'ORGMSmallPistolEmpty',
	ejectSound = 'ORGMSmallPistolOut',
	insertSound = 'ORGMSmallPistolIn',
	rackSound = 'ORGMSmallPistolRack',
	containsClip = 1,
	rackTime = 10,
	clipData = Glock17Mag };
	
local Ber93RSA = { type = "Ber93RSA",
	moduleName = 'ORGM',
	reloadClass = 'ORGMWeaponAutoMF',
	ammoType = 'Ber93RMag',
	clipName = 'Beretta 93R Magazine (9mm)',
	clipIcon = 'Ber93RMag',
	shootSound = '9mmFire',
	clickSound = 'ORGMSmallPistolEmpty',
	ejectSound = 'ORGMSmallPistolOut',
	insertSound = 'ORGMSmallPistolIn',
	rackSound = 'ORGMSmallPistolRack',
	containsClip = 1,
	rackTime = 10,
	clipData = Ber93RMag };

local VEPR12Sl = { type = "VEPR12Sl",
	moduleName = 'ORGM',
	reloadClass = 'ORGMWeaponAutoMF',
	ammoType = 'VEPR12SlMag',
	clipName = 'VEPR-12 Magazine (12 gauge slugs)',
	clipIcon = 'VEPR12Mag',
	shootSound = '12GShotgunFire',
	clickSound = 'ORGMShotgunEmpty',
	ejectSound = 'ORGMAROut',
	insertSound = 'ORGMARIn',
	rackSound = 'ORGMARRack',
	containsClip = 1,
	rackTime = 10,
	clipData = VEPR12SlMag };

local VEPR12SlMag = { type = "VEPR12SlMag",
	moduleName = 'ORGM',
	reloadClass = 'ORGMMagazine',
	clipType = 'VEPR12SlMag',
	ammoType = '12gSlugRounds',
	shootSound = 'none',
	clickSound = nil,
	ejectSound = 'ORGMShotgunRoundIn',
	insertSound = 'ORGMShotgunRoundIn',
	rackSound = 'ORGMShotgunRoundIn',
	containsClip = 0,
	maxCapacity = 8,
	reloadTime = 15,
	rackTime = 10};

local M1216Sl = { type = "M1216Sl",
	moduleName = 'ORGM',
	reloadClass = 'ORGMWeaponAutoMF',
	ammoType = 'M1216SlMag',
	clipName = 'SRM Arms Model 1216 Magazine (12 gauge slugs)',
	clipIcon = 'M1216Mag',
	shootSound = '12GShotgunFire',
	clickSound = 'ORGMShotgunEmpty',
	ejectSound = 'ORGMAROut',
	insertSound = 'ORGMARIn',
	rackSound = 'ORGMARRack',
	containsClip = 1,
	rackTime = 10,
	clipData = M1216SlMag };

local M1216SlugMag = { type = "M1216SlMag",
	moduleName = 'ORGM',
	reloadClass = 'ORGMMagazine',
	clipType = 'M1216SlMag',
	ammoType = '12gSlugRounds',
	shootSound = 'none',
	clickSound = nil,
	ejectSound = 'ORGMShotgunRoundIn',
	insertSound = 'ORGMShotgunRoundIn',
	rackSound = 'ORGMShotgunRoundIn',
	containsClip = 0,
	maxCapacity = 16,
	reloadTime = 15,
	rackTime = 10};

local ColtAnac = { type = "ColtAnac",
	moduleName = 'ORGM',
	reloadClass = 'ORGMWeaponAutoIMNCSL',
	ammoType = 'SpeedLoader446',
	clipName = '.44 Magnum 6 round Speed Loader',
	clipIcon = '44SpeedLoader6',
	shootSound = '44Fire',
    clickSound = 'ORGMRevolverEmpty',
	openSound = 'ORGMRevolverOpen',
	insertSound = 'ORGMMagLoad',
	closeSound = 'ORGMRevolverClose',
    rackSound = 'ORGMRevolverCock',
	rackTime = 10,
	clipData = SpeedLoader446 };
	
local SpeedLoader446 = { type = "SpeedLoader446",
	moduleName = 'ORGM',
	reloadClass = 'ORGMMagazine',
	clipType = 'SpeedLoader446',
	ammoType = '44Rounds',
	shootSound = 'none',
	clickSound = nil,
	ejectSound = 'ORGMMagLoad',
	insertSound = 'ORGMMagLoad',
	rackSound = 'ORGMMagLoad',
	containsClip = 0,
	maxCapacity = 6,
	reloadTime = 15,
	rackTime = 10};

local SpeedLoader3576 = { type = "SpeedLoader3576",
	moduleName = 'ORGM',
	reloadClass = 'ORGMMagazine',
	clipType = 'SpeedLoader3576',
	ammoType = '357Rounds',
	shootSound = 'none',
	clickSound = nil,
	ejectSound = 'ORGMMagLoad',
	insertSound = 'ORGMMagLoad',
	rackSound = 'ORGMMagLoad',
	containsClip = 0,
	maxCapacity = 6,
	reloadTime = 15,
	rackTime = 10};
	
local SpeedLoader386 = { type = "SpeedLoader386",
	moduleName = 'ORGM',
	reloadClass = 'ORGMMagazine',
	clipType = 'SpeedLoader386',
	ammoType = '38Rounds',
	shootSound = 'none',
	clickSound = nil,
	ejectSound = 'ORGMMagLoad',
	insertSound = 'ORGMMagLoad',
	rackSound = 'ORGMMagLoad',
	containsClip = 0,
	maxCapacity = 6,
	reloadTime = 15,
	rackTime = 10};

local SpeedLoader385 = { type = "SpeedLoader385",
	moduleName = 'ORGM',
	reloadClass = 'ORGMMagazine',
	clipType = 'SpeedLoader385',
	ammoType = '38Rounds',
	shootSound = 'none',
	clickSound = nil,
	ejectSound = 'ORGMMagLoad',
	insertSound = 'ORGMMagLoad',
	rackSound = 'ORGMMagLoad',
	containsClip = 0,
	maxCapacity = 5,
	reloadTime = 15,
	rackTime = 10};

local SpeedLoader4546 = { type = "SpeedLoader4546",
	moduleName = 'ORGM',
	reloadClass = 'ORGMMagazine',
	clipType = 'SpeedLoader4546',
	ammoType = '454Rounds',
	shootSound = 'none',
	clickSound = nil,
	ejectSound = 'ORGMMagLoad',
	insertSound = 'ORGMMagLoad',
	rackSound = 'ORGMMagLoad',
	containsClip = 0,
	maxCapacity = 6,
	reloadTime = 15,
	rackTime = 10};
	
local SpeedLoader45C6 = { type = "SpeedLoader45C6",
	moduleName = 'ORGM',
	reloadClass = 'ORGMMagazine',
	clipType = 'SpeedLoader45C6',
	ammoType = '45ColtRounds',
	shootSound = 'none',
	clickSound = nil,
	ejectSound = 'ORGMMagLoad',
	insertSound = 'ORGMMagLoad',
	rackSound = 'ORGMMagLoad',
	containsClip = 0,
	maxCapacity = 6,
	reloadTime = 15,
	rackTime = 10};
	
local SpeedLoader10mm6 = { type = "SpeedLoader10mm6",
	moduleName = 'ORGM',
	reloadClass = 'ORGMMagazine',
	clipType = 'SpeedLoader10mm6',
	ammoType = '10mmRounds',
	shootSound = 'none',
	clickSound = nil,
	ejectSound = 'ORGMMagLoad',
	insertSound = 'ORGMMagLoad',
	rackSound = 'ORGMMagLoad',
	containsClip = 0,
	maxCapacity = 6,
	reloadTime = 15,
	rackTime = 10};
	
local SpeedLoader456 = { type = "SpeedLoader456",
	moduleName = 'ORGM',
	reloadClass = 'ORGMMagazine',
	clipType = 'SpeedLoader456',
	ammoType = '45Rounds',
	shootSound = 'none',
	clickSound = nil,
	ejectSound = 'ORGMMagLoad',
	insertSound = 'ORGMMagLoad',
	rackSound = 'ORGMMagLoad',
	containsClip = 0,
	maxCapacity = 6,
	reloadTime = 15,
	rackTime = 10};
		
local ColtSAA = { type = "ColtSAA",
        moduleName = 'ORGM',
        reloadClass = 'ORGMWeaponManualIMNC',
        ammoType = '45ColtRounds',
        rackSound = 'ORGMRevolverCock',
        shootSound = '45CFire',
        shootSoundPartial = '45CFire',
        clickSound = 'ORGMRevolverEmpty',
        insertSound = 'ORGMMagLoad',
        rackTime = 10,
        bulletOutSound = "ORGMRevolverCock"};
		
local RugBH = { type = "RugBH",
        moduleName = 'ORGM',
        reloadClass = 'ORGMWeaponManualIM',
        ammoType = '357Rounds',
        rackSound = 'ORGMRevolverCock',
        shootSound = '357Fire',
        shootSoundPartial = '357Fire',
        clickSound = 'ORGMRevolverEmpty',
        insertSound = 'ORGMMagLoad',
        rackTime = 10,
        bulletOutSound = "ORGMRevolverCock"};
		
local RugBH38 = { type = "RugBH38",
        moduleName = 'ORGM',
        reloadClass = 'ORGMWeaponManualIM',
        ammoType = '38Rounds',
        rackSound = 'ORGMRevolverCock',
        shootSound = '38Fire',
        shootSoundPartial = '38Fire',
        clickSound = 'ORGMRevolverEmpty',
        insertSound = 'ORGMMagLoad',
        rackTime = 10,
        bulletOutSound = "ORGMRevolverCock"};

local HenryBB = { type = "HenryBB",
        moduleName = 'ORGM',
        reloadClass = 'ORGMWeaponManualIM',
        ammoType = '45ColtRounds',
        rackSound = 'ORGMRifleLever',
        shootSound = '45CFire',
        shootSoundPartial = '45CFire',
        clickSound = 'ORGMRifleEmpty',
        insertSound = 'ORGMMagLoad',
        rackTime = 10,
        bulletOutSound = "ORGMRifleLever"};

local RugRH = { type = "RugRH",
	moduleName = 'ORGM',
	reloadClass = 'ORGMWeaponAutoIMNCSL',
	ammoType = 'SpeedLoader446',
	clipName = '.44 Magnum 6 round Speed Loader',
	clipIcon = '44SpeedLoader6',
	shootSound = '44Fire',
    clickSound = 'ORGMRevolverEmpty',
	openSound = 'ORGMRevolverOpen',
	insertSound = 'ORGMMagLoad',
	closeSound = 'ORGMRevolverClose',
    rackSound = 'ORGMRevolverCock',
	rackTime = 10,
	clipData = SpeedLoader446 };

local SWM29 = { type = "SWM29",
	moduleName = 'ORGM',
	reloadClass = 'ORGMWeaponAutoIMNCSL',
	ammoType = 'SpeedLoader446',
	clipName = '.44 Magnum 6 round Speed Loader',
	clipIcon = '44SpeedLoader6',
	shootSound = '44Fire',
    clickSound = 'ORGMRevolverEmpty',
	openSound = 'ORGMRevolverOpen',
	insertSound = 'ORGMMagLoad',
	closeSound = 'ORGMRevolverClose',
    rackSound = 'ORGMRevolverCock',
	rackTime = 10,
	clipData = SpeedLoader446 };

local DEagle = { type = "DEagle",
        moduleName = 'ORGM',
	reloadClass = 'ORGMWeaponAutoMF',
        ammoType = 'DEagleMag',
	clipName = 'IMI Desert Eagle Magazine (.44)',
	clipIcon = 'DEagleMag',
        shootSound = '44Fire',
	clickSound = 'ORGMPistolEmpty',
	ejectSound = 'ORGMPistolOut',
	insertSound = 'ORGMPistolIn',
	rackSound = 'ORGMPistolRack',
	containsClip = 1,
	rackTime = 10,
	clipData = DEagleMag };

local DEagleMag = { type = "DEagleMag",
	moduleName = 'ORGM',
	reloadClass = 'ORGMMagazine',
	clipType = 'DEagleMag',
	ammoType = '44Rounds',
	shootSound = 'none',
	clickSound = nil,
	ejectSound = 'ORGMMagLoad',
	insertSound = 'ORGMMagLoad',
	rackSound = 'ORGMMagLoad',
	containsClip = 0,
	maxCapacity = 8,
	reloadTime = 30,
	rackTime = 10};

local ColtPyth = { type = "ColtPyth",
	moduleName = 'ORGM',
	reloadClass = 'ORGMWeaponAutoIMNCSL',
	ammoType = 'SpeedLoader3576',
	clipName = '.357 Magnum 6 round Speed Loader',
	clipIcon = '357SpeedLoader6',
	shootSound = '357Fire',
    clickSound = 'ORGMRevolverEmpty',
	openSound = 'ORGMRevolverOpen',
	insertSound = 'ORGMMagLoad',
	closeSound = 'ORGMRevolverClose',
    rackSound = 'ORGMRevolverCock',
	rackTime = 10,
	clipData = SpeedLoader3576 };

local RugGP100 = { type = "RugGP100",
	moduleName = 'ORGM',
	reloadClass = 'ORGMWeaponAutoIMNCSL',
	ammoType = 'SpeedLoader3576',
	clipName = '.357 Magnum 6 round Speed Loader',
	clipIcon = '357SpeedLoader6',
	shootSound = '357Fire',
    clickSound = 'ORGMRevolverEmpty',
	openSound = 'ORGMRevolverOpen',
	insertSound = 'ORGMMagLoad',
	closeSound = 'ORGMRevolverClose',
    rackSound = 'ORGMRevolverCock',
	rackTime = 10,
	clipData = SpeedLoader3576 };

local SWM19 = { type = "SWM19",
	moduleName = 'ORGM',
	reloadClass = 'ORGMWeaponAutoIMNCSL',
	ammoType = 'SpeedLoader3576',
	clipName = '.357 Magnum 6 round Speed Loader',
	clipIcon = '357SpeedLoader6',
	shootSound = '357Fire',
    clickSound = 'ORGMRevolverEmpty',
	openSound = 'ORGMRevolverOpen',
	insertSound = 'ORGMMagLoad',
	closeSound = 'ORGMRevolverClose',
    rackSound = 'ORGMRevolverCock',
	rackTime = 10,
	clipData = SpeedLoader3576 };

local RugAlas = { type = "RugAlas",
	moduleName = 'ORGM',
	reloadClass = 'ORGMWeaponAutoIMNCSL',
	ammoType = 'SpeedLoader4546',
	clipName = '.454 Casull 6 round Speed Loader',
	clipIcon = '454SpeedLoader6',
	shootSound = '454Fire',
    clickSound = 'ORGMRevolverEmpty',
	openSound = 'ORGMRevolverOpen',
	insertSound = 'ORGMMagLoad',
	closeSound = 'ORGMRevolverClose',
    rackSound = 'ORGMRevolverCock',
	rackTime = 10,
	clipData = SpeedLoader4546 };

local Taurus454 = { type = "Taurus454",
	moduleName = 'ORGM',
	reloadClass = 'ORGMWeaponAutoIMNCSL',
	ammoType = 'SpeedLoader4546',
	clipName = '.454 Casull 6 round Speed Loader',
	clipIcon = '454SpeedLoader6',
	shootSound = '454Fire',
    clickSound = 'ORGMRevolverEmpty',
	openSound = 'ORGMRevolverOpen',
	insertSound = 'ORGMMagLoad',
	closeSound = 'ORGMRevolverClose',
    rackSound = 'ORGMRevolverCock',
	rackTime = 10,
	clipData = SpeedLoader4546 };

local ColtPyth38 = { type = "ColtPyth38",
	moduleName = 'ORGM',
	reloadClass = 'ORGMWeaponAutoIMNCSL',
	ammoType = 'SpeedLoader386',
	clipName = '.38 Special 6 round Speed Loader',
	clipIcon = '38SpeedLoader6',
	shootSound = '38Fire',
    clickSound = 'ORGMRevolverEmpty',
	openSound = 'ORGMRevolverOpen',
	insertSound = 'ORGMMagLoad',
	closeSound = 'ORGMRevolverClose',
    rackSound = 'ORGMRevolverCock',
	rackTime = 10,
	clipData = SpeedLoader386 };
	
local SWM10 = { type = "SWM10",
	moduleName = 'ORGM',
	reloadClass = 'ORGMWeaponAutoIMNCSL',
	ammoType = 'SpeedLoader386',
	clipName = '.38 Special 6 round Speed Loader',
	clipIcon = '38SpeedLoader6',
	shootSound = '38Fire',
    clickSound = 'ORGMRevolverEmpty',
	openSound = 'ORGMRevolverOpen',
	insertSound = 'ORGMMagLoad',
	closeSound = 'ORGMRevolverClose',
    rackSound = 'ORGMRevolverCock',
	rackTime = 10,
	clipData = SpeedLoader386 };
	
local SWM252 = { type = "SWM252",
	moduleName = 'ORGM',
	reloadClass = 'ORGMWeaponAutoIMNCSL',
	ammoType = 'SpeedLoader456',
	clipName = '.45 ACP 6 round Speed Loader',
	clipIcon = '45SpeedLoader6',
	shootSound = '45Fire',
    clickSound = 'ORGMRevolverEmpty',
	openSound = 'ORGMRevolverOpen',
	insertSound = 'ORGMMagLoad',
	closeSound = 'ORGMRevolverClose',
    rackSound = 'ORGMRevolverCock',
	rackTime = 10,
	clipData = SpeedLoader456 };

local RugGP10038 = { type = "RugGP10038",
	moduleName = 'ORGM',
	reloadClass = 'ORGMWeaponAutoIMNCSL',
	ammoType = 'SpeedLoader386',
	clipName = '.38 Special 6 round Speed Loader',
	clipIcon = '38SpeedLoader6',
	shootSound = '38Fire',
    clickSound = 'ORGMRevolverEmpty',
	openSound = 'ORGMRevolverOpen',
	insertSound = 'ORGMMagLoad',
	closeSound = 'ORGMRevolverClose',
    rackSound = 'ORGMRevolverCock',
	rackTime = 10,
	clipData = SpeedLoader386 };

local SWM1938 = { type = "SWM1938",
	moduleName = 'ORGM',
	reloadClass = 'ORGMWeaponAutoIMNCSL',
	ammoType = 'SpeedLoader386',
	clipName = '.38 Special 6 round Speed Loader',
	clipIcon = '38SpeedLoader6',
	shootSound = '38Fire',
    clickSound = 'ORGMRevolverEmpty',
	openSound = 'ORGMRevolverOpen',
	insertSound = 'ORGMMagLoad',
	closeSound = 'ORGMRevolverClose',
    rackSound = 'ORGMRevolverCock',
	rackTime = 10,
	clipData = SpeedLoader386 };

local RugAlas45C = { type = "RugAlas45C",
	moduleName = 'ORGM',
	reloadClass = 'ORGMWeaponAutoIMNCSL',
	ammoType = 'SpeedLoader45C6',
	clipName = '.45 Colt 6 round Speed Loader',
	clipIcon = '454SpeedLoader6',
	shootSound = '45CFire',
    clickSound = 'ORGMRevolverEmpty',
	openSound = 'ORGMRevolverOpen',
	insertSound = 'ORGMMagLoad',
	closeSound = 'ORGMRevolverClose',
    rackSound = 'ORGMRevolverCock',
	rackTime = 10,
	clipData = SpeedLoader45C6 };

local Taurus45445C = { type = "Taurus45445C",
	moduleName = 'ORGM',
	reloadClass = 'ORGMWeaponAutoIMNCSL',
	ammoType = 'SpeedLoader45C6',
	clipName = '.45 Colt 6 round Speed Loader',
	clipIcon = '454SpeedLoader6',
	shootSound = '45CFire',
    clickSound = 'ORGMRevolverEmpty',
	openSound = 'ORGMRevolverOpen',
	insertSound = 'ORGMMagLoad',
	closeSound = 'ORGMRevolverClose',
    rackSound = 'ORGMRevolverCock',
	rackTime = 10,
	clipData = SpeedLoader45C6 };

local RugSec6 = { type = "RugSec6",
	moduleName = 'ORGM',
	reloadClass = 'ORGMWeaponAutoIMNCSL',
	ammoType = 'SpeedLoader386',
	clipName = '.38 Special 6 round Speed Loader',
	clipIcon = '38SpeedLoader6',
	shootSound = '38Fire',
    clickSound = 'ORGMRevolverEmpty',
	openSound = 'ORGMRevolverOpen',
	insertSound = 'ORGMMagLoad',
	closeSound = 'ORGMRevolverClose',
    rackSound = 'ORGMRevolverCock',
	rackTime = 10,
	clipData = SpeedLoader386 };

local SWM36 = { type = "SWM36",
	moduleName = 'ORGM',
	reloadClass = 'ORGMWeaponAutoIMNCSL',
	ammoType = 'SpeedLoader385',
	clipName = '.38 Special 5 round Speed Loader',
	clipIcon = '38SpeedLoader5',
	shootSound = '38Fire',
    clickSound = 'ORGMRevolverEmpty',
	openSound = 'ORGMRevolverOpen',
	insertSound = 'ORGMMagLoad',
	closeSound = 'ORGMRevolverClose',
    rackSound = 'ORGMRevolverCock',
	rackTime = 10,
	clipData = SpeedLoader385 };

local SWM610 = { type = "SWM610",
	moduleName = 'ORGM',
	reloadClass = 'ORGMWeaponAutoIMNCSL',
	ammoType = 'SpeedLoader10mm6',
	clipName = '10mm Auto 6 round Speed Loader',
	clipIcon = '10mmSpeedLoader6',
	shootSound = '10mmFire',
    clickSound = 'ORGMRevolverEmpty',
	openSound = 'ORGMRevolverOpen',
	insertSound = 'ORGMMagLoad',
	closeSound = 'ORGMRevolverClose',
    rackSound = 'ORGMRevolverCock',
	rackTime = 10,
	clipData = SpeedLoader10mm6 };

local RugerSR9 = { type = "RugerSR9",
	moduleName = 'ORGM',
	reloadClass = 'ORGMWeaponAutoMF',
	ammoType = 'RugerSR9Mag',
	clipName = 'Ruger SR9 Magazine (9mm)',
	clipIcon = 'RugerSR9Mag',
	shootSound = '9mmFire',
	clickSound = 'ORGMSmallPistolEmpty',
	ejectSound = 'ORGMSmallPistolOut',
	insertSound = 'ORGMSmallPistolIn',
	rackSound = 'ORGMSmallPistolRack',
	containsClip = 1,
	rackTime = 10,
	clipData = RugerSR9Mag };

local RugerSR9Mag = { type = "RugerSR9Mag",
	moduleName = 'ORGM',
	reloadClass = 'ORGMMagazine',
	clipType = 'RugerSR9Mag',
	ammoType = '9mmRounds',
	shootSound = 'none',
	clickSound = nil,
	ejectSound = 'ORGMMagLoad',
	insertSound = 'ORGMMagLoad',
	rackSound = 'ORGMMagLoad',
	containsClip = 0,
	maxCapacity = 17,
	reloadTime = 30,
	rackTime = 10};
	
local Spr19119 = { type = "Spr19119",
	moduleName = 'ORGM',
	reloadClass = 'ORGMWeaponAutoMF',
	ammoType = 'Spr19119Mag',
	clipName = 'Springfield 1911 9mm Magazine (9mm)',
	clipIcon = 'Spr19119Mag',
	shootSound = '9mmFire',
	clickSound = 'ORGMSmallPistolEmpty',
	ejectSound = 'ORGMSmallPistolOut',
	insertSound = 'ORGMSmallPistolIn',
	rackSound = 'ORGMSmallPistolRack',
	containsClip = 1,
	rackTime = 10,
	clipData = Spr19119Mag };

local Spr19119Mag = { type = "Spr19119Mag",
	moduleName = 'ORGM',
	reloadClass = 'ORGMMagazine',
	clipType = 'Spr19119Mag',
	ammoType = '9mmRounds',
	shootSound = 'none',
	clickSound = nil,
	ejectSound = 'ORGMMagLoad',
	insertSound = 'ORGMMagLoad',
	rackSound = 'ORGMMagLoad',
	containsClip = 0,
	maxCapacity = 9,
	reloadTime = 30,
	rackTime = 10};
	
local KTP32 = { type = "KTP32",
	moduleName = 'ORGM',
	reloadClass = 'ORGMWeaponAutoMF',
	ammoType = 'KTP32Mag',
	clipName = 'Kel-Tec P-32 Magazine (.32ACP)',
	clipIcon = 'KTP32Mag',
	shootSound = '32Fire',
	clickSound = 'ORGMSmallPistolEmpty',
	ejectSound = 'ORGMSmallPistolOut',
	insertSound = 'ORGMSmallPistolIn',
	rackSound = 'ORGMSmallPistolRack',
	containsClip = 1,
	rackTime = 10,
	clipData = KTP32Mag };

local KTP32Mag = { type = "KTP32Mag",
	moduleName = 'ORGM',
	reloadClass = 'ORGMMagazine',
	clipType = 'KTP32Mag',
	ammoType = '32Rounds',
	shootSound = 'none',
	clickSound = nil,
	ejectSound = 'ORGMMagLoad',
	insertSound = 'ORGMMagLoad',
	rackSound = 'ORGMMagLoad',
	containsClip = 0,
	maxCapacity = 7,
	reloadTime = 30,
	rackTime = 10};
	
local TaurusP132 = { type = "TaurusP132",
	moduleName = 'ORGM',
	reloadClass = 'ORGMWeaponAutoMF',
	ammoType = 'TaurusP132Mag',
	clipName = 'Taurus Millennium P132 Magazine (.32ACP)',
	clipIcon = 'TaurusP132Mag',
	shootSound = '32Fire',
	clickSound = 'ORGMSmallPistolEmpty',
	ejectSound = 'ORGMSmallPistolOut',
	insertSound = 'ORGMSmallPistolIn',
	rackSound = 'ORGMSmallPistolRack',
	containsClip = 1,
	rackTime = 10,
	clipData = TaurusP132Mag };

local TaurusP132Mag = { type = "TaurusP132Mag",
	moduleName = 'ORGM',
	reloadClass = 'ORGMMagazine',
	clipType = 'TaurusP132Mag',
	ammoType = '32Rounds',
	shootSound = 'none',
	clickSound = nil,
	ejectSound = 'ORGMMagLoad',
	insertSound = 'ORGMMagLoad',
	rackSound = 'ORGMMagLoad',
	containsClip = 0,
	maxCapacity = 10,
	reloadTime = 30,
	rackTime = 10};
	
local Skorpion = { type = "Skorpion",
	moduleName = 'ORGM',
	reloadClass = 'ORGMWeaponAutoMF',
	ammoType = 'SkorpionMag',
	clipName = 'Skorpion vz. 61 Magazine (.32ACP)',
	clipIcon = 'SkorpionMag',
	shootSound = '32Fire',
	clickSound = 'ORGMSmallPistolEmpty',
	ejectSound = 'ORGMSmallPistolOut',
	insertSound = 'ORGMSmallPistolIn',
	rackSound = 'ORGMSmallPistolRack',
	containsClip = 1,
	rackTime = 10,
	clipData = SkorpionMag };

local SkorpionMag = { type = "SkorpionMag",
	moduleName = 'ORGM',
	reloadClass = 'ORGMMagazine',
	clipType = 'SkorpionMag',
	ammoType = '32Rounds',
	shootSound = 'none',
	clickSound = nil,
	ejectSound = 'ORGMMagLoad',
	insertSound = 'ORGMMagLoad',
	rackSound = 'ORGMMagLoad',
	containsClip = 0,
	maxCapacity = 20,
	reloadTime = 30,
	rackTime = 10};

local XD40 = { type = "XD40",
	moduleName = 'ORGM',
	reloadClass = 'ORGMWeaponAutoMF',
	ammoType = 'XD40Mag',
	clipName = 'Springfield XD-40 Magazine (.40)',
	clipIcon = 'XD40Mag',
	shootSound = '40Fire',
	clickSound = 'ORGMSmallPistolEmpty',
	ejectSound = 'ORGMSmallPistolOut',
	insertSound = 'ORGMSmallPistolIn',
	rackSound = 'ORGMSmallPistolRack',
	containsClip = 1,
	rackTime = 10,
	clipData = XD40Mag };

local XD40Mag = { type = "XD40Mag",
	moduleName = 'ORGM',
	reloadClass = 'ORGMMagazine',
	clipType = 'XD40Mag',
	ammoType = '40Rounds',
	shootSound = 'none',
	clickSound = nil,
	ejectSound = 'ORGMMagLoad',
	insertSound = 'ORGMMagLoad',
	rackSound = 'ORGMMagLoad',
	containsClip = 0,
	maxCapacity = 9,
	reloadTime = 30,
	rackTime = 10};

local KahrCT40 = { type = "KahrCT40",
	moduleName = 'ORGM',
	reloadClass = 'ORGMWeaponAutoMF',
	ammoType = 'KahrCT40Mag',
	clipName = 'Kahr CT-40 Magazine (.40)',
	clipIcon = 'KahrCT40Mag',
	shootSound = '40Fire',
	clickSound = 'ORGMSmallPistolEmpty',
	ejectSound = 'ORGMSmallPistolOut',
	insertSound = 'ORGMSmallPistolIn',
	rackSound = 'ORGMSmallPistolRack',
	containsClip = 1,
	rackTime = 10,
	clipData = KahrCT40Mag };

local KahrCT40Mag = { type = "KahrCT40Mag",
	moduleName = 'ORGM',
	reloadClass = 'ORGMMagazine',
	clipType = 'KahrCT40Mag',
	ammoType = '40Rounds',
	shootSound = 'none',
	clickSound = nil,
	ejectSound = 'ORGMMagLoad',
	insertSound = 'ORGMMagLoad',
	rackSound = 'ORGMMagLoad',
	containsClip = 0,
	maxCapacity = 7,
	reloadTime = 30,
	rackTime = 10};

local KahrP380 = { type = "KahrP380",
	moduleName = 'ORGM',
	reloadClass = 'ORGMWeaponAutoMF',
	ammoType = 'KahrP380Mag',
	clipName = 'Kahr P-380 Magazine (.380 ACP)',
	clipIcon = 'KahrP380Mag',
	shootSound = '380Fire',
	clickSound = 'ORGMSmallPistolEmpty',
	ejectSound = 'ORGMSmallPistolOut',
	insertSound = 'ORGMSmallPistolIn',
	rackSound = 'ORGMSmallPistolRack',
	containsClip = 1,
	rackTime = 10,
	clipData = KahrP380Mag };

local KahrP380Mag = { type = "KahrP380Mag",
	moduleName = 'ORGM',
	reloadClass = 'ORGMMagazine',
	clipType = 'KahrP380Mag',
	ammoType = '380Rounds',
	shootSound = 'none',
	clickSound = nil,
	ejectSound = 'ORGMMagLoad',
	insertSound = 'ORGMMagLoad',
	rackSound = 'ORGMMagLoad',
	containsClip = 0,
	maxCapacity = 6,
	reloadTime = 30,
	rackTime = 10};

local DEagleXIX = { type = "DEagleXIX",
        moduleName = 'ORGM',
	reloadClass = 'ORGMWeaponAutoMF',
        ammoType = 'DEagleXIXMag',
	clipName = 'IMI Desert Eagle XIX Magazine (.50)',
	clipIcon = 'DEagleXIXMag',
        shootSound = '50AEFire',
	clickSound = 'ORGMPistolEmpty',
	ejectSound = 'ORGMPistolOut',
	insertSound = 'ORGMPistolIn',
	rackSound = 'ORGMPistolRack',
	containsClip = 1,
	rackTime = 10,
	clipData = DEagleXIXMag };

local DEagleXIXMag = { type = "DEagleXIXMag",
	moduleName = 'ORGM',
	reloadClass = 'ORGMMagazine',
	clipType = 'DEagleXIXMag',
	ammoType = '50AERounds',
	shootSound = 'none',
	clickSound = nil,
	ejectSound = 'ORGMMagLoad',
	insertSound = 'ORGMMagLoad',
	rackSound = 'ORGMMagLoad',
	containsClip = 0,
	maxCapacity = 7,
	reloadTime = 30,
	rackTime = 10};

local AutomagV = { type = "AutomagV",
        moduleName = 'ORGM',
	reloadClass = 'ORGMWeaponAutoMF',
        ammoType = 'AutomagVMag',
	clipName = 'AMT Automag V Magazine (.50)',
	clipIcon = 'AutomagVMag',
        shootSound = '50AEFire',
	clickSound = 'ORGMPistolEmpty',
	ejectSound = 'ORGMPistolOut',
	insertSound = 'ORGMPistolIn',
	rackSound = 'ORGMPistolRack',
	containsClip = 1,
	rackTime = 10,
	clipData = AutomagVMag };

local AutomagVMag = { type = "AutomagVMag",
	moduleName = 'ORGM',
	reloadClass = 'ORGMMagazine',
	clipType = 'AutomagVMag',
	ammoType = '50AERounds',
	shootSound = 'none',
	clickSound = nil,
	ejectSound = 'ORGMMagLoad',
	insertSound = 'ORGMMagLoad',
	rackSound = 'ORGMMagLoad',
	containsClip = 0,
	maxCapacity = 5,
	reloadTime = 30,
	rackTime = 10};
	
local Hawk982 = { type = "Hawk982",
	moduleName = 'ORGM',
	reloadClass = 'ORGMWeaponManualIM',
	ammoType = '12gRounds',
	rackSound = 'ORGMShotgunRack',
	shootSound = '12GShotgunFire',
	shootSoundPartial = '12GShotgunFire',
	clickSound = 'ORGMShotgunEmpty',
	insertSound = 'ORGMShotgunRoundIn',
	rackTime = 10,
  	bulletOutSound = 'ORGMShotgunRack'};
	
local Striker = { type = "Striker",
	moduleName = 'ORGM',
	reloadClass = 'ORGMWeaponAutoIMNC',
	ammoType = '12gRounds',
	rackSound = 'ORGMARRack',
	shootSound = '12GShotgunFire',
	shootSoundPartial = '12GShotgunFire',
	clickSound = 'ORGMShotgunEmpty',
	insertSound = 'ORGMShotgunRoundIn',
	rackTime = 10,
  	bulletOutSound = 'ORGMShotgunRack'};
	
local Hawk982Sl = { type = "Hawk982Sl",
	moduleName = 'ORGM',
	reloadClass = 'ORGMWeaponManualIM',
	ammoType = '12gSlugRounds',
	rackSound = 'ORGMShotgunRack',
	shootSound = '12GShotgunFire',
	shootSoundPartial = '12GShotgunFire',
	clickSound = 'ORGMShotgunEmpty',
	insertSound = 'ORGMShotgunRoundIn',
	rackTime = 10,
  	bulletOutSound = 'ORGMShotgunRack'};
	
local StrikerSl = { type = "StrikerSl",
	moduleName = 'ORGM',
	reloadClass = 'ORGMWeaponAutoIMNC',
	ammoType = '12gSlugRounds',
	rackSound = 'ORGMARRack',
	shootSound = '12GShotgunFire',
	shootSoundPartial = '12GShotgunFire',
	clickSound = 'ORGMShotgunEmpty',
	insertSound = 'ORGMShotgunRoundIn',
	rackTime = 10,
  	bulletOutSound = 'ORGMShotgunRack'};
	
local Marlin60 = { type = "Marlin60",
	moduleName = 'ORGM',
	reloadClass = 'ORGMWeaponAutoIM',
	ammoType = '22Rounds',
	rackSound = 'ORGMRifleRack',
	shootSound = '22Fire',
	shootSoundPartial = '22Fire',
	clickSound = 'ORGMSmallPistolEmpty',
	insertSound = 'ORGMMagLoad',
	rackTime = 10,
  	bulletOutSound = 'none'};
	
local WinM94 = { type = "WinM94",
	moduleName = 'ORGM',
	reloadClass = 'ORGMWeaponManualIM',
	ammoType = '3030Rounds',
	rackSound = 'ORGMRifleLever',
	shootSound = '3030Fire',
	shootSoundPartial = '3030Fire',
	clickSound = 'ORGMRifleEmpty',
	insertSound = 'ORGMMagLoad',
	rackTime = 10,
  	bulletOutSound = 'ORGMRifleLever'};
	
local Rem788 = { type = "Rem788",
  	moduleName = 'ORGM',
	reloadClass = 'ORGMWeaponManualMF',
    	ammoType = 'Rem788Mag',
	clipName = 'Remington Magazine (.30-30)',
	clipIcon = 'Rem788Mag',
    	shootSound = '3030Fire',
	clickSound = 'ORGMRifleEmpty',
	ejectSound = 'ORGMRifleOut',
	insertSound = 'ORGMRifleIn',
	rackSound = 'ORGMRifleBolt',
	containsClip = 1,
	rackTime = 10,
	clipData = Rem788Mag };

local Rem788Mag = { type = "Rem788Mag",
	moduleName = 'ORGM',
	reloadClass = 'ORGMMagazine',
	clipType = 'Rem788Mag',
	ammoType = '3030Rounds',
	shootSound = 'none',
	clickSound = nil,
	ejectSound = 'ORGMMagLoad',
	insertSound = 'ORGMMagLoad',
	rackSound = 'ORGMMagLoad',
	containsClip = 0,
	maxCapacity = 3,
	reloadTime = 30,
	rackTime = 10};
	
local SR25 = { type = "SR25",
    	moduleName = 'ORGM',
	reloadClass = 'ORGMWeaponAutoMF',
    	ammoType = 'SR25Mag',
	clipName = 'KAC SR-25 Magazine (7.62x51)',
	clipIcon = 'SR25Mag',
    	shootSound = '308Fire',
	clickSound = 'ORGMRifleEmpty',
	ejectSound = 'ORGMAROut',
	insertSound = 'ORGMARIn',
	rackSound = 'ORGMARRack',
	containsClip = 1,
	rackTime = 10,
	clipData = SR25Mag };

local SR25Mag = { type = "SR25Mag",
	moduleName = 'ORGM',
	reloadClass = 'ORGMMagazine',
	clipType = 'SR25Mag',
	ammoType = '762x51Rounds',
	shootSound = 'none',
	clickSound = nil,
	ejectSound = 'ORGMMagLoad',
	insertSound = 'ORGMMagLoad',
	rackSound = 'ORGMMagLoad',
	containsClip = 0,
	maxCapacity = 20,
	reloadTime = 30,
	rackTime = 10};
	
local SR25308 = { type = "SR25308",
    	moduleName = 'ORGM',
	reloadClass = 'ORGMWeaponAutoMF',
    	ammoType = 'SR25308Mag',
	clipName = 'KAC SR-25 Magazine (.308)',
	clipIcon = 'SR25Mag',
    	shootSound = '308Fire',
	clickSound = 'ORGMRifleEmpty',
	ejectSound = 'ORGMAROut',
	insertSound = 'ORGMARIn',
	rackSound = 'ORGMARRack',
	containsClip = 1,
	rackTime = 10,
	clipData = SR25308Mag };

local SR25308Mag = { type = "SR25308Mag",
	moduleName = 'ORGM',
	reloadClass = 'ORGMMagazine',
	clipType = 'SR25308Mag',
	ammoType = '308Rounds',
	shootSound = 'none',
	clickSound = nil,
	ejectSound = 'ORGMMagLoad',
	insertSound = 'ORGMMagLoad',
	rackSound = 'ORGMMagLoad',
	containsClip = 0,
	maxCapacity = 20,
	reloadTime = 30,
	rackTime = 10};
	
local M249 = { type = "M249",
    	moduleName = 'ORGM',
	reloadClass = 'ORGMWeaponAutoMF',
    	ammoType = 'M249Belt',
	clipName = 'M249 Belt (5.56)',
	clipIcon = 'M249Belt',
    	shootSound = '223Fire',
	clickSound = 'ORGMRifleEmpty',
	ejectSound = 'ORGMLMGOut',
	insertSound = 'ORGMLMGIn',
	rackSound = 'ORGMLMGRack',
	containsClip = 1,
	rackTime = 10,
	clipData = M249Belt };

local M249Belt = { type = "M249Belt",
	moduleName = 'ORGM',
	reloadClass = 'ORGMMagazine',
	clipType = 'M249Belt',
	ammoType = '556Rounds',
	shootSound = 'none',
	clickSound = nil,
	ejectSound = 'ORGMMagLoad',
	insertSound = 'ORGMMagLoad',
	rackSound = 'ORGMMagLoad',
	containsClip = 0,
	maxCapacity = 200,
	reloadTime = 30,
	rackTime = 10};
	
local M249223 = { type = "M249223",
    	moduleName = 'ORGM',
	reloadClass = 'ORGMWeaponAutoMF',
    	ammoType = 'M249223Belt',
	clipName = 'M249 Belt (.223)',
	clipIcon = 'M249Belt',
    	shootSound = '223Fire',
	clickSound = 'ORGMRifleEmpty',
	ejectSound = 'ORGMLMGOut',
	insertSound = 'ORGMLMGIn',
	rackSound = 'ORGMLMGRack',
	containsClip = 1,
	rackTime = 10,
	clipData = M249223Belt };

local M249223Belt = { type = "M249223Belt",
	moduleName = 'ORGM',
	reloadClass = 'ORGMMagazine',
	clipType = 'M249223Belt',
	ammoType = '223Rounds',
	shootSound = 'none',
	clickSound = nil,
	ejectSound = 'ORGMMagLoad',
	insertSound = 'ORGMMagLoad',
	rackSound = 'ORGMMagLoad',
	containsClip = 0,
	maxCapacity = 200,
	reloadTime = 30,
	rackTime = 10};
	
local BenelliXM1014 = { type = "BenelliXM1014",
	moduleName = 'ORGM',
	reloadClass = 'ORGMWeaponAutoIM',
	ammoType = '12gRounds',
	rackSound = 'ORGMARRack',
	shootSound = '12GShotgunFire',
	shootSoundPartial = '12GShotgunFire',
	clickSound = 'ORGMShotgunEmpty',
	insertSound = 'ORGMShotgunRoundIn',
	rackTime = 10,
  	bulletOutSound = 'ORGMARRack'};
	
local BenelliXM1014Sl = { type = "BenelliXM1014Sl",
	moduleName = 'ORGM',
	reloadClass = 'ORGMWeaponAutoIM',
	ammoType = '12gRounds',
	rackSound = 'ORGMARRack',
	shootSound = '12GShotgunFire',
	shootSoundPartial = '12GShotgunFire',
	clickSound = 'ORGMShotgunEmpty',
	insertSound = 'ORGMShotgunRoundIn',
	rackTime = 10,
  	bulletOutSound = 'ORGMARRack'};
	
--************************************************************************--
--** ReloadUtil
--**
--************************************************************************--

ReloadUtil:addMagazineType(DEagleMag)
ReloadUtil:addMagazineType(M1216SlugMag)
ReloadUtil:addMagazineType(VEPR12SlugMag)
ReloadUtil:addMagazineType(RugerSR9Mag)
ReloadUtil:addMagazineType(XD40Mag)
ReloadUtil:addMagazineType(KahrCT40Mag)
ReloadUtil:addMagazineType(KahrP380Mag)
ReloadUtil:addMagazineType(DEagleXIXMag)
ReloadUtil:addMagazineType(AutomagVMag)
ReloadUtil:addMagazineType(Rem788Mag)
ReloadUtil:addMagazineType(SR25Mag)
ReloadUtil:addMagazineType(M249Belt)
ReloadUtil:addMagazineType(SR25308Mag)
ReloadUtil:addMagazineType(M249223Belt)
ReloadUtil:addMagazineType(SpeedLoader446)
ReloadUtil:addMagazineType(SpeedLoader3576)
ReloadUtil:addMagazineType(SpeedLoader386)
ReloadUtil:addMagazineType(SpeedLoader385)
ReloadUtil:addMagazineType(SpeedLoader4546)
ReloadUtil:addMagazineType(SpeedLoader45C6)
ReloadUtil:addMagazineType(SpeedLoader456)
ReloadUtil:addMagazineType(SpeedLoader10mm6)
ReloadUtil:addMagazineType(Spr19119Mag)
ReloadUtil:addMagazineType(KTP32Mag)
ReloadUtil:addMagazineType(TaurusP132Mag)
ReloadUtil:addMagazineType(SkorpionMag)

ReloadUtil:addWeaponType(ColtAnac)
ReloadUtil:addWeaponType(ColtPyth)
ReloadUtil:addWeaponType(ColtPyth38)
ReloadUtil:addWeaponType(RugAlas)
ReloadUtil:addWeaponType(RugAlas45C)
ReloadUtil:addWeaponType(RugGP100)
ReloadUtil:addWeaponType(RugGP10038)
ReloadUtil:addWeaponType(RugRH)
ReloadUtil:addWeaponType(Glock18SA)
ReloadUtil:addWeaponType(Ber93RSA)
ReloadUtil:addWeaponType(RugSec6)
ReloadUtil:addWeaponType(SWM19)
ReloadUtil:addWeaponType(SWM1938)
ReloadUtil:addWeaponType(SWM29)
ReloadUtil:addWeaponType(SWM36)
ReloadUtil:addWeaponType(SWM610)
ReloadUtil:addWeaponType(Taurus454)
ReloadUtil:addWeaponType(Taurus45445C)
ReloadUtil:addWeaponType(DEagle)
ReloadUtil:addWeaponType(M1216Sl)
ReloadUtil:addWeaponType(VEPR12Sl)
ReloadUtil:addWeaponType(HenryBB)
ReloadUtil:addWeaponType(ColtSAA)
ReloadUtil:addWeaponType(RugerSR9)
ReloadUtil:addWeaponType(XD40)
ReloadUtil:addWeaponType(KahrCT40)
ReloadUtil:addWeaponType(KahrP380)
ReloadUtil:addWeaponType(DEagleXIX)
ReloadUtil:addWeaponType(AutomagV)
ReloadUtil:addWeaponType(Hawk982)
ReloadUtil:addWeaponType(Striker)
ReloadUtil:addWeaponType(Hawk982Sl)
ReloadUtil:addWeaponType(StrikerSl)
ReloadUtil:addWeaponType(Marlin60)
ReloadUtil:addWeaponType(WinM94)
ReloadUtil:addWeaponType(Rem788)
ReloadUtil:addWeaponType(SR25)
ReloadUtil:addWeaponType(M249)
ReloadUtil:addWeaponType(SR25308)
ReloadUtil:addWeaponType(M249223)
ReloadUtil:addWeaponType(Spr19119)
ReloadUtil:addWeaponType(KTP32)
ReloadUtil:addWeaponType(TaurusP132)
ReloadUtil:addWeaponType(Skorpion)
ReloadUtil:addWeaponType(SWM10)
ReloadUtil:addWeaponType(SWM252)
ReloadUtil:addWeaponType(RugBH)
ReloadUtil:addWeaponType(RugBH38)
ReloadUtil:addWeaponType(BenelliXM1014)
ReloadUtil:addWeaponType(BenelliXM1014Sl)
ReloadUtil:addWeaponType(SilverhawkSl)
ReloadUtil:addWeaponType(SilverHawkSOSl)
ReloadUtil:addWeaponType(Spas12Sl)
ReloadUtil:addWeaponType(Spas12PASl)
ReloadUtil:addWeaponType(Stevens320Sl)
