local m_PropertyConnections = require "__shared/Utils/PropertyConnections"
local m_LinkConnections = require "__shared/Utils/LinkConnections"
local m_EventConnections = require "__shared/Utils/EventConnections"
local m_VehicleSpawnReferenceObjectDataGenerator = require "__shared/Generator/VehicleSpawnReferenceObjectDataGenerator"
local m_CharacterSpawnReferenceObjectDataGenerator = require "__shared/Generator/CharacterSpawnReferenceObjectDataGenerator"
local m_AlternateSpawnEntityDataGenerator = require "__shared/Generator/AlternateSpawnEntityDataGenerator"
local m_VehicleCameraEntityDataGenerator = require "__shared/Generator/VehicleCameraEntityDataGenerator"

-- Adding boat spawns by creating VehicleSpawnReferenceObjectData, and adding that data to the SubWorldData that creates this gameMode's logic (Levels/MP_Subway/Conquest_Small_Logic)
function AddBoats(p_SubWorldData)
    local s_RhibBlueprint = VehicleBlueprint(ResourceManager:SearchForDataContainer("Vehicles/RHIB/RHIB"))

    for _, INFO in pairs(CONFIG.BOATS) do
        CreateVehicleSpawnFromMenu(s_RhibBlueprint, INFO.POS, 'ID_P_VNAME_RIB', INFO.TEAM, 50, p_SubWorldData, INFO.LINK, INFO.GUID1, INFO.GUID2, INFO.GUID3, INFO.GUID4, INFO.ID, INFO.CAM)
	end
end

function CreateVehicleSpawnFromMenu(p_Blueprint, p_Transform, p_TextSid, p_TeamId, p_Icon, p_SubWorldData, p_LinkedCpGuid, p_CustomVehicleSpawnGuid, p_CustomCharacterSpawnGuid, p_CustomAlternateSpawnGuid, p_CustomCameraGuid, p_NameId, p_CameraPosition)
    -- VehicleSpawnReferenceObjectData creates a vehiclespawnentity (which spawn the vehicle itself, it is not a spawnpoint)
    local s_VehicleSpawnData = m_VehicleSpawnReferenceObjectDataGenerator:Create(p_Blueprint, p_Transform, p_TeamId, p_CustomVehicleSpawnGuid)
    -- CharacterSpawnReferenceObjectData creates a spawnpoint
    local s_CharacterSpawnData = m_CharacterSpawnReferenceObjectDataGenerator:Create(p_Transform, p_TeamId, p_Icon, p_TextSid, p_CustomCharacterSpawnGuid, p_NameId)
	-- AlternateSpawnEntityData creates an alternative spawn
	local s_AlternateSpawnEntityData = m_AlternateSpawnEntityDataGenerator:Create(p_Transform, p_TeamId, p_CustomCameraGuid)
    -- CameraEntityData creates a camera
    local s_VehicleCameraEntityData = m_VehicleCameraEntityDataGenerator:Create(p_CameraPosition, p_CustomAlternateSpawnGuid, p_NameId)

    -- This is connection links the VehicleIsNear property of the vehicleSpawn, to the Enable property of the spawnpoint. (the spawnpoint will be enabled when the vehicle hasnt left its place)
    local vehicleToSpawnConnection = m_PropertyConnections:Create(s_VehicleSpawnData, s_CharacterSpawnData, "VehicleIsNear", "Enabled")
    -- This connection links the link the vehicleSpawn to the spawnPoint, making the spawnpoint a vehiclespawnpoint
    local spawnToVehicleConnection = m_LinkConnections:Create(s_CharacterSpawnData, s_VehicleSpawnData, "Vehicle")
    -- This connection links the vehicle spawn to the HQ
    local baseToVehicleConnection = m_LinkConnections:Create(ResourceManager:SearchForInstanceByGuid(p_LinkedCpGuid), s_VehicleSpawnData, "Vehicles")
	-- This connection links the characterSpawnData to the alternateSpawnEntityData
	local spawnToAlternativeSpawnConnection = m_LinkConnections:Create(s_CharacterSpawnData, s_AlternateSpawnEntityData, "AlternativeSpawnPoints")
    -- This connection links the spawnscreen camera to the vehicle
    local cameraToVehicleConnection = m_EventConnections:Create(s_VehicleCameraEntityData, ResourceManager:SearchForInstanceByGuid(Guid('3B307FE6-E28E-4559-ADD0-FECE30C7CD24')), -2068939912, 293085142, 2)

    -- Add created data to the SubWorldData
    p_SubWorldData.objects:add(s_VehicleSpawnData)
    p_SubWorldData.objects:add(s_CharacterSpawnData)
    p_SubWorldData.objects:add(s_AlternateSpawnEntityData)
    p_SubWorldData.objects:add(s_VehicleCameraEntityData)

    -- Add the connections to the SubWorldData
    p_SubWorldData.propertyConnections:add(vehicleToSpawnConnection)
    p_SubWorldData.linkConnections:add(spawnToVehicleConnection)
    p_SubWorldData.linkConnections:add(baseToVehicleConnection)
    p_SubWorldData.linkConnections:add(spawnToAlternativeSpawnConnection)
    p_SubWorldData.eventConnections:add(cameraToVehicleConnection)

    local s_Partition = p_SubWorldData.partition
    s_Partition:AddInstance(s_VehicleSpawnData)
    s_Partition:AddInstance(s_CharacterSpawnData)
    s_Partition:AddInstance(s_AlternateSpawnEntityData)
    s_Partition:AddInstance(s_VehicleCameraEntityData)
