include common

# seems like this should be in the std lib ¯\_(ツ)_/¯
proc dec(t: var CountTableRef[char], key: char) =
  let val = t[key]
  if val == 1:
    t.del key
  else:
    t[key] = val - 1

proc findDistinctWindow(s: string, n: int): int =
  var windowCounts = newCountTable[char](s[0 .. n-1])
  
  if windowCounts.len == n:
    return n

  for idx, c in s[n .. ^1]:
    windowCounts.inc c
    windowCounts.dec s[idx]
    if windowCounts.len == n:
      return idx + n + 1

  return 0

when isMainModule:
  let input = readFile inputFilename(6)

  echo fmt"Part 1 {findDistinctWindow(input, 4)}"
  echo fmt"Part 2 {findDistinctWindow(input, 14)}"
