include common

type
  Tree = tuple
    row, col, height: int

  Forest = seq[seq[Tree]]

  Dir = enum
    Up, Down, Left, Right

proc readForest(filename: string): seq[seq[Tree]] =
  result = newSeq[seq[Tree]]()
  for row, line in filename.lines.toSeq:
    var xs = newSeq[Tree]()
    for col, char in line:
      xs.add (row: row, col: col, height: char.int - '0'.int)
    result.add xs

func transpose(input: Forest): seq[seq[Tree]] =
  result = newSeq[seq[Tree]](input[0].len)
  for row in 0 .. input.len - 1:
    for col in 0 .. input[0].len - 1:
      result[col].add input[row][col]

func part1(forest: Forest): int =
  let 
    rows = forest.len
    cols = forest[0].len

  var visible = initHashSet[(int, int)]()

  proc markVisible(trees: seq[Tree]) =
    var height = -1
    for tree in trees:
      if tree.row == 0 or tree.col == 0 or tree.row == rows - 1 or tree.col == cols - 1:
        visible.incl((tree.row, tree.col))
      if tree.height > height:
        visible.incl((tree.row, tree.col))
        height = tree.height

  for row in 0 .. rows - 1:
    markVisible(forest[row])
    markVisible(forest[row].reversed)

  let transposed = transpose(forest)

  for col in 0 .. cols - 1:
    markVisible(transposed[col])
    markVisible(transposed[col].reversed)

  return visible.len

func scenicScore(forest: seq[seq[Tree]], tree: Tree): int =
  result = 1
  let height = tree.height

  for dir in [Up, Down, Left, Right]:
    var (row, col, _) = tree
    var directionScore = 0

    while true:
      case dir
        of Up: dec row
        of Down: inc row
        of Left: dec col
        of Right: inc col

      if row < 0 or row >= forest.len or col < 0 or col >= forest[0].len:
        break

      inc directionScore

      if forest[row][col].height >= height:
        break

    result *= directionScore

func part2(forest: Forest): int =
  result = -1
  for row in forest:
    for col in row:
      let score = scenicScore(forest, col)
      if score > result:
        result = score

when isMainModule:
  let forest = readForest inputFilename(8)

  echo "Part 1 ", part1(forest)
  echo "Part 2 ", part2(forest)
