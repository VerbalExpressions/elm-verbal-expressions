# VerbalExpressions

VerbalExpressions is an Elm package that helps to construct difficult regular
expressions.

## Other Implementations

You can see an up to date list of all ports on [VerbalExpressions.github.io](http://VerbalExpressions.github.io).
- [Ruby](https://github.com/ryan-endacott/verbal_expressions)
- [C#](https://github.com/VerbalExpressions/CSharpVerbalExpressions)
- [Python](https://github.com/VerbalExpressions/PythonVerbalExpressions)
- [Java](https://github.com/VerbalExpressions/JavaVerbalExpressions)
- [Groovy](https://github.com/VerbalExpressions/GroovyVerbalExpressions)
- [PHP](https://github.com/VerbalExpressions/PHPVerbalExpressions)
- [Haskell](https://github.com/VerbalExpressions/HaskellVerbalExpressions)
- [C++](https://github.com/VerbalExpressions/CppVerbalExpressions)
- [Objective-C](https://github.com/VerbalExpressions/ObjectiveCVerbalExpressions)
- [Perl](https://github.com/VerbalExpressions/PerlVerbalExpressions)

## Example

```elm
import Regex exposing (Regex, HowMany(..))
import VerbalExpressions exposing (..)


{-| Create an example of how to test for correctly formed URLs
-}
tester : Regex
tester =
  verex
    |> startOfLine
    |> followedBy "http"
    |> possibly "s"
    |> followedBy "://"
    |> possibly "www."
    |> anythingBut " "
    |> endOfLine
    |> toRegex


{-| Create an example URL
-}
testMe : String
testMe =
  "https://www.google.com"


{-| Use Regex.contains to determine if we have a url

    result == True
-}
result : Bool
result =
  Regex.contains tester testMe


{-| Replace a string with another

    replaced == "We have a blue house"
-}
replaced : String
replaced =
  verex
    |> find "red"
    |> toRegex
    |> replace All "blue" "We have a red house"
```

## API differences

The following table illustrates any differences between this package's function
names and the canonical VerbalExpressions operator names, and explains the
reason for the difference.

| Operator Name | Function Name | Reason |
|---------------|---------------|--------|
| `then`        | `followedBy`  | `then` is a keyword in Elm, and the compiler will not allow aliasing of keywords. `andThen` is typically used in this scenario, but as a result has taken on an implicit use with chainable data-types like `Task` and `Maybe`. `followedBy` is a good synonym for the semantic meaning of the `then` VerbalExpressions operator. |
| `maybe`       | `possibly`    | `maybe` might cause confusion due to the existence of the core `Maybe` type. |
| `or`          | `orElse`      | `or` is already a built-in function for performing logical-or operations on `Bool` values. It's best practice not to alias basic functions. |

Additionally, the following operators have been omitted for technical or conventional reasons.

| Operator Name   | Reason |
|-----------------|--------|
| `br`            | Elm conventions encourage a minimal API surface, and `br` offers no different readability semantics from `lineBreak`. |
| `any`           | See above for `br`, as it applies to `anyOf`. |
| `stopAtFirst`   | Elm regular expressions handle number of matches at the function-call level, with the `Regex.HowMany` type, so this functionality is not supported or needed. |
| `searchOneLine` | Elm's regular expressions do not support setting the `"m"` flag on their internal JavaScript representations yet. |

---

This Elm package is based on the original Javascript
[VerbalExpressions](https://github.com/VerbalExpressions/JSVerbalExpressions)
library by [jehna](https://github.com/jehna/).
