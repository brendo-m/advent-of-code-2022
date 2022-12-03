include common

func score(c: char): int = 
  if ord(c) >= ord('a') and ord(c) <= ord('z'):
    ord(c) - ord('a') + 1
  else:
    ord(c) - ord('A') + 27  

func repeatedChar(chars: seq[char]): char =
  let mid = len(chars) div 2
  let firstHalfSet = toHashSet(chars[0 .. mid-1])
  for c in chars[mid .. len(chars)-1]:
    if c in firstHalfSet:
      return c

func commonChar(input: seq[seq[char]]): char =
  input.mapIt(toHashSet(it)).foldl(a.intersection(b)).toSeq[0]

func part1(input: seq[seq[char]]): int =
  input.mapIt(repeatedChar(it)).mapIt(score(it)).sum

func part2(input: seq[seq[char]]): int =
  input.chunk(3).map(commonChar).mapIt(score(it)).sum

when isMainModule:
  let input: seq[seq[char]] = 
    inputFilename(3).lines.toSeq.mapIt(it.toSeq) 

  echo fmt"Part 1 {part1(input)}"
  echo fmt"Part 2 {part2(input)}"
