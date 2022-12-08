ADD $1, $0, $0
ADDI $1, $1, 1
; Single line comment test
BNE $1, $7, label_first; Should be BNE 3
JUMP label_first; Should be JUMP 6
ADDI $1, $1, 1; This is a comment
; another one
label_second:
; another one
ADDI $1, $1, 1; Another comment
label_first: ; Label test
ADDI $1, $1, 1
ADDI $1, $1, 1
SB R1, -1(R0)
BNE $1, $2, label_second; Should be BNE -5
HALT