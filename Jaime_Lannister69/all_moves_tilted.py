#!/usr/bin/env python3

import chess
import chess.uci
import sys
import random

if (len(sys.argv) != 2):
    print('Usage: ./python-chess.py "FEN"', file=sys.stderr)
    print('Usage: ./python-chess.py "FEN"')
    sys.exit(1)

board = chess.Board(sys.argv[1])
moves = []
variance = 160 #155
depth = 12
for move in board.legal_moves:
    handler = chess.uci.InfoHandler()
    engine = chess.uci.popen_engine('/usr/games/stockfish')
    engine.info_handlers.append(handler)
    engine.position(board)
    engine.go(searchmoves=[move], depth=depth)
    centipawns = handler.info['score'][1].cp
    mate = handler.info['score'][1].mate
    if (centipawns is None and mate is not None):
        if (mate >= 0):
            score = (20-mate)*10000
        else:
            score = (-20-mate)*10000
        moves.append((move, score, random.randint(-variance,variance)))
    else:
        moves.append((move, centipawns, random.randint(-variance,variance)))
    engine.quit()
moves = sorted(moves, key=lambda x: x[1],reverse=True)
maximum = max(moves, key=lambda x: x[1]+x[2])

for m in moves[0:6]:
    print('({},{},{}): {}'.format(board.san(m[0]),m[1],m[2], m[1]+m[2]))
print('bestmove {}'.format(maximum[0]))
