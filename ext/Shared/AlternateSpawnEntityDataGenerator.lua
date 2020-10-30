class 'AlternateSpawnEntityDataGenerator'

function AlternateSpawnEntityDataGenerator:Create(transform, team, randomGuid4)
	local alternateSpawnEntityData = AlternateSpawnEntityData(randomGuid4)
    alternateSpawnEntityData.team = team
    alternateSpawnEntityData.transform = transform
    alternateSpawnEntityData.isEventConnectionTarget = 2
    alternateSpawnEntityData.isPropertyConnectionTarget = 3
	
	return alternateSpawnEntityData
end

return AlternateSpawnEntityDataGenerator()