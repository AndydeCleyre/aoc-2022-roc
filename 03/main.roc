app "aoc-03"
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
        |> getRucksacks
        |> List.map commonItemType
        |> List.map itemTypePriority
        |> List.sum
        |> Num.toStr
        |> Stdout.line

partTwo =
    "input.txt"
    |> getData
    |> Task.await \data ->
        data
        |> getRucksacks
        |> rucksackTriplets
        |> List.map badgeItemType
        |> List.map itemTypePriority
        |> List.sum
        |> Num.toStr
        |> Stdout.line

getData = \filepath ->
    filepath
    |> Path.fromStr
    |> File.readUtf8
    |> Task.attempt \result ->
        result
        |> Result.withDefault ""
        |> Task.succeed

itemTypes = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"

itemTypePriority = \itemType ->
    indexResult =
        itemTypes
        |> Str.graphemes
        |> List.findFirstIndex \letter ->
            letter == itemType
    if Result.isErr indexResult then
        crash "Uh oh"
    else
        indexResult
        |> Result.withDefault 0
        |> Num.add 1

getRucksacks = \data ->
    data
    |> Str.trim
    |> Str.split "\n"

commonItemType = \rucksack ->
    compartmentSize =
        rucksack
        |> Str.countGraphemes
        |> Num.divTrunc 2
    allItems =
        rucksack
        |> Str.graphemes
    leftItemTypes =
        allItems
        |> List.sublist { start: 0, len: compartmentSize }
        |> Set.fromList
    rightItemTypes =
        allItems
        |> List.sublist { start: compartmentSize, len: compartmentSize }
        |> Set.fromList
    result =
        leftItemTypes
        |> Set.intersection rightItemTypes
        |> Set.toList
        |> List.first
    if Result.isErr result then
        crash "Uh oh"
    else
        result
        |> Result.withDefault ""

rucksackTriplets = \rucksacks ->
    List.range 0 (List.len rucksacks)
    |> List.keepIf \num ->
        num % 3 == 0
    |> List.map \index ->
        rucksacks
        |> List.sublist { start: index, len: 3 }

badgeItemType = \rucksackTriplet ->
    typesA =
        rucksackTriplet
        |> List.first
        |> Result.withDefault ""
        |> Str.graphemes
        |> Set.fromList
    typesB =
        rucksackTriplet
        |> List.get 1
        |> Result.withDefault ""
        |> Str.graphemes
        |> Set.fromList
    typesC =
        rucksackTriplet
        |> List.last
        |> Result.withDefault ""
        |> Str.graphemes
        |> Set.fromList
    result = typesA
        |> Set.intersection typesB
        |> Set.intersection typesC
        |> Set.toList
        |> List.first
    if Result.isErr result then
        crash "Uh oh"
    else
        result
        |> Result.withDefault ""
