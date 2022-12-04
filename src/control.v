module control(OP, CISEL, OSEL, SHIFT_LA, SHIFT_LR, LOGICAL_OP); // add other inputs and outputs here

  // inputs (add others here)
  input  [2:0]  OP;
  
  // outputs (add others here)
  output        CISEL;
  output [1:0]  OSEL;
  output        SHIFT_LA;
  output        SHIFT_LR;
  output        LOGICAL_OP;

  // reg and internal variable definitions
  
  
  // implement module here (add other control signals below)
  assign CISEL = (OP == 3'b001) ? 1'b1 : 1'b0;
  assign OSEL = (OP[2:1] == 2'b00) ? 2'b00 : ((OP == 3'b101) ? 2'b10 : ((OP == 3'b110) ? 2'b10 : 2'b01));
  assign SHIFT_LA = ~OP[0];
  assign SHIFT_LR = OP[1];
  assign LOGICAL_OP = OP[0];
  
endmodule