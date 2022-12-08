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
; BNE R3, R0, skip_jump_end
; JUMP end; DEBUG dont jump end what will happen?

;        ack = 0;
SB R0, -9(R0)

;        LOAD move;
LB R4, -10(R0)

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
LB R6, 0(R7)
SLL R6, R6
SRL R6, R6
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
ADDI R5, R0, 16
SLL R5, R5
SLL R5, R5
SLL R5, R5
AND R6, R6, R5
SB R6, 0(R7)

;            ack = 1
ADDI R6, R0, 15
SB R6, -9(R0)

JUMP while
