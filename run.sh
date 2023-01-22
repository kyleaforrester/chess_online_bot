#!/bin/bash

source venv/bin/activate

cd Jaime_Lannister69
rm geckodriver.log
date >> output.log
python3 chess_move.py >> output.log 2>&1

cd ../WatErbeverage
rm geckodriver.log
date >> output.log
python3 chess_move.py >> output.log 2>&1

cd ../danmusil1
rm geckodriver.log
date >> output.log
python3 chess_move.py >> output.log 2>&1
