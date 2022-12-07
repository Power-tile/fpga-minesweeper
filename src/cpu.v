module cpu(CLK, RESET, EN_L, Iin, Din, PC, NextPC, DataA, DataB, DataC, DataD, MW);
  input         CLK;
  input         RESET;
  input         EN_L;
  input  [15:0] Iin;
  input  [7:0]  Din;
  
	output [9:0]  PC;
	output [9:0]  NextPC;
  output [7:0]  DataA;
  output [7:0]  DataB;
  output [7:0]  DataC;
  output [7:0]  DataD;
  output        MW;
  
  // comment the two lines out below if you use a submodule to generate PC/NextPC
	reg [9:0] PC;
	reg [9:0] NextPC;
  
  reg MW;
  
  
  

wire [3:0] OP;
wire [7:0] imm;
reg MB, MD, ld;
reg [2:0] srcA, srcB, dest, func;
wire [7:0] aluB, regData;
wire V, C, N, Z;
reg MP;
wire HALT;
reg prevEN_L;

	
	// I added jmp
reg jmp;
// BRANCH LOGIC
always @(*) begin
	if(HALT & (~prevEN_L | EN_L)) begin
		NextPC <= PC;
	end
	else if(jmp) begin
		// Check if amount is good
		NextPC <= {Iin[8:0], 1'b0};	
	end
	else if(MP) begin
		// Unsure
		NextPC <= PC + 10'd2 + {2'b0, {imm[6:0], 1'b0}};
	end
	else begin
		NextPC <= PC + 10'd2;
	end
end

always @(*) begin
    	case(OP)
        // Added jmp here:
		4'b0001: jmp <= 1'b1;
		default: jmp <= 1'b0;
    	endcase
	case(OP)
		4'b1000: MP <= Z;
		4'b1001: MP <= ~Z;
		4'b1010: MP <= ~N;
		4'b1011: MP <= N;
		default: MP <= 1'b0;
	endcase
end


// HALT LOGIC
always @(posedge CLK) begin
	if(RESET) begin
    prevEN_L <= 1'b0;
	end
	else begin
    prevEN_L <= EN_L;
	end
end


// PROGRAM COUNTER
always @(posedge CLK) begin
	if(RESET) begin
		PC <= 10'b0;
	end
	else begin
		PC <= NextPC;
	end
end


// DECODER
assign OP = Iin[15:12];

always @(*) begin
	case(OP)
		4'b0000: begin
			srcA <= Iin[11:9];
			srcB <= Iin[8:6];
			dest <= Iin[5:3];
		end
		4'b1111: begin
			srcA <= Iin[11:9];
			srcB <= Iin[8:6];
			dest <= Iin[5:3];
		end
		default: begin
			srcA <= Iin[11:9];
			srcB <= Iin[8:6];
			dest <= Iin[8:6];
		end
	endcase
end

always @(*) begin
	case(OP)
		4'b0010: MB <= 1'b1;
		4'b0100: MB <= 1'b1;
		4'b0101: MB <= 1'b1;
		4'b0110: MB <= 1'b1;
		4'b0111: MB <= 1'b1;
		default: MB <= 1'b0;
	endcase
end

always @(*) begin
	case(OP)
		4'b0010: MD <= 1'b1;
		default: MD <= 1'b0;
	endcase
end

always @(*) begin
	case(OP)
		4'b0010: func <= 3'b000;
		4'b0100: func <= 3'b000;
		4'b0101: func <= 3'b000;
		4'b0110: func <= 3'b101;
		4'b0111: func <= 3'b110;
		4'b1000: func <= 3'b001;
		4'b1001: func <= 3'b001;
		4'b1010: func <= 3'b010;
		4'b1011: func <= 3'b010;
		default: func <= Iin[2:0];
	endcase
end

always @(*) begin
	if(RESET) begin
		ld <= 1'b0;
		MW <= 1'b0;
	end
	else begin
		case(OP)
			4'b0100: begin
				ld <= 1'b0;
				MW <= 1'b1;
			end
			4'b1000: begin
				ld <= 1'b0;
				MW <= 1'b0;
			end
			4'b1001: begin
				ld <= 1'b0;
				MW <= 1'b0;
			end
			4'b1010: begin
				ld <= 1'b0;
				MW <= 1'b0;
			end
			4'b1011: begin
				ld <= 1'b0;
				MW <= 1'b0;
			end
			4'b0000: begin
				ld <= 1'b0;
				MW <= 1'b0;
			end
			default: begin
				ld <= 1'b1;
				MW <= 1'b0;
			end
		endcase
	end
end

assign HALT = (OP == 4'b0000  && func == 3'b001);



// REGISTER FILE
registerFile rf(
	.clk(CLK),
	.reset(RESET),
	.ld(ld),
	.srcA(srcA),
	.srcB(srcB),
	.dest(dest),
	.dataD(DataC),
	.dataA(DataA),
	.dataB(DataB)
);

		
// SIGN EXTEND
assign imm = {Iin[5], Iin[5], Iin[5:0]};


// CHOOSE IMMEDIATE OR DATA
assign aluB = MB ? imm : DataB;


// ALU
alu math(
	.OP(func),
	.A(DataA),
	.B(aluB),
	.Y(DataD),
	.V(V),
	.C(C),
	.N(N),
	.Z(Z)
);


// CHOOSE ALU OR DRAM
assign DataC = MD ? Din : DataD;


endmodule
