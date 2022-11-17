# import random


def Game(map,moves):
    #n*n Map
    n = 6
    #The number of mines
    # k = 7
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
    x = 0
    y = 0
##CheckWon
    while True:
        Won = True
        for row in player_map:
            for cell in row:
                if cell == '-':
                    Won = False
                           
        if Won == False:
            #Detect Move
            time_elapsed = 0
            time_start = 0
            while True:
                #Continue moves
                # print("Enter your cell you want to open(left, right, up, down, center) :")
                # move = input()
                for move in moves:
                    if (move == "left" and x-1 >= 0):
                        x -= 1
                        time_start = 1
                    elif (move == "right" and x+1 < n):
                        x += 1
                        time_start = 1
                    elif (move == "up" and y - 1 >= 0):
                        y -= 1
                        time_start = 1
                    elif (move == "down" and y + 1 < n):
                        y += 1
                        time_start = 1
                    elif (move == "center"):
                        # simulate the elasped time for another click
                        print("Time that elapsed (s) :")
                        time_elapsed = input()
                        if float(time_elapsed) > 0.1: 
                            time_start = 0   
                    else:
                        print("Enter Valid Move Again")
                if time_start == 1:
                        break
                else:
                    player_map[y][x] = '?'
                    break    


            if (minesweeper_map[y][x] == 'X' and time_start == 1 ):
                print("Game Over!")
                for row in minesweeper_map:
                    print(" ".join(str(cell) for cell in row))
                    print("")
                return minesweeper_map
            else:
                if(player_map[y][x] != '?'):
                    player_map[y][x] = minesweeper_map[y][x]
                for row in player_map:
                    print(" ".join(str(cell) for cell in row))
                    print("")

        else:
            for row in player_map:
                print(" ".join(str(cell) for cell in row))
                print("")
            print("You have Won!")
            break
# Start of Program
# if __name__ == "__main__":
#     try:
#         Game()
#     except KeyboardInterrupt:
#         print('\nEnd of Game. Bye Bye!')