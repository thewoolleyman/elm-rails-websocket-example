module Domain.Events.Processor
    exposing
        ( processEvent
        , applyDomainEvents
        , latestDomainEventSequence
        )

import Domain.Types exposing (DomainState)
import Domain.Events.Types
    exposing
        ( DomainEvent
        , Sequence
        , DomainEventHistory
        , EventData(..)
        , invalidDomainEvent
        , textualEntityUpdatedEventData
        , numericEntityUpdatedEventData
        )
import Domain.Events.TextUpdated exposing (textUpdated)
import Domain.Events.NumberUpdated exposing (numberUpdated)
import List exposing (foldl, head)
import Maybe exposing (withDefault, map)
import Json.Decode
    exposing
        ( Decoder
        , decodeValue
        , succeed
        , fail
        , string
        , int
        , list
        , object1
        , object2
        , object3
        , at
        , andThen
        , (:=)
        )


applyDomainEvents : List DomainEvent -> DomainState -> DomainEventHistory -> ( DomainState, DomainEventHistory )
applyDomainEvents domainEvents domainState domainEventHistory =
    let
        newDomainState =
            foldl processEvent domainState domainEvents

        newDomainEventHistory =
            foldl logDomainEventToHistory domainEventHistory domainEvents
    in
        ( newDomainState, newDomainEventHistory )


{-|
    NOTE: union type constructors are not exposed outside of this module, as recommended by
     http://package.elm-lang.org/help/design-guidelines#keep-tags-and-record-constructors-secret
-}
processEvent : DomainEvent -> DomainState -> DomainState
processEvent domainEvent domainState =
    let
        eventData =
            domainEvent.data
    in
        case eventData of
            TextualEntityUpdated data ->
                textUpdated data domainState

            NumericEntityUpdated data ->
                numberUpdated data domainState

            Invalid msg ->
                Debug.crash ("Unable to process invalid domain event: " ++ msg)


logDomainEventToHistory : DomainEvent -> DomainEventHistory -> DomainEventHistory
logDomainEventToHistory domainEvent domainEventHistory =
    domainEvent :: domainEventHistory


latestDomainEventSequence : DomainEventHistory -> Sequence
latestDomainEventSequence domainEventHistory =
    map (\domainEvent -> domainEvent.sequence) (head domainEventHistory) |> withDefault 0
