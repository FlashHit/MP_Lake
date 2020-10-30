class "LinkConnections"

function LinkConnections:Create(source, target, sourceFieldId)
	
    local LinkConnection = LinkConnection()
    LinkConnection.source = source
    LinkConnection.target = target
    LinkConnection.sourceFieldId = tonumber(sourceFieldId) or MathUtils:FNVHash(sourceFieldId)
    LinkConnection.targetFieldId = 0

    return LinkConnection
end

return LinkConnections()



