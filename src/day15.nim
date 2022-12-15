include common
import std/strscans

type 
  Point = tuple[x, y: int]
  Interval = tuple[left, right: Point]
  Pair = tuple[sensor, beacon: Point]

proc readPairs(filename: string): seq[Pair] =
  for line in filename.lines:
    var sx, sy, bx, by: int
    if scanf(line, "Sensor at x=$i, y=$i: closest beacon is at x=$i, y=$i", sx, sy, bx, by):
      result.add ((sx, sy), (bx, by))
    else:
      quit "Error parsing line: " & line

func mergeOverlappingIntervals(intervals: seq[Interval]): seq[Interval] =
  # sort by start of interval
  let intervals = intervals.sortedByIt(it.left.x)

  var stack = newStack[Interval]()
  stack.push(intervals[0])
  
  for i in 1 ..< intervals.len:
    let interval = intervals[i]
    let top = stack.peek()

    # interal doesn't overlap with top, push it
    if top.right.x < interval.left.x - 1:
      stack.push(interval)
    
    # interval overlaps and extends further than top so 
    # update top
    elif top.right.x < interval.right.x:
      discard stack.pop()
      stack.push((top.left, interval.right))

  return stack

func manhattanDistance(a, b: Point): int =
  abs(a.x - b.x) + abs(a.y - b.y)

# compute the intervals on line y that are covered by the sensors
# there will be overlaps so merge them together
func intervalsForLine(pairs: seq[Pair], y: int): seq[Interval] =
  pairs
    .map(proc (pair: Pair): Interval =
      let d = manhattanDistance(pair.sensor, pair.beacon)
      let q = d - abs(pair.sensor.y - y)
      let minX = pair.sensor.x - q
      let maxX = pair.sensor.x + q
      
      ((minX, y), (maxX, y))
    )
    .filterIt(it.left.x <= it.right.x) # covered area doesn't reach this line
    .mergeOverlappingIntervals

proc part1(pairs: seq[Pair], y: int): int =
  # beacons that are on this line
  let beacons: HashSet[Point] = collect(initHashSet):
    for pair in pairs:
      if pair.beacon.y == y: {pair.beacon}

  let intervals = intervalsForLine(pairs, y)

  for (left, right) in intervals:
    inc result, right.x - left.x + 1
  
  result -= beacons.len

proc part2(pairs: seq[Pair], maxY: int): int =
  for y in 0 ..< maxY:
    let intervals = intervalsForLine(pairs, y)

    # there should be exactly 1 line with 2 intervals
    if intervals.len == 2:
      let missingX = intervals[0].right.x + 1
      return missingX * 4000000 + y

  return -1

when isMainModule:
  let input = inputFilename(15)
  let pairs = input.readPairs

  echo "Part 1 ", part1(pairs, if input.contains "sample": 10 else: 2000000)
  echo "Part 2 ", part2(pairs, if input.contains "sample": 20 else: 4000000)
