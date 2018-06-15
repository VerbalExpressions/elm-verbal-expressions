module Tests exposing (all)

import Expect
import Regex
import Test
import VerbalExpressions as VerEx


all : Test.Test
all =
    Test.describe "A Test Suite"
        [ Test.describe "startOfLine"
            [ Test.test "starts with 'a'" startOfLineMatchTest
            , Test.test "doesn't start with 'a'" startOfLineMismatchTest
            ]
        , Test.describe "endOfLine"
            [ Test.test "ends with 'a'" endOfLineMatchTest
            , Test.test "doesn't end with 'a'" endOfLineMismatchTest
            ]
        , Test.describe "possibly"
            [ Test.test "with a match" possiblyWithMatchTest
            , Test.test "without a match" possiblyWithoutMatchTest
            ]
        , Test.describe "anything"
            [ Test.test "matches anything" anythingTest
            ]
        , Test.describe "anythingBut"
            [ Test.test "starts with w" anythingButTest
            ]
        , Test.describe "something"
            [ Test.test "empty string doesn't have something" somethingEmptyTest
            , Test.test "'a' is something" somethingNotEmptyTest
            ]
        , Test.describe "somethingBut"
            [ Test.test "empty string doesn't have something" somethingButEmptyTest
            , Test.test "doesn't start with 'a'" somethingButMatchTest
            , Test.test "starts with 'a'" somethingButMismatchTest
            ]
        , Test.describe "lineBreak"
            [ Test.test "abc then line break then def" lineBreakTest
            ]
        , Test.describe "tab"
            [ Test.test "tab then def" tabTest
            ]
        , Test.describe "word"
            [ Test.test "matches word" wordMatchTest
            , Test.test "does not match two words" wordNotMatchTest
            ]
        , Test.describe "anyOf"
            [ Test.test "has an x, y, or z after an a" anyOfMatchTest
            , Test.test "doesn't have an x, y, or z after an a" anyOfMismatchTest
            ]
        , Test.describe "range"
            [ Test.test "matches range" rangeMatchTest
            , Test.test "does not match invalid range" rangeNotMatchTest
            ]
        , Test.describe "withAnyCase"
            [ Test.test "lowercase 'a' matches uppercase 'A'" withAnyCaseTest
            ]
        , Test.describe "orElse"
            [ Test.test "starts with abc or def" orElseMatchTest
            , Test.test "doesn't start with abc or def" orElseMismatchTest
            ]
        , Test.describe "toString"
            [ Test.test "can be stringified" toStringCaseTest
            ]
        ]


somethingEmptyTest : () -> Expect.Expectation
somethingEmptyTest _ =
    let
        testEx =
            VerEx.verex
                |> VerEx.something
                |> VerEx.toRegex
    in
    Expect.equal False (Regex.contains testEx "")


somethingNotEmptyTest : () -> Expect.Expectation
somethingNotEmptyTest _ =
    let
        testEx =
            VerEx.verex
                |> VerEx.something
                |> VerEx.toRegex
    in
    Expect.equal True (Regex.contains testEx "a")


anythingTest : () -> Expect.Expectation
anythingTest _ =
    let
        testEx =
            VerEx.verex
                |> VerEx.startOfLine
                |> VerEx.anything
                |> VerEx.toRegex
    in
    Expect.equal True (Regex.contains testEx "awiorllkhahl124559a agaogg87")


anythingButTest : () -> Expect.Expectation
anythingButTest _ =
    let
        testEx =
            VerEx.verex
                |> VerEx.startOfLine
                |> VerEx.anythingBut "w"
                |> VerEx.toRegex
    in
    Expect.equal True (Regex.contains testEx "what")


somethingButEmptyTest : () -> Expect.Expectation
somethingButEmptyTest _ =
    let
        testEx =
            VerEx.verex
                |> VerEx.somethingBut "a"
                |> VerEx.toRegex
    in
    Expect.equal False (Regex.contains testEx "")


somethingButMatchTest : () -> Expect.Expectation
somethingButMatchTest _ =
    let
        testEx =
            VerEx.verex
                |> VerEx.somethingBut "a"
                |> VerEx.toRegex
    in
    Expect.equal True (Regex.contains testEx "b")


somethingButMismatchTest : () -> Expect.Expectation
somethingButMismatchTest _ =
    let
        testEx =
            VerEx.verex
                |> VerEx.somethingBut "a"
                |> VerEx.toRegex
    in
    Expect.equal False (Regex.contains testEx "a")


startOfLineMatchTest : () -> Expect.Expectation
startOfLineMatchTest _ =
    let
        testEx =
            VerEx.verex
                |> VerEx.startOfLine
                |> VerEx.followedBy "a"
                |> VerEx.toRegex
    in
    Expect.equal True (Regex.contains testEx "ab")


startOfLineMismatchTest : () -> Expect.Expectation
startOfLineMismatchTest _ =
    let
        testEx =
            VerEx.verex
                |> VerEx.startOfLine
                |> VerEx.followedBy "a"
                |> VerEx.toRegex
    in
    Expect.equal False (Regex.contains testEx "ba")


endOfLineMatchTest : () -> Expect.Expectation
endOfLineMatchTest _ =
    let
        testEx =
            VerEx.verex
                |> VerEx.find "a"
                |> VerEx.endOfLine
                |> VerEx.toRegex
    in
    Expect.equal True (Regex.contains testEx "ba")


