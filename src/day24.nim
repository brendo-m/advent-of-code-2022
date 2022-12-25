include common
import std/[enumerate, deques]

type 
  Position = tuple[row, col: int]

  Direction = enum
    North, East, South, West

  Gust = object
    position: Position
    direction: Direction
  
  # 2D array of number of obstacles
  Valley = seq[seq[int]]

const DELTAS = [
  (0, 0), # stay put
  (0, -1),
  (1, 0),
  (0, 1),
  (-1, 0),
]

proc `$`(gust: Gust): string =
  case gust.direction
  of North: result = "^"
  of East: result = ">"
  of South: result = "v"
  of West: result = "<"

proc showValley(valley: Valley, gusts: seq[Gust]) =
  var grid = valley.mapIt(it.mapIt(if it > 0: "#" else: "."))
  for gust in gusts:
    let (row, col) = gust.position
    let num = valley[row][col]
    if num == 1:
      grid[row][col] = $gust
    else:
      grid[row][col] = fmt"{num}"
  echo grid.mapIt(it.join).join("\n")

proc readInput(filename: string): (Valley, seq[Gust]) =
  let lines = filename.lines.toSeq
  var valley = 0.repeat(lines[0].len).repeat(lines.len)
  var gusts = newSeq[Gust]()
  for row, line in enumerate(filename.lines):
    for col, c in enumerate(line):
      if c == '<':
        valley[row][col] = 1
        gusts.add Gust(position: (row, col), direction: West)
      elif c == '>':
        valley[row][col] = 1
        gusts.add Gust(position: (row, col), direction: East)
      elif c == '^':
        valley[row][col] = 1
        gusts.add Gust(position: (row, col), direction: North)
      elif c == 'v':
        valley[row][col] = 1
        gusts.add Gust(position: (row, col), direction: South)
      elif c == '#':
        valley[row][col] = 1
  result = (valley, gusts)

proc turn(valley: var Valley, gusts: var seq[Gust]) =
  for gust in gusts.mitems:
    var (row, col) = gust.position

    # remove from old position
    let currValue = valley[row][col]
    valley[row][col] = max(0, currValue - 1)

    # update gust
    case gust.direction:
    of North: 
      if row == 1: row = valley.len - 2 else: row -= 1
    of South: 
      if row == valley.len - 2: row = 1 else: row += 1
    of East:
      if col == valley[0].len - 2: col = 1 else: col += 1
    of West:
      if col == 1: col = valley[0].len - 2 else: col -= 1
    gust.position = (row, col)
    
    # add to new position
    valley[row][col] += 1

proc search(valley: var Valley, gusts: var seq[Gust], start: Position, finish: Position): int =
  var queue = initDeque[(Position, int)]()
  var visited = initHashSet[(Position, int)]()
  queue.addLast (start, 0)

  # turn(valley, gusts)

  while queue.len > 0:
    let length = queue.len
    # queue.echo
    for _ in 0 ..< length:
      let (pos, time) = queue.popFirst()
      if pos == finish:
        return time

      for (drow, dcol) in DELTAS:
        let n: Position = (pos.row + drow, pos.col + dcol)
        if n.row < 0 or n.row >= valley.len: continue
        if n.col < 0 or n.col >= valley[0].len: continue
        if (n, time + 1) in visited: continue
        if valley[n.row][n.col] == 0:
          queue.addLast (n, time + 1)
          visited.incl (n, time + 1)

    turn(valley, gusts)

when isMainModule:
  var (valley, gusts) = inputFilename(24).readInput

  let start = (0, 1)
  let finish = (valley.len - 1, valley[0].len - 2)

  turn(valley, gusts)
  let part1 = search(valley, gusts, start, finish)
  var part2 = part1
  inc part2, search(valley, gusts, finish, start)
  inc part2, search(valley, gusts, start, finish)

  echo "Part 1 ", part1
  echo "Part 2 ", part2
