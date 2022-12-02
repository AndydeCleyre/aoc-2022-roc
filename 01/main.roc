app "aoc-01"
    packages { pf: "https://github.com/roc-lang/basic-cli/releases/download/0.1.1/zAoiC9xtQPHywYk350_b7ust04BmWLW00sjb9ZPtSQk.tar.br" }
    imports [pf.Stdout, pf.File, pf.Path, pf.Task]
    provides [main] to pf

getLedger = \filepath ->
    filepath
    |> Path.fromStr
    |> File.readUtf8
    |> Task.attempt \result ->
        result
        |> Result.withDefault ""
        |> Task.succeed

getTotals = \ledger ->
    ledger
    |> Str.split "\n\n"
    |> List.map \elfItemBlock ->
        elfItemBlock
        |> Str.split "\n"
        |> List.walk 0 \total, item ->
            item
            |> Str.toNat
            |> Result.withDefault 0
            |> Num.add total

main =
    "input.txt"
    |> getLedger
    |> Task.await \data ->
        data
        |> getTotals
        |> List.max
        |> Result.withDefault 0
        |> Num.toStr
        |> Stdout.line
