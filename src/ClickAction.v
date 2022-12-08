`define OP_BtnC     3'b001
`define OP_DblBtnC  3'b010
`define OP_U        3'b100
`define OP_R        3'b101
`define OP_D        3'b110
`define OP_L        3'b111

module ClickAction(inbtnC, inU, inR, inD, inL, ACK, DbleClkSwitch, Action);
    input inbtnC, inU, inR, inD, inL, ACK, DbleClkSwitch;
    output[2:0] Action;
    
    wire[2:0] goOut, IsDouble;
    mux2v #(3) muxIsDouble(IsDouble, 3'b001, 3'b010, DbleClkSwitch);
    mux2v #(3) muxIsClicked(Action, goOut, IsDouble, inbtnC);
    click_detector cd(inbtnC, inU, inR, inD, inL, ACK, goOut);
endmodule

module click_detector(inbtnC, inU, inR, inD, inL, ACK, goOut);
// 000 - No input, 001 - single btnC click, 010 - double btnC, 100/101/110/111 - U/R/D/L btn click
    // inputs
    input inbtnC, inU, inR, inD, inL, ACK;
    // outputs
    output[2:0] goOut;

    // reg and internal variable definitions
    wire [2:0] firstRes, currBtnOut, secondRes;
    // COME BACK TO THIS wire
    wire firstRes3to1, CTBtnOut;
    wire secondRes3to1;

    assign firstRes = inbtnC == 1'b1 ? 3'b001 
                    : inU == 1'b1 ? 3'b100 
                    : inR == 1'b1 ? 3'b101 
                    : inD == 1'b1 ? 3'b110 
                    : inL == 1'b1 ? 3'b111
                    : 3'b000;
    assign firstRes3to1 = firstRes[2] | firstRes[1] | firstRes[0];
    dff_behavioral #(3) SingleClick(firstRes, firstRes3to1, ACK, currBtnOut);

    mux8v #(1) m8(secondzRes3to1, 1'b1, inbtnC, 1'b1, 1'b1, inU, inR, inD, inL, currBtnOut);

    dff_behavioral_WEnable #(1) ClickDetect(1'b1, secondRes3to1, 1'b1, ACK, CTBtnOut);
    assign goOut = {CTBtnOut, CTBtnOut, CTBtnOut} & currBtnOut;
endmodule

module dff_behavioral(d,clk,clear,q,qbar); 
    parameter
        width = 3;

    input [width-1:0] d;
    input clk, clear; 
    output reg [width-1:0] q, qbar; 
    always@(posedge clk) 
    begin
        if (clear== 1) begin
            q <= {width{1'b0}};
            qbar <= {width{1'b1}};
        end else begin
            q <= d; 
            qbar = ~d; 
        end
    end 
endmodule

module dff_behavioral_WEnable(d,clk,enable,clear,q,qbar); 
    parameter
        width = 3;

    input [width-1:0] d;
    input clk, clear, enable; 
    output reg [width-1:0] q, qbar; 
    always@(posedge clk) 
    begin
        if(clear == 1) begin
            q <= {width{1'b0}};
            qbar <= {width{1'b1}};
        end else if(enable == 1) begin
            q <= d; 
            qbar = ~d; 
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
