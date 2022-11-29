# FPGA Minesweeper
This is our project on implementing a Minesweeper on a Basys3 FPGA.

## Project Workflow
- Create a branch named after the **feature**, for example `oled-api`, `extend-pc`, `map-gen`;
- **Switch to the branch you created before working and do all the work there, not on `main`**;
- When ready, create a pull request and **add everyone else as the reviewer**;
- When everyone else reviewed the code, merge the pull request.

## Task Breakdown

#### Nov 7 - 13
- [X] ~~Implement API for OLED peripheral - Daniel~~ Wait for Saugata's XDC Package
  - Code for painting a pixel with a color
  - Code for clearing the whole screen
  - If have time, add label interpretation to Python Assembler
- [X] Implement minimips with extended PC + "absolute jump" instruction - Sankar
  - Design machine code details for absolute jump instruction
  - Figure out what is the sweet spot for PC's bit length (which one in 9~12?)
  - Change Verilog
- [X] C coding - Huiyao
  - Write a list of "input" variables you will need to use, for example:
    - `lButton`, `rButton`, `uButton`, `dButton`, `cButton`: these should turn 1 when the user pushes it down.
    - `timer_start`: when set to 1, start a timer that counts for 100ms.
    - `timer_stop`: after timer start, `timer_stop` will be `1` before reaching 100ms.
    - Other things you need from the user...
  - Write the infinite main loop of the game. Main loop should consist user interaction detection, interaction process, and rendering:
    - Interaction detection: Detect if there is a "click" (i.e. `0 -> 1 -> 0`) for each of the buttons. For center button, detect the double click with the help of a timer.
    - Interaction process: If not center button, move user cursor. If center button, mark tile as mine/not as mine if single click; mark the corresponding tile as open if it is a double click. If it is not a mine, calculate the number to display; if it is a mine, set the flag indicating game end to true and stop interaction detection afterwards.
    - Rendering: call pseudo-functions that render the updated tile the user clicked on. If game ends, render all mines as visible.

#### Nov 28 - Dec 4
- Hardware implementation of user input
  - [ ] Implement a timer that counts 200ms (Verilog) - Huiyao
  - [ ] Implement user interaction handler (Verilog) - Sankar
    - Gives a single code representing current user input to MMIO
      - 000 - No input, 001 - single btnC click, 010 - double btnC, 100/101/110/111 - U/R/D/L btn click
    - Uses the timer and reads button inputs
    - After the user stops pressing the button, allows the program to "reset" the handler through MMIO to await next user input
  - [ ] Implementing MMIO of handler - Daniel
- Assembly code for minesweeper
  - [ ] Figure out how to use Saugata's PMOD OLED driver - Daniel [Thursday]
  - [ ] Write rendering pipeline in Assembly - Daniel
  - [ ] Update pseudocode to make logic easier - Huiyao [Thursday]
    - Read from an input variable holding the user input code (see above); after you processed it, set 1 to acknowledge variable.
  - [ ] Design DRAM allocation - Daniel [Thursday]
  - [ ] Change assembler to support labels in assembly code - Sankar [Thursday]
    - The assembler code guarantees a specific format for labels: `label_for:` and every label has a unique line.
    - Before assembling, read all the labels into a dictionary `string -> instruction number (int)` and delete labels from to-be-assembled string.
    - For jump/branch, have a special step determining label from dictionary.
  - [ ] Write main loop logic in Assembly
  - [ ] (Optional) random map generation
