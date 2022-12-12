include common
import deques

type Point = tuple[x, y: int]

proc readInput(filename: string): (seq[seq[char]], Point, Point) =
  let heights = inputFilename(12).readFile.splitLines.mapIt(it.toSeq)
  var S, E: Point
  for i in 0 ..< heights.len:
    for j in 0 ..< heights[0].len:
      if heights[i][j] == 'S':
        S = (i, j)
      elif heights[i][j] == 'E':
        E = (i, j)
  return (heights, S, E)

proc height(c: char): int =
  if c == 'S': ord('a')
  elif c == 'E': ord('z')
  else: ord(c)

proc findShortestPath(heights: seq[seq[char]], S: Point, E: Point): int =
  let deltas = [(-1, 0), (1, 0), (0, -1), (0, 1)]

  var
    queue = toDeque([S])
    steps = -1.repeat(heights[0].len).repeat(heights.len)
  
  steps[S.x][S.y] = 0
  queue.addLast(S)

  while queue.len > 0:
    let (x, y) = queue.popFirst()

    for (dx, dy) in deltas:
      let (nx, ny) = (x + dx, y + dy)
      if nx < 0 or nx >= heights.len or ny < 0 or ny >= heights[0].len:
        continue

      if steps[nx][ny] != -1:
        continue

      if heights[nx][ny].height > heights[x][y].height + 1:
        continue

      steps[nx][ny] = steps[x][y] + 1
      queue.addLast((nx, ny))

  return steps[E.x][E.y]

proc part1(heights: seq[seq[char]], S: Point, E: Point): int =
  findShortestPath(heights, S, E)

proc part2(heights: seq[seq[char]], E: Point): int =
  result = high int
  for i in 0 ..< heights.len:
    for j in 0 ..< heights[0].len:
      if heights[i][j].height == ord('a'):
        let path = findShortestPath(heights, (i, j), E)
        if path != -1:
          result = min(result, path)

when isMainModule:
  let (heights, S, E) = readInput inputFilename(12)

  echo "Part 1 ", part1(heights, S, E)
  echo "Part 2 ", part2(heights, E)
