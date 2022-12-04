module registerFile(
	input clk,
	input ld,
	input reset,
	input [2:0] srcA,
	input [2:0] srcB,
	input [2:0] dest,
	input [7:0] dataD,
	output [7:0] dataA,
	output [7:0] dataB
);

reg [7:0] file [7:0];

assign dataA = file[srcA];
assign dataB = file[srcB];

always @(posedge clk) begin
	if(reset) begin
		file[0] <= 8'b0;
		file[1] <= 8'b0;
		file[2] <= 8'b0;
		file[3] <= 8'b0;
		file[4] <= 8'b0;
		file[5] <= 8'b0;
		file[6] <= 8'b0;
		file[7] <= 8'b0;
	end
	else if(ld) begin
		file[dest] <= dataD;
	end
end

endmodule