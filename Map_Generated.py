# import random


def Game(map,moves):
    #n*n Map
    n = 6
    #The number of mines
    # k = 7
    # mine map generated
    minesweeper_map = [[0 for row in range(n)] for column in range(n)]
    for x in range(n):
        for y in range(n):
            if(map[y][x] == 'X'):
                minesweeper_map[y][x] = map[y][x]
    # for num in range(k):
    #     x = random.randint(0,n-1)
    #     y = random.randint(0,n-1)
    #     minesweeper_map[y][x] = 'X'
                if (x >=0 and x <= n-2) and (y >= 0 and y <= n-1):
                    if minesweeper_map[y][x+1] != 'X':
                        minesweeper_map[y][x+1] += 1 # center right
                if (x >=1 and x <= n-1) and (y >= 0 and y <= n-1):
                    if minesweeper_map[y][x-1] != 'X':
                        minesweeper_map[y][x-1] += 1 # center left
                if (x >= 1 and x <= n-1) and (y >= 1 and y <= n-1):
                    if minesweeper_map[y-1][x-1] != 'X':
                        minesweeper_map[y-1][x-1] += 1 # top left

                if (x >= 0 and x <= n-2) and (y >= 1 and y <= n-1):
                    if minesweeper_map[y-1][x+1] != 'X':
                        minesweeper_map[y-1][x+1] += 1 # top right
                if (x >= 0 and x <= n-1) and (y >= 1 and y <= n-1):
                    if minesweeper_map[y-1][x] != 'X':
                        minesweeper_map[y-1][x] += 1 # top center

                if (x >=0 and x <= n-2) and (y >= 0 and y <= n-2):
                    if minesweeper_map[y+1][x+1] != 'X':
                        minesweeper_map[y+1][x+1] += 1 # bottom right
                if (x >= 1 and x <= n-1) and (y >= 0 and y <= n-2):
                    if minesweeper_map[y+1][x-1] != 'X':
                        minesweeper_map[y+1][x-1] += 1 # bottom left
                if (x >= 0 and x <= n-1) and (y >= 0 and y <= n-2):
                    if minesweeper_map[y+1][x] != 'X':
                        minesweeper_map[y+1][x] += 1 # bottom center
        
## GeneratePlayerMap
    player_map = [['-' for row in range(n)] for column in range(n)]
    x = n // 2
    y = n // 2
    testFrame = 0
    prevButtonDown = 0
    dead = False
    timerStart = 0
    move = 0

##CheckWon
    while not dead and testFrame < len(moves):
        if timerStart == 1:
            timerStart = 0

        Won = True
        for i in range(n):
            for j in range(n):
                player_cell = player_map[i][j]
                game_cell = minesweeper_map[i][j]
                if player_cell == '-' or (player_cell == '?' and game_cell != 'X'):
                    Won = False
                    break # jump out of the double loop
            else:
                break
                           
        if Won == False:
            currInput = moves[testFrame][:]
            if prevButtonDown == 0: # no button pressed before
                for buttonIdx in range(5):
                    if currInput[buttonIdx] == 1:
                        prevButtonDown = buttonIdx + 1
                        break
            else: # button pressed before
                if currInput[prevButtonDown - 1] == 0: # click
                    if move != -1:
                        move = prevButtonDown

                    if move == -1 and prevButtonDown == 5 and currInput[-1] == 1: # center double click
                        move = 6
                    elif move == 5: # center click, start timer
                        timerStart = 1
                        move = -1
                    prevButtonDown = 0
            if move == -1 and currInput[-1] == 0:
                move = 5

            if (move == 1 and x-1 >= 0): # L
                x -= 1
            elif (move == 2 and x+1 < n): # R
                x += 1
            elif (move == 3 and y - 1 >= 0): # U
                y -= 1
            elif (move == 4 and y + 1 < n): # D
                y += 1
            elif (move == 5): # C
                if player_map[y][x] == '?':
                    player_map[y][x] = '-'
                elif player_map[y][x] == '-':
                    player_map[y][x] = '?'
            elif (move == 6): # double click on center
                player_map[y][x] = minesweeper_map[y][x]

            if player_map[y][x] == 'X':
                dead = True
            for row in player_map if not dead else minesweeper_map:
                print("".join(str(cell) for cell in row))

            print("Curr pos: (%d, %d)" % (y, x));
            print()

            if move > 0:
                move = 0
            testFrame += 1

        else:
            for row in player_map:
                print("".join(str(cell) for cell in row))
                print("")
            print("You have Won!")
            break
    return x, y, dead, player_map
# Start of Program
# if __name__ == "__main__":
#     try:
#         Game()
#     except KeyboardInterrupt:
#         print('\nEnd of Game. Bye Bye!')