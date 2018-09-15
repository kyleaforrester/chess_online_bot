echo `date`

session_id=`curl -i 'https://www.chess.com/login_check' -H 'origin: https://www.chess.com' -H 'accept-encoding: gzip, deflate, br' -H 'accept-language: en-US,en;q=0.8' -H 'upgrade-insecure-requests: 1' -H 'user-agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/57.0.2987.98 Safari/537.36' -H 'content-type: application/x-www-form-urlencoded' -H 'accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8' -H 'cache-control: max-age=0' -H 'authority: www.chess.com' -H 'cookie: amplitude_idchess.com=eyJkZXZpY2VJZCI6IjZiYTlkNTk4LTlkNWYtNDQ5Yi1hZTMxLWU5ZmVhODc4MDJhNFIiLCJ1c2VySWQiOm51bGwsIm9wdE91dCI6ZmFsc2UsInNlc3Npb25JZCI6MTUwMTUwMTE4Mjk0MSwibGFzdEV2ZW50VGltZSI6MTUwMTUwMTE4Mjk0MSwiZXZlbnRJZCI6MCwiaWRlbnRpZnlJZCI6MCwic2VxdWVuY2VOdW1iZXIiOjB9; _ga=GA1.2.994613215.1501501184; _gid=GA1.2.536711694.1501501184' -H 'referer: https://www.chess.com/' --data '_username=WatErbeverage&_password=jellybean%21&_timezone=America%2FNew_York&_target_path=&_token=3FyXeTnbncjFE1kFpOvGGrz1xga2IM-K6n-AntXmF-w' --compressed | grep -Po "PHPSESSID=[0-9a-z]*" | grep -Po "[0-9a-z]*"`

curl_query="curl 'https://www.chess.com/callback/user/daily/games?showLearningTiles=1' -H 'accept-language: en-US,en;q=0.8' -H 'user-agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/57.0.2987.98 Safari/537.36' -H 'accept: application/json, text/plain, */*' -H 'referer: https://www.chess.com/home' -H 'authority: www.chess.com' -H 'cookie: __gads=ID=39696f01de1e0b5e:T=1478318872:S=ALNI_MbPjfvZoyLrXTK6jwt2dH02RgC6SA; __qca=P0-198180529-1478747058035; __atuvc=1%7C44%2C0%7C45%2C1%7C46; beta=1; __lc.visitor_id.7187901=S1482812336.5ce3fa5d7e; _ga=GA1.3.961195019.1478318854; position=1; userid=FC1AA916-8065-73F9-B96A-2BA20A58A028; PHPSESSID=$session_id; cdmu=1492773470166; cdmblk2=0:0:0:0:0:0:0:0:0:0:0:0:0,0:0:0:0:0:0:0:0:0:0:0:0:0,0:0:0:0:0:0:0:0:0:0:0:0:0,0:0.01:0:0:0:0:0:0:0:0:0:0:0,0:0:0:0:0:0:0:0:0:0:0:0:0,0:0:0:0:0:0:0:0:0:0:0:0:0; OX_sd=1; OX_plg=swf|shk|pm; cdmblk=0:0:0:0:0:0:0:0:0:0:0:0:0,0:0:0:0:0:0:0:0:0:0:0:0:0.99,0:0:0:0:0:0:0:0:0:0:0:0:0,0:0:0:0:0:0:0.09:0:0:0:0:0:0,0:0:0:0:0:0:0:0:0:0:0:0:0,0:0:0:0:0:0:0:0:0:0:0:0:0; cdmtlk=0:379:5693:0:1129:0:660:2616:598:0:1360:0:418; cdmgeo=us; cdmbaserate=2.1; cdmbaseraterow=1.1; cdmint=0; _ga=GA1.2.961195019.1478318854; amplitude_idchess.com=eyJkZXZpY2VJZCI6ImMyM2RlZDg2LTcyNDktNGFmOC1iZmVjLWYxZTc1NGU5ZWE4YVIiLCJ1c2VySWQiOiIzMzQwMTg3MyIsIm9wdE91dCI6ZmFsc2UsInNlc3Npb25JZCI6MTQ5Mjc3MTY5NTA4MiwibGFzdEV2ZW50VGltZSI6MTQ5Mjc3Mzg3MjA5NywiZXZlbnRJZCI6MzQ2LCJpZGVudGlmeUlkIjo0MjcsInNlcXVlbmNlTnVtYmVyIjo3NzN9'"

game_numbers=`eval $curl_query | grep -Eo "\"dailyGamesStatus\":\[[\"0-9\,]*" | grep -Eo "[0-9]*"`


