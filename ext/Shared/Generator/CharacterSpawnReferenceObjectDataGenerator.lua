class 'CharacterSpawnReferenceObjectDataGenerator'

function CharacterSpawnReferenceObjectDataGenerator:Create(p_Transform, p_TeamId, p_Icon, p_TextSid, p_CustomInstanceGuid, p_NameSid)
	local s_CharacterSpawnData = CharacterSpawnReferenceObjectData(p_CustomInstanceGuid)
    s_CharacterSpawnData.maxCount = 0
    s_CharacterSpawnData.team = p_TeamId
    s_CharacterSpawnData.minimapIcon = p_Icon
    s_CharacterSpawnData.locationTextSid = p_TextSid
    s_CharacterSpawnData.locationNameSid = p_NameSid
    s_CharacterSpawnData.blueprintTransform = p_Transform
    s_CharacterSpawnData.playerType = PlayerSpawnType.PlayerSpawnType_HumanPlayer
    s_CharacterSpawnData.isEventConnectionTarget = 3
    s_CharacterSpawnData.isPropertyConnectionTarget = 1

	return s_CharacterSpawnData
end

return CharacterSpawnReferenceObjectDataGenerator()
