`ifndef INCLUDE_PARAMS
	`include "params.v"
`endif

`ifndef INCLUDE_IF_MOD
	`include "IMem.v"
`endif

module IF(
	input wire clk,    	// Clock
	input wire rst_n,
	
	// pipeline output
	output wire [`WIDTH - 3:0] PC, // Program Counter
	output wire [`WIDTH - 1:0] IR, // instruction

	input wire IsStall,
	input wire IsBranch,
	input wire [`WIDTH - 3:0] BranchAddr
	);

	reg [`WIDTH - 3:0] PC_reg;	
	wire [`WIDTH - 1:0] Ins_in;
	//reg [`WIDTH - 1:0] Ins_reg;
	IMem IMem(.rst_n(rst_n), .data(Ins_in), .add(PC));

	assign PC = (IsBranch === 1)? BranchAddr : PC_reg;
	assign IR = (IsBranch === 1)? 32'b0 : Ins_in;

	always @(negedge rst_n) begin
		PC_reg = 0;
		//IR = Ins_in;
	end

	always @(posedge clk) begin
		if(IsStall === 1) begin
			 
		end else if(IsBranch === 1) begin
			PC_reg = BranchAddr;
		//	IR = Ins_in;
		end else begin
			PC_reg = PC_reg + 1;
		//	IR = Ins_in;
		end
	end
endmodule