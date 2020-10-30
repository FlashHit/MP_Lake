
function ModifyCapturePoints()

local cqLogicPartitionGuid = Guid('F5DE48B8-29ED-4E73-B040-82637BE0E81C')

cpBlueprintCallback = ResourceManager:RegisterInstanceLoadHandler(Guid("6FF061D3-B464-11E0-A8ED-AC9707C24C08"), Guid('0EBE4C00-9840-4D65-49CB-019C23BBC66B'), function(instance)

	-- CapturePoints B and C normally use a 4m flagpole because they have to fit inside the metro. 
	-- Wait for the normal blueprint to load to replace the CapturePointPrefab4m blueprint with the normal one.
	local cpBlueprint = SpatialPrefabBlueprint(instance)

	-- This SubWorldData (Levels/MP_Subway/Conquest_Small) is the parent that contains the data used to create the gamemode on MP_Subway.
	-- The SubWorldDatas connections are what links different types of data together.
	local subWorldData = SubWorldData(ResourceManager:SearchForDataContainer("Levels/MP_Subway/Conquest_Small"))
	subWorldData:MakeWritable()

	-- Move flag positions by changing the blueprintTransform of the ReferenceObjectData responsible for creating the flag from blueprint (Gameplay/Level_Setups/Components/CapturePointPrefab)
	local cpAObjectData = ReferenceObjectData(ResourceManager:FindInstanceByGuid(cqLogicPartitionGuid, CONFIG.CPA.GUID))
	cpAObjectData:MakeWritable()
	cpAObjectData.blueprintTransform = CONFIG.CPA.POS
	ReplaceCapZone(subWorldData, cpAObjectData, CONFIG.CPA.CAPZONE)
	ClearSpawnPoints(subWorldData, cpAObjectData)
	CreateSpawnPoints(subWorldData, cpAObjectData, CONFIG.CPA.USSPAWNS, "USCP")
	CreateSpawnPoints(subWorldData, cpAObjectData, CONFIG.CPA.RUSPAWNS, "RUCP")


	local cpBObjectData = ReferenceObjectData(ResourceManager:FindInstanceByGuid(cqLogicPartitionGuid, CONFIG.CPB.GUID))
	cpBObjectData:MakeWritable()
	--cpBObjectData.blueprint = cpBlueprint
	cpBObjectData.blueprintTransform = CONFIG.CPB.POS
	ReplaceCapZone(subWorldData, cpBObjectData, CONFIG.CPB.CAPZONE)
	ClearSpawnPoints(subWorldData, cpBObjectData)
	CreateSpawnPoints(subWorldData, cpBObjectData, CONFIG.CPB.USSPAWNS, "USCP")
	CreateSpawnPoints(subWorldData, cpBObjectData, CONFIG.CPB.RUSPAWNS, "RUCP")


	local cpCObjectData = ReferenceObjectData(ResourceManager:FindInstanceByGuid(cqLogicPartitionGuid, CONFIG.CPC.GUID))
	cpCObjectData:MakeWritable()
	--cpCObjectData.blueprint = cpBlueprint
	cpCObjectData.blueprintTransform = CONFIG.CPC.POS
	ReplaceCapZone(subWorldData, cpCObjectData, CONFIG.CPC.CAPZONE)
	ClearSpawnPoints(subWorldData, cpCObjectData)
	CreateSpawnPoints(subWorldData, cpCObjectData, CONFIG.CPC.USSPAWNS, "USCP")
	CreateSpawnPoints(subWorldData, cpCObjectData, CONFIG.CPC.RUSPAWNS, "RUCP")

	
	local usHqObjectData = ReferenceObjectData(ResourceManager:FindInstanceByGuid(cqLogicPartitionGuid, CONFIG.USHQ.GUID))
	usHqObjectData:MakeWritable()
	usHqObjectData.blueprintTransform = CONFIG.USHQ.POS
	ClearSpawnPoints(subWorldData, usHqObjectData)
	CreateSpawnPoints(subWorldData, usHqObjectData, CONFIG.USHQ.SPAWNS, "USHQ")
 

	local ruHqObjectData = ReferenceObjectData(ResourceManager:FindInstanceByGuid(cqLogicPartitionGuid, CONFIG.RUHQ.GUID))
	ruHqObjectData:MakeWritable()
	ruHqObjectData.blueprintTransform = CONFIG.RUHQ.POS
	ClearSpawnPoints(subWorldData, ruHqObjectData)
	CreateSpawnPoints(subWorldData, ruHqObjectData, CONFIG.RUHQ.SPAWNS, "RUHQ")

	-- Out of bounds area
	local usRedzoneVectorData = VolumeVectorShapeData(ResourceManager:FindInstanceByGuid(cqLogicPartitionGuid, Guid('081BC71A-E784-49FA-9BDA-02FC1354FE48')))
	usRedzoneVectorData:MakeWritable()
	ReplacePoints(usRedzoneVectorData.points, CONFIG.USPLAYZONE)

	local ruRedzoneVectorData = VolumeVectorShapeData(ResourceManager:FindInstanceByGuid(cqLogicPartitionGuid, Guid('11119EDC-CD69-44A9-A5CC-DC7464A984AD')))
	ruRedzoneVectorData:MakeWritable()
	ReplacePoints(ruRedzoneVectorData.points, CONFIG.RUPLAYZONE)
end)

