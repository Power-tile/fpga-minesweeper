ADD $1, $0, $0
ADDI $1, $1, 1
JUMP 8
ADDI $1, $0, 10
ADDI $1, $1, 1	// Jump 4 goes here
ADDI $1, $1, 1
ADDI $1, $1, 1
ADDI $1, $1, 1
ADDI $1, $1, 1
ADDI $1, $1, 1
ADDI $1, $1, 1
ADDI $1, $1, 1
ADDI $1, $1, 1
ADD $2, $0, $0
JUMP 40
ADDI $2, $2, 2
ADDI $2, $2, 2
ADDI $2, $2, 2
ADDI $2, $2, -10
ADDI $2, $2, 2
ADDI $2, $2, 2	// Jump 40 goes here
BNE $2, $0, 6
JUMP 50
ADD $2, $2, $2
JUMP 44
ADDI $2, $2, -2	// BNE goes here
