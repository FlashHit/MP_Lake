class 'VehicleCameraEntityDataGenerator'

function VehicleCameraEntityDataGenerator:Create(p_Transform, p_CustomInstanceGuid, p_NameId)
	local s_VehicleCameraEntityData = CameraEntityData(p_CustomInstanceGuid)
	s_VehicleCameraEntityData:MakeWritable()
	s_VehicleCameraEntityData.isEventConnectionTarget = 3
    s_VehicleCameraEntityData.isPropertyConnectionTarget = 3
	s_VehicleCameraEntityData.nameId = p_NameId
	s_VehicleCameraEntityData.transform = p_Transform

	return s_VehicleCameraEntityData
end

return VehicleCameraEntityDataGenerator()
