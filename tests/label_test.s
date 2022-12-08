ADD $1, $0, $0
ADDI $1, $1, 1
JUMP label_first; Should be JUMP 6
ADDI $1, $1, 1; This is a comment
label_second:
ADDI $1, $1, 1; Another comment
label_first: ; Label test
ADDI $1, $1, 1
ADDI $1, $1, 1
SB R1, -1(R0)
BNE $1, $2, label_second; Should be BNE -5
HALT