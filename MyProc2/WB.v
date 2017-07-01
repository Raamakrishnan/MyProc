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

`ifdef TRACE_PIPELINE
	// debug output
	output wire [`WIDTH - 1:0] IR_out,
	output wire [`WIDTH - 3:0] PC_out,
`endif

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

`ifdef TRACE_PIPELINE
	assign IR_out = IR_in;
	assign PC_out = PC_in;
`endif

	always @(posedge clk) begin
		Halt = 0;
		w_mode = 0;
		wr_en = 0;
		case(OpCode)
			`LW: begin
				//Addr = Rd;
				//Data = Z_in;
				WriteReg(Rd, Z_in, 0);
			end
			`LH: begin
				//w_mode = 1;
				//Addr = Rd;
				//Data = Z_in;
				WriteReg(Rd, Z_in, 1);
			end
			`LD: begin
				//w_mode = 1;
				//Addr = Rd;
				//Data = Z_in;
				WriteReg(Rd, Z_in, 1);
			end
			`R_TYPE, `I_TYPE: begin
				//Addr = Rd;
				//Data = Z_in;
				WriteReg(Rd, Z_in, 0);
			end
			`JAL, `JALR: begin
				//Addr = 31;
				//Data = Z_in;
				WriteReg(Rd, Z_in, 0);
			end
			`HALT: Halt = 1;
		endcase
	end

	task WriteReg(input [`REG_ADDR_LEN - 1:0] Addr_in,
		input [`WIDTH - 1:0] Data_in,
		input [1:0] w_mode_in);
		begin
			w_mode = w_mode_in;
			Data = Data_in;
			Addr = Addr_in;
			wr_en = 1;
		end
	endtask

endmodule