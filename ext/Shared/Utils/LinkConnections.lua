class "LinkConnections"

function LinkConnections:Create(p_Source, p_Target, p_SourceFieldId)
    local s_LinkConnection = LinkConnection()
    s_LinkConnection.source = p_Source
    s_LinkConnection.target = p_Target
    s_LinkConnection.sourceFieldId = tonumber(p_SourceFieldId) or MathUtils:FNVHash(p_SourceFieldId)
    s_LinkConnection.targetFieldId = 0

    return s_LinkConnection
end

return LinkConnections()
