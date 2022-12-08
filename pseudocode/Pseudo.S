;;;;;;;;;; IGNORE ABOVE ;;;;;;;;;;
;    x = 0
ADD $1, $0, $0;
;    y = 0
ADD $2, $0, $0;
;    dead = False
ADD $3, $0, $0;

;;CheckWon
;    while not dead:
while:
BNE $3, $0, end
;        Won = True
ADDI $4, $0, 1
;        for i in range(4):
;            for j in range(4):
ADDI $5, $0, $0
for:
ADDI $7, $0, 64
BEQ $5, $7, for_end
;                player_cell = player_map[i][j]
ADDI $7, $5, 64
LB $7, 0($7)
ADDI $6, $0, 32
BEQ $7, $6, first_if
;                if player_cell == ' '

ADDI $6, $0, 63
BNE $7, $6, first_else
;                game_cell = minesweeper_map[i][j]
LB $7, 0($5)
;                if player_cell == ' ' or (player_cell == '?' and game_cell != 'X'):
ADDI $6, $0, 88
BNE $7, $6, first_else
for_if:
ADD $3, $0, $0
JUMP for_end
;                    Won = False
;                    break ; jump out of the double loop
JUMP for_loop
first_else:
;                else:
;                    break
JUMP for_end
for_loop:
ADDI $5, $5, 1
JUMP for
for_end:
;        ack = 0
ADD $4, $0, $0
;        move = 0
ADD, $5, $0, $0       
;        if Won == False:
BNE $3, $0, main_else
;            if move == 0: ; move comes from click detector output
;                continue
BNE $4, $0, skip_mini_if
;            player_map[x][y][7] = 0
SLL $7, $1, 2
ADD $7, $7, $2
LB $6 0($7)
ANDI $6, $6, 127
SB $6, 0($7)
skip_mini_if:
;            if (move == 7 and y-1 >= 0): ; L(111)
ADDI $7, $0, 7
BNE $4, $7, elif_1
ADDI $7, $2, -1
BLTZ $7, elif_1
;                y -= 1
ADDI $2, $2, -1
JUMP elif_done
elif_1:
;            elif (move == 5 and y+1 < 16): ; R(101)
ADDI $7, $0, 5
BNE $4, $7, elif_1
ADDI $7, $2, -15
BLTZ $7, elif_2
;                y += 1
ADDI $2, $2, 1
JUMP elif_done
elif_2:
;            elif (move == 4 and x-1 >= 0): ; U(100)
ADDI $7, $0, 4
BNE $4, $7, elif_1
ADDI $7, $1, -1
BLTZ $7, elif_3
;               x -= 1
ADDI $1, $1, -1
JUMP elif_done
elif_3:
;            elif (move == 6 and x + 1 < 4): ; D(110)
ADDI $7, $0, 6
BNE $4, $7, elif_1
ADDI $7, $1, -3
BLTZ $7, elif_4
;                x += 1
ADDI $1, $1, 1
JUMP elif_done
elif_4:
;            elif (move == 1): ; single btnC click(001)
ADDI $7, $0, 1
BNE $4, $7, elif_5

after_elif

SLL $7, $1, 2
ADD $7, $7, $2
ADDI $7, $7, 64
LB $6 0($7)
;                if player_map[x][y] == '?':
ADDI $6, $6, -63
BNE $6, $0, not_question
;                   player_map[x][y] = ' '
ADDI $6, $0, 32
SB $6, 0($7)
JUMP elif_5
not_question:
;                elif player_map[x][y] == ' ':
LB $6 0($7)
ADDI $6, $0, -32
BNE $6, $0, elif_5
;                    player_map[x][y] = '?'
ADDI $6, $0, 63
SB $6, 0($7)

JUMP elif_done

elif_5:
;            elif (move == 2): ; double click on center(010)
ADDI $7, $0, 2
BNE $4, $7, elif_done
;                player_map[x][y] = minesweeper_map[x][y]
SLL $7, $1, 2
ADD $7, $7, $2
ADDI $7, $7, 64
LB $6 0($7)
ADDI $7, $7, -64
SB $6, 0($7)

elif_done:
;           player_map[x][y][7] = 1
SLL $7, $1, 2
ADD $7, $7, $2
LB $6 0($7)
ANDI $6, $6, 255
SB $6, 0($7)

;            ack = 1 ; acknowledge
ADDI $4, $0, 1
;            ; TODO write current x and y coordinate to MMIO for highlighting

SLL $7, $1, 2
ADD $7, $7, $2
LB $6 0($7)
ADDI $7, $0, 88
BNE $6, $7, not_dead
;            if player_map[x][y] == 'X':
;                dead = True
ADDI $3, $0, 1
not_dead:
;            for row in player_map if not dead else minesweeper_map: ; THIS LOOP IS RENDERING DON'T NEED
;                print("".join(str(cell) for cell in row))

;                print("Curr pos: (%d, %d)" % (x, y))
;                print()
main_else:
;        else:
;            ; TODO SET SOME GLOBAL WON FLAG
;            for row in player_map: ; DON'T BOTHER
;                print("".join(str(cell) for cell in row))
;                print("")
;            print("You have Won!")
;            break
;    return x, y, dead, player_map
end:
HALT
;; Start of Program
;; if __name__ == "__main__":
;;     try:
;;         Game()
;;     except KeyboardInterrupt:
;;         print('\nEnd of Game. Bye Bye!'