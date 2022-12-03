module shifter(A, LA, LR, Y, C); // add all inputs and outputs inside parentheses

  // inputs
  input  [7:0]  A;
  input         LA;
  input         LR;
  
  // outputs
  output [7:0]  Y;
  output        C;
  
  
  // reg and internal variable definitions
  
  
  // implement module here
  assign Y[7] = LR ? (LA ? A[7] : 1'b0) : A[6];
  assign Y[6:1] = LR ? A[7:2] : A[5:0];
  assign Y[0] = LR ? A[1] : 1'b0;
  
  assign C = LR ? A[0] : A[7];
  
endmodule