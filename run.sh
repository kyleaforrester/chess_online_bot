#!/bin/bash

source venv/bin/activate

if [ $((RANDOM % 100)) -lt 1 ]; then
    cd Jaime_Lannister69
    python3 chess_move.py
    cd ..
fi

if [ $((RANDOM % 100)) -lt 1 ]; then
    cd WatErbeverage
    python3 chess_move.py
    cd ..
fi

if [ $((RANDOM % 100)) -lt 1 ]; then
    cd danmusil1
    python3 chess_move.py
    cd ..
fi

if [ $((RANDOM % 100)) -lt 1 ]; then
    cd MemoryOfMaelstrom
    python3 chess_move.py
    cd ..
fi

if [ $((RANDOM % 100)) -lt 1 ]; then
    cd Forkwith
    python3 chess_move.py
    cd ..
fi
