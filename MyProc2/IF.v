`ifndef INCLUDE_PARAMS
	`include "params.v"
`endif

`ifndef INCLUDE_IF_MOD
	`include "IMem.v"
`endif

module IF_mod(
	input wire clk,    	// Clock
	input wire rst_n,
	//input wire [`WIDTH - 1:0] data,	// instruction
	//output reg [`WIDTH - 3:0] addr, // last 2 bits are always 0 for aligned memory access
	// pipeline output
	output reg [`WIDTH - 3:0] PC, // Program Counter
	output reg [`WIDTH - 1:0] IR, // instruction

	input wire IsStall,
	input wire IsBranch,
	input wire [`WIDTH - 3:0] BranchAddr
	);

	// reg [`WIDTH - 3:0] PC;	
	wire [`WIDTH - 1:0] Ins_in;
	//reg [`WIDTH - 1:0] Ins_reg;
	IMem_mod IMem(.rst_n(rst_n), .data(Ins_in), .add(PC));

	always @(posedge clk or negedge rst_n) begin
		if(~rst_n) begin
			PC = 0;
		end else if(IsStall) begin
			 
		end else if(IsBranch) begin
			PC = BranchAddr;
			IR = Ins_in;
		end else begin
			PC += 4;
			IR = Ins_in;
		end
	end
endmodule