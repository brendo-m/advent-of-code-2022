include common
import strscans

type 
  BinaryOp = enum
    boAdd, boSub, boMul, boDiv

  NodeKind = enum 
    nkNumber, nkBinary, nkHuman

  Node = ref object
    case kind: NodeKind
    of nkNumber:
      val: int
    of nkBinary:
      left, right: string
      op: BinaryOp
    of nkHuman:
      discard

proc `$`(n: Node): string =
  case n.kind
  of nkNumber: $n.val
  of nkBinary: "(" & $n.left & " " & $n.op & " " & $n.right & ")"
  of nkHuman: "Human"

proc parseBinaryOp(c: char): BinaryOp =
  case c
  of '+': boAdd
  of '-': boSub
  of '*': boMul
  of '/': boDiv
  else: quit "unknown op " & c

proc parseInput(filename: string): Table[string, Node] =
  result = initTable[string, Node]()
  for line in filename.lines:
    if (let (ok, name, val) = line.scanTuple("$w: $i"); ok):
      result[name] = Node(kind: nkNumber, val: val)
    elif (let (ok, name, left, op, right) = line.scanTuple("$w: $w $c $w"); ok):
      result[name] = Node(kind: nkBinary, left: left, right: right, op: op.parseBinaryOp)
    else:
      quit "unable to parse line " & line

proc eval(start: string, input: Table[string, Node]): int =
  proc eval(name: string): int =
    let node = input[name]
    case node.kind
    of nkHuman: discard # impossible
    of nkNumber: result = node.val
    of nkBinary:
      let left = eval(node.left)
      let right = eval(node.right)
      case node.op:
      of boAdd: result = left + right
      of boSub: result = left - right
      of boMul: result = left * right
      of boDiv: result = left div right
  
  result = eval(start)

proc part1(input: Table[string, Node]): int =
  eval("root", input)

proc part2(input: Table[string, Node]): int =
  var input = input
  input["humn"] = Node(kind: nkHuman)

  # solve and update table in place
  proc evalInPlace(name: string) =
    let node = input[name]
    case node.kind
    of nkBinary:
      evalInPlace(node.left)
      evalInPlace(node.right)
      let left = input[node.left]
      let right = input[node.right]
      if left.kind == nkNumber and right.kind == nkNumber:
        case node.op:
        of boAdd: input[name] = Node(kind: nkNumber, val: left.val + right.val)
        of boSub: input[name] = Node(kind: nkNumber, val: left.val - right.val)
        of boMul: input[name] = Node(kind: nkNumber, val: left.val * right.val)
        of boDiv: input[name] = Node(kind: nkNumber, val: left.val div right.val)
    else: discard
  
  evalInPlace("root")

  proc solve(name: string, acc: int): int =
    let left = input[input[name].left]
    let right = input[input[name].right]

    if left.kind == nkHuman and right.kind == nkNumber:
      case input[name].op:
      of boAdd: result = acc - right.val
      of boSub: result = acc + right.val
      of boMul: result = acc div right.val
      of boDiv: result = acc * right.val
    elif left.kind == nkNumber and right.kind == nkHuman:
      case input[name].op:
      of boAdd: result = acc - left.val
      of boSub: result = left.val - acc
      of boMul: result = acc div left.val
      of boDiv: result = left.val div acc

    # one of them is a binary and the other is a number
    elif left.kind == nkBinary and right.kind == nkNumber:
      case input[name].op:
      of boAdd: result = solve(input[name].left, acc - right.val)
      of boSub: result = solve(input[name].left, acc + right.val)
      of boMul: result = solve(input[name].left, acc div right.val)
      of boDiv: result = solve(input[name].left, acc * right.val)
    elif left.kind == nkNumber and right.kind == nkBinary:
      case input[name].op:
      of boAdd: result = solve(input[name].right, acc - left.val)
      of boSub: result = solve(input[name].right, left.val - acc)
      of boMul: result = solve(input[name].right, acc div left.val)
      of boDiv: result = solve(input[name].right, left.val div acc)
    else:
      # impossible
      discard

  let left = input[input["root"].left]
  let right = input[input["root"].right]
  let (toSolve, target) = 
    if left.kind == nkNumber: (input["root"].right, left.val) 
    else: (input["root"].left, right.val)

  result = solve(toSolve, target)

when isMainModule:
  let input = inputFilename(21).parseInput

  echo "Part 1: ", part1(input)
  echo "Part 2: ", part2(input)
