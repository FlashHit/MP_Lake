local propertyConnections = require "__shared/PropertyConnections"
local linkConnections = require "__shared/LinkConnections"
local eventConnections = require "__shared/EventConnections"
local vehicleSpawnReferenceObjectDataGenerator = require "__shared/VehicleSpawnReferenceObjectDataGenerator"
local characterSpawnReferenceObjectDataGenerator = require "__shared/CharacterSpawnReferenceObjectDataGenerator"
local alternateSpawnEntityDataGenerator = require "__shared/AlternateSpawnEntityDataGenerator"
local vehicleCameraEntityDataGenerator = require "__shared/VehicleCameraEntityDataGenerator"
-- If the script is a function it can be executed more than once after level reloads and map changes.
function AddBoats()

local cqLogicPartitionGuid = Guid('F5DE48B8-29ED-4E73-B040-82637BE0E81C')

-- Adding boat spawns by creating VehicleSpawnReferenceObjectData, and adding that data to the SubWorldData that creates this gameMode's logic (Levels/MP_Subway/Conquest_Small_Logic)
subWorldDataCallback = ResourceManager:RegisterInstanceLoadHandler(Guid('0964415F-1A6E-4BA3-A11D-EEDDF2DB9FD2'), Guid('B3B384A6-B1B1-4D81-9EC2-08322A8A7FFA'), function(instance)

    local subWorldData = SubWorldData(instance)
    subWorldData:MakeWritable()

    local rhibBlueprint = VehicleBlueprint(ResourceManager:SearchForDataContainer("Vehicles/RHIB/RHIB"))

    for _, INFO in pairs(CONFIG.BOATS) do
        CreateVehicleSpawnFromMenu(rhibBlueprint, INFO.POS, 'ID_P_VNAME_RIB', INFO.TEAM, 50, subWorldData, INFO.LINK, INFO.GUID1, INFO.GUID2, INFO.GUID3, INFO.GUID4, INFO.ID, INFO.CAM)
	end
	
end)

function CreateVehicleSpawnFromMenu(blueprint, transform, name, team, icon, subWorldData, linkedCpGuid, randomGuid1, randomGuid2, randomGuid3, randomGuid4, id, camPos)

    -- VehicleSpawnReferenceObjectData creates a vehiclespawnentity (which spawn the vehicle itself, it is not a spawnpoint)
    local vehicleSpawnData = vehicleSpawnReferenceObjectDataGenerator:Create(blueprint, transform, team, randomGuid1)
    
    -- CharacterSpawnReferenceObjectData creates a spawnpoint
    local characterSpawnData = characterSpawnReferenceObjectDataGenerator:Create(transform, team, icon, name, randomGuid2, id)

	-- AlternateSpawnEntityData creates an alternative spawn
	local alternateSpawnEntityData = alternateSpawnEntityDataGenerator:Create(transform, team, randomGuid4)
	
    -- CameraEntityData creates a camera
    local vehicleCameraEntityData = vehicleCameraEntityDataGenerator:Create(camPos, randomGuid3, id)

    -- This is connection links the VehicleIsNear property of the vehicleSpawn, to the Enable property of the spawnpoint. (the spawnpoint will be enabled when the vehicle hasnt left its place)
    local vehicleToSpawnConnection = propertyConnections:Create(vehicleSpawnData, characterSpawnData, "VehicleIsNear", "Enabled")
      
    -- This connection links the link the vehicleSpawn to the spawnPoint, making the spawnpoint a vehiclespawnpoint
    local spawnToVehicleConnection = linkConnections:Create(characterSpawnData, vehicleSpawnData, "Vehicle")

    -- This connection links the vehicle spawn to the HQ
    local baseToVehicleConnection = linkConnections:Create(ResourceManager:SearchForInstanceByGuid(linkedCpGuid), vehicleSpawnData, "Vehicles")
	
	-- This connection links the characterSpawnData to the alternateSpawnEntityData
	local spawnToAlternativeSpawnConnection = linkConnections:Create(characterSpawnData, alternateSpawnEntityData, "AlternativeSpawnPoints")
	
    -- This connection links the spawnscreen camera to the vehicle
    local cameraToVehicleConnection = eventConnections:Create(vehicleCameraEntityData, ResourceManager:SearchForInstanceByGuid(Guid('3B307FE6-E28E-4559-ADD0-FECE30C7CD24')), -2068939912, 293085142, 2)
    

    -- Add created data to the SubWorldData
    subWorldData.objects:add(vehicleSpawnData)
    subWorldData.objects:add(characterSpawnData)
    subWorldData.objects:add(alternateSpawnEntityData)
    subWorldData.objects:add(vehicleCameraEntityData)

    -- Add the connections to the SubWorldData
    subWorldData.propertyConnections:add(vehicleToSpawnConnection)
    subWorldData.linkConnections:add(spawnToVehicleConnection)
    subWorldData.linkConnections:add(baseToVehicleConnection)
    subWorldData.linkConnections:add(spawnToAlternativeSpawnConnection)
    subWorldData.eventConnections:add(cameraToVehicleConnection)

    local partition = DatabasePartition((ResourceManager:FindPartitionForInstance(subWorldData)))
    partition:AddInstance(vehicleSpawnData)
    partition:AddInstance(characterSpawnData)
    partition:AddInstance(alternateSpawnEntityData)
    partition:AddInstance(vehicleCameraEntityData)
	
