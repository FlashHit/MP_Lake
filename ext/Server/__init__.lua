Events:Subscribe('Level:LoadResources', function()
	if SharedUtils:GetLevelName() == "Levels/MP_Subway/MP_Subway" and SharedUtils:GetCurrentGameMode() == "ConquestSmall0" then
		if ServerUtils:GetCustomGameModeName() == nil or ServerUtils:GetCustomGameModeName() ~= 'Conquest #2' then
			ServerUtils:SetCustomGameModeName('Conquest #2')
		end
	elseif ServerUtils:GetCustomGameModeName() ~= nil and ServerUtils:GetCustomGameModeName() == 'Conquest #2' then
		ServerUtils:ClearCustomGameModeName()
	end
end)
