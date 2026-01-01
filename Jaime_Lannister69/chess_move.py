#!/usr/bin/env python3

from selenium import webdriver
from selenium.webdriver import FirefoxOptions
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.common.by import By
from selenium.webdriver.support.wait import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC

import time
import json
import random
import sys
import subprocess
import requests
import os
from subprocess import PIPE

def challenge_new_opponent(cookies):
    json_payload = {"daysPerMove":3,"gameType":"chess","isRated":1,"maxRatingDelta":None,"minRatingDelta":100,"minRequiredGameCount":0,"takeback":"0"}

    response = requests.post('https://www.chess.com/callback/game/random/daily/challenge', json=json_payload, cookies=cookies)
    print(json.loads(response.text))

def encode_move(move):
    # TCN (Two Character Notation) is quite simple.
    # Two ascii symbols are used to encode each move.
    # The first represents the "from" square.
    # "a" represents square a1, "b" b1" and so on.
    # The second symbol represents the "to" square and can also code for the promotion value.
    # If a pawn promotes, the second symbol will be one of the 12 symbols from 65-76 (i.e., from "{" to "$").
    # The first three represent queen promotion, the next three knight, followed by rook, and finally bishop.
    # The first of each trio codes for pawn movement toward the left (regardless of color) (e.g., exd), the second is straight (i.e., no change in file), the third right.
    # Since pawns must always move one square when promoting, the "to" square can calculated from the "from" square.

    my_dict = {'a1': "a", 'a2': "i", 'a3': "q", 'a4': "y", 'a5': "G", 'a6': "O", 'a7': "W", 'a8': "4", 'b1': "b", 'b2': "j", 'b3': "r", 'b4': "z", 'b5': "H", 'b6': "P", 'b7': "X", 'b8': "5", 'c1': "c", 'c2': "k", 'c3': "s", 'c4': "A", 'c5': "I", 'c6': "Q", 'c7': "Y", 'c8': "6", 'd1': "d", 'd2': "l", 'd3': "t", 'd4': "B", 'd5': "J", 'd6': "R", 'd7': "Z", 'd8': "7",
               'e1': "e", 'e2': "m", 'e3': "u", 'e4': "C", 'e5': "K", 'e6': "S", 'e7': "0", 'e8': "8", 'f1': "f", 'f2': "n", 'f3': "v", 'f4': "D", 'f5': "L", 'f6': "T", 'f7': "1", 'f8': "9", 'g1': "g", 'g2': "o", 'g3': "w", 'g4': "E", 'g5': "M", 'g6': "U", 'g7': "2", 'g8': "!", 'h1': "h", 'h2': "p", 'h3': "x", 'h4': "F", 'h5': "N", 'h6': "V", 'h7': "3", 'h8': "?"}
    if (len(move) == 4):
        # No promotion
        first_char = my_dict[move[:2]]
        second_char = my_dict[move[2:]]
        TCN = first_char + second_char
    elif (len(move) == 5):
        # A pawn has been promoted
        # Examples: b2b1r or f7g8q
        promotion_string = '{~}(^)[_]@#$'
        piece_promo_index_values = {'q': 0, 'n': 3, 'r': 6, 'b': 9}
        promoted_piece = move[4]
        index_boost = piece_promo_index_values[promoted_piece]

        columnFrom = move[0]
        columnTo = move[2]
        column_diff = ord(columnFrom) - ord(columnTo)
        if (column_diff == 1):
            # move left
            capture_index = 0
        elif (column_diff == 0):
            # move straight
            capture_index = 1
        elif (column_diff == -1):
            # move right
            capture_index = 2
        else:
            print('Pawns cannot capture two columns over', file=sys.stderr)
            sys.exit(1)

        first_char = my_dict[move[:2]]
        second_char = promotion_string[index_boost + capture_index]
        TCN = first_char + second_char
    else:
        print('Invalid move input length', file=sys.stderr)
        sys.exit(1)

    return TCN


def transfer_cookies(driver_cookies):
    cookies = {}
    for c in driver.get_cookies():
        cookies[c['name']] = c['value']
    return cookies


