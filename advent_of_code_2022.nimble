version       = "0.1.0"
author        = "Brendan McKee"
description   = "Advent of Code in nim"
license       = "MIT"
srcDir        = "src"
binDir        = "bin"
installExt    = @["nim"]
bin           = @[]

for file in listFiles(srcDir):
  if "day" in file:
    bin.add(file[4..^5])

# Dependencies

requires "nim >= 1.6.10"
