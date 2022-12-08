`timescale 1ns / 1ps

// demo file for Pmod OLED 128 x 32 on Basys 3
//
// basically, you need to do the following for your circuits
// 1. prep a 4-row message (each row is exactly 16 chars)
//    in row0, row1, row2, row3
// 2. assert enable (currently a pushbutton, but can come
//    from another circuit)
// 3. wait for OLEDInterface to assert done
// 4. de-assert enable
// 5. repeat Steps 1-4 to send a new message

module PmodOLEDDemo(
		clk,
		reset,
		enable,
		CS,
		SDIN,
		SCLK,
		DC,
		RES,
		VBAT,
		VDD,
		led,
		msg
    );

	// port declarations
	
	input  clk;
	input  reset;
	input  enable;
	input  [0:511] msg;
	
	output CS;
	output SDIN;
	output SCLK;
	output DC;
	output RES;
	output VBAT;
	output VDD;
	output led;


	// registers and wires
	
	wire CS, SDIN, SCLK, DC;
	wire VDD, VBAT, RES;

	reg [110:0] current_state = "Idle";

	wire done;
	
	reg [0:127] row0;
	reg [0:127] row1;
	reg [0:127] row2;
	reg [0:127] row3;
	
	reg [15:0] led;
    
	
	// interface that initializes and updates the OLED display
	// you should not need to look inside this
	
	OLEDInterface display (
		.clk(clk),
		.enable(enable),
		.reset(reset),
		.row0(row0),
		.row1(row1),
		.row2(row2),
		.row3(row3),
		.CS(CS),
		.SDIN(SDIN),
		.SCLK(SCLK),
		.DC(DC),
		.RES(RES),
		.VBAT(VBAT),
		.VDD(VDD),
		.done(done),
		.led()
	);

//	$display("%0h", 1 << (hlY << 3));

	//  state machine to send new messages to OLED
	//    every time enable is asserted
	always @(posedge clk) begin
			if(reset == 1'b1) begin
					current_state <= "Wait";
		    end
			else begin
					case(current_state)
					    // wait for enable to be pressed and prepare message
						"Wait" : begin
						    $display("Wait");
							current_state <= "OledUpdate";
							// row0 = "  TEST Message  ";
							// row1 = "*CS 233  HONORS*";
							// row2 = "This OLED screen";
							// row3 = "  is working?!  ";
							row0 <= msg[0:127];
							row1 <= msg[128:255];
							row2 <= msg[256:383];
							row3 <= msg[384:511];
							led <= 16'b1;
				 		end
						
  					   // send text to the screen
						"OledUpdate" : begin
						    led <= 16'b10;
							if(done == 1'b1) begin
									current_state <= "Wait";
							end
						end
						
						// do nothing
						"Done" : begin
						    led <= 16'b100;
							current_state <= "Done";
						end
						
						default : current_state <= "Idle";
					endcase
			end
	end

endmodule
