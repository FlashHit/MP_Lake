
require("__shared/_CONFIG")

local AddBoats = require('__shared/addBoats')
local ModifyCapturePoints = require('__shared/modifyCapturePoints')

Events:Subscribe('Level:LoadResources', function(levelName, gameMode, isDedicatedServer)
	
	local levelDestroyEvent = Events:Subscribe('Level:Destroy', OnLevelDestroy)

	-- Don't do anything if the wrong level/gamemode is loaded
	if levelName ~= "Levels/MP_Subway/MP_Subway" or gameMode ~= "ConquestSmall0" then
		levelDestroyEvent:Unsubscribe()
		return
	end
	
	-- Mount boat bundles and add 2 boat spawns to the conquest logic
	AddBoats()

	-- Change flag positions
	ModifyCapturePoints()
end)

-- Deregistering, uninstalling and uninstalling in case the next level isn't MP_Subway
function OnLevelDestroy()

    -- entityResourceEvent:Unsubscribe()
    -- bundleMounterEvent:Unsubscribe()
	-- bundleHook:Uninstall()
    -- subWorldDataCallback:Deregister()
    -- cpBlueprintCallback:Deregister()
	
	subWorldDataCallback = nil
	entityResourceEvent = nil
	cpBlueprintCallback = nil
	bundleHook = nil
	
end