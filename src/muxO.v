module muxO(OSEL, ADD_Y, SHIFT_Y, LOGICAL_Y, ADD_C, SHIFT_C, Y, C, V);
  
  // inputs
  input  [1:0]  OSEL;
  input  [7:0]  ADD_Y;
  input  [7:0]  SHIFT_Y;
  input  [7:0]  LOGICAL_Y;
  input         ADD_C;
  input         SHIFT_C;
  
  // outputs
  output [7:0]  Y;
  output        C;
  output        V;

  assign Y = OSEL[1] ? LOGICAL_Y : (OSEL[0] ? SHIFT_Y : ADD_Y);
  assign C = OSEL[1] ? 1'b0 : (OSEL[0] ? SHIFT_C : ADD_C);
  assign V = (~OSEL[1] & ~OSEL[0]) ? ADD_C ^ ADD_Y[7] : 1'b0;

endmodule