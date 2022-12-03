module adder(A, B, CI, Y, CO);

  // inputs
  input  [7:0] A;
  input  [7:0] B;
  input        CI;
  
  
  // outputs
  output [7:0] Y;
  output       CO;
  
  
  // reg and internal variable definitions
  wire   [8:0] carry;
  
  
  // implement module here
  assign carry[0] = CI;
  assign carry[8:1] = (A & B) | ((A ^ B) & carry[7:0]);
  assign Y = A ^ B ^ carry[7:0];
  assign CO = carry[8];

  
endmodule