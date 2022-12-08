#!/usr/bin/python3
#!/usr/bin/env python

# Simulator for MiniMIPS (Illinois CS 233 Honors)
#
# Written by
# - Ryan Wong <ryanw13@illinois.edu>
# - Saugata Ghose <ghose@illinois.edu>
#
# Based on RISC240 and P18240 scripts at CMU by
# Deanyone Su, Neil Ryan, and Paul Kennedy
# 
# Last updated 10/24/2022


from optparse import OptionParser
from getpass import getuser
from datetime import datetime
import os
import sys
from re import match, IGNORECASE
from random import randint
import signal
import readline

from mem import Memory, mmio_locations


# supress .pyc file - speedup doesn't justify cleanup
sys.dont_write_bytecode = True;

# Globals
version = "1.0.1" # MiniMIPS

transcript = ""; # holds transcript of every line printed

randomize_memory = True; # flag that randomizes the memory
use_mmio = True; # flag that controls whether memory-mapped IO is used
run_only = False; # flag that just does "run, quit"
piping = False; # flag that reads list file from STDIN (pipe from as240)
transcript_fname = ""; # filename of transcript file, provided with -t flag
mem_fname = ""; # filename of memory file, provided with -m flag
check_file = ""; # file to check state against in grading mode
quit_after_sim_file = False; # if -g is set and a sim file is provided,
                             # we quit after running the sim file

# Tab completion for user input
# commands = ['labels', 'lsbrk', 'quit', 'exit', 'help', 'run', 'reset',
#             'step', 'save', 'clear', 'load', 'check', 'break',
#             'mem[']
commands = ['lsbrk', 'quit', 'exit', 'help', 'run', 'reset',
            'step', 'clear', 'break', 'instr',
            'mem[', 'sw[', 'lsio']
def complete(text, state):
    for cmd in commands:
        if cmd.startswith(text):
            if not state:
                return cmd
            else:
                state -= 1

readline.parse_and_bind("tab: complete");
readline.set_completer(complete);
# end of tab completion

# Signal handler for SIGINTs
def sigint_handler(signal, frame):
    print("\nUnexpected input, did you forget to quit?");
    exit();

signal.signal(signal.SIGINT, sigint_handler);


wide_header = "\n--Cycle--  -PC-  Inst  nxtPC   -R0-  -R1-  -R2-  -R3-  -R4-  -R5-  -R6-  -R7-";


# print_per is a variable which determines when the simulator prints the state
# to the console.
# 'i' prints the state on every instruction. '
# 'q' is for 'quiet'; it does not ever print
print_per = "i";


# first_print controls whether the first line is printed during a run
first_print = False;


# global variables that maintain processor state
registers = [];
mem = [];
PC = -2;
nextPC = 0;
program = [];
instruction = "";
instruction_length = 0;
debug_mode = False;
halted = True;

cycle_num = 0; # global cycle counter


# MINIMIPS: labels are not yet supported
# keys are label strings, values are addresses
# labels = {};

# keys are addresses, value is always 1
breakpoints = {};

# keys are strings indicating menu option
# values are regex's which match the input for the corresponding menu option
menu = {
    'quit'    : '^\s*(q(uit)?|exit)\s*$',
    'help'    : '^\s*(\?|h(elp)?)\s*$',                             # ? ; h ; help
    'reset'   : '^\s*reset\s*$',
    'run'     : '^\s*r(un)?\s*(\d*)\s*([qi])?\s*$',                 # run ; run 5q ; r 6i
    'step'    : '^\s*s(tep)?$',                                     # s ; step
    'break'   : '^\s*break\s+(\'?\w+\'?|\[0-9]{1,3})\s*$',          # break [addr]
    'clear'   : '^\s*clear\s+(\*|\'?\w+\'?|\[0-9]{1,3})\s*$',       # clear [addr/*]
    'lsbrk'   : '^\s*lsbrk\s*$',
    'instr'   : '^\s*i(nstr)?\s*$',                                 # i ; instr
    # 'load'    : '^\s*load\s+([\w\.]+)\s*$',                         # load [file]
    # 'save'    : '^\s*save\s+([\w\.]+)\s*$',                         # save [file]
    'set_reg' : '^\s*(\*|pc|nxtpc|r[0-7])\s*=\s*(-?[0-9]{1,3})$',
    'get_reg' : '^\s*(\*|pc|nxtpc|state|r[0-7*])\s*\?$',
    'set_mem' : '^\s*m(em)?\[([0-9]{1,3})\]\s*=\s*([0-9]{1,3})$',   # m[10] = 0a10
    'get_mem' : '^\s*m(em)?\[([0-9]{1,3}|IO[A-H])(:([0-9]{1,3}))?\]\s*\?$', # m[50]? ; mem[10:20]?
    'set_sw' : '^\s*sw(itch)?\[([0-9]{1,2})\]\s*=\s*([01])$',       # sw[10] = 1
    'get_sw' : '^\s*sw(itch)?\[([0-9]{1,2})(:([0-9]{1,2}))?\]\s*\?$', # sw[0]? ; switch[3:10]?
    'lsio'   : '^\s*lsio\s*$',
    # 'check' : '^\s*check\s+([\w\.]+)\s*$',                          # check [state filename]
    # 'labels' : '^\s*labels\s*$',
};