-- The VolumeVectorShapeData (containing an array of points that make up the polygon that is the capture zone) is linked to the capturepoint with a LinkConnection.
-- Iterate through the SubWorldData's linkConnections and find the LinkConnection that links VolumeVectorShapeData to the cpObjectData, then replace its points.
function ReplaceCapZone(subWorldData, cpObjectData, points)

	for _, connection in pairs(subWorldData.linkConnections) do

		if connection.target:Is("VolumeVectorShapeData") then

			if connection.source == cpObjectData then

				vectorData = VolumeVectorShapeData(connection.target)
				vectorData:MakeWritable()
				
				ReplacePoints(vectorData.points, points)
			end
		end
	end
end

function ReplacePoints(fbArray, luaTable)

	fbArray:clear()

	for _,point in pairs(luaTable) do

		fbArray:add(point)
	end
end

-- The spawns (AlternateSpawnEntityData) are also linked to the capturepoint with a LinkConnection.
-- Iterate through the SubWorldData's linkConnections and delete any LinkConnections that link AlternateSpawnEntityData to the cpObjectData.
function ClearSpawnPoints(subWorldData, cpObjectData)
	-- Since we are removing stuff, iterate through the connections in reverse order.
	for i = #subWorldData.linkConnections, 1, -1 do

		local connection = subWorldData.linkConnections[i]

		if connection.target:Is("AlternateSpawnEntityData") then

			if connection.source == cpObjectData then

				subWorldData.linkConnections:erase(i)
			end
		end
	end
end

-- The hashes used in the linkconnections, alternateSpawnEntityData.team is only set for base spawns.
local teamAndHash = {
	["USCP"] = { 0, 1751730141 },	--
	["RUCP"] = { 0, 1879290430 },	--
	["USHQ"] = { 1, -2001390482 },	--"AlternativeSpawnPoints"
	["RUHQ"] = { 2, -2001390482 },	--"AlternativeSpawnPoints"
}

-- Create a new AlternateSpawnEntityData instance for every spawn point and create a new connection linking it to the capturepoint.
function CreateSpawnPoints(subWorldData, cpObjectData, spawns, type)
	
	for _, spawnTransform in pairs(spawns) do

		local alternateSpawn = AlternateSpawnEntityData()
		alternateSpawn.team = teamAndHash[type][1]
		alternateSpawn.transform = spawnTransform
		
		-- The sourceFieldId depends on what team the spawn belongs to. Base spawns have a different one as well.
		local connection = LinkConnection()
		connection.target = alternateSpawn
		connection.source = cpObjectData
		connection.sourceFieldId = teamAndHash[type][2]
		subWorldData.linkConnections:add(connection)
	end
end

end

return ModifyCapturePoints