#!/usr/bin/python3
#!/usr/bin/env python

# Assembler for MiniMIPS (Illinois CS 233 Honors)
#
# Written by
# - Ryan Wong <ryanw13@illinois.edu>
# - Saugata Ghose <ghose@illinois.edu>
# 
# Last updated 10/13/2022


import os
import sys
import readline

# supress .pyc file - speedup doesn't justify cleanup
sys.dont_write_bytecode = True;

# Globals
version = "1.0" # MiniMIPS

# global variables that maintain processor state
program = [];
debug_mode = False;


# Helpers
def regDecode(reg):
     reg = reg.strip(',')
     return int(reg[1])

def regString(reg):
     reg = reg.strip(',')
     return "{0:{fill}3b}".format(int(reg[1]), fill='0')
     
def immString(imm):
     assert (imm >= -32 and imm <= 31), "Immediate %d out of range" % imm
     if (imm < 0):
        imm += 64
     return "{0:{fill}6b}".format(int(imm), fill='0')
     

########################
# Main Subroutine
########################

def main():
    global program;

    if (len(sys.argv) < 2 or len(sys.argv) > 3):
        usage();

    list_filename = sys.argv[1];
    global list_fh;
    try:
        list_fh = open(list_filename, "r");
    except:
        print("Failed to open assembly file %s" % list_filename);
        exit();
    # read all lines from list_fh, store in array,
    program = [line for line in list_fh.readlines() if line.strip()];

    if (list_fh != None): list_fh.close();
    
    num_insts = len(program);
    
    if(len(sys.argv) > 2):
        print("module " + sys.argv[2] + "(CLK, RESET, ADDR, Q);");
    else:
        print("module iram(CLK, RESET, ADDR, Q);");

    print("  input           CLK;");
    print("  input           RESET;");
    print("  input  [7:0]  ADDR;");
    print("  output [15:0] Q;");
    print("");
    print("  reg     [15:0] mem[0:512]; // instruction memory with 16 bit entries");
    print("");
    print("  wire    [6:0]  saddr;");
    print("  integer        i;");
    print("");
    print("");
    print("  assign saddr = ADDR[7:1];");
    print("  assign Q = mem[saddr];");
    print("");
    print("  always @(posedge CLK) begin");
    print("     if(RESET) begin");

    for i in range(0, num_insts):
        parse_instruction(i);

    if (num_insts < 127):
        print("");
        print("        for(i = " + str(num_insts) + "; i < 512; i = i + 1) begin");
        print("         mem[i] <= 16'b0000000000000000;");
        print("        end");

    print("     end");
    print("  end");
    print("");
    print("endmodule");

# prints usage for simulator
def usage():
    print(sys.argv[0] + " <filename> [<module_name>]");
    exit();

# Generate one instruction
def parse_instruction(lineNum):
    assert (lineNum < 512), "Too many instructions - can only have 512 total."

    instr = program[lineNum]

    rs = 0
    rt = 0
    rd = 0
    imm = 0

    instr = instr.split()
    #INSTR ANY_SPACE R_1 COMMA R_2 COMMA RANDOM 
    
    print("        mem[" + str(lineNum) + "]", end = '');
    if(lineNum < 10):
        print("  ", end = '');
    elif(lineNum < 100):
        print(" ", end = '');
    print(" <= 16'b", end = '');

    instruction = instr[0].upper()
    if (instruction == 'NOP'):
        print("0000000000000000", end = '');
    elif (instruction == 'HALT'):
        print("0000000000000001", end = '');
    elif (instruction == 'JUMP'):
        #Extra decoding
        instr[2] = instr[2].strip(')')
        tmp_instr = instr[2].split('(')
        instr[2] = tmp_instr[1]
        instr.append(tmp_instr[0]) #Gotta love my hax
        imm = int(instr[1])
        print("0001" + immString(imm) + "00", end = '');
    elif (instruction == 'LB'):
        #Extra decoding
        instr[2] = instr[2].strip(')')
        tmp_instr = instr[2].split('(')
        instr[2] = tmp_instr[1]
        instr.append(tmp_instr[0]) #Gotta love my hax
        rt = instr[1]
        rs = instr[2]
        imm = int(instr[3])
        print("0010" + regString(rs) + regString(rt) + immString(imm), end = '');
    elif (instruction == 'SB'):
        instr[2] = instr[2].strip(')')
        tmp_instr = instr[2].split('(')
        instr[2] = tmp_instr[1]
        instr.append(tmp_instr[0]) #Gotta love my hax
        rt = instr[1]
        rs = instr[2]
        imm = int(instr[3])
        print("0100" + regString(rs) + regString(rt) + immString(imm), end = '');
    elif (instruction == 'ADDI'):
        rt = instr[1]
        rs = instr[2]
        imm = int(instr[3])
        print("0101" + regString(rs) + regString(rt) + immString(imm), end = '');
    elif (instruction == 'ANDI'):
        rt = instr[1]
        rs = instr[2]
        imm = int(instr[3])
        print("0110" + regString(rs) + regString(rt) + immString(imm), end = '');
    elif (instruction == 'ORI'):
        rt = instr[1]
        rs = instr[2]
        imm = int(instr[3])
        print("0111" + regString(rs) + regString(rt) + immString(imm), end = '');
    elif (instruction == 'BEQ'):
        rt = instr[1]
        rs = instr[2]
        imm = int(instr[3])
        print("1000" + regString(rs) + regString(rt) + immString(imm), end = '');
    elif (instruction == 'BNE'):
        rt = instr[1]
        rs = instr[2]
        imm = int(instr[3])
        print("1001" + regString(rs) + regString(rt) + immString(imm), end = '');
    elif (instruction == 'BGEZ'):
        rs = instr[1]
        imm = int(instr[2])
        print("1010" + regString(rs) + "000" + immString(imm), end = '');
    elif (instruction == 'BLTZ'):
        rs = instr[1]
        imm = int(instr[2])
        print("1011" + regString(rs) + "000" + immString(imm), end = '');
    elif (instruction == 'ADD'):
        rd = instr[1]
        rs = instr[2]
        rt = instr[3]
        print("1111" + regString(rs) + regString(rt) + regString(rd) + "000", end = '');
    elif (instruction == 'SUB'):
        rd = instr[1]
        rs = instr[2]
        rt = instr[3]
        print("1111" + regString(rs) + regString(rt) + regString(rd) + "001", end = '');
    elif (instruction == 'SRA'):
        rd = instr[1]
        rs = instr[2]
        print("1111" + regString(rs) + "000" + regString(rd) + "010", end = '');
    elif (instruction == 'SRL'):
        rd = instr[1]
        rs = instr[2]
        print("1111" + regString(rs) + "000" + regString(rd) + "011", end = '');
    elif (instruction == 'SLL'):
        rd = instr[1]
        rs = instr[2]
        print("1111" + regString(rs) + "000" + regString(rd) + "100", end = '');
    elif (instruction == 'AND'):
        rd = instr[1]
        rs = instr[2]
        rt = instr[3]
        print("1111" + regString(rs) + regString(rt) + regString(rd) + "101", end = '');
    elif (instruction == 'OR'):
        rd = instr[1]
        rs = instr[2]
        rt = instr[3]
        print("1111" + regString(rs) + regString(rt) + regString(rd) + "110", end = '');
    else:
        raise Exception('Unknown Instruction: %s' % (instruction))
    
    print(";    // " + program[lineNum][:-1]);


main();
