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
BNE $3, $0, skip_jump_end
JUMP end

skip_jump_end:
;        Won = True
ADDI $4, $0, 1
;        for i in range(4):
;            for j in range(4):
ADD $5, $0, $0; flatten loop to $5
for:
ADDI $7, $0, 30; add total of 64
ADDI $7, $7, 30
ADDI $7, $7, 4
BNE $5, $7, skip_jump_for_end
JUMP for_end

skip_jump_for_end:
;                player_cell = player_map[i][j]
ADDI $7, $5, 30; $7 = 64 + $5
ADDI $7, $7, 30
ADDI $7, $7, 4
LB $7, 0($7); player_cell
SLL $7, $7
SRL $7, $7; clear first bit
ADDI $6, $0, 16; add total of 32, i.e. space
ADDI $6, $6, 16
BEQ $7, $6, first_if
;                if player_cell == ' '

ADDI $6, $0, 30; add total of 63, '?'
ADDI $6, $6, 30
ADDI $6, $6, 3
BNE $7, $6, first_else
;                game_cell = minesweeper_map[i][j]
LB $7, 0($5)
;                if player_cell == ' ' or (player_cell == '?' and game_cell != 'X'):
ADDI $6, $0, 30; add total of 88 'X'
ADDI $6, $6, 30
ADDI $6, $6, 28
BNE $7, $6, first_else
first_if:
ADD $4, $0, $0; Won = false
JUMP for_end
;                    Won = False
;                    break ; jump out of the double loop
first_else:
ADDI $5, $5, 1
JUMP for
for_end:


;        ack = 0;
ADDI $7, $0, -9; ACK 
SB $0, 0($7)

;        LOAD move;
ADDI $7, $7, -1;
LB $4, 0($7)
SB $4, -1($0)

;        if Won == False:
BEQ $4, $0, continue_main_if
JUMP main_else
continue_main_if:

;            if move == 0: ; move comes from click detector output
;                continue
BNE $4, $0, continue_mini_if
JUMP while

continue_mini_if:
;            player_map[x][y][7] = 0
SLL $7, $1; x*2
SLL $7, $7
SLL $7, $7
SLL $7, $7; x*16
ADD $7, $7, $2; x*16+y
ADDI $7, $7, 30
ADDI $7, $7, 30
ADDI $7, $7, 2
LB $5, 0($7); player_map[x][y]
ADDI $6, $0, -1; create 127
SRL $6, $6
AND $5, $5, $6
SB $5, 0($7)

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
BNE $4, $7, elif_2
ADDI $7, $2, -15
BGEZ $7, elif_2
;                y += 1
ADDI $2, $2, 1
JUMP elif_done
elif_2:
;            elif (move == 4 and x-1 >= 0): ; U(100)
ADDI $7, $0, 4
BNE $4, $7, elif_3
ADDI $7, $1, -1
BLTZ $7, elif_3
;               x -= 1
ADDI $1, $1, -1
JUMP elif_done
elif_3:
;            elif (move == 6 and x + 1 < 4): ; D(110)
ADDI $7, $0, 6
BNE $4, $7, elif_4
ADDI $7, $1, -3
BGEZ $7, elif_4
;                x += 1
ADDI $1, $1, 1
JUMP elif_done
elif_4:
;            elif (move == 1): ; single btnC click(001)
ADDI $7, $0, 1
BEQ $4, $7, continue_elif_4
JUMP elif_5
continue_elif_4:

SLL $7, $1; x*2
SLL $7, $7
SLL $7, $7
SLL $7, $7; x*16
ADD $7, $7, $2; x*16+y
ADDI $7, $7, 30
ADDI $7, $7, 30
ADDI $7, $7, 2
LB $6, 0($7); player_map[x][y]
SLL $6, $6
SRL $6, $6
;                if player_map[x][y] == '?':
ADDI $6, $6, -30; add to -63
ADDI $6, $6, -30
ADDI $6, $6, -3
BNE $6, $0, not_question
;                   player_map[x][y] = ' '
ADDI $6, $0, 16; add to 32, space
ADDI $6, $6, 16
SB $6, 0($7)
JUMP elif_done
not_question:
;                elif player_map[x][y] == ' ':
LB $6 0($7)
ADDI $6, $6, -16; minus blank
ADDI $6, $6, -16
BNE $6, $0, elif_5
;                    player_map[x][y] = '?'
ADDI $6, $0, 30; ?
ADDI $6, $6, 30
ADDI $6, $6, 3
SB $6, 0($7)

JUMP elif_done

elif_5:
;            elif (move == 2): ; double click on center(010)
ADDI $7, $0, 2
BNE $4, $7, elif_done
;                player_map[x][y] = minesweeper_map[x][y]
SLL $7, $1; x*2
SLL $7, $7
SLL $7, $7
SLL $7, $7; x*16
ADD $7, $7, $2; x*16+y

ADDI $7, $7, 30; &minesweeper_map[x][y]
ADDI $7, $7, 30
ADDI $7, $7, 2
LB $6 0($7)
ADDI $7, $7, -30
ADDI $7, $7, -30
ADDI $7, $7, -2
SB $6, 0($7)

elif_done:
;           player_map[x][y][7] = 1
SLL $7, $1; x*2
SLL $7, $7
SLL $7, $7
SLL $7, $7; x*16
ADD $7, $7, $2; x*16+y
ADDI $7, $7, 30
ADDI $7, $7, 30
ADDI $7, $7, 2
LB $6, 0($7)
ORI $6, $6, -1
SB $6, 0($7)

; DEBUG PURPOSES DELETE
; HALT

;            ack = 1
ADDI $7, $0, -9; ACK 
ADDI $6, $0, 15
SB $6, 0($7)

SLL $7, $1; x*2
SLL $7, $7
SLL $7, $7
SLL $7, $7; x*16
ADD $7, $7, $2; x*16+y
ADDI $7, $7, 30
ADDI $7, $7, 30
ADDI $7, $7, 2
LB $6, 0($7)
SLL $6, $6
SRL $6, $6
ADDI $7, $0, 30; X = 88
ADDI $7, $0, 30
ADDI $7, $0, 28
BNE $6, $7, not_dead
;            if player_map[x][y] == 'X':
;                dead = True
ADDI $3, $0, 1
not_dead:

JUMP while

main_else: ; won
ADDI $7, $0, 2
SB $7, -2(R0)
game_won:
JUMP game_won
;        else:
;           for row in player_map: ; DONT BOTHER
;                print("".join(str(cell) for cell in row))
;                print("")
;            print("You have Won!")
;            break
;    return x, y, dead, player_map
end:

ADDI $7, $0, 6
SB $7, -2(R0)
game_dead:
JUMP game_dead
;; Start of Program
;; if __name__ == "__main__":
;;     try:
;;         Game()
;;     except KeyboardInterrupt:
;;         print('\nEnd of Game. Bye Bye!'