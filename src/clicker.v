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
reg[2:0] goOut, IsDouble;
    ClickerModule clicker(inbtnC, indblbtnC, inU, inR, inD, inL, ACK, goOut);
    muxIsDouble #(3) mux2v(IsDouble, 3'b001, 3'b010, DbleClkSwitch);
    muxIsClicked #(3) mux2v(Action, goOut, IsDouble, inbtnC);
    endmodule
// or browse Examples
module clicker(inbtnC, indblbtnC, inU, inR, inD, inL, ACK, goOut);
// 000 - No input, 001 - single btnC click, 010 - double btnC, 100/101/110/111 - U/R/D/L btn click
// inputs
input inbtnC, indblbtnC, inU, inR, inD, inL, ACK;
// outputs
output[2:0] goOut;

// reg and internal variable definitions
reg [2:0] firstRes, currBtnOut, secondRes;
// COME BACK TO THIS wire
reg firstRes3to1, secondRes3to1, CTBtnOut;

assign firstRes = (inbtnC == 1'b1) ? 3'b001 : ((indblbtnC == 1'b1) ? 3'b010 : ((inU == 1'b1) ? 3'b100 : ((inR == 1'b1) ? 3'b101 : ((inD == 1'b1) ? 3'b110 : ((inL == 1'b1) ? 3'b111)))));
assign firstRes3to1 = firstRes[2] | (firstRes[1] | firstRes[0]);
SingleClick #(3) dff_behavioral(firstRes, firstRes3to1, ACK, currBtnOut);

assign secondRes = (1'b1 == 1'b1) ? 3'b000 : ((inbtnC == 1'b1) ? 3'b001 : ((indblbtnC == 1'b1) ? 3'b010 : ((inU == 1'b1) ? 3'b100 : ((inR == 1'b1) ? 3'b101 : ((inD == 1'b1) ? 3'b110 : ((inL == 1'b1) ? 3'b111))))));
assign secondRes3to1 = ~(secondRes[2] | (secondRes[1] | secondRes[0]));
ClickDetect #(1) dff_behavioral_WEnable(1'b1, secondRes3to1, 1'b1, ACK, CTBtnOut);
assign goOut = {2'b00, CTBtnOut} && currBtnOut;

endmodule



module dff_behavioral(d,clk,clear,q,qbar); 
input d, clk, clear; 
output reg q, qbar; 
always@(posedge clk) 
begin
if(clear== 1)
    q <= 0;
    qbar <= 1;
else 
    q <= d; 
    qbar = !d; 
    end 
endmodule

module dff_behavioral_WEnable(d,clk,enable,clear,q,qbar); 
input d, clk, clear; 
output reg q, qbar; 
always@(posedge clk) 
begin
if(clear== 1)
    q <= 0;
    qbar <= 1;
  else if(enable == 1)
    q <= d; 
    qbar = !d; 
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