# file handles
list_fh = None;
sim_fh = None;
mem_fh = None;


## Helpers
def regDecode(reg):
    reg = reg.strip(',')
    return int(reg[1])
    
def make8Bit(val, signed = True):
    # first, crop to 8 bits
    byte = val & 0xff
    
    # then, convert to signed
    if (signed == True and byte > 127):
        byte = byte - 256

        assert (byte < 128 and byte >= -128), 'INVALID 8-BIT CONVERSION: Please report this bug to course staff'
    else:
        assert (byte < 256 and byte >= 0), 'INVALID 8-BIT CONVERSION: Please report this bug to course staff'

    return byte

def alignPC(addr):
    return addr & 0xfe

def signExtend(val):
    if (val > 31):
        val = val - 64 # treat number as negative
 
    assert (val < 32 and val >= -32), 'INVALID IMMEDIATE: Can your immediate be represented using the number of bits allocated in this ISA?'
    return val


########################
# Main Subroutine
########################

def main():
    global program;
    global instruction_length;

    args = parseInput();

    tran("User: " + getuser() + "\n");
    tran("Date: " + datetime.now().strftime("%a %b %d %Y %I:%M:%S%p") + "\n");
    tran("Arguments: " + str(args) + "\n\n");

    if (piping): # reading list file from assembler
        while(True):
            try:
                line = input();
                if (len(line) > 0): #reading will grab empty lines
                    program.append(line);
            except EOFError: break; # no more lines to read
        tran_print("Running assembly from piped input");
    else:
        if (len(args) < 1): #args takes out flags and argv[0]
            usage();
        list_filename = args.pop(0);
        global list_fh;
        try:
            list_fh = open(list_filename, "r");
        except:
            tran_print("Failed to open list_file %s" % list_filename);
            exit();
        # read all lines from list_fh, store in array,
        program = [line for line in list_fh.readlines() if line.strip()];
        tran_print('Running assembly from %s' % (list_filename));

    instruction_length = len(program);

    init();

    interface(sim_fh); #start taking input from user
    save_tran(); #save transcript

    if (sim_fh != None): sim_fh.close();
    if (list_fh != None): list_fh.close();

# parses the user supplied flags and sets globals
def parseInput():
    parser = OptionParser();
    parser.add_option("-v", "--version", action = "store_true",
                      dest = "get_version", default = False,
                      help="Prints the version, then exits");
    parser.add_option("-r", "--run", action = "store_true",
                      dest = "run_only", default = False,
                      help="Runs simulation, then exits");
    parser.add_option("-n", "--norandom", action = "store_false",
                      dest = "randomize_memory", default=True,
                      help="Initializes memory to zeros, instead of random");
    parser.add_option("-t", "--transcript", action = "store",
                      dest = "transcript_fname", default = "", type = "str",
                      help="Stores transcript of simulator in given file");
    parser.add_option("-m", "--memory", action = "store",
                      dest = "mem_fname", default = "", type = "str",
                      help="Loads memory values from file");
    parser.add_option("-q", "--quiet", action = "store_true",
                      dest = "quiet_mode", default = False,
                      help="Doesn't print output with step");
    parser.add_option("-s", "--noswitches", action = "store_false",
                      dest = "use_mmio", default = True,
                      help="Disables switches and memory-mapped IO");
    # parser.add_option("-g", "--grade", default = "", type = "str",
    #                   action = "store", dest = "check_file",
    #                   help="Runs simulation, checks state against file,\
    #                   then exits");
    parser.add_option("-i", default = False, dest = "pipe",
                      action = "store_true", help="Takes list file from STDIN.");

    (options, args) = parser.parse_args();
    if (options.get_version):
        print("minimips " + str(version));
        exit();

    global run_only;
    run_only = options.run_only;

    global print_per;
    if (options.quiet_mode): print_per = "q";

    # global check_file;
    # if (options.check_file): #empty string (default) is false
    #    check_file = options.check_file;
    #    print_per = "q";

    global randomize_memory;
    randomize_memory = options.randomize_memory;

    global transcript_fname;
    transcript_fname = options.transcript_fname;

    global mem_fname;
    mem_fname = options.mem_fname;
    
    global use_mmio;
    use_mmio = options.use_mmio;

    global piping;
    piping = options.pipe;
    if (options.pipe and not (run_only or options.check_file)):
        print("Must use -r or -g flag when piping!");
        exit();

    return args;