end

-- In order for the custom spawnData to be usable we need to register it with the engine.
Events:Subscribe('Level:RegisterEntityResources', function(p_LevelData)
    if SharedUtils:GetLevelName() ~= 'Levels/MP_Subway/MP_Subway' or SharedUtils:GetCurrentGameMode() ~= "ConquestSmall0" then
        return
    end
    -- Adding the MP_017 cq_s RegistryContainer so the RHIB boat is usable
    local s_MP_017_Registry = RegistryContainer(ResourceManager:SearchForInstanceByGuid(Guid('CD39A611-8445-E2CE-6F6D-1BB085864E0C')))
    ResourceManager:AddRegistry(s_MP_017_Registry, ResourceCompartment.ResourceCompartment_Game)

    -- The vehicles MaterialPair along with the levels MaterialGrid controls how and when a vehicle takes damage. Since the Metro MaterialGrid doesnt have any info about boats, the boat would never take damage.
    p_LevelData = LevelData(p_LevelData)
    p_LevelData:MakeWritable()
    -- Exchanging MP_Subway materialGrid with MP_017 materialGrid
    p_LevelData.runtimeMaterialGrid = MaterialGridData(ResourceManager:FindInstanceByGuid(Guid('3D110283-67EF-1F7A-6EB0-93AFB566C248'), Guid('C3762A83-47E1-6E0B-5FA7-535262C5AC22')))

    local s_Registry = RegistryContainer()
    for _, INFO in pairs(CONFIG.BOATS) do
        local s_VehicleSpawnData = VehicleSpawnReferenceObjectData(ResourceManager:SearchForInstanceByGuid(INFO.GUID1))
        local s_CharacterSpawnData = CharacterSpawnReferenceObjectData(ResourceManager:SearchForInstanceByGuid(INFO.GUID2))
        local s_AlternateSpawnEntityData = AlternateSpawnEntityData(ResourceManager:SearchForInstanceByGuid(INFO.GUID4))
        local s_VehicleCameraEntityData = CameraEntityData(ResourceManager:SearchForInstanceByGuid(INFO.GUID3))
        s_Registry.referenceObjectRegistry:add(s_VehicleSpawnData)
        s_Registry.referenceObjectRegistry:add(s_CharacterSpawnData)
        s_Registry.referenceObjectRegistry:add(s_AlternateSpawnEntityData)
        s_Registry.referenceObjectRegistry:add(s_VehicleCameraEntityData)
    end
    ResourceManager:AddRegistry(s_Registry, ResourceCompartment.ResourceCompartment_Game)
end)

Events:Subscribe('Level:LoadResources', function(p_LevelName, p_GameMode, p_IsDedicatedServer)
	if p_LevelName ~= "Levels/MP_Subway/MP_Subway" or p_GameMode ~= "ConquestSmall0" then
		return
	end
    ResourceManager:MountSuperBundle('Levels/MP_017/MP_017')
end)

Hooks:Install('ResourceManager:LoadBundles', 100, function(p_HookCtx, p_Bundles, p_Compartment)
    if p_Bundles[1] ~= 'Levels/MP_Subway/MP_Subway' or SharedUtils:GetCurrentGameMode() ~= "ConquestSmall0" then
        return
    end
    p_Bundles = {
        'Levels/MP_017/MP_017',
        'Levels/MP_017/CQS',
        p_Bundles[1]
    }
    p_HookCtx:Pass(p_Bundles, p_Compartment)
end)
