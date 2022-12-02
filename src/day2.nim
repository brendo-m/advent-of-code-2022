include common
import sugar

type 
  Move = enum
    ROCK, PAPER, SCISSORS

proc parseGamePart1(str: (string, string)): (Move, Move) =
  let parse = proc (s: string): Move =
    case s:
      of "A": return ROCK
      of "X": return ROCK
      of "B": return PAPER
      of "Y": return PAPER
      of "C": return SCISSORS
      of "Z": return SCISSORS

  return (parse(str[0]), parse(str[1]))

proc parseGamePart2(str: (string, string)): (Move, Move) =
  let parse = proc (s: string): Move =
    case s:
      of "A": return ROCK
      of "B": return PAPER
      of "C": return SCISSORS

  let a = parse(str[0])

  var b: Move
  case str[1]:
    # loss
    of "X": 
      case a:
        of ROCK: b = SCISSORS
        of PAPER: b = ROCK
        of SCISSORS: b = PAPER
    # draw
    of "Y": b = a
    # loss
    of "Z":
      case a:
        of ROCK: b = PAPER
        of PAPER: b = SCISSORS
        of SCISSORS: b = ROCK
    
  return (a, b)

proc score(game: (Move, Move)): int =
  let (a, b) = game

  if (a == b):
    result += 3
  elif (a == ROCK and b == PAPER) or (a == PAPER and b == SCISSORS) or (a == SCISSORS and b == ROCK):
    result += 6
  
  case b:
    of ROCK: result += 1
    of PAPER: result += 2
    of SCISSORS: result += 3

proc readInput(filename: string): seq[(string, string)] =
  return collect(newSeq):
    for line in filename.lines:
      let spl = line.split(" ")
      (spl[0], spl[1])

when isMainModule:
  let games = readInput inputFilename(2)
  
  let part1 = games.map(parseGamePart1).map(score).sum
  let part2 = games.map(parseGamePart2).map(score).sum

  echo fmt"Part 1 {part1}"
  echo fmt"Part 2 {part2}"
  