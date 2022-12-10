include common

proc readInput(filename: string): seq[int] =
  result = readFile(filename)
    .split("\n\n")
    .mapIt(it.splitLines().filterIt(it.len > 0).mapIt(it.parseInt).sum)
    .sorted(Descending)

when isMainModule:
  let calories = readInput inputFilename(1)

  let part1 = calories[0]
  let part2 = calories[0..2].sum

  echo "Part 1 ", part1
  echo "Part 2 ", part2
