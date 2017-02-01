require "ISBaseObject"
require "Reloading/ORGMLoadClass"

ORGMLoadUtil = ISBaseObject:derive("ORGMLoadUtil");

function ORGMLoadUtil:initialise()

end

function ORGMLoadUtil:new()
	local o = {}
	setmetatable(o, self)
	self.__index = self
	return o;
end


	loadableList = {};
	ORGMplayerData = {};

function ORGMLoadUtil:getLoadableWeapon(weapon, player)
    return self:syncItemToLoadable(weapon, player);
end

function ORGMLoadUtil:syncItemToLoadable(item, player)
	local loadable = self:setUpLoadable(item, player)
	if loadable then
		loadable:syncItemToLoadable(item);
	end
	return loadable;
end

function ORGMLoadUtil:setUpLoadable(item, playerObj)
    if(item == nil) then
        return nil;
    end
	local itemdata = item:getModData();
	if itemdata.reloadClass ~= nil then
		local loadable = self:getLoadableForPlayer(itemdata.reloadClass, playerObj);
		return loadable
	end
	local itemData = self:getLoadableData(item:getType());
	if itemData then
		local loadable = self:getLoadableForPlayer(itemData.reloadClass, playerObj)
		if loadable then
			loadable:setupLoadable(item, itemData);
			return loadable;
		end
	end
    return nil;
end

function ORGMLoadUtil:getLoadableData(itemType)
	for i,v in ipairs(loadableList) do
        if(v.type == itemType) then
            return v;
        end
    end
    return nil;
end

function ORGMLoadUtil:needsCylRotate(loadable)
	local ammoInTable = ORGMLoadUtil.tableCount(loadable.ammoLoaded)
	local lastItem = loadable.ammoLoaded[ammoInTable]
	if ammoInTable < loadable.maxCapacity then
		return false
	elseif lastItem ~= nil and ORGMLoadManager.ORGMindexfinder(lastItem, Ammoindexlist) ~= nil then
		return true
	else
		return false
	end
end

function ORGMLoadUtil:tableCount(tabletocheck) --Counts items currently in the table
	local count = 0
	for _ in pairs(tabletocheck) do
		count = count + 1
	end
	return count
end

function ORGMLoadUtil:getLoadableForPlayer(loadClass, playerObj)
	if not ORGMplayerData[playerObj] then
		ORGMplayerData[playerObj] = {}
	end
	if not ORGMplayerData[playerObj][loadClass] then
		local classDef = _G[loadClass]
		if not classDef then
			print('ERROR: no such load class "' .. loadClass .. '"')
			return nil
		end
		ORGMplayerData[playerObj][loadClass] = classDef:new()
		ORGMplayerData[playerObj][loadClass].playerObj = playerObj
	end
	return ORGMplayerData[playerObj][loadClass]
end

function ORGMLoadUtil:addLoadableType(itemType)
	table.insert(loadableList, itemType)
end

