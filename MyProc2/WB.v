`ifndef INCLUDE_PARAMS
	`include "params.v"
`endif

`ifndef INCLUDE_ISA
	`include "ISA.v"
`endif

module WB (
	input clk,    // Clock
	
	// pipeline in
	input wire [`WIDTH - 1:0] IR_in,
	input wire [`WIDTH - 3:0] PC_in,
	input wire [`WIDTH - 1:0] Z_in,

	// reg
	output reg [`WIDTH - 1:0] Addr,
	output reg [`WIDTH - 1:0] Data,
	output reg wr_en
);

	always @(posedge clk) begin
		
	end

endmodule