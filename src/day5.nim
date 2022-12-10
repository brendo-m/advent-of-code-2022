include common

type
  Instruction = tuple[amount: int, frm: int, to: int]

proc readInput(filename: string): (seq[Stack[char]], seq[Instruction]) =
  let lines = filename.lines.toSeq
  let middle = lines.find("")

  let numStacks = lines[middle - 1].splitWhitespace()[^1].parseInt

  var stacklines = lines[0 .. middle - 2]
  stacklines.reverse

  # initialize stacks
  var stacks: seq[Stack[char]] = @[]
  for i in 0 .. numStacks-1:
    stacks.add(newStack[char]())

  # populate stacks
  for line in stacklines:
    let chunks = line.toSeq
      .grouped(4)
      .mapIt(it.filterIt(ord('A') <= ord(it) and ord(it) <= ord('Z')))

    for idx, chunk in chunks:
      if chunk.len > 0:
        stacks[idx].push(chunk[0])

  let instructions = lines[middle + 1 .. ^1]
    .mapIt(it.splitWhitespace)
    .mapIt((amount: it[1].parseInt, frm: it[3].parseInt, to: it[5].parseInt))

  return (stacks, instructions)

proc part1(stacks: seq[Stack[char]], instructions: seq[Instruction]): string =
  var mutStacks = stacks
  for inst in instructions:
    for _ in 1 .. inst.amount:
      mutStacks[inst.to-1].push(mutStacks[inst.frm-1].pop())

  return mutStacks.mapIt(if it.isEmpty: ' ' else: it.peek()).join("")

proc part2(stacks: seq[Stack[char]], instructions: seq[Instruction]): string =
  var mutStacks = stacks
  for inst in instructions:
    var tmpStack = newStack[char]()
    for _ in 1 .. inst.amount:
      tmpStack.push(mutStacks[inst.frm-1].pop())
    for _ in 1 .. inst.amount:
      mutStacks[inst.to-1].push(tmpStack.pop())

  return mutStacks.mapIt(if it.isEmpty: ' ' else: it.peek()).join("")

when isMainModule:
  let (stacks, instructions) = readInput inputFilename(5)

  echo "Part 1 ", part1(stacks, instructions)
  echo "Part 2 ", part2(stacks, instructions)