# initalizes the simulator
def init():
    # get_labels();

    init_minimips(); # put CPU into a known state
    init_memory();   # put memory into a starting state

# prints usage for simulator
def usage():
    tran_print("./minimips [list_file] [sim_file]");
    exit();

# MINIMIPS: Labels not currently supported
# Reads label from list file and adds them to the labels hash.
# Currently based on spacing format of list file.
# def get_labels():
#     # check each line for a label
#     global labels;
#     for line in list_lines:
#         if (len(line) < 11): continue; #must not be a label on this line
#         addr = line[0:4];
#         line_start_at_label = line[11:];
#         end_of_label = line_start_at_label.find(' '); #first space (label end)
#         label = line_start_at_label[0:end_of_label].upper();
#         labels[label] = addr;

# Interface Code
# Loop on user input executing commands until they quit
# Arguments:
#  * file handle for sim file.
# Return value:
#  * None
def interface(input_fh):
    done = False; # flag indicating user is done and wants to quit

    #take user input if reading from stdin
    taking_user_input = (input_fh == None);

    if (run_only):
        run("", "");
        # if (check_file): check_state(check_file); # in grading mode, so grade
        done = True;

    while (not done):
        tran("> ");
        if (not taking_user_input): # we are reading from sim file
            line = input_fh.readline();
            if (len(line) == 0):
                taking_user_input = True;
                if (quit_after_sim_file):
                    check_state(check_file);
                    done = True;
                continue;
            if (not check_file): #in grading mode
                tran_print(line.rstrip("\n"));
        else:
            try: line = input("> ");
            except EOFError:
                print("\nUnexpected input, did you forget to quit?");
                exit();
            tran(line);

        # assume user input is valid until discovered not to be
        valid = True;
        #line = line.upper(); #should be independent of case
        if (match(menu["quit"], line, IGNORECASE)):
            done = True;
        elif (match(menu["help"], line, IGNORECASE)):
            print_help();
        elif (match(menu["reset"], line, IGNORECASE)):
            init();
        elif (match(menu["run"], line, IGNORECASE)):
            matchObj = match(menu["run"], line, IGNORECASE);
            run(matchObj.group(2), matchObj.group(3));
        elif (match(menu["step"], line, IGNORECASE)):
            if (print_per != "q"): tran_print(wide_header);
            cycle();
            if (print_per != "q"): tran_print(get_state());
        elif (match(menu["break"], line, IGNORECASE)):
            matchObj = match(menu["break"], line, IGNORECASE);
            set_breakpoint(matchObj.group(1));
        elif (match(menu["clear"], line, IGNORECASE)):
            matchObj = match(menu["clear"], line, IGNORECASE);
            clear_breakpoint(matchObj.group(1));
        elif (match(menu["lsbrk"], line, IGNORECASE)):
            list_breakpoints();
        elif (match(menu["instr"], line, IGNORECASE)):
            print_last_instruction();
        # elif (match(menu["load"], line, IGNORECASE)):
        #     matchObj = match(menu["load"], line, IGNORECASE);
        #     load(matchObj.group(1));
        # elif (match(menu["save"], line, IGNORECASE)):
        #     matchObj = match(menu["save"], line, IGNORECASE);
        #     save(matchObj.group(1));
        elif (match(menu["set_reg"], line, IGNORECASE)):
            matchObj = match(menu["set_reg"], line, IGNORECASE);
            set_reg(matchObj.group(1), matchObj.group(2));
        elif (match(menu["get_reg"], line, IGNORECASE)):
            matchObj = match(menu["get_reg"], line, IGNORECASE);
            get_reg(matchObj.group(1));
        elif (match(menu["set_mem"], line, IGNORECASE)):
            matchObj = match(menu["set_mem"], line, IGNORECASE);
            set_memory(matchObj.group(2), matchObj.group(3));
        elif (match(menu["get_mem"], line, IGNORECASE)):
            matchObj = match(menu["get_mem"], line, IGNORECASE);
            fget_memory({"lo" : matchObj.group(2),
                         "hi" : matchObj.group(4)});
        elif (match(menu["set_sw"], line, IGNORECASE)):
            matchObj = match(menu["set_sw"], line, IGNORECASE);
            set_switch(matchObj.group(2), matchObj.group(3));
        elif (match(menu["get_sw"], line, IGNORECASE)):
            matchObj = match(menu["get_sw"], line, IGNORECASE);
            get_switch({"lo" : matchObj.group(2),
                        "hi" : matchObj.group(4)});
        elif (match(menu["lsio"], line, IGNORECASE)):
            list_io();
        # elif (match(menu["check"], line, IGNORECASE)):
        #     matchObj = match(menu["check"], line, IGNORECASE);
        #     check_state(matchObj.group(1));
        # elif (match(menu["labels"], line, IGNORECASE)):
        #     print_labels();
        elif (match("^$", line, IGNORECASE)): # user just struck enter
            pass; # something needs to be here for python
        else:
            valid = False;

        if (not valid): tran_print("Invalid input. Type 'help' for help.");

