    0: ADD  R1, R0, R0
    2: ADD  R2, R0, R0
    4: ADD  R3, R0, R0
    6: BNE  R3, R0, 1
    8: JUMP    160
   10: ADDI R4, R0, 1
   12: ADD  R5, R0, R0
   14: ADDI R7, R0, 30
   16: ADDI R7, R7, 30
   18: ADDI R7, R7, 4
   20: BNE  R5, R7, 1
   22: JUMP    34
   24: ADDI R7, R5, 30
   26: ADDI R7, R7, 30
   28: ADDI R7, R7, 4
   30: LB    R7, 0(R7)
   32: SLL  R7, R7
   34: SRL  R7, R7
   36: ADDI R6, R0, 16
   38: ADDI R6, R6, 16
   40: BEQ  R7, R6, 9
   42: ADDI R6, R0, 30
   44: ADDI R6, R6, 30
   46: ADDI R6, R6, 3
   48: BNE  R7, R6, 7
   50: LB    R7, 0(R5)
   52: ADDI R6, R0, 30
   54: ADDI R6, R6, 30
   56: ADDI R6, R6, 28
   58: BNE  R7, R6, 2
   60: ADD  R4, R0, R0
   62: JUMP    34
   64: ADDI R5, R5, 1
   66: JUMP    7
   68: ADDI R7, R0, -9
   70: SB    R0, 0(R7)
   72: ADDI R7, R7, -1
   74: LB    R4, 0(R7)
   76: SB    R4, -1(R0)
   78: BEQ  R4, R0, 1
   80: JUMP    157
   82: BNE  R4, R0, 1
   84: JUMP    3
   86: SLL  R7, R1
   88: SLL  R7, R7
   90: SLL  R7, R7
   92: SLL  R7, R7
   94: ADD  R7, R7, R2
   96: ADDI R7, R7, 30
   98: ADDI R7, R7, 30
  100: ADDI R7, R7, 2
  102: LB    R5, 0(R7)
  104: ADDI R6, R0, -1
  106: SRL  R6, R6
  108: AND  R5, R5, R6
  110: SB    R5, 0(R7)
  112: ADDI R7, R0, 7
  114: BNE  R4, R7, 4
  116: ADDI R7, R2, -1
  118: BLTZ R7, 2
  120: ADDI R2, R2, -1
  122: JUMP    126
  124: ADDI R7, R0, 5
  126: BNE  R4, R7, 4
  128: ADDI R7, R2, -15
  130: BGEZ R7, 2
  132: ADDI R2, R2, 1
  134: JUMP    126
  136: ADDI R7, R0, 4
  138: BNE  R4, R7, 4
  140: ADDI R7, R1, -1
  142: BLTZ R7, 2
  144: ADDI R1, R1, -1
  146: JUMP    126
  148: ADDI R7, R0, 6
  150: BNE  R4, R7, 4
  152: ADDI R7, R1, -3
  154: BGEZ R7, 2
  156: ADDI R1, R1, 1
  158: JUMP    126
  160: ADDI R7, R0, 1
  162: BEQ  R4, R7, 1
  164: JUMP    111
  166: SLL  R7, R1
  168: SLL  R7, R7
  170: SLL  R7, R7
  172: SLL  R7, R7
  174: ADD  R7, R7, R2
  176: ADDI R7, R7, 30
  178: ADDI R7, R7, 30
  180: ADDI R7, R7, 2
  182: LB    R6, 0(R7)
  184: SLL  R6, R6
  186: SRL  R6, R6
  188: ADDI R6, R6, -30
  190: ADDI R6, R6, -30
  192: ADDI R6, R6, -3
  194: BNE  R6, R0, 4
  196: ADDI R6, R0, 16
  198: ADDI R6, R6, 16
  200: SB    R6, 0(R7)
  202: JUMP    126
  204: LB    R6, 0(R7)
  206: ADDI R6, R6, -16
  208: ADDI R6, R6, -16
  210: BNE  R6, R0, 5
  212: ADDI R6, R0, 30
  214: ADDI R6, R6, 30
  216: ADDI R6, R6, 3
  218: SB    R6, 0(R7)
  220: JUMP    126
  222: ADDI R7, R0, 2
  224: BNE  R4, R7, 13
  226: SLL  R7, R1
  228: SLL  R7, R7
  230: SLL  R7, R7
  232: SLL  R7, R7
  234: ADD  R7, R7, R2
  236: ADDI R7, R7, 30
  238: ADDI R7, R7, 30
  240: ADDI R7, R7, 2
  242: LB    R6, 0(R7)
  244: ADDI R7, R7, -30
  246: ADDI R7, R7, -30
  248: ADDI R7, R7, -2
  250: SB    R6, 0(R7)
  252: SLL  R7, R1
  254: SLL  R7, R7
  256: SLL  R7, R7
  258: SLL  R7, R7
  260: ADD  R7, R7, R2
  262: ADDI R7, R7, 30
  264: ADDI R7, R7, 30
  266: ADDI R7, R7, 2
  268: LB    R6, 0(R7)
  270: ORI  R6, R6, -1
  272: SB    R6, 0(R7)
  274: ADDI R7, R0, -9
  276: ADDI R6, R0, 15
  278: SB    R6, 0(R7)
  280: SLL  R7, R1
  282: SLL  R7, R7
  284: SLL  R7, R7
  286: SLL  R7, R7
  288: ADD  R7, R7, R2
  290: ADDI R7, R7, 30
  292: ADDI R7, R7, 30
  294: ADDI R7, R7, 2
  296: LB    R6, 0(R7)
  298: SLL  R6, R6
  300: SRL  R6, R6
  302: ADDI R7, R0, 30
  304: ADDI R7, R0, 30
  306: ADDI R7, R0, 28
  308: BNE  R6, R7, 1
  310: ADDI R3, R0, 1
  312: JUMP    3
  314: ADDI R7, R0, 2
  316: SB    R7, -2(R0)
  318: JUMP    159
  320: ADDI R7, R0, 6
  322: SB    R7, -2(R0)
  324: JUMP    162
    i: NOP
