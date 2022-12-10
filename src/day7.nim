include common

type 
  Directory = ref object
    name: string
    parent: Directory
    files: Table[string, int]
    children: Table[string, Directory]
    
func readDirectoryStructure(lines: seq[string]): Directory =
  let root = Directory(name: "/")
  var curr = root

  for line in lines[1..^1]:
    if line == "$ cd ..":
      curr = curr.parent
    elif line.startsWith("$ cd"):
      let dirName = line.split(" ")[2]
      curr = curr.children[dirName]
    elif line == "$ ls":
      continue
    elif line.startsWith("dir"):
      let dirName = line.split(" ")[1]
      curr.children[dirName] = Directory(name: dirName, parent: curr)
    else:
      let fileName = line.split(" ")[1]
      let fileSize = line.split(" ")[0].parseInt
      curr.files[fileName] = fileSize

  return root

proc populateDirectorySizes(dir: Directory, acc: var seq[int]): int =
  var size = 0
  for (_, child) in dir.children.pairs:
    size += populateDirectorySizes(child, acc)
  for (_, fileSize) in dir.files.pairs:
    size += fileSize
  acc.add(size)
  return size

when isMainModule:
  let input = readDirectoryStructure inputFilename(7).lines.toSeq

  var sizes: seq[int]
  discard populateDirectorySizes(input, sizes)

  let part1 = sizes.filterIt(it <= 100_000).sum

  let spaceToDelete = sizes[^1] - 40_000_000
  let part2 = sizes.filterIt(it >= spaceToDelete).min

  echo "Part 1 ", part1
  echo "Part 2 ", part2
