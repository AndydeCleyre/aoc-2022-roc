app "aoc-04"
    packages { pf: "https://github.com/roc-lang/basic-cli/releases/download/0.1.1/zAoiC9xtQPHywYk350_b7ust04BmWLW00sjb9ZPtSQk.tar.br" }
    imports [pf.Stdout, pf.File, pf.Path, pf.Task]
    provides [main] to pf

main =
    partOne
    |> Task.await \_ ->
        partTwo

partOne =
    "input.txt"
    |> getData
    |> Task.await \data ->
        data
        |> getRangePairs
        |> List.keepIf pairHasStrictSubset
        |> List.len
        |> Num.toStr
        |> Stdout.line

partTwo =
    "input.txt"
    |> getData
    |> Task.await \data ->
        data
        |> getRangePairs
        |> List.keepIf pairHasOverlap
        |> List.len
        |> Num.toStr
        |> Stdout.line

pairHasStrictSubset = \pair ->
    (
        (
            pair.a.start >= pair.b.start
        ) && (
            pair.a.end <= pair.b.end
        )
    ) || (
        (
            pair.b.start >= pair.a.start
        ) && (
            pair.b.end <= pair.a.end
        )
    )

pairHasOverlap = \pair ->
    (
        (
            pair.a.start <= pair.b.end
        ) && (
            pair.a.end >= pair.b.start
        )
    ) || (
        (
            pair.b.start <= pair.a.end
        ) && (
            pair.b.end >= pair.a.start
        )
    )

getRangePairs = \data ->
    data
    |> Str.trim
    |> Str.split "\n"
    |> List.walk [] \pairs, line ->
        pair =
            line
            |> Str.split ","
            |> List.map rangeStrToRecord
        pairs
        |> List.append {
            a: rangeOrDie (List.first pair),
            b: rangeOrDie (List.last pair)
        }

rangeStrToRecord = \rangeStr ->
    startEnd =
        rangeStr
        |> Str.split "-"
        |> List.map \numStr ->
            numStr
            |> Str.toNat
            |> numOrDie
    start =
        startEnd
        |> List.first
        |> numOrDie
    end =
        startEnd
        |> List.last
        |> numOrDie
    { start, end }

numOrDie = \result ->
    when result is
        Ok num -> num
        Err _ -> crash "Uh oh"

rangeOrDie = \result ->
    when result is
        Ok range -> range
        Err _ -> crash "Uh oh"

getData = \filepath ->
    filepath
    |> Path.fromStr
    |> File.readUtf8
    |> Task.attempt \result ->
        result
        |> Result.withDefault ""
        |> Task.succeed
