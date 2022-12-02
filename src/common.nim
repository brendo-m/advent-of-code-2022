import algorithm
import math
import sequtils
import std/parseopt
import std/strformat
import strutils

# Get the input filename for the given day, sample file if run with -s
proc inputFilename*(day: int): string =
  result = fmt"inputs/day{day}"
  for _, key, _  in getopt():
    if key == "s":
      result.add "_sample"
  result.add ".txt"

# Read filename as a seq of numbers
proc readNumbers*(filename: string): seq[int] =
  for line in filename.lines:
    let cleaned = line.strip
    if cleaned.len > 0:
      result.add cleaned.parseInt