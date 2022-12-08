;;;;;;;;;; IGNORE ABOVE ;;;;;;;;;;
SUB R0, R0, R0; reset zero register
;    x = 0
ADD R1, R0, R0;
;    y = 0
ADD R2, R0, R0;
;    dead = False
ADD R3, R0, R0;

;;CheckWon
;    while not dead:
while:
BNE R3, R0, skip_jump_end
JUMP end; DEBUG dont jump end what will happen?

skip_jump_end:
;        Won = True
ADDI R4, R0, 1; won
ADD R5, R0, R0; i

;        for i in range(64):
for:
ADDI R7, R0, 30; add total of 64
ADDI R7, R7, 30
ADDI R7, R7, 4
BNE R5, R7, skip_jump_for_end
JUMP for_end

skip_jump_for_end:
;                player_cell = player_map[i]
ADDI R7, R5, 30; R7 = 64 + R5
ADDI R7, R7, 30
ADDI R7, R7, 4
LB R7, 0(R7); player_cell
SLL R7, R7
SRL R7, R7; clear first bit
ADDI R6, R0, 16; add total of 32, i.e. space
ADDI R6, R6, 16
BEQ R7, R6, first_if
;                if player_cell == ' '

ADDI R6, R0, 30; add total of 63, '?'
ADDI R6, R6, 30
ADDI R6, R6, 3
BNE R7, R6, first_else
;                game_cell = minesweeper_map[i][j]
LB R7, 0(R5)
;                if player_cell == ' ' or (player_cell == '?' and game_cell != 'X'):
ADDI R6, R0, 30; add total of 88 'X'
ADDI R6, R6, 30
ADDI R6, R6, 28
BNE R7, R6, first_else
first_if:
ADD R4, R0, R0; Won = false
JUMP for_end
;                    Won = False
;                    break ; jump out of the double loop
first_else:
ADDI R5, R5, 1
JUMP for
for_end:


;        ack = 0;
ADDI R7, R0, -9; ACK 
SB R0, 0(R7)

;        if Won == False:
BEQ R4, R0, continue_main_if
JUMP main_else
continue_main_if:

;        LOAD move;
ADDI R7, R7, -1; move action
LB R4, 0(R7)
ADD R4, R0, R0

;            if move == 0: ; move comes from click detector output
;                continue
BNE R4, R0, continue_mini_if
JUMP while

continue_mini_if:
;            player_map[x][y][7] = 0
SLL R7, R1; x*2
SLL R7, R7
SLL R7, R7
SLL R7, R7; x*16
ADD R7, R7, R2; x*16+y
ADDI R7, R7, 30
ADDI R7, R7, 30
ADDI R7, R7, 4
LB R5, 0(R7); player_map[x][y]
ADDI R6, R0, -1; create 127
SRL R6, R6
AND R5, R5, R6
SB R5, 0(R7)

skip_mini_if:
;            if (move == 7 and y-1 >= 0): ; L(111)
ADDI R7, R0, 7
BNE R4, R7, elif_1
ADDI R7, R2, -1
BLTZ R7, elif_1
;                y -= 1
ADDI R2, R2, -1
JUMP elif_done
elif_1:
;            elif (move == 5 and y+1 < 16): ; R(101)
ADDI R7, R0, 5
BNE R4, R7, elif_2
ADDI R7, R2, -15
BGEZ R7, elif_2
;                y += 1
ADDI R2, R2, 1
JUMP elif_done
elif_2:
;            elif (move == 4 and x-1 >= 0): ; U(100)
ADDI R7, R0, 4
BNE R4, R7, elif_3
ADDI R7, R1, -1
BLTZ R7, elif_3
;               x -= 1
ADDI R1, R1, -1
JUMP elif_done
elif_3:
;            elif (move == 6 and x + 1 < 4): ; D(110)
ADDI R7, R0, 6
BNE R4, R7, elif_4
ADDI R7, R1, -3
BGEZ R7, elif_4
;                x += 1
ADDI R1, R1, 1
JUMP elif_done
elif_4:
;            elif (move == 1): ; single btnC click(001)
ADDI R7, R0, 1
BEQ R4, R7, continue_elif_4
JUMP elif_5
continue_elif_4:

SLL R7, R1; x*2
SLL R7, R7
SLL R7, R7
SLL R7, R7; x*16
ADD R7, R7, R2; x*16+y
ADDI R7, R7, 30
ADDI R7, R7, 30
ADDI R7, R7, 4
LB R6, 0(R7); player_map[x][y]
SLL R6, R6
SRL R6, R6
;                if player_map[x][y] == '?':
ADDI R6, R6, -30; add to -63
ADDI R6, R6, -30
ADDI R6, R6, -3
BNE R6, R0, not_question
;                   player_map[x][y] = ' '
ADDI R6, R0, 16; add to 32, space
ADDI R6, R6, 16
SB R6, 0(R7)
JUMP elif_done
not_question:
;                elif player_map[x][y] == ' ':
LB R6 0(R7)
ADDI R6, R6, -16; minus blank
ADDI R6, R6, -16
BNE R6, R0, elif_5
;                    player_map[x][y] = '?'
ADDI R6, R0, 30; ?
ADDI R6, R6, 30
ADDI R6, R6, 3
SB R6, 0(R7)

JUMP elif_done

elif_5:
;            elif (move == 2): ; double click on center(010)
ADDI R7, R0, 2
BNE R4, R7, elif_done
;                player_map[x][y] = minesweeper_map[x][y]
SLL R7, R1; x*2
SLL R7, R7
SLL R7, R7
SLL R7, R7; x*16
ADD R7, R7, R2; x*16+y
LB R6, 0(R7)
ADDI R7, R7, 30
ADDI R7, R7, 30
ADDI R7, R7, 4
SB R6, 0(R7)

elif_done:

;            if player_map[x][y] == 'X':
;                dead = True
SLL R7, R1; x*2
SLL R7, R7
SLL R7, R7
SLL R7, R7; x*16
ADD R7, R7, R2; x*16+y
ADDI R7, R7, 30
ADDI R7, R7, 30
ADDI R7, R7, 4
LB R6, 0(R7); player_map[x][y]
SLL R6, R6
SRL R6, R6
ADDI R7, R0, 30; X = 88
ADDI R7, R7, 30
ADDI R7, R7, 28
BNE R6, R7, not_dead
ADDI R3, R0, 1
not_dead:

;           player_map[x][y][7] = 1
SLL R7, R1; x*2
SLL R7, R7
SLL R7, R7
SLL R7, R7; x*16
ADD R7, R7, R2; x*16+y
ADDI R7, R7, 30
ADDI R7, R7, 30
ADDI R7, R7, 4
LB R6, 0(R7)
ORI R6, R6, -1
SB R6, 0(R7)

;            ack = 1
ADDI R7, R0, -9; ACK 
ADDI R6, R0, 15
SB R6, 0(R7)

JUMP while

main_else: ; won
ADDI R7, R0, 2
SB R7, -2(R0)
game_won:
JUMP game_won

end: ; dead
ADDI R7, R0, 6 ;
SB R7, -2(R0)
game_dead:
JUMP game_dead