# prints help message
def print_help():
    global use_mmio;
    
    help_msg = '';
    help_msg += "\n";
    help_msg += "quit,q,exit             Quit the simulator.\n";
    help_msg += "help,h,?                Print this help message.\n";
    help_msg += "step,s                  Simulate one instruction.\n";
    help_msg += "run,r [n]               Simulate the next n instructions.\n";
    # help_msg += "break [addr/label]      Set a breakpoint at PC [addr] or [label].\n";
    help_msg += "break [addr]            Set a breakpoint at PC [addr].\n";
    help_msg += "lsbrk                   List all set breakpoints.\n";
    # help_msg += "clear [addr/label/*]    Clear breakpoint at [addr]/[label], or clear all.\n";
    help_msg += "clear [addr/*]          Clear breakpoint at [addr], or clear all.\n";
    help_msg += "instr                   Print the last instruction executed.\n";
    if (use_mmio):
        help_msg += "lsio                    List current values in memory-mapped IO.\n";
    help_msg += "reset                   Reset the processor to initial state.\n";
    # help_msg += "save [file]             Save the current state to a file.\n";
    # help_msg += "load [file]             Load the state from a given file.\n";
    # help_msg += "check [file]            Checks state against state described in file.\n";
    # help_msg += "labels                  Prints the lables described in the .list file.\n";
    help_msg += "\n";
    help_msg += "You may set registers like so:          PC=100 (or R2=-53)\n";
    help_msg += "You may view register contents like so: PC?\n";
    help_msg += "You may view the register file like so: R*?\n";
    help_msg += "You may view all registers like so:     *?\n";
    help_msg += "\n";
    help_msg += "You may set memory like so:  m[233]=100\n";
    help_msg += "You may view memory like so: m[102]? or with a range: m[0:63]?\n";
    help_msg += "\n";
    if (use_mmio):
        help_msg += "You may set switches like so:          sw[9]=1\n";
        help_msg += "You may view switches like so:         sw[3]? or with a range: sw[8:11]?\n";
        help_msg += "You may view memory-mapped IO like so: m[IOC]?\n";
    help_msg += "\n";
    help_msg += "**NOTE: All constants are interpreted as decimal numbers.**";
    tran_print(help_msg);


def init_minimips():
    global registers;
    global PC; 
    global nextPC; 

    global cycle_num;
    cycle_num = 0;

    # init my registers
    registers = [0] * 8

    PC = -2
    nextPC = 0
 
    tran_print("Resetting processor to known state");


def init_memory():
    global mem;
    global mem_fname;
    global randomize_memory;
    global use_mmio;

    mem = Memory(256, randomize_memory, use_mmio)
    
    if (mem_fname != ""):
        load_mem_file(mem_fname)


# Load preset memory values from a
# user-specified file
def load_mem_file(filename):
    global mem;
    global mem_fh;
    
    try:
        mem_fh = open(filename, "r");
    except:
        tran_print("Failed to open mem_file %s" % filename);
        exit();
    
    tran_print("Loading memory from %s" % (filename));

    for line in mem_fh.readlines():
        if (line.find("m[") == -1):
            continue;
        
        addr = int(line[line.find("m[") + 2 : line.find("]")]);
        
        line = line.replace('_', '');
        
        value_end = line.find(";");
        if (value_end == -1):
            value_end = line.find("//");
        if (value_end == -1):
            value_end = len(line);
        
        value_start = line.find("'b", 0, value_end);
        value_base = 2;
        if (value_start == -1):
            value_start = line.find("'h", 0, value_end);
            value_base = 16;
        if (value_start == -1):
            value_start = line.find("0x", 0, value_end);
            value_base = 16;
        if (value_start == -1):
            value_start = line.find("'d", 0, value_end)
            value_base = 10;
        if (value_start == -1):
            value = int(line[line.find("=") + 1 : value_end])
        else:
            value = int(line[value_start + 2 : value_end], value_base)
            
        mem.storeByte(addr, make8Bit(int(value)));



