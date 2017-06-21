`ifndef INCLUDE_PARAMS
	`include "params.v"
`endif

`ifndef INCLUDE_ISA
	`include "ISA.v"
`endif

module ID_mod (
	input wire clk,    // Clock
	input wire rst_n,  // Asynchronous reset active low
	input wire [`WIDTH - 1:0] IR_in,
	input wire [`WIDTH - 3:0] PC_in,
	output reg [`WIDTH - 1:0] IR,
	output reg [`WIDTH - 3:0] PC,
	output reg [`REG_ADDR_LEN - 1:0] Rd_no,
	output reg [`REG_ADDR_LEN - 1:0] Rs_no,
	output reg [`WIDTH - 1:0] Rs_val,
	output reg [`REG_ADDR_LEN - 1:0] Rt_no,
	output reg [`WIDTH - 1:0] Rt_val,
	input wire IsStall,
	input wire IsFlush
);
	
	//reg [`WIDTH - 1:0] IR;
	//reg [`WIDTH - 3:0] PC;

	wire [5:0] OpCode;
	wire [4:0] Rd;
	wire [4:0] Rs;
	wire [4:0] Rt;
	wire [4:0] Shamt;
	wire [15:0] Imm;
	wire [25:0] Tgt;

	assign OpCode = IR_in[31:26];
	assign Rd = IR_in[25:21];
	assign Rs = IR_in[20:16];
	assign Rt = IR_in[15:11];
	assign Shamt = IR_in[10:6];
	assign Imm = IR_in[15:0];
	assign Tgt = IR_in[25:0];

	always @(posedge clk) begin
		if(IsStall) begin
			
		end else if(IsFlush) begin
			IR <= `NOP;
		end else begin
			IR <= IR_in;
			PC <= PC_in;
		end
	end

	always @(posedge clk) begin
		case(OpCode)
			`R_TYPE: begin
				
			end
			`I_TYPE: begin
				
			end
			`J_TYPE: begin
				
			end
			`NOP:	begin
				
			end
			`HALT:	begin
				
			end
		endcase
	end

endmodule