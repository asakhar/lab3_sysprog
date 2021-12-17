#!/bin/env python3

import subprocess

seedmin = 10
seedmax = 20
lenmin = 1
lenmax = 50
seq = 5
for seed in range(seedmin,seedmax):
  for length in range(lenmin,lenmax):
    res = None
    for _ in range(seq):
      f = subprocess.run(["build/main", f"{length}", f"{seed}"], capture_output=True)
      line1, line2 = f.stdout.decode('UTF-8').split('\n')[:2]
      assert(line1 == line2[::-1]) # "Lines are not inverse of each other"
      if res is None:
        res = line1
        continue
      assert(res == line1) # "Lines with same length and same seed should be equal"

print(f"Checked {seedmax-seedmin} seeds, {lenmax-lenmin} lengths, each {seq} times")