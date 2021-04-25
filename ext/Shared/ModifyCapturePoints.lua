function ModifyCapturePoints(p_SubWorldData)
	-- This SubWorldData (Levels/MP_Subway/Conquest_Small) is the parent that contains the data used to create the gamemode on MP_Subway.
	-- The SubWorldDatas connections are what links different types of data together.
	local s_CQLogicPartitionGuid = Guid('F5DE48B8-29ED-4E73-B040-82637BE0E81C')

	-- Move flag positions by changing the blueprintTransform of the ReferenceObjectData responsible for creating the flag from blueprint (Gameplay/Level_Setups/Components/CapturePointPrefab)
	local s_CapturePoint_A_ReferenceObjectData = ReferenceObjectData(ResourceManager:FindInstanceByGuid(s_CQLogicPartitionGuid, CONFIG.CPA.GUID))
	s_CapturePoint_A_ReferenceObjectData:MakeWritable()
	s_CapturePoint_A_ReferenceObjectData.blueprintTransform = CONFIG.CPA.POS
	ReplaceCapZone(p_SubWorldData, s_CapturePoint_A_ReferenceObjectData, CONFIG.CPA.CAPZONE)
	ClearSpawnPoints(p_SubWorldData, s_CapturePoint_A_ReferenceObjectData)
	CreateSpawnPoints(p_SubWorldData, s_CapturePoint_A_ReferenceObjectData, CONFIG.CPA.USSPAWNS, "USCP")
	CreateSpawnPoints(p_SubWorldData, s_CapturePoint_A_ReferenceObjectData, CONFIG.CPA.RUSPAWNS, "RUCP")


	local s_CapturePoint_B_ReferenceObjectData = ReferenceObjectData(ResourceManager:FindInstanceByGuid(s_CQLogicPartitionGuid, CONFIG.CPB.GUID))
	s_CapturePoint_B_ReferenceObjectData:MakeWritable()
	--s_CapturePoint_B_ReferenceObjectData.blueprint = cpBlueprint
	s_CapturePoint_B_ReferenceObjectData.blueprintTransform = CONFIG.CPB.POS
	ReplaceCapZone(p_SubWorldData, s_CapturePoint_B_ReferenceObjectData, CONFIG.CPB.CAPZONE)
	ClearSpawnPoints(p_SubWorldData, s_CapturePoint_B_ReferenceObjectData)
	CreateSpawnPoints(p_SubWorldData, s_CapturePoint_B_ReferenceObjectData, CONFIG.CPB.USSPAWNS, "USCP")
	CreateSpawnPoints(p_SubWorldData, s_CapturePoint_B_ReferenceObjectData, CONFIG.CPB.RUSPAWNS, "RUCP")


	local s_CapturePoint_C_ReferenceObjectData = ReferenceObjectData(ResourceManager:FindInstanceByGuid(s_CQLogicPartitionGuid, CONFIG.CPC.GUID))
	s_CapturePoint_C_ReferenceObjectData:MakeWritable()
	--s_CapturePoint_C_ReferenceObjectData.blueprint = cpBlueprint
	s_CapturePoint_C_ReferenceObjectData.blueprintTransform = CONFIG.CPC.POS
	ReplaceCapZone(p_SubWorldData, s_CapturePoint_C_ReferenceObjectData, CONFIG.CPC.CAPZONE)
	ClearSpawnPoints(p_SubWorldData, s_CapturePoint_C_ReferenceObjectData)
	CreateSpawnPoints(p_SubWorldData, s_CapturePoint_C_ReferenceObjectData, CONFIG.CPC.USSPAWNS, "USCP")
	CreateSpawnPoints(p_SubWorldData, s_CapturePoint_C_ReferenceObjectData, CONFIG.CPC.RUSPAWNS, "RUCP")

	local s_HQ_US_ReferenceObjectData = ReferenceObjectData(ResourceManager:FindInstanceByGuid(s_CQLogicPartitionGuid, CONFIG.USHQ.GUID))
	s_HQ_US_ReferenceObjectData:MakeWritable()
	s_HQ_US_ReferenceObjectData.blueprintTransform = CONFIG.USHQ.POS
	ClearSpawnPoints(p_SubWorldData, s_HQ_US_ReferenceObjectData)
	CreateSpawnPoints(p_SubWorldData, s_HQ_US_ReferenceObjectData, CONFIG.USHQ.SPAWNS, "USHQ")

	local s_HQ_RU_ReferenceObjectData = ReferenceObjectData(ResourceManager:FindInstanceByGuid(s_CQLogicPartitionGuid, CONFIG.RUHQ.GUID))
	s_HQ_RU_ReferenceObjectData:MakeWritable()
	s_HQ_RU_ReferenceObjectData.blueprintTransform = CONFIG.RUHQ.POS
	ClearSpawnPoints(p_SubWorldData, s_HQ_RU_ReferenceObjectData)
	CreateSpawnPoints(p_SubWorldData, s_HQ_RU_ReferenceObjectData, CONFIG.RUHQ.SPAWNS, "RUHQ")

	-- Out of bounds area
	local s_US_PlayZone = VolumeVectorShapeData(ResourceManager:FindInstanceByGuid(s_CQLogicPartitionGuid, Guid('081BC71A-E784-49FA-9BDA-02FC1354FE48')))
	s_US_PlayZone:MakeWritable()
	ReplacePoints(s_US_PlayZone.points, CONFIG.USPLAYZONE)

	local s_RU_PlayZone = VolumeVectorShapeData(ResourceManager:FindInstanceByGuid(s_CQLogicPartitionGuid, Guid('11119EDC-CD69-44A9-A5CC-DC7464A984AD')))
	s_RU_PlayZone:MakeWritable()
	ReplacePoints(s_RU_PlayZone.points, CONFIG.RUPLAYZONE)
