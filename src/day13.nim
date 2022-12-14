include common

type 
  PacketKind = enum 
    pkEntry, pkList

  Packet = ref object
    case kind: PacketKind
    of pkEntry:
      val: int
    of pkList:
      entries: seq[Packet]

func `$`(p: Packet): string =
  case p.kind:
    of pkEntry:
      return $p.val
    of pkList:
      return "[" & p.entries.mapIt($it).join(",") & "]"

func parsePacket(s: string): Packet =
  var stack = newStack[Packet]()

  var i = 0
  while i < s.len:
    case s[i]:
      of '[':
        stack.push Packet(kind: pkList, entries: @[])
        inc i # consume the '['
      of '0'..'9':
        let start = i
        while s[i] != ',' and s[i] != ']':
          inc i
        let val = s[start..i-1].parseInt
        stack.peekm.entries.add Packet(kind: pkEntry, val: val)
      of ']':
        let x = stack.pop
        if stack.len > 0:
          stack.peekm.entries.add x
          inc i # consume the ']'
        else:
          return x
      else:
        inc i

proc readPackets(filename: string): seq[Packet] =
  for line in filename.lines:
    if line.len > 0:
      result.add line.parsePacket

func compare(left, right: Packet): int =
  if (left.kind == pkEntry and right.kind == pkEntry):
    return left.val - right.val
  elif (left.kind == pkList and right.kind == pkList):
    for i in 0 ..< min(left.entries.len, right.entries.len):
      let x = compare(left.entries[i], right.entries[i])
      if x != 0:
        return x
    return left.entries.len - right.entries.len
  elif (left.kind == pkEntry and right.kind == pkList):
    let leftList = Packet(kind: pkList, entries: @[left])
    return compare(leftList, right)
  elif (left.kind == pkList and right.kind == pkEntry):
    let rightList = Packet(kind: pkList, entries: @[right])
    return compare(left, rightList)

func part1(packets: seq[Packet]): int =
  let pairs = packets.grouped(2)
  for i in 0 ..< pairs.len:
    if compare(pairs[i][0], pairs[i][1]) < 0:
      inc result, i + 1

func part2(packets: seq[Packet]): int =
  let divider2 = Packet(kind: pkList, entries: @[Packet(kind: pkEntry, val: 2)])
  let divider6 = Packet(kind: pkList, entries: @[Packet(kind: pkEntry, val: 6)])

  var packetList = packets # take a copy
  packetList.add divider2
  packetList.add divider6
  packetList.sort(compare)

  result = 1
  for i in 1 .. packetList.len:
    # equality works because Packet is a ref
    if packetList[i-1] == divider2 or packetList[i-1] == divider6:
      result *= i

when isMainModule:
  let packets = inputFileName(13).readPackets

  echo "Part 1 ", part1(packets)
  echo "Part 2 ", part2(packets)
