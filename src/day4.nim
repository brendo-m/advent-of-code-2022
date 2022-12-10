include common

type 
  Pair = tuple[s: int, e: int]

func parsePair(s: string): Pair =
  let
    a = s.split("-")
    s = parseInt(a[0])
    e = parseInt(a[1])
  (s: s, e: e)

func parsePairs(s: string): (Pair, Pair) =
  let pairs = s.split(",")
  (parsePair(pairs[0]), parsePair(pairs[1]))

func encloses(a, b: Pair): bool = a.s <= b.s and a.e >= b.e

func overlaps(a, b: Pair): bool = 
  (a.s <= b.e and a.e >= b.s) or (b.s <= a.e and b.e >= a.s)

when isMainModule:
  let input = inputFilename(4).lines.toSeq.mapIt(parsePairs(it)) 

  let part1 = input
    .filterIt(encloses(it[0], it[1]) or encloses(it[1], it[0]))
    .len
  let part2 = input
    .filterIt(overlaps(it[0], it[1]))
    .len

  echo "Part 1 ", part1
  echo "Part 2 ", part2
