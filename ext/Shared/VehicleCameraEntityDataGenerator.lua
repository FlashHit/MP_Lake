class 'VehicleCameraEntityDataGenerator'

function VehicleCameraEntityDataGenerator:Create(transform, randomGuid3, id)
	local vehicleCameraEntityData = CameraEntityData(randomGuid3)
	vehicleCameraEntityData:MakeWritable()
	vehicleCameraEntityData.isEventConnectionTarget = 3
    vehicleCameraEntityData.isPropertyConnectionTarget = 3
	vehicleCameraEntityData.nameId = id
	vehicleCameraEntityData.transform = transform
	
	return vehicleCameraEntityData
end

return VehicleCameraEntityDataGenerator()