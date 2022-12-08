`define OP_BtnC     3'b001
`define OP_DblBtnC  3'b010
`define OP_U        3'b100
`define OP_R        3'b101
`define OP_D        3'b110
`define OP_L        3'b111

// Code your testbench here
module ClickAction(inbtnC, indblbtnC, inU, inR, inD, inL, ACK, DbleClkSwitch, Action);
input inbtnC, indblbtnC, inU, inR, inD, inL, ACK, DbleClkSwitch;
output[2:0] Action;
wire[2:0] goOut, IsDouble;
    mux2v #(3) muxIsDouble(IsDouble, 3'b001, 3'b010, DbleClkSwitch);
    mux2v #(3) muxIsClicked(Action, goOut, IsDouble, inbtnC);
    endmodule
// or browse Examples
module clicker(inbtnC, indblbtnC, inU, inR, inD, inL, ACK, goOut);
// 000 - No input, 001 - single btnC click, 010 - double btnC, 100/101/110/111 - U/R/D/L btn click
// inputs
input inbtnC, indblbtnC, inU, inR, inD, inL, ACK;
// outputs
output[2:0] goOut;

// reg and internal variable definitions
wire [2:0] firstRes, currBtnOut, secondRes;
// COME BACK TO THIS wire
wire firstRes3to1, CTBtnOut;
wire secondRes3to1;

assign firstRes = inbtnC == 1'b1 ? 3'b001 
: indblbtnC == 1'b1 ? 3'b010 
: inU == 1'b1 ? 3'b100 
: inR == 1'b1 ? 3'b101 
: inD == 1'b1 ? 3'b110 
: inL == 1'b1 ? 3'b111
: 3'b000;
assign firstRes3to1 = firstRes[2] | (firstRes[1] | firstRes[0]);
dff_behavioral #(3) SingleClick(firstRes, firstRes3to1, ACK, currBtnOut);

// assign secondRes = (1'b1 == 1'b1) ? 3'b000 : ((inbtnC == 1'b1) ? 3'b001 : ((indblbtnC == 1'b1) ? 3'b010 : ((inU == 1'b1) ? 3'b100 : ((inR == 1'b1) ? 3'b101 : ((inD == 1'b1) ? 3'b110 : ((inL == 1'b1) ? 3'b111))))));
// assign secondRes3to1 = ~(secondRes[2] | (secondRes[1] | secondRes[0]));
checkTwo #(1) mux8v(secondzRes3to1, 1'b1, inbtnC, indblbtnC, 1'b1, inU, inR, inD, inL, currBtnOut);

ClickDetect #(1) dff_behavioral_WEnable(1'b1, secondRes3to1, 1'b1, ACK, CTBtnOut);
assign goOut = {2'b00, CTBtnOut} && currBtnOut;

endmodule



module dff_behavioral(d,clk,clear,q,qbar); 
input d, clk, clear; 
output reg q, qbar; 
always@(posedge clk) 
begin
if(clear== 1) begin
    q <= 0;
    qbar <= 1;
end else 
    q <= d; 
    qbar = !d; 
    end 
endmodule

module dff_behavioral_WEnable(d,clk,enable,clear,q,qbar); 
input d, clk, clear, enable; 
output reg q, qbar; 
always@(posedge clk) 
begin
if(clear== 1) begin
    q <= 0;
    qbar <= 1;
end else if(enable == 1) begin
    q <= d; 
    qbar = !d; 
    end else
    q <= q; 
    end
endmodule

module mux2v(out, A, B, sel);

   parameter
     width = 3;
   
   output [width-1:0] out;
   input  [width-1:0] A, B;
   input              sel;

   wire [width-1:0] temp1 = ({width{(!sel)}} & A);
   wire [width-1:0] temp2 = ({width{(sel)}} & B);
   assign out = temp1 | temp2;

endmodule // mux2v


module mux8v(out, A, B, C, D, E, F, G, H, sel);

   parameter
     width = 1;
   
   output [width-1:0] out;
   input [width-1:0]  A, B, C, D, E, F, G, H;
   input [2:0]        sel;

   wire [width-1:0]   wAB, wCD, wEF, wGH;
   wire [width-1:0]   wABCD, wEFGH;
   
   mux2v #(width)  mAB (wAB, A, B, sel[0]);
   mux2v #(width)  mCD (wCD, C, D, sel[0]);
   mux2v #(width)  mEF (wEF, E, F, sel[0]);
   mux2v #(width)  mGH (wGH, G, H, sel[0]);

   mux2v #(width)  mABCD (wABCD, wAB, wCD, sel[1]);
   mux2v #(width)  mEFGH (wEFGH, wEF, wGH, sel[1]);

   mux2v #(width)  mfinal (out, wABCD, wEFGH, sel[2]);

endmodule // mux8v
