ADD $1, $0, $0
ADDI $1, $1, 1
JUMP 4
ADDI $1, $0, 10
ADDI $1, $1, 1
ADDI $1, $1, 1
ADDI $1, $1, 1
ADDI $1, $1, 1
ADDI $1, $1, 1
ADDI $1, $1, 1
ADDI $1, $1, 1
ADDI $1, $1, 1
ADDI $1, $1, 1
ADD $2, $0, $0
JUMP 20
ADDI $2, $2, 2
ADDI $2, $2, 2
ADDI $2, $2, 2
ADDI $2, $2, -10
ADDI $2, $2, 2
ADDI $2, $2, 2
BNE $2, $0, 3
JUMP 25
ADD $2, $2, $2
JUMP 22
ADDI $2, $2, -2
HALT
