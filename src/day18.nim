include common
import deques

type Cube = tuple[x: int, y: int, z: int]

func neighbors(cube: Cube): seq[Cube] =
  return @[
    (cube.x + 1, cube.y, cube.z),
    (cube.x - 1, cube.y, cube.z),
    (cube.x, cube.y + 1, cube.z),
    (cube.x, cube.y - 1, cube.z),
    (cube.x, cube.y, cube.z + 1),
    (cube.x, cube.y, cube.z - 1)
  ]

func part1(lava: seq[Cube]): int =
  var seen = initHashSet[Cube]()

  for cube in lava:
    result += 6
    seen.incl cube

    for n in cube.neighbors:
      if n in seen:
        result -= 2

func part2(lava: seq[Cube]): int =
  # find the bounds of a cube surrounding the lava
  var minX, minY, minZ = int.high
  var maxX, maxY, maxZ = int.low

  for x, y, z in lava.items:
    minX = min(minX, x)
    minY = min(minY, y)
    minZ = min(minZ, z)
    maxX = max(maxX, x)
    maxY = max(maxY, y)
    maxZ = max(maxZ, z)

  let xRange = minX-1 .. maxX+1
  let yRange = minY-1 .. maxY+1
  let zRange = minZ-1 .. maxZ+1

  # BFS from a known water cube to find all water cubes
  var water = initHashSet[Cube]()
  var queue = toDeque[Cube]([(minX-1, minY-1, minZ-1)])
  while queue.len > 0:
    let cube = queue.popFirst()

    if not (cube.x in xRange and cube.y in yRange and cube.z in zRange):
      continue

    # seen already
    if cube in water:
      continue

    water.incl cube

    for neighbor in cube.neighbors:
      if neighbor notin lava:
        queue.addLast neighbor

  # get all cubes that are not water
  let lavaOrAir = collect(newSeq):
    for x in xRange:
      for y in yRange:
        for z in zRange:
          if (x, y, z) notin water:
            (x, y, z)

  # count number of water cubes touching lava to get surface area
  for cube in lavaOrAir:
    for n in cube.neighbors:
      if n notin lavaOrAir:
        inc result

when isMainModule:
  let cubes = collect(newSeq):
    for line in inputFilename(18).lines:
      let parts = line.split(',')
      (parts[0].parseInt, parts[1].parseInt, parts[2].parseInt)

  echo "Part 1 ", part1(cubes)
  echo "Part 2 ", part2(cubes)
