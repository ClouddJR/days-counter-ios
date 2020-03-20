import re
import sys

if len(sys.argv) != 3:
  print("Pierwszy argument- nazwa pliku wejściowego, drugi- pliku wyjściowego")
else:
  f = open(sys.argv[1], "r")
  w = open(sys.argv[2], "a")
  for line in f:
    elements = re.findall('"[^"]+"', line)
    if len(elements) > 0:
        w.write(elements[0] + ' = ' + elements[0] + ';\n')
    else:
        w.write(line)