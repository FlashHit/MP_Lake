-- Set redzone minimap texture to nil for both teams
ResourceManager:RegisterInstanceLoadHandler(Guid('601776CA-D1A8-432D-9F86-26BFF9E0EFB3B'), Guid('EA634590-B1EA-4056-8299-21EAF40D3520'), function(instance)
    if levelName ~= "Levels/MP_Subway/MP_Subway" or gameMode ~= "ConquestSmall0" then
		local caAsset = VeniceUICombatAreaAsset(instance)
		caAsset:MakeWritable()
		caAsset.distanceField = nil
		caAsset.surroundingDistanceField = nil
	end
end)

ResourceManager:RegisterInstanceLoadHandler(Guid('65214F82-8127-4ECD-B614-BF3B35C97787'), Guid('B8A18593-D1F7-4794-B96C-B349F3AC6459'), function(instance)
    if levelName ~= "Levels/MP_Subway/MP_Subway" or gameMode ~= "ConquestSmall0" then
		local caAsset = VeniceUICombatAreaAsset(instance)
		caAsset:MakeWritable()
		caAsset.distanceField = nil
		caAsset.surroundingDistanceField = nil
	end
end)

-- Change flag names
ResourceManager:RegisterInstanceLoadHandler(Guid("0964415F-1A6E-4BA3-A11D-EEDDF2DB9FD2"), Guid('184EB6A9-E532-8D64-0AC2-551AD903FF96'), function(instance)
    if levelName ~= "Levels/MP_Subway/MP_Subway" or gameMode ~= "ConquestSmall0" then
		instance = InterfaceDescriptorData (instance)
		instance:MakeWritable()
		DataField(instance.fields[15]).value = 'CString "CRIMEA"'
		DataField(instance.fields[17]).value = 'CString "BAGUETTE"'
		DataField(instance.fields[18]).value = 'CString "PLAYGROUND"'
	end
end)