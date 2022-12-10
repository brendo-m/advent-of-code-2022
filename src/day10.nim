include common

type 
  InstructionKind = enum
    ikAdd, ikNoop
 
  Instruction = ref object
    case kind: InstructionKind
    of ikAdd: x: int
    of ikNoop: discard

func parseInstruction(s: string): Instruction =
  let parts = s.split(" ")
  case parts[0]
  of "addx":
    result = Instruction(kind: ikAdd, x: parseInt(parts[1]))
  of "noop":
    result = Instruction(kind: ikNoop)

proc part1(instructions: seq[Instruction]): int =
  var part1 = 0
  var register = 1
  var cycle = 0
  var recordCycle = 20

  proc runCycle() =
    inc cycle
    if cycle == recordCycle:
      inc part1, recordCycle * register
      inc recordCycle, 40

  for instruction in instructions:
    case instruction.kind
    of ikAdd:
      runCycle()
      runCycle()
      inc register, instruction.x
    of ikNoop: 
      runCycle()

  echo "Part 1 ", part1

proc part2(instructions: seq[Instruction]): int =
  var pixels: array[240, bool]

  var spritePosition = 1
  var cycle = 0
  var row = 0

  proc cycleAndPaint() =
    if abs(cycle - spritePosition) < 2:
      pixels[row*40 + cycle] = true
    inc cycle
    if cycle mod 40 == 0:
      inc row
      cycle = 0

  for instruction in instructions:
    case instruction.kind
    of ikAdd:
      cycleAndPaint()
      cycleAndPaint()
      inc spritePosition, instruction.x
    of ikNoop: 
      cycleAndPaint()

  echo "Part 2"
  for i in 0 ..< 6:
    echo pixels[i*40 ..< (i+1)*40].mapIt(if it: '#' else: '.').join(" ")

when isMainModule:
  let instructions = inputFilename(10).lines.toSeq.map(parseInstruction)

  discard part1(instructions) 
  discard part2(instructions)
