ORGMConversions2 = {}

function ORGMConversions2:initialise()

end

function ORGMConversions2:new(player)
	local o = {}
	setmetatable(o, self)
    self.__index = self
	o.convertAction = nil;
	o.convertableable = nil;
	o.playerid = player;
	o.lastClickTime = 0
    return o;
end

function ORGMConversions2:StartConvertfromUi(item)
	self.convertitem = item;
	self.converttype = self.convertitem:getType()
	self.convertindex = ORGMConversions:ORGMindexfinder(self.converttype, ConversionIndexTable2);
	self.resultitem = ConversionWeaponTable2[self.convertindex];
	self:startConversion();
end

function ORGMConversions2:startConversion()
	local player = getPlayer()
	local moodles = player:getMoodles();
	local panicLevel = moodles:getMoodleLevel(MoodleType.Panic);
	self.convertmoddata = self.convertitem:getModData();
	self.convertAction = ORGMConvertAction2:new(self, getPlayer(), 1);
	ISTimedActionQueue.add(self.convertAction)
end
