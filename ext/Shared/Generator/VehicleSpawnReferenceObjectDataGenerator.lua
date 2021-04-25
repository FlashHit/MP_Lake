class 'VehicleSpawnReferenceObjectDataGenerator'

function VehicleSpawnReferenceObjectDataGenerator:Create(p_Blueprint, p_Transform, p_TeamId, p_CustomInstanceGuid)
	local s_VehicleSpawnData = VehicleSpawnReferenceObjectData(p_CustomInstanceGuid)
    s_VehicleSpawnData.enabled = true
    s_VehicleSpawnData.team = p_TeamId
    s_VehicleSpawnData.blueprint = p_Blueprint
    s_VehicleSpawnData.blueprintTransform = p_Transform
    s_VehicleSpawnData.isEventConnectionTarget = 2
    s_VehicleSpawnData.isPropertyConnectionTarget = 3
	s_VehicleSpawnData.lockedTeam = true --not working?
	s_VehicleSpawnData.initialAutoSpawn = true
	s_VehicleSpawnData.autoSpawn = true
	s_VehicleSpawnData.useAsSpawnPoint = false --not working?
	s_VehicleSpawnData.initialSpawnDelay = 0.0
    s_VehicleSpawnData.spawnDelay = 25.0
	s_VehicleSpawnData.maxCount = 0
	s_VehicleSpawnData.maxCountSimultaneously = 1
	s_VehicleSpawnData.totalCountSimultaneouslyOfType = 0
	s_VehicleSpawnData.spawnAreaRadius = 2.5
	s_VehicleSpawnData.spawnProtectionRadius = 0
	s_VehicleSpawnData.spawnProtectionCheckAllTeams = true
	s_VehicleSpawnData.spawnProtectionFriendlyKilledCount = 0
	s_VehicleSpawnData.spawnProtectionFriendlyKilledTime = 30.0
	s_VehicleSpawnData.clearBangersOnSpawn = true
	s_VehicleSpawnData.onlySendEventForHumanPlayers = true
	s_VehicleSpawnData.sendWeaponEvents = false
	s_VehicleSpawnData.tryToSpawnOutOfSight = false
	s_VehicleSpawnData.takeControlEntryIndex = 0
	s_VehicleSpawnData.takeControlOnTransformChange = true
	s_VehicleSpawnData.returnControlOnIdle = true
	s_VehicleSpawnData.rotationYaw = 0.0
	s_VehicleSpawnData.rotationPitch = 0.0
	s_VehicleSpawnData.rotationRoll = 0.0
	s_VehicleSpawnData.throttle = 0.0
	s_VehicleSpawnData.overwriteThrottle = false
	s_VehicleSpawnData.initialVelocity = 0.0
	s_VehicleSpawnData.isDynamicSpawn = false
	s_VehicleSpawnData.wreckDuration = 0.0
    s_VehicleSpawnData.setTeamOnSpawn = false
    s_VehicleSpawnData.affectedByImpulse = true
    s_VehicleSpawnData.enterRestriction = 0
    s_VehicleSpawnData.botBailWhenHealthBelow = 0.0
    s_VehicleSpawnData.botBailOutDelay = 0.5
    s_VehicleSpawnData.applyDamageToAbandonedVehicles = true
    s_VehicleSpawnData.respawnRange = 15.0
    s_VehicleSpawnData.timeUntilAbandoned = 10.0
    s_VehicleSpawnData.timeUntilAbandonedIsDestroyed = 10.0
    s_VehicleSpawnData.keepAliveRadius = 15.0
    s_VehicleSpawnData.activeStanceEntryIndex = 0
    s_VehicleSpawnData.activeStance = 0
    s_VehicleSpawnData.vehicleIsNearDistance = 2.5
    s_VehicleSpawnData.enableAvailableSeatOutput = true
    s_VehicleSpawnData.disregardSpawnAllowedSetting = true
	return s_VehicleSpawnData
end

return VehicleSpawnReferenceObjectDataGenerator()
