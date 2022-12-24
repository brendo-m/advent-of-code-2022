include common

type 
  Position = tuple[row, col: int]

  Grove = object
    positions: HashSet[Position]
    topLeft: Position
    bottomRight: Position

  Direction = enum
    NW, N, NE, E, SE, S, SW, W

func `$`(g: Grove): string =
  for row in g.topLeft.row .. g.bottomRight.row:
    for col in g.topLeft.col .. g.bottomRight.col:
      if (row, col) in g.positions:
        result.add '#'
      else:
        result.add '.'
    result.add '\n'

func incl(grove: var Grove, position: Position) =
  grove.positions.incl position
  if position.row > grove.bottomRight.row:
    grove.bottomRight.row = position.row
  if position.row < grove.topLeft.row:
    grove.topLeft.row = position.row
  if position.col > grove.bottomRight.col:
    grove.bottomRight.col = position.col
  if position.col < grove.topLeft.col:
    grove.topLeft.col = position.col

func excl(grove: var Grove, position: Position) =
  grove.positions.excl position
  if position.row == grove.bottomRight.row:
    grove.bottomRight.row = grove.positions.mapIt(it.row).max
  if position.col == grove.bottomRight.col:
    grove.bottomRight.col = grove.positions.mapIt(it.col).max

const WITH_DIAGONALS = {
  N: [NW, N, NE],
  S: [SW, S, SE],
  W: [NW, W, SW],
  E: [NE, E, SE]
}.toTable

func at(position: Position, dir: Direction): Position =
  case dir
  of NW: (position.row - 1, position.col - 1)
  of N: (position.row - 1, position.col)
  of NE: (position.row - 1, position.col + 1)
  of E: (position.row, position.col + 1)
  of SE: (position.row + 1, position.col + 1)
  of S: (position.row + 1, position.col)
  of SW: (position.row + 1, position.col - 1)
  of W: (position.row, position.col - 1)

func emptyPositions(grove: Grove): int =
  let rows = grove.bottomRight.row - grove.topLeft.row + 1
  let cols = grove.bottomRight.col - grove.topLeft.col + 1
  result = rows * cols - grove.positions.len

proc proposedDirections(): iterator(): array[4, Direction] =
  return iterator(): array[4, Direction] =
    while true:
      yield [N, S, W, E]
      yield [S, W, E, N]
      yield [W, E, N, S]
      yield [E, N, S, W]

# returns true if any positions were moved
proc turn(grove: var Grove, directionOrder: array[4, Direction]): bool =
  # proposed position -> positions proposing to move there
  var proposals = initTable[Position, seq[Position]]()
  for position in grove.positions:
    if Direction.noneIt(position.at(it) in grove.positions):
      continue
    for proposedDirection in directionOrder:
      if WITH_DIAGONALS[proposedDirection].noneIt(position.at(it) in grove.positions):
        proposals.mgetOrPut(position.at(proposedDirection), @[]).add position
        break

  for position, proposers in proposals:
    if proposers.len == 1:
      result = true
      grove.excl proposers[0]
      grove.incl position

proc readInput(filename: string): Grove =
  var positions = initHashSet[Position]()
  let 
    lines = filename.lines.toSeq
    maxRow = lines.len - 1
    maxCol = lines[0].len - 1

  for row, line in filename.lines.toSeq:
    for col, c in line:
      if c == '#':
        positions.incl (row, col)
  
  result = Grove(positions: positions, topLeft: (0, 0), bottomRight: (maxRow, maxCol))

when isMainModule:
  var grove = inputFilename(23).readInput

  let nextDirections = proposedDirections()
  var part1 = 0
  var part2 = 1
  while (let moved = grove.turn(nextDirections()); moved):
    if part2 == 10:
      part1 = grove.emptyPositions
    inc part2

  echo "Part 1 ", part1
  echo "Part 2 ", part2
