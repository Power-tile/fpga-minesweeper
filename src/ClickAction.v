`define OP_BtnC     3'b001
`define OP_DblBtnC  3'b010
`define OP_U        3'b100
`define OP_R        3'b101
`define OP_D        3'b110
`define OP_L        3'b111
// Each button's code, used the numbers directly though

// Main Module to Decide on Action using Button C Click
module ClickAction(clk, inbtnC, inU, inR, inD, inL, ACK, DbleClkSwitch, Action);
    input clk, inbtnC, inU, inR, inD, inL, ACK, DbleClkSwitch;
    output[2:0] Action; // Can be nothing, Single CLick, or Double Click to trigger or flag mine
    
    wire[2:0] goOut, IsDouble;
    mux2v #(3) muxIsDouble(IsDouble, 3'b001, 3'b010, DbleClkSwitch); // Checks if DoubleClick is enabled, outputs result
    mux2v #(3) muxIsClicked(Action, goOut, IsDouble, inbtnC);        // Based Outputs result, overriding Button C with the Double Switch if it is on
    click_detector cd(clk, inbtnC, inU, inR, inD, inL, ACK, goOut);  // Runs the CLick Detector for Button C
endmodule

// Detects Clicks for the inputted buttons
module click_detector(clk, inbtnC, inU, inR, inD, inL, ACK, goOut);
// 000 - No input, 001 - single btnC click, 010 - double btnC, 100/101/110/111 - U/R/D/L btn click
    // inputs
    input clk, inbtnC, inU, inR, inD, inL, ACK;
    // outputs
    output[2:0] goOut;

    // reg and internal variable definitions
    wire [2:0] firstRes, currBtnOut, secondRes;
    
    wire firstRes3to1, CTBtnOut;
    wire secondRes3to1;
   
    // When a button is pressed this saves the pressed button's code
   assign firstRes = inbtnC == 1'b1 ? 3'b001 
                    : inU == 1'b1 ? 3'b100 
                    : inR == 1'b1 ? 3'b101 
                    : inD == 1'b1 ? 3'b110 
                    : inL == 1'b1 ? 3'b111
                    : 3'b000;
    assign firstRes3to1 = firstRes[2] | firstRes[1] | firstRes[0]; // This wire will be 1 is any button is pressed
    dff_behavioral #(3) SingleClick(firstRes, clk, ACK, currBtnOut); // If pressed button, stores pressed button's code

    // Gets whether the pressed button is still on, using pressed button's code as control
    mux8v #(1) m8(secondzRes3to1, 1'b1, inbtnC, 1'b1, 1'b1, inU, inR, inD, inL, currBtnOut);

    // If button is no longer pressed, pass 1
    dff_behavioral_WEnable #(1) ClickDetect(1'b1, secondRes3to1, 1'b1, ACK, CTBtnOut);
    // Will output the cliked button's code
    assign goOut = {CTBtnOut, CTBtnOut, CTBtnOut} & currBtnOut;
endmodule

// Flip-Flopper taken from previous assignments
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

// Flip-Flopper taken from previous assignments, Enable Added
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

// Mux2v taken from previous assignments
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

// Mux8v taken from previous assignments
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
