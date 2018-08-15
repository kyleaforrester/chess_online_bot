import sys

if (len(sys.argv) != 2):
  print('Usage: python3 my_script.py [fromPos][toPos]')
  print('Example: python3 my_script.py g1f3')
  sys.exit(1)

# TCN (Two Character Notation) is quite simple.
# Two ascii symbols are used to encode each move.
# The first represents the "from" square.
# "a" represents square a1, "b" b1" and so on.
# The second symbol represents the "to" square and can also code for the promotion value.
# If a pawn promotes, the second symbol will be one of the 12 symbols from 65-76 (i.e., from "{" to "$").
# The first three represent queen promotion, the next three knight, followed by rook, and finally bishop.
# The first of each trio codes for pawn movement toward the left (regardless of color) (e.g., exd), the second is straight (i.e., no change in file), the third right.
# Since pawns must always move one square when promoting, the "to" square can calculated from the "from" square.

my_dict = {'a1':"a",'a2':"i",'a3':"q",'a4':"y",'a5':"G",'a6':"O",'a7':"W",'a8':"4",'b1':"b",'b2':"j",'b3':"r",'b4':"z",'b5':"H",'b6':"P",'b7':"X",'b8':"5",'c1':"c",'c2':"k",'c3':"s",'c4':"A",'c5':"I",'c6':"Q",'c7':"Y",'c8':"6",'d1':"d",'d2':"l",'d3':"t",'d4':"B",'d5':"J",'d6':"R",'d7':"Z",'d8':"7",'e1':"e",'e2':"m",'e3':"u",'e4':"C",'e5':"K",'e6':"S",'e7':"0",'e8':"8",'f1':"f",'f2':"n",'f3':"v",'f4':"D",'f5':"L",'f6':"T",'f7':"1",'f8':"9",'g1':"g",'g2':"o",'g3':"w",'g4':"E",'g5':"M",'g6':"U",'g7':"2",'g8':"!",'h1':"h",'h2':"p",'h3':"x",'h4':"F",'h5':"N",'h6':"V",'h7':"3",'h8':"?"}
if (len(sys.argv[1]) == 4):
  #No promotion
  first_char = my_dict[sys.argv[1][:2]]
  second_char = my_dict[sys.argv[1][2:]]
  TCN = first_char + second_char
elif (len(sys.argv[1]) == 5):
  # A pawn has been promoted
  # Examples: b2b1r or f7g8q
  promotion_string = '{~}(^)[_]@#$'
  piece_promo_index_values = {'q':0, 'n':3, 'r':6, 'b':9}
  promoted_piece = sys.argv[1][4]
  index_boost = piece_promo_index_values[promoted_piece]

  columnFrom = sys.argv[1][0]
  columnTo = sys.argv[1][2]
  column_diff = ord(columnFrom) - ord(columnTo)
  if (column_diff == 1):
    #move left
    capture_index = 0
  elif (column_diff == 0):
    #move straight
    capture_index = 1
  elif (column_diff == -1):
    #move right
    capture_index = 2
  else:
    print('Pawns cannot capture two columns over', file=sys.stderr)
    sys.exit(1)

  first_char = my_dict[sys.argv[1][:2]]
  second_char = promotion_string[index_boost + capture_index]
  TCN = first_char + second_char
else:
  print('Invalid move input length', file=sys.stderr)
  sys.exit(1)

print(TCN)
