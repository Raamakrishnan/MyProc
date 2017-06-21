`ifndef INCLUDE_PARAMS
	`include "params.v"
`endif

module Int_Reg_1_mod (
	input clk,    // Clock
	input [`WIDTH - 3:0] PC_in,
	input [`WIDTH - 1:0] IR_in,
	output reg [`WIDTH - 3:0] PC_out,
	output reg [`WIDTH - 1:0] IR_out	
);
	always @(posedge clk) begin
		PC_out <= PC_in;
		IR_out <= IR_in;
	end

endmodule