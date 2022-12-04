module muxB(BSEL, B, Bout);
  
  // inputs
  input        BSEL;
  input  [7:0] B;
  
  // outputs
  output [7:0] Bout;

  // MUX LOGIC:
  //   if   BSEL == 0 => Bout = B
  //   else           => Bout = ~B
  assign Bout = ( BSEL == 1'b0 ) ? B : ~B;

endmodule