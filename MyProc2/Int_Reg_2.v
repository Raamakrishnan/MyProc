`ifndef INCLUDE_PARAMS
	`include "params.v"
`endif
// Intermediate Register between ID and MEM
module Int_Reg_2 (
	input clk,    // Clock
	// pipeline in
	input wire [`WIDTH - 1:0] IR_in,
	input wire [`WIDTH - 3:0] PC_in,
	input wire [`WIDTH - 1:0] X_in,
	input wire [`WIDTH - 1:0] Y_in,
	// pipeline out
	output reg [`WIDTH - 1:0] IR_out,
	output reg [`WIDTH - 3:0] PC_out,
	output reg [`WIDTH - 1:0] X_out,
	output reg [`WIDTH - 1:0] Y_out
);

	always @(posedge clk) begin
		IR_out <= IR_in;
		PC_out <= PC_in;
		X_out <= X_out;
		Y_out <= Y_in;
	end

endmodule