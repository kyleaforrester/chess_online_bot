#!/usr/bin/env python3

import math

values = [188, 248, 753, 832, 826, 897, 1285, 1371, 2513, 2650, 15258, 3915]

#values = [math.floor(v * (1/100)) for v in values]

print('''
  PawnValueMg   = {0},   PawnValueEg   = {1},
  KnightValueMg = {2},   KnightValueEg = {3},
  BishopValueMg = {4},   BishopValueEg = {5},
  RookValueMg   = {6},  RookValueEg   = {7},
  QueenValueMg  = {8},  QueenValueEg  = {9},

  MidgameLimit  = {10}, EndgameLimit  = {11}'''.format(values[0], values[1], values[2], values[3], values[4], values[5], values[6], values[7], values[8], values[9], values[10], values[11]))
