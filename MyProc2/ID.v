`ifndef INCLUDE_PARAMS
	`include "params.v"
`endif

`ifndef INCLUDE_ISA
	`include "ISA.v"
`endif

module ID (
	input wire clk,    // Clock
	input wire rst_n,  // Asynchronous reset active low
	
	// pipeline in
	input wire [`WIDTH - 1:0] IR_in,
	input wire [`WIDTH - 3:0] PC_in,
	
	// pipeline out
	output wire [`WIDTH - 1:0] IR_out,
	output wire [`WIDTH - 3:0] PC_out,
	output reg [`WIDTH - 1:0] X,
	output reg [`WIDTH - 1:0] Y,
	
	// Reg in/out
	output reg [`REG_ADDR_LEN - 1:0] Rd1_addr,
	input wire [`WIDTH - 1:0] Rd1_data,
	output reg Rd1_en,
	input wire Rd1_st,
	output reg [`REG_ADDR_LEN - 1:0] Rd2_addr,
	input wire [`WIDTH - 1:0] Rd2_data,
	output reg Rd2_en,
	input wire Rd2_st,

	input wire IsStall,
	input wire IsFlush
);
	
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

	assign IR_out = (IsStall === 1)?IR_out:((IsFlush === 1)?`NOP:IR_in);
	assign PC_out = (IsStall === 1)?PC_out:((IsFlush === 1)?`NOP:PC_in);

	/*always @(negedge clk) begin
		if(IsStall) begin
			
		end else if(IsFlush) begin
			//IR_out = `NOP;
		end else begin
			//IR_out = IR_in;
			//PC_out = PC_in;
		end
	end
*/
	always @(posedge clk) begin
		case(OpCode)
			`R_TYPE: begin
				Rd1_addr <= Rs;
				Rd1_en <= 1;
				Rd2_addr <= Rt;
				Rd2_en <= 1;
			end
			`I_TYPE, `LW, `LH, `LD: begin
				Rd1_addr <= Rs;
				Rd1_en <= 1;
				Y <= sext16(Imm);
			end
			`Branch: begin
				Rd1_addr <= Rd;
				Rd1_en <= 1;
				Y <= sext16(Imm);
			end
			`SD, `SH, `SW: begin
				Rd1_addr <= Rd;
				Rd1_en <= 1;
				Rd2_addr <= Rs;
				Rd2_en <= 1;
			end
			`J_TYPE: begin
				X <= Tgt;
			end
			`NOP:	begin
				
			end
			`HALT:	begin
				
			end
		endcase
	end

	always @(posedge Rd1_st) begin
		X <= Rd1_data;
	end

	always @(posedge Rd2_st) begin
		Y <= Rd2_data;
	end

	function [`WIDTH-1:0] sext16(
	input [15:0] d_in);
	begin
		sext16[`WIDTH-1:0] = {{(`WIDTH-16){d_in[15]}}, d_in};
	end
	endfunction
endmodule