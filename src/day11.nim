include common

type 
  OperationKind = enum
    okAdd, okMultiply, okSquared
  
  Operation = object
    kind: OperationKind
    operand: int

  Monkey = object
    id: int
    items: seq[int]
    operation: Operation
    testNum: int
    onTrueMonkey: int
    onFalseMonkey: int

proc parseOperation(op: string): Operation =
  let 
    tokens = op.split(" ")
    kind = tokens[3]
    operand = tokens[4]
  result = case kind
    of "+": Operation(kind: okAdd, operand: operand.parseInt)
    of "*": 
      if operand == "old": Operation(kind: okSquared, operand: -1)
      else : Operation(kind: okMultiply, operand: operand.parseInt)
    else: quit "Invalid operation"

proc parseMonkey(lines: seq[string]): Monkey =
  result = Monkey()
  for line in lines.mapIt(it.strip):
    if line.startsWith "Monkey":
      # remove the trailing :
      result.id = line[7].int - '0'.int
    elif line.startsWith "Starting items":
      result.items = line.split(": ")[1].split(", ").map(parseInt)
    elif line.startsWith "Operation":
      result.operation = line.split(": ")[1].parseOperation
    elif line.startsWith "Test":
      result.testNum = line.split(" ")[3].parseInt
    elif line.startsWith "If true":
      result.onTrueMonkey = line.split(" ")[5].parseInt
    elif line.startsWith "If false":
      result.onFalseMonkey = line.split(" ")[5].parseInt
    else:
      quit "Invalid line: " & line

proc readMonkeys(filename: string): seq[Monkey] =
  for monkey in filename.readFile.split("\n\n"):
    result.add monkey.splitLines.parseMonkey

proc lcd(num: seq[int]): int =
  result = 1
  for i in 0 ..< num.len:
    result = result.lcm(num[i])
  return result

proc run(monkeys: seq[Monkey], numRounds: int, divFactor: int): int = 
  var monkeys = monkeys # copy the table
  var inspectCounts = initCountTable[int]()
  # we can safely mod by the lcd of all the test numbers
  # impacting any calculations
  let lcd = monkeys.mapIt(it.testNum).lcd

  for i in 1 .. numRounds:
    for j in 0 ..< monkeys.len:
      for item in monkeys[j].items:
        inspectCounts.inc monkeys[j].id
        var newItem = 
          case monkeys[j].operation.kind:
          of okAdd: item + monkeys[j].operation.operand
          of okMultiply: item * monkeys[j].operation.operand
          of okSquared: item * item
        
        newItem = newItem div divFactor
        newItem = newItem mod lcd
        
        if newItem mod monkeys[j].testNum == 0:
          monkeys[monkeys[j].onTrueMonkey].items.add newItem
        else:
          monkeys[monkeys[j].onFalseMonkey].items.add newItem

      monkeys[j].items = @[]

  let sortedCounts = inspectCounts.values.toSeq.sorted(Descending)
  return sortedCounts[0] * sortedCounts[1]

when isMainModule:
  let monkeys = readMonkeys inputFilename(11)
  
  let part1 = run(monkeys, 20, 3)
  let part2 = run(monkeys, 10000, 1)

  echo "Part 1 ", part1
  echo "Part 2 ", part2
