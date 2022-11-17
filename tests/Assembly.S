ADD $1, $0, $0
ADDI $1, $1, 1
ADD $3, $0, $0
JUMP 16           // Jumps to addi 7
ADDI $3, $3, 1
ADDI $1, $1, 3
ADDI $1, $1, 4
ADDI $1, $1, 5
ADDI $1, $1, 6
ADDI $1, $1, 7
ADDI $1, $1, 8
ADDI $1, $1, 9
ADDI $1, $1, 10
ADDI $1, $1, 11
JUMP 40           // Jumps to addi 5
ADD $2, $0, $0
ADDI $2, $2, 2
ADDI $2, $2, 3
ADDI $2, $2, 14
ADDI $2, $2, -15
ADDI $2, $2, 6
ADDI $2, $2, 5
BEQ $3, $0, -4
HALT
