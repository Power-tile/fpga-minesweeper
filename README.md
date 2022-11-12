# FPGA Minesweeper
This is our project on implementing a Minesweeper on a Basys3 FPGA.

## Project Workflow
- Create a branch named after the **feature**, for example `oled-api`, `extend-pc`, `map-gen`;
- **Switch to the branch you created before working and do all the work there, not on `main`**;
- When ready, create a pull request and **add everyone else as the reviewer**;
- When everyone else reviewed the code, merge the pull request.

## Task Breakdown

#### Nov 7 - 13
- Implement API for OLED peripheral - Daniel
  - Code for painting a pixel with a color
  - Code for clearing the whole screen
  - If have time, add label interpretation to Python Assembler
- Implement minimips with extended PC + "absolute jump" instruction - Sankar
  - Design machine code details for absolute jump instruction
  - Figure out what is the sweet spot for PC's bit length (which one in 9~12?)
  - Change Verilog
- C coding - Huiyao
  - Write a list of "input" variables you will need to use, for example:
    - `lButton`, `rButton`, `uButton`, `dButton`, `cButton`: these should turn 1 when the user pushes it down.
    - `timer_start`: when set to 1, start a timer that counts for 100ms.
    - `timer_stop`: after timer start, `timer_stop` will be `1` before reaching 100ms.
    - Other things you need from the user...
  - Write the infinite main loop of the game. Main loop should consist user interaction detection, interaction process, and rendering:
    - Interaction detection: Detect if there is a "click" (i.e. `0 -> 1 -> 0`) for each of the buttons. For center button, detect the double click with the help of a timer.
    - Interaction process: If not center button, move user cursor. If center button, mark tile as mine/not as mine if single click; mark the corresponding tile as open if it is a double click. If it is not a mine, calculate the number to display; if it is a mine, set the flag indicating game end to true and stop interaction detection afterwards.
    - Rendering: call pseudo-functions that render the updated tile the user clicked on. If game ends, render all mines as visible.

  
