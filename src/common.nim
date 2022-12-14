import algorithm, math, parseOpt, sequtils, sets,
       strformat, strutils, sugar, tables

# Get the input filename for the given day, sample file if run with -s
proc inputFilename*(day: int): string =
  result = fmt"inputs/day{day}"
  for _, key, _ in getopt():
    if key == "s":
      result.add "_sample"
  result.add ".txt"

# Read filename as a seq of numbers
proc readNumbers*(filename: string): seq[int] =
  for line in filename.lines:
    let cleaned = line.strip
    if cleaned.len > 0:
      result.add cleaned.parseInt

# Group a seq into chunks of size n. The last chunk may be smaller
func grouped*[T](xs: seq[T], n: int): seq[seq[T]] =
  var group: seq[T] = @[]
  for x in xs:
    group.add(x)
    if group.len == n:
      result.add group
      group = @[]
  if group.len > 0:
    result.add group

# Very basic stack implementation
type Stack*[T] = seq[T]

func newStack*[T](): Stack[T] = newSeq[T]()
proc push*[T](stack: var Stack[T], value: T) = stack.add(value)
proc pop*[T](stack: var Stack[T]): T =
  result = stack[^1]
  stack.setLen(stack.len - 1)
func peek*[T](stack: Stack[T]): T = result = stack[^1]
func peekm*[T](stack: var Stack[T]): var T = result = stack[^1]
func isEmpty*(stack: Stack): bool = result = stack.len == 0
