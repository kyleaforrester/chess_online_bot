fen="8/2K3k1/7R/3Q4/8/8/8/8 b - - 3 62"
#fen="8/5kpp/8/1pn5/8/5PP1/5K1P/8 w - - 0 49"
depth="18"


move=`(
           echo "position fen $fen";
           echo "go depth $depth";
           sleep 4;
         ) | /usr/games/stockfish | grep "info depth " | grep -v "info depth 1 "`

neg_score=`echo "$move" | grep "info depth 18 " | grep -Eo "score cp \-[0-9]*"`
neg_mate=`echo "$move" | grep "info depth 18 " | grep -Eo "score mate \-[0-9]*"`

neg_score=$(($neg_score + 0))
neg_mate=$(($neg_mate + 0))

echo "$move"
echo "neg_score" $neg_score
echo "neg_mate" $neg_mate

move=`(
           echo "position fen $fen";
           echo "go depth $depth";
           sleep 4;
         ) | /usr/games/stockfish | grep "info depth " | grep -v -e "info depth 1 " -e "info depth 2 " | grep -Eo "pv [a-h][a-h1-8]*" | grep -Eo "[a-h1-8]*" | sort -u`

echo "Candidate moves:" $move

move=`echo "$move" | shuf -n 1`

echo "$move"