# Run simulator for n instructions
# If n is undefined, run indefinitely
# In either case, the exception is to stop
# at breakpoints or the HALT instruction
# print_per_requested is how often state is printed
# (per Instruction, Quiet)
def run(num, print_per_requested):
    global nextPC;

    num = int(num) if num else (1 << 32); # num = None if not defined

    global print_per;
    global first_print;
    old_print_per = print_per;
    if (print_per_requested):
        print_per = print_per_requested;
    if (print_per != "q"):
        tran_print(wide_header);

    # if not first_print:
    #    if (print_per != "q"):
    #       tran_print(get_state());
    #    first_print = True;

    for i in range(num):
        step();
        if (print_per == "i"):
            tran_print(get_state());
        if (nextPC in breakpoints):
            tran_print("Hit breakpoint at PC = " + str(nextPC) + ".\n");
            break;

        # stop looping if we encounter a HALT instruction
        if (halted):
            break;

    print_per = old_print_per;

# Simulate one instruction
def step():
    global first_print;
    first_print = True;
    cycle(); # do-while in python

# Set a break point at a given address or label.
# Any thing which matches a hex value (e.g. a, 0B, etc) is interpreted
# as such *unless* it is surrounded by '' e.g. 'A' in which case it is
# interpreted as a label and looked up in the labels hash.
# Anything which does not match a hex value is also interpreted as a label
# with or without surrounding ''.
def set_breakpoint(arg):
    is_label = False;
    # if (match("^'(\w+)'$", arg)):
    #    label = match("^'(\w+)'$", arg).group(1).upper();
    #    is_label = True;
    # elif (match("^\$[0-9a-f]{1,4}$", arg, IGNORECASE)):
    if (match("^[0-9]{1,3}$", arg, IGNORECASE)):
        if (int(arg) > 255):
             tran_print("Invalid breakpoint.");
             return;
        addr = alignPC(int(arg));
    else:
        # is_label = True;
        # label = arg.upper();
        tran_print("Invalid breakpoint.");
        return;

    # if (is_label):
    #     if (label in labels):
    #         addr = labels[label];
    #     else:
    #         tran_print("Invalid label.");
    #         return;

    global breakpoints;
    breakpoints[addr] = 1;

# Clears a breakpoint at a given address or label
def clear_breakpoint(arg):
    clear_all = False;
    is_label = False;

    # if (match("^'(\w+)'$", arg)):
    #     label = match("^'(\w+)'$", arg).group(1).upper();
    #     is_label = True;
    # elif (match("^\$[0-9a-f]{1,4}$", arg, IGNORECASE)):
    if (match("^[0-9]{1,3}$", arg, IGNORECASE)):
        if (int(arg) > 255):
             tran_print("Invalid breakpoint.");
             return;
        addr = alignPC(int(arg));
    elif (arg == "*"):
        clear_all = True;
    else:
        # label = arg.upper();
        # is_label = True;
        tran_print("Invalid breakpoint.");
        return;

    # if (is_label):
    #     if (label in labels):
    #         addr = labels[label];
    #     else:
    #         tran_print("Invalid label.");
    #         return;

    global breakpoints;
    if (clear_all):
        breakpoints = {};
    else:
        if (addr in breakpoints):
            del breakpoints[addr];
        else: #no break point at that address
            # if (is_label):
            #    tran_print("No breakpoint at " + label + ".");
            # else:
                tran_print("No breakpoint at PC = " + str(addr) + ".");

# Print out all of the breakpoints and the addresses.
def list_breakpoints():
    for key in breakpoints:
        tran_print("PC = " + str(key));


# Print out the last instruction executed by the simulator
def print_last_instruction():
    global PC;
    global program;
    
    if (PC < 0):
        tran_print("No instruction executed yet.");
    else:
        tran_print(program[int(PC / 2)][:-1]);


