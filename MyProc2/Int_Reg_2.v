`ifndef INCLUDE_PARAMS
	`include "params.v"
`endif

module Int_Reg_2 (
	input clk,    // Clock
	// pipeline in
	input wire [`WIDTH - 1:0] IR_in,
	input wire [`WIDTH - 3:0] PC_in,
	input wire [`REG_ADDR_LEN - 1:0] Rd_no_in,
	input wire [`REG_ADDR_LEN - 1:0] Rs_no_in,
	input wire [`WIDTH - 1:0] Rs_data_in,
	input wire [`REG_ADDR_LEN - 1:0] Rt_no_in,
	input wire [`WIDTH - 1:0] Rt_data_in,
	// pipeline out
	output reg [`WIDTH - 1:0] IR_out,
	output reg [`WIDTH - 3:0] PC_out,
	output reg [`REG_ADDR_LEN - 1:0] Rd_no_out,
	output reg [`REG_ADDR_LEN - 1:0] Rs_no_out,
	output reg [`WIDTH - 1:0] Rs_data_out,
	output reg [`REG_ADDR_LEN - 1:0] Rt_no_out,
	output reg [`WIDTH - 1:0] Rt_data_out
);

	always @(posedge clk) begin
		IR_out <= IR_in;
		PC_out <= PC_in;
		Rd_no_out <= Rd_no_in;
		Rs_no_out <= Rs_no_in;
		Rs_data_out <= Rs_data_out;
		Rt_no_out <= Rt_no_in;
		Rt_data_out <= Rt_data_in;
	end

endmodule