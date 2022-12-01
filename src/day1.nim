import common
import std/strformat
import strutils
import sugar
import algorithm
import math

proc readInput(filename: string): seq[int] =
  var curr: seq[int] = @[]
  var all: seq[seq[int]] = @[]
  for line in filename.lines:
    if line == "":
      all.add curr
      curr = @[]
    else:
      curr.add line.parseInt
  all.add curr

  result = collect(newSeq):
    for nums in all:
      sum(nums)
  result.sort(system.cmp[int], Descending)


when isMainModule:
  let calories = readInput inputFilename(1)

  let part1 = calories[0]
  let part2 = calories[0] + calories[1] + calories[2]

  echo fmt"Part 1 {part1}"
  echo fmt"Part 2 {part2}"