# Sets the value of a register
def set_reg(reg_name, value):
    global registers;
    global nextPC;
   
    reg_name = reg_name.upper(); # keys stored as uppercase

    if (int(value) < -128 or int(value) > 255):
        tran_print("Value must be a valid 8-bit signed or unsigned integer.");
        return;

    if (match('^R([0-7])$', reg_name, IGNORECASE)):
        registers[regDecode(reg_name)] = make8Bit(int(value));
    elif (match("^PC$", reg_name, IGNORECASE) or match("^nxtPC$", reg_name, IGNORECASE)):
        nextPC = alignPC(int(value));
    else:
        tran_print("Unsupported register name " + reg_name);

# Gets the value of a register
def get_reg(reg_name):
    global registers;
    global PC;
    global nextPC;
   
    reg_name = reg_name.upper();
    if (reg_name == "*" or reg_name == "STATE"):
        tran_print(wide_header);
        tran_print(get_state());
    elif (reg_name == "R*"):
        print_regfile();
    elif (match("R([0-7])", reg_name, IGNORECASE)):
        regID = regDecode(reg_name);
        tran_print("R%d: 0x%02x (%4d)" % (regID, registers[regID] & 0xff, registers[regID]));
    elif (match("^PC$", reg_name, IGNORECASE) or match("^nxtPC$", reg_name, IGNORECASE)):
        tran_print("lastPC: %d; nextPC = %d" % (PC, nextPC));
    else:
        tran_print("Unsupported register name " + reg_name);

# Gets a string containing all the state information
def get_state():
    global registers;
    global PC;
    global nextPC;
    global instruction;
    global cycle_num;
   
    state_info =  "%9d  " % cycle_num;
    state_info += "%4d  " % PC;
    state_info += "%s" % instruction;
    state_info += " " * (7 - len(instruction));
    state_info += "%4d   " % nextPC;
   
    for reg in registers:
        state_info += "0x%02x  " % (reg & 0xff);

    state_info += "\n"
    state_info += " " * 31
   
    for reg in registers:
        state_info += "%4d  " % reg;

    return state_info;

# prints the state of R0-R7
def print_regfile():
    global registers;
   
    for index in range(0,8,2):
        value = registers[index];
        reg_str = "R%d: 0x%02x (%4d) \t" % (index, value & 0xff, value);
        value = registers[index+1];
        reg_str += "R%d: 0x%02x (%4d)" % (index + 1, value & 0xff, value);
        tran_print(reg_str);


def set_memory(mem_addr, value):
    global mem;

    addr = int(mem_addr);

    if (addr < 0 or addr >= mem.size):
        tran_print("Error: mem[%d] out of range. Address must be between 0 and %d." % (addr, mem.size - 1));
        return;

    mem.storeByte(addr, make8Bit(int(value)));
 

# Gets the state of a selection of memory, arguments are passed in a dict
# get_zeros specifies if zeros will be printed when they are reached
# lo - the inclusive lower bound of memory
# hi - the inclusive upper bound
# fh - file handle to write memory state to, default to STDOUT
def fget_memory(args):
    global use_mmio;
    global mem;
    global mmio_locations;

    if ("zeros" in args):
        print_zeros = args["zeros"];
    else:
        print_zeros = True;
    
    if (args["lo"] in mmio_locations):
        if (use_mmio):
            lo = mmio_locations[args["lo"]];
        else:
            tran_print("Memory-mapped IO disabled.");
            return;
    else:
        lo = int(args["lo"]);
    if ("hi" in args and args["hi"] != None):
        if (args["hi"] in mmio_locations):
            if (use_mmio):
                hi = mmio_locations[args["hi"]];
            else:
                tran_print("Memory-mapped IO disabled.");
                return;
        else:
            hi = int(args["hi"]);
    else:
        hi = lo;

    if (lo > hi):
        tran_print("Did you mean mem[%d:%d]?" % (hi,lo));
        return;
   
    if(lo < 0 or hi >= mem.size):
        tran_print("Error: mem[%d:%d] out of range. Addresses must be between 0 and %d." % (lo, hi, mem.size - 1));
        return;

    for index in range(lo, hi+1, 1):
        value = mem.loadByte(index);
        # Value in memory location that we care about
        if (value != 0 or print_zeros):
            mem_val = "mem[%3s] = %5d  // 0x%02x" % (index, value, value & 0xff);
            if ("fh" in args and memory[addr][1]): # only save used memory
                args["fh"].write(mem_val + "\n");
            elif ("fh" not in args):
                tran_print(mem_val);


# Sets the value of a switch
def set_switch(switchID, value):
    global mem;
    
    bit = int(value);
    
    if (not use_mmio):
        tran_print("Memory-mapped IO disabled. Switch not set.");
        return;
    
    if (bit != 0 and bit != 1):
        tran_print("Value must be a 0 or a 1.");
        return;
    
    mem.setSwitch(int(switchID), bit);
        

