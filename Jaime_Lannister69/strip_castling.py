import sys

if (len(sys.argv) != 2):
    print('Usage: python3 my_script.py "fen"', file=sys.stderr)
    sys.exit(1)

fen = sys.argv[1].split()
fen[2] = '-'

print(' '.join(fen))