endOfLineMismatchTest : () -> Expect.Expectation
endOfLineMismatchTest _ =
    let
        testEx =
            VerEx.verex
                |> VerEx.find "a"
                |> VerEx.endOfLine
                |> VerEx.toRegex
    in
    Expect.equal False (Regex.contains testEx "ab")


possiblyWithMatchTest : () -> Expect.Expectation
possiblyWithMatchTest _ =
    let
        testEx =
            VerEx.verex
                |> VerEx.startOfLine
                |> VerEx.followedBy "a"
                |> VerEx.possibly "b"
                |> VerEx.toRegex
    in
    Expect.equal True (Regex.contains testEx "abc")


possiblyWithoutMatchTest : () -> Expect.Expectation
possiblyWithoutMatchTest _ =
    let
        testEx =
            VerEx.verex
                |> VerEx.startOfLine
                |> VerEx.followedBy "a"
                |> VerEx.possibly "b"
                |> VerEx.toRegex
    in
    Expect.equal True (Regex.contains testEx "acd")


anyOfMatchTest : () -> Expect.Expectation
anyOfMatchTest _ =
    let
        testEx =
            VerEx.verex
                |> VerEx.startOfLine
                |> VerEx.followedBy "a"
                |> VerEx.anyOf "xyz"
                |> VerEx.toRegex
    in
    Expect.equal True (Regex.contains testEx "ay")


anyOfMismatchTest : () -> Expect.Expectation
anyOfMismatchTest _ =
    let
        testEx =
            VerEx.verex
                |> VerEx.startOfLine
                |> VerEx.followedBy "a"
                |> VerEx.anyOf "xyz"
                |> VerEx.toRegex
    in
    Expect.equal False (Regex.contains testEx "ab")


orElseMatchTest : () -> Expect.Expectation
orElseMatchTest _ =
    let
        testEx =
            VerEx.verex
                |> VerEx.startOfLine
                |> VerEx.followedBy "abc"
                |> VerEx.orElse "def"
                |> VerEx.toRegex
    in
    Expect.equal True (Regex.contains testEx "defzzz")


orElseMismatchTest : () -> Expect.Expectation
orElseMismatchTest _ =
    let
        testEx =
            VerEx.verex
                |> VerEx.startOfLine
                |> VerEx.followedBy "abc"
                |> VerEx.orElse "def"
                |> VerEx.toRegex
    in
    Expect.equal False (Regex.contains testEx "zzzabc")


lineBreakTest : () -> Expect.Expectation
lineBreakTest _ =
    let
        testEx =
            VerEx.verex
                |> VerEx.startOfLine
                |> VerEx.followedBy "abc"
                |> VerEx.lineBreak
                |> VerEx.followedBy "def"
                |> VerEx.toRegex
    in
    Expect.equal True (Regex.contains testEx "abc\u{000D}\ndef")


tabTest : () -> Expect.Expectation
tabTest _ =
    let
        testEx =
            VerEx.verex
                |> VerEx.startOfLine
                |> VerEx.tab
                |> VerEx.followedBy "def"
                |> VerEx.toRegex
    in
    Expect.equal True (Regex.contains testEx "\tdef")


wordMatchTest : () -> Expect.Expectation
wordMatchTest _ =
    let
        testEx =
            VerEx.verex
                |> VerEx.startOfLine
                |> VerEx.word
                |> VerEx.endOfLine
                |> VerEx.toRegex
    in
    Expect.equal True (Regex.contains testEx "def123")


wordNotMatchTest : () -> Expect.Expectation
wordNotMatchTest _ =
    let
        testEx =
            VerEx.verex
                |> VerEx.startOfLine
                |> VerEx.word
                |> VerEx.endOfLine
                |> VerEx.toRegex
    in
    Expect.equal False (Regex.contains testEx "def 123")


rangeMatchTest : () -> Expect.Expectation
rangeMatchTest _ =
    let
        testEx =
            VerEx.verex
                |> VerEx.startOfLine
                |> VerEx.range [ ( "0", "9" ) ]
                |> VerEx.endOfLine
                |> VerEx.toRegex
    in
    Expect.equal True (Regex.contains testEx "1")


rangeNotMatchTest : () -> Expect.Expectation
rangeNotMatchTest _ =
    let
        testEx =
            VerEx.verex
                |> VerEx.startOfLine
                |> VerEx.range [ ( "0", "9" ) ]
                |> VerEx.endOfLine
                |> VerEx.toRegex
    in
    Expect.equal False (Regex.contains testEx "a")


withAnyCaseTest : () -> Expect.Expectation
withAnyCaseTest _ =
    let
        testEx =
            VerEx.verex
                |> VerEx.startOfLine
                |> VerEx.followedBy "a"
                |> VerEx.withAnyCase True
                |> VerEx.toRegex
    in
    Expect.equal True (Regex.contains testEx "A")


toStringCaseTest : () -> Expect.Expectation
toStringCaseTest _ =
    let
        testEx =
            VerEx.verex
                |> VerEx.startOfLine
                |> VerEx.followedBy "a"
                |> VerEx.toString
    in
    Expect.equal "^(?:a)" testEx
