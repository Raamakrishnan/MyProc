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

	// processor output
	output reg Halt,

	// reg
	output reg [`REG_ADDR_LEN - 1:0] Addr,		
	output reg [`WIDTH - 1:0] Data,
	output reg wr_en,
	output reg [1:0] w_mode //w_mode: 0-word, 1-halfword, 2-byte
);

	wire [5:0] OpCode;
	wire [4:0] Rd;

	assign OpCode = IR_in[31:26];
	assign Rd = IR_in[25:21];

	always @(posedge clk) begin
		Halt = 0;
		w_mode = 0;
		wr_en = 0;
		case(OpCode)
			`LW: begin
				Addr = Rd;
				Data = Z_in;
			end
			`LH: begin
				w_mode = 1;
				Addr = Rd;
				Data = Z_in;
			end
			`LD: begin
				w_mode = 1;
				Addr = Rd;
				Data = Z_in;
			end
			`R_TYPE, `I_TYPE: begin
				Addr = Rd;
				Data = Z_in;
			end
			`JAL, `JALR: begin
				Addr = 31;
				Data = Z_in;
			end
			`HALT: Halt = 1;
		endcase
	end

endmodule