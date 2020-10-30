class 'CharacterSpawnReferenceObjectDataGenerator'

function CharacterSpawnReferenceObjectDataGenerator:Create(transform, team, icon, name, randomGuid2, id)
	local characterSpawnData = CharacterSpawnReferenceObjectData(randomGuid2)
    characterSpawnData.team = team
    characterSpawnData.minimapIcon = icon
    characterSpawnData.locationTextSid = name
    characterSpawnData.locationNameSid = id
    characterSpawnData.blueprintTransform = transform
    characterSpawnData.playerType = PlayerSpawnType.PlayerSpawnType_HumanPlayer
    characterSpawnData.isEventConnectionTarget = 3
    characterSpawnData.isPropertyConnectionTarget = 1
	
	return characterSpawnData
end

return CharacterSpawnReferenceObjectDataGenerator()