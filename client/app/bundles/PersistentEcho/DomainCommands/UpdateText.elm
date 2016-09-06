module PersistentEcho.DomainCommands.UpdateText exposing (..)

import PersistentEcho.Types exposing (..)


updateText : String -> DomainCommand
updateText newText =
    UpdateTextCommand
        { name = "UpdateText"
        , data = { text = newText }
        }
