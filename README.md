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
  - `drawPixel(color, x, y)`
  - `cleanScreen()`
  - `drawShape(Color colors[][], lenX, lenY, x0, y0)`
- Implement minimips with extended PC + "absolute jump"/"jal/jr" instruction - Sankar
  - Design machine code details for jump/jal/jr instructions
  - Figure out what is the sweet spot for PC's bit length (which one in 9~12?)
  - Change Verilog
- C coding for RNG & map generation - Huiyao
  - `rand()`, returns a random integer. This can be a simple Linear Congruential Generator (LCG).
  - `mapGen(char map[][], int sizeX, int sizeY, int startX, int startY)`, writes a random map to array `map[][]` with size `sizeX * sizeY`. Map generated guarantees there are no mines around `(startX, startY)`. Should use `rand()` we wrote.

  
