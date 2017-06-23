`ifndef INCLUDE_PARAMS
	`include "params.v"
`endif

module EXE_MEM (
	input clk,    // Clock
	
	// pipeline inputs
	input wire [`WIDTH - 1:0] IR_in,
	input wire [`WIDTH - 3:0] PC_in,
	input wire [`WIDTH - 1:0] Z_in,
	input wire [`WIDTH - 1:0] Addr_in,
	
	// pipeline outputs
	output reg [`WIDTH - 1:0] IR_out,
	output reg [`WIDTH - 3:0] PC_out,
	output reg [`WIDTH - 1:0] Z_out,
	output reg [`WIDTH - 1:0] Addr_out
);

	always @(posedge clk) begin
		IR_out <= IR_in;
		PC_out <= PC_in;
		Z_out <= Z_out;
		Addr_out <= Addr_in;
	end

endmodule