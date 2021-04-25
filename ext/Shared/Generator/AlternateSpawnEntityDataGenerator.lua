class 'AlternateSpawnEntityDataGenerator'

function AlternateSpawnEntityDataGenerator:Create(p_Transform, p_TeamId, p_CustomInstanceGuid)
	local s_AlternateSpawnEntityData = AlternateSpawnEntityData(p_CustomInstanceGuid)
    s_AlternateSpawnEntityData.team = p_TeamId
    s_AlternateSpawnEntityData.transform = p_Transform
    s_AlternateSpawnEntityData.isEventConnectionTarget = 2
    s_AlternateSpawnEntityData.isPropertyConnectionTarget = 3

	return s_AlternateSpawnEntityData
end

return AlternateSpawnEntityDataGenerator()
