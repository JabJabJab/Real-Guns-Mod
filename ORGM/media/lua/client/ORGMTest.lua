require 'Reloading/ISReloadManager'

function ORGMTest(_keyPressed)
	local key = _keyPressed;
    if key == 207 then
		local player = getPlayer();
		local testinv = player:getInventory();
		testinv:AddItems("ORGM.9mmRounds", 15);
		testinv:AddItem("ORGM.Ber92");
		testinv:AddItem("ORGM.BerMag15");
	end
end

Events.OnKeyPressed.Add(ORGMTest)