# Gets the state of a selection of switches, arguments are passed in a dict
# lo - the inclusive lower bound of memory
# hi - the inclusive upper bound
def get_switch(args):
    global use_mmio;
    global mem;

    if (not use_mmio):
        tran_print("Memory-mapped IO disabled. Switches not available.");
        return;
    
    lo = int(args["lo"]);
    if ("hi" in args and args["hi"] != None):
        hi = int(args["hi"]);
    else:
        hi = lo;

    if (lo > hi):
        tran_print("Did you mean mem[%d:%d]?" % (hi,lo));
        return;
   
    if(lo < 0 or hi > 11):
        tran_print("Error: mem[%d:%d] out of range. Addresses must be between 0 and 11." % (lo, hi));
        return;

    for index in range(lo, hi+1, 1):
        value = mem.getSwitch(index);
        # Value in switch that we care about
        mem_val = "sw[%2s] = %1d" % (index, value);
        
        tran_print(mem_val);


# Prints a string listing all of the values in
# memory-mapped IO (e.g., switches, LEDs, seven-segments)
def list_io():
    global use_mmio;
    global mem;
    global mmio_locations;
    
    if (not use_mmio):
        tran_print("Memory-mapped IO disabled. IO list not available.");
        return;
    
    header = ""
    value_hex = ""
    value_int = ""
    
    for io_label in mmio_locations:
        header     += "%3s: %3d  " % (io_label, mmio_locations[io_label]);
        value = mem.loadByte(mmio_locations[io_label]);
        value_hex  += "  0x%02x    " % (value & 0xff);
        value_int  += "  %4d    " % value;
    
    if (header != ""):
        tran_print(header);
        tran_print(value_hex);
        tran_print(value_int)


# Prints all the labels associated with the given .list file
def print_labels():
    for key in labels:
        if (len(key) > 0): # ignores spuriously created labels
            tran_print(key + ": " + labels[key])
            if (key == "VALID"):
                fget_memory({"lo":labels[key]})



########################
# Simulator Code
########################

