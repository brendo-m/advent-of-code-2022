include common

type
  Dir = enum
    Up, Down, Left, Right

  Instruction = object
    dir: Dir
    steps: int

  Point = object
    x, y: int

proc parseDir(c: char): Dir = 
  case c
    of 'U': Dir.Up
    of 'D': Dir.Down
    of 'L': Dir.Left
    of 'R': Dir.Right
    else: quit "Invalid direction: " & c

proc parseInstruction(s: string): Instruction =
  let dir = parseDir(s[0])
  let steps = s[2..^1].parseInt
  Instruction(dir: dir, steps: steps)

func run(instructions: seq[Instruction], numKnots: int): int =
  var pointers = Point(x:0, y:0).repeat(numKnots)
  var tailVisited = initHashSet[Point]() 

  for instr in instructions:
    for _ in 0 ..< instr.steps:
      case instr.dir
        of Dir.Up: inc pointers[0].y
        of Dir.Down: dec pointers[0].y
        of Dir.Right: inc pointers[0].x
        of Dir.Left: dec pointers[0].x

      for i in 1 ..< numKnots:
        let dx = pointers[i-1].x - pointers[i].x
        let dy = pointers[i-1].y - pointers[i].y

        if abs(dx) > 1 or abs(dy) > 1:
          if dx != 0: inc pointers[i].x, dx div abs(dx)
          if dy != 0: inc pointers[i].y, dy div abs(dy)

      tailVisited.incl pointers[^1]

  return tailVisited.len

when isMainModule:
  let instructions = inputFilename(9).lines.toSeq.map(parseInstruction)

  let part1 = run(instructions, 2)
  let part2 = run(instructions, 10)

  echo "Part 1 ", part1
  echo "Part 2 ", part2
