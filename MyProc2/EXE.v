`ifndef INCLUDE_PARAMS
	`include "params.v"
`endif

`ifndef INCLUDE_ISA
	`include "ISA.v"
`endif

module EXE (
	input wire clk,    // Clock
	
	// pipeline inputs
	input wire [`WIDTH - 1:0] IR_in,
	input wire [`WIDTH - 3:0] PC_in,
	input wire [`WIDTH - 1:0] X,
	input wire [`WIDTH - 1:0] Y,

	// pipeline outputs
	output reg [`WIDTH - 1:0] IR_out,
	output reg [`WIDTH - 3:0] PC_out,
	output reg [`WIDTH - 1:0] Z,
	output reg [`WIDTH - 1:0] Addr,

	input wire IsStall,
	output reg IsBranchTaken,
	output reg [`WIDTH - 3:0] BranchAddr,
	
	//conditions
	output reg FC,	//Carry Flag
	output reg FV,	//Overflow flag
	output reg FZ,	//Zero Flag
	output reg FN	//Negative Flag
);

	wire [5:0] OpCode;
	wire [4:0] Shamt;
	wire [15:0] Imm;
	
	assign OpCode = IR_in[31:26];
	assign Shamt = IR_in[10:6];
	assign Imm = IR_in[15:0];
	//assign Tgt = IR_in[25:0];

	reg [`WIDTH:0] res;

	always @(posedge clk) begin
		if (IsStall) begin
			
		end
		else begin
			IsBranchTaken = 0;
			IR_out = IR_in;
			PC_out = PC_in;
			case(OpCode)
				`ADD, `ADDI: 	begin
					res = X + Y;
					Z = res;
					setc(X, Y, res, 0);
				end
				`SUB:	begin
					res = X - Y;
					Z = res;
					setc(X, Y, res, 1);
				end
				`AND, `ANDI:	begin
					res = X & Y;
					Z = res;
					FZ = ~|res;
				end
				`OR, `ORI:	begin
					res = X | Y;
					Z = res;
					FZ = ~|res;
				end
				`XOR:	begin
					res = X ^ Y;
					Z = res;
					FZ = ~|res;
				end
				`SLL:	begin
					res = X << Shamt;
					Z = res;
					FC = X[`WIDTH - Shamt - 1];
					FZ = ~|res;
				end
				`SRL: begin
					res = X >> Shamt;
					Z = res;
					FC = X[Shamt];
					FZ = ~|res;
				end
				`SRA: begin
					res = X >> 1;
					res = {X[`WIDTH-1], res[15:0]};
					Z = res;
					FC = X[0];
					FZ = ~|res;
				end
				`SLLV: begin
					res = X << Y;
					Z = res;
					FC = X[`WIDTH - Y - 1];
					FZ = ~|res;
				end
				`SRLV: begin
					res = X >> Y;
					Z = res;
					FC = X[Y];
					FZ = ~|res;
				end
				`LUI: begin
					Z = Y << 16;
				end
				
				`LW, `LH, `LD: begin 
					Addr = X + Y;
				end

				`SW, `SH, `SD: begin
					Addr = Y + sext16(Imm);
					Z = X;
				end

				// Branches
				`BEQ: begin
					if(X == 0)
						BranchTaken(PC_in + (Y << 2));
				end
				`BNE: begin
					if(X != 0)
						BranchTaken(PC_in + (Y << 2));
				end
				`BGTZ: begin
					if($signed(X) > 0)
						BranchTaken(PC_in + (Y << 2));
				end
				`BLTZ: begin
					if($signed(X) < 0)
						BranchTaken(PC_in + (Y << 2));
				end
				`BLEZ: begin
					if($signed(X) <= 0)
						BranchTaken(PC_in + (Y << 2));
				end
				`BGEZ: begin
					if($signed(X) >= 0)
						BranchTaken(PC_in + (Y << 2));
				end

				//J Type
				`J:	begin
					BranchTaken(X);
				end
				`JAL: begin
					BranchTaken(X);
					Z = X;
				end
				`JR: begin
					BranchTaken(X + Y);
				end
				`JALR: begin
					Z = X + Y;
					BranchTaken(Z);
				end

				`NOP, `HALT: begin
					
				end
				default: begin
					$display("Unknown OpCode");
				end
			endcase
		end
	end

	task BranchTaken(input [`WIDTH-1:0] addr);
		begin
			IsBranchTaken = 1;
			BranchAddr = addr;
		end
	endtask

	task setc(
		input [`WIDTH-1:0] op1, op2,
		input [`WIDTH:0] res,
		input subt);
		begin
			FC = res[`WIDTH];
			FZ = ~|res;
			FN = res[`WIDTH-1];
			FV = ( res[`WIDTH-1] & op1[`WIDTH-1] & ~(subt ^ op2[`WIDTH-1])) | (~res[`WIDTH-1] & op1[`WIDTH-1] & (subt ^ op2[`WIDTH-1]));
		end
	endtask

	function [`WIDTH-1:0] sext16(
		input [15:0] d_in);
		begin
			sext16[`WIDTH-1:0] = {{(`WIDTH-16){d_in[15]}}, d_in};
		end
	endfunction

endmodule