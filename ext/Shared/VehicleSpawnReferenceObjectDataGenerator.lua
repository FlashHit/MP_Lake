class 'VehicleSpawnReferenceObjectDataGenerator'

function VehicleSpawnReferenceObjectDataGenerator:Create(blueprint, transform, team, randomGuid1)
	local vehicleSpawnData = VehicleSpawnReferenceObjectData(randomGuid1)
	
    vehicleSpawnData.enabled = true
    vehicleSpawnData.team = team
    vehicleSpawnData.blueprint = blueprint
    vehicleSpawnData.blueprintTransform = transform
    vehicleSpawnData.isEventConnectionTarget = 2
    vehicleSpawnData.isPropertyConnectionTarget = 3
	vehicleSpawnData.lockedTeam = true --not working?
	vehicleSpawnData.initialAutoSpawn = true
	vehicleSpawnData.autoSpawn = true
	vehicleSpawnData.useAsSpawnPoint = false --not working?
	vehicleSpawnData.initialSpawnDelay = 0.0
    vehicleSpawnData.spawnDelay = 25.0
	vehicleSpawnData.maxCount = 0
	vehicleSpawnData.maxCountSimultaneously = 1
	vehicleSpawnData.totalCountSimultaneouslyOfType = 0
	vehicleSpawnData.spawnAreaRadius = 2.5
	vehicleSpawnData.spawnProtectionRadius = 0
	vehicleSpawnData.spawnProtectionCheckAllTeams = true
	vehicleSpawnData.spawnProtectionFriendlyKilledCount = 0
	vehicleSpawnData.spawnProtectionFriendlyKilledTime = 30.0
	vehicleSpawnData.clearBangersOnSpawn = true
	vehicleSpawnData.onlySendEventForHumanPlayers = true
	vehicleSpawnData.sendWeaponEvents = false
	vehicleSpawnData.tryToSpawnOutOfSight = false
	vehicleSpawnData.takeControlEntryIndex = 0
	vehicleSpawnData.takeControlOnTransformChange = true
	vehicleSpawnData.returnControlOnIdle = true
	vehicleSpawnData.rotationYaw = 0.0
	vehicleSpawnData.rotationPitch = 0.0
	vehicleSpawnData.rotationRoll = 0.0
	vehicleSpawnData.throttle = 0.0
	vehicleSpawnData.overwriteThrottle = false
	vehicleSpawnData.initialVelocity = 0.0
	vehicleSpawnData.isDynamicSpawn = false
	vehicleSpawnData.wreckDuration = 0.0
    vehicleSpawnData.setTeamOnSpawn = false
    vehicleSpawnData.affectedByImpulse = true
    vehicleSpawnData.enterRestriction = 0
    vehicleSpawnData.botBailWhenHealthBelow = 0.0
    vehicleSpawnData.botBailOutDelay = 0.5
    vehicleSpawnData.applyDamageToAbandonedVehicles = true
    vehicleSpawnData.respawnRange = 15.0
    vehicleSpawnData.timeUntilAbandoned = 10.0
    vehicleSpawnData.timeUntilAbandonedIsDestroyed = 10.0
    vehicleSpawnData.keepAliveRadius = 15.0
    vehicleSpawnData.activeStanceEntryIndex = 0
    vehicleSpawnData.activeStance = 0
    vehicleSpawnData.vehicleIsNearDistance = 2.5
    vehicleSpawnData.enableAvailableSeatOutput = true
    vehicleSpawnData.disregardSpawnAllowedSetting = true
	
	return vehicleSpawnData
end

return VehicleSpawnReferenceObjectDataGenerator()