class "EventConnections"

function EventConnections:Create(p_Source, p_Target, p_SourceEvent, p_TargetEvent, p_EventType)
    local s_SourceEventSpec = EventSpec()
    s_SourceEventSpec.id = tonumber(p_SourceEvent) or MathUtils:FNVHash(p_SourceEvent)
    local s_TargetEventSpec = EventSpec()
    s_TargetEventSpec.id = tonumber(p_TargetEvent) or MathUtils:FNVHash(p_TargetEvent)
    local s_EventConnection = EventConnection()
    s_EventConnection.source = p_Source
    s_EventConnection.target = p_Target
    s_EventConnection.sourceEvent = s_SourceEventSpec
    s_EventConnection.targetEvent = s_TargetEventSpec
    s_EventConnection.targetType = p_EventType

    return s_EventConnection
end

return EventConnections()
