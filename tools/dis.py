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
from re import match, IGNORECASE
from optparse import OptionParser

# supress .pyc file - speedup doesn't justify cleanup
sys.dont_write_bytecode = True;

# Globals
version = "1.0" # MiniMIPS

# global variables
program = [];
clean_print = False;
debug_mode = False;


# Helpers
# parses the user supplied flags and sets globals
def parseInput():
    parser = OptionParser();
    parser.add_option("-v", "--version", action = "store_true",
                            dest = "get_version", default = False,
                            help="Prints the version, then exits");
    parser.add_option("-c", "--clean", action = "store_true",
                            dest = "clean_print", default = False,
                            help="Prints instructions without PC");

    (options, args) = parser.parse_args();

    if (options.get_version):
        print("minimips " + str(version));
        exit();

    global clean_print;
    clean_print = options.clean_print;

    return args;

     

########################
# Main Subroutine
########################

def main():
    global program;

    args = parseInput();

    if (len(args) != 1):
        usage();

    list_filename = args[0];
    global list_fh;
    try:
        list_fh = open(list_filename, "r");
    except:
        print("Failed to open file %s" % list_filename);
        exit();
    # read all lines from list_fh, store in array,
    program = [line for line in list_fh.readlines() if line.strip()];

    if (list_fh != None): list_fh.close();

    
    for currentLine in range(0, len(program)):
        line = program[currentLine];
        
        if (line.find("mem[") == -1 or line.find("<=") == -1):
            continue;
        
        PC = line[line.find("mem[") + 4 : line.find("]")];
        
        if (not clean_print):
            if (PC != "i"):
                PC = str(int(PC) * 2);
                
            print("%5s: " % PC, end = '');
        elif (PC == "i"):
            continue;
        
        instr = line[line.find("16'b") + 4 : line.find("16'b") + 20];
        
        op = instr[0:4]
        reg1 = int(instr[4:7], 2)
        reg2 = int(instr[7:10], 2)
        reg3 = int(instr[10:13], 2)
        func = instr[13:16]
        imm = int(instr[10:16], 2)
        if(imm > 31):
            imm -= 64;
        
        if (op == "0000"):
            if (func == "000"):
                print("NOP");
            elif (func == "001"):
                print("HALT");
            else:
                print("????");
        elif (op == "1111"):
            if (func == "000"):
                print("ADD  ", end = '');
            elif (func == "001"):
                print("SUB  ", end = '');
            elif (func == "010"):
                print("SRA  ", end = '');
            elif (func == "011"):
                print("SRL  ", end = '');
            elif (func == "100"):
                print("SLL  ", end = '');
            elif (func == "101"):
                print("AND  ", end = '');
            elif (func == "110"):
                print("OR    ", end = '');
            else:
                print("???? ", end = '');
            print("R%d, " % reg3, end = '');
            print("R%d" % reg1, end = '');
            if (func != "010" and func != "011" and func != "100"):
                print(", R%d" % reg2);
            else:
                print("");
        elif (op == "0001"):
            print("JUMP    %d" % (instr[7:16]));
        elif (op == "0010"):
            print("LB    R%d, %d(R%d)" % (reg2, imm, reg1));
        elif (op == "0100"):
            print("SB    R%d, %d(R%d)" % (reg2, imm, reg1));
        elif (op == "0101"):
            print("ADDI R%d, R%d, %d" % (reg2, reg1, imm));
        elif (op == "0110"):
            print("ANDI R%d, R%d, %d" % (reg2, reg1, imm));
        elif (op == "0111"):
            print("ORI  R%d, R%d, %d" % (reg2, reg1, imm));
        elif (op == "1000"):
            print("BEQ  R%d, R%d, %d" % (reg2, reg1, imm));
        elif (op == "1001"):
            print("BNE  R%d, R%d, %d" % (reg2, reg1, imm));
        elif (op == "1010"):
            print("BGEZ R%d, %d" % (reg1, imm));
        elif (op == "1011"):
            print("BLTZ R%d, %d" % (reg1, imm));
        else:
            print("???? ", end = '');

# prints usage for simulator
def usage():
    print(sys.argv[0] + " [-c] <filename>");
    exit();


main();