end

-- In order for the custom spawnData to be usable we need to register it with the engine.
entityResourceEvent = Events:Subscribe('Level:RegisterEntityResources', function(levelData)

    local registry = RegistryContainer()

    for _, INFO in pairs(CONFIG.BOATS) do
	
        local vehicleSpawnData = VehicleSpawnReferenceObjectData(ResourceManager:SearchForInstanceByGuid(INFO.GUID1))
        local characterSpawnData = CharacterSpawnReferenceObjectData(ResourceManager:SearchForInstanceByGuid(INFO.GUID2))
        local alternateSpawnEntityData = AlternateSpawnEntityData(ResourceManager:SearchForInstanceByGuid(INFO.GUID4))
        local vehicleCameraEntityData = CameraEntityData(ResourceManager:SearchForInstanceByGuid(INFO.GUID3))

        registry.referenceObjectRegistry:add(vehicleSpawnData)
        registry.referenceObjectRegistry:add(characterSpawnData)
        registry.referenceObjectRegistry:add(alternateSpawnEntityData)
        registry.referenceObjectRegistry:add(vehicleCameraEntityData)
    end

    ResourceManager:AddRegistry(registry, ResourceCompartment.ResourceCompartment_Game)

    -- Also adding the XP1_003 cq_s RegistryContainer so the RHIB boat is usable
    local registry = RegistryContainer(ResourceManager:SearchForInstanceByGuid(Guid('CDE50BB6-A595-3A6F-C2C5-0897F9143BC5')))
    ResourceManager:AddRegistry(registry, ResourceCompartment.ResourceCompartment_Game)
	
	-- The vehicles MaterialPair along with the levels MaterialGrid controls how and when a vehicle takes damage. Since the Metro MaterialGrid doesnt have any info about boats, the boat would never take damage.
    local levelData = LevelData(levelData)
    levelData:MakeWritable()
    -- Exchanging MP_Subway materialGrid with XP1_003 materialGrid
    levelData.runtimeMaterialGrid = MaterialGridData(ResourceManager:FindInstanceByGuid(Guid('8557DB6F-02B8-C634-5004-FC1A33B409BE'), Guid('A34BBB2D-B82B-F932-D2A8-0B26E7D6ABEF')))
	
	if subWorldDataCallback ~= nil then
		subWorldDataCallback:Deregister()
	end
	entityResourceEvent:Unsubscribe()
	if cpBlueprintCallback ~= nil then
		cpBlueprintCallback:Deregister()
	end
	
end)

bundleHook = Hooks:Install('ResourceManager:LoadBundles', 100, function(hook, bundles, compartment)

    if #bundles == 1 and bundles[1] == 'Levels/MP_Subway/MP_Subway' and SharedUtils:GetCurrentGameMode() == "ConquestSmall0" then
	
        print("injecting bundles")

		-- Mount sharqi bundles that include the RHIB boat bundles
		ResourceManager:MountSuperBundle('XP1Chunks')
		ResourceManager:MountSuperBundle('Levels/XP1_003/XP1_003')
		
        local bundlesCopy = {
        'Levels/XP1_003/XP1_003',
        'Levels/XP1_003/CQ_S',
        'Levels/MP_Subway/MP_Subway'
        }
		
        hook:Pass(bundlesCopy, compartment)
		
		bundleHook:Uninstall()
    end
	
end)

end
return AddBoats