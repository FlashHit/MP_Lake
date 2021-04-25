class "PropertyConnections"

function PropertyConnections:Create(p_Source, p_Target, p_SourceFieldId, p_TargetFieldId)
    local s_PropertyConnection = PropertyConnection()
    s_PropertyConnection.source = p_Source
    s_PropertyConnection.target = p_Target
    s_PropertyConnection.sourceFieldId = tonumber(p_SourceFieldId) or MathUtils:FNVHash(p_SourceFieldId)
    s_PropertyConnection.targetFieldId = tonumber(p_TargetFieldId) or MathUtils:FNVHash(p_TargetFieldId)

    return s_PropertyConnection
end

return PropertyConnections()
