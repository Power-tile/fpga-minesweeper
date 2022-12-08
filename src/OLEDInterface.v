`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Digilent Inc.
// Engineers: Ryan Kim
//				  Josh Sackos
// 
// Create Date:    14:00:51 06/12/2012
// Module Name:    PmodOLEDCtrl 
// Project Name: 	 PmodOLED Demo
// Target Devices: Nexys3
// Tool versions:  ISE 14.1
// Description: 	 Top level controller that controls the PmodOLED blocks
//
// Revision: 1.1
// Revision 0.01 - File Created
//////////////////////////////////////////////////////////////////////////////////
module OLEDInterface(
		clk,
		enable,
		reset,
        row0,
        row1,
        row2,
        row3,
    	CS,
		SDIN,
		SCLK,
		DC,
		RES,
		VBAT,
		VDD,
		done,
		led
    );

	// ===========================================================================
	// 										Port Declarations
	// ===========================================================================
	input clk;
	input enable;
	input reset;
    input [0:127] row0;
    input [0:127] row1;
    input [0:127] row2;
    input [0:127] row3;
	output CS;
	output SDIN;
	output SCLK;
	output DC;
	output RES;
	output VBAT;
	output VDD;
	output done;
	output led;

	// ===========================================================================
	// 							  Parameters, Regsiters, and Wires
	// ===========================================================================
	wire CS, SDIN, SCLK, DC;
	wire VDD, VBAT, RES;
	wire done;

    reg [15:0] led;
	reg [110:0] current_state = "Idle";

	wire init_en;
	wire init_done;
	wire init_cs;
	wire init_sdo;
	wire init_sclk;
	wire init_dc;
	
	wire driver_en;
	wire driver_cs;
	wire driver_sdo;
	wire driver_sclk;
	wire driver_dc;
	wire driver_done;
    
	// ===========================================================================
	// 										Implementation
	// ===========================================================================
	OLEDInit Init(
			.CLK(clk),
			.RST(reset),
			.EN(init_en),
			.CS(init_cs),
			.SDO(init_sdo),
			.SCLK(init_sclk),
			.DC(init_dc),
			.RES(RES),
			.VBAT(VBAT),
			.VDD(VDD),
			.FIN(init_done)
	);
	
	OLEDDriver Driver(
			.CLK(clk),
			.RST(reset),
			.EN(driver_en),
			.row0(row0),
			.row1(row1),
			.row2(row2),
			.row3(row3),
			.CS(driver_cs),
			.SDO(driver_sdo),
			.SCLK(driver_sclk),
			.DC(driver_dc),
			.ready(driver_done)
	);


	//MUXes to indicate which outputs are routed out depending on which block is enabled
	assign CS = (current_state == "OledInitialize") ? init_cs : driver_cs;
	assign SDIN = (current_state == "OledInitialize") ? init_sdo : driver_sdo;
	assign SCLK = (current_state == "OledInitialize") ? init_sclk : driver_sclk;
	assign DC = (current_state == "OledInitialize") ? init_dc : driver_dc;
	//END output MUXes

	
	//MUXes that enable blocks when in the proper states
	assign init_en = (current_state == "OledInitialize") ? 1'b1 : 1'b0;
	assign driver_en = (current_state == "OledDriver") ? 1'b1 : 1'b0;
	//END enable MUXes
	
	
	assign done = driver_done;

	
	//  State Machine
	always @(posedge clk) begin
			if(reset == 1'b1) begin
					current_state <= "Idle";
					led <= 16'b1;
			end
			else begin
					case(current_state)
						"Idle" : begin
						    led <= 16'b1;
							current_state <= "OledInitialize";
						end
  					   // Go through the initialization sequence
						"OledInitialize" : begin
						    led <= 16'b10;
							if(init_done == 1'b1) begin
								current_state <= "OledWait";
							end
						end
						// Do driver and Do nothing when finished
						"OledWait" : begin
						    led <= 16'b100;
							// if(enable == 1'b1) begin
								current_state <= "OledDriver";
							// end
						end
						// Do driver and wait to refresh screen when finished
						"OledDriver" : begin
						    led <= 16'b1000;
							if(driver_done == 1'b1 && enable == 1'b0) begin
									current_state <= "OledWait";
							end
						end
						// Do Nothing: legacy state
						"Done" : begin
						    led <= 16'b10000;
							current_state <= "Done";
						end
						
						default : current_state <= "Idle";
					endcase
			end
	end

endmodule
