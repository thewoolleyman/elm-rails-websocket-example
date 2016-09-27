module PersistentEcho.Domain.Events.NumberUpdated exposing (numberUpdated)

import PersistentEcho.Types exposing (DomainState)


numberUpdated : Int -> DomainState -> DomainState
numberUpdated newInteger domainState =
    { domainState | integer = newInteger }
