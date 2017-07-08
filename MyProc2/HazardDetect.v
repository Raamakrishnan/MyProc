`ifndef INCLUDE_PARAMS
	`include "params.v"
`endif

`ifndef INCLUDE_ISA
	`include "ISA.v"
`endif

module HazardDetect (
	input [`WIDTH - 1:0] IR_ID,
	input [`WIDTH - 1:0] IR_EXE,
	input [`WIDTH - 1:0] IR_MEM,
	output reg IsStall_IF,
	output reg IsStall_ID
);
	
	wire [4:0] Rs;
	wire [4:0] Rt;
	assign Rs = IR_ID[20:16];
	assign Rt = IR_ID[15:11];

	wire [4:0] Rd1;
	assign Rd1 = IR_EXE[25:21];
	wire [4:0] Rd2;
	assign Rd2 = IR_MEM[25:21];

	wire [5:0] Op1;
	assign Op1 = IR_ID[31:26];
	wire [5:0] Op2;
	assign Op2 = IR_EXE[31:26];
	wire [5:0] Op3;
	assign Op3 = IR_MEM[31:26];

	always @(IR_ID, IR_MEM, IR_EXE) begin
		Stall(0);
		if(shouldCheckID(Op1) && shouldCheckEXE(Op2)) begin
			if(Rs == Rd1 || Rt == Rd1)
				Stall(1);
		end else if(shouldCheckID(Op1) && shouldCheckMEM(Op3)) begin
			if(Rs == Rd2 || Rt == Rd2)
				Stall(1);
		end
	end

	function shouldCheckID(
		input [5:0] Op);
		begin
			case(Op)
				`J, `JAL, `NOP, `HALT: shouldCheckID = 0;
				default: shouldCheckID = 1;
			endcase
		end
	endfunction

	function shouldCheckEXE(
		input [5:0] Op);
		begin
			case(Op)
				`J, `JAL, `NOP, `HALT: shouldCheckEXE = 0;
				default: shouldCheckEXE = 1;
			endcase
		end
	endfunction

	function shouldCheckMEM(
		input [5:0] Op);
		begin
			case(Op)
				`J, `JAL, `NOP, `HALT: shouldCheckMEM = 0;
				default: shouldCheckMEM = 1;
			endcase
		end
	endfunction

	task Stall(input in);
		begin
			IsStall_ID = in;
			IsStall_IF = in;
		end
	endtask

endmodule