def get_bestmove(game):
    # If the opponent has only a king and pawns left, end the game quickly
    fen = game[1].split()
    endgame = False
    if fen[1] == 'w':
        # I am white
        if len(list(filter(lambda x: x in ('q', 'r', 'b', 'n'), fen[0]))) == 0:
            endgame = True
    else:
        # I am black
        if len(list(filter(lambda x: x in ('Q', 'R', 'B', 'N'), fen[0]))) == 0:
            endgame = True

    if endgame == True:
        uci_cmd = '''position fen {}
go depth 8\n'''.format(game[1])
        proc = subprocess.Popen(['/usr/games/stockfish_11'],
                                stdin=PIPE, stdout=PIPE, text=True)
        print('Endgame is true, using stockfish_11 at depth 8')

    else:
        # Play stronger depending on how many minor/major pieces are missing from our board
        if fen[1] == 'w':
            # I am white
            missing_pieces = max(7 - len(list(filter(lambda x: x in ('Q', 'R', 'B', 'N'), fen[0]))), 0)
        else:
            # I am black
            missing_pieces = max(7 - len(list(filter(lambda x: x in ('q', 'r', 'b', 'n'), fen[0]))), 0)
        nodes = 2**missing_pieces
        uci_cmd = '''setoption name Backend value eigen
position fen {}
go nodes {}\n'''.format(game[1], nodes)
        network = random.choice(['700150', '700200', '700250'])
        proc = subprocess.Popen(['/usr/games/lc0', '-w', network],
                                stdin=PIPE, stdout=PIPE, text=True)

    proc.stdin.write(uci_cmd)
    proc.stdin.flush()

    for line in iter(proc.stdout.readline, ''):
        if 'bestmove' in line:
            return line.split()[1]

opts = FirefoxOptions()
opts.add_argument("--headless")
driver = webdriver.Firefox(options=opts, service_log_path=os.devnull)
try:
    driver.get("https://www.chess.com/login_and_go?returnUrl=https://www.chess.com/")

    elem = WebDriverWait(driver, 5).until(
        EC.presence_of_element_located((By.XPATH, "//form[@id='authentication-login-form']/div[@id='username-input-field-container']/div[1]/div[1]/input[1]"))
    )
    elem.clear()
    elem.send_keys("Jaime_Lannister69")

    elem = WebDriverWait(driver, 5).until(
        EC.presence_of_element_located((By.XPATH, "//form[@id='authentication-login-form']/div[@id='password-input-field-container']/div[1]/div[1]/input[1]"))
    )
    elem.clear()
    elem.send_keys("jellybean!")
    elem.send_keys(Keys.RETURN)

    time.sleep(1)
    cookies = transfer_cookies(driver.get_cookies())
finally:
    driver.quit()

if random.random() < 0.1:
    challenge_new_opponent(cookies)

response = requests.get(
    'https://www.chess.com/callback/user/daily/games?limit=100', cookies=cookies)
games_obj = json.loads(response.text)

games_fens = [(game['id'], game['fen'])
              for game in games_obj['dailyGamesGrid'] if game['isMyTurnToMove'] == True]


for game in games_fens:
    bestmove = ''
    if (game[1] is not None):
        bestmove = get_bestmove(game)
    else:
        bestmove = random.choice(
            ('e2e4', 'd2d4', 'c2c4', 'g1f3', 'b1c3', 'b2b3', 'g2g3', 'f2f4', 'b2b4'))

    print('Game {}: bestmove: {}'.format(game, bestmove))
    encoded_move = encode_move(bestmove)

    response = requests.get(
        'https://www.chess.com/callback/daily/game/{}'.format(game[0]), cookies=cookies)
    games_obj = json.loads(response.text)

    json_payload = {'_token': '', 'lastDate': games_obj['game']['lastDate'],
                    'move': encoded_move, 'plyCount': games_obj['game']['plyCount'], 'squared': 1}
    headers = {'Referer': 'https://www.chess.com/game/daily/{}'.format(
        game[0]), 'Host': 'www.chess.com', 'Origin': 'https://www.chess.com', 'Alt-Used': 'www.chess.com'}
    response = requests.post('https://www.chess.com/callback/game/{}/submit-move'.format(
        game[0]), json=json_payload, headers=headers, cookies=cookies)
