module alu(A, B, OP, Y, C, V, N, Z);
  input  [7:0]  A;
  input  [7:0]  B;
  input  [2:0]  OP;

  output [7:0]  Y;
  output        C;
  output        V;
  output        N;
  output        Z;



  // ADD YOUR CODE BELOW THIS LINE
  wire          CISEL;
  wire   [1:0]  OSEL;
  wire          SHIFT_LA;
  wire          SHIFT_LR;
  wire          LOGICAL_OP;
  wire   [7:0]  ADD_B;
  wire          ADD_CI;
  wire   [7:0]  ADD_Y;
  wire          ADD_C;
  wire   [7:0]  LOGICAL_Y;
  wire   [7:0]  SHIFT_Y;
  wire          SHIFT_C;
  
  control freak(
    .OP(OP),
    .CISEL(CISEL),
    .OSEL(OSEL),
    .SHIFT_LA(SHIFT_LA),
    .SHIFT_LR(SHIFT_LR),
    .LOGICAL_OP(LOGICAL_OP)
  );
  
  muxB letItB(
    .BSEL(CISEL),
    .B(B),
    .Bout(ADD_B)
  );
  
  muxCI toEye(
    .CISEL(CISEL),
    .CIout(ADD_CI)
  );
  
  adder theBlackestOfBlack(
    .A(A),
    .B(ADD_B),
    .CI(ADD_CI),
    .Y(ADD_Y),
    .CO(ADD_C)
  );

  logical paradox(
    .A(A),
    .B(B),
    .OP(LOGICAL_OP),
    .Y(LOGICAL_Y)
  );  
  
  shifter iDontGiveAShift(
    .A(A),
    .LA(SHIFT_LA),
    .LR(SHIFT_LR),
    .Y(SHIFT_Y),
    .C(SHIFT_C)
  );
  
  muxO outputMux(
    .OSEL(OSEL),
    .ADD_Y(ADD_Y),
    .SHIFT_Y(SHIFT_Y),
    .LOGICAL_Y(LOGICAL_Y),
    .ADD_C(ADD_C),
    .SHIFT_C(SHIFT_C),
    .Y(Y),
    .C(C),
    .V(V)
  );
  
  assign N = Y[7];
  assign Z = (Y == 8'b0);

  // ADD YOUR CODE ABOVE THIS LINE

endmodule