end

-- The VolumeVectorShapeData (containing an array of points that make up the polygon that is the capture zone) is linked to the capturepoint with a LinkConnection.
-- Iterate through the SubWorldData's linkConnections and find the LinkConnection that links VolumeVectorShapeData to the cpObjectData, then replace its points.
function ReplaceCapZone(p_SubWorldData, p_CapturePointReference, p_Points)
	for _, connection in pairs(p_SubWorldData.linkConnections) do
		if connection.target:Is("VolumeVectorShapeData") then
			if connection.source == p_CapturePointReference then
				local s_VolumeVectorShapeData = VolumeVectorShapeData(connection.target)
				s_VolumeVectorShapeData:MakeWritable()
				ReplacePoints(s_VolumeVectorShapeData.points, p_Points)
			end
		end
	end
end

function ReplacePoints(p_Points, p_NewPoints)
	p_Points:clear()
	for _, l_Point in pairs(p_NewPoints) do
		p_Points:add(l_Point)
	end
end

-- The spawns (AlternateSpawnEntityData) are also linked to the capturepoint with a LinkConnection.
-- Iterate through the SubWorldData's linkConnections and delete any LinkConnections that link AlternateSpawnEntityData to the cpObjectData.
function ClearSpawnPoints(p_SubWorldData, p_CapturePointReference)
	-- Since we are removing stuff, iterate through the connections in reverse order.
	for i = #p_SubWorldData.linkConnections, 1, -1 do
		local s_Connection = p_SubWorldData.linkConnections[i]
		if s_Connection.target:Is("AlternateSpawnEntityData") then
			if s_Connection.source == p_CapturePointReference then
				p_SubWorldData.linkConnections:erase(i)
			end
		end
	end
end

-- Create a new AlternateSpawnEntityData instance for every spawn point and create a new connection linking it to the capturepoint.
function CreateSpawnPoints(p_SubWorldData, p_CapturePointReference, p_SpawnPoints, p_SpawnType)
	-- The hashes used in the linkconnections, alternateSpawnEntityData.team is only set for base spawns.
	local s_TeamAndHash = {
		["USCP"] = { 0, 1751730141 },	--
		["RUCP"] = { 0, 1879290430 },	--
		["USHQ"] = { 1, -2001390482 },	--"AlternativeSpawnPoints"
		["RUHQ"] = { 2, -2001390482 },	--"AlternativeSpawnPoints"
	}
	for _, l_SpawnPoint in pairs(p_SpawnPoints) do
		local s_AlternateSpawn = AlternateSpawnEntityData()
		s_AlternateSpawn.team = s_TeamAndHash[p_SpawnType][1]
		s_AlternateSpawn.transform = l_SpawnPoint
		-- The sourceFieldId depends on what team the spawn belongs to. Base spawns have a different one as well.
		local connection = LinkConnection()
		connection.target = s_AlternateSpawn
		connection.source = p_CapturePointReference
		connection.sourceFieldId = s_TeamAndHash[p_SpawnType][2]
		p_SubWorldData.linkConnections:add(connection)
	end
end
