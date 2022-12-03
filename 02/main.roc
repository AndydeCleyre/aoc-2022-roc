app "aoc-02"
    packages { pf: "https://github.com/roc-lang/basic-cli/releases/download/0.1.1/zAoiC9xtQPHywYk350_b7ust04BmWLW00sjb9ZPtSQk.tar.br" }
    imports [pf.Stdout, pf.File, pf.Path, pf.Task]
    provides [main] to pf

getStrategy = \filepath ->
    filepath
    |> Path.fromStr
    |> File.readUtf8
    |> Task.attempt \result ->
        result
        |> Result.withDefault ""
        |> Task.succeed

scoreShape = \shape ->
    when shape is
        Rock -> 1
        Paper -> 2
        Scissors -> 3

scoreOutcome = \outcome ->
    when outcome is
        Win -> 6
        Lose -> 0
        Draw -> 3

getOutcome = \{ opponentShape, selfShape } ->
    when opponentShape is
        Rock ->
            when selfShape is
                Rock -> Draw
                Paper -> Win
                Scissors -> Lose

        Paper ->
            when selfShape is
                Rock -> Lose
                Paper -> Draw
                Scissors -> Win

        Scissors ->
            when selfShape is
                Rock -> Win
                Paper -> Lose
                Scissors -> Draw

lineToRound = \line ->
    codedShapes = Str.split line " "
    opponentShape =
        when Result.withDefault (List.first codedShapes) "" is
            "A" -> Rock
            "B" -> Paper
            "C" -> Scissors
            _ -> crash "What is this shape code? on line: \(line)"
    selfShape =
        when Result.withDefault (List.last codedShapes) "" is
            "X" -> Rock
            "Y" -> Paper
            "Z" -> Scissors
            _ -> crash "What is this shape code? on line: \(line)"

    { opponentShape, selfShape }

lineToProperRound = \line ->
    codedShapes = Str.split line " "
    opponentShape =
        when Result.withDefault (List.first codedShapes) "" is
            "A" -> Rock
            "B" -> Paper
            "C" -> Scissors
            _ -> crash "What is this shape code? on line: \(line)"
    selfShape =
        when Result.withDefault (List.last codedShapes) "" is
            "X" ->
                when opponentShape is
                    Rock -> Scissors
                    Paper -> Rock
                    Scissors -> Paper

            "Y" -> opponentShape
            "Z" ->
                when opponentShape is
                    Rock -> Paper
                    Paper -> Scissors
                    Scissors -> Rock

            _ -> crash "What is this shape code? on line: \(line)"

    { opponentShape, selfShape }

getRounds = \strategy ->
    strategy
    |> Str.trim
    |> Str.split "\n"
    |> List.map lineToRound

getProperRounds = \strategy ->
    strategy
    |> Str.trim
    |> Str.split "\n"
    |> List.map lineToProperRound

scoreRounds = \rounds ->
    rounds
    |> List.walk 0 \total, round ->
        round
        |> getOutcome
        |> scoreOutcome
        |> Num.add
            (
                round.selfShape
                |> scoreShape
            )
        |> Num.add total

partOne =
    "input.txt"
    |> getStrategy
    |> Task.await \strategy ->
        strategy
        |> getRounds
        |> scoreRounds
        |> Num.toStr
        |> Stdout.line

partTwo =
    "input.txt"
    |> getStrategy
    |> Task.await \strategy ->
        strategy
        |> getProperRounds
        |> scoreRounds
        |> Num.toStr
        |> Stdout.line

main =
    partOne
    |> Task.await \_ ->
        partTwo