for x in $game_numbers
do
  random="$RANDOM"
  let "random %= 10"
  if [ "$random" -gt 0 ]; then
    echo "Random = $random .  Skipping game $x for now"
    continue
  fi

  curl_query="curl 'https://www.chess.com/callback/user/daily/games?showLearningTiles=1&limit=50' -H 'Host: www.chess.com' -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101 Firefox/52.0' -H 'Accept: application/json, text/plain, */*' -H 'Accept-Language: en-US,en;q=0.5' --compressed -H 'Referer: https://www.chess.com/daily' -H 'Cookie: _ga=GA1.2.1702818451.1494885759; __cfduid=d39fb4f3e0a5a6a055795f1513050b24b1536302546; __gads=ID=6fc58e1676cf65b8:T=1514418725:S=ALNI_MZdXR-VRHKcRpYVEv85BoIAo393_g; visitorid=%3Adb1d%3Affff%3A136.55.22.3; amplitude_id_5cc41a1e56d0ee35d4c85d1d4225d2d1chess.com=eyJkZXZpY2VJZCI6ImU0MzllZDMyLTMyMmEtNGM5My1hODUzLTQ4Y2NjMzVhOGQ2N1IiLCJ1c2VySWQiOiIzMzQwMTg3MyIsIm9wdE91dCI6ZmFsc2UsInNlc3Npb25JZCI6MTUzNjMwMTU5ODMyNiwibGFzdEV2ZW50VGltZSI6MTUzNjMwMjQ1OTMzMCwiZXZlbnRJZCI6MTMsImlkZW50aWZ5SWQiOjE5LCJzZXF1ZW5jZU51bWJlciI6MzJ9; asset_push=20180906131901%3Bf6186%2Cabff9%2Cbe386%2Ca2ab9%2Cbeff9%2Ce5061; PHPSESSID=$session_id; __vrz=1.9.2' -H 'Connection: keep-alive'"

  query_response=`eval $curl_query`
  fen=`echo $query_response | grep -Eo "\"id\":[0-9]*,\"fen\":\"[a-zA-Z0-9\/]* [wb]* [kqKQ\-]* [a-z0-9\-]* [0-9]* [0-9]*" | sort | uniq | grep $x | grep -Eo "[a-zA-Z0-9\/]* [wb]* [kqKQ\-]* [a-z0-9\-]* [0-9]* [0-9]*"`
  depth_opts=("1" "2" "3" "4" "5" "6")
  depth=${depth_opts[$RANDOM % ${#depth_opts[@]}]}
  depth=18
  echo "Fen: $fen"
  if [ -z "$fen" ]; then
    echo "No FEN found for $x"
    start_moves=("c2c4" "d2d4" "e2e4" "f2f4" "g1f3" "b2b3" "g2g3" "b2b4")
    move=${start_moves[$RANDOM % ${#start_moves[@]}]}
  else
    moves=`(
           echo "position fen $fen";
           echo "go depth $depth";
           sleep 6;
         ) | /usr/games/stockfish | grep "info depth " | grep -v -e "info depth 1 " | grep -Eo "pv [a-h][a-h1-8]*" | grep -Eo "[a-h1-8]*" | sort -u`
    echo "Candidate moves:" $moves
    move=`echo "$moves" | shuf -n 1`
    
    if [ -z "$move" ]; then
      #Stockfish has crashed.  Enable 960 support for weird castling rules
      fen=`python3 ./strip_castling.py "$fen"`
      echo "Stockfish has crashed.  Using stripped castling fen:"
      echo $fen
      move=`(
             echo "position fen $fen";
             echo "go depth $depth";
             sleep 6;
           ) | /usr/games/stockfish | grep bestmove | awk '{print $2}'`
    fi
  fi
  echo "Move: $move"
  encoded_move=`python3 ./encode_move.py $move`
  echo "Encoded Move: $encoded_move"

  curl_query="curl 'https://www.chess.com/callback/daily/game/$x' -H 'pragma: no-cache' -H 'x-requested-with: XMLHttpRequest' -H 'accept-language: en-US,en;q=0.8' -H 'user-agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/52.0.2743.82 Safari/537.36' -H 'accept: application/json' -H 'cache-control: no-cache' -H 'authority: www.chess.com' -H 'cookie: sm_dapi_session=1; H1:8c5424ad33aaf43a0850a45a68713=1; __gads=ID=001e346ebf7c0d7d:T=1475607119:S=ALNI_Mb0WKaIK8OviG1yKR9MFwCIaEOLTA; allggin=1; H1:f79607ba4d15b54f93f98a3ef8710=1; __atuvc=7%7C40%2C1%7C41; _ga=GA1.2.139882932.1475606750; beta=1; _gat=1; PHPSESSID=$session_id; _ga=GA1.3.139882932.1475606750; OX_sd=3; OX_plg=pm' -H 'referer: https://www.chess.com/daily/game/$x'"
  query_response=`eval $curl_query`
  last_date=`echo $query_response | grep -o "\"last_date\":[0-9]*" | grep -o "[0-9]*"`
  echo "Last Date: $last_date"
  ply_count=`echo $query_response | grep -o "\"ply_count\":[0-9]*" | grep -o "[0-9]*"`
  echo "Ply Count: $ply_count"

  curl_query="curl 'https://www.chess.com/callback/game/$x/submit-move' -H 'origin: https://www.chess.com' -H 'x-requested-with: XMLHttpRequest' -H 'accept-language: en-US,en;q=0.8' -H 'user-agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/52.0.2743.82 Safari/537.36' -H 'content-type: application/x-www-form-urlencoded;charset=UTF-8' -H 'accept: application/json' -H 'referer: https://www.chess.com/daily/game/$x' -H 'authority: www.chess.com' -H 'cookie: __atuvc=2%7C41; allggin=1; __gads=ID=048e25eaf94c0208:T=1476012885:S=ALNI_Ma6AFaVEoZwTNa6ZhLWaNROfmb21A; sm_dapi_session=1; H1:f79607ba4d15b54f93f98a3ef8710=1; chess_mw_c16=0; _ga=GA1.2.533584361.1476012764; beta=1; PHPSESSID=$session_id; _ga=GA1.3.533584361.1476012764; OX_sd=3; OX_plg=pm' --data 'lastDate=$last_date&plyCount=$ply_count&move=$encoded_move&squared=1'"
  if [ -n "$move" ]; then
    query_response=`eval $curl_query`
    echo "Move posted!"
  fi

  echo $x
done