# Simulate one cycle in the processor
def cycle():
    global registers;
    global mem;
    global PC; 
    global nextPC;
    global program;
    global instruction_length;
    global debug_mode;
    global halted;
    global instruction;
    global print_per;

    global cycle_num;
   
    PC = nextPC;

    assert PC % 2 == 0, 'PC MUST BE DIVISIBLE BY 2'
    instr_pc = int(PC/2)
    instr = program[instr_pc]

    rs = 0
    rt = 0
    rd = 0
    imm = 0

    take_alt_pc = False
    alt_pc = 0
    halted = False;
 
    instr = instr.split(":")[-1]
    instr = instr.split()
    #INSTR ANY_SPACE R_1 COMMA R_2 COMMA RANDOM 
   
    instruction = instr[0].upper()
    if (instruction == 'NOP'):
        rd = 0
        rs = 0
        rt = 0
    elif (instruction == 'JUMP'):
        imm = signExtend(int(instr[1])) << 1
        alt_pc = make8Bit(imm, False)
        take_alt_pc = True
    elif (instruction == 'HALT'):
        halted = True;
        # input('HALT: Press any key to continue')
    elif (instruction == 'LB'):
        #Extra decoding
        instr[2] = instr[2].strip(')')
        tmp_instr = instr[2].split('(')
        instr[2] = tmp_instr[1]
        instr.append(tmp_instr[0]) #Gotta love my hax
        rt = regDecode(instr[1])
        rs = regDecode(instr[2])
        imm = signExtend(int(instr[3]))
        addr = make8Bit(registers[rs] + imm, False)
        registers[rt] = mem.loadByte(addr)
    elif (instruction == 'SB'):
        instr[2] = instr[2].strip(')')
        tmp_instr = instr[2].split('(')
        instr[2] = tmp_instr[1]
        instr.append(tmp_instr[0]) #Gotta love my hax
        rt = regDecode(instr[1])
        rs = regDecode(instr[2])
        imm = signExtend(int(instr[3]))
        addr = make8Bit(registers[rs] + imm, False)
        mem.storeByte(addr, registers[rt])
    elif (instruction == 'ADDI'):
        rt = regDecode(instr[1])
        rs = regDecode(instr[2])
        imm = signExtend(int(instr[3]))
        registers[rt] = make8Bit(registers[rs] + imm)
    elif (instruction == 'ANDI'):
        rt = regDecode(instr[1])
        rs = regDecode(instr[2])
        imm = signExtend(int(instr[3]))
        registers[rt] = make8Bit(registers[rs] & imm)
    elif (instruction == 'ORI'):
        rt = regDecode(instr[1])
        rs = regDecode(instr[2])
        imm = signExtend(int(instr[3]))
        registers[rt] = make8Bit(registers[rs] | imm)
    elif (instruction == 'BEQ'):
        rt = regDecode(instr[1])
        rs = regDecode(instr[2])
        imm = signExtend(int(instr[3])) << 1
        alt_pc = make8Bit(PC + imm + 2, False)
        if (int(registers[rt]) == (registers[rs])):
            take_alt_pc = True
    elif (instruction == 'BNE'):
        rt = regDecode(instr[1])
        rs = regDecode(instr[2])
        imm = signExtend(int(instr[3])) << 1
        alt_pc = make8Bit(PC + imm + 2, False)
        if (int(registers[rt]) != (registers[rs])):
            take_alt_pc = True
    elif (instruction == 'BGEZ'):
        rs = regDecode(instr[1])
        imm = signExtend(int(instr[2])) << 1
        alt_pc = make8Bit(PC + imm + 2, False)
        if (int(registers[rs]) >= 0):
            take_alt_pc = True
    elif (instruction == 'BLTZ'):
        rs = regDecode(instr[1])
        imm = signExtend(int(instr[2])) << 1
        alt_pc = make8Bit(PC + imm + 2, False)
        if (int(registers[rs]) < 0):
            take_alt_pc = True
    elif (instruction == 'ADD'):
        rd = regDecode(instr[1])
        rs = regDecode(instr[2])
        rt = regDecode(instr[3])
        registers[rd] = make8Bit(registers[rs] + registers[rt])
    elif (instruction == 'SUB'):
        rd = regDecode(instr[1])
        rs = regDecode(instr[2])
        rt = regDecode(instr[3])
        registers[rd] = make8Bit(registers[rs] - registers[rt])
    elif (instruction == 'SRA'):
        rd = regDecode(instr[1])
        rs = regDecode(instr[2])
        sign_bit = registers[rs] & 0x80
        registers[rd] = make8Bit((registers[rs] >> 1) | sign_bit)
    elif (instruction == 'SRL'):
        rd = regDecode(instr[1])
        rs = regDecode(instr[2])
        registers[rd] = make8Bit((registers[rs] >> 1) & 0x7f)
    elif (instruction == 'SLL'):
        rd = regDecode(instr[1])
        rs = regDecode(instr[2])
        registers[rd] = make8Bit(registers[rs] << 1)
        assert (registers[rd] % 2 == 0)
    elif (instruction == 'AND'):
        rd = regDecode(instr[1])
        rs = regDecode(instr[2])
        rt = regDecode(instr[3])
        registers[rd] = make8Bit(registers[rs] & registers[rt])
    elif (instruction == 'OR'):
        rd = regDecode(instr[1])
        rs = regDecode(instr[2])
        rt = regDecode(instr[3])
        registers[rd] = make8Bit(registers[rs] | registers[rt])
    else:
        raise Exception('Unknown Instruction: %s' % (instruction))
    
    if (debug_mode):
        dm = '|| '
        print('PC:', PC, 'Instr:', instruction, dm, 'rd[', rd, ']->', registers[rd], dm, \
            'rs[', rs, ']->', registers[rs],  dm, \
#            'rt[', rt, ']->', registers[rt],  dm, 'imm:', imm, dm, 'op:', bin(op), dm, 'funct:', bin(funct))
            'rt[', rt, ']->', registers[rt],  dm, 'imm:', imm)
        # assert (imm <= 63)
        # mem.dump()

    if (take_alt_pc and debug_mode):
        print('Take alt_pc: %d' % (alt_pc))
        nextPC = alt_pc
    elif(take_alt_pc and not debug_mode):
        nextPC = alt_pc
    else:
        nextPC = PC + 2
    if (nextPC >= instruction_length * 2):
        nextPC = nextPC % instruction_length

    # print("Cycle " + str(cycle_num));
    cycle_num += 1;


########################
# Supporting Subroutines
########################

# adds a new line to the transcript - line doesn't include \n
def tran(line):
    global transcript;
    if (transcript_fname):
        transcript += (line);

# add the string to the transcript and print to file
def tran_print(line):
    tran(line + "\n");
    print(line);

# Saves the transcript to transcript.txt
def save_tran():
    if (transcript_fname):
        try:
            tran_fh = open(transcript_fname, "w");
        except:
            exit();
        tran_fh.write(transcript);
        tran_fh.close();


main();
