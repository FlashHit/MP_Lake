
require("__shared/_CONFIG")
require('__shared/AddBoats')
require('__shared/ModifyCapturePoints')

ResourceManager:RegisterInstanceLoadHandler(Guid('0964415F-1A6E-4BA3-A11D-EEDDF2DB9FD2'), Guid('B3B384A6-B1B1-4D81-9EC2-08322A8A7FFA'), function(p_Instance)
    if SharedUtils:GetLevelName() ~= 'Levels/MP_Subway/MP_Subway' or SharedUtils:GetCurrentGameMode() ~= "ConquestSmall0" then
        return
    end
    p_Instance = SubWorldData(p_Instance)
    p_Instance:MakeWritable()
	AddBoats(p_Instance)
	ModifyCapturePoints(p_Instance)
end)
