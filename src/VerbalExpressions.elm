module VerbalExpressions exposing (VerbalExpression, anyOf, anything, anythingBut, beginCapture, captureGroup, endCapture, endOfLine, find, followedBy, lineBreak, multiple, multiple2, orElse, possibly, range, repeatPrevious, repeatPrevious2, replace, something, somethingBut, startOfLine, tab, toRegex, toString, verex, withAnyCase, word)

{-| Elm port of [VerbalExpressions](https://github.com/VerbalExpressions)
@docs verex, startOfLine, endOfLine, followedBy, find, possibly, anything, anythingBut, something, somethingBut, lineBreak, tab, word, anyOf, range, withAnyCase, repeatPrevious, repeatPrevious2, multiple, multiple2, orElse, beginCapture, endCapture, captureGroup, toRegex, toString, replace, VerbalExpression
-}

import Regex exposing (Regex)
import String


{-| The main type used for constructing verbal expressions
-}
type alias VerbalExpression =
    { prefixes : String
    , source : String
    , suffixes : String
    , modifiers :
        { insensitive : Bool
        , multiline : Bool
        }
    }


{-| An initial, empty verex to start from and pipe through functions
-}
verex : VerbalExpression
verex =
    { prefixes = ""
    , source = ""
    , suffixes = ""
    , modifiers =
        { insensitive = False
        , multiline = True
        }
    }


wrapWith : String -> String -> String -> String
wrapWith start end value =
    start ++ value ++ end


add : String -> VerbalExpression -> VerbalExpression
add value expression =
    { expression
        | source = expression.source ++ value
    }


{-| Restrict matches to start of line
-}
startOfLine : VerbalExpression -> VerbalExpression
startOfLine expression =
    { expression | prefixes = "^" ++ expression.prefixes }


{-| Restrict matches to end of line
-}
endOfLine : VerbalExpression -> VerbalExpression
endOfLine expression =
    { expression | suffixes = expression.suffixes ++ "$" }


{-| Include a matching group in the expression
-}
followedBy : String -> VerbalExpression -> VerbalExpression
followedBy value =
    value
        |> wrapWith "(?:" ")"
        |> add


{-| Start the expression with a matching group
-}
find : String -> VerbalExpression -> VerbalExpression
find =
    followedBy


{-| Include an optional matching group
-}
possibly : String -> VerbalExpression -> VerbalExpression
possibly value =
    value |> wrapWith "(?:" ")?" |> add


{-| Match any set of characters or not
-}
anything : VerbalExpression -> VerbalExpression
anything =
    add "(?:.*)"


{-| Match any set of characters except a particular String
-}
anythingBut : String -> VerbalExpression -> VerbalExpression
anythingBut value =
    value |> wrapWith "(?:[^" "]*)" |> add


{-| Match on one or more characters
-}
something : VerbalExpression -> VerbalExpression
something =
    add "(?:.+)"


{-| Match on one or more characters, with the execption of some String
-}
somethingBut : String -> VerbalExpression -> VerbalExpression
somethingBut value =
    value |> wrapWith "(?:[^" "]+)" |> add


{-| Match a new line
-}
lineBreak : VerbalExpression -> VerbalExpression
lineBreak =
    add "(?:\\r\\n|\\r|\\n)"


{-| Match a tab
-}
tab : VerbalExpression -> VerbalExpression
tab =
    add "\\t"


{-| Match an alphanumeric word
-}
word : VerbalExpression -> VerbalExpression
word =
    add "\\w+"


{-| Match a character class
-}
anyOf : String -> VerbalExpression -> VerbalExpression
anyOf value =
    value |> wrapWith "[" "]" |> add


{-| Match a character class with ranges
-}
range : List ( String, String ) -> VerbalExpression -> VerbalExpression
range args =
    let
        rendered =
            args
                |> List.map (\( left, right ) -> left ++ "-" ++ right)
                |> String.join ""
    in
    rendered |> wrapWith "[" "]" |> add


{-| Let the expression be case insensitive
-}
withAnyCase : Bool -> VerbalExpression -> VerbalExpression
withAnyCase enable expression =
    let
        modifiers =
            expression.modifiers
                |> (\mod -> { mod | insensitive = enable })
    in
    { expression | modifiers = modifiers }


{-| NOT SUPPORTED -- Elm regex does not support modifying the "m" flag yet
-}
searchOneLine : Bool -> VerbalExpression -> VerbalExpression
searchOneLine enable expression =
    let
        modifiers =
            expression.modifiers
                |> (\mod -> { mod | multiline = not enable })
    in
    { expression | modifiers = modifiers }


{-| Repeat the prior case a number of times
-}
repeatPrevious : Int -> VerbalExpression -> VerbalExpression
repeatPrevious times =
    times |> Basics.toString |> wrapWith "{" "}" |> add


{-| Repeat the prior case within some range of times
-}
repeatPrevious2 : Int -> Int -> VerbalExpression -> VerbalExpression
repeatPrevious2 start end =
    (Basics.toString start ++ "," ++ Basics.toString end)
        |> wrapWith "{" "}"
        |> add


{-| Match a group any number of times
-}
multiple : String -> VerbalExpression -> VerbalExpression
multiple value =
    value |> wrapWith "(?:" ")*" |> add


{-| Match a group a particular number of times
-}
multiple2 : String -> Int -> VerbalExpression -> VerbalExpression
multiple2 value times =
    let
        value_ =
            value |> wrapWith "(?:" ")"

        times_ =
            times |> Basics.toString |> wrapWith "{" "}"
    in
    add (value_ ++ times_)


{-| Add an alternative expression
-}
orElse : String -> VerbalExpression -> VerbalExpression
orElse value expression =
    let
        updatedPrefixes =
            expression.prefixes ++ "(?:"

        updatedSuffixes =
            ")" ++ expression.suffixes
    in
    expression
        |> add ")|(?:"
        |> followedBy value
        |> (\exp ->
                { exp | prefixes = updatedPrefixes }
                    |> (\exp -> { exp | suffixes = updatedSuffixes })
           )


{-| Start capturing a group
-}
beginCapture : VerbalExpression -> VerbalExpression
beginCapture expression =
    let
        updatedSuffixes =
            ")" ++ expression.suffixes
    in
    expression
        |> add "("
        |> (\exp -> { exp | suffixes = updatedSuffixes })


{-| Finish capturing a group
-}
endCapture : VerbalExpression -> VerbalExpression
endCapture expression =
    let
        updatedSuffixes =
            String.dropLeft 1 expression.suffixes
    in
    expression
        |> add ")"
        |> (\exp -> { exp | suffixes = updatedSuffixes })


{-| Captures a group
-}
captureGroup : VerbalExpression -> VerbalExpression
captureGroup expression =
    beginCapture >> expression >> endCapture


{-| Compile result down to a String
Note, this is just a string of the expression. Modifier flags are discarded.
-}
toString : VerbalExpression -> String
toString expression =
    expression.prefixes ++ expression.source ++ expression.suffixes


{-| Compile result down to a Regex.regex
-}
toRegex : VerbalExpression -> Regex
toRegex expression =
    let
        joined =
            toString expression

        initialOutput =
            Regex.regex joined

        flaggedOutput =
            if expression.modifiers.insensitive then
                Regex.caseInsensitive initialOutput
            else
                initialOutput
    in
    flaggedOutput


{-| Chainable function for replacing a string with another string using a Regex
created using VerbalExpressions
-}
replace : Regex.HowMany -> String -> String -> Regex -> String
replace howMany replacement input regex =
    Regex.replace howMany regex (always replacement) input
