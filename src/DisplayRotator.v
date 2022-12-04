module DisplayRotator(
    input            clk,
    input            showUpperBits, // toggles whether to show MM:SS or SS:ss
    input      [3:0] digit0,
    input      [3:0] digit1,
    input      [3:0] digit2,
    input      [3:0] digit3,
    input      [3:0] digit4,
    input      [3:0] digit5,
    input      [3:0] digit6,
    input      [3:0] digit7,
    output reg [3:0] an,
    output reg       dpEnable,
    output reg [3:0] digitToDisplay
);

reg [16:0] counter = 17'b0;


// YOU SHOULD NOT NEED TO EDIT THIS ALWAYS BLOCK

always @(posedge clk) begin
  counter <= counter + 1;
end


// YOU SHOULD EDIT ONLY THE digitToDisplay LINES BELOW

always @(*) begin
  case(counter[16:15])
    2'b00: begin
      an <= 4'b1110;
      digitToDisplay <= (showUpperBits ? digit4 : digit0);
      dpEnable <= (showUpperBits ? 1'b0 : 1'b1);
    end
    2'b01: begin
      an <= 4'b1101;
      digitToDisplay <= (showUpperBits ? digit5 : digit1);
      dpEnable <= 1'b1;
    end
    2'b10: begin
      an <= 4'b1011;
      digitToDisplay <= (showUpperBits ? digit6 : digit2);
      dpEnable <= (showUpperBits ? 1'b1 : 1'b0);
    end
    2'b11: begin
      an <= 4'b0111;
      digitToDisplay <= (showUpperBits ? digit7 : digit3);
      dpEnable <= 1'b1;
    end
  endcase
end

endmodule