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
            if(map[x][y] == 'X'):
                minesweeper_map[x][y] = map[x][y]
    # for num in range(k):
    #     x = random.randint(0,n-1)
    #     y = random.randint(0,n-1)
    #     minesweeper_map[y][x] = 'X'
                #x the the row and y is the column
                if (y >=0 and y < n-1) and (x >= 0 and x < n):
                    if minesweeper_map[x][y+1] != 'X':
                        minesweeper_map[x][y+1] += 1 # center right
                if (y >=1 and y < n) and (x >= 0 and x < n):
                    if minesweeper_map[x][y-1] != 'X':
                        minesweeper_map[x][y-1] += 1 # center left
                if (y >= 1 and y < n) and (x >= 1 and x < n):
                    if minesweeper_map[x-1][y-1] != 'X':
                        minesweeper_map[x-1][y-1] += 1 # top left

                if (y >= 0 and y < n -1) and (x >= 1 and x < n):
                    if minesweeper_map[x-1][y+1] != 'X':
                        minesweeper_map[x-1][y+1] += 1 # top right
                if (y >= 0 and y < n) and (x >= 1 and x < n):
                    if minesweeper_map[x-1][y] != 'X':
                        minesweeper_map[x-1][y] += 1 # top center

                if (y >=0 and y < n -1) and (x >= 0 and x < n -1):
                    if minesweeper_map[x+1][y+1] != 'X':
                        minesweeper_map[x+1][y+1] += 1 # bottom right
                if (y >= 1 and y < n) and (x >= 0 and x < n -1):
                    if minesweeper_map[x+1][y-1] != 'X':
                        minesweeper_map[x+1][y-1] += 1 # bottom left
                if (y >= 0 and y < n) and (x >= 0 and x < n -1):
                    if minesweeper_map[x+1][y] != 'X':
                        minesweeper_map[x+1][y] += 1 # bottom center
        
## GeneratePlayerMap
    player_map = [['-' for row in range(n)] for column in range(n)]
    x = 0
    y = 0
    # testFrame = 0
    # prevButtonDown = 0
    dead = False
    # timerStart = 0

##CheckWon
    while not dead :
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
           for move in moves:
                if move == 0:
                    continue
                elif (move == 7 and y-1 >= 0): # L(111)
                    y -= 1
                elif (move == 5 and y+1 < n): # R(101)
                    y += 1
                elif (move == 4 and x-1 >= 0): # U(100)
                    x -= 1
                elif (move == 6 and x + 1 < n): # D(110)
                    x += 1
                elif (move == 1): # single btnC click(001)
                    if player_map[x][y] == '?':
                        player_map[x][y] = '-'
                    elif player_map[x][y] == '-':
                        player_map[x][y] = '?'
                elif (move == 2): # double click on center(010)
                    player_map[x][y] = minesweeper_map[x][y]

                if player_map[x][y] == 'X':
                    dead = True
                for row in player_map if not dead else minesweeper_map:
                    print("".join(str(cell) for cell in row))

                print("Curr pos: (%d, %d)" % (x, y))
                print()

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