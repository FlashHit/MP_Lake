-- Set redzone minimap texture to nil for both teams
ResourceManager:RegisterInstanceLoadHandler(Guid('601776CA-D1A8-432D-9F86-26BFF9E0EFB3B'), Guid('EA634590-B1EA-4056-8299-21EAF40D3520'), function(p_Instance)
    if SharedUtils:GetLevelName() ~= "Levels/MP_Subway/MP_Subway" or SharedUtils:GetCurrentGameMode() ~= "ConquestSmall0" then
		return
	end
	p_Instance = VeniceUICombatAreaAsset(p_Instance)
	p_Instance:MakeWritable()
	p_Instance.distanceField = nil
	p_Instance.surroundingDistanceField = nil
end)

ResourceManager:RegisterInstanceLoadHandler(Guid('65214F82-8127-4ECD-B614-BF3B35C97787'), Guid('B8A18593-D1F7-4794-B96C-B349F3AC6459'), function(p_Instance)
    if SharedUtils:GetLevelName() ~= "Levels/MP_Subway/MP_Subway" or SharedUtils:GetCurrentGameMode() ~= "ConquestSmall0" then
		return
	end
	p_Instance = VeniceUICombatAreaAsset(p_Instance)
	p_Instance:MakeWritable()
	p_Instance.distanceField = nil
	p_Instance.surroundingDistanceField = nil
end)

-- Change flag names
ResourceManager:RegisterInstanceLoadHandler(Guid("0964415F-1A6E-4BA3-A11D-EEDDF2DB9FD2"), Guid('184EB6A9-E532-8D64-0AC2-551AD903FF96'), function(p_Instance)
    if SharedUtils:GetLevelName() ~= "Levels/MP_Subway/MP_Subway" or SharedUtils:GetCurrentGameMode() ~= "ConquestSmall0" then
		return
	end
	p_Instance = InterfaceDescriptorData (p_Instance)
	p_Instance:MakeWritable()
	DataField(p_Instance.fields[15]).value = 'CString "CRIMEA"'
	DataField(p_Instance.fields[17]).value = 'CString "BAGUETTE"'
	DataField(p_Instance.fields[18]).value = 'CString "PLAYGROUND"'
end)
