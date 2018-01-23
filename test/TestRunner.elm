module Main exposing (..)

import Console exposing (IO, run)
import ElmTest exposing (consoleRunner)
import Signal exposing (Signal)
import Task
import Tests


console : IO ()
console =
    consoleRunner Tests.all


port runner : Signal (Task.Task x ())
port runner =
    run console
