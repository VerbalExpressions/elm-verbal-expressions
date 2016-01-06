module Tests where

import ElmTest exposing (..)

import VerbalExpressions exposing (..)
import Regex

all : Test
all =
  suite "A Test Suite"
    [ suite "something"
      [ test "empty string doesn't have something" somethingEmptyTest
      , test "'a' is something" somethingNotEmptyTest
      ]
    , suite "anything"
      [ test "matches anything" anythingTest
      ]
    , suite "anythingBut"
      [ test "starts with w" anythingButTest
      ]
    , suite "somethingBut"
      [ test "empty string doesn't have something" somethingButEmptyTest
      , test "doesn't start with 'a'" somethingButMatchTest
      , test "starts with 'a'" somethingButMismatchTest
      ]
    , suite "startOfLine"
      [ test "starts with 'a'" startOfLineMatchTest
      , test "doesn't start with 'a'" startOfLineMismatchTest
      ]
    , suite "endOfLine"
      [ test "ends with 'a'" endOfLineMatchTest
      , test "doesn't end with 'a'" endOfLineMismatchTest
      ]
    , suite "possibly"
      [ test "with a match" possiblyWithMatchTest
      , test "without a match" possiblyWithoutMatchTest
      ]
    , suite "anyOf"
      [ test "has an x, y, or z after an a" anyOfMatchTest
      , test "doesn't have an x, y, or z after an a" anyOfMismatchTest
      ]
    , suite "orElse"
      [ test "starts with abc or def" orElseMatchTest
      , test "doesn't start with abc or def" orElseMismatchTest
      ]
    , suite "lineBreak"
      [ test "abc then line break then def" lineBreakTest
      ]
    , suite "tab"
      [ test "tab then def" tabTest
      ]
    , suite "withAnyCase"
      [ test "lowercase 'a' matches uppercase 'A'" withAnyCaseTest
      ]
    , suite "toString"
      [ test "can be stringified" toStringCaseTest
      ]
    ]

somethingEmptyTest : Assertion
somethingEmptyTest =
  let
    testEx =
      verex
        |> something
        |> toRegex
  in
    assertEqual False (Regex.contains testEx "")

somethingNotEmptyTest : Assertion
somethingNotEmptyTest =
  let
    testEx =
      verex
        |> something
        |> toRegex
  in
    assertEqual True (Regex.contains testEx "a")

anythingTest : Assertion
anythingTest =
  let
    testEx =
      verex |> startOfLine |> anything |> toRegex
  in
    assertEqual True (Regex.contains testEx "awiorllkhahl124559a agaogg87")

anythingButTest : Assertion
anythingButTest =
  let
    testEx =
      verex |> startOfLine |> anythingBut "w" |> toRegex
  in
    assertEqual True (Regex.contains testEx "what")

somethingButEmptyTest : Assertion
somethingButEmptyTest =
  let
    testEx =
      verex |> somethingBut "a" |> toRegex
  in
    assertEqual False (Regex.contains testEx "")

somethingButMatchTest : Assertion
somethingButMatchTest =
  let
    testEx =
      verex |> somethingBut "a" |> toRegex
  in
    assertEqual True (Regex.contains testEx "b")

somethingButMismatchTest : Assertion
somethingButMismatchTest =
  let
    testEx =
      verex |> somethingBut "a" |> toRegex
  in
    assertEqual False (Regex.contains testEx "a")

startOfLineMatchTest : Assertion
startOfLineMatchTest =
  let
    testEx =
      verex |> startOfLine |> followedBy "a" |> toRegex
  in
    assertEqual True (Regex.contains testEx "ab")

startOfLineMismatchTest : Assertion
startOfLineMismatchTest =
  let
    testEx =
      verex |> startOfLine |> followedBy "a" |> toRegex
  in
    assertEqual False (Regex.contains testEx "ba")

endOfLineMatchTest : Assertion
endOfLineMatchTest =
  let
    testEx =
      verex |> find "a" |> endOfLine |> toRegex
  in
    assertEqual True (Regex.contains testEx "ba")

endOfLineMismatchTest : Assertion
endOfLineMismatchTest =
  let
    testEx =
      verex |> find "a" |> endOfLine |> toRegex
  in
    assertEqual False (Regex.contains testEx "ab")

possiblyWithMatchTest : Assertion
possiblyWithMatchTest =
  let
    testEx =
      verex |> startOfLine |> followedBy "a" |> possibly "b" |> toRegex
  in
    assertEqual True (Regex.contains testEx "abc")

possiblyWithoutMatchTest : Assertion
possiblyWithoutMatchTest =
  let
    testEx =
      verex |> startOfLine |> followedBy "a" |> possibly "b" |> toRegex
  in
    assertEqual True (Regex.contains testEx "acd")

anyOfMatchTest : Assertion
anyOfMatchTest =
  let
    testEx =
      verex |> startOfLine |> followedBy "a" |> anyOf "xyz" |> toRegex
  in
    assertEqual True (Regex.contains testEx "ay")

anyOfMismatchTest : Assertion
anyOfMismatchTest =
  let
    testEx =
      verex |> startOfLine |> followedBy "a" |> anyOf "xyz" |> toRegex
  in
    assertEqual False (Regex.contains testEx "ab")

orElseMatchTest : Assertion
orElseMatchTest =
  let
    testEx =
      verex |> startOfLine |> followedBy "abc" |> orElse "def" |> toRegex
  in
    assertEqual True (Regex.contains testEx "defzzz")


orElseMismatchTest : Assertion
orElseMismatchTest =
  let
    testEx =
      verex |> startOfLine |> followedBy "abc" |> orElse "def" |> toRegex
  in
    assertEqual False (Regex.contains testEx "zzzabc")

lineBreakTest : Assertion
lineBreakTest =
  let
    testEx =
      verex |> startOfLine |> followedBy "abc" |> lineBreak |> followedBy "def" |> toRegex
  in
    assertEqual True (Regex.contains testEx "abc\r\ndef")

tabTest : Assertion
tabTest =
  let
    testEx =
      verex |> startOfLine |> tab |> followedBy "def" |> toRegex
  in
    assertEqual True (Regex.contains testEx "\tdef")

withAnyCaseTest : Assertion
withAnyCaseTest =
  let
    testEx =
      verex |> startOfLine |> followedBy "a" |> withAnyCase True |> toRegex
  in
    assertEqual True (Regex.contains testEx "A")

toStringCaseTest : Assertion
toStringCaseTest =
  let
    testEx =
      verex |> startOfLine |> followedBy "a" |> VerbalExpressions.toString
  in
    assertEqual "^(?:a)" testEx
