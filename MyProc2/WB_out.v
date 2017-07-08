module WB_out (
	input clk,    // Clock
	// pipeline inputs
	input wire [`WIDTH - 1:0] IR_in,
	input wire [`WIDTH - 3:0] PC_in,
	// pipeline outputs
	output reg [`WIDTH - 1:0] IR_out,
	output reg [`WIDTH - 3:0] PC_out
);
	
	always @(posedge clk) begin
		IR_out <= IR_in;
		PC_out <= PC_in;
	end

endmodule