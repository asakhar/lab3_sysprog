#!/bin/env python3

import subprocess

seedmin = 456
seedmax = 460
lenmin = 5000
lenmax = 5002
seq = 1
for seed in range(seedmin, seedmax):
  for length in range(lenmin, lenmax):
    res = None
    for _ in range(seq):
      f = subprocess.run(
          ["build/main", f"{length}", f"{seed}"], capture_output=True)
      line1, line2 = f.stdout.decode('UTF-8').split('\n')[:2]
      assert line1 == line2[::-1], "Lines are not inverse of each other"
      if res is None:
        res = line1
        i = 1
        j = 0
        while i < len(line1):
          pj = j
          pi = i
          while j < len(line1) and i < len(line1):
            if line1[j] != line1[i]:
              j = pj
              i = pi
              break
            i += 1
            j += 1
          if (i == len(line1) or j == len(line1)) and i-pi > length//4:
            print(f"random seq len cycle length = {i-pi}")
          i += 1
        continue
      assert res == line1, "Lines with same length and same seed should be equal"

print(
    f"Checked {seedmax-seedmin} seeds, {lenmax-lenmin} lengths, each {seq} times")
