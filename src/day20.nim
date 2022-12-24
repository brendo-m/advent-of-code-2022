include common
import std/[enumerate, lists]

# just print the value
proc `$`[T](node: DoublyLinkedNode[T]): string =
  result = $node.value

proc readInput(filename: string): (DoublyLinkedRing[int], seq[DoublyLinkedNode[int]]) =
  var ring = initDoublyLinkedRing[int]()
  var nodes = newSeq[DoublyLinkedNode[int]]()

  for idx, line in enumerate(inputFilename(20).lines):
    let node = newDoublyLinkedNode(parseInt(line))
    ring.add node
    nodes.add node

  result = (ring, nodes)

func negativeMod(a, b: int): int =
  let r = a mod b
  if r < 0: r + b
  else: r

proc advance(node: var DoublyLinkedNode[int], count: int) =
  for _ in 0..<count:
    node = node.next

proc mix(ring: var DoublyLinkedRing[int], nodeOrder: seq[DoublyLinkedNode[int]]) =
  for node in nodeOrder.items:
    var prev = node.prev
    ring.remove node

    prev.advance negativeMod(node.value, nodeOrder.len - 1)

    prev.next.prev = node
    node.prev = prev
    node.next = prev.next
    prev.next = node

proc part1(ring: DoublyLinkedRing[int], nodeOrder: seq[DoublyLinkedNode[int]]): int =
  var ring = ring # mutable copy

  mix(ring, nodeOrder)

  let zero = ring.find(0)
  var node = zero
  for _ in 1..3:
    node.advance (1000 mod nodeOrder.len)
    inc result, node.value

# could be cleaned up but seriously f this question
proc part2(ring: DoublyLinkedRing[int], nodeOrder: seq[DoublyLinkedNode[int]]): int =
  var newRing = initDoublyLinkedRing[int]()
  var newNodeOrder = newSeq[DoublyLinkedNode[int]]()
  for node in ring.nodes:
    let newNode = newDoublyLinkedNode(node.value * 811589153)
    newRing.add newNode
    newNodeOrder.add newNode

  for _ in 1 .. 10:
    mix(newRing, newNodeOrder)

  let zero = newRing.find(0)
  var node = zero
  for _ in 1..3:
    node.advance (1000 mod nodeOrder.len)
    inc result, node.value


when isMainModule:
  let (ring, nodes) = readInput(inputFilename(20))
  echo "Part 1 ", part1(ring, nodes)

  # read new input, previous gets mutated ¯\_(ツ)_/¯
  let (ring2, nodes2) = readInput(inputFilename(20))
  echo "Part 2 ", part2(ring2, nodes2)
